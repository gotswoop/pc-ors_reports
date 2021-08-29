from DukeContactsProcessor import cleanInput, stripAttributes, stripTable

def insertTable(name, data, into):
    """Insert data into named table, in html 'into'."""
    inTable = False
    outhtml = ""
    for q in into.splitlines():
        line = q
        if q.count('table name="'+name+'"') > 0:
            inTable = True
        if inTable:
           if q.count('</table>') > 0:
                inTable = False
           if q.count("...") > 0:
                line = q.replace("...", data, 1)
        outhtml += line + "\n"
    return outhtml

def processContacts(data):
    data = stripAttributes(cleanInput(data))
    data = stripTable(data)
    data = data.replace('\xa0',' . ').replace('\x90','').replace('\x96','').replace('\x92','').replace('\xc2',' . ')
    # for some reason the cleaner replaces all codes with C2 and A0
    data = data.replace('&#160;',' . ').replace('&#194;',' . ')
    # and lxml.html replaces those with &#194; and &#160;
    return data

class DukeDataHandler():
    def calculateField(self, column, r):
        if r == None:
            r = ""
        if column == "attending":
            Data.surgeon_list = []
            name = getSurgeonName(r)
            if name != "":
                Data.surgeon_list.append(name)
        return r

