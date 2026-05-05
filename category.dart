import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:product/category2.dart';
import 'package:product/main.dart';
import 'package:provider/provider.dart' show Provider;

class Cat extends StatefulWidget {
  const Cat({super.key});

  @override
  State<Cat> createState() => _CatState();
}

class _CatState extends State<Cat> {
  File? pickImage;
  final ImagePicker _picker = ImagePicker();

  late Future<List<String>> f1;

  @override
  void initState() {
    super.initState();
    f1 = getdata();
  }

  Future<void> pickImageCamera() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.camera);
    if (image == null) return;

    setState(() {
      pickImage = File(image.path);
    });
  }

  List categoryImages = [
     "https://cdn-icons-png.flaticon.com/512/10274/10274533.png",
     "https://cdn-icons-png.flaticon.com/512/9361/9361223.png",
     "https://cdn-icons-png.flaticon.com/512/1198/1198368.png",
     "https://cdn-icons-png.flaticon.com/512/1261/1261163.png",
     "https://cdn-icons-png.flaticon.com/512/2621/2621957.png",
     "https://cdn-icons-png.flaticon.com/512/649/649224.png",
     "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRXqDk5-Jy1v7LpBYItqPFfdRepy-C6Qk62bA&s",
     "https://cdn-icons-png.flaticon.com/512/343/343296.png",
     "https://media.istockphoto.com/id/1272854630/vector/man-shoe-icon-isolated-mans-leather-shoe-symbol-vector.jpg?s=612x612&w=0&k=20&c=Hu9L59q8n7lJJ7ebXTcvhWyUcN7GAGbXULnh0Yt5TRE=",
     "https://static.thenounproject.com/png/2373796-200.png",
     "https://thumbs.dreamstime.com/b/illustration-icon-set-mobile-accessories-phone-101752555.jpg",
     "https://cdn-icons-png.flaticon.com/512/1986/1986937.png",
     "https://cdn-icons-png.flaticon.com/512/6075/6075429.png",
     "https://cdn-icons-png.flaticon.com/512/186/186239.png",
     "https://static.vecteezy.com/system/resources/thumbnails/069/410/418/small_2x/set-of-sports-accessories-school-sports-equipment-stickers-with-balls-rackets-skittles-set-of-icons-vector.jpg",
     "https://images.vexels.com/media/users/3/207335/isolated/preview/984b48f409b338621eba98f7661bcab0-sunglasses-icon-colorful-stroke.png?w=360",
     "https://static.vecteezy.com/system/resources/previews/021/768/403/non_2x/pills-icon-design-template-free-vector.jpg",
     "https://cdn-icons-png.freepik.com/512/4029/4029200.png",
     "https://images.rawpixel.com/image_png_800/cHJpdmF0ZS9sci9pbWFnZXMvd2Vic2l0ZS8yMDI0LTAyL3Jhd3BpeGVsb2ZmaWNlMTFfYV9ibGFja19zaWxob3VldHRlX2Nhcl9sb2dvX2ljb25fb25fYV93aGl0ZV9iYV9iYmFiMWM0YS1jZTVhLTRlM2ItOTY2ZC0yYTYzYTE4NDI0ZTVfMS5wbmc.png",
     "https://cdn-icons-png.flaticon.com/512/11057/11057831.png",
     "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSGNaP-bfSfcHGq6nqSo-tOxO0yU-iAHxJmyA&s",
     "https://static.vecteezy.com/system/resources/previews/033/868/898/non_2x/jewellery-icon-design-illustration-vector.jpg",
     "https://img.icons8.com/cotton/1200/women-shoes.jpg",
     "https://static.vecteezy.com/system/resources/thumbnails/023/332/454/small/wrist-watch-icon-vector.jpg",
  ];

  Future<List<String>> getdata() async {
    final res = await http.get(
      Uri.parse("https://dummyjson.com/products/category-list"),
    );

    if (res.statusCode == 200) {
      return List<String>.from(jsonDecode(res.body));
    } else {
      throw Exception("No data found");
    }
  }

  @override
  Widget build(BuildContext context) {
    var themedata = Provider.of<ThemProvider>(context);
    return Scaffold(
      //backgroundColor: themedata.black?Colors.black:Colors.greenAccent,
      appBar: AppBar(
        centerTitle: true,
        title:  Text("Category Page".toUpperCase(),style: TextStyle(fontWeight: FontWeight.w600,fontSize: 16),),
        flexibleSpace: Container(
          decoration:  BoxDecoration(
            gradient: LinearGradient(
              colors: themedata.black
            ? [Colors.grey.shade900, Colors.black]
                : [Color(0xFF11998e), Color(0xFF38ef7d)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
      ),

      body: FutureBuilder<List<String>>(
        future: f1,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          else if (snapshot.hasError) {
            return Center(child: Text("Error : ${snapshot.error}"));
          }
          else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
            return GridView.builder(
              padding: const EdgeInsets.all(8),
              itemCount: snapshot.data!.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 8,
                crossAxisSpacing: 8,
              ),
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CategoryProductsPage(
                          category: snapshot.data![index],
                        ),
                      ),
                    );
                  },

                  child: Card(
                    color: themedata.black?Colors.grey.shade900:Colors.white70,
                    elevation: 5,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.network(
                          categoryImages[index],
                          height: 80,
                          fit: BoxFit.contain,
                        ),
                        const SizedBox(height: 10),
                        Text(
                          snapshot.data![index],
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                );

              },
            );
          }
          else {
            return const Center(child: Text("No Data Found"));
          }
        },
      ),
    );
  }
}
