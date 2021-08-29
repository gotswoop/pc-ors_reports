<?php
//require_once "redcap_database.php";
error_reporting(0);
require_once "../redcap_connect.php";
$FILTER_FILE = $BINDIR."/reports/".$REPORT."/filter.php";
$DO_FILTER = file_exists($FILTER_FILE);
$DUMP_RECORD_LIST = true;

if($DO_FILTER)
    require_once $FILTER_FILE;

function writeData($datafile, $export_fields, $event=null, $escapeFields=false) {
    global $limiting_fields;
    global $DO_FILTER;
    global $DUMP_RECORD_LIST;
    $record_list = array();
    if(sizeof($export_fields) == 0)
        $export_fields = null;

    if($DO_FILTER) {
        $option_list = REDCap::getData('array', null, $fields = $limiting_fields);
        //print_r($option_list);
        foreach($option_list as $rec=>$events) {

            $events = array_reverse($events);
            	foreach($events as $ev=>$options) {
                    $fieldmap = [];
                    foreach ($options as $o => $v) {// flatten limiting fields in all events into $fieldmap
                        if ($fieldmap[$o] == "") {
                            $fieldmap[$o] = $v; // blank fields ignored if already found in an event
                        }


                    }

                    if (filterRecord($fieldmap)) {
                        $record_list[] = $rec;
                    } // else { print_r($rec); print_r($fieldmap);}
                }
        }
    }

    if(sizeof($record_list)>0)
        $data = REDCap::getData('xml', $record_list, $export_fields, $events=$event);
    else
        $data = REDCap::getData('xml', ($DO_FILTER)?-1:null, $export_fields, $events=$event);
    if(!$escapeFields) {
        $data = str_replace("<![CDATA[", "", $data);
        $data = str_replace("]]>", "", $data);
    }

    //var_dump($data);
    if($DUMP_RECORD_LIST) {
        $f = fopen($datafile.".filtered-records","w");
        foreach($record_list as $r)
            fwrite($f, $r."\n");
        fclose($f);
    }
    $f = fopen($datafile,"w") or die("error writing REDCap data to file");
    fwrite($f, $data);
    fclose($f);
}



?>

