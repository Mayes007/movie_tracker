class Book {
  int? id;
  String title;
  String author;
  bool borrowed;

  Book({
    this.id,
    required this.title,
    required this.author,
    this.borrowed = false,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'author': author,
      'borrowed': borrowed ? 1 : 0,
    };
  }

  factory Book.fromMap(Map<String, dynamic> map) {
    return Book(
      id: map['id'],
      title: map['title'],
      author: map['author'],
      borrowed: map['borrowed'] == 1,
    );
  }
}