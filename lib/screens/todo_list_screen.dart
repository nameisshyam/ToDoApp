import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../providers/todo_list_screen_provider.dart';
import 'add_todo_screen.dart';

class TodoListScreen extends StatelessWidget {
  const TodoListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ToDoListScreenProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'ToDo List',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.blue,
        centerTitle: true,
        actions: [
          Consumer<ToDoListScreenProvider>(
            builder: (context,provider,child){
              return IconButton(
                padding: const EdgeInsets.only(right: 15),
                  onPressed: () {
                    provider.toggleDeleteMode();
                  },
                  icon: Icon(
                    Icons.delete,
                    size: 35,
                    color: provider.deleteMode ? Colors.red : Colors.white,
                  ));
            },
          )

        ],
      ),
      body: FutureBuilder(
          future: provider.fetchToDos(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              // Show loading indicator while waiting for the response
              return const Center(child: CircularProgressIndicator(color: Colors.blue,));
            } else if (snapshot.hasError) {
              // Handle error state
              return Center(child: Text('Error: ${snapshot.error}'));
            } else {
              return Consumer<ToDoListScreenProvider>(
                builder: (context, todoProvider, child) {
                  return ListView.separated(
                    itemCount: todoProvider.todoListResponse.length,
                    itemBuilder: (context, index) {
                      final todo = todoProvider.todoListResponse[index];
                      return ListTile(
                        tileColor: todo.completed ?? false ? Colors.blue.shade50 : Colors.white,
                        title: Text(todo.title ?? '',style: const TextStyle(fontWeight: FontWeight.bold),),
                        subtitle: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if(todo.dueDate!=null)
                              Padding(
                                padding: const EdgeInsets.symmetric(vertical: 5),
                                child: Text('Due: ${DateFormat('dd-MM-yyyy hh:mm a').format(todo.dueDate!)}'),
                              ),

                            const SizedBox(height: 5,),
                            Text('Status: ${todo.completed! ? 'Completed' : 'Pending'}')

                          ],
                        ),
                        leading: provider.deleteMode ? IconButton(
                            onPressed: (){
                              provider.deleteToDoByIndex(index);
                            }, icon: const Icon(Icons.close,color: Colors.red,size: 25,))
                            : Icon(Icons.circle,color: provider.getPriorityColor(todo.priority),),
                        trailing: provider.deleteMode
                            ? null
                            : Checkbox(
                          activeColor: Colors.blue,
                          value: todo.completed,
                          onChanged: (value) {
                            todoProvider.toggleToDoStatus(index);
                          },
                        ),
                      );
                    },separatorBuilder: (context,index) {
                      return const SizedBox(height: 5,);
                  },
                  );
                },
              );
            }
          }),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blue,
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => AddToDoScreen()),
          );
        },
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
    );
  }
}
