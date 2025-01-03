import 'dart:convert';
import 'dart:io';

import 'package:ecommerc_app/models/product_model.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

class FavoritesManager extends ChangeNotifier {
  List<ProductModel> _favorites = [];

  List<ProductModel> get favorites => _favorites;

  void toggleFavorite(ProductModel product) async {
    if (_favorites.contains(product)) {
      _favorites.remove(product);
    } else {
      _favorites.add(product);
    }
    notifyListeners();
    await _saveFavoritesToFile();
  }

  Future<void> loadFavorites() async {
    try {
      final file = await _getFavoritesFile();
      if (await file.exists()) {
        final content = await file.readAsString();
        final data = json.decode(content) as List;
        _favorites = data.map((e) => ProductModel.fromJson(e)).toList();
        notifyListeners();
      }
    } catch (e) {
      debugPrint("Error loading favorites: $e");
    }
  }

  Future<void> _saveFavoritesToFile() async {
    try {
      final file = await _getFavoritesFile();
      final data = _favorites.map((e) => e.toJson()).toList();
      await file.writeAsString(json.encode(data));
    } catch (e) {
      debugPrint("Error saving favorites: $e");
    }
  }

  Future<File> _getFavoritesFile() async {
    final directory = await getApplicationDocumentsDirectory();
    return File('${directory.path}/favorites.json');
  }
}
