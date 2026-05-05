import 'dart:convert';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:dots_indicator/dots_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:http/http.dart' as http;
import 'package:carousel_slider/carousel_controller.dart';
import 'package:product/buynow.dart';
import 'package:product/cart.dart' show pro2;
import 'package:product/category.dart';
import 'package:product/main.dart';
import 'package:product/notification2.dart';
import 'package:product/product.dart';
import 'package:provider/provider.dart' show Provider;
import 'package:shared_preferences/shared_preferences.dart';

import 'category2.dart';

class cat2 extends StatefulWidget {
  String id;
  cat2({super.key,required this.id});

  @override
  State<cat2> createState() => _cat2State();
}
List<Map<String,dynamic>> cart=[];
List<String> _list= <String>['1','2','3','4','5','6'];
class _cat2State extends State<cat2> {
  TextEditingController _editingController =TextEditingController();
  Future<void> toggleWishlist(String productId) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> wishlist = prefs.getStringList('wishlist') ?? [];

    if (wishlist.contains(productId)) {
      wishlist.remove(productId);
      _is = false;
    } else {
      wishlist.add(productId);
      _is = true;
    }

    await prefs.setStringList('wishlist', wishlist);
    setState(() {});
  }
  Future<void> checkWishlist(String productId) async {
    final prefs = await SharedPreferences.getInstance();
    List<String> wishlist = prefs.getStringList('wishlist') ?? [];

    setState(() {
      _is = wishlist.contains(productId);
    });
  }

  int get(){
    return cart.fold(0, (sum, item) => sum+int.parse(item['qty'].toString()));
  }
  String dropdownvalue = _list.first;
  String dropdownvalue1 = _list.first;
  bool _is = false;
  int _currentindex=0;
  Map<String,dynamic> data={};
  late Future<Map<String, dynamic>> f1;

  @override
  void initState() {
    super.initState();
    f1 = getdata();
  }

  Future<Map<String, dynamic>> getdata() async {
    final res = await http.get(
      Uri.parse("https://dummyjson.com/products/${widget.id}"),
    );

    if (res.statusCode == 200) {
      return jsonDecode(res.body);
    } else {
      throw Exception("Product not found");
    }
  }
  @override
  Widget build(BuildContext context) {
    var themedata = Provider.of<ThemProvider>(context);
    return Scaffold(
      backgroundColor: themedata.black?Colors.black:Colors.green.shade200,
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
        title: Text(data["brand"]??"Product".toUpperCase(),style: TextStyle(fontSize: 16,fontWeight: FontWeight.w600),),
        actions: [
          NotificationIcon(),
          Padding(
              padding: const EdgeInsets.all(8.0),
              child:Stack(
                children: [
                  IconButton(
                    icon: Icon(Icons.shopping_cart_outlined),
                    onPressed: (){
                      Navigator.push(context, MaterialPageRoute(builder: (context)=>pro2())).then((_)=>setState(() {}));
                    },
                  ),
                  if(cart.isNotEmpty)Positioned(
                    right: 6,
                    top: 6,
                    child: Container(
                      padding: EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                      ),
                      child: Text(
                        get().toString(),
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              )
          ),
        ],
      ),
      body:FutureBuilder(future: f1, builder: (context,snapshort) {
        if (snapshort.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshort.hasError) {
          return Text("Error : ${snapshort.error}");
        } else if (snapshort.hasData) {
          data = snapshort.data!;
          return SingleChildScrollView(
            child: Column(
                crossAxisAlignment:CrossAxisAlignment.start,
                children: [
                  CarouselSlider.builder(
                    itemCount: 3,
                    itemBuilder: (BuildContext context, int itemIndex, int pageViewIndex) {
                      return Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                            color: themedata.black?Colors.grey.shade900:Colors.greenAccent.shade100,
                            image: DecorationImage(image: NetworkImage(data['thumbnail']))
                        ),
                      );
                    },
                    options:
                    CarouselOptions(
                      height: 300,
                      aspectRatio: 10/9,
                      viewportFraction: 1,
                      initialPage: 0,
                      enableInfiniteScroll: true,
                      reverse: false,
                      autoPlay: false,
                      autoPlayInterval: Duration(seconds: 3),
                      autoPlayAnimationDuration: Duration(milliseconds: 800),
                      autoPlayCurve: Curves.decelerate,
                      enlargeCenterPage: true,
                      enlargeFactor: 0.3,
                      onPageChanged:(index,reason){
                        setState(() {
                          _currentindex= index;
                        });
                      },
                      scrollDirection: Axis.horizontal,
                    ),
                  ),
                  Row(
                    children: [
                      SizedBox(width: 150,),
                      DotsIndicator(
                        dotsCount: 3,
                        position: _currentindex.toDouble(),
                        decorator: DotsDecorator(
                          color: Colors.black87,
                          activeColor: Colors.blue,
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          SizedBox(width: 65,),
                          IconButton(onPressed: (){
                            toggleWishlist(data['id'].toString());
                          }, icon: Icon(_is?Icons.favorite:Icons.favorite_border_outlined,
                            color: _is?Colors.red:Colors.orangeAccent,)),
                          IconButton(onPressed: (){}, icon: Icon(Icons.share_outlined,color: Colors.orangeAccent,)),
                        ],
                      )
                    ],
                  ),
                  Row(
                    children: [
                      Container(
                        height: 30,
                        width: 50,
                        decoration: BoxDecoration(
                            image: DecorationImage(image: NetworkImage("https://media.istockphoto.com/id/915255348/vector/wow.jpg?s=170667a&w=0&k=20&c=t1cok8QqopjiU55pAirYckg8U8qouUu8QMtFx3mtwdA="))
                        ),
                      ),
                      Text("Exclusive Offers",style: TextStyle(
                        color: Colors.blue.shade800,
                      ),),
                    ],
                  ),
                  Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: Container(
                          height: 23,
                          width: 120,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(3),
                            color: Colors.red.shade700,
                          ),
                          child: Center(
                            child: RichText(
                              text:TextSpan(text: 'Limited time deal',
                                  style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold)),
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 101,),
                      Text("${data["rating"].toString()} ",
                        style: TextStyle(fontWeight: FontWeight.normal,fontSize: 12,color: Colors.black),),
                      RatingBarIndicator(
                        itemCount: 5,
                        rating: (data['rating'] as num).toDouble(),
                        itemSize: 13,
                        itemBuilder: (context, _) =>
                            Icon(Icons.star, color: Colors.green.shade700),
                      ),

                      Text("(549)",style: TextStyle(color: Colors.blue.shade700,fontSize: 12),),
                      SizedBox(width: 15,),
                    ],
                  ),
                  Row(
                    children: [
                      Icon(Icons.arrow_downward,color: Colors.green.shade700,),
                      RichText(text: TextSpan(
                        text: "${data['discountPercentage']}%".toString(),style: TextStyle(color: Colors.green.shade700,fontSize:
                      23,fontWeight: FontWeight.normal),
                      )),
                      SizedBox(width: 10,),
                      Text("₹"),
                      Text("${data['price']}".toString(),style: TextStyle(fontWeight: FontWeight.bold,
                          fontSize: 35),)
                    ],
                  ),
                  Row(
                    children: [
                      SizedBox(width: 5,),
                      Text("M.R.P :",style: TextStyle(color: Colors.grey.shade600),),
                      RichText(text: TextSpan(
                        text: "₹${(
                            (data['price'] as num) +
                                ((data['price'] as num) * ((data['discountPercentage'] as num) / 100))
                        ).toStringAsFixed(2)
                        }",style: TextStyle(
                          decoration: TextDecoration.lineThrough,
                          color: Colors.grey.shade600,fontSize: 16
                      ),
                      )),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Text("${data['availabilityStatus']}",style: TextStyle(color: Colors.green),),
                  ),
                  Divider(color: themedata.black?Colors.white:Colors.black),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text("Brand :",style: TextStyle(fontSize: 17),),
                            Text(" ${data['brand']??"No Mention"}",style: TextStyle(fontSize: 15),),
                          ],
                        ),
                        Text("(${data['title']})",style: TextStyle(fontSize: 14),),
                        Row(
                          children: [
                            Text("Category :",style: TextStyle(fontSize: 17),),
                            Text(" ${data['category']}",style: TextStyle(fontSize: 15),),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Divider(color: themedata.black?Colors.white:Colors.black),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10.0),
                    child: Text("Product Description : ",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 17),),
                  ),
                  SizedBox(height:5,),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 5.0),
                    child: Text(data['description']),
                  ),
                  Divider(color: themedata.black?Colors.white:Colors.black),
                  Column(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          ElevatedButton(onPressed: (){
                            setState(() {
                              int index = cart.indexWhere(
                                    (item) => item['id'] == data['id'],
                              );
                              int qty = int.parse(dropdownvalue);
                              if (index != -1) {
                                cart[index]['qty'] += qty;
                              } else {
                                cart.add({
                                  "id": data['id'],
                                  "title": data['title'],
                                  "price": data['price'],
                                  "thumbnail": data['thumbnail'],
                                  "qty": qty,
                                });
                              }
                            });
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Added to Cart")));
                          },
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.yellow.shade700,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  )
                              ),
                              child: Icon(Icons.add_shopping_cart,color: Colors.black87,)),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Container(
                              height: 40,
                              width:250,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: Colors.blue
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text("Quantity :"),
                                  DropdownButton<String>(
                                    value: dropdownvalue,
                                    icon:  Icon(Icons.keyboard_arrow_down_sharp),
                                    elevation: 10,
                                    style: TextStyle(color: Colors.black),
                                    underline: Container(height: 2, color: Colors.deepPurpleAccent),
                                    onChanged: (String? value) {
                                      setState(() {
                                        dropdownvalue = value!;
                                      });
                                    },
                                    items: _list.map<DropdownMenuItem<String>>((String value) {
                                      return DropdownMenuItem<String>(value: value, child: Text(value));
                                    }).toList(),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 3.0),
                          child:SizedBox(width: double.infinity,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: ElevatedButton(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => buy(
                                        id: data['id'].toString(),
                                        qty: dropdownvalue,
                                      ),
                                    ),
                                  );
                                },
                                style: ElevatedButton.styleFrom(
                                  fixedSize: const Size(150, 40),
                                  backgroundColor: Colors.grey.shade400,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                child:Text(
                                  "Buy Now at ₹${data['price']}",
                                  style: const TextStyle(fontWeight: FontWeight.bold,color: Colors.black),
                                ),
                              ),
                            ),
                          )

                      ),
                    ],
                  ),
                  Divider(color: themedata.black?Colors.white:Colors.black),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Text("Information about Warranty and Shipping :",style: TextStyle(fontSize: 17,fontWeight: FontWeight.bold),),
                  ),
                  Row(
                    children: [
                      SizedBox(width: 5,),
                      Text("Warranty :",style: TextStyle(fontSize: 15),),
                      Text(data['warrantyInformation']),
                    ],
                  ),
                  Row(
                    children: [
                      SizedBox(width: 5,),
                      Text("Shipping :",style: TextStyle(fontSize: 15),),
                      Text(data['shippingInformation']),
                    ],
                  ),
                  Divider(color: themedata.black?Colors.white:Colors.black),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Text(
                      "Reviews :",
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
                    ),
                  ),

                  if (data['reviews'] == null || data['reviews'].isEmpty)
                    Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Text(
                        "No reviews available",
                        style: TextStyle(color: Colors.grey),
                      ),
                    )
                  else
                    ListView.builder(
                      shrinkWrap: true,
                      physics: NeverScrollableScrollPhysics(),
                      itemCount: data['reviews'].length,
                      itemBuilder: (context, index) {
                        final r = data['reviews'][index];

                        return Card(
                          color: themedata.black?Colors.grey.shade900:Colors.greenAccent.shade100,
                          margin: EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    CircleAvatar(
                                      radius: 18,
                                      child: Icon(Icons.person, size: 18),
                                    ),
                                    SizedBox(width: 8),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            r['reviewerName'],
                                            style: TextStyle(fontWeight: FontWeight.bold),
                                          ),
                                          Text(
                                            r['reviewerEmail'],
                                            style: TextStyle(fontSize: 12),
                                          ),
                                        ],
                                      ),
                                    ),
                                    RatingBarIndicator(
                                      rating: r['rating'].toDouble(),
                                      itemCount: 5,
                                      itemSize: 14,
                                      itemBuilder: (_, __) =>
                                          Icon(Icons.star, color: Colors.green),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 6),
                                Text("Comment: ${r['comment']}"),
                                SizedBox(height: 4),
                                Text(
                                  "Date: ${r['date']}",
                                  style: TextStyle(fontSize: 12, color: Colors.grey),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),

                  // Divider(color: themedata.black?Colors.white:Colors.black,),
                  // Padding(
                  //   padding: const EdgeInsets.symmetric(horizontal: 10.0),
                  //   child: Text("Category : ",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 17),),
                  // ),
                  // GestureDetector(
                  //   onTap: (){
                  //     Navigator.push(context, MaterialPageRoute(builder: (BuildContext)=>Cat()));
                  //   },
                  //   child: GridView.builder(
                  //     padding: const EdgeInsets.all(8),
                  //     itemCount:data1.length ,
                  //     shrinkWrap: true,
                  //     gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  //       crossAxisCount: 3,
                  //       mainAxisSpacing: 8,
                  //       crossAxisSpacing: 8,
                  //     ),
                  //     itemBuilder: (context, index) {
                  //       return Card(
                  //         color: themedata.black?Colors.grey.shade900:Colors.greenAccent.shade100,
                  //         elevation: 4,
                  //         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  //         child: Column(
                  //           mainAxisAlignment: MainAxisAlignment.center,
                  //           children: [
                  //             Image.network(data1[index])
                  //           ],
                  //         ),
                  //       );
                  //
                  //     },
                  //   ),
                  // ),
                  // TextButton(onPressed: (){
                  //   Navigator.push(context, MaterialPageRoute(builder: (BuildContext)=>Cat()));
                  // }, child: Row(
                  //   children: [
                  //     Icon(Icons.arrow_forward),
                  //     Text("Tap to View All Category")
                  //   ],
                  // ))
                ]
            ),
          );
        }else{
          return Text("No Data Founded");
        }
      }),
    );
  }
}
