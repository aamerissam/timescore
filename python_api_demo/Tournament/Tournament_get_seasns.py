import requests

url = "https://sofascore.p.rapidapi.com/tournaments/get-seasons"

querystring = {"tournamentId":"17"}

headers = {
	"x-rapidapi-key": "841a931021mshb8e199294a1a42cp15c4bbjsn9ed0c52ef22e",
	"x-rapidapi-host": "sofascore.p.rapidapi.com"
}

response = requests.get(url, headers=headers, params=querystring)

print(response.json())


"""
"C:\Users\Issam AAMER\PycharmProjects\sandbox\.venv\Scripts\python.exe" "C:\Users\Issam AAMER\PycharmProjects\sandbox\main.py" 
{'seasons': [{'name': 'Premier League 25/26', 'year': '25/26', 'editor': False, 'id': 76986}, {'name': 'Premier League 24/25', 'year': '24/25', 'editor': False, 'id': 61627}, {'name': 'Premier League 23/24', 'year': '23/24', 'editor': False, 'id': 52186}, {'name': 'Premier League 22/23', 'year': '22/23', 'editor': False, 'seasonCoverageInfo': {}, 'id': 41886}, {'name': 'Premier League 21/22', 'year': '21/22', 'editor': False, 'id': 37036}, {'name': 'Premier League 20/21', 'year': '20/21', 'editor': False, 'id': 29415}, {'name': 'Premier League 19/20', 'year': '19/20', 'editor': False, 'id': 23776}, {'name': 'Premier League 18/19', 'year': '18/19', 'editor': False, 'id': 17359}, {'name': 'Premier League 17/18', 'year': '17/18', 'editor': False, 'id': 13380}, {'name': 'Premier League 16/17', 'year': '16/17', 'editor': False, 'id': 11733}, {'name': 'Premier League 15/16', 'year': '15/16', 'editor': False, 'id': 10356}, {'name': 'Premier League 14/15', 'year': '14/15', 'editor': False, 'id': 8186}, {'name': 'Premier League 13/14', 'year': '13/14', 'editor': False, 'id': 6311}, {'name': 'Premier League 12/13', 'year': '12/13', 'editor': False, 'id': 4710}, {'name': 'Premier League 11/12', 'year': '11/12', 'editor': False, 'id': 3391}, {'name': 'Premier League 10/11', 'year': '10/11', 'editor': False, 'id': 2746}, {'name': 'Premier League 09/10', 'year': '09/10', 'editor': False, 'id': 2139}, {'name': 'Premier League 08/09', 'year': '08/09', 'editor': False, 'id': 1544}, {'name': 'Premier League 07/08', 'year': '07/08', 'editor': False, 'id': 581}, {'name': 'Premier League 06/07', 'year': '06/07', 'editor': False, 'id': 4}, {'name': 'Premier League 05/06', 'year': '05/06', 'editor': False, 'id': 3}, {'name': 'Premier League 04/05', 'year': '04/05', 'editor': False, 'id': 2}, {'name': 'Premier League 03/04', 'year': '03/04', 'editor': False, 'id': 1}, {'name': 'Premier League 02/03', 'year': '02/03', 'editor': False, 'id': 46}, {'name': 'Premier League 01/02', 'year': '01/02', 'editor': False, 'id': 47}, {'name': 'Premier League 00/01', 'year': '00/01', 'editor': False, 'id': 48}, {'name': 'Premier League 99/00', 'year': '99/00', 'editor': False, 'id': 49}, {'name': 'Premier League 98/99', 'year': '98/99', 'editor': False, 'id': 50}, {'name': 'Premier League 97/98', 'year': '97/98', 'editor': False, 'id': 51}, {'name': 'Premier League 96/97', 'year': '96/97', 'editor': False, 'id': 25682}, {'name': 'Premier League 95/96', 'year': '95/96', 'editor': False, 'id': 25681}, {'name': 'Premier League 94/95', 'year': '94/95', 'editor': False, 'id': 29167}, {'name': 'Premier League 93/94', 'year': '93/94', 'editor': False, 'id': 25680}]}

Process finished with exit code 0

"""
