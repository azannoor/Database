
use schoolManagement;

create table Userr(
UserID varchar(100) not null primary key,
userType varchar(100),
UserName varchar(100),
age varchar(100),
email varchar(100),
contact varchar(100)
);
insert into Userr(UserID,userType,UserName,age,email,contact) values
('1','student','Ali','18','ali@gmail.com','0321-123'),
('2','Teacher','Usman','24','Usman@gmail.com','0323-445'),
('3','student','David','21','David@gmail.com','0305-231'),
('4','Teacher','Alex','21','alex@gmail.com','0305-231'),
('5','student','batman','21','batman@gmail.com','0305-231'),
('6','student','robert','21','robert@gmail.com','0305-231');

select * from Userr;
truncate table Userr;
drop table Userr;




/*create table fee(
feeID varchar(100) not null primary key,
UserID varchar(100),
foreign key (UserID) references Userr(UserID)

);*/

create table attendance(
AttendanceID varchar(100) not null primary key,
viewDate date,
ATTstatus varchar(100),
UserID varchar(100),
foreign key (UserID) references Userr(UserID),
SectionID varchar(100),
foreign key (SectionID) references programSection(SectionID) 

);
insert into attendance(AttendanceID,viewDate,ATTstatus,UserID,SectionID) values
('1','2023-01-02','present','1','1'),
('2','2023-01-02','present','3','2'),
('3','2023-01-02','absent','5','1'),
('4','2023-01-03','present','1','1'),
('5','2023-01-03','present','3','1'),
('6','2023-01-03','present','5','2'),
('7','2023-01-04','present','1','2'),
('8','2023-01-04','absent','3','2'),
('9','2023-01-04','absent','5','1'),
('10','2023-01-05','present','1','2'),
('11','2023-01-05','present','3','2'),
('12','2023-01-05','absent','5','1'),
('13','2023-02-01','absent','1','2'),
('14','2023-02-01','present','3','2'),
('15','2023-02-01','absent','5','1');


drop table attendance;
truncate table attendance;
create table course(
courseID varchar(100) not null primary key,
courseName varchar(100)
);

insert into course(courseID,courseName) values
('1','Database'),
('2','Intro to Management'),
('3','DSA'),
('4','OOP');

select * from course;
drop table course;
truncate table course;

create table assignedCourse(
assignedID varchar(100) not null primary key,
courseID varchar(100),
foreign key (courseID) references course(courseID),
UserID varchar(100),
foreign key (UserID) references Userr(UserID),
batchID varchar(100),
foreign key (batchID) references Batch(batchID)
);

insert into assignedCourse(assignedID,courseID,UserID,batchID) values
('1','2','2','1'),
('2','4','2','1'),
('3','1','2','2'),
('4','1','4','1');
select * from assignedCourse;
truncate table assignedCourse;
drop table assignedCourse;

create table courseEnrollment(
enrollmentId varchar(100)  not null primary key,
UserID varchar(100),
foreign key (UserID) references Userr(UserID),
courseID varchar(100),
foreign key (courseID) references course(courseID),
enrollstatus varchar(100)
);

insert into courseEnrollment(enrollmentID,UserID,courseID,enrollstatus) values
('1','1','2','enrolled'),
('6','3','1','enrolled'),
('3','5','3','not enrolled');

select * from courseEnrollment;
drop table courseEnrollment;
truncate table courseEnrollment;

create table department(
departmentID varchar(100) not null primary key,
departmentName varchar(100)
);
insert into department(departmentID,departmentName) values
('1','ComputerScience'),
('2','Business Administration'),
('3','Media and Communication');

select * from department;
drop table department;
truncate table department;

create table program(
programID varchar(100) not null primary key,
programName varchar(100),
ProgramStrength varchar(100),
departmentID varchar(100),
foreign key (departmentID) references department(departmentID),
UserID varchar(100),
foreign key (UserID) references Userr(UserID),
batchID varchar(100),
foreign key (batchID) references Batch(batchID)
);




create table Batch(
batchID varchar(100) not null primary key,
batchSeason varchar(100),
batchYear varchar(100),
batchShift varchar(100)

);
drop table batch;
insert into batch(batchID,batchSeason,batchYear,batchShift) values
('1','Fall','2022','morning'),
('2','spring','2023','morning');

insert into program(programID,programName,programStrength,departmentID,UserID,batchID) values
('1','BS software','47','1','3','1'),
('2','BS BBA','40','2','1','2'),
('3','BS IT','50','1','5','1');

select * from program;
drop table program;
truncate table program;

create table programSection(
sectionID varchar(100) not null primary key,
sectionName varchar(100),
strength varchar(100),
userID varchar(100),
foreign key (UserID) references Userr(UserID),
programID varchar(100),
foreign key (programID) references program(programID)
);
drop table programSection;
truncate table programSection;
insert into programSection(sectionID,sectionName,strength,userID,programID) values
('1','A','22','2','1'),
('2','B','25','4','1');


-- queries

-- students with highest attendance percentage

select userName,(sum(case when Attendance.Attstatus='present' then 1 else 0 end)/count(distinct viewDate))* 100 as AttendancePercentage from Attendance
inner join userr on userr.userID=Attendance.userID
group by userName
order by AttendancePercentage desc;



-- current month highest attendance

select userName,sum(case when Attendance.Attstatus='present' then 1 else 0 end) as presentCounts,sum(case when Attendance.Attstatus='Absent' then 1 else 0 end) as AbsentCounts,month(viewDate) as MonthOfYear from Attendance
inner join userr on userr.userID=Attendance.userID
group by month(viewDate),userName
order by month(viewDate),userName;

-- highest number of students

select departmentName,sum(ProgramStrength) as departmentStrength from program
inner join department on department.departmentID=program.departmentID
group by departmentName;


select programName,programStrength from program
order by programStrength desc;

select programName,sectionName,strength as SectionStrength from programSection
inner join program on program.programID=programSection.programID
order by sectionStrength desc;


-- highest number of courses

select batchYear, userName as Teacher,count(assignedCourse.courseID) as HigestCoursesAssigned from assignedCourse
inner join userr on userr.userID=assignedCourse.userID
inner join course on course.courseID=assignedCourse.courseID
inner join batch on batch.batchID=assignedCourse.batchID
group by batch.batchYear;

-- highest number of enrollments

select batchYear, count(case when courseEnrollment.enrollstatus='enrolled' then 1 else 0 end) as highestEnrollments
from courseEnrollment
inner join userr on userr.userID=courseEnrollment.UserID
inner join program on program.userID=userr.UserID
inner join batch on batch.batchID=program.batchID
group by batchYear
order by highestEnrollments desc;


select batchYear,count(case when courseEnrollment.enrollstatus='enrolled'then 1 else 0 end) as highestEnrollments from courseEnrollments
inner join userr on userr.id=courseEnrollment.userID
inner join program on program.userID=userr.UserID







-- students enrolled in the courses

select userName,userType,courseName,enrollStatus from Userr 
inner join courseEnrollment on courseEnrollment.userID=Userr.userID
inner join course on courseEnrollment.courseID=course.courseID;

-- courses assigned to teachers

select userName,userType,courseName from Userr
inner join assignedCourse on assignedCourse.userID=Userr.userID
inner join course on course.courseID=assignedCourse.courseID;


-- Student belongs to which department and program

select userName,userType,departmentName,programName from Userr
inner join program on program.userID=Userr.userID
inner join department on department.departmentID=program.departmentID;


