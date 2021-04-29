USE hafod_database;

CREATE VIEW adminViewOfCarersData AS 
SELECT c.staffNo, c.firstname, c.surname, c.role, c.dob, l.postcode, l.localAuthority, l.businessArea, ctr.positiveCase, v.vaccinated
FROM carers c
JOIN locations l ON l.locationID = c.locationID
JOIN health_linktable h ON c.healthID = h.healthID
JOIN covidTestResult ctr ON h.testID = ctr.testID
JOIN vaccinations v ON v.vaccinationID = h.vaccinationID;

SELECT *  
FROM adminViewOfCarersData;