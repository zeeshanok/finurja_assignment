import 'package:finurja_assignment/providers/data.dart';
import 'package:finurja_assignment/providers/json_data.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

void main() {
  setupGetIt();

  runApp(const MyApp());
}

void setupGetIt() {
  GetIt.instance.registerSingleton<DataProvider>(JsonDataProvider('data.json'));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Finurja Assignment',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const Home(),
    );
  }
}

class Home extends StatelessWidget {
  const Home({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Text("Hello World"),
    );
  }
}
