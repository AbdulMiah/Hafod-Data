from flask import Flask, redirect, request, render_template, url_for, jsonify, flash, make_response, session, escape
# from flask_login import login_required
import os
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

# Abdul - route to main page, where all maps/graphs are displayed
@app.route("/", methods = ['GET', 'POST'])
# @login_required
def loadMainPage():
    tenantsVaccinated = call_numberOfVaccinatedTenants()
    tenantsNonVaccinated = call_numberOfNonVaccinatedTenants()
    tenantsInfected = call_numberOfInfectedTenants()
    tenantsNotInfected = call_numberOfNonInfectedTenants()
    return render_template('mainPage.html', title='Hafod', tenantsVaccinated=tenantsVaccinated, tenantsNonVaccinated=tenantsNonVaccinated, tenantsInfected=tenantsInfected, tenantsNotInfected=tenantsNotInfected)

# Redirect to Edit Page - Archie and Abdul
@app.route("/Edit", methods = ['GET', 'POST'])
def loadEditPage():
    usertype = 'null'
    if 'usertype' in session:
        usertype = escape(session['usertype'])
    if usertype == 'Admin':
        if request.method == 'GET':
            allData = []
            try:
                conn = mysql.connector.connect(**config)
                cur = conn.cursor()
                print("Connected to database successfully")
                # adminViewOfTenantData = ("CREATE VIEW adminViewOfData AS "
                #                         " SELECT t.tenancyNo, t.firstname, t.surname, t.dob, l.postcode, l.localAuthority, l.businessArea, c.positiveCase, v.vaccinated FROM tenants t "
                #                         " JOIN locations l ON t.locationID = l.locationID "
                #                         " JOIN health_linktable h ON t.healthID = h.healthID "
                #                         " JOIN covidTestResult c ON h.testID = c.testID "
                #                         " JOIN vaccinations v ON h.vaccinationID = v.vaccinationID;")
                selectAdminData = ("SELECT * FROM adminViewOfData")
                cur.execute(selectAdminData)
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
                return render_template("editPage.html", data=allData, title='All Tenants')
    else:
        flash('Sorry, only Admins have access to this page')
        return redirect("/")

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
def editData(tenantID): # tenantID=None
    usertype = 'null'
    if 'usertype' in session:
        usertype = escape(session['usertype'])
    if usertype == 'Admin':
        if request.method == 'GET':
            allData = []
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
                # print(allData)
                return render_template("editData.html", data=allData, title='Edit Tenants Data')
    else:
        flash('Sorry, only Admins have access to this page')
        return redirect("/")

# Temp redirect route to the login page - Abdul
@app.route("/Login", methods = ['GET', 'POST'])
def loadLoginPage():
    return render_template("loginPage.html")


@app.route("/Logout")
def logout():
    session.pop('username', None)
    session.pop('password', None)
    flash("You have Successfully Logged Out!")
    return redirect("/Login")

# Abdul - Created route to validate the login details
@app.route("/CheckLogin", methods = ['GET', 'POST'])
def checkLoginDetails():
    print("Validating Credentials...")

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
            query = ("SELECT * FROM AdminCredentials "
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
                    cur.execute("SELECT * FROM CovidCaseFigures")
                    anyData = cur.fetchall()

                    # Created if statement that checks if there are any existing data in database table.
                    if (len(anyData)>=46):
                        print("Updating Existing dataset...")           # If there is data in database then update instead of insert
                        updateQuery = ("UPDATE CovidCaseFigures "
                                " SET Date=%s, AreaName=%s, AreaType=%s, NewCasesOnGivenDay=%s, ReportedDeathsOnGivenDay=%s, latitude=%s, longitude=%s"
                                " WHERE AreaName = %s")

                        updateVal = (apiDate, apiAreaName, apiAreaType, NewCasesByPublishDate, NewDeathsByDeathDate, lat, long, apiAreaName)
                        cur.execute(updateQuery, updateVal)
                        msg = "Successfully Updated Data Set!"
                        conn.commit()
                        cur.close()
                    # Otherwise insert new data
                    else:
                        print("Inserting new data...")
                        insertQuery = ("INSERT INTO CovidCaseFigures "
                                " (Date, AreaName, AreaType, NewCasesOnGivenDay, ReportedDeathsOnGivenDay, latitude, longitude) "
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
def loadVaccinatedGraph():
    if request.method == "GET":
        vaccinated = call_numberOfVaccinatedTenants()
        nonVaccinated = call_numberOfNonVaccinatedTenants()
        return render_template("tenantsVaccinatedBarGraph.html", vaccinated=vaccinated, nonVaccinated=nonVaccinated)

@app.route("/tenantsInfected", methods = ['GET', 'POST'])
def loadTenantsInfectedGraph():
    if request.method == "GET":
        tenantsInfected = call_numberOfInfectedTenants()
        tenantsNotInfected = call_numberOfNonInfectedTenants()
        return render_template('tenantsCovidCasesGraph.html', tenantsInfected=tenantsInfected, tenantsNotInfected=tenantsNotInfected)

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

            updateQuery = ("UPDATE AdminLog SET TimeLoggedOff=%s"
                            "WHERE SessionID IN "
                            "(SELECT MAX(SessionID) FROM AdminLog WHERE AdminID=%s)")
            print("Phase 1 Complete")
            value = (session["logoutTime"], session['AdminID'])
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
def displayProperties():
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

@app.route("/infectedHeatmap", methods = ['GET', 'POST'])
def infectedMap():
    if request.method == 'GET':
        allData = []
        try:
            conn = mysql.connector.connect(**config)
            cur = conn.cursor()
            print("Connected to database successfully")
            query = ("SELECT * FROM CovidCaseFigures")
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

if __name__ == "__main__":
    app.run(debug=True)
    app.run(host='0.0.0.0', port = 5000)
