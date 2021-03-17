# This script is using Python3
import urllib.request
import urllib.parse

pageURL = "https://api.nhs.uk/conditions/coronavirus-covid-19?url=127.0.0.1:3000/&modules=false"

request_headers = {
"Accept": "application/json",
"User-Agent": "Mozilla/5.0 (Windows NT 6.1; Win64; x64; rv:47.0) Gecko/20100101 Firefox/47.0"
}

request = urllib.request.Request(pageURL, headers=request_headers)
contents = urllib.request.urlopen(request).read()

#for i in contents:
#    print(i)

#print(contents)
