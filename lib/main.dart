import 'package:buy_it_app/screens/articles/article_screen.dart';
import 'package:buy_it_app/screens/auth/connection.dart';
import 'package:buy_it_app/screens/categories/categorie_form.dart';
import 'package:buy_it_app/screens/home.dart';
import 'package:buy_it_app/screens/panier.dart';
import 'package:buy_it_app/screens/persons/person_form.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: 'home',
      routes: {
        'home': (context) => const HomeScreen(),
        'article': (context) => const ArticleScreen(),
        'categorie_form': (context) => const CategorieFormScreen(),
        'panier': (context) => const PanierScreen(),
        'auth': (context) => const ConnectionScreen(),
        'person_form': (context) => const PersonFormScreen(),
      },
      debugShowCheckedModeBanner: false,
      title: 'BUY IT',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const HomeScreen(),
    );
  }
}
