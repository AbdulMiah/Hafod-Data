from flask import Flask, redirect, request, render_template, url_for, jsonify, flash, make_response, session, escape
import os
from functools import wraps
from uk_covid19 import Cov19API #Used to call for covid case stats
# In CMD: pipenv install uk-covid19

# import sqlite3
import mysql.connector
import yaml
import time
import csv
import urllib.request as req
import json
from datetime import date, datetime, timedelta

date_yesterday = datetime.strftime(datetime.now() - timedelta(1), '%Y-%m-%d')
API_KEY = 'pk.eyJ1IjoiYWJkdWxtaWFoIiwiYSI6ImNrbXdpN2hwZDBmM3cydXJubXM2eHoyaGQifQ.RI7Qv5cRdy1h-BRgK1NKpA'
app = Flask(__name__, template_folder='templates', static_url_path='/static', static_folder='static')

# Adapted from https://stackoverflow.com/questions/34902378/where-do-i-get-a-secret-key-for-flask/34903502
# Create a random key and store it as secret key. This is to keep client-side sessions secure
secretKey = os.urandom(24).hex()
app.secret_key = secretKey
# print(secretKey)

#===========================
# Connecting to database
# Adapted from https://dev.mysql.com/doc/connector-python/en/connector-python-example-connecting.html
db = yaml.load(open('db.yaml'))
config = {
    'host': db['mysql_host'],
    'user': db['mysql_user'],
    'password': db['mysql_password'],
    'database': db['mysql_db'],
    'raise_on_warnings': True
}

# #===========================

# Help from flask documentation https://flask.palletsprojects.com/en/1.1.x/patterns/viewdecorators/
def login_required(f):
    @wraps(f)
    def decorated_function(*args, **kwargs):
        usertype = 'null'
        if 'usertype' in session:
            usertype = escape(session['usertype'])
        if usertype == 'Admin' or usertype == 'Staff':
            return f(*args, **kwargs)
        else:
            flash("You need to login first!")
            return redirect(url_for('loadLoginPage'))
    return decorated_function

def admin_login_required(f):
    @wraps(f)
    def decorated_function(*args, **kwargs):
        usertype = 'null'
        if 'usertype' in session:
            usertype = escape(session['usertype'])
        if usertype == 'Admin':
            return f(*args, **kwargs)
        else:
            flash("Permission Denied! Only Admin's have access to this page!")
            return redirect(url_for('loadMainPage'))
    return decorated_function

# Abdul - route to main page, where all maps/graphs are displayed
@app.route("/", methods = ['GET', 'POST'])
@login_required
def loadMainPage():
    # usertype = 'null'
    # if 'usertype' in session:
    #     usertype = escape(session['usertype'])
    # if usertype == 'Admin' or usertype == 'Staff':
    tenantsVaccinated = call_numberOfVaccinatedTenants()
    tenantsNonVaccinated = call_numberOfNonVaccinatedTenants()
    tenantsInfected = call_numberOfInfectedTenants()
    tenantsNotInfected = call_numberOfNonInfectedTenants()
    vaccinePfizer = call_pfizer()
    vaccineModerna = call_moderna()
    vaccineAstrazeneca = call_astrazeneca()

    return render_template('mainPage.html', title='Hafod', tenantsVaccinated=tenantsVaccinated, tenantsNonVaccinated=tenantsNonVaccinated, tenantsInfected=tenantsInfected, tenantsNotInfected=tenantsNotInfected, vaccinePfizer=vaccinePfizer, vaccineModerna = vaccineModerna, vaccineAstrazeneca = vaccineAstrazeneca)
    # else:
    #     flash("Please Login first to access the site!")
    #     return redirect("/Login")

# Redirect to Edit Page - Archie and Abdul
@app.route("/Edit/Tenants", methods = ['GET', 'POST'])
@admin_login_required
def loadEditPage():
    # usertype = 'null'
    # if 'usertype' in session:
    #     usertype = escape(session['usertype'])
    # if usertype == 'Admin':
    if request.method == 'GET':
        allData = []
        editData = []
        try:
            conn = mysql.connector.connect(**config)
            cur = conn.cursor()
            print("Connected to database successfully")

            selectAdminData = ("SELECT * FROM adminViewOfData")
            cur.execute(selectAdminData)
            allData = cur.fetchall()

            lastTenancyNo = ("SELECT * FROM tenants "
                    "ORDER BY tenancyNo DESC "
                    "LIMIT 1")
            cur.execute(lastTenancyNo)
            editData = cur.fetchall()

            print("Received all data")
        except mysql.connector.Error as e:
            conn.rollback()
            print("Ran into an error: ", e)
        finally:
            conn.close()
            cur.close()
            print("End of fetch")
            # print(allData)
            return render_template("editPage.html", data=allData, editData=editData, title='All Tenants')

    if request.method == 'POST':
        print("Search Request Submitted")
        tenantName = "%" + request.form.get("searchTenantName", default="Error") + "%"
        allData = []
        print(tenantName)
        try:
            conn = mysql.connector.connect(**config)
            cur = conn.cursor()
            print("Connected to database successfully")
            cur.execute("SELECT * FROM adminViewOfData WHERE firstname LIKE %s", [tenantName])
            allData = cur.fetchall()
            print("Received all data")
        except mysql.connector.Error as e:
            conn.rollback()
            print("Ran into an error: ", e)
        finally:
            conn.close()
            cur.close()
            print("End of fetch")
            print(allData)
            return render_template("editPage.html", data=allData)


