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

