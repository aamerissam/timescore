import 'player.dart';

class TeamModel {
  final int id;
  final String name;
  final String nameCode;
  final String slug;
  final bool national;
  final Sport sport;
  final int userCount;
  final TeamColors teamColors;
  final int? type;
  final String? gender;
  final Country? country;
  final double? latitude;  // Stadium latitude
  final double? longitude; // Stadium longitude

  TeamModel({
    required this.id,
    required this.name,
    required this.nameCode,
    required this.slug,
    required this.national,
    required this.sport,
    required this.userCount,
    required this.teamColors,
    this.type,
    this.gender,
    this.country,
    this.latitude,
    this.longitude,
  });

  factory TeamModel.fromJson(Map<String, dynamic> json) {
    // Try to extract stadium coordinates from various possible locations in the JSON
    double? latitude;
    double? longitude;
    
    print('  Parsing team: \\${json['name']}');
    print('  JSON keys: \\${json.keys.toList()}');
    
    // Check for stadium coordinates in different possible locations
    if (json['stadium'] != null && json['stadium'] is Map<String, dynamic>) {
      final stadium = json['stadium'] as Map<String, dynamic>;
      print('  Found stadium object: \\${stadium.keys.toList()}');
      latitude = stadium['latitude']?.toDouble();
      longitude = stadium['longitude']?.toDouble();
      print('  Stadium coords: lat=$latitude, lng=$longitude');
    } else if (json['venue'] != null && json['venue'] is Map<String, dynamic>) {
      final venue = json['venue'] as Map<String, dynamic>;
      print('  Found venue object: \\${venue.keys.toList()}');
      
      // Check venueCoordinates first
      if (venue['venueCoordinates'] != null && venue['venueCoordinates'] is Map<String, dynamic>) {
        final coords = venue['venueCoordinates'] as Map<String, dynamic>;
        print('  Found venueCoordinates: \\${coords.keys.toList()}');
        latitude = coords['latitude']?.toDouble();
        longitude = coords['longitude']?.toDouble();
        print('  VenueCoordinates: lat=$latitude, lng=$longitude');
      }
      
      // If no coordinates, check for city info
      if (latitude == null && longitude == null && venue['city'] != null) {
        final city = venue['city'] as Map<String, dynamic>;
        print('  Found city object: \\${city.keys.toList()}');
        latitude = city['latitude']?.toDouble();
        longitude = city['longitude']?.toDouble();
        print('  City coords: lat=$latitude, lng=$longitude');
      }
      
      print('  Venue coords: lat=$latitude, lng=$longitude');
    } else if (json['latitude'] != null && json['longitude'] != null) {
      // Direct coordinates on the team object
      latitude = json['latitude']?.toDouble();
      longitude = json['longitude']?.toDouble();
      print('  Direct coords: lat=$latitude, lng=$longitude');
    } else {
      // Check for nested structures
      if (json['location'] != null && json['location'] is Map<String, dynamic>) {
        final location = json['location'] as Map<String, dynamic>;
        print('  Found location object: \\${location.keys.toList()}');
        latitude = location['latitude']?.toDouble();
        longitude = location['longitude']?.toDouble();
        print('  Location coords: lat=$latitude, lng=$longitude');
      } else if (json['address'] != null && json['address'] is Map<String, dynamic>) {
        final address = json['address'] as Map<String, dynamic>;
        print('  Found address object: \\${address.keys.toList()}');
        latitude = address['latitude']?.toDouble();
        longitude = address['longitude']?.toDouble();
        print('  Address coords: lat=$latitude, lng=$longitude');
      }
    }
    
    print('  Final coordinates for team \\${json['name']}: lat=$latitude, lng=$longitude');
    
    return TeamModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      nameCode: json['nameCode'] ?? '',
      slug: json['slug'] ?? '',
      national: json['national'] ?? false,
      sport: Sport.fromJson(json['sport']),
      userCount: json['userCount'] ?? 0,
      teamColors: TeamColors.fromJson(json['teamColors']),
      type: json['type'],
      gender: json['gender'],
      country: json['country'] != null ? Country.fromJson(json['country']) : null,
      latitude: latitude,
      longitude: longitude,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'nameCode': nameCode,
      'slug': slug,
      'national': national,
      'sport': sport.toJson(),
      'userCount': userCount,
      'teamColors': teamColors.toJson(),
      'type': type,
      'gender': gender,
      'country': country?.toJson(),
      'latitude': latitude,
      'longitude': longitude,
    };
  }
}

