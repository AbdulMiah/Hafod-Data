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
INSERT INTO tenants VALUES(NULL, 1, 1, 'John', 'Doe', '2000-03-24');
INSERT INTO tenants VALUES(NULL, 2, 2, 'Sarah', 'Smith', '1988-03-20');
INSERT INTO tenants VALUES(NULL, 3, 3, 'Aria', 'Jones', '1990-06-20');
INSERT INTO tenants VALUES(NULL, 4, 4, 'Madog', 'Pitter', '1970-05-27');
INSERT INTO tenants VALUES(NULL, 5, 5, 'Jo', 'Lee', '1970-12-04');
INSERT INTO tenants VALUES(NULL, 6, 6, 'Hollis', 'Jurica', '1961-09-28');
INSERT INTO tenants VALUES(NULL, 7, 7, 'Axel', 'Anselm', '1972-11-05');
INSERT INTO tenants VALUES(NULL, 8, 8, 'Tena', 'Léane', '1979-12-29');
INSERT INTO tenants VALUES(NULL, 9, 9, 'Rahim', 'Soraya', '1966-05-13');
INSERT INTO tenants VALUES(NULL, 10, 10, 'Thando', 'Platon', '1989-11-14');
INSERT INTO tenants VALUES(NULL, 11, 11, 'Galen', 'Benjamín', '1965-10-19');
INSERT INTO tenants VALUES(NULL, 12, 12, 'Lennard', 'Emilia', '1950-03-14');
INSERT INTO tenants VALUES(NULL, 13, 13, 'Lizzie', 'Gilmore', '1988-04-26');
INSERT INTO tenants VALUES(NULL, 14, 14, 'Zachary', 'Duran', '1987-01-13');
INSERT INTO tenants VALUES(NULL, 15, 15, 'David', 'Mcknight', '1971-01-17');
INSERT INTO tenants VALUES(NULL, 16, 16, 'Merlin', 'Gibbons', '1994-06-23');
INSERT INTO tenants VALUES(NULL, 17, 17, 'Becky', 'Frazier', '1992-01-12');
INSERT INTO tenants VALUES(NULL, 18, 18, 'Mazie', 'Beil', '1999-12-12');
INSERT INTO tenants VALUES(NULL, 19, 19, 'Jimmy', 'Doherty', '1988-04-30');
INSERT INTO tenants VALUES(NULL, 20, 20, 'Aayan', 'Kent', '1995-09-16');
INSERT INTO tenants VALUES(NULL, 21, 21, 'Thea', 'Mack', '1985-06-14');
INSERT INTO tenants VALUES(NULL, 22, 22, 'Trent', 'Rush', '1990-12-07');
INSERT INTO tenants VALUES(NULL, 23, 23, 'Ashlyn', 'Weiss', '1987-04-23');
INSERT INTO tenants VALUES(NULL, 24, 24, 'Haidar', 'Perez', '1997-06-13');
INSERT INTO tenants VALUES(NULL, 25, 25, 'Tahmid', 'Rennie', '2000-06-23');
INSERT INTO tenants VALUES(NULL, 26, 26, 'Preston', 'Paine', '1989-04-16');
INSERT INTO tenants VALUES(NULL, 27, 27, 'Judah', 'Brook', '1981-11-26');
INSERT INTO tenants VALUES(NULL, 28, 28, 'Cristian', 'Amin', '1979-08-12');
INSERT INTO tenants VALUES(NULL, 29, 29, 'Solomon', 'Ventura', '1995-04-08');
INSERT INTO tenants VALUES(NULL, 30, 30, 'Caitlin', 'Jenna', '1987-11-15');
-- SELECT * FROM tenants;

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
INSERT INTO carers VALUES(741, 31, 564, 'Tom', 'Cooper', 'Support Assistant', '1968-03-20');
INSERT INTO carers VALUES(8878, 32, 812, 'Charles', 'Osorio', 'Registered Nurse', '2000-02-05');
INSERT INTO carers VALUES(740, 33, 200, 'Ffion', 'Adams', 'Registered Nurse', '1995-08-05');
INSERT INTO carers VALUES(2345, 34, 100, 'Karen', 'Jenkins', 'Support Assistant', '1967-09-05');
INSERT INTO carers VALUES(12, 35, 97, 'John', 'Fallen', 'Registered Nurse', '1980-04-06');
INSERT INTO carers VALUES(32, 36, 35, 'Steve', 'Rogers', 'Support Assistant', '2001-09-04');
INSERT INTO carers VALUES(123, 37, 51, 'Cameron', 'Diaz', 'Registered Nurse', '1990-03-15');
INSERT INTO carers VALUES(111, 38, 65, 'Peter', 'Davids', 'Support Assistant', '1987-09-25');
INSERT INTO carers VALUES(222, 39, 78, 'Clair', 'Davies', 'Support Assistant', '1999-05-27');
INSERT INTO carers VALUES(333, 40, 42, 'Martin', 'Clunes', 'Support Assistant', '1994-03-07');
INSERT INTO carers VALUES(444, 41, 84, 'John', 'Wick', 'Registered Nurse', '2000-01-01');
INSERT INTO carers VALUES(888, 42, 31, 'Dwayne', 'Johnson', 'Support Assistant', '1989-07-24');
INSERT INTO carers VALUES(543, 43, 45, 'Henry', 'Cavil', 'Support Assistant', '1986-09-25');
INSERT INTO carers VALUES(985, 44, 73, 'Jordan', 'Peterson', 'Registered Nurse', '1985-04-03');
INSERT INTO carers VALUES(1231, 45, 95, 'John', 'Shoe', 'Registered Nurse', '1994-06-19');
INSERT INTO carers VALUES(4547, 46, 92, 'Mark', 'Henry', 'Registered Nurse', '2001-10-04');
INSERT INTO carers VALUES(975, 47, 115, 'Ed', 'Sheeran', 'Support Assistant', '2002-01-07');
INSERT INTO carers VALUES(159, 48, 150, 'Pippa', 'Poppa', 'Registered Nurse', '1963-12-25');
INSERT INTO carers VALUES(951, 49, 183, 'Winnie', 'Pooh', 'Support Assistant', '1995-02-02');
INSERT INTO carers VALUES(357, 50, 75, 'Shawn', 'Paul', 'Registered Nurse', '2003-03-18');
INSERT INTO carers VALUES(753, 51, 94, 'Luke', 'Luwelan', 'Support Assistant', '1969-06-09');
INSERT INTO carers VALUES(468, 52, 123, 'David', 'Tenent', 'Support Assistant', '1997-07-11');
INSERT INTO carers VALUES(852, 53, 235, 'Sheila', 'Ronda', 'Support Assistant', '1988-04-14');
INSERT INTO carers VALUES(1201, 54, 349, 'Kevin', 'Lightning', 'Registered Nurse', '1972-03-22');
INSERT INTO carers VALUES(350, 55, 433, 'Theo', 'Owens', 'Registered Nurse', '1984-12-10');
INSERT INTO carers VALUES(7890, 56, 322, 'Riley', 'Ohmad', 'Registered Nurse', '1966-04-20');
INSERT INTO carers VALUES(567, 57, 111, 'Isobel', 'Robbins', 'Registered Nurse', '2002-09-03');
INSERT INTO carers VALUES(751, 58, 44, 'Laura', 'Baitman', 'Registered Nurse', '2000-01-05');
INSERT INTO carers VALUES(100, 59, 86, 'Maddie', 'Clark', 'Registered Nurse', '1990-07-28');
INSERT INTO carers VALUES(101, 60, 118, 'Samuel', 'Mossaheb', 'Registered Nurse', '1991-02-23');
-- SELECT * FROM carers;


