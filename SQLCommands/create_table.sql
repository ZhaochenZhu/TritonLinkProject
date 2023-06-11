create table student (
    student_id numeric(10)  not null primary key,
    first_name varchar(50) not null,
    last_name varchar(50) not null,
    middle_name varchar(50),
    ssn numeric(10),
    enrolled varchar(10) not null,
    residential_status varchar(20) not null,
    current_degree varchar(20) not null
);

drop table student_period_attendance ;
create  table student_period_attendance (
    student_id numeric(10) not null,
    quarter varchar(50) not null,
	year numeric(4) not null,
	enrolled varchar(10) not null,
    FOREIGN KEY (student_id) REFERENCES student,
    primary key (student_id, quarter, year)
);

create table student_past_degree (
    student_id numeric(10) not null,
    degree varchar(50) not null,
    period varchar(50) not null,
    primary key (student_id,degree,period),
    FOREIGN KEY (student_id) REFERENCES student
);

create table undergraduate_student (
    student_id numeric(10) not null primary key,
    college varchar(50) not null,
    FOREIGN KEY (student_id) REFERENCES student
);

create table undergraduate_major (
    student_id numeric(10) not null,
    major varchar(50) not null,
    primary key (student_id,major),
    FOREIGN KEY (student_id) REFERENCES student
);

create table undergraduate_minor (
    student_id numeric(10) not null,
    minor varchar(50) not null,
    primary key (student_id,minor),
    FOREIGN KEY (student_id) REFERENCES student
);

create table master_student (
    student_id numeric(10) not null primary key,
    department varchar(50) not null,
    FOREIGN KEY (student_id) REFERENCES student
);

create table PhD_student (
    student_id numeric(10) not null primary key,
    candidacy varchar(50) not null,
    foreign key (student_id) references student
);

create table probation (
    probation_year numeric(4) not null,
    probation_quarter varchar(50),
    primary key(probation_year,probation_quarter)
);

create table course_info (
    course_number varchar(50) not null primary key,
    course_name varchar(50) not null,
    department varchar(50) not null,
    lab_requirement varchar(50) not null
);

create table past_names (
    course_number varchar(50) not null,
    past_names varchar(50) not null,
    primary key(course_number, past_names),
    foreign key (course_number) references course_info
);

create table prerequisite (
    course_number varchar(50) not null,
    prerequisite varchar(50) not null,
    primary key (course_number,prerequisite),
    foreign key (course_number) references course_info,
    foreign key (prerequisite) references course_info(course_number)
);

create table units_allowed (
    course_number varchar(50) not null,
    units_range numeric(2) not null,
    primary key (course_number,units_range),
    foreign key (course_number) references course_info
);

create table grading_option (
    course_number varchar(50) not null,
    grading_options varchar(50) not null,
    primary key (course_number,grading_options),
    foreign key (course_number) references course_info
);

create table section (
    year numeric(4) not null,
    section_id varchar(50) not null,
    course_number varchar(50) not null,
    quarter varchar(50) not null,
    units numeric(2) not null,
    start_date varchar(50) not null,
    end_date varchar(50) not null,
    professor varchar(50) not null,
    grading_option varchar(50) not null,
    primary key (year, section_id, course_number),
    foreign key (course_number) references course_info
);

create table faculty(
    faculty_name varchar(50) primary key,
    title varchar(50) not null
);

create table faculty_department(
    faculty_name varchar(50),
    department varchar(50),
    primary key (faculty_name,department),
    foreign key (faculty_name) references faculty
);

create table total_unit_requirement(
    discipline varchar(50),
    degree_type varchar(50),
    degree_focus varchar(50),
    total_unit numeric(10) not null,
    primary key (discipline,degree_type, degree_focus)
);


create table undergrad_unit_requirement (
    discipline character varying(50),
    degree_type character varying(50),
    degree_focus varchar(50),
    category character varying(50),
    minimum_unit numeric(10,0),
    minimum_grade numeric(10,2) NOT NULL,
    primary key (discipline, degree_type, degree_focus, category),
    foreign key (discipline, degree_type, degree_focus) references total_unit_requirement
);


create table undergrad_course_requirement (
    discipline character varying(50),
    degree_type character varying(50),
    degree_focus varchar(50),
    category varchar(50),
    course_number varchar(50),
    primary key (discipline, degree_type, degree_focus, category, course_number),
    foreign key (course_number) references course_info,
    foreign key (discipline, degree_type, degree_focus,category) references undergrad_unit_requirement
);


CREATE TABLE master_concentration_requirement (
    discipline character varying(50),
    degree_type character varying(50),
    degree_focus varchar(50),
    concentration varchar(50),
    minimum_unit numeric(10,0),
    minimum_grade numeric(10,2) NOT NULL,
    PRIMARY KEY (discipline, degree_type, degree_focus, concentration),
    foreign key (discipline, degree_type, degree_focus) references total_unit_requirement
  );

create table master_course_requirement(
    discipline character varying(50),
    degree_type character varying(50),
    degree_focus varchar(50),
    concentration varchar(50),
    course_number varchar(50),
    primary key(discipline, degree_type, degree_focus,concentration,course_number),
    foreign key (course_number) references course_info,
    foreign key (discipline, degree_type, degree_focus,concentration) references master_concentration_requirement
);


create table meetings(
    type varchar(50),
    primary key (type)
);

