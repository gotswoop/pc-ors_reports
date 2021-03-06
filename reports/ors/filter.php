<?php
// Report Filter
// This goes in the report directory if filtering will take place.
// Must contain a $limiting_fields array, which is an array of fields that trigger the filter.
// Must contain a single filterRecord($options) function that returns true or false.
// Option keys are fields from $limiting_fields.
// Values will be either a single value or an array of checkbox values. (0 and 1)

$limiting_fields = [ "registry_id", "service_list", "patient_last", "patient_status" ];

function registry_id($values) {
    return($values=="00000001"||$values=="00000002"||$values=="00000003");
}

function patient_last($values) {
    return $values !== "";
}

function patient_status($values) {
    return $values == "0";
}

function service_list($values) {
    return ($values["2"] != "1" || $values["1"] == "1" || $values["3"] == "1");
}

function filterRecord($options) {
    if(registry_id($options["registry_id"]))
        return True;
    return(patient_last($options["patient_last"])
            && patient_status($options["patient_status"])
            && service_list($options["service_list"]));
}

?>

