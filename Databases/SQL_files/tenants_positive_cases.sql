USE hafod_database;

-- DROP VIEW tenantsCases;
CREATE VIEW tenantsCases AS
SELECT t.firstname, t.surname, t.dob, ctr.positiveCase
FROM tenants t
JOIN health_linktable h ON t.healthID = h.healthID
JOIN covidTestResult ctr ON h.testID = ctr.testID;
SELECT * FROM tenantsCases;

DELIMITER //
CREATE FUNCTION COVIDPositiveCases()
RETURNS VARCHAR(50)
BEGIN
	RETURN (
		SELECT COUNT(*)
		FROM tenantsCases
		WHERE positiveCase = 'yes'
	);
END //
DELIMITER ;

DELIMITER //
CREATE FUNCTION COVIDNegativeCases()
RETURNS VARCHAR(50)
BEGIN
	RETURN (
		SELECT COUNT(*)
		FROM tenantsCases
		WHERE positiveCase = 'no'
	);
END //
DELIMITER ;

SELECT COVIDPositiveCases();
SELECT COVIDNegativeCases();