class Player {
  final int id;
  final String name;
  final String slug;
  final int userCount;
  final Team? team;
  final bool deceased;
  final Country? country;
  final String? shortName;
  final String? position;
  final String? jerseyNumber;

  Player({
    required this.id,
    required this.name,
    required this.slug,
    required this.userCount,
    this.team,
    required this.deceased,
    this.country,
    this.shortName,
    this.position,
    this.jerseyNumber,
  });

  factory Player.fromJson(Map<String, dynamic> json) {
    return Player(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      slug: json['slug'] ?? '',
      userCount: json['userCount'] ?? 0,
      team: json['team'] != null ? Team.fromJson(json['team']) : null,
      deceased: json['deceased'] ?? false,
      country: json['country'] != null ? Country.fromJson(json['country']) : null,
      shortName: json['shortName'],
      position: json['position'],
      jerseyNumber: json['jerseyNumber'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'slug': slug,
      'userCount': userCount,
      'team': team?.toJson(),
      'deceased': deceased,
      'country': country?.toJson(),
      'shortName': shortName,
      'position': position,
      'jerseyNumber': jerseyNumber,
    };
  }
}

class Team {
  final int id;
  final String name;
  final String nameCode;
  final String slug;
  final bool national;
  final Sport sport;
  final int userCount;
  final TeamColors teamColors;
  final String? gender;
  final Country? country;

  Team({
    required this.id,
    required this.name,
    required this.nameCode,
    required this.slug,
    required this.national,
    required this.sport,
    required this.userCount,
    required this.teamColors,
    this.gender,
    this.country,
  });

  factory Team.fromJson(Map<String, dynamic> json) {
    return Team(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      nameCode: json['nameCode'] ?? '',
      slug: json['slug'] ?? '',
      national: json['national'] ?? false,
      sport: Sport.fromJson(json['sport']),
      userCount: json['userCount'] ?? 0,
      teamColors: TeamColors.fromJson(json['teamColors']),
      gender: json['gender'],
      country: json['country'] != null ? Country.fromJson(json['country']) : null,
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
      'gender': gender,
      'country': country?.toJson(),
    };
  }
}

class Sport {
  final int id;
  final String slug;
  final String name;

  Sport({
    required this.id,
    required this.slug,
    required this.name,
  });

  factory Sport.fromJson(Map<String, dynamic> json) {
    return Sport(
      id: json['id'] ?? 0,
      slug: json['slug'] ?? '',
      name: json['name'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'slug': slug,
      'name': name,
    };
  }

  static Sport empty() => Sport(id: 0, slug: '', name: '');
}

class TeamColors {
  final String primary;
  final String secondary;
  final String text;

  TeamColors({
    required this.primary,
    required this.secondary,
    required this.text,
  });

  factory TeamColors.fromJson(Map<String, dynamic> json) {
    return TeamColors(
      primary: json['primary'] ?? '#000000',
      secondary: json['secondary'] ?? '#000000',
      text: json['text'] ?? '#000000',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'primary': primary,
      'secondary': secondary,
      'text': text,
    };
  }
}

class Country {
  final String alpha2;
  final String name;
  final String slug;

  Country({
    required this.alpha2,
    required this.name,
    required this.slug,
  });

  factory Country.fromJson(Map<String, dynamic> json) {
    return Country(
      alpha2: json['alpha2'] ?? '',
      name: json['name'] ?? '',
      slug: json['slug'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'alpha2': alpha2,
      'name': name,
      'slug': slug,
    };
  }

  static Country empty() => Country(alpha2: '', name: '', slug: '');
} 