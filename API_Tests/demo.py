import requests
import urllib.request as req
import json
import time

API_KEY = 'pk.eyJ1IjoiYWJkdWxtaWFoIiwiYSI6ImNrbXdpN2hwZDBmM3cydXJubXM2eHoyaGQifQ.RI7Qv5cRdy1h-BRgK1NKpA'
def loadJsonRes(url):
    return json.loads(req.urlopen(url).read())

address = ['cardiff', 'Swansea', 'newport', 'wrexham', 'Aberystwyth', 'saint_asaph', 'st_davids', 'edinburgh', 'glasgow', 'dundee','birmingham', 'bristol', 'cambridge', 'oxford', 'nottingham']
l = []
try:
    for a in address:
        print("address",a)
        res = loadJsonRes(f'https://api.mapbox.com/geocoding/v5/mapbox.places/{a}.json?access_token={API_KEY}')
        temp = []
        for i in res['features']:
            x = i['geometry']['coordinates']
            temp.append(x)
            print("x",x)
        coord = temp.pop(0)
        print(coord[-1])
        if ((coord[0]>=-5 and coord[0]<=-2.5) and (coord[-1]>=45 and coord[-1]<=55)):
            l.append(coord[-1])
            l.append(coord[0])
        else:
            print("Not valid range")
        print("final list",l)
        # time.sleep(1)
except:
    print("Cannot get response for that address")
