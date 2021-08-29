# Custom code for COFAKS report
# Created 2015-02-01
from reports_api import *


class COFAKSFilter(ReportFilter):
    def __init__(self):
        pass

    def filter(self, column, r):
        # Show something if blank
        if r=="":
            r = "0"
            #if column.startswith("h_q_ratio"):
            #   r = "N/A"
            return r
        # Round HQ Ratio
        if column.startswith("h_q_ratio"):
            try:
                r = self.report.text_rounded(float(r))
            except:
                r = "0"
            return r

        # Calculation: [heel_height_diff] * 1.2 degrees
        #if column == "heel_height_diff":
        #    val = float(r)
        #    val *= 1.2
        #    r = str(val)

        #Calculation: [left_heel_height] * 1.2 deg
        #?
        #Calculation: [right_heel_height] * 1.2 deg
        #?

        # Rounding
        try:
            if r.count(".")==1 and column != "email_address":
                lt,rt = r.split(".")
                if column in ("r_knee_ext_rom_t_1","r_knee_ext_rom_t_2","r_knee_rom_ext_avarage","l_knee_ext_rom_t_1","l_knee_ext_rom_t_2","l_knee_ext_average","r_knee_flex_rom_t_1","r_knee_flex_rom_t_2","r_knee_flex_average","l_knee_flex_rom_t_1","l_knee_flex_rom_t_2","l_knee_flex_average","r_heel_height_avg","r_heel_height_diff_cm","l_heel_height_avg","l_heel_height_diff_cm","r_heel_height_avg","r_heel_height_diff_cm","l_heel_height_avg","l_heel_height_diff_cm","r_y_bal_ant_trial_1","r_y_bal_ant_trial_2","r_y_bal_ant_trial_3","r_y_bal_ant_greatest","l_y_bal_ant_trial_1","l_y_bal_ant_trial_2","l_y_bal_ant_trial_3","l_y_bal_ant_greatest","single_hop_involved_1","single_hop_involved_2","single_hop_involved_3","single_hop_involved_avg","single_hop_uninvolved_1","single_hop_uninvolved_2","single_hop_uninvolved_3","single_hop_uninvolved_avg","",""):
                    r = self.report.text_rounded(float(r), 1)
                    if r.count(".")==0:
                        r = r + ".0"
                elif len(rt) > 2:
                    r = self.report.text_rounded(float(r),2)
        except:
            pass
        if column in ("single_hop_involved_avg","single_hop_uninvolved_avg","r_knee_ext","l_knee_ext","r_knee_flex","l_knee_flex","involved_extremity", "r_y_bal_ant_greatest", "l_y_bal_ant_greatest","l_knee_ext_average","r_knee_rom_ext_avarage","r_heel_height_avg","l_heel_height_avg","l_knee_flex_average","r_knee_flex_average","l_heel_height_diff_cm","r_heel_height_diff_cm","heel_height_diff_cm"):
            Data.replacement[column] = r

        if column == "time_point":
            Data.replacement[column] = getChoice(column, r)

        if column == "involved_extremity" and r == "2": # both, not handled
            if column not in Data.replacement:
                Data.replacement[column] = "0"          # set as right, should be replaced below
        if column == "involved_extremity_recent" and r.strip() != "":
            Data.replacement["involved_extremity"] = r

        return r


    def postFilter(self, item):
        if "l_knee_flex" in Data.replacement and "l_knee_ext" in Data.replacement and "h_q_ratio_l" not in Data.replacement:
            Data.replacement["h_q_ratio_l"] = "0"
            a = float(Data.replacement["l_knee_flex"])
            b = float(Data.replacement["l_knee_ext"])
            if b != 0:
                c = (a/b) * 100
                Data.replacement["h_q_ratio_l"] = self.report.text_rounded(c)

        if "r_knee_flex" in Data.replacement and "r_knee_ext" in Data.replacement and "h_q_ratio_r" not in Data.replacement:
            Data.replacement["h_q_ratio_r"] = "0"
            a = float(Data.replacement["r_knee_flex"])
            b = float(Data.replacement["r_knee_ext"])
            if b != 0:
                c = (a/b) * 100
                Data.replacement["h_q_ratio_r"] = self.report.text_rounded(c)

        # new columns
        self.report.insert_data(("symmetry","symmetry_cm","knee_ext_quotient","knee_flex_quotient","y_bal_ant_greatest_diff","y_bal_ant_greatest_score"), "0")

        # calculate y_bal_ant_greatest_diff
        # Calculation: [r_y_bal_ant_greatest]-[l_y_bal_ant_greatest]
        if "r_y_bal_ant_greatest" in Data.replacement and "l_y_bal_ant_greatest" in Data.replacement and "involved_extremity" in Data.replacement:
            try:
                a = float(Data.replacement["r_y_bal_ant_greatest"])
                b = float(Data.replacement["l_y_bal_ant_greatest"])
                c = 0
                d = 0
                if Data.replacement["involved_extremity"]=="1":
                    a,b = b,a
                c = b-a
                if b != 0:
                    d = (a/b) * 100
                Data.replacement["y_bal_ant_greatest_diff"] = self.report.text_rounded(c,1)
                Data.replacement["y_bal_ant_greatest_score"] = self.report.text_rounded(d) # whole number
            except:
                Data.replacement["y_bal_ant_greatest_diff"] = "0"
                Data.replacement["y_bal_ant_greatest_score"] = "0"

        # calculate knee_ext_quotient (quads)
        # Calculation:[r_knee_ext]/[l_knee_ext]*100%
        if "r_knee_ext" in Data.replacement and "l_knee_ext" in Data.replacement and "involved_extremity" in Data.replacement:
            try:
                a = float(Data.replacement["r_knee_ext"])
                b = float(Data.replacement["l_knee_ext"])
                c = 0
                if Data.replacement["involved_extremity"]=="1":
                    a,b = b,a
                if b != 0:
                    c = (a/b) * 100
                Data.replacement["knee_ext_quotient"] = self.report.text_rounded(c) # whole number
            except:
                Data.replacement["knee_ext_quotient"] = "0"

        # calculate knee_flex_quotient (hams)
        # Calculation:[r_knee_flex]/[l_knee_flex]*100%
        if "r_knee_flex" in Data.replacement and "l_knee_flex" in Data.replacement and "involved_extremity" in Data.replacement:
            try:
                a = float(Data.replacement["r_knee_flex"])
                b = float(Data.replacement["l_knee_flex"])
                c = 0
                if Data.replacement["involved_extremity"]=="1":
                    a,b = b,a
                if b != 0:
                    c = (a/b) * 100
                Data.replacement["knee_flex_quotient"] = self.report.text_rounded(c) # whole number
            except:
                Data.replacement["knee_flex_quotient"] = "0"

        # calculate symmetry
        # Calculation: [single_hop_involved_avg]/ [single_hop_uninvolved_avg]*100%
        if "single_hop_involved_avg" in Data.replacement and "single_hop_uninvolved_avg" in Data.replacement:
            try:
                a = float(Data.replacement["single_hop_involved_avg"])
                b = float(Data.replacement["single_hop_uninvolved_avg"])
                c = 0
                d = 0
                if b != 0:
                    d = abs(a-b)
                    c = (a/b)*100
                Data.replacement["symmetry"] = self.report.text_rounded(c) # whole number
                Data.replacement["symmetry_cm"] = self.report.text_rounded(d, 1)
            except:
                Data.replacement["symmetry"] = "0"
                Data.replacement["symmetry_cm"] = "0"

        # calculate deficit_extension, deficit_flexion
        # Calculation: |[l_knee_ext_average]-[r_knee_ext_average]|
        if self.report.data_exists("l_knee_ext_average","r_knee_rom_ext_avarage","involved_extremity"):
            try:
                a = float(Data.replacement["r_knee_rom_ext_avarage"])
                b = float(Data.replacement["l_knee_ext_average"])
                c = 0
                if Data.replacement["involved_extremity"]=="1":
                    a,b = b,a
                c = abs(a-b)
                Data.replacement["deficit_extension"] = self.report.text_rounded(c,1)
            except:
                Data.replacement["deficit_extension"] = "0"
        # Calculation: |[l_knee_ext_average]-[r_knee_ext_average]|
        if self.report.data_exists("l_knee_flex_average","r_knee_flex_average","involved_extremity"):
            try:
                a = float(Data.replacement["r_knee_flex_average"])
                b = float(Data.replacement["l_knee_flex_average"])
                c = 0
                if Data.replacement["involved_extremity"]=="1":
                    a,b = b,a
                c = abs(a-b)
                Data.replacement["deficit_flexion"] = self.report.text_rounded(c,1)
            except:
                Data.replacement["deficit_flexion"] = "0"

        # Calculation: [r_heel_height_avg]-[l_heel_height_avg] * 1.2 degrees
        Data.replacement["heel_height_diff"] = "0"
        Data.replacement["heel_height_diff_cm"] = "0"
        if "r_heel_height_avg" in Data.replacement and "l_heel_height_avg" in Data.replacement:
            try:
                a = float(Data.replacement["r_heel_height_avg"])
                b = float(Data.replacement["l_heel_height_avg"])
                c = (a-b) * 1.2
                d = a-b
                a_deg = a * 1.2
                b_deg = b * 1.2
                Data.replacement["heel_height_diff"] = self.report.text_rounded(c,1)
                Data.replacement["heel_height_diff_cm"] = self.report.text_rounded(d,1)
            except:
                pass # just leave at 0
            Data.replacement["r_heel_height_diff_cm"] = self.report.text_rounded(a_deg,1)
            Data.replacement["l_heel_height_diff_cm"] = self.report.text_rounded(b_deg,1)

    # rom_uninvolved
        # Calculation: ([r_knee_rom_ext_average ]+ [r_knee_flex_average ])/ ([l_knee_ext_average]+[l_knee_flex_average]) * 100%
        if self.report.data_exists("r_knee_rom_ext_avarage","r_knee_flex_average","l_knee_ext_average","l_knee_flex_average","involved_extremity"):
            #Data.replacement["rom_uninvolved"] = self.do_equation("rom_uninvolved", "a", "b", "c", "d")
            #_,a,b,c,d = args[:5]
            try:
                a = float(Data.replacement["r_knee_rom_ext_avarage"])
                b = float(Data.replacement["r_knee_flex_average"])
                c = float(Data.replacement["l_knee_ext_average"])
                d = float(Data.replacement["l_knee_flex_average"])
                if Data.replacement["involved_extremity"]=="1":
                    a,b,c,d = c,d,a,b
                ans = abs(((a+b)/(c+d))) * 100
                Data.replacement["rom_uninvolved"] = self.report.text_rounded(ans)
            except:
                Data.replacement["rom_uninvolved"] = "0"

