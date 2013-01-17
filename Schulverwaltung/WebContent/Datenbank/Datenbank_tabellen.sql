###Erstellung der Datenbank Schulverwaltung

create database schulverwaltung;
use schulverwaltung

create table student 
	(
		id int primary key,
		name varchar(100),
		firstname varchar(100),
		street varchar (100),
		city varchar (100),
		plz varchar (100),
		birthday date,
		entry date,
		shortened boolean,
		phone varchar(100),
		email varchar (100),
		instructorid int,
		jobId int,
		religionId int,
		disableflag int default 0
	);

create table subject
	(
		id int primary key,
		short varchar(20),
		description varchar(500),
		disableflag int default 0
	);

create table religion
	(
		id int primary key,
		description varchar(500),
		subjectid int,
		disableflag int default 0
	);

create table timetable
	(
		id int primary key,
		validTill date,
		disableflag int default 0
	);

create table gradeGroup
	(
		id int primary key,
		gradeId int,
		description varchar(500),
		disableflag int default 0
	);

create table guardian
	(
		id int primary key,
		name varchar (100),
		firstname varchar(100),
		phone varchar (100),
		street varchar (100),
		city varchar (100),
		plz varchar (100),
		disableflag int default 0
	);

create table hour2subject
	(
		group2subjectId int primary key,
		hour varchar(100),
		groupid int,
		disableflag int default 0
	);

create table typification
	(
		id int primary key,
		description varchar (500),
		disableflag int default 0
	);

create table grade
	(
		id int primary key,
		description varchar (500),
		roomId int (100),
		teacherId int (100),
		disableflag int default 0
	);

create table exam
	(
		id int primary key,
		typeId int,
		executionDate date,
		group2SubjectId int,
		announceDate date,
		minPoints1 int,
		minPoints2 int,
		minPoints3 int,
		minPoints4 int,
		minPoints5,
		disableflag int default 0
	);

create table job 
	(
		id int primary key,
		description varchar (500),
		duration int,
		disableflag int default 0
	);

create table company
	(
		id int primary key,
		name varchar (100),
		street varchar (100),
		city varchar (100),
		plz varchar (100),
		phone varchar (100),
		disableflag int default 0
	);

create table teacher
	(
		id int primary key,
		name varchar (100),
		firstname varchar (100),
		short varchar(10),
		phone varchar (100),
		email varchar (100),
		roomid int,
		birthday date,
		workhours dec(4,2),
		disableflag int default 0
	);

create table room
	(
		id int primary key,
		number varchar (20),
		description varchar (500),
		disableflag int default 0
	);

create table instructor
	(
		id int primary key,
		name varchar (100),
		firstname varchar (100),
		phone varchar (100),
		email varchar (100),
		companyid int,
		disableflag int default 0
	);

create table mark
	(
		id int primary key,
		mark int,
		studentid int,
		examid int,
		trend varchar (1),
		disableflag int default 0
	);

create table marktype
	(
		id int primary key,
		description varchar (500),
		weight decimal (4,2),
		disableflag int default 0
	);

create table student2guardian
	(
		studentid int,
		guardianid int,
		primary key (studentid, guardianid)
	);


create table student2group
	(
		studentid int,
		groupid int,
		primary key(studentid, groupid)
	);


create table grademaster
	(
		studentid int,
		gradeid int,
		primary key (studentid, gradeid)
	);

create table plan2hour
	(
		timetableid int,
		subjectid int,
		weekday int,
		hour int,
		primary key (timetableid, weekday, hour)
	);

create table student2company
	(
		studentid int,
		companyid int,
		primary key (studentid, companyid)
	);

create table student2typification
	(
		studentid int,
		typificationid int,
		primary key (studentid, typificationid)
	);

create table group2subject
	(
		id int primary key auto_increment,
		groupid int,
		subjectid int,
		roomid int,
		teacherid int,
		disableflag int
	);

create table free2subjekt
	(
		studentid int,
		subjectid int,
		freedate date,
		primary key (studentid, subjectid)
	);

create table login
	(
		login varchar(60) primary key,
		password varchar(20),
		email varchar (100)
	);