@app.route("/EditData/<int:tenantID>", methods = ['GET', 'POST'])
@admin_login_required
def editData(tenantID): # tenantID=None
    if request.method == 'GET':
        try:
            conn = mysql.connector.connect(**config)
            cur = conn.cursor()
            print("Connected to database successfully")
            query = ("SELECT * FROM tenantsEditData "
                    " WHERE tenancyNo = %s ")
            cur.execute(query, [tenantID])
            allData = cur.fetchall()
            print("Received all data")
        except mysql.connector.Error as e:
            conn.rollback()
            print("Ran into an error: ", e)
        finally:
            conn.close()
            cur.close()
            print("End of fetch")
            return render_template("editData.html", data=allData, title='Edit Tenants Data')

    if request.method == 'POST':
        updateData = []
        print("Updating data...")
        updateTenantFirstName = request.form.get("firstName", default="Error")
        updateTenantSurname = request.form.get("surname", default="Error")
        updateTenantDOB = request.form.get("dob", default="Error")
        updateTenantPostCode = request.form.get("postcode", default="Error")
        updateTenantLocalAuth = request.form.get("localAuthority", default="Error")
        updateTenantBusArea = request.form.get("businessArea", default="Error")
        updateTenantCovidCase = request.form.get("positiveCase", default="Error")
        updateTenantStatus = request.form.get("status", default="Error")
        updateTenantDateOfRes = request.form.get("resultDate", default="Error")
        updateTenantIsoDate = request.form.get("endOfIsolation", default="Error")
        updateTenantVaccinated = request.form.get("vaccinated", default="Error")
        updateTenantDateVac = request.form.get("dateVaccinated", default="Error")
        updateTenantDateVacEff = request.form.get("dateVacEffective", default="Error")
        updateTenantVacType = request.form.get("vaccinationType", default="Error")
        updateTenantRFNV = request.form.get("reasonForNoVac", default="Error")
        updateTenantVacType = int(updateTenantVacType)
        print(updateTenantVacType)

        updateData = [updateTenantFirstName, updateTenantSurname, updateTenantDOB, updateTenantPostCode, updateTenantLocalAuth, updateTenantBusArea,
        updateTenantCovidCase, updateTenantStatus, updateTenantDateOfRes, updateTenantIsoDate, updateTenantVaccinated, updateTenantDateVac, updateTenantDateVacEff,
        updateTenantVacType, updateTenantRFNV]

        # Replace fields with string None or Error with None type value
        for i in updateData:
            if (i == "None" or i == "Error"):
                pos = updateData.index(i)
                updateData.remove(i)
                updateData.insert(pos, None)

        try:
            conn = mysql.connector.connect(**config)
            cur = conn.cursor()
            print("Connected to database successfully")
            updateTenants = ("UPDATE tenantsEditData "
                            " SET firstname=%s, surname=%s, dob=%s "
                            " WHERE tenancyNo=%s; ")
            cur.execute(updateTenants, [updateData[0], updateData[1], updateData[2], tenantID])
            print("Success in updating tenants")

            updateLocations = ("UPDATE tenantsEditData "
                            " SET postcode=%s, localAuthority=%s, businessArea=%s"
                            " WHERE tenancyNo=%s; ")
            cur.execute(updateLocations, [updateData[3], updateData[4], updateData[5], tenantID])
            print("Success in updating locations")

            updateCTR = ("UPDATE tenantsEditData "
                        " SET positiveCase=%s, status=%s, resultDate=%s, endOfIsolation=%s"
                        " WHERE tenancyNo=%s; ")
            cur.execute(updateCTR, [updateData[6], updateData[7], updateData[8], updateData[9], tenantID])
            print("Success in updating ctr")

            updateVac = ("UPDATE tenantsEditData "
                        " SET vaccinated=%s, dateVaccinated=%s, dateVacEffective=%s, vaccTypeID=%s, reasonForNoVaccination=%s"
                        " WHERE tenancyNo=%s; ")
            cur.execute(updateVac, [updateData[10], updateData[11], updateData[12], updateData[13], updateData[14], tenantID])
            print("Success in updating vaccinations")

            # Only commit once everything is correct in the input fields
            conn.commit()
            msg = "Successfully updated all data"

        except mysql.connector.Error as e:
            conn.rollback()
            print("Ran into an error: ", e)
            msg =("Error Encountered. Please Check your Entry and Try Again!")
        finally:
            conn.close()
            cur.close()
            print("End of fetch")
            return msg;

