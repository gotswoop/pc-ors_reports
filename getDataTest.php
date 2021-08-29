<?php
$BINDIR = getcwd();
$REPORT = $_GET["report"];
require_once "getData.php";

writeData("tmpfile.xml", getfields($REPORT));

?>

