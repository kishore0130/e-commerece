import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'main.dart';
import 'notification.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({super.key});

  @override
  State<NotificationPage> createState() =>
      _NotificationPageState();
}

class _NotificationPageState
    extends State<NotificationPage> {

  @override
  void initState() {
    super.initState();
    start();
  }

  Future<void> start() async {
    await NotificationStore.loadNotifications();
    await NotificationStore.markAllRead();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    var themedata =
    Provider.of<ThemProvider>(context);

    return Scaffold(
      //backgroundColor: themedata.black ? Colors.black : Colors.greenAccent,
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: themedata.black
                  ? [Colors.grey.shade900, Colors.black]
                  : [Color(0xFF11998e), Color(0xFF38ef7d)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        centerTitle: true,
        title: Text("NOTIFICATIONS", style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16,),),
      ),
      body: NotificationStore.notifications.isEmpty
          ? Center(
        child:
        Text("No Notifications"),
      )
          : ListView.builder(
        itemCount: NotificationStore.notifications.length,
        itemBuilder: (context, index) {
          var n = NotificationStore.notifications[index];
          return Card(
            elevation: 10,
            color: themedata.black
                ? Colors.grey.shade900
                : Colors.white,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 6),
              child: ListTile(
                isThreeLine: true,
                leading: Icon(Icons.notifications, color:
                n["read"] ? Colors.grey : Colors.blue,
                ),
                title: Text(
                  n["title"],
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                subtitle:
                Text(
                  n["message"],
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                trailing:
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(n["time"].substring(11, 16),
                      style: TextStyle(fontSize: 12,),),

                    SizedBox(height: 4),

                    GestureDetector(
                      onTap:
                          () async {
                        await NotificationStore.deleteNotification(index);
                        setState(() {});
                      },
                      child:
                      Icon(Icons.delete, size: 20,
                      ),
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