<?php
// Report Filter
// This goes in the report directory if filtering will take place.
// Must contain a $limiting_fields array, which is an array of fields that trigger the filter.
// Must contain a single filterRecord($options) function that returns true or false.
// Option keys are fields from $limiting_fields.
// Values will be either a single value or an array of checkbox values. (0 and 1)

$limiting_fields = [ "routing", "routing2", "routing3", "routing4", "routing5",
                     "routing6", "routing7", "routing8", "routing9", "routing10" ];

function filterRecord($options) {
    foreach($options as $value)
        if($value != "")
            return true;
    return false;
}

?>

