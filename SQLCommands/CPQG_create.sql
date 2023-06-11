create table CPQG(
	course_number varchar(50) not null,
	year numeric(4) not null,
	quarter varchar(50) not null,
	professor varchar(50) not null,
	grade varchar(10) not null,
	grade_count numeric(10) not null,
	primary key(course_number, year, quarter, professor,grade)
);

insert into CPQG
select s.course_number, s.year, s.quarter, s.professor, 'A' as grade, 
sum(CASE WHEN grade like 'A%' Then 1
	ELSE 0 END) 
from courses_taken c, section s
where c.course_number = s.course_number and c.section_id = s.section_id 
	and c.year = s.year
group by (s.course_number, s.year, s.quarter, s.professor);

insert into CPQG
select s.course_number, s.year, s.quarter, s.professor, 'B' as grade, 
sum(CASE WHEN grade like 'B%' Then 1
	ELSE 0 END) 
from courses_taken c, section s
where c.course_number = s.course_number and c.section_id = s.section_id 
	and c.year = s.year
group by (s.course_number, s.year, s.quarter, s.professor);

insert into CPQG
select s.course_number, s.year, s.quarter, s.professor, 'C' as grade, 
sum(CASE WHEN grade like 'C%' Then 1
	ELSE 0 END) 
from courses_taken c, section s
where c.course_number = s.course_number and c.section_id = s.section_id 
	and c.year = s.year
group by (s.course_number, s.year, s.quarter, s.professor);

insert into CPQG
select s.course_number, s.year, s.quarter, s.professor, 'D' as grade, 
sum(CASE WHEN grade like 'D%' Then 1
	ELSE 0 END) 
from courses_taken c, section s
where c.course_number = s.course_number and c.section_id = s.section_id 
	and c.year = s.year
group by (s.course_number, s.year, s.quarter, s.professor);

insert into CPQG
select s.course_number, s.year, s.quarter, s.professor, 'other' as grade, 
sum(CASE WHEN grade not like 'A%' and grade not like 'B%' and grade not like 'C%' 
											and grade not like 'D%' Then 1
	ELSE 0 END) 
from courses_taken c, section s
where c.course_number = s.course_number and c.section_id = s.section_id 
	and c.year = s.year
group by (s.course_number, s.year, s.quarter, s.professor);




-- select * from CPQG where course_number = 'CSE 101' AND year=2023 and quarter = 'Winter' and professor = 'Miles Jones'
-- order by grade asc


-- insertion trigger
CREATE or replace FUNCTION insert_grade_quarter_trig() RETURNS trigger
LANGUAGE plpgsql AS
$$
BEGIN
IF EXISTS (
select * from CPQG c, section s
where s.year = NEW.year AND s.course_number = NEW.course_number AND s.section_id = NEW.section_id
AND c.course_number = NEW.course_number AND c.year = NEW.year AND c.quarter = s.quarter 
)
THEN 
IF NEW.grade like 'A%' THEN
Update CPQG
SET grade_count = grade_count + 1 
from section s 
WHERE CPQG.course_number = NEW.course_number AND CPQG.year = NEW.year AND CPQG.quarter = s.quarter
AND s.year = NEW.year AND s.course_number = NEW.course_number AND s.section_id = NEW.section_id AND CPQG.grade = 'A';

ELSIF NEW.grade like 'B%' THEN
Update CPQG
SET grade_count = grade_count + 1 
from section s 
WHERE CPQG.course_number = NEW.course_number AND CPQG.year = NEW.year AND CPQG.quarter = s.quarter
AND s.year = NEW.year AND s.course_number = NEW.course_number AND s.section_id = NEW.section_id AND CPQG.grade = 'B';

ELSIF NEW.grade like 'C%' THEN
Update CPQG
SET grade_count = grade_count + 1 
from section s 
WHERE CPQG.course_number = NEW.course_number AND CPQG.year = NEW.year AND CPQG.quarter = s.quarter
AND s.year = NEW.year AND s.course_number = NEW.course_number AND s.section_id = NEW.section_id AND CPQG.grade = 'C';

ELSIF NEW.grade like 'D%' THEN
Update CPQG
SET grade_count = grade_count + 1 
from section s 
WHERE CPQG.course_number = NEW.course_number AND CPQG.year = NEW.year AND CPQG.quarter = s.quarter
AND s.year = NEW.year AND s.course_number = NEW.course_number AND s.section_id = NEW.section_id AND CPQG.grade = 'D';