class TournamentTopTeam {
  final TeamModel team;
  final TeamStatistics statistics;

  TournamentTopTeam({
    required this.team,
    required this.statistics,
  });

  factory TournamentTopTeam.fromJson(Map<String, dynamic> json) {
    return TournamentTopTeam(
      team: TeamModel.fromJson(json['team']),
      statistics: TeamStatistics.fromJson(json['statistics']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'team': team.toJson(),
      'statistics': statistics.toJson(),
    };
  }
}

class TeamStatistics {
  final double avgRating;
  final int id;
  final int matches;
  final int awardedMatches;

  TeamStatistics({
    required this.avgRating,
    required this.id,
    required this.matches,
    required this.awardedMatches,
  });

  factory TeamStatistics.fromJson(Map<String, dynamic> json) {
    return TeamStatistics(
      avgRating: (json['avgRating'] ?? 0.0).toDouble(),
      id: json['id'] ?? 0,
      matches: json['matches'] ?? 0,
      awardedMatches: json['awardedMatches'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'avgRating': avgRating,
      'id': id,
      'matches': matches,
      'awardedMatches': awardedMatches,
    };
  }
}

class Tournament {
  final int id;
  final String name;
  final String slug;
  final int userCount;
  final Category category;
  final bool displayInverseHomeAwayTeams;

  Tournament({
    required this.id,
    required this.name,
    required this.slug,
    required this.userCount,
    required this.category,
    required this.displayInverseHomeAwayTeams,
  });

  factory Tournament.fromJson(Map<String, dynamic> json) {
    return Tournament(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      slug: json['slug'] ?? '',
      userCount: json['userCount'] ?? 0,
      category: json['category'] != null && json['category'] is Map<String, dynamic>
          ? Category.fromJson(json['category'])
          : Category.empty(),
      displayInverseHomeAwayTeams: json['displayInverseHomeAwayTeams'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'slug': slug,
      'userCount': userCount,
      'category': category.toJson(),
      'displayInverseHomeAwayTeams': displayInverseHomeAwayTeams,
    };
  }
}

class Category {
  final int id;
  final String name;
  final String slug;
  final String alpha2;
  final String flag;
  final Sport sport;
  final Country country;

  Category({
    required this.id,
    required this.name,
    required this.slug,
    required this.alpha2,
    required this.flag,
    required this.sport,
    required this.country,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      slug: json['slug'] ?? '',
      alpha2: json['alpha2'] ?? '',
      flag: json['flag'] ?? '',
      sport: json['sport'] != null && json['sport'] is Map<String, dynamic>
          ? Sport.fromJson(json['sport'])
          : Sport.empty(),
      country: json['country'] != null && json['country'] is Map<String, dynamic>
          ? Country.fromJson(json['country'])
          : Country.empty(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'slug': slug,
      'alpha2': alpha2,
      'flag': flag,
      'sport': sport.toJson(),
      'country': country.toJson(),
    };
  }

  factory Category.empty() {
    return Category(
      id: 0,
      name: '',
      slug: '',
      alpha2: '',
      flag: '',
      sport: Sport.empty(),
      country: Country.empty(),
    );
  }
}

extension on Sport {
  static Sport empty() => Sport(id: 0, name: '', slug: '');
}

extension on Country {
  static Country empty() => Country(alpha2: '', name: '', slug: '');
} 