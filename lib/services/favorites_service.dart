import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/player.dart';
import '../models/team.dart';

class FavoritesService {
  static const String _favoritePlayersKey = 'favorite_players';
  static const String _favoriteTeamsKey = 'favorite_teams';

  // Get favorite players
  static Future<List<Player>> getFavoritePlayers() async {
    final prefs = await SharedPreferences.getInstance();
    final playersJson = prefs.getStringList(_favoritePlayersKey) ?? [];
    
    return playersJson
        .map((playerJson) => Player.fromJson(json.decode(playerJson)))
        .toList();
  }

  // Add player to favorites
  static Future<void> addFavoritePlayer(Player player) async {
    final prefs = await SharedPreferences.getInstance();
    final players = await getFavoritePlayers();
    
    // Check if player already exists
    if (!players.any((p) => p.id == player.id)) {
      players.add(player);
      final playersJson = players.map((p) => json.encode(p.toJson())).toList();
      await prefs.setStringList(_favoritePlayersKey, playersJson);
    }
  }

  // Remove player from favorites
  static Future<void> removeFavoritePlayer(int playerId) async {
    final prefs = await SharedPreferences.getInstance();
    final players = await getFavoritePlayers();
    
    players.removeWhere((player) => player.id == playerId);
    final playersJson = players.map((p) => json.encode(p.toJson())).toList();
    await prefs.setStringList(_favoritePlayersKey, playersJson);
  }

  // Check if player is favorite
  static Future<bool> isFavoritePlayer(int playerId) async {
    final players = await getFavoritePlayers();
    return players.any((player) => player.id == playerId);
  }

  // Get favorite teams
  static Future<List<TeamModel>> getFavoriteTeams() async {
    final prefs = await SharedPreferences.getInstance();
    final teamsJson = prefs.getStringList(_favoriteTeamsKey) ?? [];
    
    return teamsJson
        .map((teamJson) => TeamModel.fromJson(json.decode(teamJson)))
        .toList();
  }

  // Add team to favorites
  static Future<void> addFavoriteTeam(TeamModel team) async {
    final prefs = await SharedPreferences.getInstance();
    final teams = await getFavoriteTeams();
    
    // Check if team already exists
    if (!teams.any((t) => t.id == team.id)) {
      teams.add(team);
      final teamsJson = teams.map((t) => json.encode(t.toJson())).toList();
      await prefs.setStringList(_favoriteTeamsKey, teamsJson);
    }
  }

  // Remove team from favorites
  static Future<void> removeFavoriteTeam(int teamId) async {
    final prefs = await SharedPreferences.getInstance();
    final teams = await getFavoriteTeams();
    
    teams.removeWhere((team) => team.id == teamId);
    final teamsJson = teams.map((t) => json.encode(t.toJson())).toList();
    await prefs.setStringList(_favoriteTeamsKey, teamsJson);
  }

  // Check if team is favorite
  static Future<bool> isFavoriteTeam(int teamId) async {
    final teams = await getFavoriteTeams();
    return teams.any((team) => team.id == teamId);
  }
} 