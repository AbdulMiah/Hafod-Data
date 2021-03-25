DROP TABLE IF EXISTS `vaccinations`;

CREATE TABLE IF NOT EXISTS `vaccinations` (
	`vaccinationID`				INTEGER NOT NULL AUTO_INCREMENT,
    `vaccinated`				ENUM('yes','no') NOT NULL,
    `dateVaccinated`			DATE,
    `dataVacEffective`			DATE,
    `vaccinationType`			VARCHAR(25),
	`reasonForNoVaccination`	ENUM('N/A', 'Pregnant', 'Refused', 'Not Effective') NOT NULL,
    CONSTRAINT `PK_vaccinations` PRIMARY KEY (`vaccinationID`)
);

INSERT INTO vaccinations VALUES(NULL, 'yes', '2021-03-24', '2021-04-07', 'Pfizer', 'N/A');
INSERT INTO vaccinations VALUES(NULL, 'yes', '2021-03-1', '2021-04-14', 'Moderna', 'N/A');
INSERT INTO vaccinations VALUES(NULL, 'no', NULL, NULL, NULL, 'Not Effective');
INSERT INTO vaccinations VALUES(NULL, 'no', NULL, NULL, NULL, 'Refused');

SELECT * FROM vaccinations;