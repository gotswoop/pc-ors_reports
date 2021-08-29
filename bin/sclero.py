# Custom code for sclero report
# Created 2015-02-01
from reports_api import *



class ScleroFilter(ReportFilter):
    colmap2 = {
    "billing_ins":""
    }
    colmap3 = {
    "other_ins":""
    }
    colmap4 = {
    "other_ulcers":"", "dig_tip_ulc":"", "dig_pits":"", "telangiect":""
    }
    colmap5 = {
            "ana":"","ana_titer":"","ana_pattern":"","anti_centromere":"","anti_rna_polymeras_iii":"","anti_ro_ss_a":"","anti_la_ss_b":"","anti_sm":"","anti_rnp":"","anti_mitochondrial_ab":"","anticardiolipin_igg":"","anticardiolipin_igm":"","anticardiolipin_iga":"","rheumatoid_factor":"","ccp":"","topo_aka_scl_70":"","dsdna":""
    }

    def __init__(self):
        pass

    def filter(self, column, r):
        # SCLERO
        # hand extension
        #if column in ("other_ulcers","dig_tip_ulc","dig_pits","telangiect"):
        try:
            if column in ScleroFilter.colmap4:
                dummy=ScleroFilter.colmap4[column]
                r = getChoice(column, r)
                Data.replacement[column] = r
        except KeyError:
            pass

        # serology
        try:
            if column in ScleroFilter.colmap5:
                dummy=ScleroFilter.colmap5[column]
                r = getChoice(column, r)
                Data.replacement[column] = r
        except KeyError:
            pass

        # sclero
        if column == Data.redcap_friendly_events["_field"]:
            if r in Data.redcap_friendly_events:
                Data.replacement["redcap_friendly_event_name"] = Data.redcap_friendly_events[r]
            else:
                Data.replacement["redcap_friendly_event_name"] = r
        return r
    def postFilter(self, item):
        pass

