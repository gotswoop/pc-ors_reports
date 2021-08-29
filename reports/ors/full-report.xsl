<?xml version="1.0" ?>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform" >

<xsl:template match ="/" >
    <html>
          <head>
          <meta http-equiv="X-UA-Compatible" content="IE=8" />
          	  <!-- display none on screen, @media screen -->
			<style script="text/css">
			body {
				font-size: 90%;
					margin-left: 5;
					}
					thead {display: table-header-group; left: 0px; }
					tfoot {display: table-footer-group;}
					tbody {display: table-row-group;}
			.bed, .surgSpacer {
				width: 15%;
				text-align: left;
			}
			.mrn {
				text-align: left;
				width: 3em;
			}
			.patientName {
				width: 8em;
				}
			td.patientName {
				font-weight:bold;
				font-size: 85%;
				}
			.hd,.gender {
				text-align: right;
			}
			.age {
				width: 3em;
				text-align: left;
			}
			.hd {
				width: 3em;
				}
			.gender {
				width: 3em;
			}
			.staff {
				width: 10em;
			}
			.service {
				width: 10em;
			}
			th.gender {
				text-size: 70%;
			}
			.diagnosis {
				width: 16em;
			}
			td.diagnosis {
				border-left: 1px dotted grey;
			}
			
			.surgeryText {
				font-size: 80%;
					text-align: left;
						align:left;
						}
			.surgeryBlock {
				 background:#cccccc !important;
				 text-align:left;
				  background-color: #cccccc !important;
				-webkit-print-color-adjust: exact; 
				table-layout: auto;
				}
			p.notes {
				border: 2px solid black;
				border-collapse: separate;
				position:relative;
				left: 20;
				top: 0;
				page-break-inside: avoid;
			}
			tr.trHeader,.magic {
				border-bottom: 4px solid black;
			}
			tr.trHeader {
				display:none;
			}
			table.content {
				border-collapse: collapse;
				<!--left: 0; does nothing-->
			}
			table.content tr td, table.content tr th, .contentBlock {
				page-break-inside: avoid !important;
				margin: 4px 0 4px 0;
			}
			.contentBlock {
				page-break-inside: avoid !important;
				margin: 4px 0 4px 0;
			}
			table {
				table-layout: auto;
				border: 0px solid pink;
			}
			th, td {
				<!-- overflow: hidden; don't do this -->
				border: 0px dotted pink;
			}
			
			.topHeader, .rowHeader {
				font-size: 75%;
					color: #999999;
					}
			
			
			.hideText {
				visibility:hidden;
				color: #00FF00;
				}
			
			.columnAlign {
				visibility:hidden;
					color: #FF00FF;
					border-top: 2px solid white;
			}
			
			h2.topTitle {
				display: none;
			}
			
			
			@media print {
				.magic {
					position:fixed;
					top: 5pt;
						}
				td.content {
						}
				.footer {
							border: 1px solid grey;
							position: fixed;
							bottom: 99%;
							display: none;
						}
				.page-break {
							display: block;
							page-break-before:avoid;
							page-break-after:auto;
							}
				.topTitle {
						position: relative;
								text-align:center;
									}
				tr.trHeader {
						display:none;
						<!--text-align:center;-->
						position:relative;
						top: 0;
						left: 50%;
						right: 50%;
						}

				.surgeryBlock {
						 background:#cccccc !important;
						 text-align:left;
						  background-color: #cccccc !important;
						 -webkit-print-color-adjust: exact; 
						table-layout: auto;
						 }
			
				}
			@media screen {	
			
			}
			</style>

        <title>ORS Patient List</title>
	      </head>
        		            <body>
        		            	  <xsl:apply-templates />
        		            	        </body>
        		            	            </html>
        		            	            </xsl:template>

