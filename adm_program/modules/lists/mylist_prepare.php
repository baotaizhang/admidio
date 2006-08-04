<?
/******************************************************************************
 * Dieses Script setzt das SQL-Statement fuer die myList zusammen und
 * uebergibt es an das allgemeine Listen-Script
 *
 * Copyright    : (c) 2004 - 2006 The Admidio Team
 * Homepage     : http://www.admidio.org
 * Module-Owner : Markus Fassbender
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
require("../../system/search_parser_class.php");

session_start();

$_SESSION['mylist_request'] = $_REQUEST;

$err_text    = "";
$sql_select  = "";
$sql_join    = "";
$sql_where   = "";
$sql_orderby = "";

if(strlen($_POST["column1"]) == 0)
{
    $err_text = "Feld 1";
}

if(strlen($_POST["role"]) == 0)
{
    $err_text = "Rolle";
}

if(strlen($err_text) != 0)
{
    $location = "Location: $g_root_path/adm_program/system/err_msg.php?err_code=feld&err_text=$err_text";
    header($location);
    exit();
}

// als erstes wird die Rolle uebergeben
$rol_id = $_POST["role"];

// Ehemalige
if(!array_key_exists("former", $_POST))
{
    $act_members = 1;
}
else
{
    $act_members = 0;
}

$value = reset($_POST);
$key   = key($_POST);

// Felder zusammenstringen
for($i = 0; $i < count($_POST); $i++)
{
    if(strlen($value) > 0)
    {
        if(substr_count($key, "column") > 0)
        {
            if(strlen($sql_select) > 0) 
            {
                $sql_select = $sql_select. ", ";
            }
            if(is_numeric($value))
            {
                // ein benutzerdefiniertes Feld
                $table_alias = "f". $value;
                
                // JOIN - Syntax erstellen
                $sql_join = $sql_join. " LEFT JOIN ". TBL_USER_DATA ." $table_alias
                                           ON $table_alias.usd_usr_id = usr_id
                                          AND $table_alias.usd_usf_id = $value ";
                
                // hierbei wird die usf_id als Tabellen-Alias benutzt und vorangestellt
                $act_field = "$table_alias.usd_value";
            }
            else
            {
                $act_field = $value;
            }
            
            $sql_select = $sql_select. $act_field;
        }
        elseif(substr_count($key, "sort") > 0)
        {
            if(strlen($sql_orderby) > 0) 
            {  
                $sql_orderby = $sql_orderby. ", ";
            }
            $sql_orderby = $sql_orderby. $act_field. " ". $value;
        }
        elseif(substr_count($key, "condition") > 0)
        {
            if(strpos($act_field, ".") > 0)
            {
                // ein benutzerdefiniertes Feld
                $type = "string";
            }
            else
            {
                $sql = "SELECT $act_field FROM ". TBL_USERS. " LIMIT 1, 1 ";
                $result = mysql_query($sql, $g_adm_con);
                db_error($result);
                $type   = mysql_field_type($result, 0);
            }

            $parser    = new CParser;
            $sql_where = $sql_where. $parser->makeSqlStatement($value, $act_field, $type);
        }
    }
    else
    {
        if(substr_count($key, "column") > 0)
        {
            $act_field = "";
        }
    }

    $value = next($_POST);
    $key   = key($_POST);
}

$main_sql = "SELECT usr_id, $sql_select
               FROM ". TBL_ROLES. ", ". TBL_MEMBERS. ", ". TBL_USERS. "
                    $sql_join
              WHERE rol_org_shortname = '$g_organization'
                AND rol_id     = $rol_id
                AND rol_valid  = 1
                AND mem_rol_id = rol_id
                AND mem_valid  = $act_members
                AND mem_leader = 0
                AND mem_usr_id = usr_id
                AND usr_valid  = 1
                    $sql_where ";
if(strlen($sql_orderby) > 0)
{
    $main_sql = $main_sql. " ORDER BY $sql_orderby ";
}

// SQL-Statement in Session-Variable schreiben
$_SESSION['mylist_sql'] = $main_sql;

// weiterleiten zur allgemeinen Listeseite
$location = "Location: $g_root_path/adm_program/modules/lists/lists_show.php?type=mylist&mode=html&rol_id=$rol_id";
header($location);
exit();

?>