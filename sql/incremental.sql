alter table users add column type varchar(25);
alter table users add column customer_id int default 0;

create table customers (
	id int(11) NOT NULL auto_increment,
	created datetime,
	updated datetime,
	status varchar(25),
	name varchar(255),
	PRIMARY KEY (id)
);

create table customer_jobs (
	id int(11) NOT NULL auto_increment,
	created datetime,
	updated datetime,
	status varchar(25),
	name varchar(255),
	code varchar(25),
	customer_id int default 0,
	PRIMARY KEY (id)
);

create table customer_jobs_to_users (
	id int(11) NOT NULL auto_increment,
	pos int default 0,
	compentity_id int default 0,
	ref_compentity_id int default 0,
	PRIMARY KEY (id)
);

create table foremans (
	id int(11) NOT NULL auto_increment,
	created datetime,
	updated datetime,
	status varchar(25),
	name varchar(255),
	PRIMARY KEY (id)
);

create table whlocations (
	id int(11) NOT NULL auto_increment,
	created datetime,
	updated datetime,
	status varchar(25),
	name varchar(255),
	PRIMARY KEY (id)
);

create table drivers (
	id int(11) NOT NULL auto_increment,
	created datetime,
	updated datetime,
	status varchar(25),
	name varchar(255),
	PRIMARY KEY (id)
);

alter table foremans add column customer_id int default 0;
alter table whlocations add column customer_id int default 0;
alter table drivers add column customer_id int default 0;

create table settings (
	id int(11) NOT NULL auto_increment,
	created datetime,
	updated datetime,
	status varchar(25),
	auto_print_reel_tags varchar(1) default 'n',
	PRIMARY KEY (id)
);
alter table settings add column customer_id int default 0;

create table reels (
	id int(11) NOT NULL auto_increment,
	created datetime,
	updated datetime,
	status varchar(25),
	name varchar(255),
	wharehouse_location_id int default 0,
	reel_type varchar(15),
	reel_tag varchar(25),
	cable_description text,
	customer_pn varchar(25),
	ecs_pn varchar(25),
	manufacturer varchar(100),
	steel_reel_serial varchar(25),
	received_on datetime,
	times_checked_out int default 0,
	times_checked_in int default 0,
	carrier varchar(25),
	tracking_pro varchar(25),
	packing_list varchar(25),
	projected_shipping_date datetime,
	receiving_issue varchar(25),
	ordered_quantity int default 0,
	shipped_quantity int default 0,
	received_quantity int default 0,
	bottom_foot int default 0,
	top_foot int default 0,
	cable_used_quantity int default 0,
	PRIMARY KEY (id)
);

alter table reels add column job_id int default 0;

create table reel_logs (
	id int(11) NOT NULL auto_increment,
	created datetime,
	updated datetime,
	status varchar(25),
	reel_id int default 0,
	created_by varchar(30),
	note text,
	PRIMARY KEY (id)
);

alter table reels drop column reel_type;
alter table reels add reel_type varchar(15) default 'bulk';
alter table reels drop column wharehouse_location_id;
alter table reels add wharehouse_location varchar(15) default 'none';
alter table reels add receiving_disposition varchar(10);

create table reel_circuits (
	id int(11) NOT NULL auto_increment,
	created datetime,
	updated datetime,
	status varchar(25),
	reel_id int default 0,
	name varchar(30),
	length int default 0,
	is_pulled varchar(1) default 'n',
	PRIMARY KEY (id)
);

create table reel_notes (
	id int(11) NOT NULL auto_increment,
	created datetime,
	updated datetime,
	status varchar(25),
	reel_id int default 0,
	created_by varchar(30),
	note text,
	PRIMARY KEY (id)
);

create table reel_issues (
	id int(11) NOT NULL auto_increment,
	created datetime,
	updated datetime,
	status varchar(25),
	reel_id int default 0,
	created_by varchar(30),
	description text,
	issue_log text,
	is_resolved varchar(1) default 'n',
	PRIMARY KEY (id)
);

alter table reels add customer_po varchar(25);
alter table reels add receiving_note text;
alter table reels add pick_list_id int default 0;

create table picklists (
	id int(11) NOT NULL auto_increment,
	created datetime,
	updated datetime,
	status varchar(25),
	name varchar(255),
	job_id int default 0,
	foreman varchar(25),
	driver varchar(25),
	PRIMARY KEY (id)
);

alter table reels add on_reel_quantity int default 0;

create table reeltrack_transactions (
	id int(11) NOT NULL auto_increment,
	status varchar(25),
	OrdNo varchar(50),
	PORevision smallint(6),
	AbsoluteItem smallint(6),
	ReelSerial smallint(6),
	PRIMARY KEY (id)
);

alter table reels add OrdNo varchar(50);
alter table reels add PORevision int default 0;
alter table reels add AbsoluteItem int default 0;
alter table reels add ReelSerial int default 0;
alter table reels add job_code varchar(50);

alter table reels add ctr_number varchar(50);
alter table reels add ctr_date date;
alter table reels add ctr_sent date;

