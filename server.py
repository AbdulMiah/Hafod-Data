from flask import Flask, redirect, request, render_template, url_for, jsonify, flash, make_response, session
from uk_covid19 import Cov19API #Used to call for covid case stats
# In CMD: pipenv install uk-covid19

# import sqlite3
import mysql.connector
import yaml
import datetime
import time
import csv
import urllib.request as req
import json
app = Flask(__name__, template_folder='templates', static_url_path='/static', static_folder='static')

app.secret_key = 'superSecretKey'
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
def loadMainPage():
    return render_template('heatmaps.html', title='Hafod')

# Temp redirect route to the login page - Abdul
@app.route("/Login", methods = ['GET', 'POST'])
def loadLoginPage():
    return render_template("loginPage.html")

# Abdul - Created route to validate the login details
@app.route("/CheckLogin", methods = ['GET', 'POST'])
def checkLoginDetails():
    print("Validating Credentials...")
    # res = ''

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
                print(f"Successfully logged in as: '{username}'")

                #Sets session user to username, used to track admin login
                #
                print("Session started")
                session["AdminID"] = res[0]
                session["loginTime"] = datetime.datetime.now() #Must remove seconds from value
                #userLoginTracker() #Updates the time for when user leaves every minute
                print("User name = " , username)
                print("Login time is " , session["loginTime"])

                ##PAIR PROGRAMMED WITH ABDUL AND ARCHIE
                try:
                   print("Connected to database 2 successfully")

                   # SELECT query for appropriate fields and used WHERE clause to compare the values
                   query = ("INSERT INTO `AdminLog` VALUES (%s, %s, %s, %s)")
                   VALUES = (None, session["AdminID"], session["loginTime"], None)
                   # Execute query
                   cur.execute(query, VALUES)
                   msg = "Successfully inserted details into database"      # Print this message if details are found
                   conn.commit()
                   userLoginTracker()
                except mysql.connector.Error as e:
                   # Error message if SELECT operation failed to fetch from database
                   msg = "Failed to insert into database"
                   print(msg,"\nError:", e)
                finally:
                   # conn.close()
                   # cur.close()
                   print(msg)


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
@app.route("/SendData", methods = ['GET', 'POST'])
def loadCovidFigures():
    if request.method == 'GET':
        ltla_areas = [
        'areaType=ltla',
        'date=2021-03-15'
        ]

        cases_and_deaths = {
            "Date": "date",
            "AreaName": "areaName",
            "AreaType": "areaType",
            "NewCasesByPublishDate": "newCasesByPublishDate",
            "NewDeathsByDeathDate": "newDeathsByDeathDate"
            }
        #the api call
        api = Cov19API(filters=ltla_areas, structure=cases_and_deaths)
        #jsonifying the call
        response = api.get_json()
        responseInfo = response['data']
        print(f"Data last updated:{response['lastUpdate']}")
        i = 0
        while i < len(responseInfo):
            print(responseInfo[i])
            apiDate = responseInfo[i]['Date']
            apiAreaName = responseInfo[i]['AreaName']
            apiAreaType = responseInfo[i]['AreaType']
            NewCasesByPublishDate = responseInfo[i]['NewCasesByPublishDate']
            NewDeathsByDeathDate = responseInfo[i]['NewDeathsByDeathDate']
            i += 1
            try:
                conn = mysql.connector.connect(**config)
                cur = conn.cursor()
                print("Connected to database")

                query = ("INSERT INTO CovidCaseFigures "
                        " (Date, AreaName, AreaType, NewCasesOnGivenDay, ReportedDeathsOnGivenDay) "
                        " VALUES (%s,%s,%s,%s,%s)")
                val = (apiDate, apiAreaName, apiAreaType, NewCasesByPublishDate, NewDeathsByDeathDate)
                # print(val)
                cur.execute(query, val)
                msg =  "Data Set has been uploaded as a post"
                conn.commit()
                cur.close()
            except mysql.connector.Error as e:
                conn.rollback()
                print("Ran into an error: ", e)
            finally:
                conn.close()
                cur.close()
                print(msg)
                print("End of insertion")
        return msg


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

@app.route("/demoMap", methods = ['GET', 'POST'])
def loadMap():
    return render_template("demoMap.html")

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
                                "(locationID, postcode, latitude, longitude, localAuthority, businessArea, streetName) "
                                "VALUES(%s,%s,%s,%s,%s,%s,%s)")

                        # All the values
                        values = (None, postcode, lat, long, row[1].strip(), row[2].strip(), None)
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

        return f"Successfully inserted {line_count} rows of data"
        print(f'Processed {line_count} lines.')

## Peer-Programming with Abdul and Archie
# Route to display all properties in map
@app.route("/mapOfProperties", methods = ['GET', 'POST'])
def displayProperties():
    if request.method == 'GET':
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

# @app.route("/properties", methods = ['GET', 'POST'])
# def properties():
#     if request.method == 'GET':
#         try:
#             conn = mysql.connector.connect(**config)
#             cur = conn.cursor()
#             print("Connected to database successfully")
#             query = ("SELECT * FROM locations")
#             cur.execute(query)
#             allData = cur.fetchall()
#             print("Received all data")
#         except mysql.connector.Error as e:
#             conn.rollback()
#             print("Ran into an error: ", e)
#         finally:
#             conn.close()
#             cur.close()
#             print("End of fetch")
#             # print(allData)
#             return render_template("propertiesMap.html", data=allData)


if __name__ == "__main__":
    app.run(debug=True)
    app.run(host='0.0.0.0', port = 5000)
