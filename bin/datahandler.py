# Interface for an object that manipulates input XML Data per project requirements.
class DataHandler(object):
    def __init__(self, report=None):
        raise Exception("attempt to instantiate abstract class")

    # Set location of data-dictionary file
    def setMetadata(self, metadata):
        raise Exception("abstract method called")

    # Clear any stored data between items
    def clearRowData():
        raise Exception("abstract method called")

    # Do something before processing.
    def preProcess(self):
        raise Exception("abstract method called")

    # Handle a single field,value pair. Doesn't have to be from XML.
    def calculateField(self, column, value):
        raise Exception("abstract method called")

    # Handle an XML element (item) containing data.
    def processElem(self, item):
        raise Exception("abstract method called")

    # Do something after processing all records
    def postProcess(self):
        raise Exception("abstract method called")

