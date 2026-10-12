import 'package:flutter/material.dart';

class GoogleMapReviewScreen extends StatelessWidget {
  const GoogleMapReviewScreen({super.key});

  Widget _buildButton({required IconData icon, required String title}) {
    return Column(
      children: [
        Icon(icon, color: Colors.blue),
        Text(title, style: TextStyle(color: Colors.blue)),
      ],
    );
  }

  Widget _buildTitle() {
    return Padding(
      padding: EdgeInsets.all(20),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [Text("Judul"), Text("Sub judul")],
          ),
          Row(
            children: [
              Icon(Icons.star, color: Colors.deepOrangeAccent),
              Text("41"),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: ListView(
          children: [
            Image(
              image: AssetImage("assets/wisataa.jpg"),
              width: MediaQuery.of(context).size.width,
            ),
            _buildTitle(),
            Padding(
              padding: EdgeInsets.all(10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildButton(icon: Icons.call, title: "call"),
                  _buildButton(icon: Icons.navigation, title: "Route"),
                  _buildButton(icon: Icons.share, title: "Share"),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.all(20),
              child: Text(
                "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum ",
              ),
            ),
          ],
        ),
      ),
    );
  }
}
