import 'dart:convert';
import 'package:ebookslibrary/screens/NotesScreen.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class Bookscreen extends StatefulWidget {
  final Map<String, dynamic> book;

  const Bookscreen({super.key, required this.book});

  @override
  State<Bookscreen> createState() => _BookscreenState();
}

class _BookscreenState extends State<Bookscreen> {
  void _launchURL(String url) async {
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Could not launch $url')),
      );
    }
  }

  Future<void> _saveBook() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? savedBooks = prefs.getStringList('saved_books') ?? [];

    // Convert book object to JSON string
    String bookJson = jsonEncode(widget.book);

    // Check if the book is already saved
    if (!savedBooks.contains(bookJson)) {
      savedBooks.add(bookJson);
      await prefs.setStringList('saved_books', savedBooks);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('${widget.book['title']} added to saved books')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('${widget.book['title']} is already saved')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final String? imageUrl = widget.book['imageLinks']?['thumbnail'];
    final String title = widget.book['title'] ?? "No Title";
    final String authors =
        widget.book['authors']?.join(", ") ?? "Unknown Author";
    final String publisher = widget.book['publisher'] ?? "Unknown Publisher";
    final String description = widget.book['description'] ?? "No Description";
    final String? pdfUrl = widget.book['accessInfo']?['pdf']?['acsTokenLink'];
    final String? webReaderLink = widget.book['accessInfo']?['webReaderLink'];
    final String? previewLink = widget.book['previewLink'];

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).canvasColor,
        title: Text(
          "Book Details",
          style: TextStyle(
              fontWeight: FontWeight.bold, fontSize: 20, color: Colors.black),
        ),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => NotesScreen(
                    bookId: widget.book['title'],
                  ),
                ),
              );
            },
            icon: Icon(Icons.note_add),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              height: MediaQuery.of(context).size.height / 2,
              decoration: BoxDecoration(
                image: imageUrl != null
                    ? DecorationImage(
                        image: NetworkImage(imageUrl),
                        fit: BoxFit.cover,
                      )
                    : null,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  Text(
                    "Authors: $authors",
                    style: TextStyle(fontSize: 18, color: Colors.grey[700]),
                  ),
                  SizedBox(height: 8),
                  Text(
                    "Publisher: $publisher",
                    style: TextStyle(fontSize: 18, color: Colors.grey[700]),
                  ),
                  SizedBox(height: 16),
                  Text(
                    "Description:",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  ExpandableDescription(description: description),
                  SizedBox(height: 16),
                  pdfUrl != null
                      ? ElevatedButton(
                          onPressed: () => _launchURL(pdfUrl),
                          child: Text('Read PDF'),
                        )
                      : Text(
                          'PDF not available',
                          style: TextStyle(fontSize: 18, color: Colors.red),
                        ),
                  SizedBox(height: 16),
                  webReaderLink != null
                      ? ElevatedButton(
                          onPressed: () => _launchURL(webReaderLink),
                          child: Text('Read Online'),
                        )
                      : Text(
                          'Web reader not available',
                          style: TextStyle(fontSize: 18, color: Colors.red),
                        ),
                  SizedBox(height: 16),
                  previewLink != null
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    backgroundColor:
                                        Theme.of(context).canvasColor),
                                onPressed: () => _launchURL(previewLink),
                                child: Text(
                                  'Preview Book',
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 20),
                                ),
                              ),
                              ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor:
                                          Theme.of(context).canvasColor),
                                  onPressed: _saveBook,
                                  child: Text(
                                    "Save Book",
                                    style: TextStyle(
                                        color: Colors.white, fontSize: 20),
                                  ))
                            ])
                      : Text(
                          'Preview not available',
                          style: TextStyle(fontSize: 16, color: Colors.white),
                        ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ExpandableDescription extends StatefulWidget {
  final String description;

  const ExpandableDescription({super.key, required this.description});

  @override
  State<ExpandableDescription> createState() => _ExpandableDescriptionState();
}

class _ExpandableDescriptionState extends State<ExpandableDescription> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          isExpanded
              ? widget.description
              : (widget.description.length > 150
                  ? "${widget.description.substring(0, 150)}..."
                  : widget.description),
          style: TextStyle(fontSize: 16, color: Colors.grey[700]),
        ),
        if (widget.description.length > 150)
          TextButton(
            onPressed: () {
              setState(() {
                isExpanded = !isExpanded;
              });
            },
            child: Text(
              isExpanded ? "Show Less" : "Show More",
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).canvasColor),
            ),
          ),
      ],
    );
  }
}
