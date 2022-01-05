import 'dart:math';

import 'package:buy_it_app/widgets/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class CategorieFormScreen extends StatefulWidget {
  const CategorieFormScreen({Key? key}) : super(key: key);

  @override
  _CategorieFormScreenState createState() => _CategorieFormScreenState();
}

class _CategorieFormScreenState extends State<CategorieFormScreen> {
  GlobalKey<FormState> categorieFormKey = GlobalKey();
  TextEditingController libelleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController subCategorieController = TextEditingController();

  bool load = false;

  addCategorie() async {
    var libelle = libelleController.text;
    try {
      await FirebaseFirestore.instance.collection('categories').doc().set({
        'reference': 'CAT-${Random().nextInt(100000)}',
        'libelle': '${libelle[0].toUpperCase()}${libelle.substring(1)}',
        'description': '${descriptionController.text}',
      });
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Vous avez ajouté une catégorie')));
      setState(() {
        load = !load;
      });
      Navigator.pop(context);
    } on FirebaseException catch (e) {
      print(e);
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Erreur $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: kTitle('Ajouter une catégorie')),
        body: SingleChildScrollView(
          child: Form(
            key: categorieFormKey,
            child: Container(
              margin: EdgeInsets.all(4),
              height: MediaQuery.of(context).size.height * 0.75,
              width: MediaQuery.of(context).size.width,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextFormField(
                    controller: libelleController,
                    decoration: kInputDecoration('Libelle'),
                    validator: (val) => val!.isEmpty
                        ? 'Veuillez saisir le Libelle de la categorie'
                        : null,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    controller: descriptionController,
                    decoration: kInputDecoration('Description'),
                    validator: (val) => val!.isEmpty
                        ? 'Veuillez saisir une description de la categorie'
                        : null,
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  // TextFormField(
                  //   controller: subCategorieController,
                  //   decoration: kInputDecoration('Sous-catégorie'),
                  // ),
                  load
                      ? CircularProgressIndicator()
                      : FlatButton(
                          color: Colors.blue,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          onPressed: () {
                            if (categorieFormKey.currentState!.validate()) {
                              setState(() {
                                load = !load;
                              });
                              addCategorie();
                              print('OK');
                            }
                          },
                          child: Text(
                            'Enregistrer',
                            style: TextStyle(color: Colors.white),
                          ))
                ],
              ),
            ),
          ),
        ));
  }
}
