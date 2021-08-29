from lxml.html.soupparser import fromstring
from lxml.etree import tostring
import lxml.html.clean as clean
import lxml.html as parser

def removeRoot(html):
    el = parser.fromstring(html)
    return (el.text or '') + ''.join(parser.tostring(child) for child in el)

def stripTable(html):
    html = removeRoot(html) # remove div
    if html.strip()=="":
        return html
    root = parser.fromstring(html)
    if root is not None:
        table = root.find("table")
        if table is not None:
            html = parser.tostring(table)
            return removeRoot(html)
    return html

def cleanInput(html):
    root = fromstring(html)
    return tostring(root, pretty_print=True)


def stripAttributes(html):
    old_safe_attrs = clean.defs.safe_attrs
    clean.defs.safe_attrs = frozenset()
    cleaner = clean.Cleaner(safe_attrs_only=True)
    cleansed = cleaner.clean_html(html)

    clean.defs.safe_attrs = old_safe_attrs
    return cleansed

#with open("contacts1-table.html","r") as f:
#    html = f.read()
#    print stripAttributes(cleanInput(html))


