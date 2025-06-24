import 'package:flutter/material.dart';
import '../models/team.dart';
import '../services/favorites_service.dart';
import 'team_details.dart';

class FavoriteTeamsPage extends StatefulWidget {
  const FavoriteTeamsPage({super.key});

  @override
  State<FavoriteTeamsPage> createState() => _FavoriteTeamsPageState();
}

class _FavoriteTeamsPageState extends State<FavoriteTeamsPage> {
  List<TeamModel> _favoriteTeams = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadFavoriteTeams();
  }

  Future<void> _loadFavoriteTeams() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final teams = await FavoritesService.getFavoriteTeams();
      setState(() {
        _favoriteTeams = teams;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error loading favorite teams: $e')),
      );
    }
  }

  Future<void> _removeFavoriteTeam(TeamModel team) async {
    await FavoritesService.removeFavoriteTeam(team.id);
    await _loadFavoriteTeams();
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${team.name} removed from favorites'),
        backgroundColor: Colors.red,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Favorite Teams'),
        backgroundColor: Colors.green[800],
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadFavoriteTeams,
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.green[800]!, Colors.green[600]!, Colors.green[400]!],
          ),
        ),
        child: _isLoading
            ? const Center(
                child: CircularProgressIndicator(color: Colors.white),
              )
            : _favoriteTeams.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.favorite_border,
                          size: 80,
                          color: Colors.white.withOpacity(0.7),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'No favorite teams yet',
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.white.withOpacity(0.9),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Add teams to your favorites to see them here',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.white.withOpacity(0.7),
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: _favoriteTeams.length,
                    itemBuilder: (context, index) {
                      final team = _favoriteTeams[index];
                      return Container(
                        margin: const EdgeInsets.only(bottom: 12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 10,
                              offset: const Offset(0, 5),
                            ),
                          ],
                        ),
                        child: ListTile(
                          contentPadding: const EdgeInsets.all(16),
                          leading: Container(
                            width: 60,
                            height: 60,
                            decoration: BoxDecoration(
                              color: _parseColor(team.teamColors.primary),
                              borderRadius: BorderRadius.circular(30),
                              border: Border.all(
                                color: _parseColor(team.teamColors.secondary),
                                width: 2,
                              ),
                            ),
                            child: Icon(
                              Icons.sports_soccer,
                              color: _parseColor(team.teamColors.text),
                              size: 30,
                            ),
                          ),
                          title: Text(
                            team.name,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 4),
                              Text(
                                team.nameCode,
                                style: TextStyle(
                                  color: Colors.grey[600],
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                '${team.sport.name} • ${team.country?.name ?? 'N/A'}',
                                style: TextStyle(
                                  color: Colors.grey[500],
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                          trailing: PopupMenuButton<String>(
                            onSelected: (value) {
                              if (value == 'remove') {
                                _removeFavoriteTeam(team);
                              }
                            },
                            itemBuilder: (context) => [
                              const PopupMenuItem(
                                value: 'remove',
                                child: Row(
                                  children: [
                                    Icon(Icons.delete, color: Colors.red),
                                    SizedBox(width: 8),
                                    Text('Remove from favorites'),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => TeamDetailsPage(team: team),
                              ),
                            ).then((_) => _loadFavoriteTeams());
                          },
                        ),
                      );
                    },
                  ),
      ),
    );
  }

  Color _parseColor(String hexColor) {
    try {
      hexColor = hexColor.replaceAll('#', '');
      if (hexColor.length == 6) {
        hexColor = 'FF$hexColor';
      }
      return Color(int.parse(hexColor, radix: 16));
    } catch (e) {
      return Colors.grey;
    }
  }
} 