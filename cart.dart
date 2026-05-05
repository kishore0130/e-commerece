import 'dart:convert';
import 'dart:io';
import 'package:product/bottom.dart';
import 'package:product/buynow.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart' show ImagePicker, XFile, ImageSource;
import 'package:product/cart.dart';
import 'package:product/main.dart';
import 'package:product/product.dart';
import 'package:product/product2.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'buynow.dart';


class pro2 extends StatefulWidget {
  const pro2({super.key});

  @override
  State<pro2> createState() => _pro2State();
}

class _pro2State extends State<pro2> {
  Future<void> saveCart() async {
    final prefs = await SharedPreferences.getInstance();

    List<String> cartList =
    cart.map((item) => jsonEncode(item)).toList();

    await prefs.setStringList("cartData", cartList);
  }

  Future<void> loadCart() async {
    final prefs = await SharedPreferences.getInstance();

    List<String> cartList =
        prefs.getStringList("cartData") ?? [];

    cart.clear();

    for (String item in cartList) {
      cart.add(jsonDecode(item));
    }

    setState(() {});
  }
  @override
  void initState() {
    super.initState();
    loadCart();
  }
  @override
  Widget build(BuildContext context) {
    var themedata = Provider.of<ThemProvider>(context);
    double grandTotal = 0;
    for (var product in cart) {
      grandTotal += product['price'] * product['qty'];
    }

    return Scaffold(
    //  backgroundColor: themedata.black?Colors.black:Colors.greenAccent,
      appBar: AppBar(
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
        title: Text("Cart Page".toUpperCase(),style: TextStyle(fontSize: 16,fontWeight: FontWeight.w600),),
        centerTitle: true,
      ),
      body: cart.isEmpty
          ?  Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Your Cart is Empty",style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold),),
                Image.asset("assets/cart1.png",height: 180,width: 200,),
                Text("You haven’t added anything to your cart yet.\nBrowse products and add them here when you’re ready to buy!",
                textAlign: TextAlign.center,),
                SizedBox(height: 20,),
                ElevatedButton(onPressed: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context)=>bottom()));
                },style: ElevatedButton.styleFrom(
                  backgroundColor: themedata.black?Colors.white:Colors.black,
                  fixedSize: Size(200, 50)
                ), child: Text("Shop Now",style: TextStyle(color: themedata.black?Colors.black:Colors.white),))
              ],
            ),
          )
          : ListView.builder(
        padding: const EdgeInsets.all(8.0),
        itemCount: cart.length,
        itemBuilder: (context, index) {
          final item = cart[index];
          return InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => productPage(
                        id: item["id"].toString(),
                      ),
                    ),
                  );
                },
            child: Card(
              color: themedata.black?Colors.grey.shade900:Colors.white70,
              margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    height: 80,
                    width: 80,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      image: DecorationImage(
                        image: NetworkImage(item['thumbnail'].toString()),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item['title'].toString(),
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 5),
                        Text(
                          "Price: ${item['price'].toString()} × ${item['qty'].toString()} Qty",
                          style: const TextStyle(fontSize: 13),
                        ),
                      ],
                    ),
                  ),
                  Column(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: const Text(
                                "Delete from cart?",
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
                                      cart.removeAt(index);
                                    });
                                    saveCart();
                                    Navigator.pop(context);
                                  },
                                  child: const Text(
                                    "Delete",
                                    style: TextStyle(color: Colors.red),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                      IconButton(onPressed: (){Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => buy(
                            id: cart[index]['id'].toString(),
                            qty: cart[index]['qty'].toString(),
                          ),
                        ),
                      );}, icon: Icon(Icons.shopping_cart_outlined,color: themedata.black?Colors.white:Colors.blue)),

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
