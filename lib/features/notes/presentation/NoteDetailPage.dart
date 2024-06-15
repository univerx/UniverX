import 'package:flutter/material.dart';
import 'package:univerx/features/notes/data/model/noteModel.dart';
import 'package:univerx/database/database_helper.dart'; // Ensure you import your database file

class NoteDetailPage extends StatelessWidget {
  final Note note;

  NoteDetailPage({required this.note});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(note.title),
        actions: [
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: () {
              _editNote(context, note);
            },
          ),
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: () {
              _deleteNoteConfirmation(context, note);
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              note.createdAt,
              style: const TextStyle(
                fontSize: 12,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              note.content,
              style: const TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }

  void _editNote(BuildContext context, Note note) async {
    final editedNote = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => EditNotePage(note: note)), // Define this page to edit the note
    );

    if (editedNote != null) {
      // Here you should update the note in the database
      await DatabaseHelper.instance.updateNote(editedNote);
      Navigator.pop(context); // Return to the previous screen after updating
    }
  }

  void _deleteNoteConfirmation(BuildContext context, Note note) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Delete Note'),
          content: Text('Are you sure you want to delete this note?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                if (note.id != null) {
                  await DatabaseHelper.instance.deleteNote(note.id!);
                  Navigator.of(context).pop();
                  Navigator.of(context).pop(true); // Return after deleting
                }
              },
              child: Text('Delete'),
            ),
          ],
        );
      },
    );
  }
}

// You'll also need a page for editing notes, for example:
class EditNotePage extends StatefulWidget {
  final Note note;

  EditNotePage({required this.note});

  @override
  _EditNotePageState createState() => _EditNotePageState();
}

class _EditNotePageState extends State<EditNotePage> {
  final _formKey = GlobalKey<FormState>();
  late String _title;
  late String _content;

  @override
  void initState() {
    super.initState();
    _title = widget.note.title;
    _content = widget.note.content;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Note'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                initialValue: _title,
                decoration: InputDecoration(labelText: 'Title'),
                onSaved: (value) {
                  _title = value ?? '';
                },
              ),
              TextFormField(
                initialValue: _content,
                decoration: InputDecoration(labelText: 'Content'),
                onSaved: (value) {
                  _content = value ?? '';
                },
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState?.validate() ?? false) {
                    _formKey.currentState?.save();
                    final editedNote = Note(
                      id: widget.note.id,
                      title: _title,
                      content: _content,
                      createdAt: widget.note.createdAt,
                      isFavorite: widget.note.isFavorite,
                    );
                    Navigator.of(context).pop(editedNote);
                  }
                },
                child: Text('Save'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
