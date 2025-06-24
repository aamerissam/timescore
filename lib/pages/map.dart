import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_map/flutter_map.dart' as osm;
import 'package:latlong2/latlong.dart' as latlng;
import '../services/api_service.dart';
import '../models/team.dart';
import '../models/player.dart';

class MapPage extends StatefulWidget {
  const MapPage({super.key});

  @override
  State<MapPage> createState() => _MapPageState();
}

const List<Map<String, dynamic>> topLeagues = [
  {"id": 17, "name": "Premier League", "country": "England"},
  {"id": 8, "name": "LaLiga", "country": "Spain"},
  {"id": 23, "name": "Serie A", "country": "Italy"},
  {"id": 35, "name": "Bundesliga", "country": "Germany"},
  {"id": 34, "name": "Ligue 1", "country": "France"},
  {"id": 155, "name": "Liga Profesional de Fútbol", "country": "Argentina"},
  {"id": 11539, "name": "Primera A, Apertura", "country": "Colombia"},
  {"id": 937, "name": "Botola Pro", "country": "Morocco"},
  {"id": 825, "name": "Stars League", "country": "Qatar"},
  {"id": 196, "name": "J1 League", "country": "Japan"},
  {"id": 410, "name": "K League 1", "country": "South Korea"},
  {"id": 11621, "name": "Liga MX, Apertura", "country": "Mexico"},
];

class _MapPageState extends State<MapPage> {
  Position? _currentPosition;
  bool _isLoading = true;
  List<TournamentTopTeamWithTournament> _topTeams = [];
  List<Tournament> _tournaments = [];
  Map<int, Color> _tournamentColors = {};
  
  // Add map controller for zoom controls
  final osm.MapController _mapController = osm.MapController();

  // Predefined colors for tournaments
  final List<Color> _colors = [
    Colors.red,
    Colors.blue,
    Colors.green,
    Colors.orange,
    Colors.purple,
    Colors.teal,
    Colors.indigo,
    Colors.pink,
    Colors.amber,
    Colors.cyan,
  ];

  @override
  void initState() {
    super.initState();
    _initializeLocation();
  }

  Future<void> _initializeLocation() async {
    await _requestLocationPermission();
    await _getCurrentLocation();
    await _loadTournamentTopTeams();
    setState(() {
      _isLoading = false;
    });
  }

