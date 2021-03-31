DROP DATABASE IF EXISTS hafod_database;
CREATE DATABASE IF NOT EXISTS hafod_database;
USE hafod_database;		-- or double click the database name in the Navigator on your left

-- Table for tenants
DROP TABLE IF EXISTS `tenants`;
CREATE TABLE IF NOT EXISTS `tenants` (
	`tenancyNo`			INTEGER NOT NULL AUTO_INCREMENT,
    `healthID`			INTEGER,
    `locationID`		INTEGER,
    `firstname`			VARCHAR(45) NOT NULL,
    `surname`			VARCHAR(45) NOT NULL,
    `dob`				DATE NOT NULL,
    CONSTRAINT `PK_tenants` PRIMARY KEY (`tenancyNo`)
);
-- INSERT data into tenants
INSERT INTO tenants VALUES(NULL, NULL, NULL, 'John', 'Doe', '2000-03-24');
INSERT INTO tenants VALUES(NULL, NULL, NULL, 'Sarah', 'Smith', '1988-03-20');
INSERT INTO tenants VALUES(NULL, NULL, NULL, 'Aria', 'Jones', '1990-06-20');
INSERT INTO tenants VALUES(NULL, NULL, NULL, 'Jo', 'Lee', '1970-05-27');
SELECT * FROM tenants;


-- Table for carers
DROP TABLE IF EXISTS `carers`;
CREATE TABLE IF NOT EXISTS `carers` (
	`staffNo`			INTEGER NOT NULL,
    `healthID`			INTEGER,
    `locationID`		INTEGER,
    `firstname`			VARCHAR(45) NOT NULL,
    `surname`			VARCHAR(45) NOT NULL,
    `role`				VARCHAR(45) NOT NULL,
    `dob`				DATE NOT NULL,
    CONSTRAINT `PK_carers` PRIMARY KEY (`staffNo`)
);
-- INSERT data into carers
INSERT INTO carers VALUES(741, NULL, NULL, 'Tom', 'Cooper', 'Support Assistant', '1968-03-20');
INSERT INTO carers VALUES(8878, NULL, NULL, 'Charles', 'Osorio', 'Registered Nurse', '2000-02-05');
INSERT INTO carers VALUES(740, NULL, NULL, 'Ffion', 'Adams', 'Registered Nurse', '1995-08-05');
INSERT INTO carers VALUES(2345, NULL, NULL, 'Karen', 'Jenkins', 'Support Assistant', '1967-09-05');
SELECT * FROM carers;


-- Table for locations
DROP TABLE IF EXISTS `locations`;
CREATE TABLE IF NOT EXISTS `locations` (
`locationID`	 INTEGER NOT NULL AUTO_INCREMENT,
`postcode`       VARCHAR(20) NOT NULL, 
`latitude`       DECIMAL(8,6),
`longitude`      DECIMAL(9,6),
`localAuthority` VARCHAR(30) NOT NULL,
`businessArea`   VARCHAR(30) NOT NULL, 
`streetName`     VARCHAR(30),
CONSTRAINT `PK_locations` PRIMARY KEY (`locationID`)
);
-- INSERT data into locations
-- INSERT INTO `locations` VALUES (null, "CF23 9LJ", 228.6, 139.6, "Cardiff", "Housing", "Ael Y Bryn");
-- INSERT INTO `locations` VALUES (null, "CF24 9LJ", 139.6, 119.6, "Cardiff", "Housing", "Ael Y Bryn");
-- INSERT INTO `locations` VALUES (null, "CF24 9LK", 8.6, 9.6, "Cardiff", "Housing", "Ael Y Bryn");
SELECT * FROM locations;


-- Table for vaccinations
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
-- INSERT data into vaccinations
INSERT INTO vaccinations VALUES(NULL, 'yes', '2021-03-24', '2021-04-07', 'Pfizer', 'N/A');
INSERT INTO vaccinations VALUES(NULL, 'yes', '2021-03-1', '2021-04-14', 'Moderna', 'N/A');
INSERT INTO vaccinations VALUES(NULL, 'no', NULL, NULL, NULL, 'Not Effective');
INSERT INTO vaccinations VALUES(NULL, 'no', NULL, NULL, NULL, 'Refused');
SELECT * FROM vaccinations;


-- Table for covidTestResult
DROP TABLE IF EXISTS `covidTestResult`;
CREATE TABLE IF NOT EXISTS `covidTestResult` (
	`testID`				INTEGER NOT NULL AUTO_INCREMENT,
    `positiveCase`			ENUM('yes','no') NOT NULL,
    `status`				VARCHAR(50),
    `resultDate`			DATE,
    `endOfIsolation`		DATE,
    CONSTRAINT `PK_covidTestResult` PRIMARY KEY (`testID`)
);
-- INSERT data into covidTestResult
INSERT INTO covidTestResult VALUES(NULL, 'yes', 'isolation', '2021-04-03', '2021-05-11');
INSERT INTO covidTestResult VALUES(NULL, 'no', 'hospital', '2021-04-06', '2021-05-12');
INSERT INTO covidTestResult VALUES(NULL, 'yes', 'isolation', '2021-04-09', '2021-05-13');
INSERT INTO covidTestResult VALUES(NULL, 'no', 'hospital', '2021-04-12', '2021-05-14');
SELECT * FROM covidTestResult;


