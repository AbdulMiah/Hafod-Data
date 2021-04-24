USE hafod_database;

DROP VIEW IF EXISTS `tenantsEditData`;
CREATE VIEW tenantsEditData AS
SELECT t.tenancyNo, t.firstname, t.surname, t.dob, l.postcode, l.localAuthority, l.businessArea, c.positiveCase, c.`status`, c.resultDate, c.endOfIsolation, v.vaccinated, v.dateVaccinated, v.dateVacEffective, v.vaccinationType, v.reasonForNoVaccination
FROM tenants t
JOIN locations l ON t.locationID = l.locationID
JOIN health_linktable h ON t.healthID = h.healthID
JOIN covidTestResult c ON h.testID = c.testID
JOIN vaccinations v ON h.vaccinationID = v.vaccinationID;

SELECT * FROM tenantsEditData;
SELECT * FROM vaccinations; 