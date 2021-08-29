# Transformer+Filter framework for REDCap custom reports
# Provides a Python code-behind for XSL templated data
# 2015-02-01
from datahandler import DataHandler
import time
import datetime
from math import trunc
from operator import attrgetter
from lxml import etree
from reports_api import Data, getChoices, get_filters

DEBUG = False

# Transformer for custom reports. Implementation of DataHandler.
# Report generator references this transformer, which in turn consumes filter(s).
class ReportTransformer(DataHandler):
    tableValidator = None
    """
    match = [ "billing_ins","other_ins","other_ulcers", "dig_tip_ulc", "dig_pits", "telangiect","ana","ana_titer","ana_pattern","anti_centromere","anti_rna_polymeras_iii","anti_ro_ss_a","anti_la_ss_b","anti_sm","anti_rnp","anti_mitochondrial_ab","anticardiolipin_igg","anticardiolipin_igm","anticardiolipin_iga","rheumatoid_factor","ccp","topo_aka_scl_70","dsdna",
    Data.redcap_friendly_events["_field"],
    "routing",
    "routing2",
    "routing3",
    "routing4",
    "routing5",
    "routing6",
    "routing7",
    "routing8",
    "routing9",
    "routing10",
    "routing_users",
    "routing2_users",
    "routing3_users",
    "routing4_users",
    "routing5_users",
    "routing6_users",
    "routing7_users",
    "routing8_users",
    "routing9_users",
    "routing10_users",
    "billing_surgeon",
    "billing_consult"
    ]
    partial_match = [ "billing_date_rec" ]
    """

    def __init__(self, report=None):
        self.contactsReader = None
        self.tableValidator = None
        #self.filter_functions = {   # TODO: Transitional.
        #    "spine":[self.filter_ors, self.filter_spine],
        #    "orsbilling":[self.filter_orsbilling],
        #    "cofaks":[self.filter_cofaks],
        #    "ors":[self.filter_ors],
        #    "duke":[self.filter_duke],
        #    "sclero":[self.filter_sclero]
        #}
        self.filters = []
        self.current_report = report
        if report is not None:
            self.set_filters(get_filters(report))
        self.match = []
        self.partial_match = []
        self.loadOutputFields()
        self.last_updated = "" 

        self.preProcess()

    def setMetadata(self, metadata):
        Data.METADATA = metadata

    def set_filters(self, filterList):
        """Initialize filters with passed list of classes."""
        for fc in filterList:
            f = fc()
            f.setTransformer(self)
            self.filters.append(f)

    def equation(self, eq):
        pass

    def loadOutputFields(self):
        """Only match fields in fields.csv. Get the list of fields to match."""
        if self.current_report is None:
            raise Exception("Tried to load data transformer, but report not set.")
        try:
            with open("reports/"+self.current_report+"/fields.out.csv","r") as ff:
                self.match = ff.read().split(",")
        except:
            try:
                with open("reports/"+self.current_report+"/fields.csv","r") as ff:
                    self.match = ff.read().split(",")
            except:
                self.match = [] # match all fields

    def getTags(self):
        return self.match

    # Add field by name (for column) under parent.
    def insertField(self, parent, column, data, replace_current=False):
        """Add field by name (for column) under parent. Replace existing if replace_current is true."""
        data = str(data)
        if replace_current:
            e = parent.find(column)
        if not replace_current or e == None:
            e = etree.SubElement(parent, column)
            #parent.append(column)
            #e = parent.find(column)
            if e == None:
                raise Exception("Unknown error inserting element '%s'=%s"%(column,data))
        e.text = data

    def setAttrib(self, elem, attrib, data):
        """Add/modify attribute named attrib on elem."""
        elem.set(attrib, data)

    def preProcess(self):
        Data()  # added here since this won't be initialized elsewhere if no elements exist
        self.inRecord = "" # need to store record num since a record can span multiple lines (elements)
        self.elementsOut = {} # row lines (elements) to write back to, by record num
        self.loadSettings()

    def loadSettings(self):
        """Load report specific settings."""
        # TODO: move to report filters
        if self.current_report != "":
            fmt = "%Y-%m-%d"
            with open("reports/"+self.current_report+"/updateformat.txt") as update_f:
                fmt = update_f.read().strip()
            self.last_updated = time.strftime(fmt,time.localtime())

    def clearRowData(self):
        Data.date = ""
        Data.dob = ""
        Data.surgery_date = ""
        Data.patient_status = 0
        Data.data_list2 = [] ###
        Data.data_list3 = [] ###
        Data.data_lists = {}
        Data.replacement = {}

    def calculateField(self, column, r):
        if r is None:
            r = ""
        #if column in transform_functions:
        #    r = transform_functions[column](r)
        #else:
        #   fp = find_transform_function(column)
        #   r = fp(r)
        # class Transformations:"
        #   wildcards = {
        #       "surgery_date_*": Transformations.surgery_date,
        #       "pod_*": Transformations.pod
        #   }
        #   def admission_date(r):
        #   def dob(r):
        #   def age(r):
        #   def surgery_date(r):
        #   def pod(r):

        #for f in self.filter_functions[self.current_report]:
        #    r = f(column, r)

        # Apply any filters to this field. (passing the result to the next filter)
        for f in self.filters:
            r = f.filter(column, r)
        return r

    def text_rounded(self, num, places=0):
        """Return a string representaton of an integer (num) rounded to places."""
        result = str(round(num,places))
        if places==0 and "." in result:
            result = result.split(".")[0]
        return result

    def data_exists(self, *args):
        """Return true if all of the passed args have been set by the transformer."""
        for a in args:
            if a not in Data.replacement:
                return False
        return True

    def checkEquation(self, result_field, *args):
        kwargs = {}
        for a in args:
            if a not in Data.replacement:
                return
            kwargs[a] = Data.replacement[a]
        if result_field in Data.replacement:
            return
        if result_field in Equations.defaults:
            Data.replacement[result_field] = Equations.defaults[result_field]
        Data.replacement[result_field] = Equations.do_equation(result_field)(kwargs)
