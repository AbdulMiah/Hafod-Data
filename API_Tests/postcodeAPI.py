## Peer-Programming with Abdul and Archie
import urllib.request as req
import json

postcode = ['cf117jd','cf35 6rh','cf31 4fa','cf31 1hx']
# postcode = postcode.replace(" ","")
print(postcode)
def loadJsonRes(url):
    return json.loads(req.urlopen(url).read())

try:
    for i in postcode:
        i = i.replace(" ","")
        print(i)
        res = loadJsonRes(f'https://api.postcodes.io/postcodes/{i}')
        print(res['result']['longitude'])
        print(res['result']['latitude'])
except:
    print("Sorry! Invalid Postcode\nTry again?")
    # pass
