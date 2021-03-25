DROP TABLE `locations`;

CREATE TABLE IF NOT EXISTS `locations` (
`locationID`	 INTEGER NOT NULL AUTO_INCREMENT,
`postcode`       VARCHAR(20) NOT NULL, 
`latitude`       DECIMAL(4,1)  NOT NULL,
`longitude`      DECIMAL(4,1) NOT NULL,
`localAuthority` VARCHAR(30) NOT NULL,
`businessArea`   VARCHAR(30) NOT NULL, 
`streetName`     VARCHAR(30) NOT NULL,
CONSTRAINT `PK_locationID` PRIMARY KEY (`locationID`)
);

INSERT INTO `locations` VALUES (null, "CF23 9LJ", 228.6, 139.6, "Cardiff", "Housing", "Ael Y Bryn");
INSERT INTO `locations` VALUES (null, "CF24 9LJ", 139.6, 119.6, "Cardiff", "Housing", "Ael Y Bryn");
INSERT INTO `locations` VALUES (null, "CF24 9LK", 8.6, 9.6, "Cardiff", "Housing", "Ael Y Bryn");
SELECT * FROM locations;