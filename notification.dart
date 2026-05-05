import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class NotificationStore {
  static List<Map<String, dynamic>> notifications = [];

  // Add Notification
  static Future<void> addNotification(
      String title,
      String message,
      ) async {
    notifications.insert(0, {
      "title": title,
      "message": message,
      "time": DateTime.now().toString(),
      "read": false,
    });

    await saveNotifications();
  }

  // Save Data
  static Future<void> saveNotifications() async {
    final prefs = await SharedPreferences.getInstance();

    List<String> list =
    notifications.map((e) => jsonEncode(e)).toList();

    await prefs.setStringList("notifications", list);
  }

  // Load Data
  static Future<void> loadNotifications() async {
    final prefs = await SharedPreferences.getInstance();

    List<String> list =
        prefs.getStringList("notifications") ?? [];

    notifications = list
        .map((e) => Map<String, dynamic>.from(jsonDecode(e)))
        .toList();
  }

  // Badge Count
  static int get unreadCount {
    return notifications
        .where((n) => n["read"] == false)
        .length;
  }

  // Mark Read
  static Future<void> markAllRead() async {
    for (var n in notifications) {
      n["read"] = true;
    }

    await saveNotifications();
  }

  // Delete Notification
  static Future<void> deleteNotification(int index) async {
    notifications.removeAt(index);
    await saveNotifications();
  }
}