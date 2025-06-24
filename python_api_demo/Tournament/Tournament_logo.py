import requests

url = "https://sofascore.p.rapidapi.com/tournaments/get-logo"

querystring = {"tournamentId":"17"}

headers = {
	"x-rapidapi-key": "841a931021mshb8e199294a1a42cp15c4bbjsn9ed0c52ef22e",
	"x-rapidapi-host": "sofascore.p.rapidapi.com"
}

response = requests.get(url, headers=headers, params=querystring)

print(response.json())

"""
Output:

"""