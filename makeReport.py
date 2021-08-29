#!/usr/bin/env python
import sys,os
def printException(details):
    print "<hr/>Details:<br/>"
    print "<pre>"+str(details)+"</pre>"
    lineno = sys.exc_info()[2].tb_lineno
    print "<pre>On line %d</pre>"%(lineno)

try:
    from api import redcap
    from reports import REPORTS
    from xslformatter import Formatter
except Exception as e:
    print "Error loading the REDCap API.<br/>"
    printException(e)
    raise

class ReportGenerator:
    def processor(self, elements):
        for s in self.sections:
            elements.set(s,"true")
    @staticmethod
    def fileExpired(fname):
        import time
        if not os.path.isfile(fname):
            return True
        mtime = int(os.stat(fname).st_mtime)
        time_passed = int(time.time())-mtime
        return time_passed >= REPORT_EXPIRE_TIME

    def processXML(self, xmlfile, attribs={}):
        xmldata = ""
        with open(xmlfile, "r") as fin:
            xmldata = fin.read()
        if len(xmldata)>0:
            xmldata = redcap.doCalculationsXML(xmldata) # should overwrite the original file
            for a in attribs:
                xmldata = redcap.insertAttribute(xmldata, a, str(attribs[a]))
        with open(xmlfile, "w") as fout:
            fout.write(xmldata)

    def __init__(self):
        try:
            REPORT_EXPIRE_TIME = 300    # Seconds
            self.report = ""
            self.sections = []
            self.reload = False
            self.get_map = {}
            datafile = ""
            for arg in sys.argv[1:]:
                k, v = arg.split("=")
                if k.lower()=="report":
                    self.report = v
                if k.lower()=="sections":
                    v = v.strip()
                    if len(v) > 0:
                        self.sections = v.split(",")
                if k.lower()=="reload":
                    v = v.strip().lower()
                    if v == "yes":
                        self.reload = True
                if k.lower()=="set":
                    import json
                    v = v.strip()
                    self.get_map = json.loads(v)
                if k.lower()=="datafile":
                    datafile = v.strip()

            if self.report == "": err="No"
            else:               err="Invalid"
            if self.report == "" or self.report not in REPORTS:
                raise Exception("Error: "+err+" report specified.")
                exit()

            REPORTS[self.report]["xml"] = "data/" + REPORTS[self.report]["xml"]
            REPORTS[self.report]["xsl"] = "reports/" + self.report + "/" + REPORTS[self.report]["xsl"]
            if datafile != "": # override
                REPORTS[self.report]["xml"] = "data/" + datafile
            redcap.datadict = "reports/" + self.report + "/metadata.csv"

            # Load DataHandler if present
            if "handler" in REPORTS[self.report]:
                handlerClass = REPORTS[self.report]["handler"]
                if "calculateField" in dir(handlerClass): # TODO: better check
                    redcap.setDataHandler( handlerClass(self.report) )
                else:
                    raise Exception("Invalid data handler specified.")

        except Exception as details:
            print "An error occurred while building this export. Please contact the REDCap administrator."
            printException(details)
            raise

    # Get data (open the saved file if already retrieved)
    def read_and_save_data(self):
            try:
                dataSource = ""
                redcap.xmlout = REPORTS[self.report]["xml"]
                #redcap.datadict = "reports/" + self.report + "/metadata.csv"  # now done earlier when setting data handler
                #redcap.fieldcalc.METADATA = redcap.datadict

                if "token" in REPORTS[self.report]:
                    #if "method" in REPORTS[self.report] and REPORTS[self.report]["method"]!="api":
                    #    raise Exception("API token specified for %s report, but method is not 'api'"%(self.report))
                    dataSource = REPORTS[self.report]["token"]
                    if "method" in REPORTS[self.report] and REPORTS[self.report]["method"]=="direct":
                        redcap.main("meta", dataSource) # Get Metadata
                elif "method" not in REPORTS[self.report] or REPORTS[self.report]["method"]!="direct":
                    raise Exception("API-download specified for %s report, but token not specified!"%(self.report))
                if "method" in REPORTS[self.report] and REPORTS[self.report]["method"]=="direct":
                    #redcapphp.writeData(redcap.xsmlout, pid)
                    #os.system("/bin/env php getData.php?output="+redcap.xmlout);
                    if not os.path.isfile(redcap.xmlout):
                        raise Exception("Direct-download specified for %s report, but data file not found!"%(self.report))
                    # since we did direct download we have to run the processor directly
                    # can also embed attributes from the command-line
                    self.processXML(redcap.xmlout, self.get_map)
                else:
                    if self.reload or fileExpired(redcap.xmlout):
                        if "select" in REPORTS[self.report]:
                            redcap.main("download", dataSource, fields=REPORTS[self.report]["select"])
                        else:
                            redcap.main("download", dataSource)

            except Exception as details:
                print "An error occurred during record export. Please contact the REDCap administrator."
                printException(details)
                raise

    # Formatting
    def getHTML(self):
            try:
                formatter = Formatter()
                formatter.setXML(REPORTS[self.report]["xml"]).setXSL(REPORTS[self.report]["xsl"])
                formatter.preProcess(self.processor)
                html = formatter.format()
            except Exception as details:
                print "An error occurred during formatting. Please contact the REDCap administrator."
                printException(details)
                raise
            return html

    # Appending data-files
    def append_files(self, html):
            if "files" in REPORTS[self.report]:
                for f in REPORTS[self.report]["files"]:
                    if f["appender"]: # don't do anything if no appender exists
                        # download file data
                        try:
                            dataSource = REPORTS[self.report]["token"]
                            redcap.main(option="getfile", token=dataSource, record=f["record"], fields=f["field"])
                            fname = f["record"]+"-"+f["field"]
                            data = ""
                            foundSection = False
                            with open(fname, "r") as htmlf:
                                inBlock = False
                                for line in htmlf:
                                    if line.count("div class=Section1")>0 or line.count("div class=WordSection1")>0:
                                        inBlock = True
                                        foundSection = True
                                    if inBlock:
                                        data += line
                                    if line.count("</div>")>0:
                                        break
                            os.remove(fname)
                            if foundSection == False:
                                data = "<div class=Section1><pre>The contacts file in record %s was not in the recognized format. Please contact the REDCap administrator.</pre></div>" % (f["record"])
                            elif data=="":
                                data = "<div class=Section1><pre>Contacts data in record %s was empty.</pre></div>" % (f["record"])
                        except Exception as e:
                            data = "<div class=Section1><pre>Contacts data not found in record %s, or an error occurred during export.</pre></div>" % (f["record"])
                        try:
                            with open("appender.log","w") as logf:
                                logf.write(f["name"] + ' ' + data + '\n')
                            # validate html, process, call insert
                            if f["validator"] is None or f["validator"](data) == True:
                                if f["processor"]:
                                    func = f["processor"]
                                    data = func(data)
                                func = f["appender"]
                                html = func(f["name"], data, html)
                        except:
                            with open("makeReport.log","a") as logf:
                                logf.write('\n' + f["name"] + ': error appending file\n')
            return html

if __name__ == "__main__":
    makeReport = ReportGenerator()
    makeReport.read_and_save_data()
    html = makeReport.getHTML()
    print makeReport.append_files(html)
    ##os.remove(REPORTS[self.report]["xml"])
