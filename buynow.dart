import 'dart:convert';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:product/main.dart';
import 'package:product/payment%20success.dart';
import 'package:product/product2.dart' show cart;
import 'package:provider/provider.dart' show Provider;
import 'package:shared_preferences/shared_preferences.dart';
import 'notification.dart';
import 'order store.dart';


class buy extends StatefulWidget {
  String id;
  String qty;

  buy({super.key,required this.id,required this.qty});

  @override

  State<buy> createState() => _buyState(); }

  enum PaymentMethod { upi, netBanking, cod }

class _buyState extends State<buy> {
  TextEditingController name=TextEditingController();
  TextEditingController phone=TextEditingController();
  TextEditingController address=TextEditingController();
  TextEditingController pincode=TextEditingController();
  PaymentMethod? selectedPayment;
  Map<String,dynamic> data={};
  late var f1 = getdata();
  Future<Map<String,dynamic>>getdata()async{
    try{
      var res = await http.get(Uri.parse("https://dummyjson.com/products/${widget.id}"));
      var body = jsonDecode(res.body);
      print(res.body);
      if(res.statusCode==200){
        data=body;
        print(data);
        return data;
      }else{
        throw Exception("fail to load");
      }
    }catch(e){
      throw Exception(e);
    }
  }
  Future<void> saveOrders() async {
    final prefs = await SharedPreferences.getInstance();

    List<String> list =
    OrderStore.orders.map((item) => jsonEncode(item)).toList();

    await prefs.setStringList("orders", list);
  }
  @override
  Widget build(BuildContext context) {

    var themedata = Provider.of<ThemProvider>(context);
    return Scaffold(
    //  backgroundColor: themedata.black?Colors.black:Colors.greenAccent,

      appBar: AppBar(
        centerTitle: true,
        flexibleSpace: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(colors: themedata.black
                  ? [Colors.grey.shade900, Colors.black]
                  : [Color(0xFF11998e), Color(0xFF38ef7d)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight
              )
          ),
        ),
        title: Text("Order Now".toUpperCase(),style: TextStyle(fontWeight: FontWeight.w600,fontSize: 16),),
      ),
      body:FutureBuilder(future: f1, builder: (context,snapshort) {
        if (snapshort.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        } else if (snapshort.hasError) {
          return Text("Error : ${snapshort.error}");
        } else if (snapshort.hasData) {
          int qty = int.parse(widget.qty);
          double totalprice=data['price']*qty;
          return SingleChildScrollView(
            child: Column(
              children: [
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text("Shipping Address :",style: TextStyle(fontWeight: FontWeight.bold),),
                    )
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    controller: name,
                    decoration: InputDecoration(
                      labelText: "Full Name",
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.person),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    controller: phone,
                    keyboardType: TextInputType.phone,
                    decoration: InputDecoration(
                      labelText: "Phone Number",
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.phone),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    controller: address,
                    decoration: InputDecoration(
                      labelText: "Full Address",
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.home),
                    ),
                    maxLines: 3,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    controller: pincode,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: "Pincode",
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.pin_drop),
                    ),
                  ),
                ),
                Divider(color: themedata.black?Colors.white:Colors.black),
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text("product Details :",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 15),),
                    )
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Card(
                    elevation: 5,
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
                                  image: DecorationImage(image: NetworkImage(data['thumbnail'])),
                                ),
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("${data['brand']??"Product".toString()}"),
                                  Text("(${data['title']})",style: TextStyle(fontSize: 10.5),),
                                  Row(
                                    children: [
                                      RatingBarIndicator(
                                          itemCount: 5,
                                          rating: data['rating'],
                                          itemSize: 20,
                                          itemBuilder: (context,int index)=>Icon(Icons.star,color: Colors.green.shade700,)),
                                      Text("(${data['rating']})".toString()),
                                      SizedBox(width: 7),
                                      CircleAvatar(
                                        radius:8,
                                        backgroundImage: NetworkImage("https://cdn-icons-png.flaticon.com/512/2164/2164832.png"),
                                      ),
                                      Text("Assured",style: TextStyle(color: Colors.blue,fontWeight: FontWeight.bold,fontStyle: FontStyle.italic,fontSize: 12),)
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Icon(Icons.arrow_downward,color: Colors.green.shade700,size: 20,),
                                      Text("${data['discountPercentage'].toString()}%",style: TextStyle(color: Colors.green.shade700,fontSize: 17,fontWeight: FontWeight.bold),),
                                      SizedBox(width: 6,),
                                      Text("₹${(data['price'] + (data['price'] * (data['discountPercentage'] / 100))).toStringAsFixed(2)}",style: TextStyle(decoration: TextDecoration.lineThrough,color: Colors.grey.shade600,fontSize: 14,fontWeight: FontWeight.bold),),
                                      SizedBox(width: 10,),
                                      Text("₹${data['price'].toString()}",style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontSize: 17),),
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
                                        color: Colors.blue.shade800,),)
                                    ],
                                  ),
                                  Text("Only ${data['stock'].toString()} left",style: TextStyle(color: Colors.red,fontSize: 13),),
                                  Text("${data['warrantyInformation']} by ${data['brand']??"Brand"}",style: TextStyle(fontSize: 11.5,color: Colors.grey.shade500),)
                                ],
                              ),
                            ],
                          ),
                        ],
                      )
                  ),
                ),
                Divider(color: themedata.black?Colors.white:Colors.black),
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text("Price Details :",style: TextStyle(fontWeight: FontWeight.bold),),
                    ),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    height: 200,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child:Card(
                      color: themedata.black?Colors.grey.shade900:Colors.white,
                      margin: EdgeInsets.all(12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      elevation: 4,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text("M.R.P :",style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold),),
                                Text("₹${(data['price'] + (data['price'] * (data['discountPercentage'] / 100))).toStringAsFixed(2)}",style: TextStyle(fontSize: 20,color: Colors.red
                                ),),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text("Discount% :",style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold),),
                                Text("%${data['discountPercentage']}".toString(),style: TextStyle(fontSize: 20,color: Colors.green
                                ),),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text("Price :",style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold),),
                                Text("₹${data['price'].toString()}",style: TextStyle(fontSize: 20
                                ),),
                              ],
                            ),
                            Row(
                              mainAxisAlignment:MainAxisAlignment.spaceBetween,
                              children: [
                                Text("Quantity :",style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold),),
                                Text("${widget.qty} qty".toString(),style: TextStyle(fontSize: 16,color: Colors.blue),),
                              ],
                            ),
                            Divider(),
                            Row(
                              mainAxisAlignment:MainAxisAlignment.spaceBetween,
                              children: [
                                Text("Total Price :",style: TextStyle(fontWeight: FontWeight.bold,fontSize:18 ),),
                                Text("₹${totalprice}",style: TextStyle(color: Colors.greenAccent.shade700,fontSize: 16),)
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                Divider(color: themedata.black?Colors.white:Colors.black),
                Row(
                  children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text("Payment Method :",style: TextStyle(fontWeight: FontWeight.bold),),
                  ),
                  ],
                ),
                Card(
                  color: themedata.black?Colors.grey.shade900:Colors.white,
                  margin: EdgeInsets.all(12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  elevation: 4,
                  child: Column(
                    children: [
                      ListTile(
                        leading: IconButton(onPressed: (){
                          setState(() {
                            selectedPayment=PaymentMethod.upi;
                          });
                          },
                            icon: Icon(selectedPayment==PaymentMethod.upi?Icons.radio_button_checked:Icons.radio_button_unchecked,
                              color: selectedPayment==PaymentMethod.upi?Colors.green:Colors.grey,)),
                        title: Text("Pay by any UPI App"),
                        subtitle: Text("Google Pay,PhonePe,Paytm and more"),
                        trailing: Container(
                          height: 50,
                          width: 50,
                          child: Image.network("https://www.shutterstock.com/image-vector/unified-payments-interface-upi-logo-260nw-2327361425.jpg")
                        ),
                      )
                    ],
                  ),
                ),
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text("CREDIT & DEBIT CARDS",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 15),),
                    ),
                  ],
                ),
                Card(
                  color: themedata.black?Colors.grey.shade900:Colors.white,
                  margin: EdgeInsets.all(12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  elevation: 4,
                  child: Column(
                    children: [
                      ListTile(
                        leading: IconButton(onPressed: (){
                          setState(() {
                            selectedPayment=PaymentMethod.netBanking;
                          });
                          },
                            icon: Icon(selectedPayment==PaymentMethod.netBanking?Icons.radio_button_checked:Icons.radio_button_unchecked,
                              color: selectedPayment==PaymentMethod.netBanking?Colors.green:Colors.grey,)),
                        title: Text("Net Banking"),
                        trailing: Container(
                          height: 30,
                          width: 50,
                          child: Image.network("https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSJOQfwPo4FZRrYdBgh7mLKtMJKQCc-VWLTFg&s"),
                        ),
                      )
                    ],
                  ),
                ),
                Card(
                  color: themedata.black?Colors.grey.shade900:Colors.white,
                  margin: EdgeInsets.all(12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  elevation: 4,
                  child: Column(
                    children: [
                      ListTile(
                        leading: IconButton(onPressed: (){
                          setState(() {
                            selectedPayment=PaymentMethod.cod;
                          });
                          },
                            icon: Icon(selectedPayment==PaymentMethod.cod?Icons.radio_button_checked:Icons.radio_button_unchecked,
                              color: selectedPayment==PaymentMethod.cod?Colors.green:Colors.grey,)),
                        title: Text("cash on Delivery/Pay on Delivery"),
                        subtitle: Text("Cash,UPI and Card accepted."),
                        trailing: Container(
                          height: 50,
                          width: 50,
                          child: Image.network("https://cdn.iconscout.com/icon/free/png-256/free-cash-on-delivery-icon-svg-download-png-1569374.png"),
                        ),
                      )
                    ],
                  ),
                ),
                Card(
                  color: themedata.black?Colors.grey.shade900:Colors.white,
                  margin: EdgeInsets.all(12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  elevation: 4,
                  child: Column(
                    children: [
                      ListTile(
                        title: Text("Add Gift Card or Promo Code",style: TextStyle(color: Colors.blue),),
                        subtitle: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8.0),
                          child: Row(
                            children: [
                              SizedBox(
                                width: 140,
                                height: 40,
                                child: TextFormField(
                                  decoration: InputDecoration(
                                      labelText: 'Enter Code',
                                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(15))
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 4.0),
                                child: ElevatedButton(onPressed: (){},style: ElevatedButton.styleFrom(
                                    fixedSize: Size(90, 30),
                                    backgroundColor: Colors.yellow.shade700,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(15),
                                    )
                                ), child: Text("Apply",style: TextStyle(color: themedata.black?Colors.white:Colors.white),)),
                              )
                            ],
                          ),
                        ),
                        trailing: Container(
                          height: 50,
                          width: 50,
                          child: Image.network("https://static.vecteezy.com/system/resources/previews/003/329/433/non_2x/line-icon-for-promocode-vector.jpg"),
                        ),
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                        onPressed: () {
                          if (name.text.isEmpty ||
                              phone.text.isEmpty ||
                              address.text.isEmpty) {
                            ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text("Please fill all details")));
                            return;
                          }
                          if (selectedPayment == null) {
                            ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text("Select payment method")));
                            return;
                          }
                          OrderStore.orders.add({
                            "name": name.text,
                            "phone": phone.text,
                            "address": address.text,
                            "pincode": pincode.text,
                            "product": data,
                            "qty": widget.qty,
                            "total": totalprice,
                            "payment": selectedPayment?.name.toUpperCase(),
                            "status": "Processing",
                            "date": DateTime.now().toString(),
                          });
                          saveOrders();
                          NotificationStore.addNotification(
                            "Order Placed".toUpperCase(),
                            "Your order for ${data['title']} placed successfully",
                          );
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  PaymentSuccessPage(totalprice: totalprice),
                            ),

                          );
                          },style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.amber
                    ), child: Text("Buy at ₹ ₹${totalprice}",style: TextStyle(fontSize: 18,color: themedata.black?Colors.white:Colors.white),)),
                  ),
                )
              ],
            ),
          );
        }else{
          return Text("No Data Founded");
        }
      }),
    );
  }
}