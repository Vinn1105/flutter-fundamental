import 'package:flutter/material.dart';
import 'package:pml/pages/detail_shoping_screen.dart';
import 'package:pml/pages/shoping_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => ShopingScreen(),
        '/detail': (context) => DetailShopingScreen(),
      },
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  DateTime? _dateTime = DateTime.now();

  // void _incrementCounter() {
  //   setState(() {

  //    _counter++;
  //   });
  // }

  void tampilkanDialog(BuildContext context) {
    Widget okButton = TextButton(
      child: Text("Ok"),
      onPressed: () => Navigator.pop(context),
    );

    AlertDialog dialog = AlertDialog(
      title: Text("Judul Dialog"),
      content: Text("Ini isi dialog Alvin"),
      actions: [okButton],
    );

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return dialog;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(_dateTime.toString()),
            ElevatedButton(
              child: const Text("ubah tanggal"),
              onPressed: () async {
                final DateTime? tanggal = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(2015, 8),
                  lastDate: DateTime(2101),
                );

                if (tanggal != null && tanggal != _dateTime) {
                  setState(() {
                    _dateTime = tanggal;
                  });
                }
              },
            ),
            const Text('You have pushed the button this many times:'),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => tampilkanDialog(context),
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
