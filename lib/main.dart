import 'package:flutter/material.dart';
import 'main_screen.dart';
import 'new_book_screen.dart';
import 'search_screen.dart'; // Importa la pantalla de búsqueda

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Catálogo de Libros',
      initialRoute: '/',
      routes: {
        '/': (context) => MainScreen(),
        '/new': (context) => NewBookScreen(),
        '/search': (context) => SearchScreen(), // Agrega la ruta de búsqueda
      },
    );
  }
}


