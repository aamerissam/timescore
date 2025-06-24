import 'package:flutter/material.dart';
import '../models/player.dart';
import '../services/favorites_service.dart';

class PlayerDetailsPage extends StatefulWidget {
  final Player player;

  const PlayerDetailsPage({super.key, required this.player});

  @override
  State<PlayerDetailsPage> createState() => _PlayerDetailsPageState();
}

class _PlayerDetailsPageState extends State<PlayerDetailsPage> {
  bool _isFavorite = false;

  @override
  void initState() {
    super.initState();
    _checkFavoriteStatus();
  }

  Future<void> _checkFavoriteStatus() async {
    final isFavorite = await FavoritesService.isFavoritePlayer(widget.player.id);
    setState(() {
      _isFavorite = isFavorite;
    });
  }

  Future<void> _toggleFavorite() async {
    if (_isFavorite) {
      await FavoritesService.removeFavoritePlayer(widget.player.id);
    } else {
      await FavoritesService.addFavoritePlayer(widget.player);
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.player.name),
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
              // Player Header Card
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
                    CircleAvatar(
                      radius: 60,
                      backgroundColor: Colors.green[100],
                      child: Icon(
                        Icons.person,
                        size: 60,
                        color: Colors.green[800],
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      widget.player.name,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    if (widget.player.shortName != null) ...[
                      const SizedBox(height: 8),
                      Text(
                        widget.player.shortName!,
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              
              const SizedBox(height: 16),
              
              // Player Information Cards
              _buildInfoCard(
                'Player Information',
                [
                  _buildInfoRow('Position', widget.player.position ?? 'N/A'),
                  _buildInfoRow('Jersey Number', widget.player.jerseyNumber ?? 'N/A'),
                  _buildInfoRow('User Count', '${widget.player.userCount}'),
                  _buildInfoRow('Deceased', widget.player.deceased ? 'Yes' : 'No'),
                ],
              ),
              
              const SizedBox(height: 16),
              
              // Team Information
              if (widget.player.team != null)
                _buildInfoCard(
                  'Team Information',
                  [
                    _buildInfoRow('Team Name', widget.player.team!.name),
                    _buildInfoRow('Team Code', widget.player.team!.nameCode),
                    _buildInfoRow('National Team', widget.player.team!.national ? 'Yes' : 'No'),
                    _buildInfoRow('Sport', widget.player.team!.sport.name),
                    _buildInfoRow('User Count', '${widget.player.team!.userCount}'),
                    if (widget.player.team!.gender != null)
                      _buildInfoRow('Gender', widget.player.team!.gender!),
                  ],
                ),
              
              const SizedBox(height: 16),
              
              // Country Information
              if (widget.player.country != null)
                _buildInfoCard(
                  'Country Information',
                  [
                    _buildInfoRow('Country', widget.player.country!.name),
                    _buildInfoRow('Country Code', widget.player.country!.alpha2),
                  ],
                ),
              
              const SizedBox(height: 16),
              
              // Team Colors (if available)
              if (widget.player.team != null)
                _buildInfoCard(
                  'Team Colors',
                  [
                    _buildColorRow('Primary', widget.player.team!.teamColors.primary),
                    _buildColorRow('Secondary', widget.player.team!.teamColors.secondary),
                    _buildColorRow('Text', widget.player.team!.teamColors.text),
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