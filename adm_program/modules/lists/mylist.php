<?php
/******************************************************************************
 * Eigene Listen erstellen
 *
 * Copyright    : (c) 2004 - 2006 The Admidio Team
 * Homepage     : http://www.admidio.org
 * Module-Owner : Markus Fassbender
 *
 * Uebergaben:
 *
 * rol_id : das Feld Rolle kann mit der entsprechenden Rolle vorbelegt werden
 * active_role   : 1 - (Default) aktive Rollen auflisten
 *                 0 - Ehemalige Rollen auflisten
 * active_member : 1 - (Default) aktive Mitglieder der Rolle anzeigen
 *                 0 - Ehemalige Mitglieder der Rolle anzeigen
 *
 ******************************************************************************
 *
 * This program is free software; you can redistribute it and/or
 * modify it under the terms of the GNU General Public License
 * as published by the Free Software Foundation; either version 2
 * of the License, or (at your option) any later version.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program; if not, write to the Free Software
 * Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA  02111-1307, USA.
 *
 *****************************************************************************/

require("../../system/common.php");
require("../../system/login_valid.php");

// Uebergabevariablen pruefen und ggf. vorbelegen

if(array_key_exists("rol_id", $_GET))
{
    if(is_numeric($_GET["rol_id"]) == false)
    {
        $location = "Location: $g_root_path/adm_program/system/err_msg.php?err_code=invalid";
        header($location);
        exit();
    }   
}
else
{
    $_GET["rol_id"] = 0;
}   

if(!isset($_GET['active_role']))
{
    $active_role = 1;
}
else
{
    if($_GET['active_role'] != 0
    && $_GET['active_role'] != 1)
    {
        $active_role = 1;
    }
    else
    {
        $active_role = $_GET['active_role'];
    }
}   

if(!isset($_GET['active_member']))
{
    $active_member = 1;
}
else
{
    if($_GET['active_member'] != 0
    && $_GET['active_member'] != 1)
    {
        $active_member = 1;
    }
    else
    {
        $active_member = $_GET['active_member'];
    }
}   

session_start();
$b_history = false;		// History-Funktion bereits aktiviert ja/nein
$default_fields = 6;	// Anzahl der Felder, die beim Aufruf angezeigt werden

if(isset($_SESSION['mylist_request']))
{
	$request = $_SESSION['mylist_request'];
	$rol_id  = $request['role'];
	if($request['former'] == 1)
	{
		$active_member = 0;
	}
	
	// falls vorher schon Felder manuell hinzugefuegt wurden, 
	// muessen diese nun direkt angelegt werden
	for($i = $default_fields+1; $i > 0; $i++)
	{
		if(isset($request["column$i"]))
		{
			$default_fields++;			
		}	
		else
		{
			$i = -1;
		}
	}
	
	$b_history = true;
}

echo "
<!-- (c) 2004 - 2006 The Admidio Team - http://www.admidio.org - Version: ". getVersion(). " -->\n
<!DOCTYPE HTML PUBLIC \"-//W3C//DTD HTML 4.01 Transitional//EN\" \"http://www.w3.org/TR/html4/loose.dtd\">
<html>
<head>
    <title>$g_current_organization->longname - Eigene Liste - Einstellungen</title>
    <link rel=\"stylesheet\" type=\"text/css\" href=\"$g_root_path/adm_config/main.css\">
	<script type=\"text/javascript\" src=\"$g_root_path/adm_program/system/ajax.js\"></script>
	
	<script type=\"text/javascript\">
		var actFieldCount = $default_fields;
		var resObject     = createXMLHttpRequest();

		function addField() 
		{
			actFieldCount++;
			resObject.open('get', 'mylist_field_list.php?field_number=' + actFieldCount, true);
			resObject.onreadystatechange = handleResponse;
			resObject.send(null);
		}

		function handleResponse() 
		{
			if(resObject.readyState == 4) 
			{
				var objectId = 'next_field_' + actFieldCount;
				document.getElementById(objectId).innerHTML += resObject.responseText;
			}
		}
	</script>

    <!--[if lt IE 7]>
    <script type=\"text/javascript\" src=\"$g_root_path/adm_program/system/correct_png.js\"></script>
    <![endif]-->";

    require("../../../adm_config/header.php");
echo "</head>";