#retrieve carer data and edit - Mahi
@app.route("/Edit/Carers", methods = ['GET', 'POST'])
@admin_login_required
def loadEditCarerPage():
    if request.method == 'GET':
        allCarerData = []
        try:
            conn = mysql.connector.connect(**config)
            cur = conn.cursor()
            print("Connected to database successfully")
            selectAdminCarerData = ("SELECT * FROM adminViewOfCarersData")
            cur.execute(selectAdminCarerData)
            allCarerData = cur.fetchall()
            print("Received all data")
        except mysql.connector.Error as e:
            conn.rollback()
            print("Ran into an error: ", e)
        finally:
            conn.close()
            cur.close()
            print("End of fetch")
            print(allCarerData)
            return render_template("editCarerPage.html", data=allCarerData)

    if request.method == 'POST':
        print("Search Request Submitted")
        carerName = "%" + request.form.get("searchCarerName", default="Error") + "%"
        allData = []
        print(carerName)
        try:
            conn = mysql.connector.connect(**config)
            cur = conn.cursor()
            print("Connected to database successfully")
            cur.execute("SELECT * FROM adminViewOfCarersData WHERE firstname LIKE %s", [carerName])
            allData = cur.fetchall()
            print("Received all data")
        except mysql.connector.Error as e:
            conn.rollback()
            print("Ran into an error: ", e)
        finally:
            conn.close()
            cur.close()
            print("End of fetch")
            print(allData)
            return render_template("editCarerPage.html", data=allData)


@app.route("/Edit/insertTenantData", methods = ['GET', 'POST'])
@admin_login_required
def insertTenantData():
    allData = []
    if request.method == 'GET':
        try:
            conn = mysql.connector.connect(**config)
            cur = conn.cursor()
            print("Connected to database successfully")
            query = ("SELECT * FROM tenants "
                    "ORDER BY tenancyNo DESC "
                    "LIMIT 1")
            cur.execute(query)
            allData = cur.fetchall()
            print(allData)
            print("Received all data")
        except mysql.connector.Error as e:
            conn.rollback()
            print("Ran into an error: ", e)
        finally:
            conn.close()
            cur.close()
            print("End of fetch")
            return render_template("insertTenantData.html", data=allData, title='Insert New Tenants Data')

    if request.method == 'POST':
        print(allData)
        insertData = []
        print("Inserting data...")
        insertTenantNo = request.form.get("tenancyNo", default = "Error")
        insertTenantFirstName = request.form.get("firstName", default="Error")
        insertTenantSurname = request.form.get("surname", default="Error")
        insertTenantDOB = request.form.get("dob", default="Error")
        insertTenantlocationID = request.form.get("locationID", default="Error")
        insertTenantCovidCase = request.form.get("positiveCase", default="Error")
        insertTenantStatus = request.form.get("status", default="Error")
        insertTenantDateOfRes = request.form.get("resultDate", default="Error")
        insertTenantIsoDate = request.form.get("endOfIsolation", default="Error")
        insertTenantVaccinated = request.form.get("vaccinated", default="Error")
        insertTenantDateVac = request.form.get("dateVaccinated", default="Error")
        insertTenantDateVacEff = request.form.get("dateVacEffective", default="Error")
        insertTenantVacType = request.form.get("vaccinationType", default="Error")
        insertTenantRFNV = request.form.get("reasonForNoVac", default="Error")
        insertTenantVacType = int(insertTenantVacType)
        print(insertTenantVacType)

        insertData = [insertTenantFirstName, insertTenantSurname, insertTenantDOB, insertTenantlocationID,
        insertTenantCovidCase, insertTenantStatus, insertTenantDateOfRes, insertTenantIsoDate, insertTenantVaccinated, insertTenantDateVac, insertTenantDateVacEff,
        insertTenantVacType, insertTenantRFNV, insertTenantNo]
        # print(insertData)


        # Replace fields with string None or Error with None type value
        for i in insertData:
            if (i == "None" or i == "Error"):
                pos = insertData.index(i)
                insertData.remove(i)
                insertData.insert(pos, None)

        try:
            msg = ""
            flashMsg = ""
            conn = mysql.connector.connect(**config)
            cur = conn.cursor()
            print("Connected to database successfully")

            print("Starting Covid Test Result Insert")
            insertCTR = ("INSERT INTO covidTestResults "
                        "(testID, positiveCase, status, resultDate, endOfIsolation) VALUES (%s, %s, %s, %s, %s)")
            cur.execute(insertCTR, [None, insertData[4], insertData[5], insertData[6], insertData[7]])
            print("Success inserting covid test result")
            # conn.commit()

            getTenantTestID = cur.execute("SELECT testID FROM covidTestResults ORDER BY testID DESC LIMIT 1")
            tenantTestID = cur.fetchall()
            tenantTestID = tenantTestID[0][0]
            print(tenantTestID)

            ##############################################

            print("Starting Vac Insert")
            insertVac = ("INSERT INTO vaccinations "
                        "(vaccinationID, vaccinated, dateVaccinated, dateVacEffective, vaccTypeID, reasonForNoVaccination)"
                        " VALUES(%s, %s, %s, %s, %s, %s)")
            cur.execute(insertVac, [None, insertData[8], insertData[9], insertData[10], insertData[11], insertData[12]])
            print("Success inserting vaccinations")
            # conn.commit()

            getTenantVacID = cur.execute("SELECT vaccinationID FROM vaccinations ORDER BY vaccinationID DESC LIMIT 1")
            tenantVacID = cur.fetchall()
            tenantVacID = tenantVacID[0][0]
            print(tenantVacID)

            ########################################

            insertTestsLinkTable = ("INSERT INTO testsLinkTable"
                            " (healthID, testID)"
                            " VALUES (%s, %s)")
            cur.execute(insertTestsLinkTable, [None, tenantTestID])
            print("Success inserting testsLinkTable")
            # conn.commit()

            getTenantHealthID = cur.execute("SELECT healthID FROM testsLinkTable ORDER BY healthID DESC LIMIT 1")
            tenantHealthID = cur.fetchall()
            tenantHealthID = tenantHealthID[0][0]
            print(tenantHealthID)

            ########################################

            insertVaccLinkTable = ("INSERT INTO vaccinationsLinkTable"
                            " (healthID, vaccinationID)"
                            " VALUES (%s, %s)")
            cur.execute(insertVaccLinkTable, [None, tenantVacID])
            print("Success inserting vaccinationsLinkTable")
            # conn.commit()


            ##########################################


            print("Starting Tenants Insert")
            insertTenants = ("INSERT INTO tenants"
                            " (healthID,locationID, firstname, surname, dob) VALUES (%s, %s,%s,%s,%s)")
            cur.execute(insertTenants, [tenantHealthID, insertData[3], insertData[0], insertData[1], insertData[2]])
            print("Success inserting tenants")

            # Only commit once all inserts successfully pass
            conn.commit()

            flashMsg = "Successfully Added New Tenant!"
            msg = "Successfully Added New Tenant! Please Refresh the Page to see New Record in the Table Above!"

        except mysql.connector.Error as e:
            conn.rollback()
            print("Ran into an error: ", e)
            msg =("Error Encountered! Could Not Add New Tenant.")
        finally:
            conn.close()
            cur.close()
            print("End of Insertion")
            flash(flashMsg)
            return msg

