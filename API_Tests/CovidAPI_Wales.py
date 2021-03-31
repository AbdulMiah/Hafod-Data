#Based off examples gives in https://publichealthengland.github.io/coronavirus-dashboard-api-python-sdk/pages/examples/timestamps.html
from uk_covid19 import Cov19API
import urllib.request as req
import json
from datetime import date

today = date.today().strftime("%Y-%m-%d")
API_KEY = 'pk.eyJ1IjoiYWJkdWxtaWFoIiwiYSI6ImNrbXdpN2hwZDBmM3cydXJubXM2eHoyaGQifQ.RI7Qv5cRdy1h-BRgK1NKpA'

def loadJsonRes(url):
    return json.loads(req.urlopen(url).read())

#need to identify ltla areas within Wales
ltla_areas = [
  'areaType=ltla',
  'date=2021-03-30'
  # f'date={today}'
]

#defines the fields which are displayed
cases_and_deaths = {
    "Date": "date",
    "AreaName": "areaName",
    'AreaType': 'areaType',
    "NewCasesByPublishDate": "newCasesByPublishDate",
    "NewDeathsByDeathDate": "newDeathsByDeathDate"
}

#defines which filter is used
filters = ltla_areas

#the api call
api = Cov19API(filters, structure=cases_and_deaths)
#jsonifying the call
response = api.get_json()

#response is a dictionary
#responseInfo is a list of covid cases
responseInfo = response['data']
print(responseInfo)

print(f"Data last updated: {response['lastUpdate']} ")

areaNames = []
l = []
try:
    for i in responseInfo:
        area = i['AreaName']
        area = area.replace(" ","_")
        areaNames.append(area)
except:
    print("Sorry! Invalid Area Name")
print(areaNames)


try:
    for a in areaNames:
        res = loadJsonRes(f'https://api.mapbox.com/geocoding/v5/mapbox.places/{a}.json?access_token={API_KEY}')
        temp = []
        for j in res['features']:
            x = j['geometry']['coordinates']
            temp.append(x)
        coord = temp.pop(0)
        if ((coord[0]>=-5 and coord[0]<=-2.5) and (coord[-1]>=51 and coord[-1]<=55)):
            l.append(coord[-1])
            l.append(coord[0])
        else:
            print(a,"is not in a valid range")
except:
    print("Cannot get response for that address")

print("final list",l)
