-- VIEWS 
CREATE VIEW tenantsVaccinations AS
SELECT tenants.tenancyNo, tenants.healthID, tenants.locationID,
tenants.dob, vaccinations.vaccinated, vaccinations.vaccinationType, vaccinations.reasonForNoVaccination
FROM tenants
INNER JOIN health_linktable 
ON tenants.healthID = health_linktable.healthID
INNER JOIN vaccinations
ON health_linktable.vaccinationID = vaccinations.vaccinationID;
-- Create view of tenants who are 
SELECT * FROM tenantsVaccinations;

-- Stored Procedure 
DELIMITER //
CREATE PROCEDURE countNumberOfVaccinatedTenants()
BEGIN
SELECT COUNT(tenancyNO) AS TotalTenantsVaccinated FROM tenantsVaccinations
WHERE vaccinated = "yes";
END //
DELIMITER ;

CALL countNumberOfVaccinatedTenants();