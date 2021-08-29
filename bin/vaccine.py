# Custom code for hccc report
# Created 2015-03-23
from reports_api import *
from api.routing import getUsernames
from datetime import datetime

class HCCCFilter(ReportFilter):
    def __init__(self):
        pass

    def filter(self, column, r):
        
        return r
        
        
    def postFilter(self, item):
        pass
            
        
        #Data.replacement["billing_date"] = Data.replacement["billing_date_rec"]