create table cable_tech_data (
	id int(11) NOT NULL auto_increment,
	created datetime,
	updated datetime,
	status varchar(25),
	reel_id int default 0,
	Conductor_Area int default 0,
	Conductor_GroundSize varchar(10),
	Insulation_Thickness smallint default 0,
	Insulation_Compound varchar(25),
	Insulation_Colorcode varchar(25),
	ShieldType varchar(25),
	Jacket_Thickness smallint default 0,
	Jacket_Compound varchar(25),
	Cable_OD double default 0,
	Cable_Weight int default 0,
	Cable_Radius double default 0,
	Cable_XSection double default 0,
	Cable_PullTension int default 0,
	ECSPartNo varchar(15),
	PRIMARY KEY (id)
);

alter table picklists add job_code varchar(25);

alter table reels add ctr_file varchar(100);
alter table reels add data_sheet_file varchar(100);

alter table cable_tech_data add data_sheet_file varchar(100);

alter table cable_tech_data add job_code varchar(50);
alter table cable_tech_data add ecs_pn varchar(25);

alter table reels add rt_qrcode_file varchar(50);
alter table reels add pl_qrcode_file varchar(50);

alter table reels add cr_id int default 0;

alter table reels add pn_volt varchar(2);
alter table reels add pn_gauge varchar(3);
alter table reels add pn_conductor varchar(2);

alter table customer_jobs add auto_print_reel_tags varchar(1) default 'n';

/* 12/02/2013 */
create table glossary (
	id int(11) NOT NULL auto_increment,
	created datetime,
	updated datetime,
	status varchar(25),
	name varchar(255),
	job_id int default 0,
	description text,
	PRIMARY KEY (id)
);

/* 12/10.2013 */
alter table reels add reel_tag_file varchar(50);

/* 12/12/13*/
alter table reel_logs add on_reel_quantity int default 0;
alter table reel_logs add top_foot int default 0;
alter table reels add has_reel_tag_file varchar(1) default 'n';

/* 12/20/2013 */
create table file_cabinet (
	id int(11) NOT NULL auto_increment,
	created datetime,
	updated datetime,
	status varchar(25),
	title varchar(255),
	job_id int default 0,
	file_name varchar(255),
	PRIMARY KEY (id)
);

alter table reels add has_reel_tag_file varchar(1) default 'n';
alter table reels add has_reel_markers varchar(1) default 'n';
alter table reels add received_weight int default 0;
alter table reels add current_weight int default 0;

create table reeltrack_circuits (
	id int(11) NOT NULL auto_increment,
	created datetime,
	updated datetime,
	reel_id int default 0,
	OrdNo varchar(50),
	PORevision smallint(6),
	AbsoluteItem smallint(6),
	ReelSerial smallint(6),
	name varchar(30),
	length int default 0,
	is_pulled varchar(1) default 'n',
	synced_date datetime,
	PRIMARY KEY (id)
);

alter table reel_circuits add is_synced varchar(1) default 'n';

alter table reels add ECSInvoice varchar(50);
alter table reels add ECSInvoiceDate date;
alter table reels add is_steel_reel varchar(1) default 'n';

alter table customers add issue_contact_email varchar(255);

alter table cable_tech_data add column est_al_weight int default 0;
alter table cable_tech_data add column est_cu_weight int default 0;

alter table customers add scans_must_match varchar(1) default 'n';

/* 020114 */
alter table reels add shipping_date datetime;
alter table reels add bottom_foot_not_visible varchar(1) default 'n';
alter table cable_tech_data add column con_al_weight int default 0;
alter table cable_tech_data add column con_cu_weight int default 0;
alter table file_cabinet add customer_id int default 0;

/* 02/05/2014 */
alter table glossary add column glossary_type varchar(255);
alter table reel_circuits add act_length int default 0;

/* 02/25/2014 */
alter table reels add pos int default 0;

alter table reels add UniqueID int default 0;


/* 02/28/2014 */
alter table customer_jobs add bom_pdf varchar(255);
alter table cable_tech_data add usage_tracking varchar(255);

alter table reels add orig_top_foot int default 0;

/* 4/22/15*/
alter table customer_jobs add scans_must_match varchar(1) default 'n';

/* june 11 */
alter table users add column can_add_user varchar(1) default 'n';

alter table cable_tech_data add qrc_tracking char(1) default 'n';

/* feb 1 */
alter table glossary add is_video char(1) default 'n';
alter table glossary add video_url varchar(255);

/* june 6th */
alter table reels add vendor_code varchar(25);
alter table reels add vendor_abbrev_name varchar(25);

alter table users add column vendor_code varchar(15);

/* 2016 */
alter table reel_circuits add max_tension int(11) default 0;

create table reel_pulls (
	id int(11) NOT NULL auto_increment,
	created datetime,
	updated datetime,
	status varchar(25),
	reel_id int default 0,
	length int default 0,
	is_pulled varchar(1) default 'n',
	max_tension int(11) default 0,
	is_synced varchar(1) default 'n',
	PRIMARY KEY (id)
);

alter table reel_circuits add column pos int(11) default 0;
alter table reel_circuits add column kind varchar(1) default 'c';
alter table reel_circuits add column marker int(11) default 0;
