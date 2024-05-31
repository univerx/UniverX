import 'package:flutter/material.dart';
import 'package:univerx/models/noteModel.dart';
import 'package:univerx/database_helper.dart';
import 'package:univerx/features/home/presentation/pages/homePage.dart';

// ---------------------Widgets--------------------------
import 'package:univerx/features/common/widgets/default_app_bar.dart';

class Notes extends StatefulWidget {
  const Notes({Key? key}) : super(key: key);

  @override
  _NotesState createState() => _NotesState();
}

class _NotesState extends State<Notes> {
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;
  late Future<List<Note>> _notesList;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _refreshNotes();
  }

  void _refreshNotes() {
    setState(() {
      _notesList = _dbHelper.getNotes();
    });
  }

  void _showNoteDialog({Note? note}) {
    if (note != null) {
      _titleController.text = note.title;
      _contentController.text = note.content;
    } else {
      _titleController.clear();
      _contentController.clear();
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(note == null ? 'Create Note' : 'Edit Note'),
          content: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  TextFormField(
                    controller: _titleController,
                    decoration: InputDecoration(labelText: 'Title'),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a title';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: _contentController,
                    decoration: InputDecoration(labelText: 'Content'),
                    maxLines: null,
                    keyboardType: TextInputType.multiline,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter content';
                      }
                      return null;
                    },
                  ),
                ],
              ),
            ),
          ),
          actions: <Widget>[
            ElevatedButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            ElevatedButton(
              child: Text(note == null ? 'Create' : 'Update'),
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  if (note == null) {
                    _dbHelper.insertNote(
                      Note(
                        title: _titleController.text,
                        content: _contentController.text,
                      ),
                    );
                  } else {
                    _dbHelper.updateNote(
                      Note(
                        id: note.id,
                        title: _titleController.text,
                        content: _contentController.text,
                      ),
                    );
                  }
                  Navigator.of(context).pop();
                  _refreshNotes();
                }
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,

      appBar: DefaultAppBar(
          title: "UniX-Notes",
          showBackButton: true,
      ),
      
      body: FutureBuilder<List<Note>>(
        future: _notesList,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text('No notes available.'));
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final note = snapshot.data![index];
                return Card(
                  elevation: 4,
                  margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  child: ListTile(
                    title: Text(
                      note.title,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(note.content),
                    onTap: () => _showNoteDialog(note: note),
                    trailing: IconButton(
                      icon: Icon(Icons.delete),
                      onPressed: () {
                        _dbHelper.deleteNote(note.id!);
                        _refreshNotes();
                      },
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showNoteDialog(),
        child: Icon(Icons.add),
      ),
    );
  }
}
