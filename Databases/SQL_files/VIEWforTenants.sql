USE hafod_database;

DROP VIEW adminViewOfData;
CREATE VIEW adminViewOfData AS
SELECT t.tenancyNo, t.firstname, t.surname, t.dob, l.postcode, l.localAuthority, l.businessArea, c.positiveCase, v.vaccinated
FROM tenants t
JOIN locations l ON t.locationID = l.locationID
JOIN health_linktable h ON t.healthID = h.healthID
JOIN covidTestResult c ON h.testID = c.testID
JOIN vaccinations v ON h.vaccinationID = v.vaccinationID;

SELECT * FROM adminViewOfData;