import './screens/chat_screen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'screens/auth_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  final fcmToken = await FirebaseMessaging.instance.getToken();
  print('FCM Token: ${fcmToken!}');
  FirebaseMessaging.onBackgroundMessage(_onBackgroundMessage);
  runApp(MyApp());
}
Future<void> _onBackgroundMessage(RemoteMessage msg) async {
  await Firebase.initializeApp();
  print('ON BGND STARTED');
  print("onBackgroundMessage: ${msg}");
  print("onBackgroundMessage.data: ${msg.data}");
  print("onBackgroundMessage.notification.title: ${msg.notification?.title}");
  print("onBackgroundMessage.notification.body: ${msg.notification?.body}");
  print('ON BGND ENDED');
}

class MyApp extends StatelessWidget {
  final _firebaseAuth = FirebaseAuth.instance;

  MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, // hide "debug" banner
      title: 'Chat Up!',
      theme: ThemeData(
        primaryColor: Colors.pink,
        colorScheme: ColorScheme.fromSwatch(
          primarySwatch: Colors.pink,
          backgroundColor: Colors.pink,
          accentColor: Colors.deepPurple,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
          foregroundColor: Colors.white,
          textStyle: const TextStyle(color: Colors.pink),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
        )),
      ),
      home: FutureBuilder(
          future: Firebase.initializeApp(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              debugPrint('snapshot error - ${snapshot.error}');
              return const Text('Snapshot error');
            } else if (snapshot.hasData) {
              return StreamBuilder(
                  stream: _firebaseAuth.authStateChanges(),
                  builder: (ctx, snapshot) {
                    if(snapshot.hasData){
                      return ChatScreen();
                    }
                    return AuthScreen();
                  });
            } else {
              return const Center(child: CircularProgressIndicator());
            }
          }),
    );
  }
}
