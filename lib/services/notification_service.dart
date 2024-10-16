import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:intl/intl.dart';
import 'package:timezone/timezone.dart' as tz;
import 'package:timezone/data/latest.dart' as tz;

class NotificationService {
  ///single instance of FCM
  static final _messaging = FirebaseMessaging.instance;

  static final FlutterLocalNotificationsPlugin _localNotificationsPlugin =
  FlutterLocalNotificationsPlugin();

  ///To store the FCM token
  static String? _token;

  static Future init() async {
    _requestPermission();
    _getFCMToken();
    _configureLocalNotificationPlugin();
    _createAndroidNotificationChannel();


    /// Foreground notification handler
    // FirebaseMessaging.onMessage.listen(_showForegroundNotification);

    /// Background notification handler
    // FirebaseMessaging.onMessageOpenedApp
    //     .listen(_handleBackgroundNotificationOnTap);
  }

  //ask permission from the user to display notifications
  static void _requestPermission() async {
    final settings = await _messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      /// User has granted the notification permission
    } else if (settings.authorizationStatus ==
        AuthorizationStatus.provisional) {
      /// User has only granted the provisional permission
    } else {
      /// User has discarded the permission popup or denied the notification permission
    }
  }

  ///setup the FCM token to receive notifications
  static void _getFCMToken() async {
    _token = await _messaging.getToken();
    print("FCM token== $_token");
    ///onTokenRefresh stream allows us to listen to the token value whenever it changes
    _messaging.onTokenRefresh.listen((newValue) {
      _token = newValue;
    });
  }


  ///notification plugin initialisation
  static final FlutterLocalNotificationsPlugin
  _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  ///notification channel to handle android notifications
  static const AndroidNotificationChannel _androidNotificationChannel =
  AndroidNotificationChannel(
    'high_importance_channel',
    'High Importance Notifications',
    description: 'This channel is used for important notifications.',
    importance: Importance.max,
  );

  ///notification channel to handle iOS notifications
  static const DarwinNotificationDetails _iOSNotificationChannel =
  DarwinNotificationDetails(
    presentAlert: true,
    presentBadge: true,
    presentSound: true,
  );

  static void _configureLocalNotificationPlugin() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
    AndroidInitializationSettings('ic_launcher');

    const DarwinInitializationSettings initializationSettingsIOS =
    DarwinInitializationSettings(
      requestSoundPermission: false,
      requestBadgePermission: false,
      requestAlertPermission: false,
    );

    await _flutterLocalNotificationsPlugin.initialize(
      const InitializationSettings(
        android: initializationSettingsAndroid,
        iOS: initializationSettingsIOS,
      ),
      onDidReceiveNotificationResponse: (response) {},
    );

    /** Update the iOS foreground notification presentation options to allow
        heads up notifications. */
    await _messaging.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );
  }

  static void _createAndroidNotificationChannel() async {

    const AndroidNotificationChannel channel = AndroidNotificationChannel(
      'todo_reminders', // Channel ID
      'ToDo Reminders', // Channel name
      description: 'This channel is used for important task reminders.', // Description
      importance: Importance.max,
    );

    /** we have created the android notification channel which
        we had specified in the AndroidManifest.xml file earlier */
    await _flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
        AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(_androidNotificationChannel);
  }

  ///
  static Future<void> scheduleNotification(DateTime dueDate) async {
    // Initialize the timezone data
    tz.initializeTimeZones();

    // Set the local timezone to India/Kolkata
    tz.setLocalLocation(tz.getLocation('Asia/Kolkata'));

    // Convert DateTime to TZDateTime
    final tzDateTime = tz.TZDateTime.from(dueDate, tz.getLocation('Asia/Kolkata'));

    // Schedule notification for the due date
    var scheduledTime = tzDateTime.subtract(const Duration(minutes: 1)); // 1 minute before due date
    print("scheduledTime: ${DateFormat('dd-MM-yyyy hh:mm a').format(scheduledTime)}");
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
    AndroidNotificationDetails(
      'todo_reminders',
      'ToDo Reminders',
      importance: Importance.max,
      priority: Priority.high,
    );

    const NotificationDetails platformChannelSpecifics =
    NotificationDetails();

    // platformChannelSpecifics,

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
}