class ToDo {
  String title;
  DateTime dueDate;
  bool isCompleted;

  ToDo({
    required this.title,
    required this.dueDate,
    this.isCompleted = false,
  });
}
