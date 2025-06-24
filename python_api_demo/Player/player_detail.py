import requests

url = "https://sofascore.p.rapidapi.com/players/detail"

querystring = {"playerId":"750"}

headers = {
	"x-rapidapi-key": "841a931021mshb8e199294a1a42cp15c4bbjsn9ed0c52ef22e",
	"x-rapidapi-host": "sofascore.p.rapidapi.com"
}

response = requests.get(url, headers=headers, params=querystring)

print(response.json())

"""
Output:
{'player': {'name': 'Cristiano Ronaldo', 'slug': 'cristiano-ronaldo', 'shortName': 'C. Ronaldo', 'team': {'name': 'Al-Nassr', 'slug': 'al-nassr', 'shortName': 'Al-Nassr', 'gender': 'M', 'sport': {'name': 'Football', 'slug': 'football', 'id': 1}, 'tournament': {'name': 'Saudi Pro League', 'slug': 'saudi-pro-league', 'category': {'name': 'Saudi Arabia', 'slug': 'saudi-arabia', 'sport': {'name': 'Football', 'slug': 'football', 'id': 1}, 'id': 310, 'country': {'alpha2': 'SA', 'alpha3': 'SAU', 'name': 'Saudi Arabia', 'slug': 'saudi-arabia'}, 'flag': 'saudi-arabia', 'alpha2': 'SA', 'fieldTranslations': {'nameTranslation': {'ar': 'السعودية', 'hi': 'सऊदी अरब', 'bn': 'সৌদি আরব'}, 'shortNameTranslation': {}}}, 'uniqueTournament': {'name': 'Saudi Pro League', 'slug': 'saudi-pro-league', 'primaryColorHex': '#0d1539', 'secondaryColorHex': '#61ab34', 'category': {'name': 'Saudi Arabia', 'slug': 'saudi-arabia', 'sport': {'name': 'Football', 'slug': 'football', 'id': 1}, 'id': 310, 'country': {'alpha2': 'SA', 'alpha3': 'SAU', 'name': 'Saudi Arabia', 'slug': 'saudi-arabia'}, 'flag': 'saudi-arabia', 'alpha2': 'SA', 'fieldTranslations': {'nameTranslation': {'ar': 'السعودية', 'hi': 'सऊदी अरब', 'bn': 'সৌদি আরব'}, 'shortNameTranslation': {}}}, 'userCount': 163999, 'id': 955, 'country': {}, 'displayInverseHomeAwayTeams': False, 'fieldTranslations': {'nameTranslation': {'ar': 'الدوري السعودي للمحترفين', 'hi': 'सऊदी प्रो लीग', 'bn': 'সৌদি প্রো লীগ'}, 'shortNameTranslation': {}}}, 'priority': 200, 'isLive': False, 'id': 3708, 'fieldTranslations': {'nameTranslation': {'ar': 'الدوري السعودي للمحترفين', 'hi': 'सऊदी प्रो लीग', 'bn': 'সৌদি প্রো লীগ'}, 'shortNameTranslation': {}}}, 'primaryUniqueTournament': {'name': 'Saudi Pro League', 'slug': 'saudi-pro-league', 'primaryColorHex': '#0d1539', 'secondaryColorHex': '#61ab34', 'category': {'name': 'Saudi Arabia', 'slug': 'saudi-arabia', 'sport': {'name': 'Football', 'slug': 'football', 'id': 1}, 'id': 310, 'country': {'alpha2': 'SA', 'alpha3': 'SAU', 'name': 'Saudi Arabia', 'slug': 'saudi-arabia'}, 'flag': 'saudi-arabia', 'alpha2': 'SA', 'fieldTranslations': {'nameTranslation': {'ar': 'السعودية', 'hi': 'सऊदी अरब', 'bn': 'সৌদি আরব'}, 'shortNameTranslation': {}}}, 'userCount': 163999, 'id': 955, 'country': {}, 'displayInverseHomeAwayTeams': False, 'fieldTranslations': {'nameTranslation': {'ar': 'الدوري السعودي للمحترفين', 'hi': 'सऊदी प्रो लीग', 'bn': 'সৌদি প্রো লীগ'}, 'shortNameTranslation': {}}}, 'userCount': 1625855, 'nameCode': 'ALN', 'disabled': False, 'national': False, 'type': 0, 'id': 23400, 'country': {'alpha2': 'SA', 'alpha3': 'SAU', 'name': 'Saudi Arabia', 'slug': 'saudi-arabia'}, 'teamColors': {'primary': '#ffff00', 'secondary': '#ffff00', 'text': '#ffff00'}, 'fieldTranslations': {'nameTranslation': {'ar': 'النصر', 'ru': 'Аль-Наср', 'hi': 'अल-नासर', 'bn': 'আল-নাসর'}, 'shortNameTranslation': {}}}, 'position': 'F', 'jerseyNumber': '7', 'height': 187, 'preferredFoot': 'Right', 'userCount': 1423399, 'deceased': False, 'gender': 'M', 'id': 750, 'country': {'alpha2': 'PT', 'alpha3': 'PRT', 'name': 'Portugal', 'slug': 'portugal'}, 'shirtNumber': 7, 'dateOfBirthTimestamp': 476409600, 'contractUntilTimestamp': 1751241600, 'proposedMarketValue': 12500000, 'proposedMarketValueRaw': {'value': 12500000, 'currency': 'EUR'}, 'fieldTranslations': {'nameTranslation': {}, 'shortNameTranslation': {'ar': 'ك. رونالدو', 'hi': 'सी. रोनाल्डो', 'bn': 'সি. রোনালদো'}}}}

"""