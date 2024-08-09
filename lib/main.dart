import 'package:finurja_assignment/pages/home.dart';
import 'package:finurja_assignment/providers/data.dart';
import 'package:finurja_assignment/providers/json_data.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:intl/date_symbol_data_local.dart';

void main() {
  setup();

  runApp(const MyApp());
}

void setup() {
  initializeDateFormatting('en_IN');

  GetIt.instance.registerSingleton<DataProvider>(JsonDataProvider('data.json'));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Finurja Assignment',
      theme: ThemeData.from(
        colorScheme: ColorScheme.fromSeed(
          dynamicSchemeVariant: DynamicSchemeVariant.vibrant,
          seedColor: Colors.greenAccent,
          brightness: Brightness.light,
        ),
      ).copyWith(splashFactory: NoSplash.splashFactory),
      home: const HomePage(),
    );
  }
}
