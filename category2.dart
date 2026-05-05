import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:product/cat.dart';
import 'package:product/main.dart';
import 'package:provider/provider.dart' show Provider;

class CategoryProductsPage extends StatefulWidget {
  final String category;

  const CategoryProductsPage({super.key, required this.category});

  @override
  State<CategoryProductsPage> createState() => _CategoryProductsPageState();
}

class _CategoryProductsPageState extends State<CategoryProductsPage> {
  late Future<List<dynamic>> products;

  @override
  void initState() {
    super.initState();
    products = fetchCategoryProducts();
  }

  Future<List<dynamic>> fetchCategoryProducts() async {
    final res = await http.get(
      Uri.parse(
        "https://dummyjson.com/products/category/${widget.category}",
      ),
    );

    if (res.statusCode == 200) {
      return jsonDecode(res.body)['products'];
    } else {
      throw Exception("Failed to load products");
    }
  }

  @override
  Widget build(BuildContext context) {
    var themedata = Provider.of<ThemProvider>(context);
    return Scaffold(
      backgroundColor: themedata.black?Colors.black:Colors.greenAccent,
      appBar: AppBar(
        flexibleSpace: Container(
          decoration:   BoxDecoration(
            gradient: LinearGradient(
              colors: themedata.black
                  ? [Colors.grey.shade900, Colors.black]
                  : [Color(0xFF11998e), Color(0xFF38ef7d)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        title: Center(child: Text(widget.category.toUpperCase(),style: TextStyle(fontSize: 16,fontWeight: FontWeight.w600),)),
      ),
      body: FutureBuilder<List<dynamic>>(
        future: products,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return  Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          }

          final data = snapshot.data!;

          return GridView.builder(
            padding: const EdgeInsets.all(8),
            itemCount: data.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 8,
              crossAxisSpacing: 8,
            ),
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context)=>cat2(id: data[index]['id'].toString())));
                },
                child: Card(
                  color: themedata.black?Colors.grey.shade900:Colors.greenAccent.shade100,
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    children: [
                      Padding(
                        padding:  EdgeInsets.all(6),
                        child: Text(
                          data[index]['brand']??"Product".toString(),
                          textAlign: TextAlign.center,
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                      Expanded(
                        child: Image.network(
                          data[index]['thumbnail'],
                          fit: BoxFit.cover,
                        ),
                      ),
                      Padding(
                        padding:  EdgeInsets.all(6),
                        child: Text(
                          data[index]['title'],
                          textAlign: TextAlign.center,
                        ),
                        ),
                    ],
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
