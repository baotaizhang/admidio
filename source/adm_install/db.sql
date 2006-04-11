/******************************************************************************
 * Skript fuer die MySql-Datenbank
 *
 * Copyright    : (c) 2004 - 2005 The Admidio Team
 * Homepage     : http://www.admidio.org
 *
 ******************************************************************************/

drop table if exists %PRAEFIX%_announcements;

drop table if exists %PRAEFIX%_dates;

drop table if exists %PRAEFIX%_folders;

drop table if exists %PRAEFIX%_folder_roles;

drop table if exists %PRAEFIX%_members;

drop table if exists %PRAEFIX%_organizations;

drop table if exists %PRAEFIX%_photos;

drop table if exists %PRAEFIX%_role_categories;

drop table if exists %PRAEFIX%_role_dependencies;

drop table if exists %PRAEFIX%_roles;

drop table if exists %PRAEFIX%_sessions;

drop table if exists %PRAEFIX%_user_data;

drop table if exists %PRAEFIX%_user_fields;

drop table if exists %PRAEFIX%_users;

/*==============================================================*/
/* Table: adm_announcements                                     */
/*==============================================================*/
create table %PRAEFIX%_announcements
(
   ann_id                         int(11) unsigned               not null AUTO_INCREMENT,
   ann_org_shortname              varchar(10)                    not null,
   ann_global                     tinyint(1) unsigned            not null default 0,
   ann_headline                   varchar(50)                    not null,
   ann_description                text,
   ann_usr_id                     int(11) unsigned,
   ann_timestamp                  datetime                       not null,
   ann_last_change                datetime,
   ann_usr_id_change              int(11) unsigned,
   primary key (ann_id)
)
type = InnoDB
auto_increment = 1;

/*==============================================================*/
/* Index: "ANN_ORG_FK"                                            */
/*==============================================================*/
alter table %PRAEFIX%_announcements add index ANN_ORG_FK (ann_org_shortname);

/*==============================================================*/
/* Index: "ANN_USR_FK"                                            */
/*==============================================================*/
alter table %PRAEFIX%_announcements add index ANN_USR_FK(ann_usr_id);

/*==============================================================*/
/* Index: "ANN_USR_CHANGE_FK"                                            */
/*==============================================================*/
alter table %PRAEFIX%_announcements add index ANN_USR_CHANGE_FK (ann_usr_id_change);

/*==============================================================*/
/* Table: adm_dates                                             */
/*==============================================================*/
create table %PRAEFIX%_dates
(
   dat_id                         int(11) unsigned               not null AUTO_INCREMENT,
   dat_org_shortname              varchar(10)                    not null,
   dat_global                     tinyint(1) unsigned            not null default 0,
   dat_begin                      datetime                       not null,
   dat_end                        datetime,
   dat_description                text,
   dat_location                   varchar(100),
   dat_headline                   varchar(50)                    not null,
   dat_usr_id                     int(11) unsigned,
   dat_timestamp                  datetime                       not null,
   dat_last_change                datetime,
   dat_usr_id_change              int(11) unsigned,
   primary key (dat_id)
)
type = InnoDB
auto_increment = 1;

/*==============================================================*/
/* Index: "DAT_ORG_FK"                                            */
/*==============================================================*/
alter table %PRAEFIX%_dates add index DAT_ORG_FK (dat_org_shortname);

/*==============================================================*/
/* Index: "DAT_USR_FK"                                            */
/*==============================================================*/
alter table %PRAEFIX%_dates add index DAT_USR_FK (dat_usr_id);

/*==============================================================*/
/* Index: "DAT_USR_CHANGE_FK"                                            */
/*==============================================================*/
alter table %PRAEFIX%_dates add index DAT_USR_CHANGE_FK (dat_usr_id_change);

/*==============================================================*/
/* Table: adm_folders                                           */
/*==============================================================*/
create table %PRAEFIX%_folders
(
   fol_id                         int(11) unsigned               not null AUTO_INCREMENT,
   fol_org_shortname              varchar(10)                    not null,
   fol_fol_id_parent              int(11) unsigned,
   fol_type                       varchar(10)                    not null,
   fol_name                       varchar(255)                   not null,
   primary key (fol_id)
)
type = InnoDB
auto_increment = 1;

