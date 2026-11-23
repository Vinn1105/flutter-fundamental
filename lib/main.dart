import 'package:flutter/material.dart';
import 'package:pml/http_helper.dart';
import 'package:pml/model/pizza.dart';
import 'package:pml/pages/form_pizza.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pizza App - Alvin',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late Future<List<Pizza>> pizzaList;

  @override
  void initState() {
    super.initState();
    pizzaList = HttpHelper().getPizzaList();
  }

  // Refresh daftar pizza
  void refreshData() {
    setState(() {
      pizzaList = HttpHelper().getPizzaList();
    });
  }

  // DELETE: Menghapus pizza
  Future<void> deletePizza(Pizza pizza, List<Pizza> pizzas) async {
    // Dialog konfirmasi sebelum menghapus
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Konfirmasi Delete'),
          content: Text(
            'Apakah kamu yakin ingin menghapus ${pizza.pizzaName}?',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context, false);
              },
              child: const Text('Batal'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context, true);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              child: const Text('Hapus'),
            ),
          ],
        );
      },
    );

    // Jika batal, hentikan proses
    if (confirm != true) return;

    try {
      // Memanggil API DELETE
      final result = await HttpHelper().deletePizza(pizza);
      debugPrint(result);

      if (!mounted) return;

      // Menghapus pizza dari tampilan lokal
      setState(() {
        pizzaList = Future.value(
          pizzas.where((item) => item.id != pizza.id).toList(),
        );
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${pizza.pizzaName} berhasil dihapus!'),
          duration: const Duration(seconds: 2),
        ),
      );
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(e.toString()),
          duration: const Duration(seconds: 2),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pizza List - Alvin'),
      ),
      body: FutureBuilder<List<Pizza>>(
        future: pizzaList,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Text('Error: ${snapshot.error}'),
            );
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text('Pizza tidak ditemukan'),
            );
          }

          final pizzas = snapshot.data!;

          return ListView.builder(
            itemCount: pizzas.length,
            itemBuilder: (context, index) {
              final pizza = pizzas[index];

              return ListTile(
                title: Text(pizza.pizzaName ?? ''),
                subtitle: Text(pizza.description ?? ''),
                leading: CircleAvatar(
                  backgroundImage: NetworkImage(pizza.imageUrl ?? ''),
                ),

                // Klik pizza untuk Edit (PUT)
                onTap: () async {
                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => FormPizza(
                        pizza: pizza,
                        isNew: false,
                      ),
                    ),
                  );
                },

                // Tombol Delete
                trailing: IconButton(
                  icon: const Icon(
                    Icons.delete,
                    color: Colors.red,
                  ),
                  onPressed: () {
                    deletePizza(pizza, pizzas);
                  },
                ),
              );
            },
          );
        },
      ),

      // Tombol tambah pizza (POST)
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => FormPizza(
                pizza: Pizza(),
                isNew: true,
              ),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}