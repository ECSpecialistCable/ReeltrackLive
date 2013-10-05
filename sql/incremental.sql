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
	manufacturer varchar(25),
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




