# Transformer+Filter framework for REDCap custom reports
# Provides a Python code-behind for XSL templated data
# 2015-02-01

import time
import datetime
from math import trunc
from operator import attrgetter
from api.readChoices import getChoices
from lxml import etree

class ReportFilter(object):
    def __init__(self):
        raise Exception("attempted to instantiate abstract class")
    def filter(self, column, value):
        raise Exception("abstract method called")
    def postFilter(self, item):
        raise Exception("abstract method called")
    def updateItemData(self, item, value):
        raise Exception("abstract method called")
    def setTransformer(self, report_transformer):
        self.report = report_transformer

def get_filters(reportName):
    from reports import REPORTS
    if reportName not in REPORTS:
        raise Exception(reportName + " not in list of reports")
    if "filters" not in REPORTS[reportName]:
        return []
    return REPORTS[reportName]["filters"]

# Because 2.6 doesn't have cmp_to_key
# TODO: use these operators to begin with
def cmp_to_key(mycmp):
    'Convert a cmp= function into a key= function'
    class K(object):
        def __init__(self, obj, *args):
            self.obj = obj
        def __lt__(self, other):
            return mycmp(self.obj, other.obj) < 0
        def __gt__(self, other):
            return mycmp(self.obj, other.obj) > 0
        def __eq__(self, other):
            return mycmp(self.obj, other.obj) == 0
        def __le__(self, other):
            return mycmp(self.obj, other.obj) <= 0
        def __ge__(self, other):
            return mycmp(self.obj, other.obj) >= 0
        def __ne__(self, other):
            return mycmp(self.obj, other.obj) != 0
    return K


class Data:
    MAX_SURGERY_FIRST = 25 # ORS
    MAX_SURGERY_FOLLOW = 5
    METADATA = None

    # Duke
    diagnosisPriority = (
    "altered mental status",
    "sah",
    "sdh",
    "edh",
    "dai",
    "cerebral contusion",
    "concussion",
    "increased icp",
    "skull fracture",
    "scalp laceration",
    "bcvi",
    "suicide risk",
    "acute trauma pain",
    "facial laceration",
    "face fracture",
    "mandible fracture",
    "tooth avulsion",
    "lip laceration",
    "globe rupture",
    "corneal abrasion",
    "acute respiratory failure",
    "hypoxia",
    "rib fracture(s)",
    "sternal fracture",
    "pneumothorax",
    "hemothorax",
    "pneumohemothorax",
    "pleural effusion",
    "pulmonary contusion",
    "inhalation injury",
    "pulmonary embolism",
    "pneumonia",
    "aortic injury",
    "peripheral vascular injury",
    "mediastinal hematoma",
    "hypotension",
    "hemorrhagic shock",
    "hypovolemic shock",
    "septic shock",
    "neurogenic shock",
    "shock nos",
    "sinus tachycardia",
    "bradycardia",
    "atrial fibrillation",
    "dvt",
    "liver injury",
    "spleen injury",
    "renal injury",
    "adrenal injury",
    "stomach injury",
    "small bowel injury",
    "colon injury",
    "rectal injury",
    "hemoperitoneum without solid organ injury",
    "bladder injury",
    "retroperitoneal hematoma",
    "abdominal wall ecchymosis",
    "enteric fistula",
    "ileus",
    "malnutrition",
    "inability to swallow",
    "urethral injury",
    "bladder injury",
    "hematuria",
    "uti",
    "hyponatremia",
    "urinary retention",
    "acute kidney injury",
    "acute renal failure",
    "acute posthemorrhagic anemia",
    "fever",
    "leukocytosis",
    "sirs",
    "sepsis",
    "uti",
    "pneumonia",
    "hypercoagulable",
    "dvt",
    "pulmonary embolism",
    "pelvic fracture",
    "acetabular fracture",
    "femur fracture",
    "tibia/fibula fracture",
    "ankle fracture",
    "scapula fracture",
    "clavicle fracture",
    "humerus fracture",
    "radius/ulna fracture",
    "complex forearm/hand injury",
    "hand fracture",
    "joint dislocation",
    "c-spine fracture",
    "t-spine fracture",
    "l-spine fracture",
    "sacral fracture",
    "spinal cord injury",
    "spinal ligament injury",
    "neurogenic shock",
    "sacral decubitus ulcer",
    "burn",
    "laceration",
    "abrasion",
    "open wound",
    "cellulitis"
    )


    #date = ""
    #dob = ""
    #surgery_date = ""
    #patient_status = 0
    #data_list = {}
    #data_list2 = []
    #data_list3 = []
    #data_lists = {}
    #replacement = {}


    #equations = {
    #"deficit_extension": [Equations.deficit_extension, "l_knee_rom_"],
    #}

    redcap_friendly_events = {
        "_field":   "redcap_event_name", # special: identifies column with event name
        "baseline_arm_1": "Baseline",
        "initial_import_arm_1": "Imported",
        "fu_visit_01_arm_1": "Visit 1",
        "fu_visit_02_arm_1": "Visit 2",
        "fu_visit_03_arm_1": "Visit 3",
        "fu_visit_04_arm_1": "Visit 4",
        "fu_visit_05_arm_1": "Visit 5",
        "fu_visit_06_arm_1": "Visit 6",
        "fu_visit_07_arm_1": "Visit 7",
        "fu_visit_08_arm_1": "Visit 8",
        "fu_visit_09_arm_1": "Visit 7",
        "fu_visit_10_arm_1": "Visit 10",
        "fu_visit_11_arm_1": "Visit 11",
        "fu_visit_12_arm_1": "Visit 12",
        "fu_visit_13_arm_1": "Visit 13",
        "fu_visit_14_arm_1": "Visit 14",
        "fu_visit_15_arm_1": "Visit 15",
        "fu_visit_16_arm_1": "Visit 16",
        "fu_visit_17_arm_1": "Visit 17",
        "fu_visit_18_arm_1": "Visit 18",
        "fu_visit_19_arm_1": "Visit 19",
        "fu_visit_20_arm_1": "Visit 20" }

    class Surgery:
        key = attrgetter('pod')
        def __init__(self):
            self.name = None
            self.pod = None # uses int for fast comparison sort
            self.key = attrgetter('pod')

    def __init__(self):
        Data.date = ""
        Data.dob = ""
        Data.surgery_date = ""
        Data.patient_status = 0
        Data.data_list = {}
        Data.data_list2 = []
        Data.data_list3 = []
        Data.data_lists = {}
        Data.replacement = {}
        Data.surgery_fields = []

    @staticmethod
    def addToList(listName, item):
        """Add item data to a named data list for later processing."""
        if listName not in Data.data_lists:
            Data.data_lists[listName] = []
        Data.data_lists[listName].append(item)

    @staticmethod
    def getSurgery(inRecord):
        if inRecord not in Data.data_list:
            raise Exception("Record " + inRecord + " is not in the surgery list. Has the list been initialized?")

        last = None
        l = len(Data.data_list[inRecord])
        if l == 0:
            Data.data_list[inRecord].append(Data.Surgery()) # init new
            l = 1
        last = Data.data_list[inRecord][l-1]
        if last.pod != None and last.name != None:
            Data.data_list[inRecord].append(Data.Surgery()) # init new
            l += 1
        last = Data.data_list[inRecord][l-1]

        return last

    @staticmethod
    def getSurgeryNum(name):
        num = name[-2:]
        if not num.isdigit(): num = num[1:]
        if name.startswith("sub_"): # 26-31
            num = str(int(num)+25)
        return num

    @staticmethod
    def diagnosisCmp(item, other):
        item = item.diagName
        other = other.diagName
        try:
            x = Data.diagnosisPriority.index(item.lower())
        except ValueError:
            x = len(Data.diagnosisPriority) 
        try:
            y = Data.diagnosisPriority.index(other.lower())
        except ValueError:
            y = len(Data.diagnosisPriority)
        return x - y

