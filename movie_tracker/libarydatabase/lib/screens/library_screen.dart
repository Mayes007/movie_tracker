import 'package:flutter/material.dart';
import '../database/library_database.dart';
import '../models/book.dart';

class LibraryScreen extends StatefulWidget {
  const LibraryScreen({super.key});

  @override
  State<LibraryScreen> createState() => _LibraryScreenState();
}

class _LibraryScreenState extends State<LibraryScreen> {

  List<Book> books = [];

  final titleController = TextEditingController();
  final authorController = TextEditingController();

  Future refreshBooks() async {
    books = await LibraryDatabase.instance.readAllBooks();
    setState(() {});
  }

  Future addBook() async {

    final book = Book(
      title: titleController.text,
      author: authorController.text,
    );

    await LibraryDatabase.instance.createBook(book);

    titleController.clear();
    authorController.clear();

    refreshBooks();
  }

  @override
  void initState() {
    super.initState();
    refreshBooks();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text("Library Catalog"),
      ),

      body: Column(
        children: [

          TextField(
            controller: titleController,
            decoration: const InputDecoration(
              labelText: "Book Title",
            ),
          ),

          TextField(
            controller: authorController,
            decoration: const InputDecoration(
              labelText: "Author",
            ),
          ),

          ElevatedButton(
            onPressed: addBook,
            child: const Text("Add Book"),
          ),

          Expanded(
            child: ListView.builder(
              itemCount: books.length,
              itemBuilder: (context, index) {

                final book = books[index];

                return ListTile(
                  title: Text(book.title),
                  subtitle: Text(book.author),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () async {

                      await LibraryDatabase.instance.deleteBook(book.id!);

                      refreshBooks();
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}