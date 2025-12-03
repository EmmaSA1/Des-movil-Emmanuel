import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'notifications_page.dart';

// Handler para mensajes recibidos en segundo plano
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print("Mensaje en segundo plano: ${message.messageId}");
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  // Configurar handler de mensajes en background
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    _initNotifications();
  }

  void _initNotifications() async {
    // Solicitar permisos
    NotificationSettings settings =
        await FirebaseMessaging.instance.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );

    print("Permisos otorgados: ${settings.authorizationStatus}");

    // Obtener token
    String? token = await FirebaseMessaging.instance.getToken();
    print("🔥 TOKEN FCM:");
    print(token);

    // Manejo cuando la app está abierta
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print("📩 Notificación en FOREGROUND:");
      print("Título: ${message.notification?.title}");
      print("Cuerpo: ${message.notification?.body}");
    });

    // Manejo cuando abres la app tocando la notificación
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print("📲 Abriste la app desde una notificación");
    });

    // Manejo si la app estaba cerrada y se abrió por una notificación
    RemoteMessage? initialMessage =
        await FirebaseMessaging.instance.getInitialMessage();
    if (initialMessage != null) {
      print("📲 App abierta desde TERMINADA por una notificación");
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Notificaciones FCM',
      debugShowCheckedModeBanner: false,
      home: const NotificationsPage(),
    );
  }
}
