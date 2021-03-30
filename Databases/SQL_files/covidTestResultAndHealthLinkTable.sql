DROP TABLE IF EXISTS `covidTestResult`;

CREATE TABLE IF NOT EXISTS `covidTestResult` (
	`testID`				INTEGER NOT NULL AUTO_INCREMENT,
    `positiveCase`				ENUM('yes','no') NOT NULL,
    `status`					VARCHAR(50),
    `resultDatee`				DATE,
    `endOfIsolation`			DATE,
    CONSTRAINT `PK_covidTestResult` PRIMARY KEY (`testID`)
);

INSERT INTO covidTestResult VALUES(NULL, 'yes', 'isolation', '2021-04-03', '2021-05-11');
INSERT INTO covidTestResult VALUES(NULL, 'no', 'hospital', '2021-04-06', '2021-05-12');
INSERT INTO covidTestResult VALUES(NULL, 'yes', 'isolation', '2021-04-09', '2021-05-13');
INSERT INTO covidTestResult VALUES(NULL, 'no', 'hospital', '2021-04-12', '2021-05-14');

SELECT * FROM covidTestResult;

DROP TABLE IF EXISTS `health_linktable`;

CREATE TABLE IF NOT EXISTS `health_linktable` (
	`healthID`				INTEGER NOT NULL AUTO_INCREMENT,
    `vaccinationID`			INTEGER,
    `testID`				INTEGER,
    CONSTRAINT `health_linktable` PRIMARY KEY (`healthID`)
);

INSERT INTO health_linktable VALUES(NULL, NULL, NULL);
INSERT INTO health_linktable VALUES(NULL, NULL, NULL);
INSERT INTO health_linktable VALUES(NULL, NULL, NULL);
INSERT INTO health_linktable VALUES(NULL, NULL, NULL);

SELECT * FROM health_linktable;