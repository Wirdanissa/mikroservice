import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart';
import 'detail_produk_page.dart'; // Pastikan file ini ada

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  HomePageState createState() => HomePageState();
}

class HomePageState extends State<HomePage> {
  List<dynamic> products = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchProducts();
  }

  Future<void> fetchProducts() async {
    try {
      log("Fetching products from the server...");
      final response =
          await http.get(Uri.parse('http://192.168.100.163:3000/products'));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data is Map<String, dynamic> && data.containsKey('data')) {
          setState(() {
            products = List.from(data['data']);
            isLoading = false;
          });
          log("Successfully fetched ${products.length} products.");
        } else {
          throw Exception("Unexpected response format: $data");
        }
      } else {
        throw Exception(
            "Failed to load products. Status code: ${response.statusCode}");
      }
    } catch (e) {
      log("Error fetching products: $e");
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade800,
      appBar: AppBar(
        elevation: 1.0,
        backgroundColor: Colors.grey.shade800,
        title: const Text(
          "Daftar Produk",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : products.isEmpty
              ? const Center(
                  child: Text(
                    "Tidak ada produk yang tersedia",
                    style: TextStyle(color: Colors.white),
                  ),
                )
              : ListView.builder(
                  itemCount: products.length,
                  itemBuilder: (context, index) {
                    final product = products[index];
                    return Card(
                      elevation: 8.0,
                      margin: const EdgeInsets.symmetric(
                          horizontal: 10.0, vertical: 6.0),
                      child: Container(
                        decoration: const BoxDecoration(
                          color: Color.fromRGBO(64, 75, 96, .9),
                        ),
                        child: ListTile(
                          contentPadding: const EdgeInsets.symmetric(
                              horizontal: 20.0, vertical: 10.0),
                          leading: Container(
                            padding: const EdgeInsets.only(right: 12.0),
                            decoration: const BoxDecoration(
                              border: Border(
                                right: BorderSide(
                                    width: 1.0, color: Colors.white70),
                              ),
                            ),
                            child: const Icon(Icons.shopping_cart,
                                color: Colors.white),
                          ),
                          title: Text(
                            product['name'] ?? 'Nama produk tidak tersedia',
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          subtitle: Text(
                            NumberFormat.currency(
                              locale: 'id_ID',
                              symbol: 'Rp',
                              decimalDigits: 2,
                            ).format(product['price'] ?? 0),
                            style: const TextStyle(color: Colors.white70),
                          ),
                          trailing: const Icon(
                            Icons.keyboard_arrow_right,
                            color: Colors.white,
                            size: 30.0,
                          ),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    DetailProdukPage(productId: product['id']),
                              ),
                            );
                          },
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}
