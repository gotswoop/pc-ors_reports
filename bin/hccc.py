# Custom code for hccc report
# Created 2015-03-23
from reports_api import *
from api.routing import getUsernames
from datetime import datetime

class HCCCFilter(ReportFilter):
    def __init__(self):
        pass

    def filter(self, column, r):
        # used for counting later
        #if column.startswith("billing_date_rec"):
        #    Data.replacement[column] = r
        
        if column in("arm"):
            rchoice = getChoice(column,r)
            if rchoice.strip() != "":
                r = rchoice
            return r
           
        if column.startswith("visit_select"):
            Data.replacement[column] = r 
            return 
        
        if column.startswith("resp_symp"):
            Data.replacement[column] = r 
            return r
        
        if column.startswith("hosp"):
            Data.replacement[column] = r 
            return r
            
        if column.startswith("hosp_days"):
            Data.replacement[column] = r 
            return r
            
        if column.startswith("units"):
            Data.replacement[column] = r 
            return r
            
        if column.startswith("er_to_admit"):
            Data.replacement[column] = r 
            return r
            
        if column.startswith("los_picu"):
            Data.replacement[column] = r 
            return r
        
        if column.startswith("visit_type"):
            Data.replacement[column] = r
            return r
        
        if column.startswith("date_study"):
            Data.replacement[column] = r
            return r
            
        if column.startswith("month_misseddays"):
            Data.replacement[column] = r
            return r
            
        if column.startswith("month_daysmissedresp"):
            Data.replacement[column] = r
            return r
            
        if column in ("date_e","date_e2","date_e3","date_e4","date_e5","date_e6","date_e7","date_e8","date_e9","date_e10","date_e11","date_e12","date_e13","date_e14","date_e15","date_e16","date_e17","date_e18","date_e19","date_e20","date_e21","date_e22","date_e23","date_e24","date_e25","date_e26","date_e27"):
            Data.replacement[column] = r
            return r
        
        if column.startswith("date_er"):
            Data.replacement[column] = r
            return r
        
        if column.startswith("date_admit"):
            Data.replacement[column] = r
            return r
        
        return r
        
        
    def postFilter(self, item):
        
        officeCount = 0
        erCount = 0
        toAdmitYesCount = 0
        toAdmitNoCount = 0
        hospAdmitCount = 0
        picuAdmitCount = 0
        hospLosSum = 0
        hospLosRespSum = 0
        picuLosSum = 0
        picuLosRespSum = 0 
        officeRespCount = 0
        officeOtherSickCount = 0
        officeFollowUpCount = 0
        officeOtherCount = 0
        erRespCount = 0
        obsAdmitCount = 0
        missedDaysSum = 0
        missedDaysRespSum = 0
        uniqueVisitsSum = 0
        dateSet = set()
        
        for i in range(1,28):
            if i == 1:
                visitColumn = "visit_select"
            else:
                visitColumn = "visit_select" + str(i)
          
            if visitColumn in Data.replacement:
                if Data.replacement[visitColumn] == "1":
                    officeCount += 1
                elif Data.replacement[visitColumn] == "2":
                    erCount += 1
                  
        Data.replacement["office_visits"] = officeCount
        Data.replacement["er_visits"] = erCount
        
        for i in range(1,28):
            if i == 1:
                toAdmitColumn = "er_to_admit"
            else:
                toAdmitColumn = "er_to_admit" + str(i)
          
            if toAdmitColumn in Data.replacement:
                if Data.replacement[toAdmitColumn] == "1":
                    toAdmitYesCount += 1
                elif Data.replacement[toAdmitColumn] == "0":
                    toAdmitNoCount += 1

        Data.replacement["er_admit_yes"] = toAdmitYesCount
        Data.replacement["er_admit_no"] = toAdmitNoCount
        
        for i in range(1,28):
            if i == 1:
                hospColumn = "hosp"
            else:
                hospColumn = "hosp" + str(i)
          
            if hospColumn in Data.replacement:
                if Data.replacement[hospColumn] == "1":
                    hospAdmitCount += 1
                  
        Data.replacement["hosp_admit"] = hospAdmitCount
        
        for i in range(1,28):
            if i == 1:
                picuColumn = "units___1"
            else:
                picuColumn = "units" + str(i) + "___1"
          
            if picuColumn in Data.replacement:
                if Data.replacement[picuColumn] == "1":
                    picuAdmitCount += 1
                  
        Data.replacement["picu_admit"] = picuAdmitCount
        
        for i in range(1,28):
            if i == 1:
                hospLosColumn = "hosp_days"
                hospRespLosColumn = "resp_symp"
                
            else:
                hospLosColumn = "hosp_days" + str(i)
                hospRespLosColumn = "resp_symp" + str(i)
          
            if hospLosColumn in Data.replacement:
                    if Data.replacement[hospLosColumn] != '':
                        hospLosSum += int(Data.replacement[hospLosColumn])
                        if Data.replacement[hospRespLosColumn] == "1":
                            hospLosRespSum += int(Data.replacement[hospLosColumn])
                  
        Data.replacement["hosp_los"] = hospLosSum
        Data.replacement["hosp_los_resp"] = hospLosRespSum
        
        for i in range(1,24):
            if i == 1:
                monthMissedColumn = "month_misseddays"
            else:
                monthMissedColumn = "month_misseddays" + str(i)
          
            if monthMissedColumn in Data.replacement:
                    if Data.replacement[monthMissedColumn] != '':
                        missedDaysSum += int(Data.replacement[monthMissedColumn])
                  
        Data.replacement["school_days"] = missedDaysSum
        
        for i in range(1,24):
            if i == 1:
                monthMissedRespColumn = "month_daysmissedresp"
            else:
                monthMissedRespColumn = "month_daysmissedresp" + str(i)
          
            if monthMissedColumn in Data.replacement:
                    if Data.replacement[monthMissedRespColumn] != '':
                        missedDaysRespSum += int(Data.replacement[monthMissedRespColumn])
                  
        Data.replacement["school_days_resp"] = missedDaysRespSum
        
        for i in range(1,28):
            if i == 1:
                picuLosColumn = "los_picu"
                picuLosRespColumn = "resp_symp"
            else:
                picuLosColumn = "los_picu" + str(i)
                picuLosRespColumn = "resp_symp" + str(i)
          
            if picuLosColumn in Data.replacement:
                    if Data.replacement[picuLosColumn] != '':
                        picuLosSum += int(Data.replacement[picuLosColumn])
                        if Data.replacement[picuLosRespColumn] == "1":
                            picuLosRespSum += int(Data.replacement[picuLosColumn])
                                  
        Data.replacement["picu_los"] = picuLosSum
        Data.replacement["picu_los_resp"] = picuLosRespSum
        
        for i in range(1,28):
            if i == 1:
                officeRespColumn = "visit_type"
            else:
                officeRespColumn = "visit_type" + str(i)
          
            if officeRespColumn in Data.replacement:
                if Data.replacement[officeRespColumn] == "1":
                    officeRespCount += 1
                elif Data.replacement[officeRespColumn] == "2":
                    officeOtherSickCount += 1
                elif Data.replacement[officeRespColumn] == "3":
                    officeFollowUpCount += 1
                elif Data.replacement[officeRespColumn] == "4":
                    officeOtherCount += 1
                    
        Data.replacement["office_resp"] = officeRespCount
        Data.replacement["office_othersick"] = officeOtherSickCount
        Data.replacement["office_followup"] = officeFollowUpCount
        Data.replacement["office_other"] = officeOtherCount
                    
        for i in range(1,28):
            if i == 1:
                erRespColumn = "resp_symp"
            else:
                erRespColumn = "resp_symp" + str(i)
          
            if erRespColumn in Data.replacement:
                if Data.replacement[erRespColumn] == "1":
                    erRespCount += 1
                    
        Data.replacement["er_resp"] = erRespCount
        
        today = datetime.now() 
        if Data.replacement["date_study"] != '':
            entryDate = datetime.strptime(Data.replacement["date_study"], '%Y-%m-%d')
            daysInStudy = today - entryDate
            Data.replacement["days_in_study"] = daysInStudy.days
            
        for i in range(1,28):
            if i == 1:
                obsColumn = "units___4"
            else:
                obsColumn = "units" + str(i) + "___4"
          
            if obsColumn in Data.replacement:
                if Data.replacement[obsColumn] == "1":
                    obsAdmitCount += 1
                  
        Data.replacement["obs_admit"] = obsAdmitCount
        
        #Add office visit, er, and admit dates to a list and find the length of that list to count only unique     
        for i in range(1,28):
            if i == 1:
                visitDateColumn = "date_e"
            else:
                visitDateColumn = "date_e" + str(i)
          
            if visitDateColumn in Data.replacement:
                if (Data.replacement[visitDateColumn] != ""):
                    dateSet.add(Data.replacement[visitDateColumn])

        for i in range(1,28):
            if i == 1:
                erDateColumn = "date_er"
            else:
                erDateColumn = "date_er" + str(i)
          
            if erDateColumn in Data.replacement:
                if Data.replacement[erDateColumn] != "":
                    dateSet.add(Data.replacement[erDateColumn])
        
        for i in range(1,28):
            if i == 1:
                admitDateColumn = "date_admit"
            else:
                admitDateColumn = "date_admit" + str(i)
          
            if admitDateColumn in Data.replacement:
                if Data.replacement[admitDateColumn] != "":
                    dateSet.add(Data.replacement[admitDateColumn])
                    
        Data.replacement["unique_dates"] = len(dateSet)
            
        
        #Data.replacement["billing_date"] = Data.replacement["billing_date_rec"]