-- Table for locations
-- DROP TABLE IF EXISTS `locations`;
CREATE TABLE IF NOT EXISTS `locations` (
`locationID`	 INTEGER NOT NULL AUTO_INCREMENT,
`postcode`       VARCHAR(20) NOT NULL, 
`latitude`       DECIMAL(8,6),
`longitude`      DECIMAL(9,6),
`localAuthority` VARCHAR(30) NOT NULL,
`businessArea`   VARCHAR(30) NOT NULL, 
CONSTRAINT `PK_locations` PRIMARY KEY (`locationID`)
);
-- INSERT data into locations
-- INSERT INTO `locations` VALUES (null, "CF23 9LJ", 58.6, -2.6, "Cardiff", "Housing", "Ael Y Bryn");
-- SELECT * FROM locations;


-- Table for vaccinations
DROP TABLE IF EXISTS `vaccinations`;
CREATE TABLE IF NOT EXISTS `vaccinations` (
	`vaccinationID`				INTEGER NOT NULL AUTO_INCREMENT,
    `vaccinated`				ENUM('yes','no') NOT NULL,
    `dateVaccinated`			DATE,
    `dateVacEffective`			DATE,
    `vaccinationType`			VARCHAR(25),
	`reasonForNoVaccination`	ENUM('N/A', 'Pregnant', 'Refused', 'Not Effective', 'Allergic') NOT NULL,
    CONSTRAINT `PK_vaccinations` PRIMARY KEY (`vaccinationID`)
);
-- INSERT data into vaccinations
INSERT INTO vaccinations VALUES(NULL, 'yes', '2021-03-24', '2021-04-07', 'Pfizer', 'N/A');
INSERT INTO vaccinations VALUES(NULL, 'yes', '2021-03-1', '2021-04-14', 'Moderna', 'N/A');
INSERT INTO vaccinations VALUES(NULL, 'no', NULL, NULL, NULL, 'Not Effective');
INSERT INTO vaccinations VALUES(NULL, 'no', NULL, NULL, NULL, 'Refused');
INSERT INTO vaccinations VALUES(NULL, 'yes', '2021-03-3', '2021-03-17', 'Moderna', 'N/A');
INSERT INTO vaccinations VALUES(NULL, 'yes', '2021-03-3', '2021-03-17', 'Moderna', 'N/A');
INSERT INTO vaccinations VALUES(NULL, 'yes', '2021-03-4', '2021-03-18', 'Pfizer', 'N/A');
INSERT INTO vaccinations VALUES(NULL, 'yes', '2021-03-6', '2021-03-20', 'Moderna', 'N/A');
INSERT INTO vaccinations VALUES(NULL, 'yes', '2021-03-14', '2021-03-28', 'Moderna', 'N/A');
INSERT INTO vaccinations VALUES(NULL, 'no', NULL, NULL, NULL, 'Refused');
INSERT INTO vaccinations VALUES(NULL, 'yes', '2021-03-17', '2021-03-31', 'Pfizer', 'N/A');
INSERT INTO vaccinations VALUES(NULL, 'yes', '2021-03-8', '2021-03-22', 'Moderna', 'N/A');
INSERT INTO vaccinations VALUES(NULL, 'no', NULL, NULL, NULL, 'Pregnant');
INSERT INTO vaccinations VALUES(NULL, 'yes', '2021-03-8', '2021-03-22', 'Pfizer', 'N/A');
INSERT INTO vaccinations VALUES(NULL, 'no', NULL, NULL, NULL, 'Refused');
INSERT INTO vaccinations VALUES(NULL, 'yes', '2021-03-10', '2021-03-24', 'Moderna', 'N/A');
INSERT INTO vaccinations VALUES(NULL, 'no', NULL, NULL, NULL, 'Refused');
INSERT INTO vaccinations VALUES(NULL, 'yes', '2021-03-10', '2021-03-24', 'Pfizer', 'N/A');
INSERT INTO vaccinations VALUES(NULL, 'no', NULL, NULL, NULL, 'Pregnant');
INSERT INTO vaccinations VALUES(NULL, 'yes', '2021-02-10', '2021-02-24', 'Pfizer', 'N/A');
INSERT INTO vaccinations VALUES(NULL, 'yes', '2021-02-11', '2021-02-25', 'Pfizer', 'N/A');
INSERT INTO vaccinations VALUES(NULL, 'yes', '2021-02-12', '2021-02-26', 'Pfizer', 'N/A');
INSERT INTO vaccinations VALUES(NULL, 'no', NULL, NULL, NULL, 'Refused');
INSERT INTO vaccinations VALUES(NULL, 'yes', '2021-02-16', '2021-03-2', 'Pfizer', 'N/A');
INSERT INTO vaccinations VALUES(NULL, 'no', NULL, NULL, NULL, 'Allergic');
INSERT INTO vaccinations VALUES(NULL, 'yes', '2021-02-16', '2021-03-2', 'Pfizer', 'N/A');
INSERT INTO vaccinations VALUES(NULL, 'yes', '2021-02-17', '2021-03-3', 'Pfizer', 'N/A');
INSERT INTO vaccinations VALUES(NULL, 'yes', '2021-02-17', '2021-03-3', 'Pfizer', 'N/A');
INSERT INTO vaccinations VALUES(NULL, 'yes', '2021-02-20', '2021-03-6', 'Pfizer', 'N/A');
INSERT INTO vaccinations VALUES(NULL, 'no', NULL, NULL, NULL, 'Allergic');
INSERT INTO vaccinations VALUES(NULL, 'no', NULL, NULL, NULL, 'Refused');

