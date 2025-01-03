import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DetailProdukPage extends StatelessWidget {
  final Map<String, dynamic> produk;
  final List<dynamic> ulasan;

  const DetailProdukPage({
    super.key,
    required this.produk,
    required this.ulasan,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Detail Produk',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.grey.shade800,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: produk.isEmpty
          ? const Center(
              child: Text("Produk Tidak Ditemukan"),
            )
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      Container(
                        width: double.infinity,
                        height: 250,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10.0),
                          image: DecorationImage(
                            image: produk['image_url'] != null
                                ? NetworkImage(produk['image_url'])
                                : const AssetImage('assets/product.jpg')
                                    as ImageProvider,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      Column(
                        children: [
                          Text(
                            produk['name'] ?? 'Produk Tidak Tersedia',
                            style: const TextStyle(
                              fontSize: 24.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              shadows: [
                                Shadow(
                                  color: Colors.black,
                                  blurRadius: 3.0,
                                  offset: Offset(1.5, 1.5),
                                ),
                              ],
                            ),
                          ),
                          Text(
                            NumberFormat.currency(
                              locale: 'id_ID',
                              symbol: 'Rp',
                              decimalDigits: 2,
                            ).format(produk['price'] ?? 0),
                            style: const TextStyle(
                              fontSize: 20.0,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              shadows: [
                                Shadow(
                                  color: Colors.black,
                                  blurRadius: 3.0,
                                  offset: Offset(1.5, 1.5),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 16.0),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      produk['description'] ?? 'Deskripsi Tidak Tersedia',
                      textAlign: TextAlign.justify,
                      style: const TextStyle(fontSize: 16.0),
                    ),
                  ),
                  const SizedBox(height: 20.0),
                  ElevatedButton(
                    onPressed: () {
                      debugPrint("Tambahkan ke Keranjang");
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey.shade800,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 50.0, vertical: 12.0),
                    ),
                    child: const Text(
                      "Tambahkan ke Keranjang",
                      style: TextStyle(
                        fontSize: 16.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20.0),

                  // Ulasan produk
                  if (ulasan.isNotEmpty) ...[
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        "Ulasan: ",
                        style: TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10.0),
                    ...ulasan.map((review) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            review['comment'] ?? 'Tidak ada komentar',
                            style: const TextStyle(fontSize: 16.0),
                          ),
                          const SizedBox(height: 4.0),
                          Row(
                            children: List.generate(5, (index) {
                              return Icon(
                                index < (review['ratings'] ?? 0)
                                    ? Icons.star
                                    : Icons.star_border,
                                color: Colors.amber,
                                size: 20.0,
                              );
                            }),
                          ),
                          const SizedBox(height: 10.0),
                        ],
                      );
                    }),
                  ] else
                    const Text(
                      'Belum ada ulasan.',
                      style: TextStyle(fontSize: 16.0),
                    ),
                ],
              ),
            ),
    );
  }
}