<xsl:template match="records" >
	<br/><br/>
	    <h2 class="topTitle" align="center">ORS Patient List</h2>
	        <table class="content" width="97%" align="center" cellpadding="3">
		<thead class="magic">
		<tr>
		<th class="bed">Bed<span class="hideText">######</span></th><th class="mrn">MRN<span class="hideText">#####</span></th><th class="patientName">Name<span class="hideText">##############</span></th><th class="gender">Gender</th><th class="age">Age</th><th class="hd">HD</th><th class="staff">Staff<span class="hideText">######</span></th><th class="service">Service<span class="hideText">##</span></th><th class="diagnosis">Diagnosis<span class="hideText">######################</span></th>
		</tr></thead>

		<xsl:apply-templates select="item">
			<xsl:sort select="room" data-type="text"/>
		</xsl:apply-templates>
    </table>
    	<p class="footer"><hr/></p>
    	</xsl:template >

<xsl:template match="item">
<xsl:if test="patient_last!=''">
<xsl:if test="patient_status='0' and (service_list___2!='1' or service_list___1='1' or service_list___3='1')">
<div class="contentBlock">
<tr width="100%">

<table class="content" width="97%" align="center" cellpadding="3" border="0">
<!-- add a blank line (+columnAlign) to make space for the headers -->
<tr><td class="content"></td></tr>
<!-- have to show this on each row for printing -->
<!--<tr class="rowHeader">
<td>Bed</td><td>MRN</td><td style="width:50%;">Name</td><td>Gender</td><td>Age</td><td>HD</td><td>Staff</td><td>Service</td><td style="width:40%;">Diagnosis</td>
</tr>-->
<!--<thead class="columnAlign">-->
<!--<tr class="columnAlign"><th></th><th></th><th><h3>ORS Patient List</h3></th></tr>-->
<tr class="columnAlign"><th class="bed">Bed#####</th><th class="mrn">MRN#####</th><th class="patientName">Name##############</th><th class="gender">Gender</th><th class="age">Age</th><th class="hd">HD</th><th class="staff">Staff######</th><th class="service">Service</th><th class="diagnosis">Diagnosis######################</th></tr>
<!--</thead>-->
<tr>
<td class="bed"><xsl:value-of select="room" /></td>
<td class="mrn"><xsl:if test="mrn &gt; 00000002"><xsl:value-of select="mrn" /></xsl:if></td>
<td class="patientName"><xsl:value-of select="patient_last" />, <xsl:value-of select="patient_first" /></td>
<td class="gender"><xsl:if test="mrn &gt; 00000002"> <xsl:if test="gender = 0">M</xsl:if><xsl:if test="gender = 1">F</xsl:if></xsl:if></td>
<td class="age"><xsl:if test="mrn &gt; 00000002"><xsl:value-of select="age" /></xsl:if></td>
<td class="hd"><xsl:if test="mrn &gt; 00000002"><xsl:value-of select="hd" /></xsl:if></td>
<td class="staff"><xsl:value-of select="surgeon" /></td>
<td class="service"><xsl:value-of select="enterable_notes2_725" /></td>
<td class="diagnosis"><xsl:value-of select="enterable_notes2_698" /></td>
</tr>
<tr align="center">
<td class="surgSpacer"></td>

<td colspan="5" width="40%" alight="right">
<xsl:for-each select="../item[registry_id=current()/registry_id]">
<xsl:if test="surgery_name_1 != '' or sub_surgery_name_1 != ''">