def calcHospitalDays(date):
    """rounddown( datediff("today",[admission_date],"d") )), 0)"""
    admissionTime = time.strptime(date, "%Y-%m-%d")
    admissionDate = datetime.datetime(admissionTime.tm_year, admissionTime.tm_mon, admissionTime.tm_mday)
    nowTime = time.localtime()
    nowDate = datetime.datetime(nowTime.tm_year, nowTime.tm_mon, nowTime.tm_mday)
    diff = nowDate - admissionDate
    s = str(trunc(diff.days))
    if s == "": s = 0
    return s

def calcPatientAge(dob):
    """rounddown( datediff("today",[dob],"y") )"""
    dobTime = time.strptime(dob, "%Y-%m-%d")
    dobDate = datetime.datetime(dobTime.tm_year, dobTime.tm_mon, dobTime.tm_mday)
    nowTime = time.localtime()
    nowDate = datetime.datetime(nowTime.tm_year, nowTime.tm_mon, nowTime.tm_mday)
    diff = nowDate - dobDate
    s = str(trunc(diff.days/365.25))
    if s == "": s == "0"
    return s


def calcSurgeryDays(date):
    """rounddown(datediff([surgery_date_1],"today","d", "ymd", true))"""
    surgeryTime = time.strptime(date, "%Y-%m-%d")
    surgeryDate = datetime.datetime(surgeryTime.tm_year, surgeryTime.tm_mon, surgeryTime.tm_mday)
    nowTime = time.localtime()
    nowDate = datetime.datetime(nowTime.tm_year, nowTime.tm_mon, nowTime.tm_mday)
    diff = nowDate - surgeryDate  # i don't understand why this has to be the opposite of the formula
    #return str(trunc(diff.days))
    s = str(trunc(diff.days))
    if s == "": s = 0
    return s

def getSurgeonName(index):
    surgeons = getChoices(Data.METADATA,"surgeons")
    name = ""
    if index!="0": # OTHER
        try:
    	    name = surgeons[index]
        except:
        	name = ""
    return name

def getOtherChoice(elem, base="", otherSuffix="_other"):
    c = elem.tag
    if base=="": base = c
    suffix = c[c.find(base)+len(base)+1:]
    otherTag = c.replace(base,base+otherSuffix)

    otherElem = elem.find("../"+otherTag)
    if otherElem is not None and otherElem.text is not None:
        return otherElem.text
    return "Other (no text)"

def getChoice(c, index):
    if c.count("___")>0:
        surgeons = getChoices(Data.METADATA,c[:c.find("___")])
        if index == "1":
            index = c[c.find("___")+3:] # get checkbox tag; this doesn't account for the other checkboxes
            return surgeons[index]
        return ""

    surgeons = getChoices(Data.METADATA,c)
    name = ""
        
    if index!="0": # OTHER in surgeons list
        try:
            name = surgeons[index]
        except:
            name = ""
    #print "getChoice(%s,%s)=%s<br/>"%(c,index,name)
    return name


def fieldname_in(field, intuple, exact=True):
    for s in intuple:
        if field.startswith(s):
            if exact == False or s == field or (len(field)>len(s) and field[len(s)].isalpha()==False):
                return True
    return False

def getfields(report):
    fields = "study_id"
    try:
        with open("reports/"+report+"/fields.csv") as ff:
            fields = ff.read()
    except:
        return ""
    return fields


