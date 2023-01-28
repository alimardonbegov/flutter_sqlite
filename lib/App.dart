import 'package:flutter/material.dart';
import 'package:flutter_sqlite/pages/items_page.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: ItemsPage());
  }
}