<table class="surgeryBlock" style="" width="100%">
<xsl:if test="surgery_name_1 != ''">
<tr>
<td style="width:3em;" class="surgeryText">POD</td>
<td align="left" class="surgeryText" style="position:relative; left:0;"><xsl:value-of select="pod_1"/><xsl:if test="pod_1 = ''">0</xsl:if></td>
<td colspan="3"></td>
<td class="surgeryText"><xsl:value-of select="surgery_name_1"/></td>
</tr></xsl:if>
<xsl:if test="surgery_name_2 != ''">
<tr><td class="surgeryText">POD</td>
<td class="surgeryText"><xsl:value-of select="pod_2"/><xsl:if test="pod_2 = ''">0</xsl:if></td>
<td colspan="3"> </td>
<td class="surgeryText"><xsl:value-of select="surgery_name_2"/></td>
</tr></xsl:if>
<xsl:if test="surgery_name_3 != ''">
<tr><td class="surgeryText">POD</td>
<td class="surgeryText"><xsl:value-of select="pod_3"/><xsl:if test="pod_3 = ''">0</xsl:if></td>
<td colspan="3"> </td>
<td class="surgeryText"><xsl:value-of select="surgery_name_3"/></td>
</tr></xsl:if>
<xsl:if test="surgery_name_4 != ''">
<tr><td class="surgeryText">POD</td>
<td class="surgeryText"><xsl:value-of select="pod_4"/><xsl:if test="pod_4 = ''">0</xsl:if></td>
<td colspan="3"> </td>
<td class="surgeryText"><xsl:value-of select="surgery_name_4"/></td>
</tr></xsl:if>
<xsl:if test="surgery_name_5 != ''">
<tr><td class="surgeryText">POD</td>
<td class="surgeryText"><xsl:value-of select="pod_5"/><xsl:if test="pod_5 = ''">0</xsl:if></td>
<td colspan="3"> </td>
<td class="surgeryText"><xsl:value-of select="surgery_name_5"/></td>
</tr></xsl:if>
<xsl:if test="surgery_name_6 != ''">
<tr><td class="surgeryText">POD</td>
<td class="surgeryText"><xsl:value-of select="pod_6"/><xsl:if test="pod_6 = ''">0</xsl:if></td>
<td colspan="3"> </td>
<td class="surgeryText"><xsl:value-of select="surgery_name_6"/></td>
</tr></xsl:if>
<xsl:if test="surgery_name_7 != ''">
<tr><td class="surgeryText">POD</td>
<td class="surgeryText"><xsl:value-of select="pod_7"/><xsl:if test="pod_7 = ''">0</xsl:if></td>
<td colspan="3"> </td>
<td class="surgeryText"><xsl:value-of select="surgery_name_7"/></td>
</tr></xsl:if>
<xsl:if test="surgery_name_8 != ''">
<tr><td class="surgeryText">POD</td>
<td class="surgeryText"><xsl:value-of select="pod_8"/><xsl:if test="pod_8 = ''">0</xsl:if></td>
<td colspan="3"> </td>
<td class="surgeryText"><xsl:value-of select="surgery_name_8"/></td>
</tr></xsl:if>
<xsl:if test="surgery_name_9 != ''">
<tr><td class="surgeryText">POD</td>
<td class="surgeryText"><xsl:value-of select="pod_9"/><xsl:if test="pod_9 = ''">0</xsl:if></td>
<td colspan="3"> </td>
<td class="surgeryText"><xsl:value-of select="surgery_name_9"/></td>
</tr></xsl:if>
<xsl:if test="surgery_name_10 != ''">
<tr><td class="surgeryText">POD</td>
<td class="surgeryText"><xsl:value-of select="pod_10"/><xsl:if test="pod_10 = ''">0</xsl:if></td>
<td colspan="3"> </td>
<td class="surgeryText"><xsl:value-of select="surgery_name_10"/></td>
</tr></xsl:if>
<xsl:if test="surgery_name_11 != ''">
<tr><td class="surgeryText">POD</td>
<td class="surgeryText"><xsl:value-of select="pod_11"/><xsl:if test="pod_11 = ''">0</xsl:if></td>
<td colspan="3"> </td>
<td class="surgeryText"><xsl:value-of select="surgery_name_11"/></td>
</tr></xsl:if>
<xsl:if test="surgery_name_12 != ''">
<tr><td class="surgeryText">POD</td>
<td class="surgeryText"><xsl:value-of select="pod_12"/><xsl:if test="pod_12 = ''">0</xsl:if></td>
<td colspan="3"> </td>
<td class="surgeryText"><xsl:value-of select="surgery_name_12"/></td>
</tr></xsl:if>
<xsl:if test="surgery_name_13 != ''">
<tr><td class="surgeryText">POD</td>
<td class="surgeryText"><xsl:value-of select="pod_13"/><xsl:if test="pod_13 = ''">0</xsl:if></td>
<td colspan="3"> </td>
<td class="surgeryText"><xsl:value-of select="surgery_name_13"/></td>
</tr></xsl:if>
<xsl:if test="surgery_name_14 != ''">
<tr><td class="surgeryText">POD</td>
<td class="surgeryText"><xsl:value-of select="pod_14"/><xsl:if test="pod_14 = ''">0</xsl:if></td>
<td colspan="3"> </td>
<td class="surgeryText"><xsl:value-of select="surgery_name_14"/></td>
</tr></xsl:if>
<xsl:if test="surgery_name_15 != ''">
<tr><td class="surgeryText">POD</td>
<td class="surgeryText"><xsl:value-of select="pod_15"/><xsl:if test="pod_15 = ''">0</xsl:if></td>
<td colspan="3"> </td>
<td class="surgeryText"><xsl:value-of select="surgery_name_15"/></td>
</tr></xsl:if>
<xsl:if test="surgery_name_16 != ''">
<tr><td class="surgeryText">POD</td>
<td class="surgeryText"><xsl:value-of select="pod_16"/><xsl:if test="pod_16 = ''">0</xsl:if></td>
<td colspan="3"> </td>
<td class="surgeryText"><xsl:value-of select="surgery_name_16"/></td>
</tr></xsl:if>
<xsl:if test="surgery_name_17 != ''">
<tr><td class="surgeryText">POD</td>
<td class="surgeryText"><xsl:value-of select="pod_17"/><xsl:if test="pod_17 = ''">0</xsl:if></td>
<td colspan="3"> </td>
<td class="surgeryText"><xsl:value-of select="surgery_name_17"/></td>
</tr></xsl:if>
<xsl:if test="surgery_name_18 != ''">
<tr><td class="surgeryText">POD</td>
<td class="surgeryText"><xsl:value-of select="pod_18"/><xsl:if test="pod_18 = ''">0</xsl:if></td>
<td colspan="3"> </td>
<td class="surgeryText"><xsl:value-of select="surgery_name_18"/></td>
</tr></xsl:if>
<xsl:if test="surgery_name_19 != ''">
<tr><td class="surgeryText">POD</td>
<td class="surgeryText"><xsl:value-of select="pod_19"/><xsl:if test="pod_19 = ''">0</xsl:if></td>
<td colspan="3"> </td>
<td class="surgeryText"><xsl:value-of select="surgery_name_19"/></td>
</tr></xsl:if>
<xsl:if test="surgery_name_20 != ''">
<tr><td class="surgeryText">POD</td>
<td class="surgeryText"><xsl:value-of select="pod_20"/><xsl:if test="pod_20 = ''">0</xsl:if></td>
<td colspan="3"> </td>
<td class="surgeryText"><xsl:value-of select="surgery_name_20"/></td>
</tr></xsl:if>
<xsl:if test="surgery_name_21 != ''">
<tr><td class="surgeryText">POD</td>
<td class="surgeryText"><xsl:value-of select="pod_21"/><xsl:if test="pod_21 = ''">0</xsl:if></td>
<td colspan="3"> </td>
<td class="surgeryText"><xsl:value-of select="surgery_name_21"/></td>
</tr></xsl:if>
<xsl:if test="surgery_name_22 != ''">
<tr><td class="surgeryText">POD</td>
<td class="surgeryText"><xsl:value-of select="pod_22"/><xsl:if test="pod_22 = ''">0</xsl:if></td>
<td colspan="3"> </td>
<td class="surgeryText"><xsl:value-of select="surgery_name_22"/></td>
</tr></xsl:if>
<xsl:if test="surgery_name_23 != ''">
<tr><td class="surgeryText">POD</td>
<td class="surgeryText"><xsl:value-of select="pod_23"/><xsl:if test="pod_23 = ''">0</xsl:if></td>
<td colspan="3"> </td>
<td class="surgeryText"><xsl:value-of select="surgery_name_23"/></td>
</tr></xsl:if>
<xsl:if test="surgery_name_24 != ''">
<tr><td class="surgeryText">POD</td>
<td class="surgeryText"><xsl:value-of select="pod_24"/><xsl:if test="pod_24 = ''">0</xsl:if></td>
<td colspan="3"> </td>
<td class="surgeryText"><xsl:value-of select="surgery_name_24"/></td>
</tr></xsl:if>
<xsl:if test="surgery_name_25 != ''">
<tr><td class="surgeryText">POD</td>
<td class="surgeryText"><xsl:value-of select="pod_25"/><xsl:if test="pod_25 = ''">0</xsl:if></td>
<td colspan="3"> </td>
<td class="surgeryText"><xsl:value-of select="surgery_name_25"/></td>
</tr></xsl:if>

