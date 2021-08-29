<?php
require_once "/var/www/redcap/public/redcap_connect.php";

$FIELD = 'routing';
$PROJECTID = $_GET['pid'];
if($PROJECTID != '87' || (USERID != 'mgalpin' && USERID != 'rapplegate1' && USERID != 'hgoodrum' && USERID != 'awinslow' && USERID != 'rwarth')) {
    print "Permission Denied";
    die();
}
$optionsSql = "select element_enum from redcap_metadata where project_id=$PROJECTID and field_name='$FIELD'";
$optionsQuery = db_query($optionsSql);
$options = explode("\\n", db_result($optionsQuery, 0));
$groups = [];
foreach($options as $o) {
    $vals = explode(", ", trim($o), 2);
    $groups[] = $vals[1];
     }


?>
<form id="groupsForm" style="display:none;" method="post" action="reports/orsbilling/setup.php?pid=<?php echo $PROJECTID;?>">
<input type="hidden" name="newGroups" value="" />
</form>
<script src="reports/orsbilling/setup.js"></script>
<?php

if(!empty($_POST['newGroups'])) {
    print "<span class='notice'>";
    $pplf = fopen("people.csv", "w") or (print ("Error saving groups to file.</span><br/>") and die());
    $newGroups = json_decode($_POST['newGroups'], JSON_HEX_TAG);
    //print_array($newGroups);
    foreach($newGroups as $grp=>$row) {
        $flattened = [];
        $flattened[] = $grp;
        foreach(explode(",",$row) as $person) $flattened[] = strtolower(trim($person));
        fputcsv($pplf,$flattened);
    }
    fclose($pplf);
    print "Routing groups saved!</span><br/>";
    print "<a href='javascript:window.history.back();'>Go back</a>";
    exit();
}

$billing_ppl = [];
foreach(REDCap::getUsers() as $u) {
    $rights = REDCap::getUserRights($u);
    if(!empty($rights) && array_key_exists("role_name", $rights[$u]) && $rights[$u]['role_name'] == 'Billing')
        $billing_ppl[] = $u;
}

$pplf = fopen("people.csv", "r") or die("Can't open people.csv.");
$pplcsv = [];
$groupsAssoc = [];
while(($pplcsv[] = fgetcsv($pplf)) !== FALSE);
fclose($pplf);
foreach($pplcsv as $row)
{
    $groupsAssoc[$row[0]] = [];
    for($p=1; $p<count($row); $p++)
        $groupsAssoc[$row[0]][] = $row[$p];
}


print "<table style='border: 0px;'><tr><td>";
print "<table id='routing-table' role='grid' style='border: 0px;'>";
print "<tr><th></th><th colspan='2'>People <span class='editnote'>(use commas to separate usernames)</th><th></th></tr>";
foreach($groups as $g) {
     if ( $g == 'BILL COMPLETE'){
       continue;
     }
    //if($g==="" || !array_key_exists($g, $groupsAssoc)) // END OF LIST
        //break;
    $ppl = $groupsAssoc[$g];
    //if(count($ppl) == 0)
        //break;    
    $pplstring = implode(", ",$ppl);
    print "<tr>";
    print "<td>$g</td>";
    print "<td class='infobox'><input class='peoples' type='text' value='$pplstring' onkeypress='showButton(this);' onclick='showButton(this);'/></td>";
    print "<td></td>";
    print "</tr>";
}
print "<tr><td><button class='tiny button' type='button' value='Edit groups' onclick='addGroup();'>Edit groups</button></td><td><button class='tiny button savebtn' type='button' value='Save' onclick='savePeople();'>Save</button></td></tr>";
print "</table>";
print "</td><td id='userlist' style='vertical-align: top; padding-left: 2rem;'>Valid users:<br/>".implode("<br/>", $billing_ppl);
print "</td></tr></table>";


?>

