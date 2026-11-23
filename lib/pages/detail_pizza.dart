
import 'package:flutter/material.dart';
import 'package:pml/http_helper.dart';

class DetailPizza extends StatelessWidget {
  final String id;

  const DetailPizza({super.key, required this.id});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Center(
          child: FutureBuilder(
            future: HttpHelper().getPizzaByID(id),
            builder: (context, data) {
              if (data.connectionState == ConnectionState.waiting) {
                return CircularProgressIndicator();
              }

              if (data.connectionState == ConnectionState.done &&
                  data.data != null) {
                return ListTile(
                  title: Text(data.data?.pizzaName ?? ''),
                  subtitle: Text(data.data?.description ?? ''),
                );
              }

              return Text("Error ${data.error}");
            },
          ),
        ),
      ),
    );
  }
}