<!-- do this 6 times, for surgery_1-6 -->
<!-- redcap_event_name == surgery_1-6_arm_1-->
<xsl:if test="sub_surgery_name_1 != ''">
<tr><td style="width:3em;" class="surgeryText">POD</td>
<td align="left" class="surgeryText" style="position:relative; left:0;"><xsl:value-of select="sub_pod_1"/><xsl:if test="sub_pod_1 = ''">0</xsl:if></td>
<td colspan="3"> </td>
<td class="surgeryText"><xsl:value-of select="sub_surgery_name_1"/></td>
</tr></xsl:if>
<xsl:if test="sub_surgery_name_2 != ''">
<tr><td class="surgeryText">POD</td>
<td class="surgeryText"><xsl:value-of select="sub_pod_2"/><xsl:if test="sub_pod_2 = ''">0</xsl:if></td>
<td colspan="3"> </td>
<td class="surgeryText"><xsl:value-of select="sub_surgery_name_2"/></td>
</tr></xsl:if>
<xsl:if test="sub_surgery_name_3 != ''">
<tr><td class="surgeryText">POD</td>
<td class="surgeryText"><xsl:value-of select="sub_pod_3"/><xsl:if test="sub_pod_3 = ''">0</xsl:if></td>
<td colspan="3"> </td>
<td class="surgeryText"><xsl:value-of select="sub_surgery_name_3"/></td>
</tr></xsl:if>
<xsl:if test="sub_surgery_name_4 != ''">
<tr><td class="surgeryText">POD</td>
<td class="surgeryText"><xsl:value-of select="sub_pod_4"/><xsl:if test="sub_pod_4 = ''">0</xsl:if></td>
<td colspan="3"> </td>
<td class="surgeryText"><xsl:value-of select="sub_surgery_name_4"/></td>
</tr></xsl:if>
<xsl:if test="sub_surgery_name_5 != ''">
<tr><td class="surgeryText">POD</td>
<td class="surgeryText"><xsl:value-of select="sub_pod_5"/><xsl:if test="sub_pod_5 = ''">0</xsl:if></td>
<td colspan="3"> </td>
<td class="surgeryText"><xsl:value-of select="sub_surgery_name_5"/></td>
</tr></xsl:if>

</table>
</xsl:if>
</xsl:for-each>
</td>
<xsl:if test="enterable_notes != ''">
<td colspan="3" class="notes" align="left" valign="top">
<p class="notes"><xsl:value-of select="enterable_notes" /></p>
</td></xsl:if>
</tr>
</table>
</tr>
</div>
</xsl:if>
</xsl:if>
<!--<div class="page-break"></div>-->
</xsl:template>


</xsl:stylesheet >

