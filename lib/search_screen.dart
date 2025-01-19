import 'dart:io';

import 'package:flutter/material.dart';
import 'db_helper.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final _searchController = TextEditingController();
  List<Map<String, dynamic>> _searchResults = [];

  Future<void> _searchBooks(String query) async {
    final allBooks = await DatabaseHelper.instance.fetchBooks();
    setState(() {
      _searchResults = allBooks
          .where((book) =>
      book['title'].toLowerCase().contains(query.toLowerCase()) ||
          book['author'].toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Buscar Libros'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: 'Buscar por título o autor',
                suffixIcon: IconButton(
                  icon: Icon(Icons.search),
                  onPressed: () {
                    _searchBooks(_searchController.text);
                  },
                ),
              ),
              onSubmitted: (value) => _searchBooks(value),
            ),
            SizedBox(height: 20),
            Expanded(
              child: _searchResults.isEmpty
                  ? Center(child: Text('No se encontraron resultados.'))
                  : ListView.builder(
                itemCount: _searchResults.length,
                itemBuilder: (context, index) {
                  final book = _searchResults[index];
                  return Card(
                    child: ListTile(
                      leading: Image.file(
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
              ),
            ),
          ],
        ),
      ),
    );
  }
}
