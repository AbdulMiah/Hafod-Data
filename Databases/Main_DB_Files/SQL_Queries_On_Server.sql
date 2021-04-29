-- --------------------------------------------- -- 
-- SQL QUERIES USED IN SERVER 
-- --------------------------------------------- -- 
-- Alot of the statements are commented out as they use an ever so slightly different syntax to standard SQL 
-- Where %s is seen signifies the input value is a string and is used to prevent SQL injection attacks 
-- A value will then be assigned in place of the %s later in the statement, example immediately below. 

-- Example 
-- INSERT INTO vaccinations 
-- (vaccinationID, vaccinated, dateVaccinated, dateVacEffective, vaccinationType, reasonForNoVaccination)
-- VALUES(%s, %s, %s, %s, %s, %s)")
-- cur.execute(insertVac, [None, insertData[8], insertData[9], insertData[10], insertData[11], insertData[12]])

-- ------------------------------- -- 
-- UPDATE STATEMENTS / TRANSACTION EXAMPLE -- 
-- ------------------------------- -- 
-- These are all submitted within the same transaction 
-- To avoid holes within the database

-- UPDATE tenantsEditData  
-- SET firstname=%s, surname=%s, dob=%s 
-- WHERE tenancyNo=%s; 

-- UPDATE tenantsEditData 
-- SET postcode=%s, localAuthority=%s, businessArea=%s
-- WHERE tenancyNo=%s;

-- UPDATE tenantsEditData 
-- SET positiveCase=%s, status=%s, resultDate=%s, endOfIsolation=%s
-- WHERE tenancyNo=%s; 

-- UPDATE tenantsEditData 
-- SET vaccinated=%s, dateVaccinated=%s, dateVacEffective=%s, vaccinationType=%s, reasonForNoVaccination=%s
-- WHERE tenancyNo=%s;


-- End of Transaction 

-- UPDATE CovidCaseFigures 
-- SET Date=%s, AreaName=%s, AreaType=%s, NewCasesOnGivenDay=%s, ReportedDeathsOnGivenDay=%s, latitude=%s, longitude=%s
-- WHERE AreaName = %s

-- -------------------------------
-- INSERT STATEMENTS 
-- -------------------------------

-- INSERT INTO covidTestResult 
-- (testID, positiveCase, status, resultDate, endOfIsolation) VALUES (%s, %s, %s, %s, %s)")
-- cur.execute(insertCTR, [None, insertData[4], insertData[5], insertData[6], insertData[7]])



-- INSERT INTO vaccinations 
-- (vaccinationID, vaccinated, dateVaccinated, dateVacEffective, vaccinationType, reasonForNoVaccination)
-- VALUES(%s, %s, %s, %s, %s, %s)")
-- cur.execute(insertVac, [None, insertData[8], insertData[9], insertData[10], insertData[11], insertData[12]])
    
            
-- INSERT INTO health_linktable
-- (healthID, testID, vaccinationID)"
-- VALUES (%s, %s, %s)
-- cur.execute(insertHeathLinkTable, [None, tenantTestID, tenantVacID])  
            
-- INSERT INTO tenants
-- (healthID,locationID, firstname, surname, dob) VALUES (%s, %s,%s,%s,%s)")
-- cur.execute(insertTenants, [tenantHealthID, insertData[3], insertData[0], insertData[1], insertData[2]])
 
-- Example of how insert statement would look in python 
-- (Insert Query)    
-- INSERT INTO CovidCaseFigures 
-- (Date, AreaName, AreaType, NewCasesOnGivenDay, ReportedDeathsOnGivenDay, latitude, longitude) 
-- VALUES (%s,%s,%s,%s,%s,%s,%s)
-- insertVal = (apiDate, apiAreaName, apiAreaType, NewCasesByPublishDate, NewDeathsByDeathDate, lat, long)
-- cur.execute(insertQuery, insertVal) 
-- conn.commit()
                        
-- INSERT INTO locations 
-- (locationID, postcode, latitude, longitude, localAuthority, businessArea) 
-- VALUES(%s,%s,%s,%s,%s,%s) 
                                
-- --------------------------------------------- -- 
-- SELECT Statements used on the server 
SELECT * FROM locations 

SELECT * FROM CovidCaseFigures

SELECT * FROM locations

SELECT * FROM adminViewOfCarersData

-- SELECT * FROM adminViewOfCarersData WHERE firstname LIKE %s, [carerName]

-- SELECT * FROM tenants 
-- ORDER BY tenancyNo DESC 
-- LIMIT 1

-- SELECT vaccinationID FROM vaccinations ORDER BY vaccinationID DESC LIMIT 1

-- SELECT * FROM tenantsEditData
 ORDER BY tenancyNo DESC LIMIT 1;

 SELECT * FROM tenants
 ORDER BY tenancyNo DESC LIMIT 1;

SELECT * FROM adminViewOfData 

-- SELECT testID FROM covidTestResult ORDER BY testID DESC LIMIT 1;

-- SELECT * FROM adminViewOfData WHERE firstname LIKE %s", [tenantName]

-- %s is a variable set by the server 
-- SELECT * FROM tenantsEditData WHERE tenancyNo = %s                      

            SELECT * FROM AdminCredentials 
                    WHERE (Username=%s OR Email=%s) AND Password=%s
                    cur.execute(query, [username, email, password])
                    
SELECT * FROM CovidCaseFigures

SELECT healthID FROM health_linktable ORDER BY healthID DESC LIMIT 1
                        