/*==============================================================*/
/* Index: "FOL_ORG_FK"                                            */
/*==============================================================*/
alter table %PRAEFIX%_folders add index FOL_ORG_FK (fol_org_shortname);

/*==============================================================*/
/* Index: "FOL_FOL_PARENT_FK"                                            */
/*==============================================================*/
alter table %PRAEFIX%_folders add index FOL_FOL_PARENT_FK (fol_fol_id_parent);

/*==============================================================*/
/* Table: adm_folder_roles                                      */
/*==============================================================*/
create table %PRAEFIX%_folder_roles
(
   flr_fol_id                     int(11) unsigned               not null,
   flr_rol_id                     int(11) unsigned               not null
)
type = InnoDB;

/*==============================================================*/
/* Index: "FLR_FOL_FK"                                            */
/*==============================================================*/
alter table %PRAEFIX%_folder_roles add index FLR_FOL_FK (flr_fol_id);

/*==============================================================*/
/* Index: "FOL_ROL_FK"                                            */
/*==============================================================*/
alter table %PRAEFIX%_folder_roles add index FOL_ROL_FK (flr_rol_id);

/*==============================================================*/
/* Table: adm_members                                           */
/*==============================================================*/
create table %PRAEFIX%_members
(
   mem_id                         int(11)                        not null AUTO_INCREMENT,
   mem_rol_id                     int(11) unsigned               not null,
   mem_usr_id                     int(11) unsigned               not null,
   mem_begin                      date                           not null,
   mem_end                        date,
   mem_valid                      tinyint(1) unsigned            not null default 1,
   mem_leader                     tinyint(1) unsigned            not null default 0,
   primary key (mem_id),
   unique ak_rol_usr_id (mem_rol_id, mem_usr_id)
)
type = InnoDB
auto_increment = 1;

/*==============================================================*/
/* Index: "MEM_ROL_FK"                                            */
/*==============================================================*/
alter table %PRAEFIX%_members add index MEM_ROL_FK (mem_rol_id);

/*==============================================================*/
/* Index: "MEM_USR_FK"                                            */
/*==============================================================*/
alter table %PRAEFIX%_members add index MEM_USR_FK (mem_usr_id);

/*==============================================================*/
/* Table: adm_organizations                                     */
/*==============================================================*/
create table %PRAEFIX%_organizations
(
   org_id                         tinyint(4)                     not null AUTO_INCREMENT,
   org_longname                   varchar(60)                    not null,
   org_shortname                  varchar(10)                    not null,
   org_org_id_parent              tinyint(4),
   org_homepage                   varchar(30)                    not null,
   org_mail_size                  smallint                       default 1024,
   org_upload_size                smallint                       default 3072,
   org_photo_size                 smallint                       default 512,
   org_mail_extern                tinyint                        not null default 0,
   org_enable_rss                 tinyint                        not null default 1,
   org_bbcode                     tinyint                        not null default 1,
   org_font								 varchar(30)                    not null default 'mr_phone1.ttf',
   primary key (org_id),
   unique ak_shortname (org_shortname)
)
type = InnoDB
auto_increment = 1;

/*==============================================================*/
/* Index: "ORG_ORG_PARENT_FK"                                            */
/*==============================================================*/
alter table %PRAEFIX%_organizations add index ORG_ORG_PARENT_FK (org_org_id_parent);

/*==============================================================*/
/* Table: adm_photos                                            */
/*==============================================================*/
create table %PRAEFIX%_photos
(
   pho_id                         int(11) unsigned               not null AUTO_INCREMENT,
   pho_org_shortname              varchar(10)                    not null,
   pho_quantity                   int(11) unsigned               not null default 0,
   pho_name                       varchar(50)                    not null,
   pho_begin                      date                           not null default '0000-00-00',
   pho_end                        date                           not null default '0000-00-00',
   pho_photographers              varchar(100),
   pho_usr_id                     int(11) unsigned,
   pho_timestamp                  datetime                       not null,
   pho_locked                     tinyint(1) unsigned            not null default 0,
   pho_pho_id_parent              int(11) unsigned,
   pho_last_change                datetime,
   pho_usr_id_change              int(11) unsigned,
   primary key (pho_id)
)
type = InnoDB
auto_increment = 1;

