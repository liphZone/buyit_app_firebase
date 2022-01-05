import 'package:flutter/material.dart';

class PanierScreen extends StatefulWidget {
  const PanierScreen({Key? key}) : super(key: key);

  @override
  _PanierScreenState createState() => _PanierScreenState();
}

class _PanierScreenState extends State<PanierScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Text(
              'BUY IT',
              style: TextStyle(color: Colors.black),
            ),
            Spacer(),
            Text(
              'Mon Panier',
              style: TextStyle(color: Colors.black),
            ),
          ],
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
      ),
    );
  }
}
