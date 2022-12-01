select distinct dept_name from course where credits > 3;
select building,room_number from classroom where building ='Watson' or building ='Packard';
select  course_id ,title from course where dept_name = 'Comp. Sci.';
select distinct course_id from takes where semester = 'Fall';
select name from student where tot_cred >=45 and tot_cred<=90;
select name from student where name like '%a' or  name like '%e' or name like '%u' or name like '%i' or name like '%o';
select course_id from prereq where prereq_id = 'CS-101';


select dept_name ,avg(salary) from instructor group by dept_name order by avg(salary) ;
select building from section group by building having COUNT(*)= (SELECT COUNT(course_id) from section group by building limit 1);
select dept_name from course group by dept_name having COUNT(*)= (SELECT COUNT(course_id) from course group by dept_name limit 1);

select student.id, name from student join takes on student.id = takes.id group by student.id, name
having count(course_id like 'CS%')>3;

select all name from instructor where dept_name ='Biology' or dept_name = 'Music' or dept_name ='Philosophy';
select all id from teaches where year ='2018' except select all id from teaches where year='2017';


select distinct student.id, name from student join takes on student.id = takes.id where course_id like 'CS%' and  grade like 'A%' order by name ASC;
select distinct i_id from advisor join takes on s_id= id where grade like 'B-' or grade like 'C%' or grade='F' or grade is null;

select distinct student.dept_name from student join takes on student.id = takes.id
except select distinct student.dept_name from student join takes on student.id = takes.id
where grade like 'C%' or grade like 'F' or grade is null;

select distinct name from instructor
    join teaches on instructor.id = teaches.id
    join takes on teaches.course_id = takes.course_id
except select distinct name from instructor
    join teaches on instructor.id = teaches.id
    join takes on teaches.course_id = takes.course_id
    where grade like 'A%';

select distinct course_id from section join time_slot on time_slot.time_slot_id = section.time_slot_id
except select distinct course_id from section join time_slot on time_slot.time_slot_id = section.time_slot_id
where end_hr >=13;