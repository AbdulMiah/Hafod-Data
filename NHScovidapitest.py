#Based off examples gives in https://publichealthengland.github.io/coronavirus-dashboard-api-python-sdk/pages/examples/timestamps.html
from uk_covid19 import Cov19API

england_only = [
    'areaType=nation',
    'areaName=Wales'
]

cases_and_deaths = {
    "date": "date",
    "areaName": "areaName",
    "areaRegion": "areaRegion",
    "areaCode": "areaCode",
    "newCasesByPublishDate": "newCasesByPublishDate",
    "cumCasesByPublishDate": "cumCasesByPublishDate",
    "newDeathsByDeathDate": "newDeathsByDeathDate",
    "cumDeathsByDeathDate": "cumDeathsByDeathDate"
}

api = Cov19API(filters=england_only, structure=cases_and_deaths)

data = api.get_json()
print(data)
