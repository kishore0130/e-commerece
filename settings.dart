import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:product/My%20order.dart';
import 'package:product/bottom.dart';
import 'package:product/cart.dart';
import 'package:product/category.dart';
import 'package:product/product.dart';
import 'package:provider/provider.dart';
//import 'package:provider/provider.dart';
import 'heart.dart';
import 'main.dart';
import 'notification1.dart';

class qwe extends StatefulWidget {
  const qwe({super.key});

  @override
  State<qwe> createState() => _qweState();
}

class _qweState extends State<qwe> {
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
  @override
  Widget build(BuildContext context) {
     var themedata = Provider.of<ThemProvider>(context);
    return Scaffold(
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
        title: Text("Settings"),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child:Switch(value:
            themedata.black, onChanged: (context){
              themedata.theme(darkmode:context);
            })
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 25),
              decoration:   BoxDecoration(
                gradient: LinearGradient(
                  colors: themedata.black
                      ? [Colors.grey.shade900, Colors.black]
                      : [Color(0xFF11998e), Color(0xFF38ef7d)],
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                ),
              ),
              child: Column(
                children: [
                  GestureDetector(
                    onTap: pickImageGallery,
                    child: CircleAvatar(
                      radius: 45,
                      backgroundColor: Colors.white,
                      backgroundImage:
                      pickImage != null ? FileImage(pickImage!) : null,
                      child: pickImage == null
                          ?  Icon(Icons.person, size: 50, color: Colors.grey)
                          : null,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    "User",
                    style: TextStyle(  color: themedata.black?Colors.white:Colors.white, fontSize: 18,fontWeight: FontWeight.bold),
                  ),
                  Text(
                    "View & Edit Profile",
                    style: TextStyle(color: Colors.white70,fontSize: 14),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListTile(
                leading: Icon(Icons.shopping_cart,),
                title: Text("My Cart",style: TextStyle( color: themedata.black?Colors.white:Colors.blue.shade900,),),
                trailing: Icon(Icons.arrow_forward_ios,),
                onTap: (){
                  Navigator.push(context, MaterialPageRoute(builder: (BuildContext)=>pro2()));
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListTile(
                leading: Icon(Icons.favorite,),
                title: Text("My WiseList",style: TextStyle(color: themedata.black?Colors.white:Colors.blue.shade900,),),
                trailing: Icon(Icons.arrow_forward_ios,),
                onTap: (){
                  Navigator.push(context, MaterialPageRoute(builder: (BuildContext)=>WishlistPage()));
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListTile(
                leading: Icon(Icons.menu,),
                title: Text("All Category",style: TextStyle(color: themedata.black?Colors.white:Colors.blue.shade900,),),
                trailing: Icon(Icons.arrow_forward_ios,),
                onTap: (){
                  Navigator.push(context, MaterialPageRoute(builder: (BuildContext)=>Cat()));
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListTile(
                leading: Icon(Icons.card_travel,),
                title: Text("My Orders",style: TextStyle(color: themedata.black?Colors.white:Colors.blue.shade900,),),
                trailing: Icon(Icons.arrow_forward_ios,),
                onTap: (){
                  Navigator.push(context, MaterialPageRoute(builder: (BuildContext)=>MyOrdersPage()));
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListTile(
                leading: Icon(Icons.notifications),
                title: Text("My Notification",style: TextStyle(color: themedata.black?Colors.white:Colors.blue.shade900,),),
                trailing: Icon(Icons.arrow_forward_ios),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => NotificationPage()),
                  ).then((_) {
                    setState(() {});
                  });
                },
              )
            ),
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextButton(onPressed: (){}, child: Text("Notification Preferences",style: TextStyle(color: Colors.blue),),),
                      TextButton(onPressed: (){}, child: Text("Help Center",style: TextStyle(color: Colors.blue),),),
                      TextButton(onPressed: (){}, child: Text("Legal",style: TextStyle(color: Colors.blue),),),
                    ],
                  ),
                ),
              ],
            ),
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
                          Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (BuildContext)=>bottom()),(e){
                            return false;
                          });
                        }, child: Text("Logout",style: TextStyle(color: Colors.blue),))
                      ],
                    );
                  }
                  );
                });
              },child: Text("Logout",style: TextStyle(color: Colors.red,),)),
            )
          ],
        ),
      ),
    );
  }
}