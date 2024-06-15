import 'package:flutter/material.dart';
import 'package:univerx/features/notes/data/model/noteModel.dart';
import 'package:univerx/database/database_helper.dart';

// ---------------------Widgets--------------------------
import 'package:univerx/features/common/widgets/default_app_bar.dart';
import 'package:univerx/features/common/widgets/profile_menu.dart';
import 'package:univerx/features/notes/presentation/NoteDetailPage.dart';

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
                        createdAt: DateTime.now().toString(), // Set createdAt here
                      ),
                    );
                  } else {
                    _dbHelper.updateNote(
                      Note(
                        id: note.id,
                        title: _titleController.text,
                        content: _contentController.text,
                        createdAt: note.createdAt, // Keep the existing createdAt
                        isFavorite: note.isFavorite, // Keep the existing isFavorite
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

  void _toggleFavorite(Note note) {
    setState(() {
      note.isFavorite = !note.isFavorite;
    });
    _dbHelper.updateNote(note);
    _refreshNotes();
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
                  await _dbHelper.deleteNote(note.id!);
                  Navigator.of(context).pop();
                  _refreshNotes();
                }
              },
              child: Text('Delete'),
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
      endDrawer: const DrawerMenu(), //Profile_menu pop up
      body: CustomScrollView(
        slivers: <Widget>[
          DefaultAppBar(
            title: "UniX-Notes",
            showBackButton: true,
          ),
          SliverList(
            delegate: SliverChildListDelegate(
              [
                FutureBuilder<List<Note>>(
                  future: _notesList,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Center(child: Text('Error: ${snapshot.error}'));
                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return const Center(child: Text('No notes available.'));
                    } else {
                      // Sort notes by isFavorite and createdAt
                      final notes = snapshot.data!;
                      notes.sort((a, b) {
                        if (a.isFavorite == b.isFavorite) {
                          return b.createdAt.compareTo(a.createdAt);
                        }
                        return a.isFavorite ? -1 : 1;
                      });

                      return ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: notes.length,
                        itemBuilder: (context, index) {
                          final note = notes[index];
                          return Card(
                            elevation: 4,
                            margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                            child: ListTile(
                              title: Text(
                                note.title,
                                style: const TextStyle(fontWeight: FontWeight.bold),
                              ),
                              subtitle: Text(note.createdAt), // Use createdAt instead of date
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => NoteDetailPage(note: note),
                                  ),
                                );
                              },
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    icon: Icon(note.isFavorite ? Icons.favorite : Icons.favorite_border),
                                    onPressed: () => _toggleFavorite(note),
                                  ),
                                  IconButton(
                                    icon: Icon(Icons.delete),
                                    onPressed: () => _deleteNoteConfirmation(context, note),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showNoteDialog(),
        child: const Icon(Icons.add),
      ),
    );
  }
}
