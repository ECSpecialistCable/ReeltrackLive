CREATE TABLE users (
id int(11) NOT NULL auto_increment,
username varchar(20),
password varchar(20),
fname varchar(25),
lname varchar(25),
created datetime,
updated datetime,
email varchar(75),
status varchar(25),
PRIMARY KEY (id)
);

CREATE TABLE groups (
id int(11) NOT NULL auto_increment,
pos int(11) default 0,
parent_id int(11) default 0,
name varchar(255),
PRIMARY KEY (id)
);

create table groups_users (
    id int(11) NOT NULL auto_increment,
    pos int(11) default '0',
    compentity_id int(11),
    ref_compentity_id int(11),
    PRIMARY KEY (id)
);

CREATE TABLE permissions (
  id int(11) NOT NULL auto_increment,
  component_type varchar(255),
  can_add char(1) DEFAULT 'N',
  can_edit char(1) DEFAULT 'N',
  can_delete char(1) DEFAULT 'N',
  can_activate char(1) DEFAULT 'N',
  admin char(1) DEFAULT 'N',
  PRIMARY KEY (id)
);

create table groups_permissions (
    id int(11) NOT NULL auto_increment,
    pos int(11) default '0',
    compentity_id int(11),
    ref_compentity_id int(11),
    PRIMARY KEY (id)
);

insert into users (fname,lname,username, password, status) values ('Admin','Account','admin','admin','active');
insert into groups (name) values ('Admin Group');
insert into permissions(component_type,can_add,can_edit,can_delete,can_activate,admin) values('com.monumental.trampoline.security.User','Y','Y','Y','Y','Y');
insert into permissions(component_type,can_add,can_edit,can_delete,can_activate,admin) values('com.monumental.trampoline.security.Group','Y','Y','Y','Y','Y');
insert into groups_users(compentity_id,ref_compentity_id) values(1,1);
insert into groups_permissions(compentity_id,ref_compentity_id) values(1,1);
insert into groups_permissions(compentity_id,ref_compentity_id) values(1,2);
