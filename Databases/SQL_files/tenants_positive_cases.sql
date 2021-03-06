USE hafod_database;

-- DROP VIEW tenantsCases;
CREATE VIEW tenantsCases AS
SELECT t.firstname, t.surname, t.dob, ctr.positiveCase
FROM tenants t
JOIN health_linktable h ON t.healthID = h.healthID
JOIN covidTestResult ctr ON h.testID = ctr.testID;
SELECT * FROM tenantsCases;

DELIMITER //
CREATE PROCEDURE tenantsPositiveCases()
BEGIN
	SELECT COUNT(*)
	FROM tenantsCases
	WHERE positiveCase = 'yes';
END //
DELIMITER ;

DELIMITER //
CREATE PROCEDURE tenantsNegativeCases()
BEGIN
	SELECT COUNT(*)
	FROM tenantsCases
	WHERE positiveCase = 'no';
END //
DELIMITER ;

CALL tenantsPositiveCases();
CALL tenantsNegativeCases();


-------- [ FUNCTIONS ] --------------------------------------------------------------------
DELIMITER //
CREATE FUNCTION tenantsPositiveCases()
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
CREATE FUNCTION tenantsNegativeCases()
RETURNS VARCHAR(50)
BEGIN
	RETURN (
		SELECT COUNT(*)
		FROM tenantsCases
		WHERE positiveCase = 'no'
	);
END //
DELIMITER ;

SELECT tenantsPositiveCases();
SELECT tenantsNegativeCases();
