import reporttransformer
import datetime
from math import trunc
from operator import attrgetter
from lxml import etree
from reporttransformer import ReportTransformer
from reports_api import *

DEBUG = False

# Manipulates data in Data per project requirements.
class DukeTransformer(ReportTransformer):
    tableValidator = None

    def __init__(self, report=None):
        Data.data_list = {} # This only needs initialization for Duke Trauma report. It should NOT be initialized every row/record.
                            # (Other reports initialize it at the beginning of each record.)
        self.dukeContactsInsert = None

        super(DukeTransformer, self).__init__(report)

    def clearRowData(self):
        Data()
        Data.data_list = {}
        super(DukeTransformer, self).clearRowData()

    def preProcess(self):
        # Duplicate (don't call) super, since Duke doesn't init Data on each row
        self.inRecord = "" # need to store record num since a record can span multiple lines (elements)
        self.elementsOut = {} # row lines (elements) to write back to, by record num
        self.loadSettings()

    def updateItemData(self, item, r):
            if r.tag == "admit_date" or r.tag == "transfer_date":
                try:
                    admitTime = time.strptime(r.text, "%Y-%m-%d %H:%M")
                    admitDate = datetime.datetime(admitTime.tm_year, admitTime.tm_mon, admitTime.tm_mday)
                    nowTime = time.localtime()
                    nowDate = datetime.datetime(nowTime.tm_year, nowTime.tm_mon, nowTime.tm_mday)
                    diff = nowDate - admitDate
                    days = str(trunc(diff.days))
                except:
                    days = str(0)
                self.setAttrib(r, "days", days)

            if r.tag.startswith("diagnosis") and r.tag.count("_other")==0 and r.tag.count("_resolved")==0:
                name = getChoice(r.tag, r.text)
                if name.startswith("Other"):
                    name = getOtherChoice(r,base="diagnosis") # reads DIAGNOSIS_OTHER*
                    Data.addToList("diagnosis", "diag:"+name)
                else:
                    Data.addToList("diagnosis", "category:"+name)

            if fieldname_in(r.tag, ("diagnosis_resolved", "neuro", "nuero", "face", "chest", "abdomen", "cardio", "gu", "heme", "musculo", "spine", "skin")) and r.tag.count("_other")==0: # add the diagnosis and resolved flags, parse out later
                if r.text != "" and r.text.lower() != "other":
                    name = getChoice(r.tag, r.text)
                    if name == "Other": name = ""  # Add a blank diagnoses, this will later be replaced with Info text
                    if not r.tag.startswith("diagnosis_resolved"):
                        Data.addToList("diagnosis", "diag:"+name)
                    else:
                        Data.addToList("diagnosis", "resolved:"+r.text) # add resolved flag
            if r.tag.startswith("treatment"):   # add the treatment and dates, parse out later
                prefix = "item:"
                if r.tag.count("date")>0:   prefix = "date:"
                Data.addToList("treatment", prefix+r.text)
            if r.tag.startswith("link_tx_to_dx") and r.text != "" and r.text != "100": # 100 = multiple dx, handled next case
                Data.addToList("treatment", "link:"+r.text)
            if r.tag.startswith("mult_tx_to_dx") and r.text == "1": # multiple dx
                tag = "mult_tx_to_dx"
                checked = r.tag[r.tag.find("___")+3:]
                Data.addToList("treatment", "link:"+checked)

            if r.tag.startswith("followup") and r.text != "":
                Data.addToList("followup", "[ ] F/u " + r.text)
            if r.tag == "allergies":
                name = getChoice(r.tag, r.text)
                if name != "":
                    Data.replacement[r.tag] = name
            if r.tag.startswith("consults_list"):
                tag = "consults_list"
                if r.tag == "consults_list_other":
                    name = r.text
                else:
                    name = getChoice(r.tag, r.text)
                if name != "" and name != "Other":
                    if tag not in Data.replacement:
                        Data.replacement[tag] = name
                    else:
                        Data.replacement[tag] += ", "+name

            if r.tag == "allergies_other" and r.text != "":
                Data.replacement["allergies"] = r.text

            if fieldname_in(r.tag, ("stage", "type_level", "location", "layers", "grade", "degree", "diagnosis_other")):
                if r.text != "" and not r.text.startswith("Other"):
                    Data.addToList("diagnosis", "info:"+r.text)


