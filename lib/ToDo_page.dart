import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'LoginIn.dart';

class TodoPage extends StatefulWidget {
  const TodoPage({super.key});

  @override
  State<TodoPage> createState() => _TodoPageState();
}

class _TodoPageState extends State<TodoPage> {
  final user = FirebaseAuth.instance.currentUser;
  final TextEditingController _todoController = TextEditingController();

  String? userName;

  @override
  void initState() {
    super.initState();
    getUserName();
  }

  Future<void> getUserName() async {
    final uid = FirebaseAuth.instance.currentUser!.uid;
    final doc =
        await FirebaseFirestore.instance.collection('users').doc(uid).get();
    setState(() {
      userName = doc['name'];
    });
  }

  CollectionReference<Map<String, dynamic>> get todoRef {
    return FirebaseFirestore.instance
        .collection('users')
        .doc(user!.uid)
        .collection('todos');
  }

  Future<void> addTodo(String title) async {
    await todoRef.add({
      'title': title,
      'isDone': false,
      'timestamp': FieldValue.serverTimestamp(),
    });
    _todoController.clear();
  }

  Future<void> toggleTodoDone(String id, bool isDone) async {
    await todoRef.doc(id).update({'isDone': isDone});
  }

  Future<void> deleteTodo(String id) async {
    await todoRef.doc(id).delete();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color(0xff323232),
            Color(0xff252525),
            Color(0xff1a1a1a),
            Color(0xff121212),
            Color(0xff000000),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          stops: [0.5, 0.65, 0.8, 0.9, 1],
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Colors.black.withOpacity(0.2),
          title: Text(
            'Welcome, ${userName ?? ''}',
            style: GoogleFonts.spaceGrotesk(
              textStyle: TextStyle(fontSize: 20, color: Colors.white),
            ),
          ),
          actions: [
            IconButton(
              icon: Icon(
                CupertinoIcons.square_arrow_right,
                color: Colors.white,
              ),
              onPressed: () async {
                await FirebaseAuth.instance.signOut();
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (_) => LoginIn()),
                  (route) => false,
                );
              },
            ),
          ],
        ),
        body: Column(
          children: [
            //* Input field to add todo
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _todoController,
                      cursorColor: Colors.red,
                      style: GoogleFonts.spaceGrotesk(
                        textStyle: TextStyle(fontSize: 20, color: Colors.white),
                      ),
                      decoration: InputDecoration(
                        hintText: 'Add todo...',
                        hintStyle: TextStyle(
                          color: Colors.white60, // Change to any color you want
                          fontSize: 16,
                        ),
                        //fillColor: Colors.white,
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.add_circle, size: 30, color: Colors.red),
                    onPressed: () {
                      if (_todoController.text.trim().isNotEmpty) {
                        addTodo(_todoController.text.trim());
                      }
                    },
                  ),
                ],
              ),
            ),

            //* List of todos
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream:
                    todoRef.orderBy('timestamp', descending: true).snapshots(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData)
                    return Center(child: CircularProgressIndicator());

                  final todos = snapshot.data!.docs;

                  if (todos.isEmpty) {
                    return Center(
                      child: Text(
                        "No todos yet.",
                        style: GoogleFonts.spaceGrotesk(
                          color: Colors.white,
                          fontSize: 20,
                        ),
                      ),
                    );
                  }

                  return ListView.builder(
                    itemCount: todos.length,
                    itemBuilder: (context, index) {
                      final todo = todos[index];
                      return ListTile(
                        title: Text(
                          todo['title'],
                          style: GoogleFonts.spaceGrotesk(
                            color: Colors.white,
                            fontSize: 16,
                          ),
                        ),
                        leading: Checkbox(
                          checkColor: Colors.red,
                          value: todo['isDone'],
                          onChanged: (val) {
                            toggleTodoDone(todo.id, val!);
                          },
                        ),
                        trailing: IconButton(
                          icon: Icon(Icons.delete, color: Colors.red),
                          onPressed: () => deleteTodo(todo.id),
                        ),
                      );
                    },
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
