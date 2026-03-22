import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class FavoriteRoute {
  final String id;
  final String from;
  final String to;
  final String name;
  final DateTime addedAt;

  FavoriteRoute({
    required this.id,
    required this.from,
    required this.to,
    required this.name,
    required this.addedAt,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'from': from,
    'to': to,
    'name': name,
    'addedAt': addedAt.toIso8601String(),
  };

  factory FavoriteRoute.fromJson(Map<String, dynamic> json) => FavoriteRoute(
    id: json['id'],
    from: json['from'],
    to: json['to'],
    name: json['name'],
    addedAt: DateTime.parse(json['addedAt']),
  );
}

class FavoritesProvider extends ChangeNotifier {
  List<FavoriteRoute> _favorites = [];
  static const String _favoritesKey = 'favoriteRoutes';

  List<FavoriteRoute> get favorites => _favorites;

  FavoritesProvider() {
    _loadFavorites();
  }

  Future<void> _loadFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    final String? favoritesJson = prefs.getString(_favoritesKey);
    
    if (favoritesJson != null) {
      final List<dynamic> decoded = json.decode(favoritesJson);
      _favorites = decoded.map((item) => FavoriteRoute.fromJson(item)).toList();
      notifyListeners();
    }
  }

  Future<void> _saveFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    final String encoded = json.encode(_favorites.map((f) => f.toJson()).toList());
    await prefs.setString(_favoritesKey, encoded);
  }

  Future<void> addFavorite(String from, String to, String name) async {
    final favorite = FavoriteRoute(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      from: from,
      to: to,
      name: name,
      addedAt: DateTime.now(),
    );
    
    _favorites.insert(0, favorite);
    await _saveFavorites();
    notifyListeners();
  }

  Future<void> removeFavorite(String id) async {
    _favorites.removeWhere((f) => f.id == id);
    await _saveFavorites();
    notifyListeners();
  }

  bool isFavorite(String from, String to) {
    return _favorites.any((f) => f.from == from && f.to == to);
  }
}
