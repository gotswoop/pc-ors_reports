#!/usr/bin/env python

import sys
import urllib
import httplib
import ssl
#try:
#    import fieldcalc
#    from fieldcalc import Data
#except:
#    raise
from lxml import etree
import time

# example usage: ./redcap.py option=? token=<token> content=record format=xml

# Set the url and path to the API
host = 'redcap.med.usc.edu'
path = '/api/'
output = 'redcap-out.csv'
xmlout = 'redcap-out.xml'
inputf = ''
datadict = 'redcap-metadata.csv'
BLOCKSIZE = 40000
blocksize = BLOCKSIZE
READ_RECORD_COUNT = 800
c = None
calculateFields = True
dataHnd = None     # field/data handler
DEBUG = False
DEBUG_REC='36113321'
#fieldcalc.DEBUG = DEBUG
#fieldcalc.DEBUG_REC = DEBUG_REC
#fieldcalc.METADATA = datadict
READ_IN_BLOCKS = False 

def setDataHandler(handler):
    global dataHnd
    dataHnd = handler
    dataHnd.DEBUG = DEBUG
    dataHnd.DEBUG_REC = DEBUG_REC
    dataHnd.setMetadata(datadict)

def doRequest(params):
    global c
    c.request('POST', path, urllib.urlencode(params), {'Content-Type': 'application/x-www-form-urlencoded'})
    return c.getresponse()

def fileexport(params,record, field, event=""):
    params["content"]="file"
    params["action"]="export"
    params["record"]=record
    params["field"]=field
    if event!="": params["event"]=event
    return doRequest(params)

def fileimport(params, record, field, data, event=""):
    params["content"]="file"
    params["action"]="import"
    params["record"]=record
    params["field"]=field
    params["file"]=data
    if event!="": params["event"]=event
    return doRequest(params)


def csvexport(params):
    params["format"]="csv"
    params["content"]="record"
    return doRequest(params)

def xmlexportold(params):
    params["format"]="xml"
    params["content"]="record"
    return doRequest(params)


def xmlexport(params):
    params["format"]="csv"
    params["content"]="record"
    ofields = ""
    if "fields" in params:
        ofields = params["fields"]

    print "Block Read. params:",params

    res = doRequest(params)
    if res.status != 200:
        return res
    recordData = res.read()
    recordData = recordData.split("\n")[1:]
    for r in range(0,len(recordData)):
        recordData[r] = recordData[r].strip('"')
    firstBlock = True
    while len(recordData) > 0:
        thisBlock = []
        while len(recordData) > 0 and len(thisBlock) < READ_RECORD_COUNT:
            if recordData[0] == '':
                recordData.pop(0)
                continue
            thisBlock.append(recordData.pop(0))
        getRecords = ",".join(thisBlock)
        params["records"] = getRecords
        with open("makeReport.log","a") as logf:
            logf.write("\nRecords in:" + getRecords + "\n")
        if len(thisBlock) == 0:
            break
        params["format"] = "xml"
        params["fields"] = ofields
        res = doRequest(params)
        if res.status != 200:
            break
        if firstBlock:
            mode = "w"
        else:
            mode = "a"
        with open("makeReport.log","a") as logf:
            logf.write("Read data\n")
        data = res.read()
        if res.status != 200:
            break
        data = doCalculationsXML(data)

        with open("makeReport.log","a") as logf:
            logf.write("Write block\n")
        with open(xmlout, mode) as f:
            datalines = data.split('\n')
            datalines = datalines[:-1] # strip </records>
            if not firstBlock:
                datalines = datalines[1:]  # strip <records...>
            for line in datalines:
                f.write(line+"\n")
        firstBlock = False
    with open(xmlout, "a") as f:
        f.write("</records>")
    return res

def csvimport(params,data):
    global c
    params["format"]="csv"
    params["content"]="record"
    params["type"]="flat"
    params["data"]=data
    params["returnContent"]="count"
    c.request('POST', path, urllib.urlencode(params), {'Content-Type': 'application/x-www-form-urlencoded'})
    return c.getresponse()

def csvdatadictionary(params):
    global c
    params["format"]="csv"
    params["content"]="metadata"
    c.request('POST', path, urllib.urlencode(params), {'Content-Type': 'application/x-www-form-urlencoded'})
    return c.getresponse()

def doAuth(params):
	params["format"]="json"
	r = doRequest(params)
	return r

def getConnection(host):
    global c
    c = httplib.HTTPSConnection(host, timeout=5, context=ssl._create_unverified_context())
    return c

class RegistryID:
    match = "registry_id"
    def replace(self):
        pass

