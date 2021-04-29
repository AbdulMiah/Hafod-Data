USE hafod_database;

DROP FUNCTION IF EXISTS pfizerVaccine;
DELIMITER //
CREATE FUNCTION pfizerVaccine()
RETURNS VARCHAR(50)
BEGIN
	RETURN (
		SELECT COUNT(*)
		FROM vaccinations
		WHERE vaccinationType = 'Pfizer'
	);
END //
DELIMITER ;

SELECT pfizerVaccine();

DROP FUNCTION IF EXISTS modernaVaccine;
DELIMITER //
CREATE FUNCTION modernaVaccine()
RETURNS VARCHAR(50)
BEGIN
	RETURN (
		SELECT COUNT(*)
		FROM vaccinations
		WHERE vaccinationType = 'Moderna'
	);
END //
DELIMITER ;

SELECT modernaVaccine();