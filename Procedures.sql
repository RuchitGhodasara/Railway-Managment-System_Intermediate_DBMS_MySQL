DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `bookTicket`(IN `userID` CHAR(20), IN `train_no` VARCHAR(20), IN `journeyDate` DATE, IN `departureTime` TIME, IN `arrivalTime` TIME)
BEGIN

	DECLARE PNR char(20);
    Set PNR = PNRGenerator();
		INSERT INTO passenger VALUES(
				PNR,
                userID,
                'NO',
                seat_no()
        );
        
        
        
        INSERT INTO ticket VALUES(
            ticketNoGenerator(),
				PNR,
                journeyDate,
                train_no,
                rentCalculator(departureTime, arrivalTime),
                NOW()
        );
END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `cancelTicket`(ticketNo VARCHAR(20), PNR CHAR(20))
BEGIN
        DELETE FROM ticket
        WHERE ticket_no = ticketNo;
        
        DELETE FROM passenger
        WHERE PNR = PNR;
END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `creatingUserProfile`(
		first_name VARCHAR(50),
        last_name VARCHAR(50),
        gender CHAR(1),
        birthdate DATE,
        email VARCHAR(50),
        contactNo CHAR(15),
        password VARCHAR(20)
)
BEGIN
		call validatingContactNo(contactNo);
		
		INSERT INTO user values(
			userIdGenerator(first_name, last_name),
			first_name,
			last_name,
			gender,
			birthdate,
			email,
			contactNo,
			password
		);
        
		
END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `train_enquiry`(
		boarding_station VARCHAR(50),
        destination_station VARCHAR(50),
        journey_date DATE
)
BEGIN
	
SELECT train_no as train_num, (SELECT train_name from train where train_no=train_num) as train, route_no, startStation_1, arriving_time, endStation_2, destination_time, rent, journeyDate from train_timing INNER JOIN

(SELECT train_no, route_no, startStation_1, if(A_time_1<A_time_2,A_time_1,D_time_1) as arriving_time, endStation_2, if(A_time_1>A_time_2,D_time_2, A_time_2) as destination_time, rentCalculator(if(A_time_1>A_time_2,D_time_2, A_time_2), if(A_time_1<A_time_2,A_time_1,D_time_1)) AS 'rent' from train_routes
INNER JOIN
((SELECT route_no, t1.station_name as startStation_1, t1.arrivalTime as A_time_1, t1.departureTime as D_time_1, t2.station_name as endStation_2, t2.arrivalTime as A_time_2, t2.departureTime as D_time_2 from 
	(SELECT route_no, station_name, arrivalTime, departureTime from station where station_name = boarding_station) as t1 		INNER JOIN 
	(SELECT route_no, station_name, arrivalTime, departureTime from station where station_name = destination_station) as t2 
 	using(route_no)) as t3)
  		using (route_no)) as temp_name using(train_no) WHERE journeyDate=journey_date;

END$$
DELIMITER ;

DELIMITER $$
CREATE DEFINER=`root`@`localhost` PROCEDURE `validatingContactNo`(
	contactNo CHAR(15)
)
BEGIN
	IF  length(contactNo) != 10 THEN
		 SIGNAL SQLSTATE '22003'
			SET MESSAGE_TEXT = 'Invalid contact number. Only Enter 10 digit number.';
	 END IF;
END$$
DELIMITER ;