INSERT INTO vaccinations VALUES(NULL, 'yes', '2021-02-04', '2021-02-15', 'Pfizer', 'N/A');
INSERT INTO vaccinations VALUES(NULL, 'yes', '2021-03-12', '2021-01-22', 'Moderna', 'N/A');
INSERT INTO vaccinations VALUES(NULL, 'no', NULL, NULL, NULL, 'Not Effective');
INSERT INTO vaccinations VALUES(NULL, 'no', NULL, NULL, NULL, 'Refused');
INSERT INTO vaccinations VALUES(NULL, 'yes', '2020-11-03', '2021-11-17', 'Moderna', 'N/A');
INSERT INTO vaccinations VALUES(NULL, 'no', NULL, NULL, NULL, 'Not Effective');
INSERT INTO vaccinations VALUES(NULL, 'yes', '2020-12-04', '2020-12-18', 'Pfizer', 'N/A');
INSERT INTO vaccinations VALUES(NULL, 'yes', '2021-03-06', '2021-03-24', 'Moderna', 'N/A');
INSERT INTO vaccinations VALUES(NULL, 'yes', '2021-04-01', '2021-04-14', 'Moderna', 'N/A');
INSERT INTO vaccinations VALUES(NULL, 'no', NULL, NULL, NULL, 'Refused');
INSERT INTO vaccinations VALUES(NULL, 'yes', '2021-01-06', '2021-01-20', 'Pfizer', 'N/A');
INSERT INTO vaccinations VALUES(NULL, 'yes', '2021-02-14', '2021-02-23', 'Moderna', 'N/A');
INSERT INTO vaccinations VALUES(NULL, 'no', NULL, NULL, NULL, 'Pregnant');
INSERT INTO vaccinations VALUES(NULL, 'yes', '2020-10-08', '2020-10-22', 'Pfizer', 'N/A');
INSERT INTO vaccinations VALUES(NULL, 'no', NULL, NULL, NULL, 'Refused');
INSERT INTO vaccinations VALUES(NULL, 'yes', '2020-09-24', '2020-10-06', 'Moderna', 'N/A');
INSERT INTO vaccinations VALUES(NULL, 'no', NULL, NULL, NULL, 'Refused');
INSERT INTO vaccinations VALUES(NULL, 'yes', '2020-10-01', '2020-10-16', 'Pfizer', 'N/A');
INSERT INTO vaccinations VALUES(NULL, 'no', NULL, NULL, NULL, 'Pregnant');
INSERT INTO vaccinations VALUES(NULL, 'yes', NULL, NULL, NULL, 'N/A');
INSERT INTO vaccinations VALUES(NULL, 'no', NULL, NULL, NULL, 'Allergic');
INSERT INTO vaccinations VALUES(NULL, 'yes', '2021-02-14', '2021-02-26', 'Pfizer', 'N/A');
INSERT INTO vaccinations VALUES(NULL, 'no', NULL, NULL, NULL, 'Refused');
INSERT INTO vaccinations VALUES(NULL, 'yes', '2020-12-09', '2020-12-23', 'Pfizer', 'N/A');
INSERT INTO vaccinations VALUES(NULL, 'no', NULL, NULL, NULL, 'Allergic');
INSERT INTO vaccinations VALUES(NULL, 'yes', '2021-01-01', '2021-01-16', 'Pfizer', 'N/A');
INSERT INTO vaccinations VALUES(NULL, 'yes', '2021-03-13', '2021-03-23', 'Moderna', 'N/A');
INSERT INTO vaccinations VALUES(NULL, 'no', NULL, NULL, NULL, 'Refused');
INSERT INTO vaccinations VALUES(NULL, 'yes', '2020-10-20', '2021-11-06', 'Pfizer', 'N/A');
INSERT INTO vaccinations VALUES(NULL, 'no', NULL, NULL, NULL, 'Allergic');
INSERT INTO vaccinations VALUES(NULL, 'no', NULL, NULL, NULL, 'Refused');
-- SELECT * FROM vaccinations;


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
INSERT INTO covidTestResult VALUES(NULL, 'no', NULL, NULL, NULL);
INSERT INTO covidTestResult VALUES(NULL, 'yes', 'isolation', '2021-04-09', '2021-05-13');
INSERT INTO covidTestResult VALUES(NULL, 'no', NULL, NULL, NULL);
INSERT INTO covidTestResult VALUES(NULL, 'yes', 'isolation', '2020-05-12', '2021-05-24');
INSERT INTO covidTestResult VALUES(NULL, 'no', NULL, NULL, NULL);
INSERT INTO covidTestResult VALUES(NULL, 'yes', 'isolation', '2020-07-15', '2021-08-13');
INSERT INTO covidTestResult VALUES(NULL, 'no', NULL, NULL, NULL);
INSERT INTO covidTestResult VALUES(NULL, 'yes', 'hospital', '2020-07-21', '2020-12-24');
INSERT INTO covidTestResult VALUES(NULL, 'yes', 'isolation', '2020-07-22', '2020-12-10');
INSERT INTO covidTestResult VALUES(NULL, 'no', NULL, NULL, NULL);
INSERT INTO covidTestResult VALUES(NULL, 'yes', 'hospital', '2020-07-24', '2020-12-7');
INSERT INTO covidTestResult VALUES(NULL, 'no', NULL, NULL, NULL);
INSERT INTO covidTestResult VALUES(NULL, 'no', NULL, NULL, NULL);
INSERT INTO covidTestResult VALUES(NULL, 'no', NULL, NULL, NULL);
INSERT INTO covidTestResult VALUES(NULL, 'no', NULL, NULL, NULL);
INSERT INTO covidTestResult VALUES(NULL, 'yes', 'hospital', '2021-01-01', '2021-01-26');
INSERT INTO covidTestResult VALUES(NULL, 'no', NULL, NULL, NULL);
INSERT INTO covidTestResult VALUES(NULL, 'yes', 'hospital', '2021-01-03', '2021-01-25');
INSERT INTO covidTestResult VALUES(NULL, 'no', NULL, NULL, NULL);
INSERT INTO covidTestResult VALUES(NULL, 'no', NULL, NULL, NULL);
INSERT INTO covidTestResult VALUES(NULL, 'no', NULL, NULL, NULL);
INSERT INTO covidTestResult VALUES(NULL, 'yes', 'hospital', '2021-02-07', '2021-03-05');
INSERT INTO covidTestResult VALUES(NULL, 'no', NULL, NULL, NULL);
INSERT INTO covidTestResult VALUES(NULL, 'yes', 'hospital', '2021-03-09', '2021-04-05');
INSERT INTO covidTestResult VALUES(NULL, 'no', NULL, NULL, NULL);
INSERT INTO covidTestResult VALUES(NULL, 'no', NULL, NULL, NULL);
INSERT INTO covidTestResult VALUES(NULL, 'no', NULL, NULL, NULL);
INSERT INTO covidTestResult VALUES(NULL, 'yes', 'hospital', '2021-03-11', '2021-04-05');
INSERT INTO covidTestResult VALUES(NULL, 'no', NULL, NULL, NULL);

