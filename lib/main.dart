import 'package:film_newwave/screen/list_film_screen.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Film Demo',
      debugShowCheckedModeBanner: false,
      theme: theme,
      home: const ListFilmScreen(),
    );
  }
}

ThemeData theme = ThemeData(
  scaffoldBackgroundColor: Colors.white,
  textTheme: const TextTheme(
    headline4: TextStyle(fontSize: 17, color: Colors.grey, fontWeight: FontWeight.w700),
    headline5: TextStyle(fontSize: 15, color: Colors.grey, fontWeight: FontWeight.w600),
    bodyText1: TextStyle(fontSize: 15, color: Colors.black, fontWeight: FontWeight.w400),
  ),
);
