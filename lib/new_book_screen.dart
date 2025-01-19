import 'package:flutter/material.dart';
import "package:image_picker/image_picker.dart";
import 'dart:io';
import 'db_helper.dart';

class NewBookScreen extends StatefulWidget {
  @override
  _NewBookScreenState createState() => _NewBookScreenState();
}

class _NewBookScreenState extends State<NewBookScreen> {
  final _titleController = TextEditingController();
  final _authorController = TextEditingController();
  File? _selectedImage;

  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    }
  }

  Future<void> _saveBook() async {
    if (_titleController.text.isNotEmpty &&
        _authorController.text.isNotEmpty &&
        _selectedImage != null) {
      final book = {
        'title': _titleController.text,
        'author': _authorController.text,
        'imagePath': _selectedImage!.path,
      };
      await DatabaseHelper.instance.insertBook(book);
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Nuevo Libro')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(controller: _titleController, decoration: InputDecoration(labelText: 'Título')),
            TextField(controller: _authorController, decoration: InputDecoration(labelText: 'Autor')),
            SizedBox(height: 10),
            _selectedImage == null
                ? Text('Ninguna imagen seleccionada.')
                : Image.file(_selectedImage!, height: 150),
            ElevatedButton.icon(
              onPressed: _pickImage,
              icon: Icon(Icons.image),
              label: Text('Seleccionar Imagen'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _saveBook,
              child: Text('Guardar'),
            ),
          ],
        ),
      ),
    );
  }
}
