import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:provider/provider.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;

import '../models/todo_list_response_model.dart';
import '../models/todo_model.dart';
import '../services/dio_service.dart';

class ToDoListScreenProvider with ChangeNotifier {
  final List<ToDo> _todos = [];

  List<ToDo> get todos => _todos;

  final List<ToDoListResponseModel> todoListResponse = [];

  bool _deleteMode = false;
  bool get deleteMode => _deleteMode;

  final FlutterLocalNotificationsPlugin _localNotificationsPlugin =
  FlutterLocalNotificationsPlugin();

  // Create an instance of the DioService
  final DioService _dioService = DioService();

  // Fetch ToDo list from the API when the provider is initialized
  Future<void> fetchToDos() async {
    try {
      Response? response = await _dioService.getRequest('/todos');
      if (response != null && response.statusCode == 200) {
        List<dynamic> data = response.data;
        print("responseData: ${response.data}");
        todoListResponse.clear();  // Clear any existing ToDos
        todoListResponse.addAll(data.map((todo) => ToDoListResponseModel.fromJson(todo)).toList()); // Map response to ToDo
        notifyListeners();
      } else {
        print('Error fetching todos: ${response?.statusMessage}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }


  void addToDo(ToDoListResponseModel todo) {
    todoListResponse.insert(0, todo);
    notifyListeners();
  }

  void toggleToDoStatus(int index) {
    todoListResponse[index].completed = !todoListResponse[index].completed!;
    notifyListeners();
  }


  // Remove selected todos
  void removeSelectedToDos(List<int> selectedIndexes) {
    selectedIndexes.sort((a, b) => b.compareTo(a)); // Sort in reverse to avoid index issues
    for (int index in selectedIndexes) {
      todoListResponse.removeAt(index);
    }
    notifyListeners();
  }

  void toggleDeleteMode() {
    _deleteMode = !_deleteMode;
    notifyListeners();
  }

  // Delete ToDo item
  void deleteToDoByIndex(int index) {
    todoListResponse.removeAt(index);
    notifyListeners();
  }

  Color getPriorityColor(String? priority) {
    switch (priority) {
      case 'High':
        return Colors.red;
      case 'Medium':
        return Colors.orange;
      case 'Low':
        return Colors.blue;
      default:
        return Colors.black;
    }
  }

  Future<void> scheduleNotification(DateTime dueDate) async {
    // Convert DateTime to TZDateTime
    final tzDateTime = tz.TZDateTime.from(dueDate, tz.local);

    // Schedule notification for the due date
    var scheduledTime = tzDateTime.subtract(const Duration(hours: 1)); // 1 hour before due date

    const AndroidNotificationDetails androidPlatformChannelSpecifics =
    AndroidNotificationDetails(
      'your_channel_id',
      'your_channel_name',
      importance: Importance.max,
      priority: Priority.high,
    );

    const NotificationDetails platformChannelSpecifics =
    NotificationDetails(android: androidPlatformChannelSpecifics);

    await _localNotificationsPlugin.zonedSchedule(
      0, // Notification ID
      'ToDo Reminder',
      'Your task is due soon!',
      scheduledTime,
      platformChannelSpecifics,
      androidAllowWhileIdle: true,
      uiLocalNotificationDateInterpretation:
      UILocalNotificationDateInterpretation.absoluteTime,
    );
  }

  // Toggle selection state of an item
  // void onTileTapped(int index) {
  //   if (todoListResponse[index].dueDate) {
  //     todoListResponse.remove(index);
  //   } else {
  //     todoListResponse.add(index);
  //   }
  // }


}