import 'dart:io';
import 'dart:math';

import 'package:buy_it_app/widgets/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class ArticleFormScreen extends StatefulWidget {
  final categorieReference;
  const ArticleFormScreen({Key? key, this.categorieReference})
      : super(key: key);

  @override
  _ArticleFormScreenState createState() => _ArticleFormScreenState();
}

class _ArticleFormScreenState extends State<ArticleFormScreen> {
  GlobalKey<FormState> articleFormKey = GlobalKey();
  TextEditingController libelleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController prixController = TextEditingController();
  TextEditingController quantiteController = TextEditingController();

  bool load = false;

  ImagePicker image = ImagePicker();

  File? file;
  String url = "";

  User? user;

  getImage() async {
    var img = await image.pickImage(source: ImageSource.gallery);
    setState(() {
      if (img == null) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Aucune image sélectionnée')));
      }
      file = File(img!.path);
    });
  }

  void userData() async {
    setState(() {
      user = FirebaseAuth.instance.currentUser;
    });
  }

  addArticle() async {
    var libelle = libelleController.text;
    var imageFile = FirebaseStorage.instance
        .ref()
        .child('articles')
        .child('${libelleController.text}/.jpg');
    UploadTask task = imageFile.putFile(file!);
    TaskSnapshot snapshot = await task;
    url = await snapshot.ref.getDownloadURL();

    try {
      await FirebaseFirestore.instance.collection('articles').doc().set({
        'reference': 'PROD-${Random().nextInt(100000)}',
        'libelle': '${libelle[0].toUpperCase()}${libelle.substring(1)}',
        'description': descriptionController.text,
        'categorie_id': widget.categorieReference,
        'prix': prixController.text,
        'quantite': quantiteController.text,
        'image': url,
        'user_id': user?.uid
      });
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Vous avez ajouté un article')));
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
  void initState() {
    userData();
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: kTitle('Ajouter article'),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: articleFormKey,
          child: Container(
            margin: EdgeInsets.all(10),
            child: Column(
              children: [
                GestureDetector(
                  onTap: getImage,
                  child: Column(
                    children: [
                      Text('Choisissez votre image ici'),
                      CircleAvatar(
                        backgroundImage: file == null
                            ? AssetImage("")
                            : FileImage(File(file!.path)) as ImageProvider,
                        radius: 80,
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                TextFormField(
                  controller: libelleController,
                  keyboardType: TextInputType.text,
                  decoration: kInputDecoration('Libelle'),
                  validator: (val) => val!.isEmpty
                      ? 'Veuillez saisir le libelle de l\'article !'
                      : null,
                ),
                SizedBox(
                  height: 20,
                ),
                TextFormField(
                  controller: descriptionController,
                  keyboardType: TextInputType.text,
                  decoration: kInputDecoration('Description'),
                  validator: (val) => val!.isEmpty
                      ? 'Veuillez entrer une description de l\' article'
                      : null,
                ),
                SizedBox(
                  height: 20,
                ),
                TextFormField(
                  controller: prixController,
                  keyboardType: TextInputType.number,
                  decoration: kInputDecoration('Prix'),
                  validator: (val) => val!.isEmpty
                      ? 'Veuillez saisir le prix de l\'article !'
                      : null,
                ),
                SizedBox(
                  height: 20,
                ),
                TextFormField(
                  controller: quantiteController,
                  keyboardType: TextInputType.number,
                  decoration: kInputDecoration('Quantité'),
                  validator: (val) => val!.isEmpty
                      ? 'Veuillez saisir la quantité à enregistrer !'
                      : null,
                ),
                load
                    ? CircularProgressIndicator()
                    : FlatButton(
                        color: Colors.blue,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        onPressed: () {
                          if (articleFormKey.currentState!.validate()) {
                            setState(() {
                              load = !load;
                            });
                            addArticle();
                          }
                        },
                        child: Text(
                          'Enregistrer',
                          style: TextStyle(color: Colors.white),
                        )),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
