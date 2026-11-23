
import 'package:flutter/material.dart';
import 'package:pml/http_helper.dart';
import 'package:pml/model/pizza.dart';

class FormPizza extends StatefulWidget {
  final Pizza pizza;
  final bool isNew;

  FormPizza({
    super.key,
    Pizza? pizza,
    this.isNew = true,
  }) : pizza = pizza ?? Pizza();

  @override
  State<FormPizza> createState() => _FormPizzaState();
}

class _FormPizzaState extends State<FormPizza> {
  final name = TextEditingController();
  final description = TextEditingController();
  final price = TextEditingController();
  final imageUrl = TextEditingController();

  @override
  void initState() {
    super.initState();

    // Jika mode Edit, isi form dari data pizza
    if (!widget.isNew) {
      name.text = widget.pizza.pizzaName ?? '';
      description.text = widget.pizza.description ?? '';
      price.text = widget.pizza.price?.toString() ?? '';
      imageUrl.text = widget.pizza.imageUrl ?? '';
    }
  }

  @override
  void dispose() {
    name.dispose();
    description.dispose();
    price.dispose();
    imageUrl.dispose();
    super.dispose();
  }

  Future<void> postData() async {
    Pizza pizza = Pizza(
      id: widget.isNew ? 11 : widget.pizza.id,
      description: description.text,
      imageUrl: imageUrl.text,
      pizzaName: name.text,
      price: double.tryParse(price.text) ?? 0,
    );

    try {
      HttpHelper helper = HttpHelper();

      // Create menggunakan POST, Edit menggunakan PUT
      final data = await (widget.isNew
          ? helper.postPizza(pizza)
          : helper.putPizza(pizza));

      debugPrint(data);

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            widget.isNew
                ? 'Pizza berhasil ditambahkan!'
                : 'Pizza berhasil diperbarui!',
          ),
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
        title: Text(widget.isNew ? 'Form Create Pizza' : 'Form Edit Pizza'),
      ),
      body: Container(
        padding: const EdgeInsets.all(20),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              children: [
                TextField(
                  controller: name,
                  decoration: const InputDecoration(
                    labelText: 'Pizza Name',
                  ),
                ),
                TextField(
                  controller: description,
                  decoration: const InputDecoration(
                    labelText: 'Pizza Description',
                  ),
                ),
                TextField(
                  controller: price,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: 'Pizza Price',
                  ),
                ),
                TextField(
                  controller: imageUrl,
                  decoration: const InputDecoration(
                    labelText: 'Pizza Image',
                  ),
                ),
                ElevatedButton(
                  onPressed: postData,
                  child: Text(widget.isNew ? 'Simpan' : 'Update'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
