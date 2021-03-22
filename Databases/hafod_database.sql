DROP DATABASE IF EXISTS hafod_database;

CREATE DATABASE IF NOT EXISTS hafod_database;

USE hafod_database;		-- or double click the database name in the Navigator on your left

DROP TABLE IF EXISTS `AdminCredentials`;
CREATE TABLE `AdminCredentials` (
	`AdminID`			INTEGER NOT NULL AUTO_INCREMENT,
    `Username`			VARCHAR(25) NOT NULL,
    `Email`				VARCHAR(50) NOT NULL,
    `Password`			VARCHAR(25) NOT NULL,
    CONSTRAINT `PK_AdminCredentials` PRIMARY KEY (`AdminID`)
);

INSERT INTO `AdminCredentials` VALUES (null, 'admin', 'admin@admin.com', 'adminpass');
INSERT INTO `AdminCredentials` VALUES (null, 'test', 'test@test.com', 'testpass');
INSERT INTO `AdminCredentials` VALUES (null, 'abdulmiah123', 'miaham@cardiff.ac.uk', 'abdulpass12');
select * from AdminCredentials;

DROP TABLE `AdminLog`;

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
WHERE SessionID > ANY 
(SELECT SessionID 
FROM AdminLog
WHERE AdminID = 1);

SELECT * FROM AdminLog;


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

INSERT INTO `covidcasefigures` VALUES (null, '2021-04-03', 'Cardiff', 'ltlt', 1, Null);
SELECT * FROM CovidCaseFigures;