# Temp redirect route to the login page - Abdul
@app.route("/Login", methods = ['GET', 'POST'])
def loadLoginPage():
    return render_template("loginPage.html")


@app.route("/Logout")
@login_required
def logout():
    session.clear()
    # session.pop('username', None)
    # session.pop('password', None)
    flash("You have Successfully Logged Out!")
    return redirect("/Login")

# Abdul - Created route to validate the login details
@app.route("/CheckLogin", methods = ['GET', 'POST'])
def checkLoginDetails():
    print("Validating Credentials...")
    res = ""

    if request.method == 'POST':
        # Taking input from the login form and saving them as local variables in server
        username = request.form.get("username", default="Error")
        email = request.form.get("username", default="Error")       # Taking both email and username
        password = request.form.get("password", default="Error")
        print(f"Checking details for '{username}'")

        # Connect to database
        try:
            conn = mysql.connector.connect(**config)
            cur = conn.cursor()
            print("Connected to database successfully")

            # SELECT query for appropriate fields and used WHERE clause to compare the values
            query = ("SELECT * FROM adminCredentials "
                    "WHERE (Username=%s OR Email=%s) AND Password=%s")

            # Execute query
            cur.execute(query, [username, email, password])
            res = cur.fetchone()        # Fetch the first result that matches user's input
            msg = "Successfully fetched details from database"      # Print this message if details are found
            conn.commit()
        except mysql.connector.Error as e:
            # Error message if SELECT operation failed to fetch from database
            msg = "Failed to fetch from database"
            print(msg,"\nError:", e)
        finally:
            # If there is a result (If details are found), then let the admin log in
            if res:
                msg = ""
                print(f"Successfully logged in as: '{username}'")

                #Sets session user to username, used to track admin login
                #
                print("Session started")
                session["username"] = username
                session["password"] = password

                # session["loginTime"] = datetime.datetime.now() #Must remove seconds from value
                #userLoginTracker() #Updates the time for when user leaves every minute
                print("User name = " , username)
                print(res)
                if (res[4] == 'admin'):
                    session["usertype"] = 'Admin'
                elif (res[4] == 'staff'):
                    session["usertype"] = 'Staff'
                else:
                    session["usertype"] = 'InvalidUser'

                print("This user is "+session["usertype"])
                # print("Login time is " , session["loginTime"])

                ##PAIR PROGRAMMED WITH ABDUL AND ARCHIE
                # try:
                #    print("Connected to database 2 successfully")
                #
                #    # SELECT query for appropriate fields and used WHERE clause to compare the values
                #    query = ("INSERT INTO `AdminLog` VALUES (%s, %s, %s, %s)")
                #    VALUES = (None, session["AdminID"], session["loginTime"], None)
                #    # Execute query
                #    cur.execute(query, VALUES)
                #    msg = "Successfully inserted details into database"      # Print this message if details are found
                #    conn.commit()
                #    userLoginTracker()
                # except mysql.connector.Error as e:
                #    # Error message if SELECT operation failed to fetch from database
                #    msg = "Failed to insert into database"
                #    print(msg,"\nError:", e)
                # finally:
                #    # conn.close()
                #    # cur.close()
                #    print(msg)

                flash(f"Successfully logged in as: {username}")
                return redirect("/")

            # Otherwise, print an error message
            else:
                msg = "Sorry, could not find your Administration details"
                flash(msg)
                return redirect("/Login")

            # Close the connection and return the messages
            conn.close()
            cur.close()
            print(msg)
            return msg

