# Custom code for spine report
# Created 2015-02-01
from reports_api import *


class SpineFilter(ReportFilter):
    spineDxTypes = {
    "C-spine Fracture":"C",
    "T-spine Fracture":"T",
    "L-spine Fracture":"L",
    "Sacral Fracture":"Sacral",
    "Spinal Cord Injury":"Spinal Cord",
    "Spinal Ligament Injury":"Ligament",
    "Neurogenic Shock":"",
    "Other":""
    }

    def __init__(self):
        pass

    def filter(self, column, r):
        if column in ("asia", "precautions", "braces", "dvt_ppx"):
            name = getChoice(column, r)
            if name != "":
                r = Data.replacement[column] = name
        if column.startswith("spine_dx___") and r == "1": # checkbox
            name = getChoice(column, r)
            if name != "" and name != "Other":
                r = name
                dxtype = SpineFilter.spineDxTypes[r]
                if dxtype == "":
                    dxtype = r
                if "spine_dx" not in Data.data_lists or "dx:"+dxtype not in Data.data_lists["spine_dx"]:
                    Data.addToList("spine_dx","dx:"+dxtype)
        elif column == "spine_other_desc" and r != "":
            if "spine_dx" not in Data.data_lists or "dx:other"+r not in Data.data_lists["spine_dx"]:
                Data.addToList("spine_dx","dx:other:"+r)
        if column in ("type_level_c","type_level_t","type_level_l","type_level_sacral","type_level_cord","type_level_ligament","type_level_other") and r != "":
            dxtype = column[11:].upper()
            if "spine_dx" not in Data.data_lists or "dx:"+dxtype+":"+r not in Data.data_lists["spine_dx"]:
                Data.addToList("spine_dx","level:"+dxtype+":"+r)

        return r

    def postFilter(self, item):
        if "spine_dx" in Data.data_lists:
            datalist = Data.data_lists["spine_dx"]
            if len(datalist)>0:
                Data.replacement["spine_dx"] = ""
            spine_dx_map = {}
            for d in datalist:
                dxkey,dxval = d.split(":",1)
                dxfor = dxval
                if ":" in dxval:
                    dxfor,dxval = dxval.split(":",1)
                dxfor = dxfor.upper()
                if dxkey == "dx" and dxfor not in spine_dx_map:
                    spine_dx_map[dxfor] = dxval
                if dxkey == "level":
                    if dxfor not in spine_dx_map:
                        spine_dx_map[dxfor] = dxfor
                    spine_dx_map[dxfor] += "-"+dxval
            outlist = []
            for dkey in spine_dx_map:
                dx_formatted = spine_dx_map[dkey]
                if len(dx_formatted)==1 or dx_formatted[1] == "-":
                    dxcode = dx_formatted[0]
                else:
                    dxcode = ""
                if dxcode in ("C","T","L","S"):
                    dx_formatted += " Fracture"
                outlist.append(dx_formatted)
            Data.replacement["spine_dx"] += ", ".join(outlist)

        # add a current_room field (TODO: new version? NO-spine doesn't use room_number/current_room)
        room = item.find("room_number")
        if room is not None:
            current_room = room.text
            xferToRoom = item.find("room_number_transfer")
            if (xferToRoom is not None and xferToRoom.text != ""):
                current_room = xferToRoom.text
            self.insertField(item, "current_room", current_room)

