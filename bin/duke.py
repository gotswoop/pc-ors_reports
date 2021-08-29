# Custom code for Duke report
# Created 2015-02-01
from reports_api import *

class DukeFilter(ReportFilter):
    def __init__(self):
        pass

    def filter(self, column, r):
        r = r.strip()
        if column in ("attending") or column.startswith("or_surgeon"): # change this to a tuple, pass column name to getList() function
            Data.surgeon_list = []
            #Data.replacement[column] = getChoice(column, r)
            name = getChoice(column, r)
            if name != "":
                Data.surgeon_list.append(name)
                r = Data.surgeon_list[0]
        if column == "code_status":
            name = getChoice(column, r)
            if name != "":
                r = Data.replacement[column] = name
        if column == "unit" or column == "unit_transfer":
            name = getChoice(column, r)
            if name != "":
                r = Data.replacement[column] = name
        if (column == "unit_other" or column == "unit_transfer_other") and r != "":
            Data.replacement[column.replace("_other","")] = r
        if column.startswith("mechanism___"):
            name = getChoice(column, r)
            if name != "" and name != "Other":
                if "mechanism" in Data.replacement:
                    r = name
                    Data.replacement["mechanism"] += ", " + name
                else:
                    r = Data.replacement["mechanism"] = name
        if column == "mechanism_other" and r != "":
            if ("mechanism" in Data.replacement) and (Data.replacement["mechanism"] != "" and Data.replacement["mechanism"] != "Other"):
                Data.replacement["mechanism"] += " (" + r + ")"
            else:
                Data.replacement["mechanism"] = r
        if column in ("condition", "prophylaxis", "diet"):
            name = getChoice(column, r)
            if name != "" and name != "Other":
                r = Data.replacement[column] = name
        if column in ("other_prophylaxis", "diet_other", "attending_other") and r != "":
            tag,_ = column.split("_")
            if column == "other_prophylaxis": tag = "prophylaxis"
            if tag in Data.replacement:
                Data.replacement[tag] += " (" + r + ")"
            else:
                Data.replacement[tag] = r
        return r

    def postFilter(self, item):
        # write other lists
        #for column in Data.listProcessors: Data.process_list(column)
        #    listProcessor.process()
        #Data.write_list(column)

        # pre-format diagnoses and treatments
        class Diagnosis:
            def __init__(self, num, cat, diag, info):
                self.num = num
                self.category = cat
                self.diagName = diag
                if info == ", "+diag: info = ""  # fix an earlier bug
                self.info = info
            def __str__(self):
                if self.diagName != "" and self.info != "" and not self.info.startswith(","):
                    self.diagName += ", "
                return str(self.num) + ". " + self.diagName + self.info
        class Treatment:
            def __init__(self,num, dateTxt, procTxt):
                self.num = num
                self.date = dateTxt
                self.procedure = procTxt

        if "diagnosis" in Data.data_lists:
            datalist = Data.data_lists["diagnosis"]
            if len(datalist)>0:
                outlist = []
                outlist_resolved = []
                previous = ""
                cat = ""
                info = ""
                num = 0
                # TODO: BUG, Diagnosis is Other then Diagnosis_Other is being printed twice "foo, foo"
                for i,d in enumerate(datalist):
                    diagTag,diagName = d.split(":",1)
                    if diagTag == "resolved":
                        if previous == "" and info == "" and cat != "":
                            previous = cat + " (other)"
                        if previous == "" and cat == "": continue # data-entry error; dont add to either list
                        num += 1
                        if diagName == "1":
                            outlist_resolved.append(Diagnosis(num, cat, previous.strip(), info.strip()))
                        else:
                            outlist.append(Diagnosis(num, cat, previous.strip(), info.strip()))
                        previous = cat = info = ""
                    elif diagTag == "diag":
                        previous = diagName # we don't know which list it goes in yet
                    elif diagTag == "category":
                        cat = diagName
                    elif diagTag == "info" and diagName != "" and diagName.strip() != previous.strip():
                        if (previous == "Other (no text)") or (info != "" and previous != ""):
                            info += ", "
                        elif info != "" and previous != "":
                            info += ", "
                        info += diagName
                # save and reorder by priority list (diagnosisCmp)
                outlist = sorted(outlist,key=cmp_to_key(Data.diagnosisCmp))
                outlist_resolved = sorted(outlist_resolved,key=cmp_to_key(Data.diagnosisCmp))
                Data.data_lists["diagnosis"] = map(lambda d: d.__str__(), outlist)
                Data.data_lists["diagnosis_resolved"] = map(lambda d: d.__str__(), outlist_resolved)
        else:
            Data.data_lists["diagnosis"] = []

        if "treatment" in Data.data_lists:
            datalist = Data.data_lists["treatment"]
            if len(datalist)>0:
                outlist = []
                num = 1
                date = procedure = ""
                pending = False
                for d in datalist:
                    if d == "": continue
                    prefix,txt = d.split(":",1)
                    if prefix=="date":
                        date = txt
                    elif prefix=="link":
                        # go back and link diagnoses to this tx num
                        #for dxi,targetdx in enumerate(Data.data_lists["diagnosis"]):
                        #    dxnum,_ = targetdx.split(". ")
                        #    if dxnum == txt.strip():
                        #        if Data.data_lists["diagnosis"][dxi].count("> Tx:") == 0:
                        #            Data.data_lists["diagnosis"][dxi] += " > Tx:"
                        #        Data.data_lists["diagnosis"][dxi] += " "+str(num-1)
                        pass
                    else: # "item"
                        if pending and procedure != "":
                            if date != "" and len(date) >= 8:
                                date = date[5:]
                            outlist.append(Treatment(num,date,procedure))
                            num += 1
                            date = procedure = ""
                            pending = False
                        procedure = txt   # Item rows are treatments
                        pending = True

                if pending and procedure != "":
                    if date != "" and len(date) >= 8:
                        date = date[5:]
                    outlist.append(Treatment(num,date,procedure))
                    num += 1
                    date = procedure = ""
                    pending = False

                Data.data_lists["treatment"] = []
                # automatically sorts properly formatted dates
                outlist = sorted(outlist, key=attrgetter("date"))
                for t in outlist:
                    if t.procedure != "": # not entering treatment is an error (date could be blank)
                        if t.date == "":
                            #if len(outlist) > 1:
                            #t.date = ". . . . . ."
                            Data.data_lists["treatment"].append(t.procedure)
                        else:
                            #Data.data_lists["treatment"].append(str(t.num) + ". " + t.date + " - " + t.procedure)
                            Data.data_lists["treatment"].append(t.date + " - " + t.procedure)
                if len(Data.data_lists["treatment"])>0: # store top 2 treatments for wound list
                    Data.data_lists["treatment2"] = [txt for txt in Data.data_lists["treatment"][-2:] ]


        # number lists (no longer doing this here)
        for column in Data.data_lists:
            datalist = Data.data_lists[column]
            if len(datalist)>0:
                for r in item:      # Find Element
                    if r.tag == column:
                        text = ""
                        for i,d in enumerate(datalist):
                            if d == "": break
                            if column == "followup":
                                text += "%s\n"%(d)
                            else:
                            #    text += "%d. %s\n"%(i+1,d)
                                text += "%s\n"%(d)
                        r.text = text   # Set Element
                datalist = []
            else: # blank the list
                for r in [r for r in item if r.tag == column]: r.text = ""

        # add a current_room field (TODO: old version?)
        room = item.find("room_number")
        xferToRoom = item.find("room_number_transfer")
        if (xferToRoom is not None and xferToRoom.text != ""):
            current_room = xferToRoom.text
        else:
            current_room = room.text
        self.report.insertField(item, "current_room", current_room)


