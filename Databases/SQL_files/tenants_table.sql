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

INSERT INTO tenants VALUES(NULL, NULL, NULL, 'John', 'Doe', 2000-03-24);
INSERT INTO tenants VALUES(NULL, NULL, NULL, 'Sarah', 'Smith', 1988-03-20);
INSERT INTO tenants VALUES(NULL, NULL, NULL, 'Aria', 'Jones', 1990-06-20);
INSERT INTO tenants VALUES(NULL, NULL, NULL, 'Jo', 'Lee', 1970-05-27);
SELECT * FROM tenants;