ELSE
Update CPQG
SET grade_count = grade_count + 1 
from section s 
WHERE CPQG.course_number = NEW.course_number AND CPQG.year = NEW.year AND CPQG.quarter = s.quarter
AND s.year = NEW.year AND s.course_number = NEW.course_number AND s.section_id = NEW.section_id AND CPQG.grade = 'other';
END IF;
ELSE
insert into CPQG
select s.course_number, s.year, s.quarter, s.professor, 'A' as grade, 
CASE WHEN NEW.grade like 'A%' Then 1
ELSE 0 END
from section s
where NEW.course_number = s.course_number and NEW.section_id = s.section_id 
and NEW.year = s.year;

insert into CPQG
select s.course_number, s.year, s.quarter, s.professor, 'B' as grade, 
CASE WHEN NEW.grade like 'B%' Then 1
ELSE 0 END
from section s
where NEW.course_number = s.course_number and NEW.section_id = s.section_id 
and NEW.year = s.year;

insert into CPQG
select s.course_number, s.year, s.quarter, s.professor, 'C' as grade, 
CASE WHEN NEW.grade like 'C%' Then 1
ELSE 0 END
from section s
where NEW.course_number = s.course_number and NEW.section_id = s.section_id 
and NEW.year = s.year;

insert into CPQG
select s.course_number, s.year, s.quarter, s.professor, 'D' as grade, 
CASE WHEN NEW.grade like 'D%' Then 1
ELSE 0 END
from section s
where NEW.course_number = s.course_number and NEW.section_id = s.section_id 
and NEW.year = s.year;

insert into CPQG
select s.course_number, s.year, s.quarter, s.professor, 'other' as grade, 
CASE WHEN NEW.grade not like 'A%' and grade not like 'B%' and grade not like 'C%' 
and grade not like 'D%' Then 1
ELSE 0 END
from section s
where NEW.course_number = s.course_number and NEW.section_id = s.section_id 
and NEW.year = s.year;
END if;
return NEW;
END;
$$;

DROP TRIGGER IF EXISTS insert_grade_quarter on courses_taken;
CREATE TRIGGER insert_grade_quarter 
AFTER INSERT on courses_taken 
FOR EACH ROW EXECUTE PROCEDURE insert_grade_quarter_trig();



-- delete trigger 
CREATE or replace FUNCTION delete_grade_quarter_trig() RETURNS trigger
LANGUAGE plpgsql AS
$$BEGIN
IF OLD.grade like 'A%' THEN
Update CPQG
SET grade_count = grade_count - 1 
from section s 
WHERE CPQG.course_number = OLD.course_number AND CPQG.year = OLD.year AND CPQG.quarter = s.quarter
AND s.year = OLD.year AND s.course_number = OLD.course_number AND s.section_id = OLD.section_id AND CPQG.grade = 'A';

ELSIF OLD.grade like 'B%' THEN
Update CPQG
SET grade_count = grade_count - 1 
from section s 
WHERE CPQG.course_number = OLD.course_number AND CPQG.year = OLD.year AND CPQG.quarter = s.quarter
AND s.year = OLD.year AND s.course_number = OLD.course_number AND s.section_id = OLD.section_id AND CPQG.grade = 'B';

ELSIF OLD.grade like 'C%' THEN
Update CPQG
SET grade_count = grade_count - 1 
from section s 
WHERE CPQG.course_number = OLD.course_number AND CPQG.year = OLD.year AND CPQG.quarter = s.quarter
AND s.year = OLD.year AND s.course_number = OLD.course_number AND s.section_id = OLD.section_id AND CPQG.grade = 'C';

ELSIF OLD.grade like 'D%' THEN
Update CPQG
SET grade_count = grade_count - 1 
from section s 
WHERE CPQG.course_number = OLD.course_number AND CPQG.year = OLD.year AND CPQG.quarter = s.quarter
AND s.year = OLD.year AND s.course_number = OLD.course_number AND s.section_id = OLD.section_id AND CPQG.grade = 'D';

ELSE
Update CPQG
SET grade_count = grade_count - 1 
from section s 
WHERE CPQG.course_number = OLD.course_number AND CPQG.year = OLD.year AND CPQG.quarter = s.quarter
AND s.year = OLD.year AND s.course_number = OLD.course_number AND s.section_id = OLD.section_id AND CPQG.grade = 'other';
END IF;

return NEW;
END;
$$;

