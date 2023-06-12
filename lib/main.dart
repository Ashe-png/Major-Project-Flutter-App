import 'package:flutter/material.dart';

import 'package:major/views/home_view.dart';
import 'package:major/views/respose_view.dart';

import 'constants/routes.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return Builder(builder: (context) {
      return MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          // Set the background color
          scaffoldBackgroundColor: const Color.fromARGB(255, 27, 34, 35),

          // Set the text color
          textTheme: const TextTheme(
            bodyMedium: TextStyle(
              color: Color.fromARGB(255, 244, 254, 253),
            ),
          ),

          // Set the app bar color
          appBarTheme: const AppBarTheme(
            backgroundColor: Color.fromARGB(255, 3, 224, 253),
          ),
        ),
        home: const HomePage(),
        routes: {
          responseRoute: (context) => const ResponseView(),
          homeRoute: (context) => const HomePage(),
        },
      );
    });
  }
}
