class ShowModel {
  final int id;
  final String name;
  final List<String> genres;
  final double rating;
  final String imageMedium;
  final String imageOriginal;
  final String summary;
  final String status;
  final String premiered;

  //constructor utk menampung data yang wajib diisi
  ShowModel({
    required this.id,
    required this.name,
    required this.genres,
    required this.rating,
    required this.imageMedium,
    required this.imageOriginal,
    required this.summary,
    required this.status,
    required this.premiered,
  });

  //factory constructor
  factory ShowModel.fromJson(Map<String, dynamic> json) {
    // parse rating bisa bertipe int, double, atau null)
    double parsedRating = 0.0;
    if (json['rating'] != null && json['rating']['average'] != null) {
      parsedRating = (json['rating']['average'] as num).toDouble();
    }

    //parse gamabr, bisa null jika show belum ada gambar)
    String mediumImg = '';
    String originalImg = '';
    if (json['image'] != null) {
      mediumImg = json['image']['medium'] ?? '';
      originalImg = json['image']['original'] ?? '';
    }

    //parse genre bentuk list string
    List<String> parsedGenres = [];
    if (json['genres'] != null) {
      parsedGenres = List<String>.from(json['genres']);
    }

    //bersihin tag HTML dari string summary bawaan TVMaze (<p>, <b>, dsb)
    String rawSummary = json['summary'] ?? 'Tidak ada ringkasan sinopsis untuk show ini.';
    String cleanSummary = rawSummary.replaceAll(RegExp(r'<[^>]*>|&[^;]+;'), '').trim();

    return ShowModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? 'Judul Tidak Tersedia',
      genres: parsedGenres,
      rating: parsedRating,
      imageMedium: mediumImg,
      imageOriginal: originalImg.isNotEmpty ? originalImg : mediumImg,
      summary: cleanSummary.isNotEmpty ? cleanSummary : 'Tidak ada sinopsis tersedia.',
      status: json['status'] ?? 'Unknown',
      premiered: json['premiered'] ?? '-',
    );
  }
}