DROP TRIGGER IF EXISTS delete_grade_quarter on courses_taken;
CREATE TRIGGER delete_grade_quarter 
AFTER delete on courses_taken 
FOR EACH ROW EXECUTE PROCEDURE delete_grade_quarter_trig();



-- update trigger
CREATE or replace FUNCTION update_grade_quarter_trig() RETURNS trigger
LANGUAGE plpgsql AS
$$BEGIN
IF NEW.grade like 'A%' THEN
Update CPQG
SET grade_count = grade_count + 1 
from section s 
WHERE CPQG.course_number = NEW.course_number AND CPQG.year = NEW.year AND CPQG.quarter = s.quarter
AND s.year = NEW.year AND s.course_number = NEW.course_number AND s.section_id = NEW.section_id AND CPQG.grade = 'A';

ELSIF NEW.grade like 'B%' THEN
Update CPQG
SET grade_count = grade_count + 1 
from section s 
WHERE CPQG.course_number = NEW.course_number AND CPQG.year = NEW.year AND CPQG.quarter = s.quarter
AND s.year = NEW.year AND s.course_number = NEW.course_number AND s.section_id = NEW.section_id AND CPQG.grade = 'B';

ELSIF NEW.grade like 'C%' THEN
Update CPQG
SET grade_count = grade_count + 1 
from section s 
WHERE CPQG.course_number = NEW.course_number AND CPQG.year = NEW.year AND CPQG.quarter = s.quarter
AND s.year = NEW.year AND s.course_number = NEW.course_number AND s.section_id = NEW.section_id AND CPQG.grade = 'C';

ELSIF NEW.grade like 'D%' THEN
Update CPQG
SET grade_count = grade_count + 1 
from section s 
WHERE CPQG.course_number = NEW.course_number AND CPQG.year = NEW.year AND CPQG.quarter = s.quarter
AND s.year = NEW.year AND s.course_number = NEW.course_number AND s.section_id = NEW.section_id AND CPQG.grade = 'D';

ELSE
Update CPQG
SET grade_count = grade_count + 1 
from section s 
WHERE CPQG.course_number = NEW.course_number AND CPQG.year = NEW.year AND CPQG.quarter = s.quarter
AND s.year = NEW.year AND s.course_number = NEW.course_number AND s.section_id = NEW.section_id AND CPQG.grade = 'other';
END IF;


IF OLD.grade like 'A%' THEN
Update CPQG
SET grade_count = grade_count - 1 
from section s 
WHERE CPQG.course_number = OLD.course_number AND CPQG.year = OLD.year AND CPQG.quarter = s.quarter
AND s.year = OLD.year AND s.course_number = OLD.course_number AND s.section_id = OLD.section_id AND CPQG.grade = 'A';

ELSIF OLD.grade like 'B%' THEN
Update CPQG
SET grade_count = grade_count - 1 
from section s 
WHERE CPQG.course_number = OLD.course_number AND CPQG.year = OLD.year AND CPQG.quarter = s.quarter
AND s.year = OLD.year AND s.course_number = OLD.course_number AND s.section_id = OLD.section_id AND CPQG.grade = 'B';

ELSIF OLD.grade like 'C%' THEN
Update CPQG
SET grade_count = grade_count - 1 
from section s 
WHERE CPQG.course_number = OLD.course_number AND CPQG.year = OLD.year AND CPQG.quarter = s.quarter
AND s.year = OLD.year AND s.course_number = OLD.course_number AND s.section_id = OLD.section_id AND CPQG.grade = 'C';

ELSIF OLD.grade like 'D%' THEN
Update CPQG
SET grade_count = grade_count - 1 
from section s 
WHERE CPQG.course_number = OLD.course_number AND CPQG.year = OLD.year AND CPQG.quarter = s.quarter
AND s.year = OLD.year AND s.course_number = OLD.course_number AND s.section_id = OLD.section_id AND CPQG.grade = 'D';

ELSE
Update CPQG
SET grade_count = grade_count - 1 
from section s 
WHERE CPQG.course_number = OLD.course_number AND CPQG.year = OLD.year AND CPQG.quarter = s.quarter
AND s.year = OLD.year AND s.course_number = OLD.course_number AND s.section_id = OLD.section_id AND CPQG.grade = 'other';
END IF;

return NEW;
END;
$$;

DROP TRIGGER IF EXISTS update_grade_quarter on courses_taken;
CREATE TRIGGER update_grade_quarter 
AFTER UPDATE on courses_taken 
FOR EACH ROW EXECUTE PROCEDURE update_grade_quarter_trig();
