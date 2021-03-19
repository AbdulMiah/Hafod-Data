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
SELECT * FROM AdminCredentials;

DROP TABLE IF EXISTS `CovidCaseFigures`;
CREATE TABLE IF NOT EXISTS `CovidCaseFigures` (
`CasesReportID` 			INTEGER NOT NULL AUTO_INCREMENT,
`Date` 						VARCHAR(10) NOT NULL,
`AreaName` 					VARCHAR(40) NOT NULL,
`AreaType` 					VARCHAR(20) NOT NULL, 
`NewCasesOnGivenDay`  		INTEGER NOT NULL, 
`ReportedDeathsOnGivenDay`	INTEGER,
CONSTRAINT `PK_CasesReportID` PRIMARY KEY (`CasesReportID`)
);

SELECT * FROM CovidCaseFigures;
