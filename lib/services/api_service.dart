import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:latres_mobile_124240081/models/show_model.dart';

class ApiService {
  //tulis url api nya
  static const String baseUrl = 'https://api.tvmaze.com';

  //ambil daftar seluruh tv shows untuk halaman home
  static Future<List<ShowModel>> fetchShows() async {
    final url = Uri.parse('$baseUrl/shows');
    
    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final List<dynamic> jsonList = jsonDecode(response.body);
        return jsonList.map((item) => ShowModel.fromJson(item)).toList();
      } else {
        throw Exception('Gagal memuat data shows. Status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Terjadi kesalahan koneksi internet: $e');
    }
  }

  //ambil detail satu TV Show berdasarkan ID untuk halaman detail show
  static Future<ShowModel> fetchShowDetail(int id) async {
    final url = Uri.parse('$baseUrl/shows/$id');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        // Decode body response menjadi single Map
        final Map<String, dynamic> jsonMap = jsonDecode(response.body);
        return ShowModel.fromJson(jsonMap);
      } else {
        throw Exception('Gagal memuat detail show. Status code: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Terjadi kesalahan saat mengambil detail: $e');
    }
  }
}
