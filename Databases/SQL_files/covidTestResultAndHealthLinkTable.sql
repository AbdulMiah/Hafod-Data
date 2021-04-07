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
INSERT INTO covidTestResult VALUES(NULL, 'yes', 'isolation', '2020-05-12', '2021-05-24');
INSERT INTO covidTestResult VALUES(NULL, 'yes', 'isolation', '2020-06-13', '2021-07-10');
INSERT INTO covidTestResult VALUES(NULL, 'yes', 'isolation', '2020-07-15', '2021-08-13');
INSERT INTO covidTestResult VALUES(NULL, 'yes', 'hospital', '2020-08-25', '2021-09-7');
INSERT INTO covidTestResult VALUES(NULL, 'yes', 'hospital', '2020-07-21', '2020-12-24');
INSERT INTO covidTestResult VALUES(NULL, 'yes', 'hospital', '2020-07-22', '2020-12-10');
INSERT INTO covidTestResult VALUES(NULL, 'yes', 'hospital', '2020-07-23', '2020-12-13');
INSERT INTO covidTestResult VALUES(NULL, 'yes', 'hospital', '2020-07-24', '2020-12-7');
INSERT INTO covidTestResult VALUES(NULL, 'no', 'isolation', '2021-04-13', '2021-04-27');
INSERT INTO covidTestResult VALUES(NULL, 'no', 'isolation', '2021-04-14', '2021-04-28');
INSERT INTO covidTestResult VALUES(NULL, 'no', 'isolation', '2021-04-15', '2021-04-29');
INSERT INTO covidTestResult VALUES(NULL, 'no', 'isolation', '2021-04-16', '2021-04-30');
INSERT INTO covidTestResult VALUES(NULL, 'yes', 'hospital', '2021-01-01', '2021-01-26');
INSERT INTO covidTestResult VALUES(NULL, 'no', 'isolation', '2021-01-02', '2021-01-15');
INSERT INTO covidTestResult VALUES(NULL, 'yes', 'hospital', '2021-01-03', '2021-01-25');
INSERT INTO covidTestResult VALUES(NULL, 'no', 'isolation', '2021-01-04', '2021-01-20');
INSERT INTO covidTestResult VALUES(NULL, 'no', 'hospital', '2021-02-05', '2021-02-28');
INSERT INTO covidTestResult VALUES(NULL, 'no', 'isolation', '2021-02-06', '2021-02-21');
INSERT INTO covidTestResult VALUES(NULL, 'yes', 'hospital', '2021-02-07', '2021-03-05');
INSERT INTO covidTestResult VALUES(NULL, 'yes', 'isolation', '2021-02-08', '2021-02-20');
INSERT INTO covidTestResult VALUES(NULL, 'yes', 'hospital', '2021-03-09', '2021-04-05');
INSERT INTO covidTestResult VALUES(NULL, 'no', 'isolation', '2021-03-09', '2021-03-20');
INSERT INTO covidTestResult VALUES(NULL, 'no', 'hospital', '2021-03-10', '2021-04-06');
INSERT INTO covidTestResult VALUES(NULL, 'no', 'isolation', '2021-03-10', '2021-03-24');
INSERT INTO covidTestResult VALUES(NULL, 'yes', 'hospital', '2021-03-11', '2021-04-05');
INSERT INTO covidTestResult VALUES(NULL, 'yes', 'isolation', '2021-03-11', '2021-03-20');

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