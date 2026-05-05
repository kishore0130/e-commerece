import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:product/order%20product.dart';
import 'package:product/product2.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'main.dart';
import 'notification.dart';
import 'order store.dart';

class MyOrdersPage extends StatefulWidget {
  const MyOrdersPage({super.key});

  @override
  State<MyOrdersPage> createState() => _MyOrdersPageState();
}

class _MyOrdersPageState extends State<MyOrdersPage> {
  Future<void> saveOrders() async {
    final prefs = await SharedPreferences.getInstance();

    List<String> list = OrderStore.orders
        .map((item) => jsonEncode(item))
        .toList();

    await prefs.setStringList("orders", list);
  }

  Future<void> loadOrders() async {
    final prefs = await SharedPreferences.getInstance();

    List<String> list =
        prefs.getStringList("orders") ?? [];

    OrderStore.orders.clear();

    for (String item in list) {
      OrderStore.orders.add(jsonDecode(item));
    }

    setState(() {});
  }
  @override
  void initState() {
    super.initState();
    loadOrders();
  }

  @override
  Widget build(BuildContext context) {
    var themedata = Provider.of<ThemProvider>(context);
    return Scaffold(
     // backgroundColor: themedata.black?Colors.black:Colors.greenAccent,
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
          centerTitle: true,
          title: Text("my orders".toUpperCase(),style: TextStyle(fontWeight: FontWeight.w600,fontSize: 16),)),
      body: OrderStore.orders.isEmpty
          ? Center(child: Text("No Orders Yet"))
          : ListView.builder(
        itemCount: OrderStore.orders.length,
        itemBuilder: (context, index) {
          var order = OrderStore.orders[index];

          return InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => 
                      orderProduct(
                    id: order["product"]["id"].toString(),
                  ),
                ),
              );
            },
            child: Card(
              color: themedata.black?Colors.grey.shade900:Colors.white,
              elevation: 5,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15),
              ),
              margin: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.network(
                        order["product"]["thumbnail"],
                        width: 70,
                        height: 70,
                        fit: BoxFit.cover,
                      ),
                    ),
                    SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            order["product"]["title"],
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 5),
                          Text(
                            "Quantity: ${order["qty"]}",
                            style: TextStyle(color: Colors.grey[700]),
                          ),
                          Text(
                            "Total Price: ₹${order["total"]}",
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.green,
                            ),
                          ),

                          SizedBox(height: 4),

                          Text(
                            "Address: ${order["address"] ?? ""}",
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[600],
                            ),
                          ),

                          SizedBox(height: 6),

                          Row(
                            children: [
                              Icon(Icons.payment, size: 14, color: Colors.blue),
                              SizedBox(width: 4),
                              Text(
                                order["payment"],
                                style: TextStyle(
                                  color: Colors.blue,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              SizedBox(width: 10),
                              Icon(Icons.local_shipping,
                                  size: 14, color: Colors.orange),
                              SizedBox(width: 4),
                              Text(
                                order["status"],
                                style: TextStyle(
                                  color: Colors.orange,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    Column(
                      children: [
                        TextButton(
                          onPressed: () {
                            setState(() {
                              OrderStore.orders.removeAt(index);
                            });
                            saveOrders();
                            NotificationStore.addNotification(
                              "Order Canceled".toUpperCase(),
                              "Your order for ${order['title']} Canceled",
                            );
                          },
                          child: Text(
                            "Cancel",
                            style: TextStyle(
                              color: Colors.red,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}