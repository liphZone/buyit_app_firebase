import 'package:buy_it_app/screens/articles/article_screen.dart';
import 'package:buy_it_app/screens/auth/compte_screen.dart';
import 'package:buy_it_app/screens/panier.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int selectIndex = 0;

  List<Widget> screens = [
    ArticleScreen(),
    PanierScreen(),
    CompteScreen(),
  ];

  User? user;

  @override
  void initState() {
    user = FirebaseAuth.instance.currentUser;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: screens.elementAt(selectIndex),
      // drawer: kDrawer(context),
      bottomNavigationBar: BottomAppBar(
        notchMargin: 5,
        elevation: 10,
        clipBehavior: Clip.antiAlias,
        shape: CircularNotchedRectangle(),
        child: BottomNavigationBar(
          currentIndex: selectIndex,
          selectedItemColor: Colors.red,
          unselectedItemColor: Colors.black,
          items: [
            BottomNavigationBarItem(
                icon: Icon(Icons.home_filled), label: 'Accueil'),
            BottomNavigationBarItem(
                icon: Icon(Icons.shopping_cart_outlined), label: 'Panier'),
            BottomNavigationBarItem(
                icon: Icon(Icons.person_outline_sharp), label: 'Compte'),
          ],
          onTap: (val) {
            setState(() {
              selectIndex = val;
            });
          },
        ),
      ),
    );
  }
}
