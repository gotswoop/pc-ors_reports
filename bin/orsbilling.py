# Custom code for orsbilling report
# Created 2015-02-01
from reports_api import *
from api.routing import getUsernames

class ORSBillingFilter(ReportFilter):
    colmap2 = {
    "billing_ins":""
    }
    colmap3 = {
    "other_ins":""
    }
    def __init__(self):
        pass

    def filter(self, column, r):
        # used for counting later
        if column.startswith("billing_date_rec"):
            Data.replacement[column] = r

        # TODO: replace this with something that checks if column is a dropdown etc
        # or just check if getChoice() is empty
        if column in ("billing_surgeon","billing_consult","routing") or column.startswith("routing") or column.startswith("billing_surgeon"):
            rchoice = getChoice(column, r)
            if rchoice.strip()!="":
                r = rchoice # keep original value if unknown for some reason
            if column.startswith("routing"):
                uname = r
                if "BILL COMPLETE" in r:
                    unamelst = ["COMPLETE"]
                else:
                    unamelst = getUsernames(r)
                if len(unamelst) == 0 or (len(unamelst)==1 and unamelst[0]==''):
                    Data.replacement[column+"_users"] = ","+r+","
                else:
                    uname = ",".join(unamelst)
                    Data.replacement[column+"_users"] = ","+uname+"," # bounding commas help prevent partial name matches
                                                                        # TODO: fix bug with commas at end of people csv / usernames
            return r

        try: # TODO: not sure what I was going for here...
            if column in ORSBillingFilter.colmap2:
                dummy=ORSBillingFilter.colmap2[column]
                r = getChoice(column, r)
                Data.replacement["billing_ins"] = r
        except KeyError:
            pass
        try:
            if column in ORSBillingFilter.colmap3:
                dummy=ORSBillingFilter.colmap3[column]
                if r.strip()!="":
                    Data.replacement["billing_ins"] = r # copy other_ins to billing_ins
        except KeyError:
            pass
        return r

    def postFilter(self, item):
        #number of invoices
        num_bills = 0
        for billnum in ("","2","3","4","5","6","7","8","9","10"):
            routecol = "routing"+billnum+"_users"
            if self.report.data_exists(routecol):
                while ",," in Data.replacement[routecol]:
                    Data.replacement[routecol] = Data.replacement[routecol].replace(",,","")
                if Data.replacement[routecol] == ",":
                    Data.replacement[routecol] = ""
                if Data.replacement[routecol].strip()=="": continue
                num_bills += 1
                compositecol = "routing_record_users"
                if compositecol not in Data.replacement:
                    Data.replacement[compositecol] = ","
                routes = Data.replacement[routecol][1:] # skip preceding comma
                if routes not in Data.replacement[compositecol]:
                    Data.replacement[compositecol] += routes
                    if "INCOMPLETE" not in Data.replacement[compositecol]:
                        for routen in routes.split(","):    # add an "INCOMPLETE" flag for any other users
                            if routen.upper() != "COMPLETE" and routen != "":
                                Data.replacement[compositecol] += "INCOMPLETE,"
                                break # only need to add it once
        Data.replacement["num_bills"] = str(num_bills)

        #if self.report.data_exists("billing_ins","other_ins"):
        #    if Data.replacement["billing_ins"] == "OTHER" and Data.replacement["other_ins"].strip() != "":
        #        Data.replacement["billing_ins"] = Data.replacement["other_ins"]




