import requests
import json

routes = []
routesURL = 'http://www.ctabustracker.com/bustime/api/v2/getroutes?key=bYNAHrnsnbcxH7FwqhVdL9jRa&format=json'
directionsURL = 'http://www.ctabustracker.com/bustime/api/v2/getdirections?key=bYNAHrnsnbcxH7FwqhVdL9jRa&format=json&rt='

busLineData = {"lines": []}


def getRoutes():
    linesResponse = requests.get(routesURL)
    linesDecoded = linesResponse.json()['bustime-response']['routes']
    for line in linesDecoded:
        lineData = {}
        name = line['rtnm']
        rt = line['rt']
        directions = []

        directionsResponse = requests.get(directionsURL + rt)
        if (directionsResponse.status_code == 200):
            directionsList = directionsResponse.json(
            )['bustime-response']['directions']
            for direction in directionsList:
                directions.append(direction['dir'])

        lineData['name'] = name
        lineData['rt'] = rt
        lineData['directions'] = directions
        busLineData["lines"].append(lineData)
    return busLineData


data = getRoutes()
data = json.dumps(data)
loaded_data = json.loads(data)

with open('bus_line_data.json', 'w') as fp:
    json.dump(loaded_data, fp, indent=4)
