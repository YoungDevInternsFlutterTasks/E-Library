import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NotesScreen extends StatefulWidget {
  final String bookId; // Unique identifier for the book

  const NotesScreen({super.key, required this.bookId});

  @override
  State<NotesScreen> createState() => _NotesScreenState();
}

class _NotesScreenState extends State<NotesScreen> {
  TextEditingController _notesController = TextEditingController();
  bool _isEditing = false; // Track if editing is allowed

  @override
  void initState() {
    super.initState();
    _loadSavedNotes();
  }

  // Load saved notes from SharedPreferences for the specific book
  Future<void> _loadSavedNotes() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _notesController.text = prefs.getString('notes_${widget.bookId}') ?? '';
    });
  }

  // Save notes to SharedPreferences for the specific book
  Future<void> _saveNotes() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('notes_${widget.bookId}', _notesController.text);
    setState(() {
      _isEditing = false; // Disable editing after saving
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Notes saved!')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).canvasColor,
        title: const Text(
          "Notes",
          style: TextStyle(
              fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextFormField(
              controller: _notesController,
              maxLines: 10,
              readOnly: !_isEditing, // Disable editing if not in edit mode
              decoration: InputDecoration(
                hintText: "Write your notes here...",
                filled: true,
                fillColor: Colors.white,
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: const BorderSide(
                    color: Colors.white,
                    width: 1.5,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: BorderSide(
                    color: Theme.of(context).canvasColor,
                    width: 2.0,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).canvasColor),
                  onPressed: _isEditing ? _saveNotes : null,
                  child: const Text(
                    "Save",
                    style: TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Theme.of(context).canvasColor),
                  onPressed: () {
                    setState(() {
                      _isEditing = true; // Enable editing mode
                    });
                  },
                  child: const Text("Edit",
                      style: TextStyle(
                          fontSize: 20,
                          color: Colors.white,
                          fontWeight: FontWeight.bold)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
