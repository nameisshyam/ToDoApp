
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todoapp/providers/home_screen_provider.dart';
import 'package:todoapp/providers/todo_list_screen_provider.dart';
import 'package:todoapp/providers/user_screen_provider.dart';
import 'package:todoapp/screens/home_screen.dart';
import 'package:todoapp/screens/profile_screen.dart';
import 'package:todoapp/screens/todo_list_screen.dart';
import 'package:todoapp/screens/user_screen.dart';
import 'package:todoapp/services/notification_service.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  await Firebase.initializeApp(options: const FirebaseOptions(
      apiKey: 'AIzaSyDGLjzv_WbG67Q7eSiYplR8ZZH2IvZn_6Q',
      appId: '1:890622605051:android:85edbed7023d4e100ba25e',
      messagingSenderId: '890622605051',
      projectId: 'todoapp-7dcb6'));
  await NotificationService.init();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserProvider()..loadUserData()),
        ChangeNotifierProvider(create: (_) => HomeScreenProvider()),
        ChangeNotifierProvider(create: (_) => ToDoListScreenProvider()),
      ],
      child: const MyApp(),
    ),
  );

  // try {
  //
  // } catch(e){
  //   print("Firebase not initializeApp");
  // }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: true,
      title: 'ToDo App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => Consumer<UserProvider>(
          builder: (context, userProvider, child) {
            return userProvider.user == null
                ? UserScreen()
                : const HomeScreen();
          },
        ),
        '/home' : (context) => const HomeScreen(),
        '/toDoList' : (context) => const TodoListScreen(),
        '/profile': (context) => ProfileScreen(),
      },
    );
  }
}


