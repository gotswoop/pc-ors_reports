<!DOCTYPE html>
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform">
    <xsl:output method="html"/>
	<xsl:template match ="/">
		    <!--[if IE 9]><html class="lt-ie10" lang="en" > <![endif]-->
        <html class="no-js" lang="en" >
			<head>
                <meta charset="utf-8"/>
                <meta name="viewport" content="width=device-width, initial-scale=1.0"/>

                <link rel="stylesheet" href="css/normalize.css"/>
                <link rel="stylesheet" href="css/foundation.css"/>
                <link rel="stylesheet" href="css/app.css"/>
                <!-- display none on screen, @media screen -->
				<link rel="stylesheet" href="orslegacy.css" media="screen"/>
				<!-- <link rel="stylesheet" href="orslegacy.css" media="print"/>-->
				<title>Billing Reports - Patient Care ORS</title>
                <script src="js/vendor/modernizr.js">&#160;</script>
                <script src="reports/orsbilling/setup.js">&#160;</script>
                <script>
                    function toggleChecked(elem) {
                        /*if(!$(elem).parent().parent().parent().hasClass("recordhidden")) {
                            $(elem).parent().parent().parent().hide();
                            $(elem).parent().parent().parent().prev().show();
                            $(elem).attr("checked",false);
                        }
                        else {
                            $(elem).attr("checked",true);
                            $(elem).parent().parent().hide();
                            $(elem).parent().parent().next().show();
                        }*/
                    }

                    function loadXMLDoc() /* kirupa.com */
                    {
                        var xmlhttp;
                        var pageToDisplay = 'reports/orsbilling/setup.php?pid=87'; // Update PID if project moves

                        if (window.XMLHttpRequest) {
                            xmlhttp = new XMLHttpRequest();
                        } else {
                            xmlhttp = new ActiveXObject("Microsoft.XMLHTTP");
                        }
                
                        xmlhttp.onreadystatechange = function () {
                            if (xmlhttp.readyState == 4)
                                if (xmlhttp.status == 200) {
                                    document.getElementById("subcontent").innerHTML = xmlhttp.responseText;
                                }
                        }

                        xmlhttp.open("GET", pageToDisplay, true);
                        xmlhttp.send();
                    }   
                </script>
			</head>
			<body>
    			<h4>Billing Worklists</h4>
    			<p>This page shows all bills that have been routed to you (<xsl:value-of select="/records/@username"/>). Click the Edit button next to a record to modify the billing informaton in a new window, then <b>close that window</b> and move down to the next record.</p>
			    <ul class="tabs" data-tab="">
			        <li class="tab-title active"><a href="#userpanel">My Worklist</a></li>
			        <li class="tab-title"><a href="#alluserspanel">Incomplete Bills</a></li>
			        <li class="tab-title"><a href="#completepanel">Complete Bills</a></li>
              <li class="tab-title"><a href="#setuppanel" onclick="loadXMLDoc();">Setup</a></li>
			    </ul>
			    <div class="tabs-content">
			        <div class="content active" id="userpanel">
                           
                  <!--         
    			        <form>
        				<xsl:apply-templates select="/records/item[routing!='' and contains(routing_record_users,concat(',',/records/@username,','))]" mode="personal"/>
        				</form>
        				<xsl:if test="not (/records/item[routing!='' and contains(routing_record_users,concat(',',/records/@username,','))])">
        				    No records have been routed to you.
        				</xsl:if>
                </form>
                -->
                 <form>
                
                <xsl:if test="records/@username = 'lmerritt' or records/@username = 'lstewart2'
                 ">
                <fieldset style="background-color:#D0DBF7;">
                <legend>IDX Entry</legend>
                <xsl:apply-templates select="/records/item[routing!='' and routing_users = ',lstewart2,lmerritt,'] | 
                /records/item[routing!='' and routing2_users = ',lstewart2,lmerritt,'] |
                /records/item[routing!='' and routing3_users = ',lstewart2,lmerritt,'] |
                /records/item[routing!='' and routing4_users = ',lstewart2,lmerritt,'] |
                /records/item[routing!='' and routing5_users = ',lstewart2,lmerritt,'] |
                /records/item[routing!='' and routing6_users = ',lstewart2,lmerritt,'] |
                /records/item[routing!='' and routing7_users = ',lstewart2,lmerritt,'] |
                /records/item[routing!='' and routing8_users = ',lstewart2,lmerritt,'] |
                /records/item[routing!='' and routing9_users = ',lstewart2,lmerritt,'] |
                /records/item[routing!='' and routing10_users = ',lstewart2,lmerritt,'] " mode="personal"/>
                </fieldset>
                </xsl:if>
                
                
              <!--  <xsl:if test="/records/item[routing!='' and contains(routing_record_users,concat(',',/records/@username,',')) and routing_record_users != concat(',',/records/@username,',INCOMPLETE,') and routing_record_users != concat(',',/records/@username,',COMPLETE,')]"> -->
                
               
                <xsl:if test="records/@username = 'lmerritt' or records/@username = 'lstewart2'
                 ">
                <fieldset style="background-color:#F5E5CB;">
                <legend><xsl:value-of select="/records/@username"/></legend>
                <xsl:apply-templates select="/records/item[routing!='' and routing_users = (concat(',',/records/@username,','))] | 
                /records/item[routing!='' and routing2_users = (concat(',',/records/@username,','))] |
                /records/item[routing!='' and routing3_users = (concat(',',/records/@username,','))] |
                /records/item[routing!='' and routing4_users = (concat(',',/records/@username,','))] |
                /records/item[routing!='' and routing5_users = (concat(',',/records/@username,','))] |
                /records/item[routing!='' and routing6_users = (concat(',',/records/@username,','))] |
                /records/item[routing!='' and routing7_users = (concat(',',/records/@username,','))] |
                /records/item[routing!='' and routing8_users = (concat(',',/records/@username,','))] |
                /records/item[routing!='' and routing9_users = (concat(',',/records/@username,','))] |
                /records/item[routing!='' and routing10_users = (concat(',',/records/@username,','))] " mode="personal"/>
                </fieldset>
                </xsl:if>
                
                <xsl:if test="records/@username != 'lmerritt' and records/@username != 'lstewart2'">
                <fieldset style="background-color:#F5E5CB;">
                <legend><xsl:value-of select="/records/@username"/></legend>
                <xsl:apply-templates select="/records/item[routing!='' and contains(routing_record_users,concat(',',/records/@username,','))]" mode="personal"/>
                </fieldset>
                </xsl:if>
                
                <xsl:if test="not (/records/item[routing!='' and contains(routing_record_users,concat(',',/records/@username,','))])">
        				    No records have been routed to you.
        				</xsl:if>
            </form>
                
    				</div>
    				<div class="content" id="alluserspanel">
                        <form>
                        <xsl:apply-templates select="/records/item[routing!='' and routing_users != '' and contains(routing_record_users,',INCOMPLETE,')]" mode="incomplete"/>
                        </form>
    				</div>
    				<div class="content" id="completepanel">
                        <form>
                        <xsl:apply-templates select="/records/item[contains(routing_record_users,',COMPLETE,')]" mode="complete"/>
                        </form>
    				</div>
                    <div class="content" id="setuppanel">
                        This panel will enable you to view / update billing groups.<br/>
                        <!--<h5>Current Routes</h5>
                        <table role="grid" style="width: 50%">
                            <tr><th>Target</th><th>Username(s)</th></tr>
                            <tr><td>Data Entry (Letha - Lena)</td><td>lstewart2,lmerritt</td></tr>
                            <tr><td>Becky</td><td>rwright3</td></tr>
                            <tr><td>Gloria</td><td>ghinojosa</td></tr>
                            <tr><td>Patti</td><td>pgarcia2</td></tr>
                            <tr><td>Susan</td><td>sposten</td></tr>
                            <tr><td>Stephanie - Kara</td><td>ssalazar,kdavis17</td></tr>
                            <tr><td>Kara</td><td>kdavis17</td></tr>
                            <tr><td>Kelly Ryan</td><td>kryan</td></tr>
                        </table>-->
                        <div id="subcontent">&#160;</div>
                    </div>
				</div>

                <script src="js/vendor/jquery.js">&#160;</script>
                <script src="js/foundation.min.js">&#160;</script>
                <script>
                    $(document).foundation();
                </script>
			</body>
		</html>
	</xsl:template>
  
    <xsl:template match="item" mode="summary">
        <div class="small-12 medium-12 large-3 column">
        <span class="dlabel">Patient: </span><span>
            <xsl:for-each select="/records/item[registry_id=current()/registry_id]">
             <xsl:value-of select="patient_last"/>
             </xsl:for-each>,
             <xsl:for-each select="/records/item[registry_id=current()/registry_id]">
             <xsl:value-of select="patient_first"/>
             </xsl:for-each>
             </span>
             <br/>
             <span class="dlabel">DOB: </span><span>
               <xsl:for-each select="/records/item[registry_id=current()/registry_id]">
             <xsl:value-of select="dob"/>
             </xsl:for-each>
             </span><br/>
            <span class="dlabel">Consultaton: </span><span><xsl:value-of select="billing_consult"/></span><br/>
            <span class="dlabel">IDX / Allscripts ID: </span><span><xsl:value-of select="billing_idx_mrn"/></span><br/>
            <span class="dlabel">Insurance: </span><span><xsl:value-of select="billing_ins"/></span><br/>
        </div>
    </xsl:template>

	<xsl:template match="item" mode="personal"> 

    <xsl:if test="((/records/@username = 'lmerritt') and (contains(billing_surgeon,'Achor') or contains(billing_surgeon,'Burgess') or contains(billing_surgeon,'Choo') or contains(billing_surgeon,'Harvin')
                                                      or contains(billing_surgeon2,'Achor') or contains(billing_surgeon2,'Burgess') or contains(billing_surgeon2,'Choo')or contains(billing_surgeon2,'Harvin')
                                                      or contains(billing_surgeon3,'Achor') or contains(billing_surgeon3,'Burgess') or contains(billing_surgeon3,'Choo')or contains(billing_surgeon3,'Harvin')
                                                      or contains(billing_surgeon4,'Achor') or contains(billing_surgeon4,'Burgess') or contains(billing_surgeon4,'Choo')or contains(billing_surgeon4,'Harvin')
                                                      or contains(billing_surgeon5,'Achor') or contains(billing_surgeon5,'Burgess') or contains(billing_surgeon5,'Choo')or contains(billing_surgeon5,'Harvin')
                                                      or contains(billing_surgeon6,'Achor') or contains(billing_surgeon6,'Burgess') or contains(billing_surgeon6,'Choo')or contains(billing_surgeon6,'Harvin')
                                                      or contains(billing_surgeon7,'Achor') or contains(billing_surgeon7,'Burgess') or contains(billing_surgeon7,'Choo')or contains(billing_surgeon7,'Harvin')
                                                      or contains(billing_surgeon8,'Achor') or contains(billing_surgeon8,'Burgess') or contains(billing_surgeon8,'Choo')or contains(billing_surgeon8,'Harvin')
                                                      or contains(billing_surgeon9,'Achor') or contains(billing_surgeon9,'Burgess') or contains(billing_surgeon9,'Choo')or contains(billing_surgeon9,'Harvin')
                                                      or contains(billing_surgeon10,'Achor') or contains(billing_surgeon10,'Burgess') or contains(billing_surgeon10,'Choo') or contains(billing_surgeon10,'Harvin'))) or 
                ((/records/@username = 'lstewart2') 
                          and (contains(billing_surgeon,'Gary') or  contains(billing_surgeon,'Munz') or contains(billing_surgeon,'Prasarn') or contains(billing_surgeon,'Routt') or contains(billing_surgeon,'Tiffany')
                          or contains(billing_surgeon2,'Gary') or  contains(billing_surgeon2,'Munz') or contains(billing_surgeon2,'Prasarn') or contains(billing_surgeon2,'Routt') or contains(billing_surgeon2,'Tiffany')
                          or contains(billing_surgeon3,'Gary') or  contains(billing_surgeon3,'Munz') or contains(billing_surgeon3,'Prasarn') or contains(billing_surgeon3,'Routt') or contains(billing_surgeon3,'Tiffany')
                          or contains(billing_surgeon4,'Gary') or  contains(billing_surgeon4,'Munz') or contains(billing_surgeon4,'Prasarn') or contains(billing_surgeon4,'Routt') or contains(billing_surgeon4,'Tiffany')
                          or contains(billing_surgeon5,'Gary') or  contains(billing_surgeon5,'Munz') or contains(billing_surgeon5,'Prasarn') or contains(billing_surgeon5,'Routt') or contains(billing_surgeon5,'Tiffany')
                          or contains(billing_surgeon6,'Gary') or  contains(billing_surgeon6,'Munz') or contains(billing_surgeon6,'Prasarn') or contains(billing_surgeon6,'Routt') or contains(billing_surgeon6,'Tiffany')
                          or contains(billing_surgeon7,'Gary') or  contains(billing_surgeon7,'Munz') or contains(billing_surgeon7,'Prasarn') or contains(billing_surgeon7,'Routt') or contains(billing_surgeon7,'Tiffany')
                          or contains(billing_surgeon8,'Gary') or  contains(billing_surgeon8,'Munz') or contains(billing_surgeon8,'Prasarn') or contains(billing_surgeon8,'Routt') or contains(billing_surgeon8,'Tiffany')
                          or contains(billing_surgeon9,'Gary') or  contains(billing_surgeon9,'Munz') or contains(billing_surgeon9,'Prasarn') or contains(billing_surgeon9,'Routt') or contains(billing_surgeon9,'Tiffany')
                          or contains(billing_surgeon10,'Gary') or  contains(billing_surgeon10,'Munz') or contains(billing_surgeon10,'Prasarn') or contains(billing_surgeon10,'Routt') or contains(billing_surgeon10,'Tiffany'))) or (/records/@username != 'lstewart2' and /records/@username != 'lmerritt')">  

	    <fieldset class="recordhidden" style="background-color:white;">
	        <legend>Record <xsl:value-of select="registry_id"/></legend>
	        Work complete. Click to show.
            <div style="float:right; text-decoration:line-through;">
                <input type="checkbox" onclick="toggleChecked(this);this.checked='checked';">Done!</input>
            </div>
	    </fieldset>
	    <fieldset class="record" style="background-color:white;">
	    <legend>Record <xsl:value-of select="registry_id"/></legend>
	    <div class="record rows">
	    <xsl:apply-templates select="." mode="summary"/>
        <div class="small-12 medium-12 large-8 column">
            <table class="bills">
                <tr>
                    <th style="text-align:center;" width="20">#</th><th width="100px" style="text-align:center"><span class="dlabel">Date of Service</span></th><th width="100px" style="text-align:center"><span class="tablegreentext dlabel">Received by Billing</span></th><th width="150px" style="text-align:center"><span class="pink dlabel">Completed by CODING</span></th><th width="100px" style="text-align:center"><span class="redtext dlabel">Finished by Billing</span></th><th width="150px" style="text-align:center"><span class="dlabel">Surgeon</span></th>
                </tr>

                <xsl:if test="contains(routing_users,concat(',',/records/@username,','))">
                
                <tr>
                    <td><span>1</span></td>
                    <td><span><xsl:value-of select="billing_date"/></span></td>
                    <td><span><xsl:value-of select="billing_date_rec"/></span></td>
                    <td><span><xsl:value-of select="billing_date_cod"/></span></td>
                    <td><span><xsl:value-of select="billing_date_end"/></span></td>
	                  <td>
                    <xsl:choose>
                    <xsl:when test="contains(billing_surgeon, 'Achor')">
                        <span class="bluetext"><xsl:value-of select="billing_surgeon"/></span>
                    </xsl:when>
                    <xsl:when test="contains(billing_surgeon, 'Gary')">
                        <span class="orangetext"><xsl:value-of select="billing_surgeon"/></span>
                    </xsl:when>
                    <xsl:when test="contains(billing_surgeon, 'Choo')">
                        <span class="yellowtext"><xsl:value-of select="billing_surgeon"/></span>
                    </xsl:when>
                    <xsl:when test="contains(billing_surgeon, 'Munz')">
                        <span class="greentext"><xsl:value-of select="billing_surgeon"/></span>
                    </xsl:when>
                    <xsl:when test="contains(billing_surgeon, 'Prasarn')">
                        <span class="lightbluetext"><xsl:value-of select="billing_surgeon"/></span>
                    </xsl:when>
                    <xsl:when test="contains(billing_surgeon, 'Harvin')">
                        <span class="purpletext"><xsl:value-of select="billing_surgeon"/></span>
                    </xsl:when>
                    <xsl:when test="contains(billing_surgeon, 'Burgess')">
                        <span class="brightredtext"><xsl:value-of select="billing_surgeon"/></span>
                    </xsl:when>
                    <xsl:otherwise>
                        <span><xsl:value-of select="billing_surgeon"/></span>
                    </xsl:otherwise>
                    </xsl:choose>
                    </td>
                </tr>
               </xsl:if> 
                <xsl:if test="contains(routing2_users,concat(',',/records/@username,','))">
                <tr>
                    <td><span>2</span></td>
                    <td><span><xsl:value-of select="billing_date2"/></span></td>
                    <td><span><xsl:value-of select="billing_date_rec2"/></span></td>
                    <td><span><xsl:value-of select="billing_date_cod2"/></span></td>
                    <td><span><xsl:value-of select="billing_date_end2"/></span></td> 
                    <td>
                    <xsl:choose>
                    <xsl:when test="contains(billing_surgeon2, 'Achor')">
                        <span class="bluetext"><xsl:value-of select="billing_surgeon2"/></span>
                    </xsl:when>
                    <xsl:when test="contains(billing_surgeon2, 'Gary')">
                        <span class="orangetext"><xsl:value-of select="billing_surgeon2"/></span>
                    </xsl:when>
                    <xsl:when test="contains(billing_surgeon2, 'Choo')">
                        <span class="yellowtext"><xsl:value-of select="billing_surgeon2"/></span>
                    </xsl:when>
                    <xsl:when test="contains(billing_surgeon2, 'Munz')">
                        <span class="greentext"><xsl:value-of select="billing_surgeon2"/></span>
                    </xsl:when>
                     <xsl:when test="contains(billing_surgeon, 'Prasarn')">
                        <span class="lightbluetext"><xsl:value-of select="billing_surgeon2"/></span>
                    </xsl:when>
                    <xsl:when test="contains(billing_surgeon, 'Harvin')">
                        <span class="purpletext"><xsl:value-of select="billing_surgeon2"/></span>
                    </xsl:when>
                    <xsl:when test="contains(billing_surgeon, 'Burgess')">
                        <span class="brightredtext"><xsl:value-of select="billing_surgeon2"/></span>
                    </xsl:when>
                    <xsl:otherwise>
                        <span><xsl:value-of select="billing_surgeon2"/></span>
                    </xsl:otherwise>
                    </xsl:choose>
                    </td>
                </tr>
                </xsl:if>
                <xsl:if test="contains(routing3_users,concat(',',/records/@username,','))">
                <tr>
                    <td><span>3</span></td>
                    <td><span><xsl:value-of select="billing_date3"/></span></td>
                    <td><span><xsl:value-of select="billing_date_rec3"/></span></td>
                    <td><span><xsl:value-of select="billing_date_cod3"/></span></td>
                    <td><span><xsl:value-of select="billing_date_end3"/></span></td>
                    <td>
                    <xsl:choose>
                    <xsl:when test="contains(billing_surgeon3, 'Achor')">
                        <span class="bluetext"><xsl:value-of select="billing_surgeon3"/></span>
                    </xsl:when>
                    <xsl:when test="contains(billing_surgeon3, 'Gary')">
                        <span class="orangetext"><xsl:value-of select="billing_surgeon3"/></span>
                    </xsl:when>
                    <xsl:when test="contains(billing_surgeon3, 'Choo')">
                        <span class="yellowtext"><xsl:value-of select="billing_surgeon3"/></span>
                    </xsl:when>
                    <xsl:when test="contains(billing_surgeon3, 'Munz')">
                        <span class="greentext"><xsl:value-of select="billing_surgeon3"/></span>
                    </xsl:when>
                     <xsl:when test="contains(billing_surgeon3, 'Prasarn')">
                        <span class="lightbluetext"><xsl:value-of select="billing_surgeon3"/></span>
                    </xsl:when>
                    <xsl:when test="contains(billing_surgeon3, 'Harvin')">
                        <span class="purpletext"><xsl:value-of select="billing_surgeon3"/></span>
                    </xsl:when>
                    <xsl:when test="contains(billing_surgeon3, 'Burgess')">
                        <span class="brightredtext"><xsl:value-of select="billing_surgeon3"/></span>
                    </xsl:when>
                    <xsl:otherwise>
                        <span><xsl:value-of select="billing_surgeon3"/></span>
                    </xsl:otherwise>
                    </xsl:choose>
                    </td>
                </tr>
                </xsl:if>
                <xsl:if test="contains(routing4_users,concat(',',/records/@username,','))">
                <tr>
                    <td><span>4</span></td>
                    <td><span><xsl:value-of select="billing_date4"/></span></td>
                    <td><span><xsl:value-of select="billing_date_rec4"/></span></td>
                    <td><span><xsl:value-of select="billing_date_cod4"/></span></td>
                    <td><span><xsl:value-of select="billing_date_end4"/></span></td>
                    <td>
                    <xsl:choose>
                    <xsl:when test="contains(billing_surgeon4, 'Achor')">
                        <span class="bluetext"><xsl:value-of select="billing_surgeon4"/></span>
                    </xsl:when>
                    <xsl:when test="contains(billing_surgeon4, 'Gary')">
                        <span class="orangetext"><xsl:value-of select="billing_surgeon4"/></span>
                    </xsl:when>
                    <xsl:when test="contains(billing_surgeon4, 'Choo')">
                        <span class="yellowtext"><xsl:value-of select="billing_surgeon4"/></span>
                    </xsl:when>
                    <xsl:when test="contains(billing_surgeon4, 'Munz')">
                        <span class="greentext"><xsl:value-of select="billing_surgeon4"/></span>
                    </xsl:when>
                     <xsl:when test="contains(billing_surgeon4, 'Prasarn')">
                        <span class="lightbluetext"><xsl:value-of select="billing_surgeon4"/></span>
                    </xsl:when>
                    <xsl:when test="contains(billing_surgeon4, 'Harvin')">
                        <span class="purpletext"><xsl:value-of select="billing_surgeon4"/></span>
                    </xsl:when>
                    <xsl:when test="contains(billing_surgeon4, 'Burgess')">
                        <span class="brightredtext"><xsl:value-of select="billing_surgeon4"/></span>
                    </xsl:when>
                    <xsl:otherwise>
                        <span><xsl:value-of select="billing_surgeon4"/></span>
                    </xsl:otherwise>
                    </xsl:choose>
                    </td>
                </tr>
                </xsl:if>
                <xsl:if test="contains(routing5_users,concat(',',/records/@username,','))">
                <tr>
                    <td><span>5</span></td>
                    <td><span><xsl:value-of select="billing_date5"/></span></td>
                    <td><span><xsl:value-of select="billing_date_rec5"/></span></td>
                    <td><span><xsl:value-of select="billing_date_cod5"/></span></td>
                    <td><span><xsl:value-of select="billing_date_end5"/></span></td>
                    <td>
                    <xsl:choose>
                    <xsl:when test="contains(billing_surgeon5, 'Achor')">
                        <span class="bluetext"><xsl:value-of select="billing_surgeon5"/></span>
                    </xsl:when>
                    <xsl:when test="contains(billing_surgeon5, 'Gary')">
                        <span class="orangetext"><xsl:value-of select="billing_surgeon5"/></span>
                    </xsl:when>
                    <xsl:when test="contains(billing_surgeon5, 'Choo')">
                        <span class="yellowtext"><xsl:value-of select="billing_surgeon5"/></span>
                    </xsl:when>
                    <xsl:when test="contains(billing_surgeon5, 'Munz')">
                        <span class="greentext"><xsl:value-of select="billing_surgeon5"/></span>
                    </xsl:when>
                     <xsl:when test="contains(billing_surgeon5, 'Prasarn')">
                        <span class="lightbluetext"><xsl:value-of select="billing_surgeon5"/></span>
                    </xsl:when>
                    <xsl:when test="contains(billing_surgeon5, 'Harvin')">
                        <span class="purpletext"><xsl:value-of select="billing_surgeon5"/></span>
                    </xsl:when>
                    <xsl:when test="contains(billing_surgeon5, 'Burgess')">
                        <span class="brightredtext"><xsl:value-of select="billing_surgeon5"/></span>
                    </xsl:when>
                    <xsl:otherwise>
                        <span><xsl:value-of select="billing_surgeon5"/></span>
                    </xsl:otherwise>
                    </xsl:choose>
                    </td>
                </tr>
                </xsl:if>
                <xsl:if test="contains(routing6_users,concat(',',/records/@username,','))">
                <tr>
                    <td><span>6</span></td>
                    <td><span><xsl:value-of select="billing_date6"/></span></td>
                    <td><span><xsl:value-of select="billing_date_rec6"/></span></td>
                    <td><span><xsl:value-of select="billing_date_cod6"/></span></td>
                    <td><span><xsl:value-of select="billing_date_end6"/></span></td>
                    <td>
                    <xsl:choose>
                    <xsl:when test="contains(billing_surgeon6, 'Achor')">
                        <span class="bluetext"><xsl:value-of select="billing_surgeon6"/></span>
                    </xsl:when>
                    <xsl:when test="contains(billing_surgeon6, 'Gary')">
                        <span class="orangetext"><xsl:value-of select="billing_surgeon6"/></span>
                    </xsl:when>
                    <xsl:when test="contains(billing_surgeon6, 'Choo')">
                        <span class="yellowtext"><xsl:value-of select="billing_surgeon6"/></span>
                    </xsl:when>
                    <xsl:when test="contains(billing_surgeon6, 'Munz')">
                        <span class="greentext"><xsl:value-of select="billing_surgeon6"/></span>
                    </xsl:when>
                     <xsl:when test="contains(billing_surgeon6, 'Prasarn')">
                        <span class="lightbluetext"><xsl:value-of select="billing_surgeon6"/></span>
                    </xsl:when>
                    <xsl:when test="contains(billing_surgeon6, 'Harvin')">
                        <span class="purpletext"><xsl:value-of select="billing_surgeon6"/></span>
                    </xsl:when>
                    <xsl:when test="contains(billing_surgeon6, 'Burgess')">
                        <span class="brightredtext"><xsl:value-of select="billing_surgeon6"/></span>
                    </xsl:when>
                    <xsl:otherwise>
                        <span><xsl:value-of select="billing_surgeon6"/></span>
                    </xsl:otherwise>
                    </xsl:choose>
                    </td>>
                </tr>
                </xsl:if>
                <xsl:if test="contains(routing7_users,concat(',',/records/@username,','))">
                <tr>
                    <td><span>7</span></td>
                    <td><span><xsl:value-of select="billing_date7"/></span></td>
                    <td><span><xsl:value-of select="billing_date_rec7"/></span></td>
                    <td><span><xsl:value-of select="billing_date_cod7"/></span></td>
                    <td><span><xsl:value-of select="billing_date_end7"/></span></td>
                    <td>
                    <xsl:choose>
                    <xsl:when test="contains(billing_surgeon7, 'Achor')">
                        <span class="bluetext"><xsl:value-of select="billing_surgeon7"/></span>
                    </xsl:when>
                    <xsl:when test="contains(billing_surgeon7, 'Gary')">
                        <span class="orangetext"><xsl:value-of select="billing_surgeon7"/></span>
                    </xsl:when>
                    <xsl:when test="contains(billing_surgeon7, 'Choo')">
                        <span class="yellowtext"><xsl:value-of select="billing_surgeon7"/></span>
                    </xsl:when>
                    <xsl:when test="contains(billing_surgeon7, 'Munz')">
                        <span class="greentext"><xsl:value-of select="billing_surgeon7"/></span>
                    </xsl:when>
                     <xsl:when test="contains(billing_surgeon7, 'Prasarn')">
                        <span class="lightbluetext"><xsl:value-of select="billing_surgeon7"/></span>
                    </xsl:when>
                    <xsl:when test="contains(billing_surgeon7, 'Harvin')">
                        <span class="purpletext"><xsl:value-of select="billing_surgeon7"/></span>
                    </xsl:when>
                    <xsl:when test="contains(billing_surgeon7, 'Burgess')">
                        <span class="brightredtext"><xsl:value-of select="billing_surgeon7"/></span>
                    </xsl:when>
                    <xsl:otherwise>
                        <span><xsl:value-of select="billing_surgeon7"/></span>
                    </xsl:otherwise>
                    </xsl:choose>
                    </td>
                </tr>
                </xsl:if>
                <xsl:if test="contains(routing8_users,concat(',',/records/@username,','))">
                <tr>
                    <td><span>8</span></td>
                    <td><span><xsl:value-of select="billing_date8"/></span></td>
                    <td><span><xsl:value-of select="billing_date_rec8"/></span></td>
                    <td><span><xsl:value-of select="billing_date_cod8"/></span></td>
                    <td><span><xsl:value-of select="billing_date_end8"/></span></td>
                    <td>
                    <xsl:choose>
                    <xsl:when test="contains(billing_surgeon8, 'Achor')">
                        <span class="bluetext"><xsl:value-of select="billing_surgeon8"/></span>
                    </xsl:when>
                    <xsl:when test="contains(billing_surgeon8, 'Gary')">
                        <span class="orangetext"><xsl:value-of select="billing_surgeon8"/></span>
                    </xsl:when>
                    <xsl:when test="contains(billing_surgeon8, 'Choo')">
                        <span class="yellowtext"><xsl:value-of select="billing_surgeon8"/></span>
                    </xsl:when>
                    <xsl:when test="contains(billing_surgeon8, 'Munz')">
                        <span class="greentext"><xsl:value-of select="billing_surgeon8"/></span>
                    </xsl:when>
                     <xsl:when test="contains(billing_surgeon8, 'Prasarn')">
                        <span class="lightbluetext"><xsl:value-of select="billing_surgeon8"/></span>
                    </xsl:when>
                    <xsl:when test="contains(billing_surgeon8, 'Harvin')">
                        <span class="purpletext"><xsl:value-of select="billing_surgeon8"/></span>
                    </xsl:when>
                    <xsl:when test="contains(billing_surgeon8, 'Burgess')">
                        <span class="brightredtext"><xsl:value-of select="billing_surgeon8"/></span>
                    </xsl:when>
                    <xsl:otherwise>
                        <span><xsl:value-of select="billing_surgeon8"/></span>
                    </xsl:otherwise>
                    </xsl:choose>
                    </td>
                </tr>
                </xsl:if>
                <xsl:if test="contains(routing9_users,concat(',',/records/@username,','))">
                <tr>
                    <td><span>9</span></td>
                    <td><span><xsl:value-of select="billing_date9"/></span></td>
                    <td><span><xsl:value-of select="billing_date_rec9"/></span></td>
                    <td><span><xsl:value-of select="billing_date_cod9"/></span></td>
                    <td><span><xsl:value-of select="billing_date_end9"/></span></td>
                    <td>
                    <xsl:choose>
                    <xsl:when test="contains(billing_surgeon9, 'Achor')">
                        <span class="bluetext"><xsl:value-of select="billing_surgeon9"/></span>
                    </xsl:when>
                    <xsl:when test="contains(billing_surgeon9, 'Gary')">
                        <span class="orangetext"><xsl:value-of select="billing_surgeon9"/></span>
                    </xsl:when>
                    <xsl:when test="contains(billing_surgeon9, 'Choo')">
                        <span class="yellowtext"><xsl:value-of select="billing_surgeon9"/></span>
                    </xsl:when>
                    <xsl:when test="contains(billing_surgeon9, 'Munz')">
                        <span class="greentext"><xsl:value-of select="billing_surgeon9"/></span>
                    </xsl:when>
                     <xsl:when test="contains(billing_surgeon9, 'Prasarn')">
                        <span class="lightbluetext"><xsl:value-of select="billing_surgeon9"/></span>
                    </xsl:when>
                    <xsl:when test="contains(billing_surgeon9, 'Harvin')">
                        <span class="purpletext"><xsl:value-of select="billing_surgeon9"/></span>
                    </xsl:when>
                    <xsl:when test="contains(billing_surgeon9, 'Burgess')">
                        <span class="brightredtext"><xsl:value-of select="billing_surgeon9"/></span>
                    </xsl:when>
                    <xsl:otherwise>
                        <span><xsl:value-of select="billing_surgeon9"/></span>
                    </xsl:otherwise>
                    </xsl:choose>
                    </td>
                </tr>
                </xsl:if>
                <xsl:if test="contains(routing10_users,concat(',',/records/@username,','))">
                <tr>
                    <td><span>10</span></td>
                    <td><span><xsl:value-of select="billing_date10"/></span></td>
                    <td><span><xsl:value-of select="billing_date_rec10"/></span></td>
                    <td><span><xsl:value-of select="billing_date_cod10"/></span></td>
                    <td><span><xsl:value-of select="billing_date_end10"/></span></td>
                    <td>
                    <xsl:choose>
                    <xsl:when test="contains(billing_surgeon10, 'Achor')">
                        <span class="bluetext"><xsl:value-of select="billing_surgeon10"/></span>
                    </xsl:when>
                    <xsl:when test="contains(billing_surgeon10, 'Gary')">
                        <span class="orangetext"><xsl:value-of select="billing_surgeon10"/></span>
                    </xsl:when>
                    <xsl:when test="contains(billing_surgeon10, 'Choo')">
                        <span class="yellowtext"><xsl:value-of select="billing_surgeon10"/></span>
                    </xsl:when>
                    <xsl:when test="contains(billing_surgeon10, 'Munz')">
                        <span class="greentext"><xsl:value-of select="billing_surgeon10"/></span>
                    </xsl:when>
                     <xsl:when test="contains(billing_surgeon10, 'Prasarn')">
                        <span class="lightbluetext"><xsl:value-of select="billing_surgeon10"/></span>
                    </xsl:when>
                    <xsl:when test="contains(billing_surgeon10, 'Harvin')">
                        <span class="purpletext"><xsl:value-of select="billing_surgeon10"/></span>
                    </xsl:when>
                    <xsl:when test="contains(billing_surgeon10, 'Burgess')">
                        <span class="brightredtext"><xsl:value-of select="billing_surgeon10"/></span>
                    </xsl:when>
                    <xsl:otherwise>
                        <span><xsl:value-of select="billing_surgeon10"/></span>
                    </xsl:otherwise>
                    </xsl:choose>
                    </td>
                </tr>
                </xsl:if>
            </table>
        </div>
        </div>
        <div class="rows">
            <div class="small-12 medium-12 large-4 column">&#160;</div>
            <div class="small-12 medium-12 large-8 column">
                <xsl:if test="redcap_event_name = 'consultation_arm_1'">
                      <button class="tiny button" type="button" onclick="window.open('https:\/\/redcap.uth.tmc.edu\/redcap_v5.9.11\/DataEntry\/index.php?pid=87&amp;id={registry_id}&amp;event_id=699&amp;page=billing');">Edit</button>
                    </xsl:if>
                    <xsl:if test="redcap_event_name = 'surgery_1_arm_1'">
                      <button class="tiny button" type="button" onclick="window.open('https:\/\/redcap.uth.tmc.edu\/redcap_v5.9.11\/DataEntry\/index.php?pid=87&amp;id={registry_id}&amp;event_id=720&amp;page=billing');">Edit</button>
                    </xsl:if>
                    <xsl:if test="redcap_event_name = 'surgery_2_arm_1'">
                      <button class="tiny button" type="button" onclick="window.open('https:\/\/redcap.uth.tmc.edu\/redcap_v5.9.11\/DataEntry\/index.php?pid=87&amp;id={registry_id}&amp;event_id=721&amp;page=billing');">Edit</button>
                    </xsl:if>
                    <xsl:if test="redcap_event_name = 'surgery_3_arm_1'">
                      <button class="tiny button" type="button" onclick="window.open('https:\/\/redcap.uth.tmc.edu\/redcap_v5.9.11\/DataEntry\/index.php?pid=87&amp;id={registry_id}&amp;event_id=722&amp;page=billing');">Edit</button>
                    </xsl:if>
                    <xsl:if test="redcap_event_name = 'surgery_4_arm_1'">
                      <button class="tiny button" type="button" onclick="window.open('https:\/\/redcap.uth.tmc.edu\/redcap_v5.9.11\/DataEntry\/index.php?pid=87&amp;id={registry_id}&amp;event_id=723&amp;page=billing');">Edit</button>
                    </xsl:if>
                    <xsl:if test="redcap_event_name = 'surgery_5_arm_1'">
                      <button class="tiny button" type="button" onclick="window.open('https:\/\/redcap.uth.tmc.edu\/redcap_v5.9.11\/DataEntry\/index.php?pid=87&amp;id={registry_id}&amp;event_id=724&amp;page=billing');">Edit</button>
                    </xsl:if>
                    </div>
        </div>
        </fieldset>
        </xsl:if>
	</xsl:template>

    <xsl:template match="item" mode="complete">
        <fieldset class="recordhidden"  style="background-color:white;">
            <legend>Record <xsl:value-of select="registry_id"/></legend>
            Work complete. Click to show.
            <div style="float:right; text-decoration:line-through;">
                <input type="checkbox" onclick="toggleChecked(this);this.checked='checked';">Done!</input>
            </div>
        </fieldset>
        <fieldset class="record" style="background-color:white;">
        <legend>Record <xsl:value-of select="registry_id"/></legend>
        <div class="record rows">
        <xsl:apply-templates select="." mode="summary"/>
        <div class="small-12 medium-12 large-8 column">
            <table class="bills">
                <tr>
                    <th style="text-align:center" width="20" >#</th><th width="100px" style="text-align:center"><span class="dlabel">Date of Service</span></th><th width="100px" style="text-align:center"><span class="tablegreentext dlabel">Received by Billing</span></th><th width="150px" style="text-align:center"><span class="pink dlabel">Completed by CODING</span></th><th width="100px" style="text-align:center"><span class="redtext dlabel">Finished by Billing</span></th><th style="text-align:center" width="150px"><span class="dlabel">Surgeon</span></th>
                </tr>

                <xsl:if test="contains(routing_users,',COMPLETE,')">
                <tr>
                    <td><span>1</span></td>
                    <td><span><xsl:value-of select="billing_date"/></span></td>
                    <td><span><xsl:value-of select="billing_date_rec"/></span></td>
                    <td><span><xsl:value-of select="billing_date_cod"/></span></td>
                    <td><span><xsl:value-of select="billing_date_end"/></span></td>
                    <td>
                    <xsl:choose>
                    <xsl:when test="contains(billing_surgeon, 'Achor')">
                        <span class="bluetext"><xsl:value-of select="billing_surgeon"/></span>
                    </xsl:when>
                    <xsl:when test="contains(billing_surgeon, 'Gary')">
                        <span class="orangetext"><xsl:value-of select="billing_surgeon"/></span>
                    </xsl:when>
                    <xsl:when test="contains(billing_surgeon, 'Choo')">
                        <span class="yellowtext"><xsl:value-of select="billing_surgeon"/></span>
                    </xsl:when>
                    <xsl:when test="contains(billing_surgeon, 'Munz')">
                        <span class="greentext"><xsl:value-of select="billing_surgeon"/></span>
                    </xsl:when>
                     <xsl:when test="contains(billing_surgeon, 'Prasarn')">
                        <span class="lightbluetext"><xsl:value-of select="billing_surgeon"/></span>
                    </xsl:when>
                    <xsl:when test="contains(billing_surgeon, 'Harvin')">
                        <span class="purpletext"><xsl:value-of select="billing_surgeon"/></span>
                    </xsl:when>
                    <xsl:when test="contains(billing_surgeon, 'Burgess')">
                        <span class="brightredtext"><xsl:value-of select="billing_surgeon"/></span>
                    </xsl:when>
                    <xsl:otherwise>
                        <span><xsl:value-of select="billing_surgeon"/></span>
                    </xsl:otherwise>
                    </xsl:choose>
                    </td>
                </tr>
                </xsl:if>
                <xsl:if test="contains(routing2_users,',COMPLETE,')">
                <tr>
                    <td><span>2</span></td>
                    <td><span><xsl:value-of select="billing_date2"/></span></td>
                    <td><span><xsl:value-of select="billing_date_rec2"/></span></td>
                    <td><span><xsl:value-of select="billing_date_cod2"/></span></td>
                    <td><span><xsl:value-of select="billing_date_end2"/></span></td>
                    <td>
                    <xsl:choose>
                    <xsl:when test="contains(billing_surgeon2, 'Achor')">
                        <span class="bluetext"><xsl:value-of select="billing_surgeon2"/></span>
                    </xsl:when>
                    <xsl:when test="contains(billing_surgeon2, 'Gary')">
                        <span class="orangetext"><xsl:value-of select="billing_surgeon2"/></span>
                    </xsl:when>
                    <xsl:when test="contains(billing_surgeon2, 'Choo')">
                        <span class="yellowtext"><xsl:value-of select="billing_surgeon2"/></span>
                    </xsl:when>
                    <xsl:when test="contains(billing_surgeon2, 'Munz')">
                        <span class="greentext"><xsl:value-of select="billing_surgeon2"/></span>
                    </xsl:when>
                     <xsl:when test="contains(billing_surgeon2, 'Prasarn')">
                        <span class="lightbluetext"><xsl:value-of select="billing_surgeon2"/></span>
                    </xsl:when>
                    <xsl:when test="contains(billing_surgeon2, 'Harvin')">
                        <span class="purpletext"><xsl:value-of select="billing_surgeon2"/></span>
                    </xsl:when>
                    <xsl:when test="contains(billing_surgeon2, 'Burgess')">
                        <span class="brightredtext"><xsl:value-of select="billing_surgeon2"/></span>
                    </xsl:when>
                    <xsl:otherwise>
                        <span><xsl:value-of select="billing_surgeon2"/></span>
                    </xsl:otherwise>
                    </xsl:choose>
                    </td>
                </tr>
                </xsl:if>
                <xsl:if test="contains(routing3_users,',COMPLETE,')">
                <tr>
                    <td><span>3</span></td>
                    <td><span><xsl:value-of select="billing_date3"/></span></td>
                    <td><span><xsl:value-of select="billing_date_rec3"/></span></td>
                    <td><span><xsl:value-of select="billing_date_cod3"/></span></td>
                    <td><span><xsl:value-of select="billing_date_end3"/></span></td>
                    <td>
                    <xsl:choose>
                    <xsl:when test="contains(billing_surgeon3, 'Achor')">
                        <span class="bluetext"><xsl:value-of select="billing_surgeon3"/></span>
                    </xsl:when>
                    <xsl:when test="contains(billing_surgeon3, 'Gary')">
                        <span class="orangetext"><xsl:value-of select="billing_surgeon3"/></span>
                    </xsl:when>
                    <xsl:when test="contains(billing_surgeon3, 'Choo')">
                        <span class="yellowtext"><xsl:value-of select="billing_surgeon3"/></span>
                    </xsl:when>
                    <xsl:when test="contains(billing_surgeon3, 'Munz')">
                        <span class="greentext"><xsl:value-of select="billing_surgeon3"/></span>
                    </xsl:when>
                     <xsl:when test="contains(billing_surgeon3, 'Prasarn')">
                        <span class="lightbluetext"><xsl:value-of select="billing_surgeon3"/></span>
                    </xsl:when>
                    <xsl:when test="contains(billing_surgeon3, 'Harvin')">
                        <span class="purpletext"><xsl:value-of select="billing_surgeon3"/></span>
                    </xsl:when>
                    <xsl:when test="contains(billing_surgeon3, 'Burgess')">
                        <span class="brightredtext"><xsl:value-of select="billing_surgeon3"/></span>
                    </xsl:when>
                    <xsl:otherwise>
                        <span><xsl:value-of select="billing_surgeon3"/></span>
                    </xsl:otherwise>
                    </xsl:choose>
                    </td>
                </tr>
                </xsl:if>
                <xsl:if test="contains(routing4_users,',COMPLETE,')">
                <tr>
                    <td><span>4</span></td>
                    <td><span><xsl:value-of select="billing_date4"/></span></td>
                    <td><span><xsl:value-of select="billing_date_rec4"/></span></td>
                    <td><span><xsl:value-of select="billing_date_cod4"/></span></td>
                    <td><span><xsl:value-of select="billing_date_end4"/></span></td>
                    <td>
                    <xsl:choose>
                    <xsl:when test="contains(billing_surgeon4, 'Achor')">
                        <span class="bluetext"><xsl:value-of select="billing_surgeon4"/></span>
                    </xsl:when>
                    <xsl:when test="contains(billing_surgeon4, 'Gary')">
                        <span class="orangetext"><xsl:value-of select="billing_surgeon4"/></span>
                    </xsl:when>
                    <xsl:when test="contains(billing_surgeon4, 'Choo')">
                        <span class="yellowtext"><xsl:value-of select="billing_surgeon4"/></span>
                    </xsl:when>
                    <xsl:when test="contains(billing_surgeon4, 'Munz')">
                        <span class="greentext"><xsl:value-of select="billing_surgeon4"/></span>
                    </xsl:when>
                     <xsl:when test="contains(billing_surgeon4, 'Prasarn')">
                        <span class="lightbluetext"><xsl:value-of select="billing_surgeon4"/></span>
                    </xsl:when>
                    <xsl:when test="contains(billing_surgeon4, 'Harvin')">
                        <span class="purpletext"><xsl:value-of select="billing_surgeon4"/></span>
                    </xsl:when>
                    <xsl:when test="contains(billing_surgeon4, 'Burgess')">
                        <span class="brightredtext"><xsl:value-of select="billing_surgeon4"/></span>
                    </xsl:when>
                    <xsl:otherwise>
                        <span><xsl:value-of select="billing_surgeon4"/></span>
                    </xsl:otherwise>
                    </xsl:choose>
                    </td>
                </tr>
                </xsl:if>
                <xsl:if test="contains(routing5_users,',COMPLETE,')">
                <tr>
                    <td><span>5</span></td>
                    <td><span><xsl:value-of select="billing_date5"/></span></td>
                    <td><span><xsl:value-of select="billing_date_rec5"/></span></td>
                    <td><span><xsl:value-of select="billing_date_cod5"/></span></td>
                    <td><span><xsl:value-of select="billing_date_end5"/></span></td>
                    <td>
                    <xsl:choose>
                    <xsl:when test="contains(billing_surgeon5, 'Achor')">
                        <span class="bluetext"><xsl:value-of select="billing_surgeon5"/></span>
                    </xsl:when>
                    <xsl:when test="contains(billing_surgeon5, 'Gary')">
                        <span class="orangetext"><xsl:value-of select="billing_surgeon5"/></span>
                    </xsl:when>
                    <xsl:when test="contains(billing_surgeon5, 'Choo')">
                        <span class="yellowtext"><xsl:value-of select="billing_surgeon5"/></span>
                    </xsl:when>
                    <xsl:when test="contains(billing_surgeon5, 'Munz')">
                        <span class="greentext"><xsl:value-of select="billing_surgeon5"/></span>
                    </xsl:when>
                     <xsl:when test="contains(billing_surgeon5, 'Prasarn')">
                        <span class="lightbluetext"><xsl:value-of select="billing_surgeon5"/></span>
                    </xsl:when>
                    <xsl:when test="contains(billing_surgeon5, 'Harvin')">
                        <span class="purpletext"><xsl:value-of select="billing_surgeon5"/></span>
                    </xsl:when>
                    <xsl:when test="contains(billing_surgeon5, 'Burgess')">
                        <span class="brightredtext"><xsl:value-of select="billing_surgeon5"/></span>
                    </xsl:when>
                    <xsl:otherwise>
                        <span><xsl:value-of select="billing_surgeon5"/></span>
                    </xsl:otherwise>
                    </xsl:choose>
                    </td>>
                </tr>
                </xsl:if>
                <xsl:if test="contains(routing6_users,',COMPLETE,')">
                <tr>
                    <td><span>6</span></td>
                    <td><span><xsl:value-of select="billing_date6"/></span></td>
                    <td><span><xsl:value-of select="billing_date_rec6"/></span></td>
                    <td><span><xsl:value-of select="billing_date_cod6"/></span></td>
                    <td><span><xsl:value-of select="billing_date_end6"/></span></td>
                    <td>
                    <xsl:choose>
                    <xsl:when test="contains(billing_surgeon6, 'Achor')">
                        <span class="bluetext"><xsl:value-of select="billing_surgeon6"/></span>
                    </xsl:when>
                    <xsl:when test="contains(billing_surgeon6, 'Gary')">
                        <span class="orangetext"><xsl:value-of select="billing_surgeon6"/></span>
                    </xsl:when>
                    <xsl:when test="contains(billing_surgeon6, 'Choo')">
                        <span class="yellowtext"><xsl:value-of select="billing_surgeon6"/></span>
                    </xsl:when>
                    <xsl:when test="contains(billing_surgeon6, 'Munz')">
                        <span class="greentext"><xsl:value-of select="billing_surgeon6"/></span>
                    </xsl:when>
                     <xsl:when test="contains(billing_surgeon6, 'Prasarn')">
                        <span class="lightbluetext"><xsl:value-of select="billing_surgeon6"/></span>
                    </xsl:when>
                    <xsl:when test="contains(billing_surgeon6, 'Harvin')">
                        <span class="purpletext"><xsl:value-of select="billing_surgeon6"/></span>
                    </xsl:when>
                    <xsl:when test="contains(billing_surgeon6, 'Burgess')">
                        <span class="brightredtext"><xsl:value-of select="billing_surgeon6"/></span>
                    </xsl:when>
                    <xsl:otherwise>
                        <span><xsl:value-of select="billing_surgeon6"/></span>
                    </xsl:otherwise>
                    </xsl:choose>
                    </td>
                </tr>
                </xsl:if>
                <xsl:if test="contains(routing7_users,',COMPLETE,')">
                <tr>
                    <td><span>7</span></td>
                    <td><span><xsl:value-of select="billing_date7"/></span></td>
                    <td><span><xsl:value-of select="billing_date_rec7"/></span></td>
                    <td><span><xsl:value-of select="billing_date_cod7"/></span></td>
                    <td><span><xsl:value-of select="billing_date_end7"/></span></td>
                    <td>
                    <xsl:choose>
                    <xsl:when test="contains(billing_surgeon7, 'Achor')">
                        <span class="bluetext"><xsl:value-of select="billing_surgeon7"/></span>
                    </xsl:when>
                    <xsl:when test="contains(billing_surgeon7, 'Gary')">
                        <span class="orangetext"><xsl:value-of select="billing_surgeon7"/></span>
                    </xsl:when>
                    <xsl:when test="contains(billing_surgeon7, 'Choo')">
                        <span class="yellowtext"><xsl:value-of select="billing_surgeon7"/></span>
                    </xsl:when>
                    <xsl:when test="contains(billing_surgeon7, 'Munz')">
                        <span class="greentext"><xsl:value-of select="billing_surgeon7"/></span>
                    </xsl:when>
                     <xsl:when test="contains(billing_surgeon7, 'Prasarn')">
                        <span class="lightbluetext"><xsl:value-of select="billing_surgeon7"/></span>
                    </xsl:when>
                    <xsl:when test="contains(billing_surgeon7, 'Harvin')">
                        <span class="purpletext"><xsl:value-of select="billing_surgeon7"/></span>
                    </xsl:when>
                    <xsl:when test="contains(billing_surgeon7, 'Burgess')">
                        <span class="brightredtext"><xsl:value-of select="billing_surgeon7"/></span>
                    </xsl:when>
                    <xsl:otherwise>
                        <span><xsl:value-of select="billing_surgeon7"/></span>
                    </xsl:otherwise>
                    </xsl:choose>
                    </td>
                </tr>
                </xsl:if>
                <xsl:if test="contains(routing8_users,',COMPLETE,')">
                <tr>
                    <td><span>8</span></td>
                    <td><span><xsl:value-of select="billing_date8"/></span></td>
                    <td><span><xsl:value-of select="billing_date_rec8"/></span></td>
                    <td><span><xsl:value-of select="billing_date_cod8"/></span></td>
                    <td><span><xsl:value-of select="billing_date_end8"/></span></td>
                    <td>
                    <xsl:choose>
                    <xsl:when test="contains(billing_surgeon8, 'Achor')">
                        <span class="bluetext"><xsl:value-of select="billing_surgeon8"/></span>
                    </xsl:when>
                    <xsl:when test="contains(billing_surgeon8, 'Gary')">
                        <span class="orangetext"><xsl:value-of select="billing_surgeon8"/></span>
                    </xsl:when>
                    <xsl:when test="contains(billing_surgeon8, 'Choo')">
                        <span class="yellowtext"><xsl:value-of select="billing_surgeon8"/></span>
                    </xsl:when>
                    <xsl:when test="contains(billing_surgeon8, 'Munz')">
                        <span class="greentext"><xsl:value-of select="billing_surgeon8"/></span>
                    </xsl:when>
                     <xsl:when test="contains(billing_surgeon8, 'Prasarn')">
                        <span class="lightbluetext"><xsl:value-of select="billing_surgeon8"/></span>
                    </xsl:when>
                    <xsl:when test="contains(billing_surgeon8, 'Harvin')">
                        <span class="purpletext"><xsl:value-of select="billing_surgeon8"/></span>
                    </xsl:when>
                    <xsl:when test="contains(billing_surgeon8, 'Burgess')">
                        <span class="brightredtext"><xsl:value-of select="billing_surgeon8"/></span>
                    </xsl:when>
                    <xsl:otherwise>
                        <span><xsl:value-of select="billing_surgeon8"/></span>
                    </xsl:otherwise>
                    </xsl:choose>
                    </td>
                </tr>
                </xsl:if>
                <xsl:if test="contains(routing9_users,',COMPLETE,')">
                <tr>
                    <td><span>9</span></td>
                    <td><span><xsl:value-of select="billing_date9"/></span></td>
                    <td><span><xsl:value-of select="billing_date_rec9"/></span></td>
                    <td><span><xsl:value-of select="billing_date_cod9"/></span></td>
                    <td><span><xsl:value-of select="billing_date_end9"/></span></td>
                    <td>
                    <xsl:choose>
                    <xsl:when test="contains(billing_surgeon9, 'Achor')">
                        <span class="bluetext"><xsl:value-of select="billing_surgeon9"/></span>
                    </xsl:when>
                    <xsl:when test="contains(billing_surgeon9, 'Gary')">
                        <span class="orangetext"><xsl:value-of select="billing_surgeon9"/></span>
                    </xsl:when>
                    <xsl:when test="contains(billing_surgeon9, 'Choo')">
                        <span class="yellowtext"><xsl:value-of select="billing_surgeon9"/></span>
                    </xsl:when>
                    <xsl:when test="contains(billing_surgeon9, 'Munz')">
                        <span class="greentext"><xsl:value-of select="billing_surgeon9"/></span>
                    </xsl:when>
                     <xsl:when test="contains(billing_surgeon9, 'Prasarn')">
                        <span class="lightbluetext"><xsl:value-of select="billing_surgeon9"/></span>
                    </xsl:when>
                    <xsl:when test="contains(billing_surgeon9, 'Harvin')">
                        <span class="purpletext"><xsl:value-of select="billing_surgeon9"/></span>
                    </xsl:when>
                    <xsl:when test="contains(billing_surgeon9, 'Burgess')">
                        <span class="brightredtext"><xsl:value-of select="billing_surgeon9"/></span>
                    </xsl:when>
                    <xsl:otherwise>
                        <span><xsl:value-of select="billing_surgeon9"/></span>
                    </xsl:otherwise>
                    </xsl:choose>
                    </td>
                </tr>
                </xsl:if>
                <xsl:if test="contains(routing10_users,',COMPLETE,')">
                <tr>
                    <td><span>10</span></td>
                    <td><span><xsl:value-of select="billing_date10"/></span></td>
                    <td><span><xsl:value-of select="billing_date_rec10"/></span></td>
                    <td><span><xsl:value-of select="billing_date_cod10"/></span></td>
                    <td><span><xsl:value-of select="billing_date_end10"/></span></td>
                    <td>
                    <xsl:choose>
                    <xsl:when test="contains(billing_surgeon10, 'Achor')">
                        <span class="bluetext"><xsl:value-of select="billing_surgeon10"/></span>
                    </xsl:when>
                    <xsl:when test="contains(billing_surgeon10, 'Gary')">
                        <span class="orangetext"><xsl:value-of select="billing_surgeon10"/></span>
                    </xsl:when>
                    <xsl:when test="contains(billing_surgeon10, 'Choo')">
                        <span class="yellowtext"><xsl:value-of select="billing_surgeon10"/></span>
                    </xsl:when>
                    <xsl:when test="contains(billing_surgeon10, 'Munz')">
                        <span class="greentext"><xsl:value-of select="billing_surgeon10"/></span>
                    </xsl:when>
                     <xsl:when test="contains(billing_surgeon10, 'Prasarn')">
                        <span class="lightbluetext"><xsl:value-of select="billing_surgeon10"/></span>
                    </xsl:when>
                    <xsl:when test="contains(billing_surgeon10, 'Harvin')">
                        <span class="purpletext"><xsl:value-of select="billing_surgeon10"/></span>
                    </xsl:when>
                    <xsl:when test="contains(billing_surgeon10, 'Burgess')">
                        <span class="brightredtext"><xsl:value-of select="billing_surgeon10"/></span>
                    </xsl:when>
                    <xsl:otherwise>
                        <span><xsl:value-of select="billing_surgeon10"/></span>
                    </xsl:otherwise>
                    </xsl:choose>
                    </td>
                </tr>
                </xsl:if>


            </table>
        </div>
        </div>
        <div class="rows">
            <div class="small-12 medium-12 large-4 column">&#160;</div>
            <div class="small-12 medium-12 large-8 column">
                <xsl:if test="redcap_event_name = 'consultation_arm_1'">
                      <button class="tiny button" type="button" onclick="window.open('https:\/\/redcap.uth.tmc.edu\/redcap_v5.9.11\/DataEntry\/index.php?pid=87&amp;id={registry_id}&amp;event_id=699&amp;page=billing');">Edit</button>
                    </xsl:if>
                    <xsl:if test="redcap_event_name = 'surgery_1_arm_1'">
                      <button class="tiny button" type="button" onclick="window.open('https:\/\/redcap.uth.tmc.edu\/redcap_v5.9.11\/DataEntry\/index.php?pid=87&amp;id={registry_id}&amp;event_id=720&amp;page=billing');">Edit</button>
                    </xsl:if>
                    <xsl:if test="redcap_event_name = 'surgery_2_arm_1'">
                      <button class="tiny button" type="button" onclick="window.open('https:\/\/redcap.uth.tmc.edu\/redcap_v5.9.11\/DataEntry\/index.php?pid=87&amp;id={registry_id}&amp;event_id=721&amp;page=billing');">Edit</button>
                    </xsl:if>
                    <xsl:if test="redcap_event_name = 'surgery_3_arm_1'">
                      <button class="tiny button" type="button" onclick="window.open('https:\/\/redcap.uth.tmc.edu\/redcap_v5.9.11\/DataEntry\/index.php?pid=87&amp;id={registry_id}&amp;event_id=722&amp;page=billing');">Edit</button>
                    </xsl:if>
                    <xsl:if test="redcap_event_name = 'surgery_4_arm_1'">
                      <button class="tiny button" type="button" onclick="window.open('https:\/\/redcap.uth.tmc.edu\/redcap_v5.9.11\/DataEntry\/index.php?pid=87&amp;id={registry_id}&amp;event_id=723&amp;page=billing');">Edit</button>
                    </xsl:if>
                    <xsl:if test="redcap_event_name = 'surgery_5_arm_1'">
                      <button class="tiny button" type="button" onclick="window.open('https:\/\/redcap.uth.tmc.edu\/redcap_v5.9.11\/DataEntry\/index.php?pid=87&amp;id={registry_id}&amp;event_id=724&amp;page=billing');">Edit</button>
                    </xsl:if>
                    </div>
        </div>
        <!--    <div style="float: right;">
               <input type="checkbox" onclick="toggleChecked(this);">Done!</input>
            </div>-->
        </fieldset>
    </xsl:template>

    <xsl:template match="item" mode="incomplete">
        <fieldset class="recordhidden" style="background-color:white;">
            <legend>Record <xsl:value-of select="registry_id"/></legend>
            Work complete. Click to show.
            <div style="float:right; text-decoration:line-through;">
                <input type="checkbox" onclick="toggleChecked(this);this.checked='checked';">Done!</input>
            </div>
        </fieldset>
        <fieldset class="record" style="background-color:white;">
        <legend>Record <xsl:value-of select="registry_id"/></legend>
        <div class="record rows">
        <xsl:apply-templates select="." mode="summary"/>
        <div class="small-12 medium-12 large-9 column">
            <table class="bills">
                <tr>
                    <th width="20px" style="text-align:center">#</th><th width="100px" style="text-align:center"><span class="dlabel">Date of Service</span></th><th width="130px" style="text-align:center"><span class="tablegreentext dlabel">Received by Billing</span></th><th width="150px" style="text-align:center"><span class="pink dlabel">Completed by CODING</span></th><th width="130px" style="text-align:center"><span class="redtext dlabel">Finished by Billing</span></th><th width="150px" style="text-align:center"><span class="dlabel">Surgeon</span></th><th width="150px" style="text-align:center"><span class="dlabel">For</span></th>
                </tr>
                <xsl:if test="routing_users != '' and not(contains(routing_users,',COMPLETE,'))">
                <tr>
                    <td><span>1</span></td>
                    <td><span><xsl:value-of select="billing_date"/></span></td>
                    <td><span><xsl:value-of select="billing_date_rec"/></span></td>
                    <td><span><xsl:value-of select="billing_date_cod"/></span></td>
                    <td><span><xsl:value-of select="billing_date_end"/></span></td>
                    <td>
                    <xsl:choose>
                    <xsl:when test="contains(billing_surgeon, 'Achor')">
                        <span class="bluetext"><xsl:value-of select="billing_surgeon"/></span>
                    </xsl:when>
                    <xsl:when test="contains(billing_surgeon, 'Gary')">
                        <span class="orangetext"><xsl:value-of select="billing_surgeon"/></span>
                    </xsl:when>
                    <xsl:when test="contains(billing_surgeon, 'Choo')">
                        <span class="yellowtext"><xsl:value-of select="billing_surgeon"/></span>
                    </xsl:when>
                    <xsl:when test="contains(billing_surgeon, 'Munz')">
                        <span class="greentext"><xsl:value-of select="billing_surgeon"/></span>
                    </xsl:when>
                     <xsl:when test="contains(billing_surgeon, 'Prasarn')">
                        <span class="lightbluetext"><xsl:value-of select="billing_surgeon"/></span>
                    </xsl:when>
                    <xsl:when test="contains(billing_surgeon, 'Harvin')">
                        <span class="purpletext"><xsl:value-of select="billing_surgeon"/></span>
                    </xsl:when>
                    <xsl:when test="contains(billing_surgeon, 'Burgess')">
                        <span class="brightredtext"><xsl:value-of select="billing_surgeon"/></span>
                    </xsl:when>
                    <xsl:otherwise>
                        <span><xsl:value-of select="billing_surgeon"/></span>
                    </xsl:otherwise>
                    </xsl:choose>
                    </td>
                    <td><span><xsl:value-of select="routing"/></span></td>
                </tr>
                </xsl:if>
                <xsl:if test="routing2_users != '' and not(contains(routing2_users,',COMPLETE,'))">
                <tr>
                    <td><span>2</span></td>
                    <td><span><xsl:value-of select="billing_date2"/></span></td>
                    <td><span><xsl:value-of select="billing_date_rec2"/></span></td>
                    <td><span><xsl:value-of select="billing_date_cod2"/></span></td>
                    <td><span><xsl:value-of select="billing_date_end2"/></span></td>
                    <td>
                    <xsl:choose>
                    <xsl:when test="contains(billing_surgeon2, 'Achor')">
                        <span class="bluetext"><xsl:value-of select="billing_surgeon2"/></span>
                    </xsl:when>
                    <xsl:when test="contains(billing_surgeon2, 'Gary')">
                        <span class="orangetext"><xsl:value-of select="billing_surgeon2"/></span>
                    </xsl:when>
                    <xsl:when test="contains(billing_surgeon2, 'Choo')">
                        <span class="yellowtext"><xsl:value-of select="billing_surgeon2"/></span>
                    </xsl:when>
                    <xsl:when test="contains(billing_surgeon2, 'Munz')">
                        <span class="greentext"><xsl:value-of select="billing_surgeon2"/></span>
                    </xsl:when>
                     <xsl:when test="contains(billing_surgeon2, 'Prasarn')">
                        <span class="lightbluetext"><xsl:value-of select="billing_surgeon2"/></span>
                    </xsl:when>
                    <xsl:when test="contains(billing_surgeon2, 'Harvin')">
                        <span class="purpletext"><xsl:value-of select="billing_surgeon2"/></span>
                    </xsl:when>
                    <xsl:when test="contains(billing_surgeon2, 'Burgess')">
                        <span class="brightredtext"><xsl:value-of select="billing_surgeon2"/></span>
                    </xsl:when>
                    <xsl:otherwise>
                        <span><xsl:value-of select="billing_surgeon2"/></span>
                    </xsl:otherwise>
                    </xsl:choose>
                    </td>
                    <td><span><xsl:value-of select="routing2"/></span></td>
                </tr>
                </xsl:if>
                <xsl:if test="routing3_users != '' and not(contains(routing3_users,',COMPLETE,'))">
                <tr>
                    <td><span>3</span></td>
                    <td><span><xsl:value-of select="billing_date3"/></span></td>
                    <td><span><xsl:value-of select="billing_date_rec3"/></span></td>
                    <td><span><xsl:value-of select="billing_date_cod3"/></span></td>
                    <td><span><xsl:value-of select="billing_date_end3"/></span></td>
                    <td>
                    <xsl:choose>
                    <xsl:when test="contains(billing_surgeon3, 'Achor')">
                        <span class="bluetext"><xsl:value-of select="billing_surgeon3"/></span>
                    </xsl:when>
                    <xsl:when test="contains(billing_surgeon3, 'Gary')">
                        <span class="orangetext"><xsl:value-of select="billing_surgeon3"/></span>
                    </xsl:when>
                    <xsl:when test="contains(billing_surgeon3, 'Choo')">
                        <span class="yellowtext"><xsl:value-of select="billing_surgeon3"/></span>
                    </xsl:when>
                    <xsl:when test="contains(billing_surgeon3, 'Munz')">
                        <span class="greentext"><xsl:value-of select="billing_surgeon3"/></span>
                    </xsl:when>
                     <xsl:when test="contains(billing_surgeon3, 'Prasarn')">
                        <span class="lightbluetext"><xsl:value-of select="billing_surgeon3"/></span>
                    </xsl:when>
                    <xsl:when test="contains(billing_surgeon3, 'Harvin')">
                        <span class="purpletext"><xsl:value-of select="billing_surgeon3"/></span>
                    </xsl:when>
                    <xsl:when test="contains(billing_surgeon3, 'Burgess')">
                        <span class="brightredtext"><xsl:value-of select="billing_surgeon3"/></span>
                    </xsl:when>
                    <xsl:otherwise>
                        <span><xsl:value-of select="billing_surgeon3"/></span>
                    </xsl:otherwise>
                    </xsl:choose>
                    </td>
                    <td><span><xsl:value-of select="routing3"/></span></td>
                </tr>
                </xsl:if>
                <xsl:if test="routing4_users != '' and not(contains(routing4_users,',COMPLETE,'))">
                <tr>
                    <td><span>4</span></td>
                    <td><span><xsl:value-of select="billing_date4"/></span></td>
                    <td><span><xsl:value-of select="billing_date_rec4"/></span></td>
                    <td><span><xsl:value-of select="billing_date_cod4"/></span></td>
                    <td><span><xsl:value-of select="billing_date_end4"/></span></td>
                    <td>
                    <xsl:choose>
                    <xsl:when test="contains(billing_surgeon4, 'Achor')">
                        <span class="bluetext"><xsl:value-of select="billing_surgeon4"/></span>
                    </xsl:when>
                    <xsl:when test="contains(billing_surgeon4, 'Gary')">
                        <span class="orangetext"><xsl:value-of select="billing_surgeon4"/></span>
                    </xsl:when>
                    <xsl:when test="contains(billing_surgeon4, 'Choo')">
                        <span class="yellowtext"><xsl:value-of select="billing_surgeon4"/></span>
                    </xsl:when>
                    <xsl:when test="contains(billing_surgeon4, 'Munz')">
                        <span class="greentext"><xsl:value-of select="billing_surgeon4"/></span>
                    </xsl:when>
                     <xsl:when test="contains(billing_surgeon4, 'Prasarn')">
                        <span class="lightbluetext"><xsl:value-of select="billing_surgeon4"/></span>
                    </xsl:when>
                    <xsl:when test="contains(billing_surgeon4, 'Harvin')">
                        <span class="purpletext"><xsl:value-of select="billing_surgeon4"/></span>
                    </xsl:when>
                    <xsl:when test="contains(billing_surgeon4, 'Burgess')">
                        <span class="brightredtext"><xsl:value-of select="billing_surgeon4"/></span>
                    </xsl:when>
                    <xsl:otherwise>
                        <span><xsl:value-of select="billing_surgeon4"/></span>
                    </xsl:otherwise>
                    </xsl:choose>
                    </td> 
                    <td><span><xsl:value-of select="routing4"/></span></td>
                </tr>
                </xsl:if>
                <xsl:if test="routing5_users != '' and not(contains(routing5_users,',COMPLETE,'))">
                <tr>
                    <td><span>5</span></td>
                    <td><span><xsl:value-of select="billing_date5"/></span></td>
                    <td><span><xsl:value-of select="billing_date_rec5"/></span></td>
                    <td><span><xsl:value-of select="billing_date_cod5"/></span></td>
                    <td><span><xsl:value-of select="billing_date_end5"/></span></td>
                    <td>
                    <xsl:choose>
                    <xsl:when test="contains(billing_surgeon5, 'Achor')">
                        <span class="bluetext"><xsl:value-of select="billing_surgeon5"/></span>
                    </xsl:when>
                    <xsl:when test="contains(billing_surgeon5, 'Gary')">
                        <span class="orangetext"><xsl:value-of select="billing_surgeon5"/></span>
                    </xsl:when>
                    <xsl:when test="contains(billing_surgeon5, 'Choo')">
                        <span class="yellowtext"><xsl:value-of select="billing_surgeon5"/></span>
                    </xsl:when>
                    <xsl:when test="contains(billing_surgeon5, 'Munz')">
                        <span class="greentext"><xsl:value-of select="billing_surgeon5"/></span>
                    </xsl:when>
                     <xsl:when test="contains(billing_surgeon5, 'Prasarn')">
                        <span class="lightbluetext"><xsl:value-of select="billing_surgeon5"/></span>
                    </xsl:when>
                    <xsl:when test="contains(billing_surgeon5, 'Harvin')">
                        <span class="purpletext"><xsl:value-of select="billing_surgeon5"/></span>
                    </xsl:when>
                    <xsl:when test="contains(billing_surgeon5, 'Burgess')">
                        <span class="brightredtext"><xsl:value-of select="billing_surgeon5"/></span>
                    </xsl:when>
                    <xsl:otherwise>
                        <span><xsl:value-of select="billing_surgeon5"/></span>
                    </xsl:otherwise>
                    </xsl:choose>
                    </td>
                    <td><span><xsl:value-of select="routing5"/></span></td>
                </tr>
                </xsl:if>
                <xsl:if test="routing6_users != '' and not(contains(routing6_users,',COMPLETE,'))">
                <tr>
                    <td><span>6</span></td>
                    <td><span><xsl:value-of select="billing_date6"/></span></td>
                    <td><span><xsl:value-of select="billing_date_rec6"/></span></td>
                    <td><span><xsl:value-of select="billing_date_cod6"/></span></td>
                    <td><span><xsl:value-of select="billing_date_end6"/></span></td>
                    <td>
                    <xsl:choose>
                    <xsl:when test="contains(billing_surgeon6, 'Achor')">
                        <span class="bluetext"><xsl:value-of select="billing_surgeon6"/></span>
                    </xsl:when>
                    <xsl:when test="contains(billing_surgeon6, 'Gary')">
                        <span class="orangetext"><xsl:value-of select="billing_surgeon6"/></span>
                    </xsl:when>
                    <xsl:when test="contains(billing_surgeon6, 'Choo')">
                        <span class="yellowtext"><xsl:value-of select="billing_surgeon6"/></span>
                    </xsl:when>
                    <xsl:when test="contains(billing_surgeon6, 'Munz')">
                        <span class="greentext"><xsl:value-of select="billing_surgeon6"/></span>
                    </xsl:when>
                     <xsl:when test="contains(billing_surgeon6, 'Prasarn')">
                        <span class="lightbluetext"><xsl:value-of select="billing_surgeon6"/></span>
                    </xsl:when>
                    <xsl:when test="contains(billing_surgeon6, 'Harvin')">
                        <span class="purpletext"><xsl:value-of select="billing_surgeon6"/></span>
                    </xsl:when>
                    <xsl:when test="contains(billing_surgeon6, 'Burgess')">
                        <span class="brightredtext"><xsl:value-of select="billing_surgeon6"/></span>
                    </xsl:when>
                    <xsl:otherwise>
                        <span><xsl:value-of select="billing_surgeon6"/></span>
                    </xsl:otherwise>
                    </xsl:choose>
                    </td>
                    <td><span><xsl:value-of select="routing6"/></span></td>
                </tr>
                </xsl:if>
                <xsl:if test="routing7_users != '' and not(contains(routing7_users,',COMPLETE,'))">
                <tr>
                    <td><span>7</span></td>
                    <td><span><xsl:value-of select="billing_date7"/></span></td>
                    <td><span><xsl:value-of select="billing_date_rec7"/></span></td>
                    <td><span><xsl:value-of select="billing_date_cod7"/></span></td>
                    <td><span><xsl:value-of select="billing_date_end7"/></span></td>
                    <td>
                    <xsl:choose>
                    <xsl:when test="contains(billing_surgeon7, 'Achor')">
                        <span class="bluetext"><xsl:value-of select="billing_surgeon7"/></span>
                    </xsl:when>
                    <xsl:when test="contains(billing_surgeon7, 'Gary')">
                        <span class="orangetext"><xsl:value-of select="billing_surgeon7"/></span>
                    </xsl:when>
                    <xsl:when test="contains(billing_surgeon7, 'Choo')">
                        <span class="yellowtext"><xsl:value-of select="billing_surgeon7"/></span>
                    </xsl:when>
                    <xsl:when test="contains(billing_surgeon7, 'Munz')">
                        <span class="greentext"><xsl:value-of select="billing_surgeon7"/></span>
                    </xsl:when>
                     <xsl:when test="contains(billing_surgeon7, 'Prasarn')">
                        <span class="lightbluetext"><xsl:value-of select="billing_surgeon7"/></span>
                    </xsl:when>
                    <xsl:when test="contains(billing_surgeon7, 'Harvin')">
                        <span class="purpletext"><xsl:value-of select="billing_surgeon7"/></span>
                    </xsl:when>
                    <xsl:when test="contains(billing_surgeon7, 'Burgess')">
                        <span class="brightredtext"><xsl:value-of select="billing_surgeon7"/></span>
                    </xsl:when>
                    <xsl:otherwise>
                        <span><xsl:value-of select="billing_surgeon7"/></span>
                    </xsl:otherwise>
                    </xsl:choose>
                    </td>
                    <td><span><xsl:value-of select="routing7"/></span></td>
                </tr>
                </xsl:if>
                <xsl:if test="routing8_users != '' and not(contains(routing8_users,',COMPLETE,'))">
                <tr>
                    <td><span>8</span></td>
                    <td><span><xsl:value-of select="billing_date8"/></span></td>
                    <td><span><xsl:value-of select="billing_date_rec8"/></span></td>
                    <td><span><xsl:value-of select="billing_date_cod8"/></span></td>
                    <td><span><xsl:value-of select="billing_date_end8"/></span></td>
                    <td>
                    <xsl:choose>
                    <xsl:when test="contains(billing_surgeon8, 'Achor')">
                        <span class="bluetext"><xsl:value-of select="billing_surgeon8"/></span>
                    </xsl:when>
                    <xsl:when test="contains(billing_surgeon8, 'Gary')">
                        <span class="orangetext"><xsl:value-of select="billing_surgeon8"/></span>
                    </xsl:when>
                    <xsl:when test="contains(billing_surgeon8, 'Choo')">
                        <span class="yellowtext"><xsl:value-of select="billing_surgeon8"/></span>
                    </xsl:when>
                    <xsl:when test="contains(billing_surgeon8, 'Munz')">
                        <span class="greentext"><xsl:value-of select="billing_surgeon8"/></span>
                    </xsl:when>
                     <xsl:when test="contains(billing_surgeon8, 'Prasarn')">
                        <span class="lightbluetext"><xsl:value-of select="billing_surgeon8"/></span>
                    </xsl:when>
                    <xsl:when test="contains(billing_surgeon8, 'Harvin')">
                        <span class="purpletext"><xsl:value-of select="billing_surgeon8"/></span>
                    </xsl:when>
                    <xsl:when test="contains(billing_surgeon8, 'Burgess')">
                        <span class="brightredtext"><xsl:value-of select="billing_surgeon8"/></span>
                    </xsl:when>
                    <xsl:otherwise>
                        <span><xsl:value-of select="billing_surgeon8"/></span>
                    </xsl:otherwise>
                    </xsl:choose>
                    </td>
                    <td><span><xsl:value-of select="routing8"/></span></td>
                </tr>
                </xsl:if>
                <xsl:if test="routing9_users != '' and not(contains(routing9_users,',COMPLETE,'))">
                <tr>
                    <td><span>9</span></td>
                    <td><span><xsl:value-of select="billing_date9"/></span></td>
                    <td><span><xsl:value-of select="billing_date_rec9"/></span></td>
                    <td><span><xsl:value-of select="billing_date_cod9"/></span></td>
                    <td><span><xsl:value-of select="billing_date_end9"/></span></td>
                    <td>
                    <xsl:choose>
                    <xsl:when test="contains(billing_surgeon9, 'Achor')">
                        <span class="bluetext"><xsl:value-of select="billing_surgeon9"/></span>
                    </xsl:when>
                    <xsl:when test="contains(billing_surgeon9, 'Gary')">
                        <span class="orangetext"><xsl:value-of select="billing_surgeon9"/></span>
                    </xsl:when>
                    <xsl:when test="contains(billing_surgeon9, 'Choo')">
                        <span class="yellowtext"><xsl:value-of select="billing_surgeon9"/></span>
                    </xsl:when>
                    <xsl:when test="contains(billing_surgeon9, 'Munz')">
                        <span class="greentext"><xsl:value-of select="billing_surgeon9"/></span>
                    </xsl:when>
                     <xsl:when test="contains(billing_surgeon9, 'Prasarn')">
                        <span class="lightbluetext"><xsl:value-of select="billing_surgeon9"/></span>
                    </xsl:when>
                    <xsl:when test="contains(billing_surgeon9, 'Harvin')">
                        <span class="purpletext"><xsl:value-of select="billing_surgeon9"/></span>
                    </xsl:when>
                    <xsl:when test="contains(billing_surgeon9, 'Burgess')">
                        <span class="brightredtext"><xsl:value-of select="billing_surgeon9"/></span>
                    </xsl:when>
                    <xsl:otherwise>
                        <span><xsl:value-of select="billing_surgeon9"/></span>
                    </xsl:otherwise>
                    </xsl:choose>
                    </td>
                    <td><span><xsl:value-of select="routing9"/></span></td>
                </tr>
                </xsl:if>
                <xsl:if test="routing10_users != '' and not(contains(routing10_users,',COMPLETE,'))">
                <tr>
                    <td><span>10</span></td>
                    <td><span><xsl:value-of select="billing_date10"/></span></td>
                    <td><span><xsl:value-of select="billing_date_rec10"/></span></td>
                    <td><span><xsl:value-of select="billing_date_cod10"/></span></td>
                    <td><span><xsl:value-of select="billing_date_end10"/></span></td>
                    <td>
                    <xsl:choose>
                    <xsl:when test="contains(billing_surgeon10, 'Achor')">
                        <span class="bluetext"><xsl:value-of select="billing_surgeon10"/></span>
                    </xsl:when>
                    <xsl:when test="contains(billing_surgeon10, 'Gary')">
                        <span class="orangetext"><xsl:value-of select="billing_surgeon10"/></span>
                    </xsl:when>
                    <xsl:when test="contains(billing_surgeon10, 'Choo')">
                        <span class="yellowtext"><xsl:value-of select="billing_surgeon10"/></span>
                    </xsl:when>
                    <xsl:when test="contains(billing_surgeon10, 'Munz')">
                        <span class="greentext"><xsl:value-of select="billing_surgeon10"/></span>
                    </xsl:when>
                     <xsl:when test="contains(billing_surgeon10, 'Prasarn')">
                        <span class="lightbluetext"><xsl:value-of select="billing_surgeon10"/></span>
                    </xsl:when>
                    <xsl:when test="contains(billing_surgeon10, 'Harvin')">
                        <span class="purpletext"><xsl:value-of select="billing_surgeon10"/></span>
                    </xsl:when>
                    <xsl:when test="contains(billing_surgeon10, 'Burgess')">
                        <span class="brightredtext"><xsl:value-of select="billing_surgeon10"/></span>
                    </xsl:when>
                    <xsl:otherwise>
                        <span><xsl:value-of select="billing_surgeon10"/></span>
                    </xsl:otherwise>
                    </xsl:choose>
                    </td>
                    <td><span><xsl:value-of select="routing10"/></span></td>
                </tr>
                </xsl:if>

            </table>
        </div>
        </div>
        <div class="rows">
            <div class="small-12 medium-12 large-3 column">&#160;</div>
            <div class="small-12 medium-12 large-9 column">
                <xsl:if test="redcap_event_name = 'consultation_arm_1'">
                      <button class="tiny button" type="button" onclick="window.open('https:\/\/redcap.uth.tmc.edu\/redcap_v5.9.11\/DataEntry\/index.php?pid=87&amp;id={registry_id}&amp;event_id=699&amp;page=billing');">Edit</button>
                    </xsl:if>
                    <xsl:if test="redcap_event_name = 'surgery_1_arm_1'">
                      <button class="tiny button" type="button" onclick="window.open('https:\/\/redcap.uth.tmc.edu\/redcap_v5.9.11\/DataEntry\/index.php?pid=87&amp;id={registry_id}&amp;event_id=720&amp;page=billing');">Edit</button>
                    </xsl:if>
                    <xsl:if test="redcap_event_name = 'surgery_2_arm_1'">
                      <button class="tiny button" type="button" onclick="window.open('https:\/\/redcap.uth.tmc.edu\/redcap_v5.9.11\/DataEntry\/index.php?pid=87&amp;id={registry_id}&amp;event_id=721&amp;page=billing');">Edit</button>
                    </xsl:if>
                    <xsl:if test="redcap_event_name = 'surgery_3_arm_1'">
                      <button class="tiny button" type="button" onclick="window.open('https:\/\/redcap.uth.tmc.edu\/redcap_v5.9.11\/DataEntry\/index.php?pid=87&amp;id={registry_id}&amp;event_id=722&amp;page=billing');">Edit</button>
                    </xsl:if>
                    <xsl:if test="redcap_event_name = 'surgery_4_arm_1'">
                      <button class="tiny button" type="button" onclick="window.open('https:\/\/redcap.uth.tmc.edu\/redcap_v5.9.11\/DataEntry\/index.php?pid=87&amp;id={registry_id}&amp;event_id=723&amp;page=billing');">Edit</button>
                    </xsl:if>
                    <xsl:if test="redcap_event_name = 'surgery_5_arm_1'">
                      <button class="tiny button" type="button" onclick="window.open('https:\/\/redcap.uth.tmc.edu\/redcap_v5.9.11\/DataEntry\/index.php?pid=87&amp;id={registry_id}&amp;event_id=724&amp;page=billing');">Edit</button>
                    </xsl:if>

                </div>
        </div>
        </fieldset>
    </xsl:template>

</xsl:stylesheet>

