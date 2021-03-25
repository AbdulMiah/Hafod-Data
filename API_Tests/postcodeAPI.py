## Peer-Programming with Abdul and Archie
import urllib.request as req
import json

postcode = 'cf11 7jd'
postcode = postcode.replace(" ","")
print(postcode)
def loadJsonRes(url):
    return json.loads(req.urlopen(url).read())

res = loadJsonRes(f'https://api.postcodes.io/postcodes/{postcode}')
print(res['result']['longitude'])
print(res['result']['latitude'])
