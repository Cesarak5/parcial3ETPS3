import 'dart:async';
import 'dart:convert';
import 'package:parcial3_2514342018/json/integrantesjson.dart';
import 'package:restart_app/restart_app.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

Future<Perro> fetchPerro() async {
  final response =
      await http.get(Uri.parse('https://dog.ceo/api/breeds/image/random'));

  if (response.statusCode == 200) {
    // If the server did return a 200 OK response,
    // then parse the JSON.
    return Perro.fromJson(jsonDecode(response.body));
  } else {
    // If the server did not return a 200 OK response,
    // then throw an exception.
    throw Exception('Failed to load album');
  }
}

class Perro {
  final String message;
  final String status;

  const Perro({
    required this.message,
    required this.status,
  });

  factory Perro.fromJson(Map<String, dynamic> json) {
    return Perro(
      message: json['message'],
      status: json['status'],
    );
  }
}

void main() => runApp(const Home());

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();
  late Future<Perro> futurePerro;

  @override
  void initState() {
    super.initState();
    futurePerro = fetchPerro();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Perro Aleatorio',
      theme: ThemeData(
          primarySwatch: Colors.blueGrey, secondaryHeaderColor: Colors.grey),
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blueGrey,
          title: Center(
            child: const Text('Perro Aleatorio',
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.white)),
          ),
        ),
        body: RefreshIndicator(
          key: _refreshIndicatorKey,
          triggerMode: RefreshIndicatorTriggerMode.onEdge,
          onRefresh: () async {
            // Replace this delay with the code to be executed during refresh
            // and return a Future when code finishs execution.
            return Future<void>.delayed(const Duration(seconds: 2));
          },
          child: cuerpo(),
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () async {
            final result = await Restart.restartApp();
            print(result);
            _refreshIndicatorKey.currentState?.show();
          },
          icon: const Icon(Icons.refresh),
          label: const Text('Nuevo Perro'),
        ),
      ),
    );
  }

  Widget imagen() {
    return FutureBuilder<Perro>(
      future: futurePerro,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return Image.network(snapshot.data!.message);
        } else if (snapshot.hasError) {
          return Text('${snapshot.error}');
        }

        // By default, show a loading spinner.
        return const CircularProgressIndicator();
      },
    );
  }

  Future<void> refresh() async {
    cuerpo();
  }

  void _restartApp() async {
    Restart.restartApp();
  }

  Widget cuerpo() {
    return SingleChildScrollView(
      scrollDirection: Axis.vertical,
      child: Column(
        children: [
          SizedBox(
            height: 30,
          ),
          Text(
            "Integrantes",
            style: TextStyle(
                fontSize: 18, color: Colors.black, fontWeight: FontWeight.w600),
          ),
          SizedBox(
            height: 30,
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Padding(
              padding: const EdgeInsets.only(left: 30),
              child: Row(
                children: List.generate(integrantes.length, (index) {
                  return Padding(
                    padding: const EdgeInsets.only(right: 30),
                    child: Column(
                      children: [
                        Container(
                          width: 350,
                          height: 80,
                          decoration: BoxDecoration(
                              image: DecorationImage(
                                  image: AssetImage(integrantes[index]['img']),
                                  fit: BoxFit.cover),
                              color: Colors.blueGrey,
                              borderRadius: BorderRadius.circular(10)),
                        ),
                      ],
                    ),
                  );
                }),
              ),
            ),
          ),
          SizedBox(
            height: 30,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(
              child: imagen(),
            ),
          ),
        ],
      ),
    );
  }
}