/*==============================================================*/
/* Index: "PHO_ORG_FK"                                            */
/*==============================================================*/
alter table %PRAEFIX%_photos add index PHO_ORG_FK (pho_org_shortname);

/*==============================================================*/
/* Index: "PHO_USR_FK"                                            */
/*==============================================================*/
alter table %PRAEFIX%_photos add index PHO_USR_FK (pho_usr_id);

/*==============================================================*/
/* Index: "PHO_USR_CHANGE_FK"                                            */
/*==============================================================*/
alter table %PRAEFIX%_photos add index PHO_USR_CHANGE_FK (pho_usr_id_change);

/*==============================================================*/
/* Index: "FK_PHO_PHO_PARENT_FK"                                            */
/*==============================================================*/
alter table %PRAEFIX%_photos add index FK_PHO_PHO_PARENT_FK (pho_pho_id_parent);

/*==============================================================*/
/* Table: adm_role_categories                                   */
/*==============================================================*/
create table %PRAEFIX%_role_categories
(
   rlc_id                         int (11) unsigned              not null AUTO_INCREMENT,
   rlc_org_shortname              varchar(10)                    not null,
   rlc_name                       varchar(30)                    not null,
   primary key (rlc_id)
)
type = InnoDB
auto_increment = 1;

/*==============================================================*/
/* Index: "RLC_ORG_FK"                                            */
/*==============================================================*/
alter table %PRAEFIX%_role_categories add index RLC_ORG_FK (rlc_org_shortname);

/*==============================================================*/
/* Table: adm_role_dependencies                                 */
/*==============================================================*/
create table %PRAEFIX%_role_dependencies
(
   rld_rol_id_parent              int(11) unsigned               not null,
   rld_rol_id_child               int(11) unsigned               not null,
   rld_comment                    text,
   rld_usr_id                     int(11) unsigned,
   rld_timestamp                  datetime                       not null,
   primary key (rld_rol_id_parent, rld_rol_id_child)
)
type = InnoDB;

/*==============================================================*/
/* Index: "RLD_USR_FK"                                            */
/*==============================================================*/
alter table %PRAEFIX%_role_dependencies add index RLD_USR_FK (rld_usr_id);

/*==============================================================*/
/* Index: "RLD_ROL_PARENT_FK"                                            */
/*==============================================================*/
alter table %PRAEFIX%_role_dependencies add index RLD_ROL_PARENT_FK (rld_rol_id_parent);

/*==============================================================*/
/* Index: "RLD_ROL_CHILD_FK"                                            */
/*==============================================================*/
alter table %PRAEFIX%_role_dependencies add index RLD_ROL_CHILD_FK (rld_rol_id_child);

/*==============================================================*/
/* Table: adm_roles                                             */
/*==============================================================*/
create table %PRAEFIX%_roles
(
   rol_id                         int(11) unsigned               not null AUTO_INCREMENT,
   rol_org_shortname              varchar(10)                    not null,
   rol_rlc_id                     int(11) unsigned               not null,
   rol_name                       varchar(30)                    not null,
   rol_description                varchar(255),
   rol_moderation                 tinyint(1) unsigned            not null default 0,
   rol_dates                      tinyint(1) unsigned            not null default 0,
   rol_edit_user                  tinyint(1) unsigned            not null default 0,
   rol_photo                      tinyint(1) unsigned            not null default 0,
   rol_download                   tinyint(1) unsigned            not null default 0,
   rol_mail_logout                tinyint(1) unsigned            not null default 0,
   rol_mail_login                 tinyint(1) unsigned            not null default 0,
   rol_locked                     tinyint(1) unsigned            not null default 0,
   rol_start_date                 date,
   rol_start_time                 time,
   rol_end_date                   date,
   rol_end_time                   time,
   rol_weekday                    tinyint(1),
   rol_location                   varchar(30),
   rol_max_members                smallint(3) unsigned,
   rol_cost                       float unsigned,
   rol_last_change                datetime,
   rol_usr_id_change              int(7) unsigned,
   rol_valid                      tinyint(1) unsigned            not null default 1,
   primary key (rol_id)
)
type = InnoDB
auto_increment = 1;

