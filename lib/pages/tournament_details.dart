import 'package:flutter/material.dart';
import '../models/team.dart';

class TournamentDetailsPage extends StatelessWidget {
  final Tournament tournament;

  const TournamentDetailsPage({super.key, required this.tournament});

  @override
  Widget build(BuildContext context) {
    final category = tournament.category;
    return Scaffold(
      appBar: AppBar(
        title: Text(tournament.name),
        backgroundColor: Colors.green[800],
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              tournament.name,
              style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            _buildInfoRow('Country', category.country.name),
            _buildInfoRow('Sport', category.sport.name),
            _buildInfoRow('User Count', tournament.userCount.toString()),
            _buildInfoRow('Tier', 'N/A'),
            _buildInfoRow('Display Inverse Home/Away', tournament.displayInverseHomeAwayTeams ? 'Yes' : 'No'),
            const SizedBox(height: 24),
            // You can add more fields here as needed
            const Text('More tournament details can be added here.', style: TextStyle(color: Colors.grey)),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          SizedBox(width: 120, child: Text(label, style: const TextStyle(fontWeight: FontWeight.w600))),
          Expanded(child: Text(value, style: const TextStyle(fontSize: 16))),
        ],
      ),
    );
  }
} 