import 'package:flutter/material.dart';
import '../models/user/user_preferences.dart';
import '../services/storage/hive_service.dart';

class FavoritesProvider extends ChangeNotifier {
  List<FavoriteItem> _favorites = [];

  List<FavoriteItem> get favorites => _favorites;

  Future<void> loadFavorites() async {
    _favorites = HiveService.getAllFavorites();
    notifyListeners();
  }

  Future<void> addFavorite(FavoriteItem favorite) async {
    await HiveService.saveFavorite(favorite);
    _favorites.add(favorite);
    notifyListeners();
  }

  Future<void> removeFavorite(String id) async {
    await HiveService.deleteFavorite(id);
    _favorites.removeWhere((item) => item.id == id);
    notifyListeners();
  }
}

