from bin.reporttransformer import ReportTransformer
from bin.duketransformer import DukeTransformer
from bin.orstransformer import ORSTransformer
from bin.reports_api import getfields

# Filters
from bin import cofaks, duke, orsbilling, ors, sclero, spine, hccc

# Duke
from api.credentials import Credentials
from duke import DukeDataHandler
import reportfiles




# Options for reports:
# handler: Handler class that processes XML data before presentation. See api/DataHandler.py for interface.
# filters: Filter classes that process individual XML fields. See api/reports_api.py for interface.
# xml: Location of data output from download to be presented
# xsl: Location of XSL template to create the presentation
# method: (optional) how to get the data; can be api, which is the default, or direct; direct requires login from the browser
# files: Python object that contains a list of files to be downloaded and appended (API only)
# token: token from REDCap used to download the xml (API only)
# select: a list of fields seperated by commas to pull from the database per-record
# REPORTS = {
#   "reportname": {
#      "option":value,
#      ...
#   }, ...
# },
REPORTS = {
    "cofaks": {"handler":ReportTransformer, "filters":[cofaks.COFAKSFilter], "xml":"cofaks-data.xml", "xsl":"cofaks.xsl", "select":getfields("cofaks"), "method":"direct" },
    "orsbilling": {"handler":ReportTransformer, "filters":[orsbilling.ORSBillingFilter], "xml":"orsbilling-data.xml", "xsl":"orsbilling.xsl", "select":getfields("orsbilling"), "method":"direct", "token":Credentials.patientCareORS_t },
    "sclero": {"handler":ReportTransformer, "filters":[sclero.ScleroFilter], "xml":"sclero-data.xml", "xsl":"sclero.xsl", "select":getfields("sclero"), "method":"direct" },
    "duke": {"handler":DukeTransformer, "filters":[duke.DukeFilter], "xml":"duke-data.xml", "xsl":"duke-report.xsl", "select":getfields("duke"), "files":reportfiles.DukeFiles, "method":"direct", "token":Credentials.dukeTrauma_t },
    "duketest": {"handler":DukeTransformer, "filters":[duke.DukeFilter], "xml":"duketest-data.xml", "xsl":"duke-report.xsl", "select":getfields("duke"), "files":reportfiles.DukeFiles, "method":"direct", "token":Credentials.dukeTrauma_t },
    "spine": {"handler":ORSTransformer, "filters":[ors.ORSFilter, spine.SpineFilter], "xml":"spine-data.xml", "xsl":"spine.xsl", "files":"", "select":getfields("spine"), "method":"direct", "token":Credentials.patientCareORS_t },
    "spineprint": {"handler":ORSTransformer, "filters":[ors.ORSFilter, spine.SpineFilter], "xml":"spine-data.xml", "xsl":"spineprint.xsl", "files":"", "select":getfields("spine"), "method":"direct", "token":Credentials.patientCareORS_t },
    "ors": {"handler":ORSTransformer, "filters":[ors.ORSFilter], "xml":"ors-data.xml", "xsl":"full-report.xsl", "method":"direct", "select":getfields("ors"), "token":Credentials.patientCareORS_t },
    "hccc": {"handler":ReportTransformer, "filters":[hccc.HCCCFilter], "xml":"hccc-data.xml", "xsl" : "hccc.xsl", "select":getfields("hccc"), "method":"direct"},
    "vaccine": {"handler":ReportTransformer, "filters":[hccc.HCCCFilter], "xml":"hccc-data.xml", "xsl" : "hccc.xsl", "select":getfields("hccc"), "method":"direct"}
    #"dental": {"handler":ReportTransformer, "filters":[dental.DentalFilter], "xml":"dental-data.xml", "xsl" : "dental.xsl", "select":getfields("dental"), "method":"direct"}
    

    #"": {"handler":ReportTransformer, "xml":"", "xsl":"", "token":Credentials._, "select":"" }
}

