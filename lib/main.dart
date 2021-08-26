import 'package:flutter/material.dart';
import 'package:newsapp_bloc/screens/news_view.dart';
 

// api key 07b547dad53c4208810379a479746cf9



void main() => runApp(MyApp());
 
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Material App',
      debugShowCheckedModeBanner: false,
      home: NewsView()
    );
  }
}