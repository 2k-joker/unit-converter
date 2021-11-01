import 'package:flutter/material.dart';
import 'package:unit_converter/category_screen.dart';

void main() {
  runApp(const UnitConverter());
}

class UnitConverter extends StatelessWidget {
  const UnitConverter({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Unit Converter',
      theme: ThemeData(
        textTheme: Theme.of(context).textTheme.apply(
              bodyColor: Colors.black,
              displayColor: Colors.grey[600],
            ),
        primaryColor: Colors.grey[500],
        textSelectionTheme:
            TextSelectionThemeData(selectionHandleColor: Colors.green[500]),
      ),
      home: const CategoryScreen(),
    );
  }
}
