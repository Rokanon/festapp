drop database fest;

create database fest;

use fest;

create table user_profile(
    id bigint(20) not null auto_increment,
    first_name varchar(20),
    last_name varchar(20),
    username varchar(20),
    password varchar(50),
    phone varchar(15),
    email varchar(30),
    kind tinyint(2) default 0,
    primary key(id)
);
alter table user_profile add column verified tinyint(2) default 0;
alter table user_profile add column blocked tinyint(2) default 0;
alter table user_profile add column times_not_bought_reserved_ticket int default 0;

create table festival(
    id bigint(20) not null auto_increment,
    title varchar(50),
    genre varchar(20),
    begin_date timestamp default '2000-01-01 00:00:00',
    end_date timestamp default '2000-01-01 00:00:00',
    primary key(id)
);
alter table festival add column place varchar(20);
alter table festival add column times_seen bigint(20) default 0;
alter table festival add column tickets_sold bigint(20) default 0;
alter table festival add column max_tickets_per_user int default 0;
alter table festival add column max_tickets_per_user_per_day int default 0;
alter table festival add column price_one_day int default 0;
alter table festival add column price_whole_festival int default 0;
alter table festival add column rating decimal(4,2);
alter table festival add column users_rated int;
alter table festival add column info varchar(1000) default "There is no info for this festival";
alter table festival add column verified boolean default false;

create table festival_day(
    id bigint(20) not null auto_increment,
    festival_id bigint(20),
    date_of_a_day timestamp default '2000-01-01 00:00:00',
    number_of_tickets int,
    primary key (id)
);

create table ticket (
    id bigint(20) not null auto_increment,
    user_id bigint(20),
    festival_id bigint(20),
    primary key(id)
);

create table reservation(
    id bigint(20) not null auto_increment,
    festival_id bigint(20),
    user_id bigint(20),
    time_of_reservation timestamp default current_timestamp,
    duration_time int,
    bought boolean default false,
    primary key(id)
);

create table image(
    id bigint(20) not null auto_increment, 
    festival_id bigint(20),
    file_name varchar(100),
    file_size bigint(20),
    primary key(id)
);
alter table image add column approved int default 0;

create table video(
    id bigint(20) not null auto_increment, 
    festival_id bigint(20),
    file_name varchar(100),
    file_size bigint(20),
    primary key(id)
);
alter table video add column approved int default 0;

create table artist(
    id bigint(20) not null auto_increment,
    festival_id bigint(20),
    artist_name varchar(20),
    performance_date timestamp,
    performance_time_start time,
    performance_time_end time,
    primary key(id)
);
alter table artist add column performance_end_date timestamp default current_timestamp;

create table comment(
    id bigint(20) not null auto_increment,
    festival_id bigint(20),
    festival_title varchar(50),
    user_id bigint(20),    
    text varchar(512),
    rating decimal(4,2) default -1,
    primary key(id)
);

create table social_networks(
    festival_id bigint(20) not null,
    facebook varchar(20),
    twitter varchar(20),
    youtube varchar(20),
    primary key(festival_id)
);

-- inserting data

insert into artist(festival_id, artist_name, performance_date, performance_time_start, performance_time_end) values (1, "Riblja Corba", "2017-08-23 00:00:00", "22:30:00", "00:00:00");
insert into artist(festival_id, artist_name, performance_date, performance_time_start, performance_time_end) values (1, "Bajaga", "2017-08-23 00:00:00", "21:30:00", "22:15:00");

insert into user_profile(first_name,last_name,username, password, phone, email, kind, verified) VALUES ('Admin', 'Admin', 'admin', 'admin', '00000000', 'admin@admin.com', 1, 1);
insert into user_profile(first_name,last_name,username, password, phone, email, kind, verified) VALUES ('User', 'User', 'user', 'user', '11111111', 'user@user.com', 0, 1);
insert into user_profile(first_name,last_name,username, password, phone, email, kind, verified) VALUES ('Pera', 'Peric', 'pera987', '100j@d1n', '0645555555', 'pera.peric@gmail.com', 0, 0);
insert into user_profile(first_name,last_name,username, password, phone, email, kind, verified) VALUES ('Mika', 'Peric', 'Mika987', 'mikaperic555', '0645555555', 'mika.peric@gmail.com', 0, 0);


insert into festival(title, genre, begin_date, end_date, place, times_seen, tickets_sold, verified) values ("Beer fest", "Rock" ,"2017-08-22 00:00:00", "2017-08-26 00:00:00", "Usce", 25, 7, true);
insert into festival(title, genre, begin_date, end_date, place, times_seen, tickets_sold, verified) values ("Guca", "Folk" ,"2017-08-12 00:00:00", "2017-08-20 00:00:00", "Guca", 55, 15, false);
insert into festival(title, genre, begin_date, end_date, place, times_seen, tickets_sold, verified) values ("Foam fest", "Techno" ,"2017-08-28 00:00:00", "2017-09-02 00:00:00", "Beograd", 56, 25, true);
insert into festival(title, genre, begin_date, end_date, place, times_seen, tickets_sold, verified) values ("Exit", "multiple" ,"2017-07-08 00:00:00", "2017-07-12 00:00:00", "Novi Sad",100, 78, true);
insert into festival(title, genre, begin_date, end_date, place, times_seen, tickets_sold, verified) values ("Novogodisnji festival", "Rock" ,"2016-12-25 00:00:00", "2017-01-05 00:00:00", "Trg", 32, 17, true);
insert into festival(title, genre, begin_date, end_date, place, times_seen, tickets_sold) values ("Lim fest", "Rock" ,"2017-08-01 00:00:00", "2017-08-04 00:00:00", "Lim",4, 2);

-- Triger
drop update_festival_tickets;

DELIMITER $$
CREATE TRIGGER update_festival_tickets
  AFTER UPDATE ON reservation
  for each row
    UPDATE festival f
      when NEW.bought=1 then SET f.tickets_sold = f.tickets_sold + 1 
      WHERE NEW.festival_id = f.id ;
$$;


drop delete_reservation;
-- event to delete reservation after two days if ticket is not bought
DELIMITER $$
    CREATE EVENT delete_reservation
    ON SCHEDULE AT CURRENT_TIMESTAMP + INTERVAL 1 DAY
    ON COMPLETION PRESERVE
    DO
      DELETE FROM reservation WHERE time_of_reservation < (CURDATE() - INTERVAL 2 DAY) and bought=0;
$$;

drop trigger success_times_not_bought;

DELIMITER $$
    CREATE TRIGGER success_times_not_bought 
    BEFORE DELETE on reservation
    FOR EACH ROW
    BEGIN
    UPDATE USER_PROFILE u SET u.times_not_bought_reserved_ticket=u.times_not_bought_reserved_ticket+1 
        WHERE u.id=OLD.user_id;
    END
$$;

drop trigger set_bought;

DELIMITER $$
CREATE TRIGGER set_bought
  BEFORE UPDATE ON user_profile
  for each row
    BEGIN
      IF (NEW.times_not_bought_reserved_ticket=3)
      THEN SET NEW.blocked=1;
      END IF;
    END
$$;

create table logged_in_users(
    id bigint(20) NOT NULL auto_increment,
    user_name varchar(20),
    user_id bigint(20),
    primary key(id)
);

create table message(
    id bigint(20) NOT NULL auto_increment,
    user_id bigint(20),
    festival_id bigint(20),
    primary key(id)
);