INSERT INTO covidTestResult VALUES(NULL, 'yes', 'isolation', '2021-05-01', '2021-05-22');
INSERT INTO covidTestResult VALUES(NULL, 'no', NULL, NULL, NULL);
INSERT INTO covidTestResult VALUES(NULL, 'yes', 'isolation', '2021-05-02', '2021-05-18');
INSERT INTO covidTestResult VALUES(NULL, 'no', NULL, NULL, NULL);
INSERT INTO covidTestResult VALUES(NULL, 'yes', 'isolation', '2020-05-03', '2021-05-16');
INSERT INTO covidTestResult VALUES(NULL, 'yes', 'hospital', '2020-08-13', '2021-08-30');
INSERT INTO covidTestResult VALUES(NULL, 'no', NULL, NULL, NULL);
INSERT INTO covidTestResult VALUES(NULL, 'no', NULL, NULL, NULL);
INSERT INTO covidTestResult VALUES(NULL, 'no', NULL, NULL, NULL);
INSERT INTO covidTestResult VALUES(NULL, 'no', NULL, NULL, NULL);
INSERT INTO covidTestResult VALUES(NULL, 'yes', 'hospital', '2021-02-06', '2021-02-12');
INSERT INTO covidTestResult VALUES(NULL, 'yes', 'hospital', '2021-04-16', '2021-04-30');
INSERT INTO covidTestResult VALUES(NULL, 'no', NULL, NULL, NULL);
INSERT INTO covidTestResult VALUES(NULL, 'no', NULL, NULL, NULL);
INSERT INTO covidTestResult VALUES(NULL, 'no', NULL, NULL, NULL);
INSERT INTO covidTestResult VALUES(NULL, 'no', NULL, NULL, NULL);
INSERT INTO covidTestResult VALUES(NULL, 'yes', 'hospital', '2020-11-11', '2021-12-25');
INSERT INTO covidTestResult VALUES(NULL, 'no', NULL, NULL, NULL);
INSERT INTO covidTestResult VALUES(NULL, 'yes', 'hospital', '2021-01-03', '2021-02-12');
INSERT INTO covidTestResult VALUES(NULL, 'no', NULL, NULL, NULL);
INSERT INTO covidTestResult VALUES(NULL, 'no', NULL, NULL, NULL);
INSERT INTO covidTestResult VALUES(NULL, 'no', NULL, NULL, NULL);
INSERT INTO covidTestResult VALUES(NULL, 'yes', 'hospital', '2020-05-12', '2020-06-18');
INSERT INTO covidTestResult VALUES(NULL, 'no', NULL, NULL, NULL);
INSERT INTO covidTestResult VALUES(NULL, 'yes', 'hospital', '2020-10-17', '2020-10-31');
INSERT INTO covidTestResult VALUES(NULL, 'no', NULL, NULL, NULL);
INSERT INTO covidTestResult VALUES(NULL, 'no', NULL, NULL, NULL);
INSERT INTO covidTestResult VALUES(NULL, 'no', NULL, NULL, NULL);
INSERT INTO covidTestResult VALUES(NULL, 'yes', 'hospital', '2020-07-15', '2021-08-01');
INSERT INTO covidTestResult VALUES(NULL, 'yes', 'isolation', '2021-03-07', '2021-03-21');
-- SELECT * FROM covidTestResult;


