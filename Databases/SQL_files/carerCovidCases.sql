USE hafod_database;

CREATE VIEW carersCases AS 
SELECT c.firstname, c.surname, c.dob, ctr.positiveCase
FROM carers c
JOIN health_linktable h ON c.healthID = h.healthID
JOIN covidTestResult ctr ON h.testID = ctr.testID;

SELECT *  
FROM carersCases;

DELIMITER ££ 
CREATE PROCEDURE carerPositiveCases()
BEGIN 
	SELECT COUNT(*)
    FROM carersCases
    WHERE positiveCase = "yes";
END ££
DELIMITER ;
CALL carerPositiveCases();

DELIMITER ££ 
CREATE PROCEDURE carerNegativeCases()
BEGIN 
	SELECT COUNT(*)
    FROM carersCases
    WHERE positiveCase = "no";
END ££
DELIMITER ;
CALL carerNegativeCases();