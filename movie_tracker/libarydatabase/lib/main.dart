import 'package:flutter/material.dart';
import 'screens/library_screen.dart';

void main() {
  runApp(const LibraryApp());
}

class LibraryApp extends StatelessWidget {
  const LibraryApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: LibraryScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}