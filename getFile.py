#!/usr/bin/env python
from api import redcap
import lxml.etree as ET
import sys, os


from reports import REPORTS

class FILES: # TODO: delete
    xml = "redcap-out.xml"
    xsl = "report.xsl"
    header = "xmlheader.xml" # currently only used by concat()
    inp = header+"-"+xml+".tmp"

class Formatter(object):
    """See: http://stackoverflow.com/questions/16698935/how-to-transform-an-xml-file-using-xslt-in-python"""
    def __init__(self):
        #self.concat(FILES.header,FILES.xml,FILES.inp)
        self.setXSL(FILES.xsl)

    def setXML(self, xml):
        self.input_dom = ET.parse(xml)
        return self

    def setXSL(self, xsl):
        self.input_xslt = ET.parse(xsl)
        self.xslt_transformer = ET.XSLT(self.input_xslt)
        return self

    def readHeader(self, filen):
        topfile = open(filen, "r")
        return topfile

    def readXML(self, filen):
        xmlfile = open(filen, "r")
        return xmlfile

    def concat(self, file1, file2, file3):
        try:
            in_file1 = readHeader(file1)
            in_file2 = readXML(file2)
            out_file = open(file3, "w")
            out_file.write(in_file1.read())
            out_file.write(in_file2.read())
        except:
            print "Unknown error occurred in file concatenation. (Check permissions)<br>"
        finally:
            in_file1.close()
            in_file2.close()
            out_file.close()

    def format(self):
        newdom = self.xslt_transformer(self.input_dom)
        return ET.tostring(newdom, pretty_print=True)

report = ""
for arg in sys.argv[1:]:
    k, v = arg.split("=")
    if k.lower()=="report":
        report = v

if report == "": err="No"
else:               err="Invalid"
if report == "" or report not in REPORTS:
    print "Error: "+err+" report specified."
    exit()

try:
    dataSource = REPORTS[report]["token"]
    files = REPORTS[report]["files"]
    for f in files:
        redcap.main(option="getfile", token=dataSource, record=f["record"], fields=f["field"])
        fname = f["record"]+"-"+f["field"]
        html = ""
        with open(fname, "r") as htmlf:
            inBlock = False
            for line in htmlf:
                if line.count("div class=Section1")>0:
                    inBlock = True
                if inBlock:
                    html += line
                if line.count("</div>")>0:
                    break
        #os.remove(fname)
        with open(fname+"-table", "w") as outf:
            outf.write(html)


except:
    print "An error occurred during record export. Please contact the REDCap administrator."
    raise

