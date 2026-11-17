import 'package:flutter/material.dart';
import 'package:latres_mobile_124240081/models/show_model.dart';
import 'package:latres_mobile_124240081/screens/detail_screen.dart';
import 'package:latres_mobile_124240081/services/api_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  //nampung daftar TV Shows dari API
  List<ShowModel> _shows = [];

  //var status loading dan pesan error
  bool _isLoading = true;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _loadShows();
  }

  //ambil data TV Shows dari api
  Future<void> _loadShows() async {
    setState(() {
      _isLoading = true;
      _errorMessage = '';
    });

    try {
      final data = await ApiService.fetchShows();
      setState(() {
        _shows = data;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        _errorMessage = e.toString();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        backgroundColor: const Color(0xFF121212),
        elevation: 0,
        title: const Text(
          'Skuy Nonton!',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
            color: Colors.white,
          ),
        ),
      ),
      // [FITUR UTAMA]: Tampilkan Loading Indicator vs Daftar Film vs Pesan Error
      body: _isLoading
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(color: Colors.redAccent),
                  SizedBox(height: 14),
                  Text(
                    'Memuat daftar TV Shows...',
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            )
          : _errorMessage.isNotEmpty
              ? Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.cloud_off, size: 60, color: Colors.redAccent),
                        const SizedBox(height: 12),
                        const Text(
                          'Gagal Mengambil Data',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          _errorMessage,
                          textAlign: TextAlign.center,
                          style: const TextStyle(color: Colors.grey, fontSize: 12),
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton.icon(
                          onPressed: _loadShows,
                          icon: const Icon(Icons.refresh),
                          label: const Text('Coba Lagi'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.redAccent,
                            foregroundColor: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              : RefreshIndicator(
                  color: Colors.redAccent,
                  onRefresh: _loadShows,
                  //grid kartu film dalam 2 kolom memanjang
                  child: GridView.builder(
                    padding: const EdgeInsets.all(14.0),
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2, //kolom nyamping
                      childAspectRatio: 0.65,   
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                    ),
                    itemCount: _shows.length,
                    itemBuilder: (context, index) {
                      final show = _shows[index];
                      return _buildShowCard(
                        show: show,
                        onTap: () {
                          //pindah ke detail screen
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => DetailScreen(
                                showId: show.id,
                                initialShow: show,
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
    );
  }

  //widget kartu film
  Widget _buildShowCard({required ShowModel show, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFF1E1E1E), // Warna latar belakang kartu film
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(100),
              blurRadius: 6,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 1. GAMBAR POSTER FILM
            Expanded(
              child: show.imageMedium.isNotEmpty
                  ? Image.network(
                      show.imageMedium,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return Container(
                          color: const Color(0xFF2A2A2A),
                          child: const Center(
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.redAccent,
                            ),
                          ),
                        );
                      },
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          color: const Color(0xFF2A2A2A),
                          child: const Center(
                            child: Icon(Icons.broken_image, color: Colors.grey, size: 40),
                          ),
                        );
                      },
                    )
                  : Container(
                      color: const Color(0xFF2A2A2A),
                      child: const Center(
                        child: Icon(Icons.movie, color: Colors.grey, size: 40),
                      ),
                    ),
            ),

            //judul dan rating di bwh gmbr
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    show.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.star, color: Colors.amber, size: 14),
                      const SizedBox(width: 4),
                      Text(
                        show.rating > 0 ? '${show.rating}' : '-',
                        style: TextStyle(
                          color: Colors.grey[400],
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}