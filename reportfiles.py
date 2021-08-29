from bin.reporttransformer import ReportTransformer
import duke

DukeFiles = [
    {"record":"00000001", "field":"picture", "name":"contacts1", "validator":ReportTransformer.tableValidator, "processor":duke.processContacts, "appender":duke.insertTable},
    {"record":"00000001", "field":"picture2", "name":"contacts2", "validator":ReportTransformer.tableValidator, "processor":duke.processContacts, "appender":duke.insertTable}
]





