create table CPG(
course_number varchar(50) not null,
professor varchar(50) not null,
grade varchar(10) not null,
grade_count numeric(10) not null,
primary key(course_number,professor,grade)
);

insert into CPG
select course_number, professor, 'A' as grade, 
sum(CASE WHEN grade like 'A%' Then 1
ELSE 0 END) 
from courses_taken
group by (course_number, professor);

insert into CPG
select course_number, professor, 'B' as grade, 
sum(CASE WHEN grade like 'B%' Then 1
ELSE 0 END) 
from courses_taken
group by (course_number, professor);

insert into CPG
select course_number, professor, 'C' as grade, 
sum(CASE WHEN grade like 'C%' Then 1
ELSE 0 END) 
from courses_taken
group by (course_number, professor);

insert into CPG
select course_number, professor, 'D' as grade, 
sum(CASE WHEN grade like 'D%' Then 1
ELSE 0 END) 
from courses_taken
group by (course_number, professor);

insert into CPG
select course_number, professor, 'other' as grade, 
sum(CASE WHEN grade not like 'A%' and grade not like 'B%' and grade not like 'C%' 
and grade not like 'D%' Then 1
ELSE 0 END)
from courses_taken
group by (course_number, professor);

-- insertion trigger
CREATE or replace FUNCTION insert_grade_trig() RETURNS trigger
LANGUAGE plpgsql AS
$$
BEGIN
IF EXISTS (
select * from CPG
where professor = NEW.professor AND course_number = NEW.course_number
)
THEN 
IF NEW.grade like 'A%' THEN
Update CPG
SET grade_count = grade_count + 1
WHERE course_number = NEW.course_number AND grade = 'A' AND professor = NEW.professor;

ELSIF NEW.grade like 'B%' THEN
Update CPG
SET grade_count = grade_count + 1
WHERE course_number = NEW.course_number AND grade = 'B' AND professor = NEW.professor;

ELSIF NEW.grade like 'C%' THEN
Update CPG
SET grade_count = grade_count + 1
WHERE course_number = NEW.course_number AND grade = 'C' AND professor = NEW.professor;

ELSIF NEW.grade like 'D%' THEN
Update CPG
SET grade_count = grade_count + 1
WHERE course_number = NEW.course_number AND grade = 'D' AND professor = NEW.professor;

ELSE
Update CPG
SET grade_count = grade_count + 1
WHERE course_number = NEW.course_number AND grade = 'other' AND professor = NEW.professor;
END IF;
ELSE
insert into CPG VALUES (NEW.course_number, NEW.professor, 'A', CASE WHEN NEW.grade like 'A%' Then 1
ELSE 0 END);
insert into CPG VALUES (NEW.course_number, NEW.professor, 'B', CASE WHEN NEW.grade like 'B%' Then 1
ELSE 0 END);
insert into CPG VALUES (NEW.course_number, NEW.professor, 'C', CASE WHEN NEW.grade like 'C%' Then 1
ELSE 0 END);
insert into CPG VALUES (NEW.course_number, NEW.professor, 'D', CASE WHEN NEW.grade like 'D%' Then 1
ELSE 0 END);
insert into CPG VALUES (NEW.course_number, NEW.professor, 'other', CASE WHEN NEW.grade not like 'A%' and NEW.grade not like 'B%' and NEW.grade not like 'C%' 
and NEW.grade not like 'D%' Then 1
ELSE 0 END);
END if;
return NEW;
END;
$$;

DROP TRIGGER IF EXISTS insert_grade on courses_taken;
CREATE TRIGGER insert_grade 
AFTER INSERT on courses_taken 
FOR EACH ROW EXECUTE PROCEDURE insert_grade_trig();

DROP TRIGGER IF EXISTS update_grade1 on courses_taken;
DROP TRIGGER IF EXISTS update_grade2 on courses_taken;

CREATE TRIGGER update_grade1 
AFTER update on courses_taken 
FOR EACH ROW EXECUTE PROCEDURE delete_grade_trig();

CREATE TRIGGER update_grade2
AFTER update on courses_taken 
FOR EACH ROW EXECUTE PROCEDURE insert_grade_trig();