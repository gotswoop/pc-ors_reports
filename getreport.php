<?php
$PULL_DATA = true;      // use PHP methods to get the data for this report
$BINDIR = getcwd() or die("Permission denied when loading plugin directory."); // location of report builder
$DATADIR = ""; // specify where any data and temp files will be written
$INJECT_RECORDS = false; // add record numbers to javascript (TODO: write json, import with ajax)
$PROJECT_PLUGIN = true; // show REDCap header and footer
$SET_USER = true;       // send username to report builder
$SET_EVENT = true;
$FIELDSFILE = "fields.csv";


function getSections() {
    $sections = "";
    $s = "";

    foreach($_POST as $k=>$v)
    {
        if($k=="cb")
        {
            foreach($v as $cb=>$cbv)
            {
                if($s!="")
                    $s = $s.",";
                $s = $s.$cbv;
            }
            break;
        }
    }
    if(strlen($s) > 0)
        $sections = " sections=".$s;
    return $sections;
}

//$reportBuilder = ReportBuilder();
//$reportBuilder->getParameters();
//$report = $reportBuilder->loadProject();
//$report->makeReport()
//if($report->use_xml) {
//  while($data = reportBuilder->pullProjectData()) {
//      $xmlFilter = reportBuilder->createReportXMLFilter()
//      $data = $xmlFilter->processData($data)
//    }
// }
// else {
//  while($datafile = reportBuilder->downloadData()) {
//   $data = reportBuilder->readData();
//  }
// }
// $html = $report->formatData($data)
// print $html;


// Get/Post Data
//getParameters();
if(isset($_GET["reload"]))
    $reload=true;
else
    $reload=false;
if(!isset($_GET["report"]))
    die("<h3>No report specified!</h3>");
$REPORT=$_GET["report"];
$REPORTDIR = $BINDIR."/reports/".$REPORT;
if(!file_exists($REPORTDIR))
    die("<h3>Invalid report specified! Report directory doesn't exist.</h3>");

require_once $BINDIR."/getdata.php";
if(file_exists($REPORTDIR."/settings.php")) {
    require_once $REPORTDIR."/settings.php";
}

if(isset($_GET["record"]) and !empty($_GET["record"]))
    $record=$_GET["record"];
else {
    $RECORD_ID=REDCap::getRecordIdField();
    $record=-1;
    $records = REDCap::getData('json',null,$RECORD_ID);
}

$event = "";
if($SET_EVENT && isset($_GET["event"]))
    $event = $_GET["event"];

$sections = getSections();
//$sections = " sections=icu,trauma,morning"; // test

$settings = "set='{\"id\":".$record;
if($SET_USER)
    $settings .= ', "username":"'.strtolower(USERID).'"';
$settings .= "}'";
$DATAFILE = $REPORT."-data.xml"; # default, shared for all users
if($SET_USER && USERID !== "") {
    $DATAFILE = $REPORT.".".USERID;
    $CMD = "./makeReport.py ".($reload?"reload=yes":"")." report=$REPORT datafile=$DATAFILE ".$settings.$sections;
}
else
    $CMD = "./makeReport.py ".($reload?"reload=yes":"")." report=$REPORT ".$settings.$sections;

// getting the data with PHP is faster than using the API
if($PULL_DATA) {
    require_once "getfields.php";
    // We use the PHP methods to get the data for this report because it's faster.
    $fields = getFields($REPORT);
    writeData($BINDIR."/data/".$DATAFILE, $fields, $event, true);
}
//die(); // measuring export time
if($PROJECT_PLUGIN)
    require_once APP_PATH_DOCROOT . 'ProjectGeneral/header.php';

//--- BEGIN REPORT ---//
if($INJECT_RECORDS) {
    print "<script>var urlParams = " . json_encode($_GET, JSON_HEX_TAG) . "; </script>";
    if($record == -1)
        print "<script>var redcapRecords = ".$records . "; </script>";
}
system("cd " . $BINDIR . "; " . $CMD);
//--- END REPORT ---//

if($PROJECT_PLUGIN)
    require_once APP_PATH_DOCROOT . 'ProjectGeneral/footer.php';
?>

