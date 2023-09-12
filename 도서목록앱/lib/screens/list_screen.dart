import 'package:flutter/material.dart';
import 'package:flutter_book_list/screens/detail_screen.dart';
import 'package:flutter_book_list/repositories/book_repository.dart';
import 'package:flutter_book_list/models/book.dart';

class ListScreen extends StatelessWidget {
  ListScreen({super.key});
  final List<Book> books = BookRepository().getBooks();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('도서 목록 앱'),
        centerTitle: true,
      ),
      body: ListView.builder(
        itemCount: books.length,
        itemBuilder: (context, index) {
          return BookTile(book: books[index]);
        },
      ),
    );
  }
}

class BookTile extends StatelessWidget {
  final Book book;

  const BookTile({
    super.key,
    required this.book,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(book.title),
      leading: Image.network(book.image),
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => DetailScreen(
              title: book.title,
              subtitle: book.subtitle,
              description: book.description,
              image: book.image,
            ),
          ),
        );
      },
    );
  }
}
