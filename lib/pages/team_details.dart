import 'package:flutter/material.dart';
import '../models/team.dart';
import '../services/favorites_service.dart';
import '../services/api_service.dart';
import '../models/player.dart';
import 'player_details.dart';

class TeamDetailsPage extends StatefulWidget {
  final TeamModel team;

  const TeamDetailsPage({super.key, required this.team});

  @override
  State<TeamDetailsPage> createState() => _TeamDetailsPageState();
}

class _TeamDetailsPageState extends State<TeamDetailsPage> {
  bool _isFavorite = false;
  List<Player> _squad = [];
  bool _isLoadingSquad = false;

  @override
  void initState() {
    super.initState();
    _checkFavoriteStatus();
    _loadSquad();
  }

  Future<void> _checkFavoriteStatus() async {
    final isFavorite = await FavoritesService.isFavoriteTeam(widget.team.id);
    setState(() {
      _isFavorite = isFavorite;
    });
  }

  Future<void> _toggleFavorite() async {
    if (_isFavorite) {
      await FavoritesService.removeFavoriteTeam(widget.team.id);
    } else {
      await FavoritesService.addFavoriteTeam(widget.team);
    }
    setState(() {
      _isFavorite = !_isFavorite;
    });
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(_isFavorite ? 'Added to favorites' : 'Removed from favorites'),
        backgroundColor: _isFavorite ? Colors.green : Colors.red,
      ),
    );
  }

  Future<void> _loadSquad() async {
    setState(() {
      _isLoadingSquad = true;
    });

    try {
      final squad = await ApiService.getTeamSquad(widget.team.id);
      setState(() {
        _squad = squad;
        _isLoadingSquad = false;
      });
    } catch (e) {
      setState(() {
        _isLoadingSquad = false;
      });
      // Only show snackbar if not a 404 error
      if (!e.toString().contains('404')) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error loading squad: $e')),
        );
      }
      // For 404, just show 'No squad information available' in the UI
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.team.name),
        backgroundColor: Colors.green[800],
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: Icon(_isFavorite ? Icons.favorite : Icons.favorite_border),
            onPressed: _toggleFavorite,
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
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Team Header Card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16),
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
                    Container(
                      width: 120,
                      height: 120,
                      decoration: BoxDecoration(
                        color: _parseColor(widget.team.teamColors.primary),
                        borderRadius: BorderRadius.circular(60),
                        border: Border.all(
                          color: _parseColor(widget.team.teamColors.secondary),
                          width: 3,
                        ),
                      ),
                      child: Icon(
                        Icons.sports_soccer,
                        size: 60,
                        color: _parseColor(widget.team.teamColors.text),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      widget.team.name,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      widget.team.nameCode,
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.grey[600],
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              
              const SizedBox(height: 16),
              
              // Team Information Cards
              _buildInfoCard(
                'Team Information',
                [
                  _buildInfoRow('Team Code', widget.team.nameCode),
                  _buildInfoRow('National Team', widget.team.national ? 'Yes' : 'No'),
                  _buildInfoRow('Sport', widget.team.sport.name),
                  _buildInfoRow('User Count', '${widget.team.userCount}'),
                  if (widget.team.gender != null)
                    _buildInfoRow('Gender', widget.team.gender!),
                  if (widget.team.type != null)
                    _buildInfoRow('Type', '${widget.team.type}'),
                ],
              ),
              
              const SizedBox(height: 16),
              
              // Country Information
              if (widget.team.country != null)
                _buildInfoCard(
                  'Country Information',
                  [
                    _buildInfoRow('Country', widget.team.country!.name),
                    _buildInfoRow('Country Code', widget.team.country!.alpha2),
                  ],
                ),
              
              const SizedBox(height: 16),
              
              // Team Colors
              _buildInfoCard(
                'Team Colors',
                [
                  _buildColorRow('Primary', widget.team.teamColors.primary),
                  _buildColorRow('Secondary', widget.team.teamColors.secondary),
                  _buildColorRow('Text', widget.team.teamColors.text),
                ],
              ),
              
              const SizedBox(height: 16),
              
              // Squad Section
              _buildInfoCard(
                'Squad (${_squad.length} players)',
                [
                  if (_isLoadingSquad)
                    const Center(
                      child: Padding(
                        padding: EdgeInsets.all(16.0),
                        child: CircularProgressIndicator(),
                      ),
                    )
                  else if (_squad.isEmpty)
                    const Padding(
                      padding: EdgeInsets.all(16.0),
                      child: Text(
                        'No squad information available',
                        style: TextStyle(color: Colors.grey),
                        textAlign: TextAlign.center,
                      ),
                    )
                  else
                    ..._squad.take(10).map((player) => _buildPlayerRow(player)),
                  if (_squad.length > 10)
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        '... and ${_squad.length - 10} more players',
                        style: const TextStyle(
                          color: Colors.grey,
                          fontStyle: FontStyle.italic,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoCard(String title, List<Widget> children) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 12),
          ...children,
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                color: Colors.black54,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                color: Colors.black87,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildColorRow(String label, String colorHex) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          SizedBox(
            width: 120,
            child: Text(
              label,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                color: Colors.black54,
              ),
            ),
          ),
          Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              color: _parseColor(colorHex),
              borderRadius: BorderRadius.circular(4),
              border: Border.all(color: Colors.grey),
            ),
          ),
          const SizedBox(width: 8),
          Text(
            colorHex,
            style: const TextStyle(
              color: Colors.black87,
              fontFamily: 'monospace',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPlayerRow(Player player) {
    return ListTile(
      leading: CircleAvatar(
        backgroundColor: Colors.green[100],
        child: Icon(
          Icons.person,
          color: Colors.green[800],
        ),
      ),
      title: Text(
        player.name,
        style: const TextStyle(fontWeight: FontWeight.w500),
      ),
      subtitle: Text(
        '${player.position ?? 'N/A'} • ${player.jerseyNumber ?? 'N/A'}',
      ),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PlayerDetailsPage(player: player),
          ),
        );
      },
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