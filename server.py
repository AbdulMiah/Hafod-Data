from flask import Flask, redirect, request, render_template, url_for, jsonify
from uk_covid19 import Cov19API #Used to call for covid case stats
import sqlite3

# import other libraries here
#===========================
#Importing Database
DATABASE = 'Databases/hafod_database.db'
#===========================
app = Flask(__name__, template_folder='templates', static_url_path='/static', static_folder='static')

@app.route("/", methods = ['GET', 'POST'])
def loadMainPage():
    return render_template('generalLayout.html', title='Hafod')


##Unfinished - Archie xx
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
        conn = sqlite3.connect(DATABASE)
        while i < len(responseInfo):
            print(responseInfo[i])
            Date = responseInfo[i]['Date']
            AreaName = responseInfo[i]['AreaName']
            AreaType = responseInfo[i]['AreaType']
            NewCasesByPublishDate = responseInfo[i]['NewCasesByPublishDate']
            NewDeathsByDeathDate = responseInfo[i]['NewDeathsByDeathDate']
            msg = "Uploading data (Pray for it to work)"
            try:
                conn = sqlite3.connect(DATABASE)
                print("Connected to database")
                ##Error at this stage, data not being commited to SQL database
                cur.execute("INSERT INTO covidcasefigures ('Date', 'AreaName', 'AreaType','NewCasesOnGivenDay', 'ReportedDeathsOnGivenDay')\
                            VALUES (?,?,?,?,?)",(Date, AreaName, AreaType, NewCasesByPublishDate, NewDeathsByDeathDate) )
                print('Succesful insert')
                conn.commit()
                msg =  "Data Set " + i + " has been uploaded as a post"
            except:
                conn.rollback()
                msg = "Data Set " + i + " has expierenced an error, please try again."
            finally:
                conn.close()
                print("End of insertion")
                return msg
                i = i + 1
##End of unfinished


    return render_template('generalLayout.html', title='Hafod')

if __name__ == "__main__":
    app.run(debug=True)
    app.run(host='0.0.0.0', port = 5000)