# Abdul and Archie Peer Programming
@app.route("/CovidData", methods = ['GET', 'POST'])
def loadCovidFigures():
    if request.method == 'GET':
        print(date_yesterday)
        areaNames = []          # Store the area names collected from covid API
        l = []          # To store all the coordinates
        ltla_areas = [
        'areaType=ltla',
        f'date={date_yesterday}' #Yesterday used to insure we're not calling for data that doesnt yet exist
        # 'date=2021-04-03'
        ]

        cases_and_deaths = {
            "Date": "date",
            "AreaName": "areaName",
            "AreaType": "areaType",
            "NewCasesByPublishDate": "newCasesByPublishDate",
            "NewDeathsByDeathDate": "newDeathsByDeathDate"
            }
        # The api call

        api = Cov19API(filters=ltla_areas, structure=cases_and_deaths)
        # jsonifying the call
        response = api.get_json()
        responseInfo = response['data']
        print("Response" , response)
        print("Response Info" , responseInfo)
        print(f"Data last updated:{response['lastUpdate']}")

        msg = "" #Declaring message for later flash message
        i = 0
        while i < len(responseInfo):
            print(responseInfo[i])
            apiDate = responseInfo[i]['Date']
            apiAreaName = responseInfo[i]['AreaName']
            apiAreaType = responseInfo[i]['AreaType']
            NewCasesByPublishDate = responseInfo[i]['NewCasesByPublishDate']
            NewDeathsByDeathDate = responseInfo[i]['NewDeathsByDeathDate']
            # Replace spaces with underscores. This is so second API call understands the areas
            apiAreaName = apiAreaName.replace(" ","_")

            # Second API call to get Lat and Long from area names
            try:
                res = loadJsonRes(f'https://api.mapbox.com/geocoding/v5/mapbox.places/{apiAreaName}.json?access_token={API_KEY}')
                temp = []           # Create temp list
                for j in res['features']:
                    x = j['geometry']['coordinates']            # Get the coordinates from JSON file
                    temp.append(x)
                coord = temp.pop(0)         # Get the correct coordinates
                if ((coord[0]>=-5 and coord[0]<=-2.5) and (coord[-1]>=51 and coord[-1]<=55)):           # Condition: Only get the coordinates for cities in Wales
                    l.append(coord[-1])
                    l.append(coord[0])
                else:
                    this = responseInfo[i]['AreaName']
                    print(this,"is not in a valid range")
                    responseInfo.remove(this)
            except:
                print("Cannot get response for that address")
            i += 1
            if len(l)>0:
                l1 = l.pop(0)
                l2 = l.pop(0)
                lat = "%.6f" % l1       # Truncates to 6 decimal points
                long = "%.6f" % l2

                try:
                    conn = mysql.connector.connect(**config)
                    cur = conn.cursor()
                    print("Connected to database")
                    cur.execute("SELECT * FROM covidCaseFigures")
                    anyData = cur.fetchall()

                    # Created if statement that checks if there are any existing data in database table.
                    if (len(anyData)>=46):
                        print("Updating Existing dataset...")           # If there is data in database then update instead of insert
                        updateQuery = ("UPDATE covidCaseFigures "
                                " SET date=%s, areaName=%s, areaType=%s, newCasesOnGivenDay=%s, reportedDeathsOnGivenDay=%s, latitude=%s, longitude=%s"
                                " WHERE areaName = %s")

                        updateVal = (apiDate, apiAreaName, apiAreaType, NewCasesByPublishDate, NewDeathsByDeathDate, lat, long, apiAreaName)
                        cur.execute(updateQuery, updateVal)
                        msg = "Successfully Updated Data Set!"
                        conn.commit()
                        cur.close()
                    # Otherwise insert new data
                    else:
                        print("Inserting new data...")
                        insertQuery = ("INSERT INTO covidCaseFigures "
                                " (date, areaName, areaType, newCasesOnGivenDay, reportedDeathsOnGivenDay, latitude, longitude) "
                                " VALUES (%s,%s,%s,%s,%s,%s,%s)")
                        insertVal = (apiDate, apiAreaName, apiAreaType, NewCasesByPublishDate, NewDeathsByDeathDate, lat, long)
                        cur.execute(insertQuery, insertVal)
                        msg = "Successfully Inserted New Data Set!"
                        conn.commit()
                        cur.close()
                except mysql.connector.Error as e:
                    conn.rollback()
                    msg = "Error in UPDATE/INSERT operation"
                    print("Ran into an error: ", e)
                finally:
                    conn.close()
                    cur.close()
                    print(msg)
                    print("End of update/insertion")
        # Display success message on main page, once update/insert operation is complete
        flash(msg)
        return redirect("/")

