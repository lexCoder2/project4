import 'package:flutter/material.dart';
import 'db_helper.dart';
import 'dart:io';

class MainScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Catálogo de Libros'),
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              Navigator.pushNamed(context, '/search');
            },
          ),
        ],
      ),
      body: FutureBuilder(
        future: DatabaseHelper.instance.fetchBooks(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasData) {
            final books = snapshot.data as List<Map<String, dynamic>>;
            return ListView.builder(
              itemCount: books.length,
              itemBuilder: (context, index) {
                final book = books[index];
                return Card(
                  child: ListTile(
                    leading: book['imagePath'].isEmpty
                        ? Icon(Icons.book, size: 50)
                        : Image.file(
                      File(book['imagePath']),
                      width: 50,
                      height: 50,
                      fit: BoxFit.cover,
                    ),
                    title: Text(book['title']),
                    subtitle: Text(book['author']),
                  ),
                );
              },
            );
          } else {
            return Center(child: Text('No hay libros registrados.'));
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/new');
        },
        child: Icon(Icons.add),
      ),
    );
  }
}


