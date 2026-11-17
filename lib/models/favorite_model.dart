class FavoriteShow {
  final int id;
  final String name;
  final String imageUrl;
  final double rating;
  final String genres;
  final String summary;

  FavoriteShow({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.rating,
    this.genres = '',
    this.summary = '',
  });

  //mengonversi objek FavoriteShow menjadi Map agar bisa disimpan ke Hive
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'imageUrl': imageUrl,
      'rating': rating,
      'genres': genres,
      'summary': summary,
    };
  }

  //membaca Map dari Hive dan mengubahnya kembali menjadi objek FavoriteShow
  factory FavoriteShow.fromMap(Map<dynamic, dynamic> map) {
    return FavoriteShow(
      id: map['id'] ?? 0,
      name: map['name'] ?? '',
      imageUrl: map['imageUrl'] ?? '',
      rating: (map['rating'] as num?)?.toDouble() ?? 0.0,
      genres: map['genres'] ?? '',
      summary: map['summary'] ?? '',
    );
  }
}