@app.route("/tenantsVaccinated", methods = ['GET', 'POST'])
@login_required
def loadVaccinatedGraph():
    # usertype = 'null'
    # if 'usertype' in session:
    #     usertype = escape(session['usertype'])
    # if usertype == 'Admin' or usertype == 'Staff':
    if request.method == "GET":
        vaccinated = call_numberOfVaccinatedTenants()
        nonVaccinated = call_numberOfNonVaccinatedTenants()
        return render_template("tenantsVaccinatedBarGraph.html", vaccinated=vaccinated, nonVaccinated=nonVaccinated)
    # else:
    #     flash("Please Login first to access the site!")
    #     return redirect("/Login")

@app.route("/tenantsInfected", methods = ['GET', 'POST'])
@login_required
def loadTenantsInfectedGraph():
    # usertype = 'null'
    # if 'usertype' in session:
    #     usertype = escape(session['usertype'])
    # if usertype == 'Admin' or usertype == 'Staff':
    if request.method == "GET":
        tenantsInfected = call_numberOfInfectedTenants()
        tenantsNotInfected = call_numberOfNonInfectedTenants()
        return render_template('tenantsCovidCasesGraph.html', tenantsInfected=tenantsInfected, tenantsNotInfected=tenantsNotInfected)
    # else:
    #     flash("Please Login first to access the site!")
    #     return redirect("/Login")

@app.route("/pieChart/Vaccines", methods = ["GET", "POST"])
@login_required
def loadVaccinePieChart():
    if request.method == "GET":
        pfizer = call_pfizer()
        moderna = call_moderna()
        astrazeneca = call_astrazeneca()
        return render_template("popularVaccinesPieChart.html", pfizer = pfizer, moderna = moderna, astrazeneca = astrazeneca)

###=======UNFINISHED=====================
def userLoginTracker():
   if "AdminID" in session:
        ###Sleep function found https://www.programiz.com/python-programming/time/sleep
        #time.sleep(60) #Commented out to save time while testing
        #NEED TO MAKE THIS RUN IN THE BACKGROUND
        session["logoutTime"] = datetime.datetime.now() #Must remove seconds from value
        # session["logoutTime"] = '2021-03-22 19:26:36' #For testing
        #update the database value for current session log out time
        try:
            conn = mysql.connector.connect(**config)
            cur = conn.cursor()
            print("Connected to update database")
            #Error Occuring Here =============================
            # query1 = ("UPDATE `AdminLog` SET TimeLoggedOff=%s "
            #         "WHERE `SessionID` > ANY "
            #         "(SELECT `SessionID` FROM `AdminLog` WHERE AdminID=%s)")

            updateQuery = ("UPDATE adminLog SET TimeLoggedOff=%s"
                            "WHERE sessionID IN "
                            "(SELECT MAX(sessionID) FROM adminLog WHERE adminID=%s)")
            print("Phase 1 Complete")
            value = (session["logoutTime"], session['adminID'])
            print("Phase 2 Complete")
            print(f"Session Logout Time is {session['logoutTime']}")
            ##ERROR RAISED HERE
            cur.execute(updateQuery, value)
            print("Phase 3 Complete")
            conn.commit()
            #==================================================
            print("Updated logout time successfully")
        except mysql.connector.Error as e:
            print("Error in UPDATE operation")
            print(e)
        finally:
            conn.close()
            cur.close()
   return None


## Peer-Programming with Abdul and Archie
# Function that reads the API URL
def loadJsonRes(url):
    return json.loads(req.urlopen(url).read())