create table current_classes (
	faculty_name varchar(50),
	course_number varchar(50),
	year numeric(4) not null,
	section_id varchar(50) not null,
	primary key(faculty_name, course_number, year, section_id),
	foreign key (faculty_name) references faculty,
	foreign key (course_number)references course_info,
	foreign key (year, section_id, course_number) references section
);

create table taught_classes (
	faculty_name varchar(50),
	course_number varchar(50),
	year numeric(4) not null,
	section_id varchar(50) not null,
	primary key(faculty_name, course_number, year, section_id),
	Foreign key (faculty_name) references faculty,
	Foreign key (course_number)references course_info,
	Foreign key (year, section_id, course_number) references section

);

create table scheduled_course (
	faculty_name varchar(50),
	course_number varchar(50),
	primary key (faculty_name, course_number),
	foreign key (faculty_name) references faculty,
	foreign key (course_number) references course_info
);

create table advisor (
	student_id numeric(10),
	faculty_name varchar(50),
	primary key (student_id, faculty_name),
	foreign key (student_id) references student,
	foreign key (faculty_name) references faculty
);

create table thesis_committee (
	student_id numeric(10),
	faculty_name varchar(50),
	primary key (student_id, faculty_name),
	foreign key (student_id) references student,
	foreign key (faculty_name) references faculty
);

create table courses_taken (
	student_id numeric(10),
	course_number varchar(50),
	section_id varchar(50),
	year numeric(4),
	unit numeric(2) not null,
	grade varchar(2) not null,
	professor varchar(50) not null,
	grading_option varchar(50) not null,
	primary key(student_id, course_number, section_id, year),
	foreign key (student_id) references student,
	foreign key (course_number) references course_info,
	foreign key (year, section_id, course_number) references section
);

create table waitlist_of_class (
	year numeric(4),
	section_id varchar(50),
	course_number varchar(50),
	student_id numeric(10),
	grading_option varchar(50) not null,
    unit numeric(2) not null,
	primary key (year, section_id, course_number, student_id),
	foreign key (course_number) references course_info,
	foreign key (student_id) references student,
	foreign key (year, section_id, course_number) references section
);

create table enrollment_list_of_class (
	year numeric(4),
	section_id varchar(50),
	course_number varchar(50),
	student_id numeric(10),
	grading_option varchar(50) not null,
	unit numeric(2) not null,
	primary key (year, section_id, course_number, student_id),
	foreign key (course_number) references course_info,
	foreign key (student_id) references student,
	foreign key (year, section_id, course_number) references section
);

create table department_approval_of_class (
	year numeric(4),
	section_id varchar(50),
	course_number varchar(50),
	student_id numeric(10),
	primary key(year, section_id, course_number, student_id),
	foreign key (course_number) references course_info,
	foreign key (student_id) references student,
	foreign key (year, section_id, course_number) references section
);

create table class_meetings_times (
	year numeric(4),
	section_id varchar(50),
	course_number varchar(50),
	type varchar(50),
	day varchar(50),   
	date varchar(50),
	start_time varchar(50) not null,
	end_time varchar(50) not null,
	primary key(year, section_id, course_number, type, day, date),
	foreign key (course_number) references course_info,
	foreign key (year, section_id, course_number) references section,
	foreign key (type) references meetings
);

create table class_meeting_info(
    year numeric(4),
    section_id varchar(50),
    course_number varchar(50),
    type varchar(50),
    location varchar(50) not null,
    date varchar(50) not null,
    start_time varchar(50) not null,
    end_time varchar(50) not null,
    primary key (year,section_id,course_number,type,date),
    foreign key (course_number) references course_info,
    foreign key (year, section_id, course_number) references section,
    foreign key (type) references meetings
);

create table student_probation(
    student_id numeric(10),
    probation_year numeric(4),
    probation_quarter varchar(50),
    probation_reason varchar(50) not null,
    primary key (student_id,probation_year,probation_quarter),
    foreign key (student_id) references student,
    foreign key (probation_year, probation_quarter) references probation (probation_year, probation_quarter)
);

create table review_session_times( 
start_time varchar(50), 	
end_time varchar(50), 
primary key (start_time,end_time) 
);

create table review_session_range( 
date varchar(50), 
primary key (date) 
);

Insert into review_session_times values('8:00','9:00'); 
Insert into review_session_times values('9:00','10:00'); 
Insert into review_session_times values('10:00','11:00');
Insert into review_session_times values('11:00','12:00'); 
Insert into review_session_times values('12:00','13:00'); 
Insert into review_session_times values('13:00','14:00'); 
Insert into review_session_times values('14:00','15:00'); 
Insert into review_session_times values('15:00','16:00'); 
Insert into review_session_times values('16:00','17:00'); 
Insert into review_session_times values('17:00','18:00'); 
Insert into review_session_times values('18:00','19:00'); 
Insert into review_session_times values('19:00','20:00');


ALTER TABLE section
ALTER COLUMN units TYPE varchar(10);

CREATE TABLE grade_conversion (
    letter_grade character(2) NOT NULL,
    number_grade numeric(2,1)
);


CREATE TABLE quarter_conversion (
    quarter character varying(50) PRIMARY KEY,
    number numeric
);
Insert into quarter_conversion(‘Winter’, 1)
Insert into quarter_conversion(Spring’, 2)
Insert into quarter_conversion(‘Summer’, 3)
Insert into quarter_conversion(‘Fall’, 4)


ALTER TABLE section
ADD maximum_seats numeric (10, 0);
ALTER TABLE section
ADD available_seats numeric (10, 0);
