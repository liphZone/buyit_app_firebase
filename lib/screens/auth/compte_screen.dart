import 'package:buy_it_app/screens/categories/categorie_transition.dart';
import 'package:buy_it_app/widgets/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class CompteScreen extends StatefulWidget {
  const CompteScreen({Key? key}) : super(key: key);

  @override
  _CompteScreenState createState() => _CompteScreenState();
}

class _CompteScreenState extends State<CompteScreen> {
  int index = -1;
  Future<void> signOut() async {
    await FirebaseAuth.instance.signOut();
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text('Déconnexion réussie')));
    Navigator.pushNamed(context, 'home');
  }

  User? user;

    @override
  void initState() {
  user = FirebaseAuth.instance.currentUser;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: kTitle('Mon Compte'),
        backgroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Stack(
                children: [
                  Image.asset(
                    'assets/images/user1.png',
                    height: 100,
                    width: 100,
                    fit: BoxFit.cover,
                  ),
                  Positioned(
                    bottom: 0,
                    right: -5,
                    child: Container(
                      height: 30,
                      width: 30,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(30)),
                      child: Icon(Icons.camera_alt),
                    ),
                  ),
                ],
              ),
              user?.email == null
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        TextButton(
                            onPressed: () {
                              Navigator.pushNamed(context, 'auth');
                            },
                            child: const Text('S\'inscrire\t')),
                        TextButton(
                            onPressed: () {
                              Navigator.pushNamed(context, 'auth');
                            },
                            child: const Text('Se connecter')),
                      ],
                    )
                  : Container(
                      height: 50,
                      width: 300,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        '${user?.email}',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  child: ExpansionPanelList(
                    expansionCallback: (i, isOpen) {
                      setState(() {
                        if (index == i)
                          index = -1;
                        else
                          index = i;
                      });
                    },
                    animationDuration: Duration(milliseconds: 900),
                    dividerColor: Colors.teal,
                    elevation: 2,
                    children: [
                      ExpansionPanel(
                        headerBuilder: (BuildContext context, bool isExpanded) {
                          return ListTile(
                            leading: Icon(Icons.person),
                            title: Text("Mon compte"),
                          );
                        },
                        canTapOnHeader: true,
                        body: Column(
                          children: [
                            ListTile(
                              leading: Icon(Icons.person_pin),
                              title: Text("Profil"),
                              onTap: () {
                                //;
                              },
                            ),
                            user?.email != null
                                ? ListTile(
                                    leading: Icon(Icons.logout),
                                    title: Text("Déconnexion "),
                                    onTap: () {
                                      signOut();
                                    },
                                  )
                                : SizedBox(),
                          ],
                        ),
                        isExpanded: index == 0,
                      ),
                      ExpansionPanel(
                        headerBuilder: (BuildContext context, bool isExpanded) {
                          return ListTile(
                            leading: Icon(Icons.flash_on_rounded),
                            title: Text("Ventes"),
                          );
                        },
                        canTapOnHeader: true,
                        body: Column(
                          children: [
                            ListTile(
                              leading: const Icon(Icons.article),
                              title: const Text("Poster produit"),
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const CategorieTransitionScreen()));
                              },
                            ),
                            ListTile(
                              leading: const Icon(Icons.article),
                              title: const Text("Ajouter categorie"),
                              onTap: () {
                                Navigator.pushNamed(context, 'categorie_form');
                                //Navigation vers categorie Transition
                              },
                            ),
                            ListTile(
                              leading: const Icon(Icons.sell),
                              title: const Text("Je veux vendre"),
                              onTap: () {
                                //Navigation vers PersonForm
                              },
                            )
                          ],
                        ),
                        isExpanded: index == 1,
                      ),
                      ExpansionPanel(
                        headerBuilder: (BuildContext context, bool isExpanded) {
                          return ListTile(
                            leading: Icon(Icons.settings),
                            title: Text("Paramètres"),
                          );
                        },
                        canTapOnHeader: true,
                        body: Column(
                          children: [
                            ListTile(
                              leading: Icon(Icons.monetization_on),
                              title: Text("Devise"),
                            ),
                            ListTile(
                              leading: Icon(Icons.language),
                              title: Text("Livraison"),
                            ),
                            ListTile(
                              leading: Icon(Icons.lock),
                              title: Text("Politique de confidentialité"),
                            ),
                            ListTile(
                              leading: Icon(Icons.text_snippet_sharp),
                              title: Text("Informations légales"),
                            ),
                          ],
                        ),
                        isExpanded: index == 2,
                      ),
                      ExpansionPanel(
                        headerBuilder: (BuildContext context, bool isExpanded) {
                          return ListTile(
                            leading: Icon(Icons.help),
                            title: Text("Centre d'aide"),
                          );
                        },
                        canTapOnHeader: true,
                        body: ListTile(
                          title: Text("-"),
                          subtitle: const Text('-'),
                        ),
                        isExpanded: index == 3,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
