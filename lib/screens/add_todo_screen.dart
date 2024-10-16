import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:todoapp/models/todo_list_response_model.dart';
import 'package:todoapp/providers/todo_list_screen_provider.dart';

import '../services/notification_service.dart';

class AddToDoScreen extends StatefulWidget {
  @override
  _AddToDoScreenState createState() => _AddToDoScreenState();
}

class _AddToDoScreenState extends State<AddToDoScreen> {
  final _formKey = GlobalKey<FormState>();
  String _title = '';
  DateTime _dueDate = DateTime.now();
  String? _selectedPriority;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Add New ToDo',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.blue,
        centerTitle: true,
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: const Icon(Icons.arrow_back),
          color: Colors.white,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Create a new task',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                  ),
                ),
                const SizedBox(height: 20),
                TextFormField(
                  decoration: InputDecoration(
                    labelText: 'Title',
                    labelStyle: const TextStyle(color: Colors.blue),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.blue),
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a title';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    _title = value!;
                  },
                ),
                const SizedBox(height: 20),
                const Text(
                  'Due Date',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.blue,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                InkWell(
                  onTap: () async {
                    // Show Date Picker
                    final selectedDate = await showDatePicker(
                      context: context,
                      // barrierColor: Colors.blue,
                      initialDate: _dueDate,
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2101),
                      builder: (context, child) {
                        return Theme(
                          data: Theme.of(context).copyWith(
                            colorScheme: const ColorScheme.light(
                              primary: Colors
                                  .blue, // Header background and selected date color
                              onPrimary: Colors
                                  .white, // Header text color (like "Select Date")
                              onSurface: Colors
                                  .black, // Button text color (like "Cancel" and "OK")
                            ),
                            textButtonTheme: TextButtonThemeData(
                              style: TextButton.styleFrom(
                                foregroundColor: Colors
                                    .blue, // "Cancel" and "OK" button text color
                              ),
                            ),
                          ),
                          child: child!,
                        );
                      },
                    );
            
                    if (selectedDate != null) {
                      // Show Time Picker
                      final selectedTime = await showTimePicker(
                        context: context,
                        initialTime: TimeOfDay.fromDateTime(DateTime.now()),
                        builder: (context, child) {
                          return Theme(
                            data: Theme.of(context).copyWith(
                              timePickerTheme: TimePickerThemeData(
                                dialTextColor:
                                    WidgetStateColor.resolveWith((states) {
                                  if (states.contains(WidgetState.selected)) {
                                    return Colors
                                        .white; // Text color when selected
                                  }
                                  return Colors.black; // Default text color
                                }),
                                cancelButtonStyle: const ButtonStyle(
                                    foregroundColor:
                                        WidgetStatePropertyAll(Colors.blue)),
                                confirmButtonStyle: const ButtonStyle(
                                    foregroundColor:
                                        WidgetStatePropertyAll(Colors.blue)),
                                dialHandColor: Colors.blue,
                                hourMinuteColor: Colors.blue,
                                hourMinuteTextColor: Colors.white,
                                dayPeriodTextColor: WidgetStateColor.resolveWith(
                                    (states) =>
                                        states.contains(WidgetState.selected)
                                            ? Colors.white
                                            : Colors.blue), // AM/PM text color
                                dayPeriodColor: WidgetStateColor.resolveWith(
                                    (states) => states
                                            .contains(WidgetState.selected)
                                        ? Colors.blue
                                        : Colors.white), // AM/PM background color
                              ),
                            ),
                            child: child!,
                          );
                        },
                      );
            
                      if (selectedTime != null) {
                        setState(() {
                          // Combine the selected date and time
                          _dueDate = DateTime(
                            selectedDate.year,
                            selectedDate.month,
                            selectedDate.day,
                            selectedTime.hour,
                            selectedTime.minute,
                          );
                        });
                      }
                    }
                  },
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      // color: Colors.blue.shade50,
                      border: Border.all(color: Colors.black),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          DateFormat('dd-MM-yyyy hh:mm a')
                              .format(_dueDate), // This shows both date and time
                          style:
                              const TextStyle(fontSize: 16, color: Colors.blue),
                        ),
                        const Icon(Icons.calendar_today, color: Colors.blue),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 40),
                DropdownButtonFormField<String>(
                  decoration: InputDecoration(
                      labelText: 'Priority',
                      labelStyle: const TextStyle(
                          color: Colors.blue,
                          fontWeight: FontWeight.bold), // Label color
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(color: Colors.blue),
                      ),
                      focusedBorder: const OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.blue))),
                  value: _selectedPriority,
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedPriority = newValue; // Update the selected value
                    });
                  },
                  items: const [
                    DropdownMenuItem(
                      value: 'Low',
                      child: Row(
                        children: [
                          Icon(
                            Icons.circle,
                            color: Colors.blue,
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            "Low",
                            style: TextStyle(fontWeight: FontWeight.w700),
                          )
                        ],
                      ),
                    ),
                    DropdownMenuItem(
                      value: 'Medium',
                      child: Row(
                        children: [
                          Icon(
                            Icons.circle,
                            color: Colors.orange,
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            "Medium",
                            style: TextStyle(fontWeight: FontWeight.w700),
                          )
                        ],
                      ),
                    ),
                    DropdownMenuItem(
                      value: 'High',
                      child: Row(
                        children: [
                          Icon(
                            Icons.circle,
                            color: Colors.red,
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Text(
                            "High",
                            style: TextStyle(fontWeight: FontWeight.w700),
                          )
                        ],
                      ),
                    ),
                  ],
                  dropdownColor: Colors.white, // Dropdown background color
                  iconEnabledColor: Colors.blue, // Dropdown icon color
                  iconDisabledColor: Colors.grey, // Disabled icon color
                  style: const TextStyle(
                      color: Colors.blue), // Selected item text color
                ),
                const SizedBox(height: 20),
                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        _formKey.currentState!.save();
                        if (_dueDate.isAfter(DateTime.now())) {
                          NotificationService.scheduleNotification(_dueDate);
                          // notificationProvider.scheduleNotification(_dueDate);
                          Provider.of<ToDoListScreenProvider>(context,
                                  listen: false)
                              .addToDo(
                            ToDoListResponseModel(
                                title: _title,
                                dueDate: _dueDate,
                                completed: false,
                                priority: _selectedPriority),
                          );
                          Navigator.pop(context);
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                              content: Text(
                                  "Due date is in the past. Please choose a future date.")));
                        }
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 50, vertical: 15),
                      backgroundColor: Colors.blue,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ), // Background color
                    ),
                    child: const Text(
                      'Add Task',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
