import 'package:flutter/material.dart';
import 'package:shopping_list_app/widget/grocery_item_list.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Groceries',
      theme: ThemeData.dark().copyWith(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color.fromARGB(255, 60, 255, 164),
          brightness: Brightness.dark,
          surface: const Color.fromARGB(255, 42, 59, 58),
        ),
        scaffoldBackgroundColor: const Color.fromARGB(255, 50, 58, 60),
      ),
      home: Scaffold(
        appBar: AppBar(title: const Text('Your Groceries'), centerTitle: false),
        body: const GroceryItemList(),
      ),
    );
  }
}
