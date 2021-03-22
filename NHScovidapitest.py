#Based off examples gives in https://publichealthengland.github.io/coronavirus-dashboard-api-python-sdk/pages/examples/timestamps.html
from uk_covid19 import Cov19API


#need to identify ltla areas within Wales
ltla_areas = [
  'areaType=ltla',
  'date=2021-03-15'
]

#defines the fields which are displayed
cases_and_deaths = {
    "Date": "date",
    "AreaName": "areaName",
    "AreaType": "areaType",
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

print(f"Data last updated:{response['lastUpdate']}")

#used to display all infomation
i = 0
while i < len(responseInfo):
    print(responseInfo[i]['Date'])
    i = i + 1