-- Table for health_linktable
DROP TABLE IF EXISTS `health_linktable`;
CREATE TABLE IF NOT EXISTS `health_linktable` (
	`healthID`				INTEGER NOT NULL AUTO_INCREMENT,
    `vaccinationID`			INTEGER,
    `testID`				INTEGER,
    CONSTRAINT `PK_health_linktable` PRIMARY KEY (`healthID`)
);
-- INSERT data into health_linktable
INSERT INTO health_linktable VALUES(NULL, 1, 1);
INSERT INTO health_linktable VALUES(NULL, 2, 2);
INSERT INTO health_linktable VALUES(NULL, 3, 3);
INSERT INTO health_linktable VALUES(NULL, 4, 4);
INSERT INTO health_linktable VALUES(NULL, 5, 5);
INSERT INTO health_linktable VALUES(NULL, 6, 6);
INSERT INTO health_linktable VALUES(NULL, 7, 7);
INSERT INTO health_linktable VALUES(NULL, 8, 8);
INSERT INTO health_linktable VALUES(NULL, 9, 9);
INSERT INTO health_linktable VALUES(NULL, 10, 10);
INSERT INTO health_linktable VALUES(NULL, 11, 11);
INSERT INTO health_linktable VALUES(NULL, 12, 12);
INSERT INTO health_linktable VALUES(NULL, 13, 13);
INSERT INTO health_linktable VALUES(NULL, 14, 14);
INSERT INTO health_linktable VALUES(NULL, 15, 15);
INSERT INTO health_linktable VALUES(NULL, 16, 16);
INSERT INTO health_linktable VALUES(NULL, 17, 17);
INSERT INTO health_linktable VALUES(NULL, 18, 18);
INSERT INTO health_linktable VALUES(NULL, 19, 19);
INSERT INTO health_linktable VALUES(NULL, 20, 20);
INSERT INTO health_linktable VALUES(NULL, 21, 21);
INSERT INTO health_linktable VALUES(NULL, 22, 22);
INSERT INTO health_linktable VALUES(NULL, 23, 23);
INSERT INTO health_linktable VALUES(NULL, 24, 24);
INSERT INTO health_linktable VALUES(NULL, 25, 25);
INSERT INTO health_linktable VALUES(NULL, 26, 26);
INSERT INTO health_linktable VALUES(NULL, 27, 27);
INSERT INTO health_linktable VALUES(NULL, 28, 28);
INSERT INTO health_linktable VALUES(NULL, 29, 29);
INSERT INTO health_linktable VALUES(NULL, 30, 30);

