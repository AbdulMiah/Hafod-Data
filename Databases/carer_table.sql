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

INSERT INTO carer VALUES(741, NULL , 'Tom', 'Cooper', 'Support Assistant', 1968-03-20, NULL);
INSERT INTO carer VALUES(8878, NULL , 'Charles', 'Osorio', 'Registered Nurse', 2000-02-05, NULL);
INSERT INTO carer VALUES(740, NULL, 'Ffion', 'Adams', 'Registered Nurse', 1995-08-05, NULL);
INSERT INTO carer VALUES(2345, NULL, 'Karen', 'Jenkins', 'Support Assistant', 1967-09-05, NULL);

SELECT * FROM carer;
