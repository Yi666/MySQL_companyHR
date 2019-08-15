USE sports_complex_management;
ALTER TABLE bookings
	ADD CONSTRAINT room_booked UNIQUE (room_id, booked_date, booked_time),
	ADD CONSTRAINT fk1 FOREIGN KEY (member_id) REFERENCES members (id) ON DELETE CASCADE ON UPDATE RESTRICT,
    ADD CONSTRAINT fk2 FOREIGN KEY (room_id) REFERENCES rooms (id) ON DELETE CASCADE ON UPDATE RESTRICT;
 
 
# data inserted through Java JDBC


# view of the booking information 
CREATE VIEW member_bookings AS
	SELECT bookings.id AS 'id', rooms.id AS 'room_id', room_type, booked_date, booked_time, member_id, datetime_of_booking, price, payment_status FROM bookings INNER JOIN rooms ON bookings.room_id = rooms.id;

SELECT * FROM member_bookings;


#set the procedures
DELIMITER $$
CREATE PROCEDURE insert_new_member (IN p_id VARCHAR(255), p_password VARCHAR(255), p_email VARCHAR(255))
BEGIN
	INSERT INTO members (id, password, email) VALUES (p_id, p_password, p_email);
END $$

CREATE PROCEDURE delete_member (IN p_id VARCHAR(255))
BEGIN
	DELETE FROM members WHERE id = p_id;
END $$

CREATE PROCEDURE update_member_email (IN p_id VARCHAR(255), p_email VARCHAR(255))
BEGIN
	UPDATE members
		SET email = p_email WHERE id = p_id;
END $$

CREATE PROCEDURE update_member_password (IN p_id VARCHAR(255), p_password VARCHAR(255))
BEGIN
	UPDATE members
		SET password = p_password WHERE id = p_id;
END $$

CREATE PROCEDURE make_booking (IN p_room_id VARCHAR(255), p_booked_date DATE, p_booked_time TIME, p_member_id VARCHAR(255))
BEGIN
	DECLARE v_price DECIMAL(6,2);
    DECLARE v_payment_due DOUBLE(8,2);
    SELECT price INTO v_price FROM rooms WHERE id = p_room_id;
    SELECT payment_due INTO v_payment_due FROM members WHERE id = p_member_id;
    INSERT INTO bookings (room_id, booked_date, booked_time, member_id) VALUES (p_room_id, p_booked_date, p_booked_time, p_member_id);
    
    UPDATE members
		SET payment_due = v_payment_due + v_price WHERE id = p_member_id;
    
END $$

CREATE PROCEDURE update_payment (IN p_id INT)
BEGIN
	DECLARE v_member_id VARCHAR(255);
    DECLARE v_payment_due DOUBLE(8,2);
    DECLARE v_price DECIMAL(6,2);
    UPDATE bookings
		SET payment_status = 'Paid' WHERE id = p_id;
	SELECT member_id, price INTO v_member_id, v_price FROM member_bookings WHERE id = p_id;
    SELECT payment_due INTO v_payment_due FROM members WHERE id = v_member_id;
    UPDATE members
		SET payment_due = v_payment_due - v_price WHERE id = v_member_id;
END $$

CREATE PROCEDURE view_bookings (IN p_id VARCHAR(255))
BEGIN
	SELECT * FROM member_bookings WHERE member_id = p_id;
END $$

CREATE PROCEDURE search_room (IN p_room_type VARCHAR(255), p_booked_date DATE, p_booked_time TIME)
BEGIN
	SELECT * FROM rooms WHERE id NOT IN (SELECT room_id FROM bookings 
		WHERE booked_date = p_booked_date AND booked_time = p_booked_time AND payment_status != 'Cancelled') AND room_type = p_room_type;
END $$

CREATE PROCEDURE cancel_booking (IN p_booking_id INT, OUT p_message VARCHAR(255))
BEGIN
	DECLARE v_cancellation INT;
    DECLARE v_member_id VARCHAR(255);
    DECLARE v_payment_status VARCHAR(255);
    DECLARE v_booked_date DATE;
    DECLARE v_price DECIMAL(6,2);
    DECLARE v_payment_due DOUBLE(8,2);
    SET v_cancellation = 0;
    SELECT member_id, booked_date, price, payment_status INTO v_member_id, v_booked_date, v_price, v_payment_status 
		FROM member_bookings WHERE id = p_booking_id;
    SELECT payment_due INTO v_payment_due FROM members WHERE id = v_member_id;
    
    IF curdate() >= v_booked_date THEN
		SELECT 'Cancellation cannot be done on/after the booked date' INTO p_message;
	ELSEIF v_payment_status = 'Cancelled' OR v_payment_status = 'Paid' THEN
		SELECT 'Booking has already been cancelled or paid' INTO p_message;
	ELSE
		UPDATE bookings SET payment_status = 'Cancelled' WHERE id = p_booking_id;
        SET v_payment_due = v_payment_due - v_price;
        SET v_cancellation = check_cancellation(p_booking_id);
        IF v_cancellation >= 2 THEN SET v_payment_due = v_payment_due + 10;
        END IF;
        UPDATE members SET payment_due = v_payment_due WHERE id + v_member_id;
        SELECT 'Booking Cancelled' INTO p_message;
    END IF;
END $$

# function of check cancellation
CREATE FUNCTION check_cancellation (p_booking_id INT) RETURNS INT DETERMINISTIC
BEGIN
	DECLARE v_done INT;
    DECLARE v_cancellation INT;
    DECLARE v_current_payment_status VARCHAR(255);
    DECLARE cur CURSOR FOR
		SELECT payment_status FROM bookings WHERE member_id = (SELECT member_id FROM bookings WHERE id = p_booking_id) ORDER BY datetime_of_booking DESC;
	DECLARE CONTINUE HANDLER FOR NOT FOUND SET v_done = 1;
    SET v_done = 0;
    SET v_cancellation = 0;
    OPEN cur;
    cancellation_loop: LOOP
		FETCH cur INTO v_current_payment_status;
        IF v_current_payment_status != 'Cancelled' OR v_done = 1 THEN LEAVE cancellation_loop;
        ELSE SET v_cancellation = v_cancellation + 1;
        END IF;
	END LOOP;
    CLOSE cur;
    RETURN v_cancellation;
    
END $$

DELIMITER ;

    


	




