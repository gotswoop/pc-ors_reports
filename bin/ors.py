# Custom code for ors and spine reports
# Created 2015-02-01
from reports_api import *


class ORSFilter(ReportFilter):
    def __init__(self):
        pass

    def filter(self, column, r):
        if column == "admission_date":
            Data.date = r.strip().strip('"')
        if column == "hd" and Data.date != "":
            if Data.patient_status == 0:
                r = calcHospitalDays(Data.date)
            else:
                r = "0"
        # TODO: may not need to calculate fields anymore (at least if using php output)
        if column == "dob":
            Data.dob = r.strip().strip('"')
        if column == "age" and Data.dob != "":
            r = calcPatientAge(Data.dob)

        #if column.startswith("surgery_name"):
        #    Data.getSurgery(Data.getSurgeryNum(column)).name = r   # init new surgery; at the end of the row, rewrite the fields

        if column.find("surgery_date_") >= 0: # set surgery date
            Data.surgery_date = r.strip().strip('"')

        if column.find("pod_") >= 0 and Data.surgery_date != "": # replace old pod with calculated days
            r = calcSurgeryDays(Data.surgery_date)
            Data.surgery_date = "" # clear surgery date for this row

            #if r != "":
            #    Data.getSurgery(Data.getSurgeryNum(column)).pod = int(r)   # set new pod; at the end of the row, rewrite the fields

        if column == "surgeons":
            Data.surgeon_list = []
            name = getSurgeonName(r)
            if name != "":
                Data.surgeon_list.append(name)
        if column == "surgeon":
            if r not in Data.surgeon_list and r != "":
                Data.surgeon_list.append(r)
            if len(Data.surgeon_list) > 1:
                r = ", ".join(Data.surgeon_list)
            elif len(Data.surgeon_list)==1:
                r = Data.surgeon_list[0]
        if (column == "dvt_ppx_other") and r != "":
            other_other = getChoice(column, r) # this "Other" is a dropdown
            r = Data.replacement["dvt_ppx"] = other_other
        return r

    def postFilter(self, item):
        pass

