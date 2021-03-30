DROP DATABASE IF EXISTS hafod_database;
CREATE DATABASE IF NOT EXISTS hafod_database;
USE hafod_database;		-- or double click the database name in the Navigator on your left

-- Table for tenants
DROP TABLE IF EXISTS `tenants`;
CREATE TABLE IF NOT EXISTS `tenants` (
	`tenancyNo`		INTEGER NOT NULL AUTO_INCREMENT,
    `healthID`			INTEGER,
    `locationID`		INTEGER,
    `firstname`			VARCHAR(45),
    `surname`			VARCHAR(45),
    `dob`				DATE,
    CONSTRAINT `PK_tenants` PRIMARY KEY (`tenancyNo`)
);
-- INSERT data into tenants
INSERT INTO tenants VALUES(NULL, NULL, NULL, 'John', 'Doe', 2000-03-24);
INSERT INTO tenants VALUES(NULL, NULL, NULL, 'Sarah', 'Smith', 1988-03-20);
INSERT INTO tenants VALUES(NULL, NULL, NULL, 'Aria', 'Jones', 1990-06-20);
INSERT INTO tenants VALUES(NULL, NULL, NULL, 'Jo', 'Lee', 1970-05-27);
SELECT * FROM tenants;


-- Table for carers
DROP TABLE IF EXISTS `carers`;
CREATE TABLE IF NOT EXISTS `carers` (
	`staffNo`			INTEGER,
    `healthID`			INTEGER,
    `firstname`			VARCHAR(45),
    `surname`			VARCHAR(45),
    `role`				VARCHAR(45),
    `dob`				DATE,
    `locationID`		INTEGER,
    CONSTRAINT `PK_carer` PRIMARY KEY (`staffNo`)
);
-- INSERT data into carers
INSERT INTO carer VALUES(741, NULL , 'Tom', 'Cooper', 'Support Assistant', 1968-03-20, NULL);
INSERT INTO carer VALUES(8878, NULL , 'Charles', 'Osorio', 'Registered Nurse', 2000-02-05, NULL);
INSERT INTO carer VALUES(740, NULL, 'Ffion', 'Adams', 'Registered Nurse', 1995-08-05, NULL);
INSERT INTO carer VALUES(2345, NULL, 'Karen', 'Jenkins', 'Support Assistant', 1967-09-05, NULL);
SELECT * FROM carer;


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
CONSTRAINT `PK_locationID` PRIMARY KEY (`locationID`)
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
    `positiveCase`				ENUM('yes','no') NOT NULL,
    `status`					VARCHAR(50),
    `resultDatee`				DATE,
    `endOfIsolation`			DATE,
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
    CONSTRAINT `health_linktable` PRIMARY KEY (`healthID`)
);
-- INSERT data into health_linktable
INSERT INTO health_linktable VALUES(NULL, NULL, NULL);
INSERT INTO health_linktable VALUES(NULL, NULL, NULL);
INSERT INTO health_linktable VALUES(NULL, NULL, NULL);
INSERT INTO health_linktable VALUES(NULL, NULL, NULL);
SELECT * FROM health_linktable;

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
select * from AdminCredentials;


-- Table for AdminLog
DROP TABLE IF EXISTS`AdminLog`;
CREATE TABLE IF NOT EXISTS `AdminLog` (
`SessionID`         INTEGER NOT NULL AUTO_INCREMENT,
`AdminID`			INTEGER,
`TimeLoggedOn`      TIMESTAMP NOT NULL, 
`TimeLoggedOff`     TIMESTAMP NOT NULL, 
CONSTRAINT `FK_AdminID` FOREIGN KEY (`AdminID`) REFERENCES admincredentials(AdminID), 
CONSTRAINT `PK_SessionID` PRIMARY KEY (`SessionID`)
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
DROP TABLE `CovidCaseFigures`;
CREATE TABLE IF NOT EXISTS `CovidCaseFigures` (
`CasesReportID` 			INTEGER NOT NULL AUTO_INCREMENT,
`Date` 						VARCHAR(10) NOT NULL,
`AreaName`					VARCHAR(40) NOT NULL,
`AreaType` 					VARCHAR(20) NOT NULL,
`NewCasesOnGivenDay` 		INTEGER,
`ReportedDeathsOnGivenDay`  INTEGER,
CONSTRAINT `PK_CasesReportID` PRIMARY KEY (`CasesReportID`)
);
-- INSERT data into covidcasefigures
INSERT INTO `covidcasefigures` VALUES (null, '2021-04-03', 'Cardiff', 'ltlt', 1, Null);
SELECT * FROM CovidCaseFigures;


-- Table for VaccinationFigures
DROP TABLE `VaccinationFigures`;
CREATE TABLE IF NOT EXISTS `VaccinationFigures` (
`VaccinatedID` 			INTEGER NOT NULL AUTO_INCREMENT,
`Date` 						VARCHAR(10) NOT NULL,
`AreaName`					VARCHAR(40) NOT NULL,
`AreaType` 					VARCHAR(20) NOT NULL,
CONSTRAINT `PK_VaccinatedID` PRIMARY KEY (`VaccinatedID`)
);
-- INSERT data into VaccinationFigures
INSERT INTO `VaccinationFigures` VALUES (null, '2021-23-03', 'Cardiff', 'ltlt');
SELECT * FROM VaccinationFigures;
