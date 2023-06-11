-- A professor should not have multiple sections at the same time. 
-- For example, a professor that is scheduled to teach classes X and Y should not have conflicting sections, mainly overlapping meetings. 
-- It is enough to check for the regular meetings (e.g., "LE"). Extra credit is given for checking conflicts on the irregular meetings too.

CREATE or replace FUNCTION meeting_schedule_trig() RETURNS trigger
LANGUAGE plpgsql AS
$$
Declare 
conflict_professor    varchar(50);
conflict_type     varchar(50);
conflict_section    varchar(50);
conflict_course    varchar(50);
BEGIN
conflict_professor:=(
With same_professor_meeting AS(
select c1.start_time as start_1, c1.end_time as end_1, c2.start_time as start_2, c2.end_time as end_2, s1.professor 
from section s1, section s2, class_meetings_times c1, class_meetings_times c2
where s1.year= c1.year AND s1.section_id= c1.section_id AND s1.course_number = c1.course_number
AND s2.year= c2.year AND s2.section_id= c2.section_id AND s2.course_number = c2.course_number
AND s1.professor = s2.professor AND s1.quarter = s2.quarter AND c2.course_number = NEW.course_number
AND c1.date = c2.date AND (c1.course_number<>c2.course_number or c1.section_id<>c2.section_id)
)
select professor
from same_professor_meeting
where ((TO_TIMESTAMP(start_1,'HH24:MI')<TO_TIMESTAMP(end_2,'HH24:MI')
and TO_TIMESTAMP(end_1,'HH24:MI')>TO_TIMESTAMP(start_2,'HH24:MI'))
or (TO_TIMESTAMP(start_2,'HH24:MI')<TO_TIMESTAMP(end_1,'HH24:MI')
and TO_TIMESTAMP(end_2,'HH24:MI')>TO_TIMESTAMP(start_1,'HH24:MI')))
LIMIT 1);
conflict_type:=(
With same_professor_meeting AS(
select c1.start_time as start_1, c1.end_time as end_1, c2.start_time as start_2, c2.end_time as end_2, c1.type 
from section s1, section s2, class_meetings_times c1, class_meetings_times c2
where s1.year= c1.year AND s1.section_id= c1.section_id AND s1.course_number = c1.course_number
AND s2.year= c2.year AND s2.section_id= c2.section_id AND s2.course_number = c2.course_number
AND s1.professor = s2.professor AND s1.quarter = s2.quarter AND c2.course_number = NEW.course_number
AND c1.date = c2.date AND (c1.course_number<>c2.course_number or c1.section_id<>c2.section_id)
)
select type
from same_professor_meeting
where ((TO_TIMESTAMP(start_1,'HH24:MI')<TO_TIMESTAMP(end_2,'HH24:MI')
and TO_TIMESTAMP(end_1,'HH24:MI')>TO_TIMESTAMP(start_2,'HH24:MI'))
or (TO_TIMESTAMP(start_2,'HH24:MI')<TO_TIMESTAMP(end_1,'HH24:MI')
and TO_TIMESTAMP(end_2,'HH24:MI')>TO_TIMESTAMP(start_1,'HH24:MI')))
LIMIT 1);

conflict_section:=(
With same_professor_meeting AS(
select c1.start_time as start_1, c1.end_time as end_1, c2.start_time as start_2, c2.end_time as end_2, c1.section_id 
from section s1, section s2, class_meetings_times c1, class_meetings_times c2
where s1.year= c1.year AND s1.section_id= c1.section_id AND s1.course_number = c1.course_number
AND s2.year= c2.year AND s2.section_id= c2.section_id AND s2.course_number = c2.course_number
AND s1.professor = s2.professor AND s1.quarter = s2.quarter AND c2.course_number = NEW.course_number
AND c1.date = c2.date AND (c1.course_number<>c2.course_number or c1.section_id<>c2.section_id)
)
select section_id
from same_professor_meeting
where ((TO_TIMESTAMP(start_1,'HH24:MI')<TO_TIMESTAMP(end_2,'HH24:MI')
and TO_TIMESTAMP(end_1,'HH24:MI')>TO_TIMESTAMP(start_2,'HH24:MI'))
or (TO_TIMESTAMP(start_2,'HH24:MI')<TO_TIMESTAMP(end_1,'HH24:MI')
and TO_TIMESTAMP(end_2,'HH24:MI')>TO_TIMESTAMP(start_1,'HH24:MI')))
LIMIT 1);
conflict_course:=(
With same_professor_meeting AS(
select c1.start_time as start_1, c1.end_time as end_1, c2.start_time as start_2, c2.end_time as end_2, c1.course_number 
from section s1, section s2, class_meetings_times c1, class_meetings_times c2
where s1.year= c1.year AND s1.section_id= c1.section_id AND s1.course_number = c1.course_number
AND s2.year= c2.year AND s2.section_id= c2.section_id AND s2.course_number = c2.course_number
AND s1.professor = s2.professor AND s1.quarter = s2.quarter AND c2.course_number = NEW.course_number
AND c1.date = c2.date AND (c1.course_number<>c2.course_number or c1.section_id<>c2.section_id)
)
select course_number
from same_professor_meeting
where ((TO_TIMESTAMP(start_1,'HH24:MI')<TO_TIMESTAMP(end_2,'HH24:MI')
and TO_TIMESTAMP(end_1,'HH24:MI')>TO_TIMESTAMP(start_2,'HH24:MI'))
or (TO_TIMESTAMP(start_2,'HH24:MI')<TO_TIMESTAMP(end_1,'HH24:MI')
and TO_TIMESTAMP(end_2,'HH24:MI')>TO_TIMESTAMP(start_1,'HH24:MI')))
LIMIT 1);
IF conflict_professor<>''
THEN
RAISE EXCEPTION 'The % of section %, % from % to % overlaps with % of section %, % by professor %', 
NEW.type, NEW.section_id, NEW.course_number,
NEW.start_time, NEW.end_time, conflict_type, conflict_section, conflict_course, conflict_professor;
END IF;

RETURN OLD;
END;$$;

DROP TRIGGER IF EXISTS insert_meeting_schedule_trig on class_meetings_times;
CREATE TRIGGER insert_meeting_schedule_trig AFTER INSERT ON class_meetings_times
FOR EACH ROW EXECUTE PROCEDURE meeting_schedule_trig();

DROP TRIGGER IF EXISTS update_meeting_schedule_trig on class_meetings_times;

CREATE or replace TRIGGER update_meeting_schedule_trig AFTER update ON class_meetings_times
FOR EACH ROW EXECUTE PROCEDURE meeting_schedule_trig();