/*==============================================================*/
/* Index: "ROL_ORG_FK"                                            */
/*==============================================================*/
alter table %PRAEFIX%_roles add index ROL_ORG_FK (rol_org_shortname);

/*==============================================================*/
/* Index: "ROL_RLC_FK"                                            */
/*==============================================================*/
alter table %PRAEFIX%_roles add index ROL_RLC_FK (rol_rlc_id);

/*==============================================================*/
/* Index: "ROL_USR_FK"                                            */
/*==============================================================*/
alter table %PRAEFIX%_roles add index ROL_USR_FK (rol_usr_id_change);

/*==============================================================*/
/* Table: adm_sessions                                          */
/*==============================================================*/
create table %PRAEFIX%_sessions
(
   ses_id                         int(11) unsigned               not null AUTO_INCREMENT,
   ses_usr_id                     int(11) unsigned               not null,
   ses_org_shortname              varchar(10)                    not null,
   ses_session                    varchar(35)                    not null,
   ses_timestamp                  datetime                       not null,
   ses_ip_address                 varchar(15),
   ses_longer_session             tinyint(1) unsigned            not null default 0,
   primary key (ses_id),
   key ak_session (ses_session)
)
type = InnoDB
auto_increment = 1;

/*==============================================================*/
/* Index: "SES_USR_FK"                                            */
/*==============================================================*/
alter table %PRAEFIX%_sessions add index SES_USR_FK (ses_usr_id);

/*==============================================================*/
/* Index: "SES_ORG_FK"                                            */
/*==============================================================*/
alter table %PRAEFIX%_sessions add index SES_ORG_FK (ses_org_shortname);

/*==============================================================*/
/* Table: adm_user_data                                         */
/*==============================================================*/
create table %PRAEFIX%_user_data
(
   usd_id                         int(11) unsigned               not null AUTO_INCREMENT,
   usd_usr_id                     int(11) unsigned               not null,
   usd_usf_id                     int(11) unsigned               not null,
   usd_value                      varchar(255),
   primary key (usd_id),
   unique ak_usr_usf_id (usd_usr_id, usd_usf_id)
)
type = InnoDB
auto_increment = 1;

/*==============================================================*/
/* Index: "USD_USF_FK"                                            */
/*==============================================================*/
alter table %PRAEFIX%_user_data add index USD_USF_FK (usd_usf_id);
/*==============================================================*/
/* Index: "USD_USR_FK"                                            */
/*==============================================================*/
alter table %PRAEFIX%_user_data add index USD_USR_FK (usd_usr_id);

/*==============================================================*/
/* Table: adm_user_fields                                       */
/*==============================================================*/
create table %PRAEFIX%_user_fields
(
   usf_id                         int(11) unsigned               not null AUTO_INCREMENT,
   usf_org_shortname              varchar(10),
   usf_type                       varchar(10)                    not null,
   usf_name                       varchar(100)                   not null,
   usf_description                varchar(255),
   usf_locked                     tinyint(1) unsigned            not null default 0,
   primary key (usf_id)
)
type = InnoDB
auto_increment = 1;

/*==============================================================*/
/* Index: "USF_ORG_FK"                                            */
/*==============================================================*/
alter table %PRAEFIX%_user_fields add index USF_ORG_FK (usf_org_shortname);