@app.route("/readCSV", methods = ['GET', 'POST'])
def uploadCSVFile():
    if request.method == 'GET':
        AssetList_file = "asset-files/AssetList.csv"        # Route to CSV file

        with open(AssetList_file) as csv_file:          # Open CSV flle
            csv_reader = csv.reader(csv_file)
            line_count = 0          # Create a counter

            for row in csv_reader:          # Loop through the rows in CSV file
                if line_count == 0:     # Prints column names
                    print(f"Column names are {row}")
                    line_count += 1         # Increment counter
                elif line_count == 1264:            # Break out of loop when reaches end of CSV file
                    break
                else:
                    # Output the values that are going to be inserted
                    print(f'\npostcode: {row[0].strip()}, localAuthority: {row[1].strip()}, businessArea: {row[2].strip()}.')
                    # Connect to database
                    try:
                        conn = mysql.connector.connect(**config)
                        cur = conn.cursor()
                        print("Connected to database successfully")

                        # Retreive postcode and make sure there are no spaces
                        postcode = row[0].strip()
                        postcode = postcode.replace(" ","")
                        print(postcode)

                        # Get the Lat and Long from postcode using API
                        try:
                            res = loadJsonRes(f'https://api.postcodes.io/postcodes/{postcode}')
                            long = res['result']['longitude']
                            lat = res['result']['latitude']
                        except:
                            print("Invalid postcode")

                        # INSERT query to insert all the values
                        query = ("INSERT INTO locations "
                                "(locationID, postcode, latitude, longitude, localAuthority, businessArea) "
                                "VALUES(%s,%s,%s,%s,%s,%s)")

                        # All the values
                        values = (None, postcode, lat, long, row[1].strip(), row[2].strip())
                        cur.execute(query, values)
                        print(f"Successfully inserted data")
                        conn.commit()
                    except mysql.connector.Error as e:
                        conn.rollback()
                        print("Ran into an error: ", e)
                    finally:
                        conn.close()
                        cur.close()
                        print("End of insertion")
                line_count += 1         # Increment counter

        print(f'Processed {line_count} lines.')
        msg = f"Successfully inserted {line_count} rows of data"
        flash(msg)
        return redirect("/")

## Peer-Programming with Abdul and Archie
# Route to display all properties in map
@app.route("/mapOfProperties", methods = ['GET', 'POST'])
@login_required
def displayProperties():
    # usertype = 'null'
    # if 'usertype' in session:
    #     usertype = escape(session['usertype'])
    # if usertype == 'Admin' or usertype == 'Staff':
    if request.method == 'GET':
        allData = []
        try:
            conn = mysql.connector.connect(**config)
            cur = conn.cursor()
            print("Connected to database successfully")
            query = ("SELECT * FROM locations")
            cur.execute(query)
            allData = cur.fetchall()
            print("Received all data")
        except mysql.connector.Error as e:
            conn.rollback()
            print("Ran into an error: ", e)
        finally:
            conn.close()
            cur.close()
            print("End of fetch")
            # print(allData)
            return render_template("mapOfProperties.html", data=allData)
    # else:
    #     flash("Please Login first to access the site!")
    #     return redirect("/Login")

@app.route("/infectedHeatmap", methods = ['GET', 'POST'])
@login_required
def infectedMap():
    # usertype = 'null'
    # if 'usertype' in session:
    #     usertype = escape(session['usertype'])
    # if usertype == 'Admin' or usertype == 'Staff':
    if request.method == 'GET':
        allData = []
        try:
            conn = mysql.connector.connect(**config)
            cur = conn.cursor()
            print("Connected to database successfully")
            query = ("SELECT * FROM covidCaseFigures")
            cur.execute(query)
            allData = cur.fetchall()
            print("Received all data")
        except mysql.connector.Error as e:
            conn.rollback()
            print("Ran into an error: ", e)
        finally:
            conn.close()
            cur.close()
            print("End of fetch")
            # print(allData)
            return render_template("infected_heatmap.html", data=allData)
    # else:
    #     flash("Please Login first to access the site!")
    #     return redirect("/Login")


@app.route("/propertiesAndCovidHeatMap", methods = ['GET', 'POST'])
@login_required
def infectedandPropertiesMap():
    if request.method == 'GET':
        allCovidData = []
        allPropertiesData = []
        try:
            conn = mysql.connector.connect(**config)
            cur = conn.cursor()
            print("Connected to database successfully")
            query = ("SELECT * FROM covidCaseFigures")
            cur.execute(query)
            allCovidData = cur.fetchall()
            query = ("SELECT * FROM locations")
            cur.execute(query)
            allPropertiesData = cur.fetchall()
            print("Received all data")
        except mysql.connector.Error as e:
            conn.rollback()
            print("Ran into an error: ", e)
        finally:
            conn.close()
            cur.close()
            print("End of fetch")
            return render_template("mapOfPropertiesAndCovid.html", covidData=allCovidData, propertiesData=allPropertiesData)

