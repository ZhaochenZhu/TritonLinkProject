-- If the enrollment limit of a section has been reached then additional
-- enrollments should be rejected. It is not required to update the waitlist .

CREATE or replace FUNCTION maximum_seats_trig() RETURNS trigger
   LANGUAGE plpgsql AS
$$
DECLARE
    enrollment          numeric(10, 0);
    available          numeric(10, 0);
BEGIN	
    enrollment :=(
            SELECT COUNT(student_id)
            FROM enrollment_list_of_class
            WHERE year = NEW.year AND section_id = NEW.section_id AND course_number = NEW.course_number 
        );  
    available :=(
        WITH enrollment_amount AS(
            SELECT COUNT(student_id) AS enrollment_amount
            FROM enrollment_list_of_class
            WHERE year = NEW.year AND section_id = NEW.section_id AND course_number = NEW.course_number 
        )
        SELECT NEW.maximum_seats -  e.enrollment_amount
        FROM section s, enrollment_amount e 
        WHERE s.year = NEW.year AND s.section_id = NEW.section_id AND s.course_number = NEW.course_number 
    );
    IF NEW.maximum_seats < 0 THEN 
        RAISE EXCEPTION 'Negative maximum_seats';
    END IF;
    IF NEW.maximum_seats <> OLD.maximum_seats THEN
        IF available < 0 THEN
            RAISE EXCEPTION 'Current enrolmment number of course %, %, % is %. New maximum_seats, %, is too small.', 
            NEW.course_number, NEW.year, NEW.section_id, enrollment, NEW.maximum_seats;
        ELSEIF NEW.maximum_seats < 0 THEN
            RAISE EXCEPTION 'Negative maximum_seats';
        ELSE
            UPDATE section SET available_seats = available
            WHERE year = NEW.year AND section_id = NEW.section_id AND course_number = NEW.course_number;
        END IF;
    END IF;
    RETURN NEW;
END;$$;

DROP TRIGGER IF EXISTS insert_maximum_seat_trig on section ;
CREATE TRIGGER insert_maximum_seat_trig 
    AFTER INSERT ON section 
    FOR EACH ROW EXECUTE PROCEDURE  maximum_seats_trig();

DROP TRIGGER IF EXISTS update_maximum_seat_trig on section ;
CREATE TRIGGER update_maximum_seat_trig 
    AFTER UPDATE ON section 
    FOR EACH ROW EXECUTE PROCEDURE  maximum_seats_trig();



CREATE or replace FUNCTION enrollment_limit_trig() RETURNS trigger
   LANGUAGE plpgsql AS
$$
DECLARE
    enrollment          numeric(10, 0);
    available          numeric(10, 0);
BEGIN	
    enrollment :=(
            SELECT COUNT(student_id)
            FROM enrollment_list_of_class
            WHERE year = NEW.year AND section_id = NEW.section_id AND course_number = NEW.course_number 
        );  
    available :=(
        WITH enrollment_amount AS(
            SELECT COUNT(student_id) AS enrollment_amount
            FROM enrollment_list_of_class
            WHERE year = NEW.year AND section_id = NEW.section_id AND course_number = NEW.course_number 
        )
        SELECT s.maximum_seats -  e.enrollment_amount
        FROM section s, enrollment_amount e 
        WHERE s.year = NEW.year AND s.section_id = NEW.section_id AND s.course_number = NEW.course_number 
    );
    
    IF available < 0 THEN
        RAISE EXCEPTION 'Current enrolmment number of course %, %, % is %. And available seats is %. No more available seats', 
        NEW.course_number, NEW.year, NEW.section_id, enrollment - 1, available + 1;
    ELSE
        UPDATE section SET available_seats = available
        WHERE year = NEW.year AND section_id = NEW.section_id AND course_number = NEW.course_number;
    END IF;
   

    RETURN NEW;
END;$$;

DROP TRIGGER IF EXISTS insert_enrollment_limit_trig on enrollment_list_of_class ;
CREATE TRIGGER insert_enrollment_limit_trig 
    AFTER INSERT ON enrollment_list_of_class 
    FOR EACH ROW EXECUTE PROCEDURE enrollment_limit_trig();



CREATE or replace FUNCTION drop_enrollment_trig() RETURNS trigger
   LANGUAGE plpgsql AS
$$
DECLARE
    enrollment          numeric(10, 0);
    available          numeric(10, 0);
BEGIN	
    UPDATE section SET available_seats = available_seats + 1
    WHERE year = OLD.year AND section_id = OLD.section_id AND course_number = OLD.course_number;
   

    RETURN OLD;
END;$$;

DROP TRIGGER IF EXISTS delete_enrollment_trig on enrollment_list_of_class ;
CREATE TRIGGER delete_enrollment_trig
    AFTER DELETE ON enrollment_list_of_class 
    FOR EACH ROW EXECUTE PROCEDURE drop_enrollment_trig();

