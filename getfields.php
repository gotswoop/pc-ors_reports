<?php

// Return array of fields to pull for a project report or an empty array if it doesn't exist.
function getFields($report, $ffile="fields.csv") {
    global $BINDIR;
    if(trim($report)=="")
        die("No report specified.");
    if(!isset($BINDIR))
        die("Plugin home directory not set.");
    $FFILE = $BINDIR."/reports/".$report."/".$ffile;
    $fcsv = fopen($FFILE,"r");
    if($fcsv == False)
        return array();
    $fields = fgetcsv($fcsv);
    fclose($fscv);
    return $fields;
}

//var_dump(getFields(""));

?>