"""
<records>
    <item>
        ...
    </item>
<records>"""
def doCalculationsXML(block):
    #BLOCKSIZE=2000
    #print "------ BLOCK --------------------"
    global calculateFields
    if calculateFields == False:
        return block

    doc = etree.fromstring(block)
    elements = doc.xpath("/records")[0]
    if dataHnd:
        dataHnd.preProcess()
        # TODO: move to report filters
        elements.set("last_update",dataHnd.last_updated)
        # must check every record (iterating match tags would be faster)
        # TODO: filter out certain records by field criteria i.e. spine_service___2==1
        # count items, and divide up into blocks if necessary
        #n = len(elements.findall("item"))
        #print n,"items"
        for item in elements.findall("item"):
            dataHnd.clearRowData() # TODO: fix: repeats DataHandler.Data() initializaton
            dataHnd.processElem(item)
    #    for r in item:
    #        print r
    #        r.text = calculateField(r.tag, r.text)
                #r.text = "<![CDATA["+r.text+"]]>" # etree strips out "cdata", but not really necessary
        dataHnd.postProcess()
    #else:
    #    raise Exception("No data handler specified for report.")

    #print "------ END BLOCK ----------------"
    return etree.tostring(doc, encoding="UTF-8")    # encoding string not written

def insertAttribute(block, attrib, value, path="/records"):
    doc = etree.fromstring(block)
    elements = doc.xpath(path)[0]
    elements.set(attrib,value)
    return etree.tostring(doc, encoding="UTF-8")    # encoding string not written


def calculateField(column, r):
    if r == None:
        r = ""
    if dataHnd:
        return dataHnd.calculateField(column, r)
    return r

def line2tuple(line): return line.split(",")
def tuple2line(tup): return ",".join(tup)
def doCalculations(block):
    global calculateFields
    if calculateFields == False:
        return block

    lines = block.split("\n")
    output = ""
    header = ""
    columns = {}
    for line in lines:
        print line
        if header == "":
            header = line
            headers = line2tuple(header)
            output += line + "\n"
            continue
        row = line2tuple(line)
        outrow = []
        fieldcalc.clearRowData()
        i = 0
        for r in row:
            r = calculateField(headers[i], r)
            outrow.append(r)
            i+=1
        output += tuple2line(outrow) + "\n"
    return output

def doDownload(params):
    mode = "XML".upper()
    #if "mode" in params:
    #    mode = params["mode"].upper()
    if mode == "XML":
        try:
            rx = xmlexportold(params)
        except:
            raise Exception("\nInner Error 1a: API read error")

        # TODO: Clean this up. This is done in xmlexport now.
        try:
            xmlfile = open(xmlout,'w')
        except:
            raise Exception("\nInner Error 1b: File access error")

        if rx.status == 200:
            xmlfile.write(doCalculationsXML(rx.read()))
        else:
            print rx.status, rx.reason, rx.read()
            raise Exception(str(rx.status) + " " + rx.reason + " " + rx.read())

        xmlfile.close()
    elif mode=="CSV":
        r = csvexport(params)

        csvfile = open(output,'w')
        if r.status == 200:
            csvfile.write(r.read())
        else:
            print r.status, r.reason, r.read()
            raise Exception(str(rx.status) + " " + rx.reason + " " + rx.read())

        csvfile.close()
    else:
        raise Exception("REDCap: Unknown output mode %s"%(mode))

def doBlockDownload(params):
    # only supports XML
    rx = xmlexport(params)


def main(option="",token="",**kwargs):
    global c,dataHnd
    c = getConnection(host)
    params = {}
    #for arg in sys.argv[1:]:
    #   k, v = arg.split('=')
    #   params[k] = v

    params["token"]=token
    params["returnFormat"]="json"
    params["exportSurveyFields"]="false"
    params["exportDataAccessGroups"]="false"
    try:
        option = params["option"]
    except:
        pass

    for k in kwargs:
        params[k] = kwargs[k]

    if DEBUG:
        print "Run export. option="+option

    if option == "meta":
        with open(datadict,'w') as f:
            r = csvdatadictionary(params)
            f.write(r.read())
    if option == "auth":
    	p = {}
    	p["authkey"] = params["authkey"]
    	p["format"] = "xml"
    	r = doAuth(p)
    	if r.status != 200:
    		 raise Exception("\nAuth Error: API read error")
    	return r.read()
    if option == "download":
        if READ_IN_BLOCKS:
            doBlockDownload(params)
        else:
            doDownload(params)

    if option == "upload":
        header = None
        chunks = [""]
        chunk = 0
        with open(inputf,'r') as f2:
            for line in f2:
                if header == None: header = line
                else:
                    d = line
                    if len(chunks[chunk]+line) <= BLOCKSIZE:
                        chunks[chunk] += line
                    else:
                        chunks.append("")
                        chunk += 1
                        chunks[chunk] = ""
            for ci in chunks:
                r2 = csvimport(params,header+ci)
                print r2.status, r2.reason, r2.read()
                if r2.status != 200:
                    break
    if option == "getfile":
        if "fields" not in params or params["fields"] == "" or "record" not in params or params["record"] == "":
            raise Exception("\tFile download error 1")

        for f in params["fields"].split(","):
            r3 = fileexport(params, params["record"], f)
            if r3.status != 200:
                raise Exception("\tFile download error 3: " + r3.reason)
            try:
                with open(params["record"]+"-"+f, "w") as outf:
                    outf.write(str(r3.status) + r3.reason + '\n')
                    outf.write(r3.read())
            except:
                raise Exception("\tFile download error 2")

    c.close()

if __name__ == '__main__':
    main("download")

