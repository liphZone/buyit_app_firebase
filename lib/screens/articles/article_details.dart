import 'dart:math';

import 'package:buy_it_app/widgets/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ArticleDetailScreen extends StatefulWidget {
  final reference;
  final libelle;
  final description;
  final prix;
  final quantite;
  final image;
  const ArticleDetailScreen(
      {Key? key,
      this.libelle,
      this.description,
      this.prix,
      this.quantite,
      this.image,
      this.reference})
      : super(key: key);

  @override
  _ArticleDetailScreenState createState() => _ArticleDetailScreenState();
}

class _ArticleDetailScreenState extends State<ArticleDetailScreen> {
  GlobalKey<FormState> venteFormKey = GlobalKey();
  bool load = false;

  int qValue = 1;

  var qvChangeController = TextEditingController();
  User? user;

  //Fonction incrementation quantité
  void addQuantite() {
    setState(() {
      if (qValue < 5) {
        qValue++;
      }
      qValue;
    });
  }

  //Fonction decrmentation quantite
  void removeQuantite() {
    setState(() {
      qValue == 1 ? qValue = qValue : qValue--;
    });
  }

  //Ajout de produit dans la collection ventes
  addVente() async {
    try {
      await firestore.collection('ventes').doc(widget.reference).set({
        'reference': 'V-${Random().nextInt(100000)}',
        'article_id': widget.reference,
        'article': widget.libelle,
        'prix_vente': widget.prix,
        'quantite_vendue': qvChangeController.text,
        'user_id': user?.uid,
        'montant':
            '${int.parse(widget.prix) * int.parse(qvChangeController.text)}',
        'image': widget.image
      });
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Nouveau produit ajouté au panier')));
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

  //Ajout du produit dans la collection paniers
  addPanier() async {
    try {
      await firestore.collection('ventes').get().then((snapshot) {
        double sum = 0.0;
        for (var counter = 0; counter < snapshot.docs.length; counter++) {
          sum += int.parse(snapshot.docs[counter]['montant']);
        }
        firestore.collection('paniers').doc(user?.uid).set({
          'user_id': user?.uid,
          'montant': sum,
          'total_article': snapshot.docs.length
        });
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Article ajouté au panier')));
      });
    } on FirebaseException catch (e) {
      print(e);
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Erreur $e')));
    }
  }

  //Mise a jour de la quantit de l'article (decrementation apres ajout au panier)
  updateQuantiteArticle() async {
    try {
      firestore.collection('articles').doc(widget.reference).update({
        'quantite':
            int.parse(widget.quantite) - int.parse(qvChangeController.text),
      });
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Mise à jour réussi')));
    } on FirebaseException catch (e) {
      print(e);
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
      backgroundColor: Colors.grey.shade200,
      appBar: AppBar(
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        title: Text('Article : ${widget.libelle}',
            style: TextStyle(color: Colors.black)),
        leading: IconButton(
            onPressed: () {},
            icon: Container(
                height: 40,
                width: 40,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(30)),
                child: IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: Icon(
                      Icons.arrow_back_ios_new,
                      color: Colors.black,
                    )))),
      ),
      body: SingleChildScrollView(
        physics: ScrollPhysics(),
        child: Column(
          children: [
            // ***Image du produit
            Center(
              child: Container(
                margin: EdgeInsets.only(top: 6),
                height: 200,
                width: 200,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    image: DecorationImage(
                        image: NetworkImage('${widget.image}'),
                        fit: BoxFit.cover)),
              ),
            ),
            Text(
              '${widget.libelle}',
              style: TextStyle(fontSize: 30),
            ),
            Text(
              'Détails: ${widget.description}',
              style: TextStyle(fontSize: 20),
            ),
            int.parse(widget.quantite) >= int.parse(widget.quantite) / 2 - 2
                ? Text(
                    'Quantité disponible: ${widget.quantite}',
                    style: TextStyle(fontSize: 20),
                  )
                : Text('Quantité disponible: ${widget.quantite}',
                    style: TextStyle(fontSize: 20, color: Colors.red)),
            SizedBox(
              height: 10,
            ),
            Row(
              children: [
                IconButton(
                    onPressed: () {
                      removeQuantite();
                      qvChangeController.text = '$qValue';
                    },
                    icon: Icon(Icons.remove)),
                IconButton(
                    onPressed: () {
                      addQuantite();
                      qvChangeController.text = '$qValue';
                    },
                    icon: const Icon(Icons.add)),
                Container(
                  height: 50,
                  width: 50,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(30)),
                  child: Center(
                    child: TextFormField(
                      textAlign: TextAlign.center,
                      readOnly: true,
                      controller: qvChangeController,
                      decoration: kInputDecoration('$qValue'),
                    ),
                  ),
                ),
              ],
            ),
            int.parse(widget.quantite) > 3 && int.parse(widget.quantite) > 5
                ? FlatButton(
                    color: Colors.blue,
                    splashColor: Colors.lightBlue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    onPressed: () {
                      showDialog(
                          context: context,
                          builder: (_) => AlertDialog(
                              title: Text(
                                  'Vous allez ajouter dans votre panier  ${int.parse(widget.quantite) / 4}?'),
                              actions: [
                                FlatButton(
                                    onPressed: () {
                                      addVente();
                                      addPanier();
                                      updateQuantiteArticle();
                                    },
                                    child: Text('Confirmer')),
                                FlatButton(
                                    onPressed: () => Navigator.pop(context),
                                    child: Text('Annuler')),
                              ],
                              content: Form(
                                key: venteFormKey,
                                child: Container(
                                  height: 200,
                                  child: ListView(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: TextFormField(
                                            readOnly: true,
                                            initialValue: '${widget.libelle}',
                                            decoration: InputDecoration(
                                              labelText: 'Produit',
                                              border: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          30)),
                                            )),
                                      ),
                                      SizedBox(
                                        height: 10,
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: TextFormField(
                                            readOnly: true,
                                            initialValue:
                                                qvChangeController.text,
                                            decoration: InputDecoration(
                                              labelText: 'Quantité à ajouter',
                                              border: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          30)),
                                            )),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: TextFormField(
                                            readOnly: true,
                                            initialValue: '${widget.prix}',
                                            decoration: InputDecoration(
                                              labelText: 'Prix',
                                              border: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          30)),
                                            )),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: TextFormField(
                                            readOnly: true,
                                            initialValue:
                                                "${int.parse(widget.prix) * qValue as int}",
                                            decoration: InputDecoration(
                                              labelText: 'Montant',
                                              border: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          30)),
                                            )),
                                      )
                                    ],
                                  ),
                                ),
                              )));
                    },
                    child: Text(
                      'Ajouter au Panier',
                      style: TextStyle(color: Colors.white),
                    ))
                : Text('Quantité en stock insuffisante',
                    style: TextStyle(color: Colors.red, fontSize: 20)),
          ],
        ),
      ),
    );
  }
}
