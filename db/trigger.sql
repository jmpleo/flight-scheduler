BEGIN;

-- init status
CREATE OR REPLACE FUNCTION init_flight_status()
RETURNS TRIGGER AS $$
BEGIN
  INSERT INTO status (id) VALUES (NEW.id);
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- trigger init status after planning flight
CREATE TRIGGER init_status_after_flight_planning
AFTER INSERT ON schedule FOR EACH ROW EXECUTE FUNCTION init_flight_status();


-- delete scheduled flight
CREATE OR REPLACE FUNCTION delete_scheduled_flight()
RETURNS TRIGGER AS $$
BEGIN
  PERFORM * FROM schedule WHERE id = OLD.id FOR UPDATE;
  DELETE FROM schedule WHERE id = OLD.id;
  RETURN OLD;
END;
$$ LANGUAGE plpgsql;

--trigger delete after delete status
CREATE TRIGGER delete_scheduled_flight_after_delete_status
AFTER DELETE ON status FOR EACH ROW EXECUTE FUNCTION delete_scheduled_flight();


CREATE OR REPLACE FUNCTION delete_status()
RETURNS TRIGGER AS $$
BEGIN
  PERFORM * FROM status WHERE id = OLD.id FOR UPDATE;
  DELETE FROM status WHERE id = OLD.id;
  RETURN OLD;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER delete_status_after_delete_scheduled_flight
AFTER DELETE ON schedule FOR EACH ROW EXECUTE FUNCTION delete_status();

END;
