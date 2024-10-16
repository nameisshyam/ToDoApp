import 'dart:convert';

class ToDoListResponseModel {
  int? userId;
  int? id;
  String? title;
  bool? completed;
  DateTime? dueDate;
  String? priority;

  ToDoListResponseModel({
    this.userId,
    this.id,
    this.title,
    this.completed,
    this.dueDate,
    this.priority
  });

  factory ToDoListResponseModel.fromRawJson(String str) => ToDoListResponseModel.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ToDoListResponseModel.fromJson(Map<String, dynamic> json) => ToDoListResponseModel(
    userId: json["userId"],
    id: json["id"],
    title: json["title"],
    completed: json["completed"],
    dueDate: json['dueDate'],
      priority : json['priority']

  );

  Map<String, dynamic> toJson() => {
    "userId": userId,
    "id": id,
    "title": title,
    "completed": completed,
    "dueDate": dueDate,
    "priority": priority
  };
}
