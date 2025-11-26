import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'firebase_options.dart';

Future<void> _firebaseBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  FirebaseMessaging.onBackgroundMessage(_firebaseBackgroundHandler);

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: NotificationPage(),
    );
  }
}

class NotificationPage extends StatefulWidget {
  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  String? token;
  String? errorMessage;

  @override
  void initState() {
    super.initState();
    loadToken();
    setupMessageListeners();
  }

  void setupMessageListeners() {
    FirebaseMessaging.onMessage.listen((message) {
      print("Mensaje recibido en foreground: ${message.notification?.title}");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Notificación recibida: ${message.notification?.title}")),
      );
    });
  }

  Future<void> loadToken() async {
    try {
      // Solicitar permiso para notificaciones (importante para web)
      NotificationSettings settings = await FirebaseMessaging.instance.requestPermission(
        alert: true,
        announcement: false,
        badge: true,
        carPlay: false,
        provisional: false,
        sound: true,
      );

      print('Permisos otorgados: ${settings.authorizationStatus}');

      token = await FirebaseMessaging.instance.getToken();
      print("Token obtenido: $token");
      
      setState(() {});
    } catch (e) {
      print("Error al obtener token: $e");
      setState(() {
        errorMessage = "Error: $e";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Actividad Notificaciones"),
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                color: Colors.lightBlue[100],
                padding: EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("Token del dispositivo:", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                    SizedBox(height: 8),
                    SelectableText(
                      token ?? "Cargando...",
                      style: TextStyle(fontFamily: 'monospace', fontSize: 12),
                    ),
                  ],
                ),
              ),
              if (errorMessage != null) ...[
                SizedBox(height: 16),
                Container(
                  color: Colors.red[100],
                  padding: EdgeInsets.all(12),
                  child: Text(
                    errorMessage!,
                    style: TextStyle(color: Colors.red[900], fontWeight: FontWeight.bold),
                  ),
                ),
              ],
              SizedBox(height: 24),
              Text("Instrucciones:", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              SizedBox(height: 8),
              Text("1. Copia el token mostrado arriba"),
              Text("2. Ve a Firebase Console > Cloud Messaging"),
              Text("3. Envía una notificación de prueba al dispositivo con este token"),
              Text("4. Deberías ver la notificación en Chrome"),
            ],
          ),
        ),
      ),
    );
  }
}
