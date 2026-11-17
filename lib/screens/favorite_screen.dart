import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:latres_mobile_124240081/models/favorite_model.dart';
import 'package:latres_mobile_124240081/screens/detail_screen.dart';
import 'package:latres_mobile_124240081/services/favorite_service.dart';


class FavoriteScreen extends StatelessWidget {
  const FavoriteScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        backgroundColor: const Color(0xFF121212),
        elevation: 0,
        title: const Text(
          'Daftar Favorit',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: ValueListenableBuilder<Box>(
        valueListenable: FavoriteService.getListenable(),
        builder: (context, box, child) {
          final List<FavoriteShow> favoriteList = FavoriteService.getAllFavorites();
          //kondisi jika blm ada fav
          if (favoriteList.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.favorite_border,
                    size: 72,
                    color: Colors.grey[700],
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Belum Ada Show Favorit',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Klik ikon hati pada detail show untuk menyimpannya ke sini.',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey[400], fontSize: 13),
                  ),
                ],
              ),
            );
          }

          //tampilkan daftar TV Show favorit 
          return ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 14.0),
            itemCount: favoriteList.length,
            separatorBuilder: (context, index) => const SizedBox(height: 10),
            itemBuilder: (context, index) {
              final favoriteShow = favoriteList[index];

              return Container(
                decoration: BoxDecoration(
                  color: const Color(0xFF1E1E1E),
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withAlpha(80),
                      blurRadius: 5,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: ListTile(
                  contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  //klik ke halaman show
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DetailScreen(showId: favoriteShow.id),
                      ),
                    );
                  },
                  //gambar poster
                  leading: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: SizedBox(
                      width: 50,
                      height: 70,
                      child: favoriteShow.imageUrl.isNotEmpty
                          ? Image.network(
                              favoriteShow.imageUrl,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) => Container(
                                color: const Color(0xFF2E2E2E),
                                child: const Icon(Icons.movie, color: Colors.grey),
                              ),
                            )
                          : Container(
                              color: const Color(0xFF2E2E2E),
                              child: const Icon(Icons.movie, color: Colors.grey),
                            ),
                    ),
                  ),
                  //judul show
                  title: Text(
                    favoriteShow.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                  //rating
                  subtitle: Padding(
                    padding: const EdgeInsets.only(top: 4.0),
                    child: Row(
                      children: [
                        const Icon(Icons.star, color: Colors.amber, size: 14),
                        const SizedBox(width: 4),
                        Text(
                          favoriteShow.rating > 0 ? '${favoriteShow.rating}' : '-',
                          style: TextStyle(
                            color: Colors.grey[300],
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  //delete fav
                  trailing: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.redAccent),
                    tooltip: 'Hapus dari Favorit',
                    onPressed: () async {
                      await FavoriteService.removeFavorite(favoriteShow.id);
                      if (!context.mounted) return;
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('${favoriteShow.name} dihapus dari Favorit'),
                          backgroundColor: Colors.redAccent,
                          duration: const Duration(seconds: 2),
                        ),
                      );
                    },
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
