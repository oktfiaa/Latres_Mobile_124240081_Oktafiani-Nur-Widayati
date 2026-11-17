import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:latres_mobile_124240081/models/favorite_model.dart';
import 'package:latres_mobile_124240081/models/show_model.dart';

class FavoriteService {
  static const String boxName = 'favorite_shows_box';

  static Box getBox() {
    return Hive.box(boxName);
  }
  static bool isFavorite(int id) {
    return getBox().containsKey(id);
  }
  //tambah atau hapus show dari favorit 
  static Future<bool> toggleFavorite(ShowModel show) async {
    final box = getBox();
    if (box.containsKey(show.id)) {
      await box.delete(show.id);
      return false; // Berstatus: Dihapus dari favorit
    } else {
      final favItem = FavoriteShow(
        id: show.id,
        name: show.name,
        imageUrl: show.imageMedium.isNotEmpty ? show.imageMedium : show.imageOriginal,
        rating: show.rating,
        genres: show.genres.join(', '),
        summary: show.summary,
      );
      //simpan data
      await box.put(show.id, favItem.toMap());
      return true; 
    }
  }

  //hapus show dari favorit berdasarkan id
  static Future<void> removeFavorite(int id) async {
    final box = getBox();
    await box.delete(id);
  }

  // ambil semua item show favorit 
  static List<FavoriteShow> getAllFavorites() {
    final box = getBox();
    return box.values.map((item) {
      return FavoriteShow.fromMap(Map<dynamic, dynamic>.from(item as Map));
    }).toList();
  }

  //update halaman favorit
  static ValueListenable<Box> getListenable() {
    return getBox().listenable();
  }
}