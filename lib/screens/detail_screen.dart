import 'package:flutter/material.dart';
import 'package:latres_mobile_124240081/models/show_model.dart';
import 'package:latres_mobile_124240081/services/api_service.dart';
import 'package:latres_mobile_124240081/services/favorite_service.dart';


class DetailScreen extends StatefulWidget {
  final int showId;
  final ShowModel? initialShow; // Data awal opsional dari list agar UI langsung terisi

  const DetailScreen({
    super.key,
    required this.showId,
    this.initialShow,
  });

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  ShowModel? _show;
  bool _isLoading = true;
  bool _isFavorite = false;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    _show = widget.initialShow;
    _isFavorite = FavoriteService.isFavorite(widget.showId);
    //fetch data detail
    _loadShowDetail();
  }

  Future<void> _loadShowDetail() async {
    try {
      final detail = await ApiService.fetchShowDetail(widget.showId);
      setState(() {
        _show = detail;
        _isLoading = false;
        _isFavorite = FavoriteService.isFavorite(widget.showId);
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
        if (_show == null) {
          _errorMessage = e.toString();
        }
      });
    }
  }

  //toglle status fav
  Future<void> _toggleFavorite() async {
    if (_show == null) return;

    final nowFavorited = await FavoriteService.toggleFavorite(_show!);
    setState(() {
      _isFavorite = nowFavorited;
    });

    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          nowFavorited
              ? '${_show!.name} ditambahkan ke Favorit!'
              : '${_show!.name} dihapus dari Favorit!',
        ),
        backgroundColor: nowFavorited ? Colors.green : Colors.redAccent,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        backgroundColor: const Color(0xFF121212),
        elevation: 0,
        // [FITUR UTAMA MODUL IV]: Tombol Kembali (Back Button)
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Detail',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
      body: _isLoading && _show == null
          ? const Center(
              child: CircularProgressIndicator(color: Colors.redAccent),
            )
          : _errorMessage.isNotEmpty && _show == null
              ? Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.error_outline, size: 60, color: Colors.redAccent),
                        const SizedBox(height: 12),
                        Text(
                          'Gagal memuat detail show: $_errorMessage',
                          textAlign: TextAlign.center,
                          style: const TextStyle(color: Colors.white),
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: _loadShowDetail,
                          style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
                          child: const Text('Coba Lagi', style: TextStyle(color: Colors.white)),
                        ),
                      ],
                    ),
                  ),
                )
              : SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      //gambar poster
                      Stack(
                        children: [
                          Container(
                            height: 360,
                            width: double.infinity,
                            color: const Color(0xFF1F1F1F),
                            child: _show!.imageOriginal.isNotEmpty
                                ? Image.network(
                                    _show!.imageOriginal,
                                    fit: BoxFit.cover,
                                    errorBuilder: (_, __, ___) => const Center(
                                      child: Icon(Icons.movie, size: 80, color: Colors.grey),
                                    ),
                                  )
                                : const Center(
                                    child: Icon(Icons.movie, size: 80, color: Colors.grey),
                                  ),
                          ),
                          Positioned(
                            bottom: 0,
                            left: 0,
                            right: 0,
                            height: 100,
                            child: Container(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.bottomCenter,
                                  end: Alignment.topCenter,
                                  colors: [
                                    const Color(0xFF121212),
                                    const Color(0xFF121212).withOpacity(0.0),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),

                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // 2. WAJIB DOKUMEN: Judul TV Show
                            Text(
                              _show!.name,
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 6),

                            // 3. WAJIB DOKUMEN: Rating Show
                            Row(
                              children: [
                                const Icon(Icons.star, color: Colors.amber, size: 16),
                                const SizedBox(width: 4),
                                Text(
                                  _show!.rating > 0 ? '${_show!.rating}' : '-',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 13,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 6),

                            //genre
                            if (_show!.genres.isNotEmpty) ...[
                              Text(
                                _show!.genres.join(', '),
                                style: TextStyle(
                                  color: Colors.grey[400],
                                  fontSize: 12,
                                ),
                              ),
                              const SizedBox(height: 16),
                            ],

                            //tmbl aksi nonton
                            Row(
                              children: [
                                Expanded(
                                  child: ElevatedButton.icon(
                                    onPressed: () {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                          content: Text('Memulai streaming ${_show!.name}...'),
                                          backgroundColor: Colors.redAccent,
                                        ),
                                      );
                                    },
                                    icon: const Icon(Icons.play_arrow, color: Colors.white, size: 20),
                                    label: const Text(
                                      'Nonton',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15,
                                      ),
                                    ),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color(0xFFE53935),
                                      padding: const EdgeInsets.symmetric(vertical: 12),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Container(
                                  height: 48,
                                  width: 48,
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF262626),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: IconButton(
                                    icon: Icon(
                                      _isFavorite ? Icons.favorite : Icons.favorite_border,
                                      color: _isFavorite ? Colors.redAccent : Colors.white,
                                      size: 22,
                                    ),
                                    onPressed: _toggleFavorite,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 24),

                            //summary/overview
                            const Text(
                              'Overview',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              _show!.summary,
                              textAlign: TextAlign.justify,
                              style: TextStyle(
                                color: Colors.grey[300],
                                fontSize: 14,
                                height: 1.6,
                              ),
                            ),
                            const SizedBox(height: 30),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
    );
  }
}