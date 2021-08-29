import reporttransformer
import time
import datetime
from math import trunc
from operator import attrgetter
from lxml import etree
from reporttransformer import ReportTransformer, Data

DEBUG = False

# Used to generate ORS and Spine reports
class ORSTransformer(ReportTransformer):
    tableValidator = None

    def __init__(self, report=None):
        super(ORSTransformer, self).__init__(report)

    def preProcess(self):
        super(ORSTransformer, self).preProcess()

        if Data.surgery_fields == []:
            surgery_fields_a_init = ("surgery_name_", "surgery_date_", "pod_")
            surgery_fields_b_init = ("sub_surgery_name_", "sub_surgery_date_", "sub_pod_")
            for i in range(1, Data.MAX_SURGERY_FIRST+1):
                for field in surgery_fields_a_init:
                    Data.surgery_fields.append(field+str(i))
            for i in range(1, Data.MAX_SURGERY_FIRST+1):
                for field in surgery_fields_b_init:
                    Data.surgery_fields.append(field+str(i))
            Data.surgery_xpath = " or ".join(map(lambda s: "self::"+s, Data.surgery_fields))
            if len(Data.surgery_fields)>0:
                Data.surgery_xpath = "*["+Data.surgery_xpath+"]"

    def updateItemData(self, item, r):
            # TODO: SIGNIFICANT performance hit? Check. #
            if DEBUG and (r.tag.startswith("registry_id") or r.tag.startswith("pod_") or r.tag.startswith("sub_pod_")):
                if r.text != "":
                    dbg += " " + r.tag + ":" + r.text
            if r.tag.startswith("registry_id") and r.text != "":
                if self.inRecord != "" and self.inRecord != r.text: # new record, write previous
                    Data.data_list[self.inRecord].sort(key=Data.Surgery.key, reverse=True)
                    if DEBUG and self.inRecord==DEBUG_REC:
                        print "New: " + str( [ str(s.pod)+' '+s.name for s in Data.data_list[self.inRecord] ] )
                self.inRecord = r.text
                if self.inRecord not in Data.data_list:
                    if DEBUG and self.inRecord == DEBUG_REC:
                        print "Start record " + self.inRecord + "<br>"
                    Data.data_list[self.inRecord] = []
            if (r.tag.startswith("pod_") or r.tag.startswith("sub_pod_") or r.tag.startswith("surgery_na") or r.tag.startswith("sub_surgery_na")) and self.inRecord != "":
                if self.inRecord not in self.elementsOut: # save write pos (will write starting at second input line)
                    self.elementsOut[self.inRecord] = []
                if item not in self.elementsOut[self.inRecord]:
                    self.elementsOut[self.inRecord].append(item)
                if r.text != "":
                    if self.inRecord not in Data.data_list:
                        Data.data_list[self.inRecord] = [] # init. new list
                    surgery = Data.getSurgery(self.inRecord)
                    if surgery.pod != None and surgery.name != None:
                        raise Exception("Can't write to this surgery!")
                    if r.tag.startswith("pod_") or r.tag.startswith("sub_pod_"):
                        surgery.pod = int(r.text) # integer for comparison sort
                    if r.tag.startswith("surgery_na") or r.tag.startswith("sub_surgery_na"):
                        surgery.name = r.text
                    if DEBUG and self.inRecord==DEBUG_REC:
                        print "Found surgery: " + r.tag + ":" + r.text
                        print "\tList now " + str( [ str(s.pod)+' '+str(s.name) for s in Data.data_list[self.inRecord] ] )


    # Do something after processing all records
    def postProcess(self):
        super(ORSTransformer, self).postProcess()
        # performance hit #
        # REORDER surgeries and write
        for rec in Data.data_list:
            if rec in ("00000001", "00000002", "00000003"): continue    # not real records
            slist = Data.data_list[rec]
            if len(slist)>0:
                if rec not in self.elementsOut:
                    raise Exception("Can't find write row for record "+rec)
                for item in self.elementsOut[rec]:
                    for i in range(1, Data.MAX_SURGERY_FIRST+1):
                        num = str(i)
                        blank = ("surgery_name_", "surgery_date_", "pod_")
                        for b in blank:
                            field = item.find(b+num)
                            if field is not None:
                                field.text = ""
                    for i in range(1, Data.MAX_SURGERY_FOLLOW+1):
                        num = str(i)
                        blank = ("sub_surgery_name_", "sub_surgery_date_", "sub_pod_")
                        for b in blank:
                            field = item.find(b+num)
                            if field is not None:
                                field.text = ""
                    ##blanks = item.xpath(Data.surgery_xpath)
                    ##for blank in blanks:
                    ##    blank.text = ""
                    """for blank in Data.surgery_fields:
                        field = item.findall(blank)
                        if len(field)==0: field=None
                        else: field=field[0]
                        if field is not None:
                            field.text = """""
            # cleared originals; now write new data (start from 2nd input line)
            num = 1
            writeIdx = 0

            if rec not in self.elementsOut:
                return

            if len(self.elementsOut[rec]) > 1:
                 writeIdx = 1
            item = self.elementsOut[rec][writeIdx]
            for surgery in slist:
               if surgery.name != None and surgery.pod != None:
                     if num <= Data.MAX_SURGERY_FIRST:
                         nametag = "surgery_name_" + str(num)
                         podtag = "pod_" + str(num)
                     elif num > Data.MAX_SURGERY_FIRST and num <= (Data.MAX_SURGERY_FIRST+Data.MAX_SURGERY_FOLLOW):
                         nametag = "sub_surgery_name_" + str(num-Data.MAX_SURGERY_FIRST)
                         podtag = "sub_pod_" + str(num-Data.MAX_SURGERY_FIRST)
                     else:
                         break # each line can only handle MAX_SURGERY_FIRST surgeries, MAX_SURGERY_FOLLOW sub surgeries
                     if DEBUG and rec==DEBUG_REC:
                         print "Write " + str(surgery.pod) + " " + surgery.name + " to " + podtag + "," + nametag
                     field = item.find(nametag)
                     if field is None:
                         raise Exception("Field " + nametag + " not set for record " + rec)
                     field.text = surgery.name
                     field = item.find(podtag)
                     if field is None:
                         raise Exception("Field " + podtag + " not set for record " + rec)
                     field.text = str(surgery.pod) # back to string
               num += 1
               if num > Data.MAX_SURGERY_FIRST+Data.MAX_SURGERY_FOLLOW:
                   writeIdx += 1
                   num = 1
                   if len(self.elementsOut[rec]) > writeIdx:
                       item = self.elementsOut[rec][writeIdx]
                   else:
                       break

