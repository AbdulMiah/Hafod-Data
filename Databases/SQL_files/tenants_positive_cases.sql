USE hafod_database;

SELECT t.firstname, t.surname, t.dob, ctr.positiveCase
FROM tenants t
JOIN health_linktable h ON t.healthID = h.healthID
JOIN covidTestResult ctr ON h.testID = ctr.testID
WHERE ctr.positiveCase = 'yes';
