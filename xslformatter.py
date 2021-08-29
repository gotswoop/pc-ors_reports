import lxml.etree as ET

class Formatter(object):
    """Transform an XML file using lxml's ETree. See: http://stackoverflow.com/questions/16698935/how-to-transform-an-xml-file-using-xslt-in-python"""
    def __init__(self):
        #self.concat(FILES.header,FILES.xml,FILES.inp)
        #self.setXSL(FILES.xsl)
        self.input_xslt = None
        self.xslt_transformer = None

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

    def preProcess(self, processor):
        elements = self.input_dom.xpath("/records")[0]
        input_dom = processor(elements)
    def format(self):
        newdom = self.xslt_transformer(self.input_dom)
        return ET.tostring(newdom, pretty_print=True)


