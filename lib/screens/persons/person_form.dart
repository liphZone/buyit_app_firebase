import 'dart:math';

import 'package:buy_it_app/screens/home.dart';
import 'package:buy_it_app/widgets/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class PersonFormScreen extends StatefulWidget {
  const PersonFormScreen({Key? key}) : super(key: key);

  @override
  _PersonFormScreenState createState() => _PersonFormScreenState();
}

class _PersonFormScreenState extends State<PersonFormScreen> {
  User? user;
  bool load = false;

  GlobalKey<FormState> personFormKey = GlobalKey();
  TextEditingController nomController = TextEditingController();
  TextEditingController prenomController = TextEditingController();
  TextEditingController contactController = TextEditingController();
  TextEditingController companyController = TextEditingController();

  addPerson() async {
    final ref = 'PERS-${Random().nextInt(100000)}';
    try {
      await firestore.collection('persons').doc(user?.uid).set({
        'nom': nomController.text,
        'prenom': prenomController.text,
        'email': user?.email,
        'contact': contactController.text,
        'company': companyController.text,
        'user_id': user?.uid,
      });
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Vous etes devenu un vendeur')));
      setState(() {
        load = !load;
      });
      Navigator.of(context);
      nomController.clear();
      prenomController.clear();
      contactController.clear();
      companyController.clear();
    } on FirebaseException catch (e) {
      print(e);
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Erreur $e')));
    }
  }

  updateStatusUser() async {
    try {
      firestore.collection('users').doc(user?.email).update({
        'status': 'seller',
      });
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Vous etes devenu un vendeur')));
      setState(() {
        load = !load;
      });
      Navigator.pushNamed(context, 'home');
    } on FirebaseException catch (e) {
      print(e);
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Erreur $e')));
    }
  }

  @override
  void initState() {
    user = FirebaseAuth.instance.currentUser;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Formulaire du vendeur'),
        ),
        body: SingleChildScrollView(
          child: Center(
            child: Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width * .90,
              child: Form(
                key: personFormKey,
                child: Column(
                  children: [
                    Container(
                        margin: EdgeInsets.only(bottom: 50),
                        child: Text(
                          'Parlez nous de vous',
                          style: TextStyle(fontSize: 30),
                        )),
                    TextFormField(
                      controller: nomController,
                      keyboardType: TextInputType.text,
                      decoration: kInputDecoration('Nom'),
                      validator: (val) =>
                          val!.isEmpty ? 'Veuillez saisir votre nom !' : null,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      controller: prenomController,
                      keyboardType: TextInputType.text,
                      decoration: kInputDecoration('Prénom(s)'),
                      validator: (val) => val!.isEmpty
                          ? 'Veuillez saisir votre prénom !'
                          : null,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      controller: contactController,
                      keyboardType: TextInputType.number,
                      decoration: kInputDecoration('Numéro de téléphone'),
                      validator: (val) => val!.isEmpty
                          ? 'Veuillez saisir votre contact !'
                          : null,
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      keyboardType: TextInputType.text,
                      controller: companyController,
                      decoration: kInputDecoration(
                          'Nom de la société  ex: philippes & co'),
                      validator: (val) => val!.isEmpty
                          ? 'Veuillez saisir le nom de votre entreprise !'
                          : null,
                    ),
                    load
                        ? CircularProgressIndicator()
                        : FlatButton(
                            color: Colors.blue,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10)),
                            onPressed: () {
                              if (personFormKey.currentState!.validate()) {
                                setState(() {
                                  load = !load;
                                });
                                addPerson();
                                updateStatusUser();
                              }
                            },
                            child: Text(
                              'Enregistrer',
                              style: TextStyle(color: Colors.white),
                            )),
                    Container(
                      margin: EdgeInsets.only(top: 60),
                      decoration: BoxDecoration(
                          boxShadow: [
                            BoxShadow(
                              blurRadius: 4,
                            )
                          ],
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(50)),
                      height: 50,
                      width: 50,
                      child: IconButton(
                          onPressed: () {
                            Navigator.pushNamed(context, 'home');
                          },
                          icon: Icon(
                            Icons.arrow_back,
                            color: Colors.white,
                          )),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ));
  }
}