CREATE OR REPLACE VIEW qryStudent 
(
	Id, Name, Firstname, Street, City, plz, birthday, 
	entry, shortened, phone, email, Instructor, Company, 
	Job, Religion, disableflag
)
AS 
(
	SELECT student.Id, student.Name, student.Firstname,
	student.Street, student.City, student.plz, student.birthday, 
	entry, shortened, student.phone, student.email, 
	Concat(Concat(instructor.Name, ' '), instructor.Firstname), 
	company.Name, job.description, religion.description, 
	student.disableflag 
	FROM Student 
	LEFT JOIN instructor ON instructorid = instructor.id 
	LEFT JOIN religion ON religionId = religion.Id 
	LEFT JOIN company ON instructor.companyId = company.id 
	LEFT JOIN job ON jobId = job.id
);

CREATE OR REPLACE VIEW qryReligion
(
		id,
		description,
		subject,
		disableflag
)
AS
(
	SELECT religion.id, religion.description, subject.description, religion.disableflag 
	FROM religion LEFT JOIN subject on religion.subjectId = subject.id
);

CREATE OR REPLACE VIEW qryGrade
(
	id,
	description,
	room,
	teacher,
	disableflag
)
AS
(
	SELECT grade.id, grade.description, room.number, 
	       Concat(Concat(teacher.Name, ' '), teacher.Firstname), grade.disableflag
	FROM grade
	LEFT JOIN room on grade.roomId = room.id  
	LEFT JOIN teacher on grade.teacherId = teacher.id
);

CREATE OR REPLACE VIEW qryExam
(	
	id,
	type,
	executionDate,
	subject,
	teacher,
	room,
	gradeGroup,
	grade,
	announceDate,
	disableflag
)
AS
(
	SELECT exam.id, marktype.description, exam.executionDate, 
		   subject.description, Concat(Concat(teacher.Name, ' '), 
		   teacher.Firstname), room.number, gradeGroup.description, grade.Description, exam.announceDate, exam.disableflag
	FROM exam
	LEFT JOIN marktype ON exam.typeId = marktype.Id 
	LEFT JOIN group2subject on exam.group2subjectId = group2subject.Id 
	LEFT JOIN teacher on group2subject.teacherId = teacher.Id 
	LEFT JOIN subject on group2subject.subjectId = subject.Id 
	LEFT JOIN room on group2subject.roomid = teacher.roomid 
	LEFT JOIN gradeGroup on group2subject.groupId = gradeGroup.id 
	LEFT JOIN grade on gradeGroup.gradeId = grade.id 
);

CREATE OR REPLACE VIEW qryTeacher
(
	id,
	name,
	firstname,
	phone,
	email,
	room,
	birthday,
	workhours,
	disableflag
)
AS
(
	SELECT teacher.id, teacher.name, teacher.firstname, teacher.phone, teacher.email, room.number,
		   teacher.birthday, teacher.workhours, teacher.disableflag
	FROM teacher
	LEFT JOIN room on teacher.roomid = room.id
);

CREATE OR REPLACE VIEW qryInstructor
(
	id,
	name,
	firstname,
	phone,
	email,
	company,
	disableflag
)
AS
(
	SELECT instructor.id, instructor.name, instructor.firstname, instructor.phone, 
		   instructor.email, company.name, instructor.disableflag
	FROM instructor
	LEFT JOIN company ON instructor.companyId = company.Id
);

CREATE OR REPLACE VIEW qrymark
(
	id,
	mark,
	student,
	trend,
	disableflag
)
AS
(
	SELECT mark.id, mark.mark, Concat(Concat(student.Name, ' '), 
		   student.Firstname), mark.trend, mark.disableflag
	FROM mark
	LEFT JOIN student on mark.studentId = student.id
);

CREATE OR REPLACE VIEW qrygrademaster
(
	student,
	grade
)
AS
(
	SELECT Concat(Concat(student.Name, ' '), 
		   student.Firstname), grade.description
	FROM grademaster
	LEFT JOIN grade on grademaster.gradeId = grade.id
	LEFT JOIN student on gradeMaster.studentId = student.id
);

insert into login
(login, password, email) values 
("Michael", "asdfg", "m.sachsenhauser@googlemail.com"),
("Nicole", "123", "nicole.uhb@googlemail.com"), 
("Administrator", "Administrator", "");

INSERT INTO MarkType
(id, description, weight, disableflag) VALUES 
(1, "Stegreifaufgabe", 1, 0),
(2, "Schulaufgabe", 2, 0),
(3, "M�ndlich", 1, 0),
(4, "Kurzarbeit", 1, 0);