INSERT INTO health_linktable VALUES(NULL, 31, 31);
INSERT INTO health_linktable VALUES(NULL, 32, 32);
INSERT INTO health_linktable VALUES(NULL, 33, 33);
INSERT INTO health_linktable VALUES(NULL, 34, 34);
INSERT INTO health_linktable VALUES(NULL, 35, 35);
INSERT INTO health_linktable VALUES(NULL, 36, 36);
INSERT INTO health_linktable VALUES(NULL, 37, 37);
INSERT INTO health_linktable VALUES(NULL, 38, 38);
INSERT INTO health_linktable VALUES(NULL, 39, 39);
INSERT INTO health_linktable VALUES(NULL, 40, 40);
INSERT INTO health_linktable VALUES(NULL, 41, 41);
INSERT INTO health_linktable VALUES(NULL, 42, 42);
INSERT INTO health_linktable VALUES(NULL, 43, 43);
INSERT INTO health_linktable VALUES(NULL, 44, 44);
INSERT INTO health_linktable VALUES(NULL, 45, 45);
INSERT INTO health_linktable VALUES(NULL, 46, 46);
INSERT INTO health_linktable VALUES(NULL, 47, 47);
INSERT INTO health_linktable VALUES(NULL, 48, 48);
INSERT INTO health_linktable VALUES(NULL, 49, 49);
INSERT INTO health_linktable VALUES(NULL, 50, 50);
INSERT INTO health_linktable VALUES(NULL, 51, 51);
INSERT INTO health_linktable VALUES(NULL, 52, 52);
INSERT INTO health_linktable VALUES(NULL, 53, 53);
INSERT INTO health_linktable VALUES(NULL, 54, 54);
INSERT INTO health_linktable VALUES(NULL, 55, 55);
INSERT INTO health_linktable VALUES(NULL, 56, 56);
INSERT INTO health_linktable VALUES(NULL, 57, 57);
INSERT INTO health_linktable VALUES(NULL, 58, 58);
INSERT INTO health_linktable VALUES(NULL, 59, 59);
INSERT INTO health_linktable VALUES(NULL, 60, 60);
-- SELECT * FROM health_linktable;

