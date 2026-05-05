import 'package:flutter/material.dart';
import 'notification.dart';
import 'notification1.dart';

class NotificationIcon extends StatefulWidget {
  const NotificationIcon({super.key});

  @override
  State<NotificationIcon> createState() =>
      _NotificationIconState();
}

class _NotificationIconState
    extends State<NotificationIcon> {

  @override
  void initState() {
    super.initState();
    load();
  }

  Future<void> load() async {
    await NotificationStore.loadNotifications();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        IconButton(
          icon: Icon(Icons.notifications),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => NotificationPage(),
              ),
            ).then((_) {
              setState(() {});
            });
          },
        ),

        if (NotificationStore.unreadCount > 0)
          Positioned(
            right: 5,
            top: 5,
            child: Container(
              padding: EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: Colors.red,
                shape: BoxShape.circle,
              ),
              child: Text(
                NotificationStore.unreadCount.toString(),
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 10,
                ),
              ),
            ),
          ),
      ],
    );
  }
}