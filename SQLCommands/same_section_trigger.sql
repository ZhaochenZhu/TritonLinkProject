-- A professor should not have multiple sections at the same time. 
-- For example, a professor that is scheduled to teach classes X and Y should not have conflicting sections, mainly overlapping meetings. 
-- It is enough to check for the regular meetings (e.g., "LE"). Extra credit is given for checking conflicts on the irregular meetings too.

CREATE or replace FUNCTION same_section_trig() RETURNS trigger
LANGUAGE plpgsql AS
$$
DECLARE
conflict_start          varchar(50);
conflict_end          varchar(50);
conflict_type       		varchar(50);
BEGIN
conflict_start :=( 
With same_section_meeting AS(
select c1.start_time as start_1, c1.end_time as end_1, c2.start_time as start_2, c2.end_time as end_2
from class_meetings_times c1, class_meetings_times c2
where c1.year = c2.year AND c1.section_id = c2.section_id AND c1.course_number = c2.course_number
AND c1.date = c2.date AND c1.type<>c2.type AND c1.type<>'review_session' AND c2.type<>'review_session' AND c2.type = NEW.type 
)
select same_section_meeting.start_1 
from same_section_meeting
where ((TO_TIMESTAMP(start_1,'HH24:MI')<TO_TIMESTAMP(end_2,'HH24:MI')
and TO_TIMESTAMP(end_1,'HH24:MI')>TO_TIMESTAMP(start_2,'HH24:MI'))
or (TO_TIMESTAMP(start_2,'HH24:MI')<TO_TIMESTAMP(end_1,'HH24:MI')
and TO_TIMESTAMP(end_2,'HH24:MI')>TO_TIMESTAMP(start_1,'HH24:MI'))));

conflict_end :=( 
With same_section_meeting AS(
select c1.start_time as start_1, c1.end_time as end_1, c2.start_time as start_2, c2.end_time as end_2
from class_meetings_times c1, class_meetings_times c2
where c1.year = c2.year AND c1.section_id = c2.section_id AND c1.course_number = c2.course_number
AND c1.date = c2.date AND c1.type<>c2.type AND c1.type<>'review_session' AND c2.type<>'review_session' AND c2.type = NEW.type 
)
select same_section_meeting.end_1
from same_section_meeting
where ((TO_TIMESTAMP(start_1,'HH24:MI')<TO_TIMESTAMP(end_2,'HH24:MI')
and TO_TIMESTAMP(end_1,'HH24:MI')>TO_TIMESTAMP(start_2,'HH24:MI'))
or (TO_TIMESTAMP(start_2,'HH24:MI')<TO_TIMESTAMP(end_1,'HH24:MI')
and TO_TIMESTAMP(end_2,'HH24:MI')>TO_TIMESTAMP(start_1,'HH24:MI'))));

conflict_type :=( 
With same_section_meeting AS(
select c1.start_time as start_1, c1.end_time as end_1, c2.start_time as start_2, c2.end_time as end_2, c1.type
from class_meetings_times c1, class_meetings_times c2
where c1.year = c2.year AND c1.section_id = c2.section_id AND c1.course_number = c2.course_number
AND c1.date = c2.date AND c1.type<>c2.type AND c1.type<>'review_session' AND c2.type<>'review_session' AND c2.type = NEW.type 
)
select same_section_meeting.type
from same_section_meeting
where ((TO_TIMESTAMP(start_1,'HH24:MI')<TO_TIMESTAMP(end_2,'HH24:MI')
and TO_TIMESTAMP(end_1,'HH24:MI')>TO_TIMESTAMP(start_2,'HH24:MI'))
or (TO_TIMESTAMP(start_2,'HH24:MI')<TO_TIMESTAMP(end_1,'HH24:MI')
and TO_TIMESTAMP(end_2,'HH24:MI')>TO_TIMESTAMP(start_1,'HH24:MI'))));
IF conflict_start <> ''
THEN
RAISE EXCEPTION 'The % from % to % overlaps with the % from % to % of the same section ',NEW.type, 
NEW.start_time, NEW.end_time, conflict_type, conflict_start, conflict_end;
END IF;

RETURN OLD;
END;$$;

DROP TRIGGER IF EXISTS insert_same_section_trig on class_meetings_times;
CREATE TRIGGER insert_same_section_trig AFTER INSERT ON class_meetings_times
FOR EACH ROW EXECUTE PROCEDURE same_section_trig();

DROP TRIGGER IF EXISTS update_same_section_trig on class_meetings_times;
CREATE or replace TRIGGER update_same_section_trig AFTER update ON class_meetings_times
FOR EACH ROW EXECUTE PROCEDURE same_section_trig();










