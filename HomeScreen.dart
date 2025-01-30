import 'dart:convert';
import 'package:ebookslibrary/screens/Home/BookScreen.dart';
import 'package:ebookslibrary/screens/SavedBooksScreen.dart';
import 'package:ebookslibrary/utils/OurTheme.dart';
import 'package:http/http.dart' as https;
import 'package:ebookslibrary/screens/Home/bookcard.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final String apiKey = 'Add your API Key here ';
  final String baseUrl = 'https://www.googleapis.com/books/v1/volumes';
  List<dynamic> books = [];
  bool _isLoading = false;
  final TextEditingController _searchController = TextEditingController();
  String _selectedCategory = 'Fiction'; // Default category

  final List<String> categories = [
    'Fiction',
    'Non-Fiction',
    'Science',
    'Technology',
    'Biography',
    'History',
    'Self-Help',
  ];

  @override
  void initState() {
    super.initState();
    _fetchDefaultBooks();
  }

  void _fetchDefaultBooks() async {
    setState(() => _isLoading = true);
    try {
      final response = await https.get(
        Uri.parse(
            "$baseUrl?q=subject:$_selectedCategory&key=$apiKey&maxResults=20"),
      );
      final data = json.decode(response.body);
      // Shuffle the books list to display random books
      final shuffledBooks = (data['items'] as List).toList()..shuffle();
      setState(() => books = shuffledBooks);
    } catch (e) {
      print("Error: $e");
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _searchBooks(String query, String category) async {
    if (query.isEmpty) {
      // If the query is empty, fetch default books for the selected category
      _fetchDefaultBooks();
      return;
    }
    setState(() => _isLoading = true);
    try {
      final response = await https.get(
        Uri.parse("$baseUrl?q=$query+subject:$category&key=$apiKey"),
      );
      final data = json.decode(response.body);
      setState(() => books = data['items'] ?? []);
    } catch (e) {
      print("Error: $e");
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final OurTheme theme = OurTheme();
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Theme.of(context).canvasColor,
        centerTitle: true,
        title: const Text(
          'Books Library',
          style: TextStyle(
              fontSize: 25, color: Colors.black, fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
            onPressed: () {
              Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => SavedBooksScreen()));
            },
            icon: Icon(Icons.book_sharp)),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _searchController,
                    decoration: theme.inputDecoration(context).copyWith(
                          fillColor: Colors.grey[200],
                          hintText: "Search for Books...",
                          prefixIcon: const Icon(Icons.search),
                        ),
                    onChanged: (query) {
                      // Fetch books dynamically as the user types
                      _searchBooks(query, _selectedCategory);
                    },
                  ),
                ),
                const SizedBox(width: 10),
                DropdownButton<String>(
                  value: _selectedCategory,
                  onChanged: (String? newValue) {
                    setState(() {
                      _selectedCategory = newValue!;
                      // Fetch books for the new category when the dropdown value changes
                      _searchBooks(_searchController.text, _selectedCategory);
                    });
                  },
                  items:
                      categories.map<DropdownMenuItem<String>>((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
          Expanded(
            child: _isLoading
                ? const Center(child: CircularProgressIndicator())
                : books.isEmpty
                    ? const Center(child: Text("No Books Found"))
                    : GridView.builder(
                        padding: const EdgeInsets.all(10),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 10,
                          childAspectRatio: 0.65,
                        ),
                        itemCount: books.length,
                        itemBuilder: (context, index) {
                          final book = books[index]['volumeInfo'];
                          return InkWell(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          Bookscreen(book: book)));
                            },
                            child: BookCard(book: book),
                          );
                        },
                      ),
          ),
        ],
      ),
    );
  }
}