/*==============================================================*/
/* Table: adm_users                                             */
/*==============================================================*/
create table %PRAEFIX%_users
(
   usr_id                         int(11) unsigned               not null AUTO_INCREMENT,
   usr_last_name                  varchar(30)                    not null,
   usr_first_name                 varchar(30)                    not null,
   usr_address                    varchar(50),
   usr_zip_code                   varchar(10),
   usr_city                       varchar(30),
   usr_country                    varchar(30),
   usr_phone                      varchar(20),
   usr_mobile                     varchar(20),
   usr_fax                        varchar(20),
   usr_birthday                   date,
   usr_gender                     tinyint(1) unsigned,
   usr_email                      varchar(50),
   usr_homepage                   varchar(50),
   usr_login_name                 varchar(20),
   usr_password                   varchar(35),
   usr_last_login                 datetime,
   usr_actual_login               datetime,
   usr_number_login               smallint(5) unsigned           not null default 0,
   usr_date_invalid               datetime,
   usr_number_invalid             tinyint(3) unsigned            not null default 0,
   usr_last_change                datetime,
   usr_usr_id_change              int(11) unsigned,
   usr_valid                      tinyint(1) unsigned            not null default 0,
   usr_reg_org_shortname          varchar(10),
   primary key (usr_id),
   unique ak_usr_login_name (usr_login_name)
)
type = InnoDB
auto_increment = 1;

/*==============================================================*/
/* Index: "USR_USR_CHANGE_FK"                                   */
/*==============================================================*/
alter table %PRAEFIX%_users add index USR_USR_CHANGE_FK (usr_usr_id_change);

/*==============================================================*/
/* Index: "USR_ORG_REG_FK"                                      */
/*==============================================================*/
alter table %PRAEFIX%_users add index USR_ORG_REG_FK (usr_reg_org_shortname);


/*==============================================================*/
/* Constraints between tables                                   */
/*==============================================================*/

alter table %PRAEFIX%_announcements add constraint %PRAEFIX%_FK_ANN_ORG foreign key (ann_org_shortname)
      references %PRAEFIX%_organizations (org_shortname) on delete restrict on update restrict;

alter table %PRAEFIX%_announcements add constraint %PRAEFIX%_FK_ANN_USR foreign key (ann_usr_id)
      references %PRAEFIX%_users (usr_id) on delete restrict on update restrict;

alter table %PRAEFIX%_announcements add constraint %PRAEFIX%_FK_ANN_USR_CHANGE foreign key (ann_usr_id_change)
      references %PRAEFIX%_users (usr_id) on delete set null on update restrict;

alter table %PRAEFIX%_dates add constraint %PRAEFIX%_FK_DAT_ORG foreign key (dat_org_shortname)
      references %PRAEFIX%_organizations (org_shortname) on delete restrict on update restrict;

alter table %PRAEFIX%_dates add constraint %PRAEFIX%_FK_DAT_USR foreign key (dat_usr_id)
      references %PRAEFIX%_users (usr_id) on delete set null on update restrict;

alter table %PRAEFIX%_dates add constraint %PRAEFIX%_FK_DAT_USR_CHANGE foreign key (dat_usr_id_change)
      references %PRAEFIX%_users (usr_id) on delete set null on update restrict;

alter table %PRAEFIX%_folder_roles add constraint %PRAEFIX%_FK_FOL_ROL foreign key (flr_rol_id)
      references %PRAEFIX%_roles (rol_id) on delete restrict on update restrict;

alter table %PRAEFIX%_folder_roles add constraint %PRAEFIX%_FK_FLR_FOL foreign key (flr_fol_id)
      references %PRAEFIX%_folders (fol_id) on delete restrict on update restrict;

alter table %PRAEFIX%_folders add constraint %PRAEFIX%_FK_FOL_FOL_PARENT foreign key (fol_fol_id_parent)
      references %PRAEFIX%_folders (fol_id) on delete restrict on update restrict;

alter table %PRAEFIX%_folders add constraint %PRAEFIX%_FK_FOL_ORG foreign key (fol_org_shortname)
      references %PRAEFIX%_organizations (org_shortname) on delete restrict on update restrict;

alter table %PRAEFIX%_members add constraint %PRAEFIX%_FK_MEM_ROL foreign key (mem_rol_id)
      references %PRAEFIX%_roles (rol_id) on delete restrict on update restrict;

alter table %PRAEFIX%_members add constraint %PRAEFIX%_FK_MEM_USR foreign key (mem_usr_id)
      references %PRAEFIX%_users (usr_id) on delete restrict on update restrict;

alter table %PRAEFIX%_organizations add constraint %PRAEFIX%_FK_ORG_ORG_PARENT foreign key (org_org_id_parent)
      references %PRAEFIX%_organizations (org_id) on delete set null on update restrict;

