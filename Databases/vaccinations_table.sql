DROP TABLE IF EXISTS `vaccinations`;

CREATE TABLE IF NOT EXISTS `vaccinations` (
	`vaccinationID`				INTEGER NOT NULL AUTO_INCREMENT,
    `vaccinated`				ENUM('yes','no'),
    `dateVaccinated`			DATE NOT NULL,
    `dataVacEffective`			DATE NOT NULL,
    `vaccinationType`			VARCHAR(25) NOT NULL,
	`reasonForNoVaccination`	ENUM('N/A', 'Pregnant', 'Refused'),
    CONSTRAINT `PK_vaccinations` PRIMARY KEY (`vaccinationID`)
);

SELECT * FROM vaccinations;