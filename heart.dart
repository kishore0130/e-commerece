import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:product/main.dart';
import 'package:product/product2.dart';
import 'package:provider/provider.dart' show Provider;
import 'package:shared_preferences/shared_preferences.dart';

import 'bottom.dart';
import 'buynow.dart';

class WishlistPage extends StatefulWidget {
  const WishlistPage({super.key});

  @override
  State<WishlistPage> createState() => _WishlistPageState();
}

class _WishlistPageState extends State<WishlistPage> {
  List<Map<String, dynamic>> wishlistProducts = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadWishlistProducts();
  }

  Future<void> loadWishlistProducts() async {
    final prefs = await SharedPreferences.getInstance();
    final wishlistIds = prefs.getStringList('wishlist') ?? [];

    if (wishlistIds.isEmpty) {
      setState(() {
        isLoading = false;
      });
      return;
    }

    List<Map<String, dynamic>> temp = [];

    for (String id in wishlistIds) {
      final response = await http.get(
        Uri.parse("https://dummyjson.com/products/$id"),
      );

      if (response.statusCode == 200) {
        temp.add(jsonDecode(response.body));
      }
    }

    setState(() {
      wishlistProducts = temp;
      isLoading = false;
    });
  }

  Future<void> removeFromWishlist(String id) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> wishlist = prefs.getStringList('wishlist') ?? [];

    wishlist.remove(id);
    await prefs.setStringList('wishlist', wishlist);

    wishlistProducts.removeWhere((p) => p['id'].toString() == id);

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    var themedata = Provider.of<ThemProvider>(context);
    return Scaffold(
     // backgroundColor: themedata.black?Colors.black:Colors.greenAccent,
      appBar: AppBar(
        title: Text("My Wishlist".toUpperCase(),style: TextStyle(fontWeight: FontWeight.w600,fontSize: 16),),
        flexibleSpace: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient( colors: themedata.black
                  ? [Colors.grey.shade900, Colors.black]
                  : [Color(0xFF11998e), Color(0xFF38ef7d)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight
              )
          ),
        ),
        centerTitle: true,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : wishlistProducts.isEmpty
          ? Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Your WishList is Empty",style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold),),
            Image.asset("assets/wish2.png",height: 180,width: 200,),
            Text("Looks like you haven’t added anything yet.\nStart exploring and save your favorite items here!",
            textAlign: TextAlign.center,),
            SizedBox(height: 20,),
            ElevatedButton(onPressed: (){
              Navigator.push(context, MaterialPageRoute(builder: (context)=>bottom()));
            },style: ElevatedButton.styleFrom(
                backgroundColor: themedata.black?Colors.white:Colors.black,
                fixedSize: Size(200, 50)
            ), child: Text("Add Now",style: TextStyle(color: themedata.black?Colors.black:Colors.white),))
          ],
        ),
      )
          : ListView.builder(
        itemCount: wishlistProducts.length,
        itemBuilder: (context, index) {
          final product = wishlistProducts[index];

          return Card(
            color: themedata.black?Colors.grey.shade900:Colors.white70,
            margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Image.network(
                      product['thumbnail'],
                      height: 80,
                      width: 80,
                      fit: BoxFit.cover,
                    ),
                  ),

                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          product['brand'] ?? "",
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          "(${product['title']})",
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(fontSize: 13),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          "Price :₹ ${product['price']}",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.green.shade700,
                          ),
                        ),
                      ],
                    ),
                  ),

                  Column(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.favorite, color: Colors.red),
                        onPressed: () =>
                            showDialog(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: const Text(
                                  "Remove From the WishList? ",
                                  style: TextStyle(fontSize: 15),
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.pop(context),
                                    child: const Text("No"),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      setState(() {
                                        removeFromWishlist(product['id'].toString());
                                      });
                                      Navigator.pop(context);
                                    },
                                    child: const Text(
                                      "Remove",
                                      style: TextStyle(color: Colors.red),
                                    ),
                                  ),
                                ],
                              ),
                            )
                      ),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => productPage(id: product['id'].toString())
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                          minimumSize: const Size(110, 32),
                          padding: EdgeInsets.zero,
                        ),
                        child:  Text(
                          "View the Product",
                          style: TextStyle(fontSize: 12, color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      )

    );
  }
}