alter table %PRAEFIX%_photos add constraint %PRAEFIX%_FK_PHO_PHO_PARENT foreign key (pho_pho_id_parent)
      references %PRAEFIX%_photos (pho_id) on delete set null on update restrict;

alter table %PRAEFIX%_photos add constraint %PRAEFIX%_FK_PHO_ORG foreign key (pho_org_shortname)
      references %PRAEFIX%_organizations (org_shortname) on delete restrict on update restrict;

alter table %PRAEFIX%_photos add constraint %PRAEFIX%_FK_PHO_USR foreign key (pho_usr_id)
      references %PRAEFIX%_users (usr_id) on delete set null on update restrict;

alter table %PRAEFIX%_photos add constraint %PRAEFIX%_FK_PHO_USR_CHANGE foreign key (pho_usr_id_change)
      references %PRAEFIX%_users (usr_id) on delete set null on update restrict;

alter table %PRAEFIX%_role_categories add constraint %PRAEFIX%_FK_RLC_ORG foreign key (rlc_org_shortname)
      references %PRAEFIX%_organizations (org_shortname) on delete restrict on update restrict;

alter table %PRAEFIX%_role_dependencies add constraint %PRAEFIX%_FK_RLD_ROL_CHILD foreign key (rld_rol_id_child)
      references %PRAEFIX%_roles (rol_id) on delete restrict on update restrict;

alter table %PRAEFIX%_role_dependencies add constraint %PRAEFIX%_FK_RLD_ROL_PARENT foreign key (rld_rol_id_parent)
      references %PRAEFIX%_roles (rol_id) on delete restrict on update restrict;

alter table %PRAEFIX%_role_dependencies add constraint %PRAEFIX%_FK_RLD_USR foreign key (rld_usr_id)
      references %PRAEFIX%_users (usr_id) on delete set null on update restrict;

alter table %PRAEFIX%_roles add constraint %PRAEFIX%_FK_ROL_ORG foreign key (rol_org_shortname)
      references %PRAEFIX%_organizations (org_shortname) on delete restrict on update restrict;

alter table %PRAEFIX%_roles add constraint %PRAEFIX%_FK_ROL_RLC foreign key (rol_rlc_id)
      references %PRAEFIX%_role_categories (rlc_id) on delete restrict on update restrict;

alter table %PRAEFIX%_roles add constraint %PRAEFIX%_FK_ROL_USR foreign key (rol_usr_id_change)
      references %PRAEFIX%_users (usr_id) on delete set null on update restrict;

alter table %PRAEFIX%_sessions add constraint %PRAEFIX%_FK_SES_ORG foreign key (ses_org_shortname)
      references %PRAEFIX%_organizations (org_shortname) on delete restrict on update restrict;

alter table %PRAEFIX%_sessions add constraint %PRAEFIX%_FK_SES_USR foreign key (ses_usr_id)
      references %PRAEFIX%_users (usr_id) on delete restrict on update restrict;

alter table %PRAEFIX%_user_data add constraint %PRAEFIX%_FK_USD_USF foreign key (usd_usf_id)
      references %PRAEFIX%_user_fields (usf_id) on delete restrict on update restrict;

alter table %PRAEFIX%_user_data add constraint %PRAEFIX%_FK_USD_USR foreign key (usd_usr_id)
      references %PRAEFIX%_users (usr_id) on delete restrict on update restrict;

alter table %PRAEFIX%_user_fields add constraint %PRAEFIX%_FK_USF_ORG foreign key (usf_org_shortname)
      references %PRAEFIX%_organizations (org_shortname) on delete restrict on update restrict;

alter table %PRAEFIX%_users add constraint %PRAEFIX%_FK_USR_USR_CHANGE foreign key (usr_usr_id_change)
      references %PRAEFIX%_users (usr_id) on delete set null on update restrict;

alter table %PRAEFIX%_users add constraint %PRAEFIX%_FK_USR_ORG_REG foreign key (usr_reg_org_shortname)
      references %PRAEFIX%_organizations (org_shortname) on delete restrict on update restrict;
      