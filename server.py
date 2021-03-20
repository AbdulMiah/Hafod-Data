from flask import Flask, redirect, request, render_template, url_for, jsonify
from uk_covid19 import Cov19API #Used to call for covid case stats
# import sqlite3
import mysql.connector
import yaml
app = Flask(__name__, template_folder='templates', static_url_path='/static', static_folder='static')


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


@app.route("/", methods = ['GET', 'POST'])
def loadMainPage():
    return render_template('generalLayout.html', title='Hafod')

@app.route("/Login", methods = ['GET', 'POST'])
def loadLoginPage():
    return redirect("static/loginPage.html")

@app.route("/CheckLogin", methods = ['GET', 'POST'])
def checkLoginDetails():
    print("Validating Credentials...")
    res = ''
    if request.method == 'POST':
        username = request.form.get("username", default="Error")
        email = request.form.get("username", default="Error")
        password = request.form.get("password", default="Error")
        print(f"Checking details for '{username}'")

        try:
            conn = mysql.connector.connect(**config)
            cur = conn.cursor()
            print("Connected to database successfully")

            query = ("SELECT Username, Email, Password FROM AdminCredentials "
                    "WHERE (Username=%s OR Email=%s) AND Password=%s")

            cur.execute(query, [username, email, password])
            res = cur.fetchone()
            msg = "Successfully fetched details from database"
            conn.commit()
        except conn.Error as e:
            msg = "Failed to fetch from database"
            print(msg,"\nError:", e)
        finally:
            if res:
                print(f"Successfully logged in as: '{username}'")
                return redirect("/")
            else:
                msg = "Sorry, could not find your details"
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
            except conn.Error as e:
                conn.rollback()
                print("Ran into an error: ", e)
            finally:
                conn.close()
                cur.close()
                print(msg)
                print("End of insertion")
        return msg



if __name__ == "__main__":
    app.run(debug=True)
    app.run(host='0.0.0.0', port = 5000)
