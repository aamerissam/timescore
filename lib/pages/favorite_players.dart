import 'package:flutter/material.dart';
import '../models/player.dart';
import '../services/favorites_service.dart';
import 'player_details.dart';

class FavoritePlayersPage extends StatefulWidget {
  const FavoritePlayersPage({super.key});

  @override
  State<FavoritePlayersPage> createState() => _FavoritePlayersPageState();
}

class _FavoritePlayersPageState extends State<FavoritePlayersPage> {
  List<Player> _favoritePlayers = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadFavoritePlayers();
  }

  Future<void> _loadFavoritePlayers() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final players = await FavoritesService.getFavoritePlayers();
      setState(() {
        _favoritePlayers = players;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error loading favorite players: $e')),
      );
    }
  }

  Future<void> _removeFavoritePlayer(Player player) async {
    await FavoritesService.removeFavoritePlayer(player.id);
    await _loadFavoritePlayers();
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('${player.name} removed from favorites'),
        backgroundColor: Colors.red,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Favorite Players'),
        backgroundColor: Colors.green[800],
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadFavoritePlayers,
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
            : _favoritePlayers.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.person_outline,
                          size: 80,
                          color: Colors.white.withOpacity(0.7),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'No favorite players yet',
                          style: TextStyle(
                            fontSize: 20,
                            color: Colors.white.withOpacity(0.9),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Add players to your favorites to see them here',
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
                    itemCount: _favoritePlayers.length,
                    itemBuilder: (context, index) {
                      final player = _favoritePlayers[index];
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
                          leading: CircleAvatar(
                            radius: 30,
                            backgroundColor: Colors.green[100],
                            child: Icon(
                              Icons.person,
                              size: 30,
                              color: Colors.green[800],
                            ),
                          ),
                          title: Text(
                            player.name,
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 4),
                              if (player.shortName != null) ...[
                                Text(
                                  player.shortName!,
                                  style: TextStyle(
                                    color: Colors.grey[600],
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                const SizedBox(height: 2),
                              ],
                              Text(
                                '${player.position ?? 'N/A'} • ${player.team?.name ?? 'No Team'}',
                                style: TextStyle(
                                  color: Colors.grey[500],
                                  fontSize: 12,
                                ),
                              ),
                              if (player.jerseyNumber != null && player.jerseyNumber!.isNotEmpty) ...[
                                const SizedBox(height: 2),
                                Text(
                                  'Jersey: ${player.jerseyNumber}',
                                  style: TextStyle(
                                    color: Colors.grey[500],
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ],
                          ),
                          trailing: PopupMenuButton<String>(
                            onSelected: (value) {
                              if (value == 'remove') {
                                _removeFavoritePlayer(player);
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
                                builder: (context) => PlayerDetailsPage(player: player),
                              ),
                            ).then((_) => _loadFavoritePlayers());
                          },
                        ),
                      );
                    },
                  ),
      ),
    );
  }
} 