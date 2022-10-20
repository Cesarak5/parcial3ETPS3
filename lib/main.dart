import 'package:flutter/material.dart';
import 'package:parcial3_2514342018/paginas/home.dart';

void main() {
  runApp(Perros());
}

class Perros extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Home(),
      debugShowCheckedModeBanner: false,
    );
  }
}
