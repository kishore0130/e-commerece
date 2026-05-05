import 'package:flutter/material.dart';
import 'package:product/cart.dart';
import 'package:product/category.dart';
import 'package:product/heart.dart';
import 'package:product/product.dart';
import 'package:product/settings.dart';
import 'package:provider/provider.dart';

import 'main.dart';

class bottom extends StatefulWidget {
  const bottom({super.key});

  @override
  State<bottom> createState() => _bottomState();
}

class _bottomState extends State<bottom> {
  int index =0;
  final Screen=[
    pro(),
    Cat(),
   pro2(),
    WishlistPage(),
  ];
  void tap(a){
    setState(() {
      index=a;
    });
  }
  @override
  Widget build(BuildContext context) {
    var themedata = Provider.of<ThemProvider>(context);
    return Scaffold(
     body: Screen[index],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient( colors: themedata.black
              ? [Colors.grey.shade900, Colors.black]
              : [Colors.white70 , Colors.white],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight)
        ),
        child: BottomNavigationBar(items: [
          BottomNavigationBarItem(icon: Icon(Icons.home,),label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.category_outlined,),label: 'Category'),
          BottomNavigationBarItem(icon: Icon(Icons.shopping_cart,),label: 'Cart'),
          BottomNavigationBarItem(icon: Icon(Icons.favorite,),label: 'WishList'),
        ],
          currentIndex: index,
          onTap: tap,
          selectedIconTheme: IconThemeData(
            color: themedata.black?Colors.white:Colors.black,
            size: 20
          ) ,
          selectedItemColor:themedata.black?Colors.white:Colors.black,
          unselectedItemColor: themedata.black?Colors.white:Colors.black,
          showSelectedLabels: true,
          showUnselectedLabels: false,
          backgroundColor: Colors.transparent,
          elevation: 0,
          type: BottomNavigationBarType.fixed,
        ),
      ),

    );
  }
}
