import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/api_service.dart';
import '../models/player.dart';
import '../models/team.dart';
import 'player_details.dart';
import 'team_details.dart';
import 'map.dart';
import 'favorite_teams.dart';
import 'favorite_players.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TextEditingController _searchController = TextEditingController();
  String _selectedSearchType = 'player';
  List<dynamic> _searchResults = [];
  bool _isLoading = false;

  final List<String> _searchTypes = ['player', 'team', 'competition'];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _performSearch() async {
    if (_searchController.text.trim().isEmpty) return;

    setState(() {
      _isLoading = true;
    });

    try {
      List<dynamic> results = [];
      
      switch (_selectedSearchType) {
        case 'player':
          results = await ApiService.searchPlayers(_searchController.text.trim());
          break;
        case 'team':
          results = await ApiService.searchTeams(_searchController.text.trim());
          break;
        case 'competition':
          results = await ApiService.searchTournaments(_searchController.text.trim());
          break;
      }

      setState(() {
        _searchResults = results;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  void _navigateToDetails(dynamic item) {
    if (item is Player) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PlayerDetailsPage(player: item),
        ),
      );
    } else if (item is TeamModel) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => TeamDetailsPage(team: item),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Time Score'),
        backgroundColor: Colors.green[800],
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.green[800]!, Colors.green[600]!, Colors.green[400]!],
          ),
        ),
        child: Column(
          children: [
            // Navigation Buttons
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildNavigationButton(
                    'View Map',
                    Icons.map,
                    () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const MapPage()),
                    ),
                  ),
                  _buildNavigationButton(
                    'Favorite Teams',
                    Icons.favorite,
                    () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const FavoriteTeamsPage()),
                    ),
                  ),
                  _buildNavigationButton(
                    'Favorite Players',
                    Icons.person,
                    () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const FavoritePlayersPage()),
                    ),
                  ),
                ],
              ),
            ),
            
            // Search Section
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 16.0),
              padding: const EdgeInsets.all(16.0),
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
              child: Column(
                children: [
                  // Search Type Dropdown
                  DropdownButtonFormField<String>(
                    value: _selectedSearchType,
                    decoration: const InputDecoration(
                      labelText: 'Search Type',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.category),
                    ),
                    items: _searchTypes.map((type) {
                      return DropdownMenuItem(
                        value: type,
                        child: Text(type.toUpperCase()),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedSearchType = value!;
                      });
                    },
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // Search Input
                  TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      labelText: 'Search ${_selectedSearchType}...',
                      border: const OutlineInputBorder(),
                      prefixIcon: const Icon(Icons.search),
                      suffixIcon: IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _searchController.clear();
                          setState(() {
                            _searchResults.clear();
                          });
                        },
                      ),
                    ),
                    onSubmitted: (_) => _performSearch(),
                  ),
                  
                  const SizedBox(height: 16),
                  
                  // Search Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _performSearch,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green[600],
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: _isLoading
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Text('Search', style: TextStyle(fontSize: 16)),
                    ),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 16),
            
            // Search Results
            Expanded(
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 16.0),
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
                child: _searchResults.isEmpty
                    ? const Center(
                        child: Text(
                          'Search results will appear here',
                          style: TextStyle(fontSize: 16, color: Colors.grey),
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.all(8),
                        itemCount: _searchResults.length,
                        itemBuilder: (context, index) {
                          final item = _searchResults[index];
                          return Card(
                            margin: const EdgeInsets.symmetric(vertical: 4),
                            child: ListTile(
                              leading: CircleAvatar(
                                backgroundColor: Colors.green[100],
                                child: Icon(
                                  item is Player ? Icons.person : Icons.sports_soccer,
                                  color: Colors.green[800],
                                ),
                              ),
                              title: Text(
                                item is Player ? item.name : item.name,
                                style: const TextStyle(fontWeight: FontWeight.bold),
                              ),
                              subtitle: Text(
                                item is Player 
                                    ? '${item.position ?? 'N/A'} • ${item.team?.name ?? 'No Team'}'
                                    : '${item.country?.name ?? 'N/A'} • ${item.sport.name}',
                              ),
                              trailing: const Icon(Icons.arrow_forward_ios),
                              onTap: () => _navigateToDetails(item),
                            ),
                          );
                        },
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavigationButton(String title, IconData icon, VoidCallback onPressed) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 4),
        child: ElevatedButton(
          onPressed: onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.white,
            foregroundColor: Colors.green[800],
            padding: const EdgeInsets.symmetric(vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
          ),
          child: Column(
            children: [
              Icon(icon, size: 24),
              const SizedBox(height: 4),
              Text(
                title,
                style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
} 