# Postponed User Story #31
# @app.route("/vaccinationsHeatmap", methods = ['GET', 'POST'])
# def vaccinesMap():
#     return render_template("vaccinationsHeatmap.html")

##Function to call number of vaccinated tennants
##Returns number of vaccinated tennants as an integer
def call_numberOfVaccinatedTenants():
    try:
        conn = mysql.connector.connect(**config)
        cur = conn.cursor()
        # print("FUNCTION CALLED ") #To test if function calls
        cur.callproc('countNumberOfVaccinatedTenants')
        for result in cur.stored_results():
            res = result.fetchall()
            ##res returns a tuple within a list
            totalNumberOfVaccinatedTenants = int(res[0][0])
            print("Total Number Of Vaccinated Tenants:",totalNumberOfVaccinatedTenants) #Prints returned value to console

    except mysql.connector.Error as e:
        print(e)
    finally:
        conn.close()
        cur.close()
    return totalNumberOfVaccinatedTenants

def call_numberOfNonVaccinatedTenants():
    try:
        conn = mysql.connector.connect(**config)
        cur = conn.cursor()
        # print("FUNCTION CALLED ") #To test if function calls
        cur.callproc('countNumberOfNonVaccinatedTenants')
        for result in cur.stored_results():
            res = result.fetchall()
            ##res returns a tuple within a list
            totalNumberOfNonVaccinatedTenants = int(res[0][0])
            print("Total Number Of Non-vaccinated Tenants:",totalNumberOfNonVaccinatedTenants) #Prints returned value to console

    except mysql.connector.Error as e:
        print(e)
    finally:
        conn.close()
        cur.close()
    return totalNumberOfNonVaccinatedTenants

def call_numberOfInfectedTenants():
    try:
        conn = mysql.connector.connect(**config)
        cur = conn.cursor()
        # print("FUNCTION CALLED ") #To test if function calls
        cur.callproc('tenantsPositiveCases')
        for result in cur.stored_results():
            res = result.fetchall()
            ##res returns a tuple within a list
            totalNumberOfInfectedTenants = int(res[0][0])
            print("Total Number Of Infected Tenants:",totalNumberOfInfectedTenants) #Prints returned value to console

    except mysql.connector.Error as e:
        print(e)
    finally:
        conn.close()
        cur.close()
    return totalNumberOfInfectedTenants

def call_numberOfNonInfectedTenants():
    try:
        conn = mysql.connector.connect(**config)
        cur = conn.cursor()
        # print("FUNCTION CALLED ") #To test if function calls
        cur.callproc('tenantsNegativeCases')
        for result in cur.stored_results():
            res = result.fetchall()
            ##res returns a tuple within a list
            totalNumberOfNonInfectedTenants = int(res[0][0])
            print("Total Number Of Non Infected Tenants:",totalNumberOfNonInfectedTenants) #Prints returned value to console

    except mysql.connector.Error as e:
        print(e)
    finally:
        conn.close()
        cur.close()
    return totalNumberOfNonInfectedTenants

def call_pfizer():
    try:
        conn = mysql.connector.connect(**config)
        cur = conn.cursor()
        # print("FUNCTION CALLED ") #To test if function calls
        cur.execute('SELECT pfizerVaccine()')
        res = cur.fetchall()
        for result in res:
            totalNumberOfPfizer = int(res[0][0])
            print("Total Number Of pfizer:",totalNumberOfPfizer) #Prints returned value to console

    except mysql.connector.Error as e:
        print(e)
    finally:
        conn.close()
        cur.close()
    return totalNumberOfPfizer

def call_moderna():
    try:
        conn = mysql.connector.connect(**config)
        cur = conn.cursor()
        # print("FUNCTION CALLED ") #To test if function calls
        cur.execute('SELECT modernaVaccine()')
        res = cur.fetchall()
        for result in res:
            totalNumberOfModerna = int(res[0][0])
            print("Total Number Of Moderna:",totalNumberOfModerna) #Prints returned value to console

    except mysql.connector.Error as e:
        print(e)
    finally:
        conn.close()
        cur.close()
    return totalNumberOfModerna

def call_astrazeneca():
    try:
        conn = mysql.connector.connect(**config)
        cur = conn.cursor()
        # print("FUNCTION CALLED ") #To test if function calls
        cur.execute('SELECT astrazenecaVaccine()')
        res = cur.fetchall()
        for result in res:
            totalNumberOfAstrazeneca = int(res[0][0])
            print("Total Number Of Astrazeneca:",totalNumberOfAstrazeneca) #Prints returned value to console

    except mysql.connector.Error as e:
        print(e)
    finally:
        conn.close()
        cur.close()
    return totalNumberOfAstrazeneca


if __name__ == "__main__":
    app.run(debug=True)
    app.run(host='0.0.0.0', port = 5000)
