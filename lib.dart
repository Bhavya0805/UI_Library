import 'package:flutter/material.dart';

void main() {
  runApp(LibraryApp());
}

class LibraryApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Library Management System',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: LibraryScreen(),
    );
  }
}

class Book {
  String id;
  String title;
  String author;
  bool isAvailable;

  Book({
    required this.id,
    required this.title,
    required this.author,
    this.isAvailable = true,
  });
}

class LibraryScreen extends StatefulWidget {
  @override
  _LibraryScreenState createState() => _LibraryScreenState();
}

class _LibraryScreenState extends State<LibraryScreen> {
  final List<Book> books = [];

  final TextEditingController idController = TextEditingController();
  final TextEditingController titleController = TextEditingController();
  final TextEditingController authorController = TextEditingController();

  void addBook() {
    if (idController.text.isNotEmpty &&
        titleController.text.isNotEmpty &&
        authorController.text.isNotEmpty) {
      setState(() {
        books.add(Book(
          id: idController.text,
          title: titleController.text,
          author: authorController.text,
        ));
        idController.clear();
        titleController.clear();
        authorController.clear();
      });
      Navigator.of(context).pop();
    }
  }

  void borrowBook(Book book) {
    setState(() {
      book.isAvailable = false;
    });
  }

  void returnBook(Book book) {
    setState(() {
      book.isAvailable = true;
    });
  }

  void removeBook(Book book) {
    setState(() {
      books.remove(book);
    });
  }

  void showAddBookDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Add New Book'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: idController,
                decoration: InputDecoration(labelText: 'Book ID'),
              ),
              TextField(
                controller: titleController,
                decoration: InputDecoration(labelText: 'Book Title'),
              ),
              TextField(
                controller: authorController,
                decoration: InputDecoration(labelText: 'Book Author'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: addBook,
              child: Text('Add'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Library Management System'),
      ),
      body: books.isEmpty
          ? Center(
              child: Text(
                'No books in the library. Add some!',
                style: TextStyle(fontSize: 18),
              ),
            )
          : ListView.builder(
              itemCount: books.length,
              itemBuilder: (context, index) {
                final book = books[index];
                return Card(
                  margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  child: ListTile(
                    title: Text(book.title),
                    subtitle: Text('Author: ${book.author}\nID: ${book.id}'),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: Icon(
                            book.isAvailable ? Icons.download : Icons.upload,
                            color: book.isAvailable ? Colors.green : Colors.red,
                          ),
                          onPressed: () =>
                              book.isAvailable ? borrowBook(book) : returnBook(book),
                        ),
                        IconButton(
                          icon: Icon(Icons.delete, color: Colors.grey),
                          onPressed: () => removeBook(book),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: showAddBookDialog,
        child: Icon(Icons.add),
      ),
    );
  }
}
