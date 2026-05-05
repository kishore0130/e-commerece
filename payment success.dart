import 'package:flutter/material.dart';
import 'My order.dart';

class PaymentSuccessPage extends StatefulWidget {
  final double totalprice;

  const PaymentSuccessPage({super.key, required this.totalprice});

  @override
  State<PaymentSuccessPage> createState() => _PaymentSuccessPageState();
}

class _PaymentSuccessPageState extends State<PaymentSuccessPage>
    with SingleTickerProviderStateMixin {

  late AnimationController _controller;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 2),
    )..forward();

    // Auto navigate to Orders page
    Future.delayed(Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => MyOrdersPage()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: ScaleTransition(
          scale: CurvedAnimation(
              parent: _controller, curve: Curves.easeInOut),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.check_circle, color: Colors.green, size: 100),
              SizedBox(height: 20),
              Text("Payment Successful",
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
              SizedBox(height: 10),
              Text("₹${widget.totalprice}",
                  style: TextStyle(fontSize: 18, color: Colors.grey)),
            ],
          ),
        ),
      ),
    );
  }
}