-- ADDING FOREIGN KEYS
-- ALTER TABLE `tenants` ADD CONSTRAINT `FK_tenants_locations`
-- 	FOREIGN KEY (`locationID`) REFERENCES `locations` (`locationID`);
-- ALTER TABLE `tenants` ADD CONSTRAINT `FK_tenants_health`
-- 	FOREIGN KEY (`healthID`) REFERENCES `health_linktable` (`healthID`);
--     
-- ALTER TABLE `carers` ADD CONSTRAINT `FK_carers_locations`
-- 	FOREIGN KEY (`locationID`) REFERENCES `locations` (`locationID`);
-- ALTER TABLE `carers` ADD CONSTRAINT `FK_carers_health`
-- 	FOREIGN KEY (`healthID`) REFERENCES `health_linktable` (`healthID`);
--     
-- ALTER TABLE `health_linktable` ADD CONSTRAINT `FK_health_vaccinations`
-- 	FOREIGN KEY (`vaccinationID`) REFERENCES `vaccinations` (`vaccinationID`);
-- ALTER TABLE `health_linktable` ADD CONSTRAINT `FK_health_covidTestResult`
-- 	FOREIGN KEY (`testID`) REFERENCES `covidTestResult` (`testID`);


------------------------------------------------


-- Table for AdminCredentials
DROP TABLE IF EXISTS `AdminCredentials`;
CREATE TABLE `AdminCredentials` (
	`AdminID`			INTEGER NOT NULL AUTO_INCREMENT,
    `Username`			VARCHAR(25) NOT NULL,
    `Email`				VARCHAR(50) NOT NULL,
    `Password`			VARCHAR(25) NOT NULL,
    `role`				ENUM('admin','staff') NOT NULL,
    CONSTRAINT `PK_AdminCredentials` PRIMARY KEY (`AdminID`)
);
-- INSERT data into AdminCredentials
INSERT INTO `AdminCredentials` VALUES (null, 'admin', 'admin@admin.com', 'adminpass', 'admin');
INSERT INTO `AdminCredentials` VALUES (null, 'staff', 'staff@staff.com', 'staffpass', 'staff');
INSERT INTO `AdminCredentials` VALUES (null, 'abdulmiah', 'miaham@cardiff.ac.uk', 'abdulpass', 'staff');
-- SELECT * FROM AdminCredentials;


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
-- INSERT INTO `AdminLog` VALUES (null, 1, NOW(), NOW()+1000);
-- UPDATE `AdminLog`
-- SET TimeLoggedOff = '2021-03-25 19:26:36'  
-- WHERE SessionID IN
-- (SELECT MAX(SessionID)
-- FROM AdminLog
-- WHERE AdminID = 1);
-- SELECT * FROM AdminLog;

-- Table for CovidCaseFigures
-- DROP TABLE IF EXISTS `CovidCaseFigures`;
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
-- INSERT INTO `CovidCaseFigures` VALUES (null, '2021-04-03', 'Cardiff', 'ltlt', 1, Null);
-- SELECT * FROM CovidCaseFigures;


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
-- SELECT * FROM VaccinationFigures;



-- -- VIEWS -- --

-- VIEW for tenants Vaccinations
DROP VIEW IF EXISTS `tenantsVaccinations`;
CREATE VIEW tenantsVaccinations AS
SELECT tenants.tenancyNo, tenants.healthID, tenants.locationID,
tenants.dob, vaccinations.vaccinated, vaccinations.vaccinationType, vaccinations.reasonForNoVaccination
FROM tenants
INNER JOIN health_linktable 
ON tenants.healthID = health_linktable.healthID
INNER JOIN vaccinations
ON health_linktable.vaccinationID = vaccinations.vaccinationID;
-- SELECT * FROM tenantsVaccinations;

-- VIEW for tenants COVID cases
DROP VIEW IF EXISTS `tenantsCases`;
CREATE VIEW tenantsCases AS
SELECT t.firstname, t.surname, t.dob, ctr.positiveCase
FROM tenants t
JOIN health_linktable h ON t.healthID = h.healthID
JOIN covidTestResult ctr ON h.testID = ctr.testID;
-- SELECT * FROM tenantsCases;