-- Table for health_linktable
DROP TABLE IF EXISTS `health_linktable`;
CREATE TABLE IF NOT EXISTS `health_linktable` (
	`healthID`				INTEGER NOT NULL AUTO_INCREMENT,
    `vaccinationID`			INTEGER,
    `testID`				INTEGER,
    CONSTRAINT `PK_health_linktable` PRIMARY KEY (`healthID`)
);
-- INSERT data into health_linktable
INSERT INTO health_linktable VALUES(NULL, NULL, NULL);
INSERT INTO health_linktable VALUES(NULL, NULL, NULL);
INSERT INTO health_linktable VALUES(NULL, NULL, NULL);
INSERT INTO health_linktable VALUES(NULL, NULL, NULL);
SELECT * FROM health_linktable;

-- ADDING FOREIGN KEYS
ALTER TABLE `tenants` ADD CONSTRAINT `FK_tenants_locations`
	FOREIGN KEY (`locationID`) REFERENCES `locations` (`locationID`);
ALTER TABLE `tenants` ADD CONSTRAINT `FK_tenants_health`
	FOREIGN KEY (`healthID`) REFERENCES `health_linktable` (`healthID`);
    
ALTER TABLE `carers` ADD CONSTRAINT `FK_carers_locations`
	FOREIGN KEY (`locationID`) REFERENCES `locations` (`locationID`);
ALTER TABLE `carers` ADD CONSTRAINT `FK_carers_health`
	FOREIGN KEY (`healthID`) REFERENCES `health_linktable` (`healthID`);
    
ALTER TABLE `health_linktable` ADD CONSTRAINT `FK_health_vaccinations`
	FOREIGN KEY (`vaccinationID`) REFERENCES `vaccinations` (`vaccinationID`);
ALTER TABLE `health_linktable` ADD CONSTRAINT `FK_health_covidTestResult`
	FOREIGN KEY (`testID`) REFERENCES `covidTestResult` (`testID`);


------------------------------------------------


-- Table for AdminCredentials
DROP TABLE IF EXISTS `AdminCredentials`;
CREATE TABLE `AdminCredentials` (
	`AdminID`			INTEGER NOT NULL AUTO_INCREMENT,
    `Username`			VARCHAR(25) NOT NULL,
    `Email`				VARCHAR(50) NOT NULL,
    `Password`			VARCHAR(25) NOT NULL,
    CONSTRAINT `PK_AdminCredentials` PRIMARY KEY (`AdminID`)
);
-- INSERT data into AdminCredentials
INSERT INTO `AdminCredentials` VALUES (null, 'admin', 'admin@admin.com', 'adminpass');
INSERT INTO `AdminCredentials` VALUES (null, 'test', 'test@test.com', 'testpass');
INSERT INTO `AdminCredentials` VALUES (null, 'abdulmiah123', 'miaham@cardiff.ac.uk', 'abdulpass12');
SELECT * FROM AdminCredentials;


-- Table for AdminLog
DROP TABLE IF EXISTS`AdminLog`;
CREATE TABLE IF NOT EXISTS `AdminLog` (
`SessionID`         INTEGER NOT NULL AUTO_INCREMENT,
`AdminID`			INTEGER,
`TimeLoggedOn`      TIMESTAMP NOT NULL, 
`TimeLoggedOff`     TIMESTAMP NOT NULL, 
CONSTRAINT `FK_AdminCredentials` FOREIGN KEY (`AdminID`) REFERENCES admincredentials(AdminID), 
CONSTRAINT `PK_AdminLog` PRIMARY KEY (`SessionID`)
);
##Mile Stone 2 turn this into a function where admin ID is a parameter
INSERT INTO `AdminLog` VALUES (null, 1, NOW(), NOW()+1000);
UPDATE `AdminLog`
SET TimeLoggedOff = '2021-03-22 19:26:36'  
WHERE SessionID IN
(SELECT MAX(SessionID)
FROM AdminLog
WHERE AdminID = 1);
SELECT * FROM AdminLog;

-- Table for CovidCaseFigures
DROP TABLE IF EXISTS `CovidCaseFigures`;
CREATE TABLE IF NOT EXISTS `CovidCaseFigures` (
`CasesReportID` 			INTEGER NOT NULL AUTO_INCREMENT,
`Date` 						VARCHAR(10) NOT NULL,
`AreaName`					VARCHAR(40) NOT NULL,
`AreaType` 					VARCHAR(20) NOT NULL,
`NewCasesOnGivenDay` 		INTEGER,
`ReportedDeathsOnGivenDay`  INTEGER,
`latitude`       			DECIMAL(8,6),
`longitude`      			DECIMAL(9,6),
CONSTRAINT `PK_CovidCaseFigures` PRIMARY KEY (`CasesReportID`)
);
-- INSERT data into covidcasefigures
INSERT INTO `CovidCaseFigures` VALUES (null, '2021-04-03', 'Cardiff', 'ltlt', 1, Null);
SELECT * FROM CovidCaseFigures;


-- Table for VaccinationFigures
DROP TABLE IF EXISTS `VaccinationFigures`;
CREATE TABLE IF NOT EXISTS `VaccinationFigures` (
`VaccinatedID` 			INTEGER NOT NULL AUTO_INCREMENT,
`Date` 						VARCHAR(10) NOT NULL,
`AreaName`					VARCHAR(40) NOT NULL,
`AreaType` 					VARCHAR(20) NOT NULL,
CONSTRAINT `PK_VaccinationFigures` PRIMARY KEY (`VaccinatedID`)
);
-- INSERT data into VaccinationFigures
INSERT INTO `VaccinationFigures` VALUES (null, '2021-23-03', 'Cardiff', 'ltlt');
SELECT * FROM VaccinationFigures;