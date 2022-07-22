DELIMITER $$
CREATE DEFINER=`root`@`localhost` FUNCTION `PNRGenerator`() RETURNS char(20) CHARSET utf8
    READS SQL DATA
BEGIN   
	DECLARE counter INT DEFAULT 0;
    DECLARE PNR CHAR(20);
    SET counter = (SELECT COUNT(*) FROM passenger) + 1;
    SET PNR = CONCAT('PNR00000', CONVERT(counter, CHAR) ); 
	RETURN PNR;
END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` FUNCTION `ageCalculator`(birthdate DATE) RETURNS int(11)
    READS SQL DATA
BEGIN   
	DECLARE age INT DEFAULT 0;
    SET age = ROUND((DATEDIFF(CURDATE(), birthdate) / 365), 0); 
	RETURN age;
END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` FUNCTION `rentCalculator`(`departureTime` TIME, `arrivalTime` TIME) RETURNS int(11)
    READS SQL DATA
BEGIN   
	DECLARE rent INT DEFAULT 0;
    DECLARE timeInMinutes INT;
    
    SET timeInMinutes = TIMESTAMPDIFF(minute, arrivalTime,  departureTime) ; 
    SET rent  = timeInMinutes * 2;
	RETURN ABS(rent);
END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` FUNCTION `seat_no`(trainNo CHAR(10),
        journey_Date Date
) RETURNS int(11)
    READS SQL DATA
BEGIN   
	DECLARE seat_no INT DEFAULT 0;
    SET seat_no = (SELECT seat_availibility FROM train_status as ts WHERE ts.train_no = trainNo  and ts.journeyDate = journey_Date); 
	RETURN seat_no;
END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` FUNCTION `ticketNoGenerator`() RETURNS varchar(20) CHARSET utf8
    READS SQL DATA
BEGIN   
	DECLARE counter INT DEFAULT 00000000;
    DECLARE ticket_no VARCHAR(20);
    SET ticket_no = CONCAT('T0000',CONVERT(counter, CHAR) ); 
    SET counter = (SELECT COUNT(*) FROM ticket) + 1;
	RETURN ticket_no;
END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` FUNCTION `userIdGenerator`(first_name VARCHAR(50),
        last_name VARCHAR(50)
) RETURNS char(20) CHARSET utf8
    READS SQL DATA
BEGIN   
	DECLARE counter INT DEFAULT 0;
    DECLARE userID CHAR(20);
    SET counter = (SELECT COUNT(*) FROM user) + 1;
    SET userID = CONCAT('UID',TRIM(LEFT(first_name,1)),TRIM(LEFT(last_name,1)),CONVERT(counter, CHAR) ); 
	RETURN userID;
END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` FUNCTION `validatingUser`(`user_id` VARCHAR(20), `y_password` VARCHAR(20)) RETURNS tinyint(1)
BEGIN
	IF (y_password = (SELECT password from user where userID=user_id) ) then
		RETURN 1;
	else 
		RETURN 0;
	end if;
END$$
DELIMITER ;