-- VIEW for carer COVID cases
DROP VIEW IF EXISTS `carersCases`;
CREATE VIEW carersCases AS 
SELECT c.firstname, c.surname, c.dob, ctr.positiveCase
FROM carers c
JOIN health_linktable h ON c.healthID = h.healthID
JOIN covidTestResult ctr ON h.testID = ctr.testID;
-- SELECT * FROM carersCases;

-- VIEW for relevent data for tenants
DROP VIEW IF EXISTS `adminViewOfData`;
CREATE VIEW adminViewOfData AS
SELECT t.tenancyNo, t.firstname, t.surname, t.dob, l.postcode, l.localAuthority, l.businessArea, c.positiveCase, v.vaccinated
FROM tenants t
JOIN locations l ON t.locationID = l.locationID
JOIN health_linktable h ON t.healthID = h.healthID
JOIN covidTestResult c ON h.testID = c.testID
JOIN vaccinations v ON h.vaccinationID = v.vaccinationID;
-- SELECT * FROM adminViewOfData;

-- VIEW for data to edit on the tenants edit page
DROP VIEW IF EXISTS `tenantsEditData`;
CREATE VIEW tenantsEditData AS
SELECT t.tenancyNo, t.firstname, t.surname, t.dob, l.postcode, l.localAuthority, l.businessArea, c.positiveCase, c.`status`, c.resultDate, c.endOfIsolation, v.vaccinated, v.dateVaccinated, v.dateVacEffective, v.vaccinationType, v.reasonForNoVaccination
FROM tenants t
JOIN locations l ON t.locationID = l.locationID
JOIN health_linktable h ON t.healthID = h.healthID
JOIN covidTestResult c ON h.testID = c.testID
JOIN vaccinations v ON h.vaccinationID = v.vaccinationID;
-- SELECT * FROM tenantsEditData;

-- STORED PROCEDURES -- --

-- SP for number of tenants vaccinated
DROP PROCEDURE IF EXISTS countNumberOfVaccinatedTenants;
DELIMITER //
CREATE PROCEDURE countNumberOfVaccinatedTenants()
BEGIN
SELECT COUNT(tenancyNO) AS TotalTenantsVaccinated FROM tenantsVaccinations
WHERE vaccinated = "yes";
END //
DELIMITER ;

-- SP for number of tenants not vaccinated
DROP PROCEDURE IF EXISTS countNumberOfNonVaccinatedTenants;
DELIMITER //
CREATE PROCEDURE countNumberOfNonVaccinatedTenants()
BEGIN
SELECT COUNT(tenancyNO) AS TotalTenantsVaccinated FROM tenantsVaccinations
WHERE vaccinated = "no";
END //
DELIMITER ;
-- CALL countNumberOfVaccinatedTenants();
-- CALL countNumberOfNonVaccinatedTenants();

-- SP for number of tenants with COVID
DROP PROCEDURE IF EXISTS tenantsPositiveCases;
DELIMITER //
CREATE PROCEDURE tenantsPositiveCases()
BEGIN
	SELECT COUNT(*)
	FROM tenantsCases
	WHERE positiveCase = 'yes';
END //
DELIMITER ;

-- SP for number of tenants without COVID
DROP PROCEDURE IF EXISTS tenantsNegativeCases;
DELIMITER //
CREATE PROCEDURE tenantsNegativeCases()
BEGIN
	SELECT COUNT(*)
	FROM tenantsCases
	WHERE positiveCase = 'no';
END //
DELIMITER ;
-- CALL tenantsPositiveCases();
-- CALL tenantsNegativeCases();

-- SP for number of carers with COVID
DROP PROCEDURE IF EXISTS carerPositiveCases;
DELIMITER ££ 
CREATE PROCEDURE carerPositiveCases()
BEGIN 
	SELECT COUNT(*)
    FROM carersCases
    WHERE positiveCase = "yes";
END ££
DELIMITER ;

-- SP for number of carers without COVID
DROP PROCEDURE IF EXISTS carerNegativeCases;
DELIMITER ££ 
CREATE PROCEDURE carerNegativeCases()
BEGIN 
	SELECT COUNT(*)
    FROM carersCases
    WHERE positiveCase = "no";
END ££
DELIMITER ;

-- CALL carerPositiveCases();
-- CALL carerNegativeCases();


-- -- FUNCTIONS -- -- 

-- Function for number of tenants with COVID
DROP FUNCTION IF EXISTS tenantsPositiveCases;
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

-- Function for number of tenants without COVID
DROP FUNCTION IF EXISTS tenantsNegativeCases;
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

-- SELECT tenantsPositiveCases();
-- SELECT tenantsNegativeCases();