  Future<void> _requestLocationPermission() async {
    final status = await Permission.location.request();
    if (status != PermissionStatus.granted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Location permission is required to show your position on the map'),
          backgroundColor: Colors.orange,
        ),
      );
    }
  }

  Future<void> _getCurrentLocation() async {
    try {
      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      setState(() {
        _currentPosition = position;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error getting location: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<void> _loadTournamentTopTeams() async {
    try {
      print('Starting to load top teams for top leagues...');
      // Use the hardcoded top leagues
      final tournaments = topLeagues.map((league) => Tournament(
        id: league['id'],
        name: league['name'],
        slug: '',
        userCount: 0,
        category: Category(
          id: 0,
          name: league['country'] ?? '',
          slug: '',
          alpha2: '',
          flag: '',
          sport: Sport.empty(),
          country: Country.empty().copyWith(name: league['country'] ?? ''),
        ),
        displayInverseHomeAwayTeams: false,
      )).toList();
      setState(() {
        _tournaments = tournaments;
      });

      // Assign colors to tournaments
      for (int i = 0; i < tournaments.length; i++) {
        _tournamentColors[tournaments[i].id] = _colors[i % _colors.length];
      }

      // Get top teams for each tournament
      final allTopTeams = <TournamentTopTeamWithTournament>[];
      for (final tournament in tournaments) {
        try {
          print('Fetching season for league: \\${tournament.name} (id: \\${tournament.id})');
          final seasonId = await ApiService.getTournamentCurrentSeasonId(tournament.id);
          print('  Season ID for \\${tournament.name}: \\${seasonId}');
          if (seasonId != null) {
            print('  Fetching top teams for \\${tournament.name}...');
            final topTeams = await ApiService.getTournamentTopTeams(tournament.id, seasonId);
            print('  Got \\${topTeams.length} top teams for \\${tournament.name}');
            
            // Fetch detailed team info with coordinates for each team
            final teamsWithDetails = <TournamentTopTeamWithTournament>[];
            for (final topTeam in topTeams) {
              try {
                print('    Fetching details for team: \\${topTeam.team.name} (id: \\${topTeam.team.id})');
                final detailedTeam = await ApiService.getTeamDetails(topTeam.team.id);
                
                // Create a new TournamentTopTeam with the detailed team info
                final detailedTopTeam = TournamentTopTeam(
                  team: detailedTeam,
                  statistics: topTeam.statistics,
                );
                
                teamsWithDetails.add(TournamentTopTeamWithTournament(
                  topTeam: detailedTopTeam,
                  tournament: tournament,
                ));
                
                print('    Team \\${detailedTeam.name} coordinates: lat=\\${detailedTeam.latitude}, lng=\\${detailedTeam.longitude}');
              } catch (e) {
                print('    Error fetching details for team \\${topTeam.team.name}: $e');
                // Still add the team without coordinates
                teamsWithDetails.add(TournamentTopTeamWithTournament(
                  topTeam: topTeam,
                  tournament: tournament,
                ));
              }
            }
            
            allTopTeams.addAll(teamsWithDetails);
          } else {
            print('  No season ID found for \\${tournament.name}');
          }
        } catch (e) {
          print('  Error loading top teams for league \\${tournament.name}: $e');
        }
      }
      print('Total top teams loaded: \\${allTopTeams.length}');
      setState(() {
        _topTeams = allTopTeams;
      });
    } catch (e) {
      print('Error in _loadTournamentTopTeams: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error loading tournament data: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  // Get coordinates for teams, using real coordinates if available, fallback to defaults
  List<latlng.LatLng> _getTeamCoordinates() {
    final coordinates = <latlng.LatLng>[];
    
    for (final teamWithTournament in _topTeams) {
      final team = teamWithTournament.topTeam.team;
      
      // Use real coordinates if available
      if (team.latitude != null && team.longitude != null) {
        coordinates.add(latlng.LatLng(team.latitude!, team.longitude!));
        print('Using REAL coordinates for \\${team.name}: lat=\\${team.latitude}, lng=\\${team.longitude}');
      } else {
        // Fallback to city-specific coordinates based on team name and country
        final cityCoords = _getCityCoordinates(team.name, team.country?.name ?? 'Unknown');
        coordinates.add(cityCoords);
        print('Using CITY coordinates for \\${team.name} (\\${team.country?.name ?? 'Unknown'}): lat=\\${cityCoords.latitude}, lng=\\${cityCoords.longitude}');
      }
    }
    
    return coordinates;
  }

  // Get default coordinates for a country
  latlng.LatLng _getDefaultCoordinatesForCountry(String country) {
    // Default coordinates for major countries
    switch (country.toLowerCase()) {
      case 'england':
        return latlng.LatLng(51.5074, -0.1278); // London
      case 'spain':
        return latlng.LatLng(40.4168, -3.7038); // Madrid
      case 'italy':
        return latlng.LatLng(41.9028, 12.4964); // Rome
      case 'germany':
        return latlng.LatLng(52.5200, 13.4050); // Berlin
      case 'france':
        return latlng.LatLng(48.8566, 2.3522); // Paris
      case 'argentina':
        return latlng.LatLng(-34.6118, -58.3960); // Buenos Aires
      case 'colombia':
        return latlng.LatLng(4.7110, -74.0721); // Bogota
      case 'morocco':
        return latlng.LatLng(31.7917, -7.0926); // Morocco center
      case 'qatar':
        return latlng.LatLng(25.2854, 51.5310); // Doha
      case 'japan':
        return latlng.LatLng(35.6762, 139.6503); // Tokyo
      case 'south korea':
        return latlng.LatLng(37.5665, 126.9780); // Seoul
      case 'mexico':
        return latlng.LatLng(19.4326, -99.1332); // Mexico City
      default:
        return latlng.LatLng(31.7917, -7.0926); // Default to Morocco
    }
  }

  // Get coordinates for specific football cities
  latlng.LatLng _getCityCoordinates(String teamName, String country) {
    // Major football cities with their coordinates
    final cityCoordinates = {
      // Spain
      'real madrid': latlng.LatLng(40.4168, -3.7038), // Madrid
      'barcelona': latlng.LatLng(41.3851, 2.1734), // Barcelona
      'atletico madrid': latlng.LatLng(40.4168, -3.7038), // Madrid
      'real betis': latlng.LatLng(37.3891, -5.9845), // Seville
      'athletic club': latlng.LatLng(43.2627, -2.9253), // Bilbao
      'celta vigo': latlng.LatLng(42.2406, -8.7207), // Vigo
      'girona fc': latlng.LatLng(41.9794, 2.8214), // Girona
      'osasuna': latlng.LatLng(42.8166, -1.6442), // Pamplona
      'mallorca': latlng.LatLng(39.6213, 2.9834), // Palma
      'rayo vallecano': latlng.LatLng(40.4168, -3.7038), // Madrid
      'real sociedad': latlng.LatLng(43.3223, -1.9839), // San Sebastian
      'espanyol': latlng.LatLng(41.3851, 2.1734), // Barcelona
      'deportivo alaves': latlng.LatLng(42.8467, -2.6727), // Vitoria-Gasteiz
      'sevilla': latlng.LatLng(37.3891, -5.9845), // Seville
      'getafe': latlng.LatLng(40.4168, -3.7038), // Madrid area
      'valencia': latlng.LatLng(39.4699, -0.3763), // Valencia
      'leganes': latlng.LatLng(40.4168, -3.7038), // Madrid area
      'las palmas': latlng.LatLng(28.1235, -15.4366), // Las Palmas
      'real valladolid': latlng.LatLng(41.6523, -4.7286), // Valladolid
      'villarreal': latlng.LatLng(39.9383, -0.1019), // Villarreal
      
      // Germany
      'fc bayern münchen': latlng.LatLng(48.1351, 11.5820), // Munich
      'bayer 04 leverkusen': latlng.LatLng(51.0343, 6.9843), // Leverkusen
      'eintracht frankfurt': latlng.LatLng(50.1109, 8.6821), // Frankfurt
      'borussia dortmund': latlng.LatLng(51.5136, 7.4653), // Dortmund
      '1. fsv mainz 05': latlng.LatLng(49.9929, 8.2473), // Mainz
      'rb leipzig': latlng.LatLng(51.3397, 12.3731), // Leipzig
      'vfb stuttgart': latlng.LatLng(48.7758, 9.1829), // Stuttgart
      'sv werder bremen': latlng.LatLng(53.0793, 8.8017), // Bremen
      'borussia m\'gladbach': latlng.LatLng(51.1805, 6.4428), // Mönchengladbach
      'vfl wolfsburg': latlng.LatLng(52.4226, 10.7865), // Wolfsburg
      'fc augsburg': latlng.LatLng(48.3705, 10.8978), // Augsburg
      'tsg hoffenheim': latlng.LatLng(49.2787, 8.8867), // Hoffenheim
      'sc freiburg': latlng.LatLng(47.9990, 7.8421), // Freiburg
      'fc st. pauli': latlng.LatLng(53.5511, 9.9937), // Hamburg
      '1. fc union berlin': latlng.LatLng(52.5200, 13.4050), // Berlin
      '1. fc heidenheim': latlng.LatLng(48.6782, 10.1513), // Heidenheim
      'vfl bochum 1848': latlng.LatLng(51.4818, 7.2162), // Bochum
      'holstein kiel': latlng.LatLng(54.3233, 10.1228), // Kiel
    };
    
    final teamNameLower = teamName.toLowerCase();
    
    // Try to find exact team name match
    if (cityCoordinates.containsKey(teamNameLower)) {
      print('  Found exact city match for \\${teamName}: \\${cityCoordinates[teamNameLower]}');
      return cityCoordinates[teamNameLower]!;
    }
    
    // Try to find partial matches
    for (final entry in cityCoordinates.entries) {
      if (teamNameLower.contains(entry.key.split(' ').last) || 
          entry.key.contains(teamNameLower.split(' ').last)) {
        print('  Found partial city match for \\${teamName}: \\${entry.value}');
        return entry.value;
      }
    }
    
    // Fallback to country coordinates
    print('  No city match found for \\${teamName}, using country default');
    return _getDefaultCoordinatesForCountry(country);
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        appBar: AppBar(title: const Text('Tournament Top Teams Map')),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    final teamCoordinates = _getTeamCoordinates();

    // Debug: print number of teams and their info
    print('Placing \\${_topTeams.length} team markers on the map:');
    for (int i = 0; i < _topTeams.length; i++) {
      final teamWithTournament = _topTeams[i];
      final coordinate = teamCoordinates[i];
      final team = teamWithTournament.topTeam.team;
      final hasRealCoords = team.latitude != null && team.longitude != null;
      final coordSource = hasRealCoords ? 'REAL' : 'DEFAULT';
      print('Marker: Tournament="\\${teamWithTournament.tournament.name}", Team="\\${team.name}", Lat=\\${coordinate.latitude}, Lng=\\${coordinate.longitude} (\\${coordSource})');
    }

    // Always center on Morocco
    final latlng.LatLng mapCenter = latlng.LatLng(31.7917, -7.0926);
    print('Map center: Always Morocco: 31.7917, -7.0926');

    return Scaffold(
      appBar: AppBar(
        title: const Text('Tournament Top Teams Map'),
        backgroundColor: Colors.green[800],
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              setState(() {
                _isLoading = true;
              });
              _loadTournamentTopTeams().then((_) {
                setState(() {
                  _isLoading = false;
                });
              });
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Legend
          Container(
            padding: const EdgeInsets.all(8),
            color: Colors.grey[100],
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Tournament Colors:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 4),
                Wrap(
                  spacing: 8,
                  children: _tournaments.take(5).map((tournament) {
                    return Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 16,
                          height: 16,
                          decoration: BoxDecoration(
                            color: _tournamentColors[tournament.id],
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          tournament.name,
                          style: const TextStyle(fontSize: 12),
                        ),
                      ],
                    );
                  }).toList(),
                ),
                if (_tournaments.length > 5)
                  Text(
                    '... and ${_tournaments.length - 5} more tournaments',
                    style: const TextStyle(fontSize: 12, fontStyle: FontStyle.italic),
                  ),
              ],
            ),
          ),
          // Map
          Expanded(
            child: Stack(
              children: [
                osm.FlutterMap(
                  mapController: _mapController,
                  options: osm.MapOptions(
                    center: mapCenter,
                    zoom: 8,
                    minZoom: 2,
                    maxZoom: 18,
                  ),
                  children: [
                    osm.TileLayer(
                      urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
                      subdomains: ['a', 'b', 'c'],
                    ),
                    osm.MarkerLayer(
                      markers: [
                        // Team markers
                        ..._topTeams.asMap().entries.map((entry) {
                          final index = entry.key;
                          final teamWithTournament = entry.value;
                          final coordinate = teamCoordinates[index];
                          final tournamentColor = _tournamentColors[teamWithTournament.tournament.id] ?? Colors.grey;
                          
                          return osm.Marker(
                            width: 40,
                            height: 40,
                            point: coordinate,
                            child: GestureDetector(
                              onTap: () {
                                _showTeamInfo(teamWithTournament);
                              },
                              child: Icon(
                                Icons.sports_soccer,
                                color: tournamentColor,
                                size: 36,
                              ),
                            ),
                          );
                        }),
                        // Current location marker
                        if (_currentPosition != null)
                          osm.Marker(
                            width: 40,
                            height: 40,
                            point: latlng.LatLng(_currentPosition!.latitude, _currentPosition!.longitude),
                            child: const Icon(Icons.my_location, color: Colors.blue, size: 36),
                          ),
                      ],
                    ),
                  ],
                ),
                // Zoom controls
                Positioned(
                  right: 16,
                  bottom: 16,
                  child: Column(
                    children: [
                      FloatingActionButton.small(
                        onPressed: () {
                          _mapController.move(_mapController.center, _mapController.zoom + 1);
                        },
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.black87,
                        child: const Icon(Icons.add),
                      ),
                      const SizedBox(height: 8),
                      FloatingActionButton.small(
                        onPressed: () {
                          _mapController.move(_mapController.center, _mapController.zoom - 1);
                        },
                        backgroundColor: Colors.white,
                        foregroundColor: Colors.black87,
                        child: const Icon(Icons.remove),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showTeamInfo(TournamentTopTeamWithTournament teamWithTournament) {
    final topTeam = teamWithTournament.topTeam;
    final tournament = teamWithTournament.tournament;
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(topTeam.team.name),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Tournament: ${tournament.name}'),
            Text('Average Rating: ${topTeam.statistics.avgRating.toStringAsFixed(2)}'),
            Text('Matches Played: ${topTeam.statistics.matches}'),
            Text('Country: ${topTeam.team.country?.name ?? 'N/A'}'),
            if (topTeam.team.teamColors != null) ...[
              const SizedBox(height: 8),
              Text('Team Colors:'),
              Row(
                children: [
                  Container(
                    width: 20,
                    height: 20,
                    decoration: BoxDecoration(
                      color: Color(int.parse('0xFF${topTeam.team.teamColors.primary.substring(1)}')),
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    width: 20,
                    height: 20,
                    decoration: BoxDecoration(
                      color: Color(int.parse('0xFF${topTeam.team.teamColors.secondary.substring(1)}')),
                      shape: BoxShape.circle,
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
}

// Helper class to associate top teams with their tournaments
class TournamentTopTeamWithTournament {
  final TournamentTopTeam topTeam;
  final Tournament tournament;

  TournamentTopTeamWithTournament({
    required this.topTeam,
    required this.tournament,
  });
}