require("../../../adm_config/body_top.php");
    echo "<div style=\"margin-top: 10px; margin-bottom: 10px;\" align=\"center\">
        <form action=\"mylist_prepare.php\" method=\"post\" name=\"properties\">
            <div class=\"formHead\">";
                echo strspace("Eigene Liste", 1);
            echo "</div>
            <div class=\"formBody\">
                <b>1.</b> W&auml;hle eine Rolle aus von der du eine Mitgliederliste erstellen willst:
                <p><b>Rolle :</b>&nbsp;&nbsp;
                <select size=\"1\" id=\"role\" name=\"role\">
                    <option value=\"\" selected=\"selected\">- Bitte w&auml;hlen -</option>";
                    // Rollen selektieren

                    // Webmaster und Moderatoren duerfen Listen zu allen Rollen sehen
                    if(isModerator())
                    {
                        $sql     = "SELECT * FROM ". TBL_ROLES. ", ". TBL_ROLE_CATEGORIES. "
                                     WHERE rol_org_shortname = '$g_organization'
                                       AND rol_valid         = $active_role
                                       AND rol_rlc_id        = rlc_id
                                     ORDER BY rlc_name, rol_name";
                    }
                    else
                    {
                        $sql     = "SELECT * FROM ". TBL_ROLES. ", ". TBL_ROLE_CATEGORIES. "
                                     WHERE rol_org_shortname = '$g_organization'
                                       AND rol_locked        = 0
                                       AND rol_valid         = $active_role
                                       AND rol_rlc_id        = rlc_id
                                     ORDER BY rlc_name, rol_name";
                    }
                    $result_lst = mysql_query($sql, $g_adm_con);
                    db_error($result_lst);
                    $act_category = "";

                    while($row = mysql_fetch_object($result_lst))
                    {
                        if($act_category != $row->rlc_name)
                        {
                            if(strlen($act_category) > 0)
                            {
                                echo "</optgroup>";
                            }
                            echo "<optgroup label=\"$row->rlc_name\">";
                            $act_category = $row->rlc_name;
                        }
                        echo "<option value=\"$row->rol_id\" ";
                        if($rol_id == $row->rol_id) echo " selected=\"selected\" ";
                        {
                            echo ">$row->rol_name</option>";
                        }
                    }
                    echo "</optgroup>
                </select>
                &nbsp;&nbsp;&nbsp;
                <input type=\"checkbox\" id=\"former\" name=\"former\" value=\"1\" ";
                    if(!$active_member) 
                    {
                        echo " checked=\"checked\" ";
                    }
                    echo " />
                <label for=\"former\">nur Ehemalige</label></p>

                <p><b>2.</b> Bestimme die Felder, die in der Liste angezeigt werden sollen:</p>

                <table class=\"tableList\" style=\"width: 90%;\" cellpadding=\"0\" cellspacing=\"0\">
                    <tr>
                        <th class=\"tableHeader\" style=\"width: 18%;\">Nr.</th>
                        <th class=\"tableHeader\" style=\"width: 37%;\">Feld</th>
                        <th class=\"tableHeader\" style=\"width: 18%;\">Sortierung</th>
                        <th class=\"tableHeader\" style=\"width: 27%;\">Bedingung
                            <img src=\"$g_root_path/adm_program/images/help.png\" style=\"cursor: pointer; vertical-align: middle; padding-bottom: 1px;\" width=\"16\" height=\"16\" border=\"0\" alt=\"Hilfe\" title=\"Hilfe\"
                            onClick=\"window.open('$g_root_path/adm_program/system/msg_window.php?err_code=condition','Message','width=450,height=600,left=310,top=200,scrollbars=yes')\">
                        </th>
                    </tr>
					<tr>
						<td colspan=\"4\">";
							// Zeilen mit den einzelnen Feldern anzeigen
		                    for($i = 1; $i <= $default_fields; $i++)
		                    {
		                    	include("mylist_field_list.php");
		                    }
						echo "</td>
					</tr>
					<tr>
						<td colspan=\"4\" style=\"padding: 4px;\">&nbsp;
							<span class=\"iconLink\">
			                    <a class=\"iconLink\" href=\"javascript:addField()\"><img
			                    class=\"iconLink\" src=\"$g_root_path/adm_program/images/add.png\" style=\"vertical-align: middle;\" border=\"0\" alt=\"Feld hinzuf&uuml;gen\"></a>
			                    <a class=\"iconLink\" href=\"javascript:addField()\">Feld hinzuf&uuml;gen</a>
			                </span>
						</td>
					</tr>
                </table>

                <p>
                    <button name=\"zurueck\" type=\"button\" value=\"zurueck\" onclick=\"history.back()\">
                        <img src=\"$g_root_path/adm_program/images/back.png\" style=\"vertical-align: middle; padding-bottom: 1px;\" width=\"16\" height=\"16\" border=\"0\" alt=\"Zur&uuml;ck\">
                        Zur&uuml;ck</button>
                    &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                    <button name=\"anzeigen\" type=\"submit\" value=\"anzeigen\">
                        <img src=\"$g_root_path/adm_program/images/application_view_columns.png\" style=\"vertical-align: middle; padding-bottom: 1px;\" width=\"16\" height=\"16\" border=\"0\" alt=\"Liste anzeigen\">
                        &nbsp;Liste anzeigen</button>            
                </p>
            </div>
        </form>
    </div>";
    
    require("../../../adm_config/body_bottom.php");
echo "</body>
</html>";
?>