#    @staticmethod
#    def do_equation(result_field, **kwargs):
#        a = float( kwargs["r_knee_flex"] )
#        b = float( kwargs["r_knee_ext"] )
#        if b != 0:
#            c = (a/b) * 100
#        return str( round(c,2) )

    def insert_data(self, columns, def_value):
        """Set the default value of a set of fields (columns). Overridden by any transformed replacements."""
        for column in columns:
            if column not in Data.replacement:
                Data.replacement[column] = def_value

    def matchPartial(self, tag):
        """Return true if the passed tag starts with a string in the accepted fields list. (TODO Replace with regex)"""
        if tag.count("___")>0: # checkbox split into multiple fields
            tagnm,tagopt = tag.split("___")
            if tagnm in self.match:
                self.match.append(tag) # add to match list for faster lookup in next record
                return True
        for m in self.partial_match:
            if tag.startswith(m):
                self.match.append(tag) # add to match list for faster lookup in next record
                return True
        return False

    # Handle an XML element (item) containing data.
    def processElem(self, item):
        for r in [r for r in item if r.tag in self.match or self.matchPartial(r.tag) or len(self.match)==0]:
            if r is None:
                raise Exception("Element is empty. (sub-element == None)")

            r.text = self.calculateField(r.tag, r.text)
            self.updateItemData(item, r)

            if DEBUG and self.inRecord==DEBUG_REC:
                print dbg

        self.postFilter(item)

        # handle data replacements (first add tags that already exist)
        for r in [r for r in item if r.tag in Data.replacement]:
            r.text = Data.replacement[r.tag]
            del Data.replacement[r.tag]
        for tag in Data.replacement: # the remainder; tags that don't exist
            self.insertField(item, tag, Data.replacement[tag], False)

    def updateItemData(self, item, r):
        #if self.current_report in ("spine", "ors"):
        #    self.processElem_ors_temp(item, r)
        #if self.current_report == "duke":
        #    self.processElem_duke_temp(item, r)
        pass

    # Do something immediately after processing all matching tags in a record.
    def postFilter(self, item):
        # TODO: testing equation method; this does nothing
        self.equation("h_q_ratio_l")
        self.equation("h_q_ratio_r")
        self.equation("y_bal_ant_greatest")
        self.equation("knee_ext_quotient")
        self.equation("knee_flex_quotient")
        self.equation("symmetry")
        self.equation("deficit_extension")
        self.equation("heel_height_diff")
        self.equation("rom_uninvolved")

        # Call correct post-calculation filter for report.
        for f in self.filters:
            f.postFilter(item)

    # Do something after processing all records
    def postProcess(self):
        # write final
        if self.inRecord in Data.data_list:
            Data.data_list[self.inRecord].sort(key=Data.Surgery.key, reverse=True)
            if DEBUG and self.inRecord==DEBUG_REC:
                print "New: " + str( [ s.pod for s in Data.data_list[self.inRecord] ] )

