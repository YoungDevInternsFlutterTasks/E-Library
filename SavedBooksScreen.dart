import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:ebookslibrary/screens/Home/BookScreen.dart';

class SavedBooksScreen extends StatefulWidget {
  const SavedBooksScreen({super.key});

  @override
  State<SavedBooksScreen> createState() => _SavedBooksScreenState();
}

class _SavedBooksScreenState extends State<SavedBooksScreen> {
  List<Map<String, dynamic>> savedBooks = [];

  @override
  void initState() {
    super.initState();
    _loadSavedBooks();
  }

  Future<void> _loadSavedBooks() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? bookList = prefs.getStringList('saved_books');
    if (bookList != null) {
      setState(() {
        savedBooks = bookList
            .map((book) => jsonDecode(book))
            .toList()
            .cast<Map<String, dynamic>>();
      });
    }
  }

  Future<void> _deleteBook(int index) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      savedBooks.removeAt(index);
    });

    List<String> updatedList =
        savedBooks.map((book) => jsonEncode(book)).toList();
    await prefs.setStringList('saved_books', updatedList);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Theme.of(context).canvasColor,
          title: const Text(
            "Saved Books",
            style: TextStyle(
                fontSize: 20, color: Colors.black, fontWeight: FontWeight.bold),
          )),
      body: savedBooks.isEmpty
          ? const Center(child: Text("No saved books"))
          : ListView.builder(
              itemCount: savedBooks.length,
              itemBuilder: (context, index) {
                final book = savedBooks[index];
                final String? imageUrl = book['imageLinks']?['thumbnail'];
                final String title = book['title'] ?? "No Title";
                final String authors =
                    book['authors']?.join(", ") ?? "Unknown Author";

                return Card(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  elevation: 3,
                  child: ListTile(
                    leading: imageUrl != null
                        ? Image.network(imageUrl,
                            width: 50, height: 50, fit: BoxFit.cover)
                        : const Icon(Icons.book, size: 50),
                    title: Text(title,
                        style: const TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text(authors),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Bookscreen(book: book),
                        ),
                      );
                    },
                    trailing: IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () => _deleteBook(index),
                    ),
                  ),
                );
              },
            ),
    );
  }
}
