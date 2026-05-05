import 'dart:convert';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart' show ImagePicker, XFile, ImageSource;
import 'package:product/cart.dart' show pro2;
import 'package:product/category.dart';
import 'package:product/product2.dart';
import 'package:product/settings.dart';
import 'package:product/splashscreen.dart';
import 'package:provider/provider.dart';

import 'My order.dart';
import 'bottom.dart';
import 'heart.dart';
import 'main.dart';
import 'notification1.dart';
import 'notification2.dart';

class pro extends StatefulWidget {
  const pro({super.key});

  @override
  State<pro> createState() => _proState();
}

class _proState extends State<pro> {
  File? pickImage;
  final ImagePicker _picker=ImagePicker();
  Future pickImageGallery() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image == null) return;
    setState(() {
      pickImage = File(image.path);
    });
  }
  Future pickImageCamera() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.camera);

    if (image == null) return;

    setState(() {
      pickImage = File(image.path);
    });
  }
  TextEditingController _controller=TextEditingController();
  int get(){
    return cart.fold(0, (sum, item) => sum+int.parse(item['qty'].toString()));
  }
  List text = [];
  Map<String,dynamic> data = {};
  List list = [];
  late var f1 = getdata();
  Future<Map<String,dynamic>> getdata()async{
    try{
      var res = await http.get(Uri.parse("https://dummyjson.com/products"));
      if(res.statusCode==200){
        setState(() {
          data=jsonDecode(res.body);
          list=data['products'];
          text=List.from(list);
        });
        print(list);
        return data;
      }else{
        throw Exception("No data Founded");
      }
    }
    catch(e){
      throw Exception(e);
    }
  }
  void search(String value){
    setState(() {
      if(value.isEmpty){
        text=List.from(list);
      }else{
        text=list.where((product){
          final title = product['title'].toString().toLowerCase();
          final brand = product['brand'].toString().toLowerCase();
          final id = product['id'].toString();
          return title.contains(value.toLowerCase())||
              brand.contains(value.toLowerCase())||
              id.contains(value.toLowerCase());
        }).toList();
      }
    });
  }
  void showImagePickerOption() {
    showModalBottomSheet(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: Icon(Icons.camera_alt, color: Colors.blue),
                title: Text("Camera"),
                onTap: () {
                  Navigator.pop(context);
                  pickImageCamera();
                },
              ),
              ListTile(
                leading: Icon(Icons.photo, color: Colors.green),
                title: Text("Gallery"),
                onTap: () {
                  Navigator.pop(context);
                  pickImageGallery();
                },
              ),
            ],
          ),
        );
      },
    );
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
           title: SizedBox(height: 45,
             child: TextFormField(
               controller: _controller,
               onChanged: search,
               decoration: InputDecoration(
                 filled: true,
                 hintText: 'Search Product',
                   border: OutlineInputBorder(borderRadius: BorderRadius.circular(9))
               ),
             ),
           ),
           actions: [
             NotificationIcon(),
             Padding(
               padding: const EdgeInsets.all(8.0),
               child: Stack(
                 children: [
                   IconButton(
               icon: Icon(Icons.shopping_cart_outlined),
                   onPressed: ()async{
                     final result = await Navigator.push(context,
                       MaterialPageRoute(builder: (context) => pro2()));
                     setState(() {});
                     if (result != null && result is String)
                     {
                       _controller.text = result;
                       search(result);
                     }
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
      drawer: Drawer(
        elevation: 10,
        backgroundColor: themedata.black?Colors.black:Colors.white,
        child: ListView(
          children: [
            // Container(
            //   width: double.infinity,
            //   padding: const EdgeInsets.symmetric(vertical: 25),
            //   decoration:  BoxDecoration(
            //     gradient: LinearGradient(
            //       colors: themedata.black
            //           ? [Colors.grey.shade900, Colors.black]
            //           : [Color(0xFF11998e), Color(0xFF38ef7d)],
            //       begin: Alignment.bottomCenter,
            //       end: Alignment.topCenter,
            //     ),
            //   ),
            //   child: Column(
            //     children: [
            //       GestureDetector(
            //         onTap: () {
            //           showImagePickerOption();
            //         },
            //         child:CircleAvatar(
            //           radius: 45,
            //           backgroundColor: Colors.white,
            //           backgroundImage: pickImage != null
            //               ? FileImage(pickImage!) as ImageProvider
            //               : null,
            //           child: pickImage == null
            //               ? Icon(Icons.person, size: 50, color: Colors.grey)
            //               : null,
            //         )
            //       ),
            //       SizedBox(height: 10),
            //       Text(
            //         "User",
            //         style: TextStyle(color: Colors.white, fontSize: 18,fontWeight: FontWeight.bold),
            //       ),
            //       Text(
            //         "View & Edit Profile",
            //         style: TextStyle(color: Colors.white70,fontSize: 14),
            //       ),
            //     ],
            //   ),
            // ),
            ListTile(
              leading:Icon(Icons.home) ,
              title: Text("Home"),
              trailing: Icon(Icons.arrow_forward_ios,),
              onTap: (){
                 Navigator.push(context, MaterialPageRoute(builder: (context)=>bottom()));
              },
            ),
            ListTile(
              leading:Icon(Icons.shopping_cart) ,
              title: Text("Cart"),
              trailing: Icon(Icons.arrow_forward_ios,),
              onTap: (){
                 Navigator.push(context, MaterialPageRoute(builder: (context)=>pro2()));
              },
            ),
            ListTile(
              leading: Icon(Icons.notifications),
              title: Text("Category"),
              trailing: Icon(Icons.arrow_forward_ios,),
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (context)=>Cat()));
              },
            ),
            ListTile(
              leading: Icon(Icons.favorite),
              title: Text("WishList"),
              trailing: Icon(Icons.arrow_forward_ios,),
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (context)=>WishlistPage()));
                          },
            ),
            ListTile(
              leading: Icon(Icons.card_travel,),
              title: Text("My Orders"),
              trailing: Icon(Icons.arrow_forward_ios,),
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (BuildContext)=>MyOrdersPage()));
              },
            ),
            ListTile(
              leading: Icon(Icons.notifications),
              title: Text("My Notification"),
              trailing: Icon(Icons.arrow_forward_ios),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => NotificationPage()),
                ).then((_) {
                  setState(() {});
                });
              },
            ),
            // ListTile(
            //   leading: Icon(Icons.settings),
            //   title: Text("Settings"),
            //   onTap: (){
            //     Navigator.push(context, MaterialPageRoute(builder: (context)=>qwe()));
            //               },
            // ),
            // Row(
            //   children: [
            //     Padding(
            //       padding: const EdgeInsets.all(8.0),
            //       child: Column(
            //         crossAxisAlignment: CrossAxisAlignment.start,
            //         children: [
            //           TextButton(onPressed: (){}, child: Text("Notification Preferences",style: TextStyle(color: Colors.blue),),),
            //           TextButton(onPressed: (){}, child: Text("Help Center",style: TextStyle(color: Colors.blue),),),
            //           TextButton(onPressed: (){}, child: Text("Legal",style: TextStyle(color: Colors.blue),),),
            //         ],
            //       ),
            //     ),
            //   ],
            // ),
            SizedBox(height: 200,),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(onPressed: (){
                setState(() {
                  showDialog(context: context, builder: (context)
                  {
                    return AlertDialog(
                      title: Text("Logout Conformation ",style: TextStyle(fontSize: 17),),
                      actions: [
                        TextButton(onPressed: (){
                          Navigator.pop(context);
                        }, child: Text("No",style: TextStyle(color: Colors.red),)),
                        TextButton(onPressed: () {
                          setState(() async{
                            await FirebaseAuth.instance.signOut();
                            Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (BuildContext)=>screen1()),(e){
                              return false;
                          });
                          });
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Logout Successfully")));
                        }, child: Text("Logout",style: TextStyle(color: Colors.blue),))
                      ],
                    );
                  }
                  );
                });
              },style:ElevatedButton.styleFrom(backgroundColor: themedata.black?Colors.white:Colors.white,elevation: 10),
                  child: Text("Logout".toUpperCase(),style: TextStyle(color: Colors.red,fontWeight: FontWeight.w600),)),
            ) ,
          //  SizedBox(height: 150,),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(18),
                  gradient: LinearGradient(
                    colors: themedata.black
                        ? [Colors.grey.shade900, Colors.black]
                        : [Colors.orange.shade100, Colors.yellow.shade50],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 8,
                      offset: Offset(0, 4),
                    )
                  ],
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    dropdownColor:
                    themedata.black ? Colors.grey.shade900 : Colors.white,
                    borderRadius: BorderRadius.circular(15),
                    icon: Icon(
                      Icons.keyboard_arrow_down_rounded,
                      color: themedata.black ? Colors.white : Colors.black,
                    ),
                    value: themedata.black ? "Dark Mode" : "Light Mode",
                    style: TextStyle(
                      color: themedata.black ? Colors.white : Colors.black,
                      fontWeight: FontWeight.w600,
                      fontSize: 15,
                    ),
                    items: [
                      DropdownMenuItem(
                        value: "Light Mode",
                        child: Row(
                          children: [
                            Icon(
                              CupertinoIcons.sun_max_fill,
                              color: Colors.orange,
                            ),
                            SizedBox(width: 10),
                            Text("Light Mode"),
                          ],
                        ),
                      ),
                      DropdownMenuItem(
                        value: "Dark Mode",
                        child: Row(
                          children: [
                            Icon(
                              Icons.nightlight_round,
                              color: Colors.blueGrey,
                            ),
                            SizedBox(width: 10),
                            Text("Dark Mode"),
                          ],
                        ),
                      ),
                    ],
                    onChanged: (value) {
                      if (value == "Dark Mode") {
                        themedata.theme(darkmode: true);
                      } else {
                        themedata.theme(darkmode: false);
                      }
                    },
                  ),
                ),
              ),
            )
          ],
        ),
      ),
      body:FutureBuilder(future: f1, builder: (context,snapshort){
        if(snapshort.connectionState==ConnectionState.waiting){
          return Center( child: CircularProgressIndicator());
        }else if (snapshort.hasError){
          return Text("Error : ${snapshort.error}");
        }else if (snapshort.hasData){
          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: text.length,
                    itemBuilder: (context,int index){
                  return GestureDetector(
                    onTap: ()async{
                      final result = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => productPage(
                            id: text[index]['id'].toString(),
                          ),
                        ),
                      );
                      if (result != null && result is String) {
                        _controller.text = result;
                        search(result);
                      }
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Card(
                        elevation: 4,
                        color: themedata.black?Colors.grey.shade900:Colors.white,
                        child: Column(
                          children: [
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  height: 150,
                                  width: 130,
                                  decoration: BoxDecoration(
                                    color: Colors.grey.shade200,
                                    image: DecorationImage(image: NetworkImage(text[index]['thumbnail'])),
                                  ),
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text("${text[index]['brand']??"Product".toString()}"),
                                    Text("(${text[index]['title']})",style: TextStyle(fontSize: 10.5),),
                                     Row(
                                       children: [
                                         RatingBarIndicator(
                                             itemCount: 5,
                                             rating: text[index]['rating'],
                                             itemSize: 20,
                                             itemBuilder: (context,int index)=>Icon(Icons.star,color: Colors.green.shade700,)),
                                         Text("(${text[index]['rating']})".toString()),
                                         SizedBox(width: 7),
                                         CircleAvatar(
                                           radius:10,
                                           backgroundImage: NetworkImage("https://cdn-icons-png.flaticon.com/512/2164/2164832.png"),
                                         ),
                                         Text("Assured",style: TextStyle(color: Colors.blue,fontWeight: FontWeight.bold,fontStyle: FontStyle.italic,fontSize: 12),)
                                       ],
                                     ),
                                    Row(
                                      children: [
                                        Icon(Icons.arrow_downward,color: Colors.green.shade700,size: 20,),
                                        Text("${text[index]['discountPercentage'].toString()}%",style: TextStyle(color: Colors.green.shade700,fontSize: 17,fontWeight: FontWeight.bold),),
                                       SizedBox(width: 10,),
                                        Text("₹${(text[index]['price'] + (text[index]['price'] * (text[index]['discountPercentage'] / 100))).toStringAsFixed(2)}",style: TextStyle(decoration: TextDecoration.lineThrough,color: Colors.grey.shade600,fontSize: 14,fontWeight: FontWeight.bold),),
                                        SizedBox(width: 10,),
                                        Text("₹${text[index]['price'].toString()}",style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 17),),
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
                                        ),)
                                      ],
                                    ),
                                    Text("Only ${text[index]['stock'].toString()} left",style: TextStyle(color: Colors.red,fontSize: 13),),
                                    Text("${text[index]['warrantyInformation']} by ${list[index]['brand']??"Brand"}",style: TextStyle(fontSize: 11.5,color: Colors.grey.shade500),)
                                  ],
                                ),
                              ],
                            ),
                            // Row(
                            //   children: [
                            //     Icon(CupertinoIcons.heart)
                            //   ],
                            // ),
                          ],
                        )
                      ),
                    ),
                  );
                }),
              )
            ],
          );
        }else{
            return Text("No Data Founded");
        }
      }) ,
    );
  }
}
