import 'dart:math';

import 'package:buy_it_app/widgets/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
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

  void addQuantite() {
    setState(() {
      qValue++;
    });
  }

  void removeQuantite() {
    setState(() {
      qValue == 1 ? qValue = qValue : qValue--;
    });
  }

  addVente() async {
    try {
      await FirebaseFirestore.instance.collection('ventes').doc().set({
        'reference': 'V-${Random().nextInt(100000)}',
        'article_id': widget.reference,
        'prix_vente': widget.prix,
        'quantite_vendue': widget.quantite,
        'user_id': 1,
        'montant': '${int.parse(widget.prix) * int.parse(widget.quantite)}',
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

  @override
  void initState() {
    qvChangeController.text = '$qValue';
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
            Text(
              'Quantité disponible:${widget.quantite}',
              style: TextStyle(fontSize: 20),
            ),
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
             FlatButton(
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
                                  'Vous allez ajouter  dans votre panier  ?'),
                              actions: [
                                FlatButton(
                                    onPressed: () {
                                      addVente();
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
                                                "${int.parse(widget.prix) * int.parse(widget.quantite)}",
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
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
