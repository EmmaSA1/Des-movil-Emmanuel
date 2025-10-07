import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a purple toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        scaffoldBackgroundColor: Colors.black, // fondo negro
        textTheme: const TextTheme(
          bodyMedium: TextStyle(color: Colors.white),
          bodyLarge: TextStyle(color: Colors.white),
          bodySmall: TextStyle(color: Colors.white),
        ),
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  // 🔹 Variables necesarias para historial
  List<int> _historial = []; // guarda los valores del contador
  bool _mostrarHistorial = false; // controla si se muestra la lista o no

  // Método para incrementar el contador
  void _incrementCounter() {
    setState(() {
      // This call to setState tells the Flutter framework that something has
      // changed in this State, which causes it to rerun the build method below
      // so that the display can reflect the updated values. If we changed
      // _counter without calling setState(), then the build method would not be
      // called again, and so nothing would appear to happen.
      _counter++;
      _historial.add(_counter); // Guardar valores en historial
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Se sumó 1")),
    );
  }

  // Método para decrementar el contador
  void _decrementCounter() {
    if (_counter <= 0) {
      // Aviso simple si el contador sería negativo
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("No puedes tener números negativos")),
      );
    } else {
      setState(() {
        _counter--;
        _historial.add(_counter); // Guardar valores en historial
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Se restó 1")),
      );
    }
  }

  // 🔹 Mostrar historial
  Widget _buildHistorial() {
    if (_historial.isEmpty) {
      return const Center(child: Text("No hay historial todavía."));
    }
    return Expanded(
      // Expanded permite que la lista ocupe todo el espacio restante y sea scrollable
      child: ListView.builder(
        itemCount: _historial.length,
        itemBuilder: (context, index) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: Text("Valor: ${_historial[index]}"),
            ),
          );
        },
      ),
    );
  }

  // 🔹 Botón para limpiar historial
  void _limpiarHistorial() {
    setState(() {
      _historial.clear();
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Historial limpiado")),
    );
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        // TRY THIS: Try changing the color here to a specific color (to
        // Colors.amber, perhaps?) and trigger a hot reload to see the AppBar
        // change color while the other colors stay the same.
        backgroundColor: Colors.black,
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),
        centerTitle: true,
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            // Column is also a layout widget. It takes a list of children and
            // arranges them vertically. By default, it sizes itself to fit its
            // children horizontally, and tries to be as tall as its parent.
            //
            // Column has various properties to control how it sizes itself and
            // how it positions its children. Here we use mainAxisAlignment to
            // center the children vertically; the main axis here is the vertical
            // axis because Columns are vertical (the cross axis would be
            // horizontal).
            //
            // TRY THIS: Invoke "debug painting" (choose the "Toggle Debug Paint"
            // action in the IDE, or press "p" in the console), to see the
            // wireframe for each widget.
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              const Text(
                'Has presionado el botón esta cantidad de veces:',
                style: TextStyle(fontSize: 16, color: Colors.white),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),
              Text(
                '$_counter',
                style: const TextStyle(
                  fontSize: 40,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),

              // Botón mostrar/ocultar historial
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    _mostrarHistorial = !_mostrarHistorial;
                  });
                },
                child: Text(
                  _mostrarHistorial ? "Ocultar historial" : "Mostrar historial",
                ),
              ),
              const SizedBox(height: 10),

              // Botón limpiar historial
              ElevatedButton(
                onPressed: _limpiarHistorial,
                child: const Text("Limpiar historial"),
              ),
              const SizedBox(height: 20),

              // Mostrar historial si está activado
              if (_mostrarHistorial) _buildHistorial(),
            ],
          ),
        ),
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.center, // Centrar botones
        children: [
          FloatingActionButton(
            onPressed: _incrementCounter,
            tooltip: 'Increment',
            child: const Text("+"),
            backgroundColor: Colors.grey[800],
          ),
          const SizedBox(width: 20),
          FloatingActionButton(
            onPressed: _decrementCounter,
            tooltip: 'Decrement',
            child: const Text("-"),
            backgroundColor: Colors.grey[800],
          ),
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat, // Centrar flotantes
    );
  }
}