import 'package:buy_it_app/widgets/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class PanierScreen extends StatefulWidget {
  const PanierScreen({Key? key}) : super(key: key);

  @override
  _PanierScreenState createState() => _PanierScreenState();
}

class _PanierScreenState extends State<PanierScreen> {
  User? user;
  //Fonction d'affichage du contenu la collection paniers
  showPanier() async {
    try {
      await firestore.collection('ventes').get().then((snapshot) {
        double sum = 0.0;
        for (var counter = 0; counter < snapshot.docs.length; counter++) {
          sum += int.parse(snapshot.docs[counter]['montant']);
        }
      });
    } on FirebaseException catch (e) {
      print(e);
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Erreur $e')));
    }
  }

  //Fonction de suppression  d'un article dans la collection paniers
  deleteArticlePanier(e) async {
    try {
      firestore.collection('ventes').doc(e).delete();
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Suppression réussi')));
      Navigator.pop(context);
    } on FirebaseException catch (e) {
      print(e.message);
    }
  }

  //Fonction de mise a jour de la collection paniers apres suppression
  updatePanier() async {
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
            .showSnackBar(SnackBar(content: Text('Panier Mise a jour')));
      });
    } on FirebaseException catch (e) {
      print(e);
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Erreur $e')));
    }
  }

  //Fonction de mise a jour de quantite de la collection articles apres suppression( incrementation de la quantite)
  updateQuantiteArticle(doc, q) async {
    DocumentSnapshot documentSnapshot;
    try {
      //recuperer la quantité de l'article
      documentSnapshot = await firestore.collection('articles').doc(doc).get();

      //Mise a jour de la quantite de l'article
      firestore
          .collection('articles')
          .doc(doc)
          .update({'quantite': documentSnapshot.get('quantite') + q});
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Maj quantite')));
    } on FirebaseException catch (e) {
      print(e);
    }
  }

  @override
  void initState() {
    user = FirebaseAuth.instance.currentUser;
    showPanier();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Text(
              'Mon Panier ',
              style: TextStyle(color: Colors.black),
            ),
          ],
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        color: Colors.grey.shade200,
        child: SingleChildScrollView(
          physics: ScrollPhysics(),
          child: Column(children: [
            user?.email == null
                ? Container(
                    height: MediaQuery.of(context).size.height * .70,
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Center(
                        child: Column(
                          children: [
                            Image.asset(
                              'assets/images/sac_vide.png',
                              height: 100,
                            ),
                            Text(
                              'Aucun article dans votre panier actuellement , veuillez effectuer des achats !',
                              style: TextStyle(fontSize: 20),
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.pushNamed(context, 'auth');
                              },
                              child: Text('ou connectez-vous',
                                  style: TextStyle(
                                      fontSize: 20, color: Colors.blue)),
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                : Container(
                    height: MediaQuery.of(context).size.height * .70,
                    child: StreamBuilder(
                        stream: firestore
                            .collection('ventes')
                            .where('user_id', isEqualTo: user?.uid)
                            .snapshots(),
                        builder:
                            (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                          return ListView.builder(
                              scrollDirection: Axis.vertical,
                              shrinkWrap: true,
                              itemCount: snapshot.data?.docs.length,
                              itemBuilder: (context, i) {
                                if (snapshot.hasData) {
                                  QueryDocumentSnapshot x =
                                      snapshot.data!.docs[i];
                                  return Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: GestureDetector(
                                      onTap: () {
                                        //Fonction de suppression du panier
                                      },
                                      child: Row(children: [
                                        Container(
                                          height: 100,
                                          width: 100,
                                          child: Image.network(x['image']),
                                        ),
                                        Container(
                                          height: 100,
                                          width: 120,
                                          child: Column(
                                            children: [
                                              Text(
                                                '${x['article']}',
                                                style: TextStyle(fontSize: 20),
                                              ),
                                              Row(
                                                children: [
                                                  Text('${x['prix_vente']}'),
                                                  Text('\t x \t'),
                                                  Text(
                                                      '${x['quantite_vendue']}'),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                        Container(
                                          height: 70,
                                          width: 70,
                                          decoration: BoxDecoration(
                                            boxShadow: [
                                              BoxShadow(
                                                blurRadius: 2,
                                              ),
                                            ],
                                            color: Colors.grey.shade50,
                                            borderRadius:
                                                BorderRadius.circular(50),
                                          ),
                                          child: IconButton(
                                              onPressed: () {
                                                showDialog(
                                                    context: context,
                                                    builder: (_) => AlertDialog(
                                                        title: Text(
                                                            'Vous allez supprimer ce produit de votre panier?'),
                                                        actions: [
                                                          FlatButton(
                                                              onPressed: () {
                                                                deleteArticlePanier(
                                                                    x['article_id']);
                                                                updatePanier();
                                                                updateQuantiteArticle(
                                                                    x[
                                                                        'article_id'],
                                                                    int.parse(x[
                                                                        'quantite_vendue']));
                                                              },
                                                              child: Text(
                                                                  'Confirmer')),
                                                          FlatButton(
                                                              onPressed: () =>
                                                                  Navigator.pop(
                                                                      context),
                                                              child: Text(
                                                                  'Annuler')),
                                                        ],
                                                        content: Container(
                                                            height: 90,
                                                            child: Column(
                                                                children: [
                                                                  Text(
                                                                      'Article : ${x['article']}'),
                                                                  Text(
                                                                      'Prix unitaire : ${x['prix_vente']} F CFA'),
                                                                  Text(
                                                                      'Quantité à payer : ${x['quantite_vendue']}'),
                                                                ]))));
                                              },
                                              icon: Icon(
                                                Icons.delete,
                                                size: 35,
                                                color: Colors.red,
                                              )),
                                        ),
                                      ]),
                                    ),
                                  );
                                }
                                if (!snapshot.hasData) {
                                  return Container(
                                    height: 70,
                                    width: 70,
                                    child: const CircularProgressIndicator(),
                                  );
                                }
                                return Container(
                                  child: Column(
                                    children: [
                                      Text('chargement en cours'),
                                      CircularProgressIndicator(),
                                    ],
                                  ),
                                );
                              });
                        })),
          ]),
        ),
      ),
      bottomNavigationBar: user?.email != null
          ? Container(
              height: 120,
              decoration:
                  BoxDecoration(color: Colors.grey.shade100, boxShadow: [
                BoxShadow(blurRadius: 4),
              ]),
              child: StreamBuilder(
                  stream: firestore
                      .collection('paniers')
                      .where('user_id', isEqualTo: user?.uid)
                      .snapshots(),
                  builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                    return ListView.builder(
                        scrollDirection: Axis.horizontal,
                        shrinkWrap: true,
                        itemCount: snapshot.data?.docs.length,
                        itemBuilder: (context, i) {
                          if (snapshot.hasData) {
                            QueryDocumentSnapshot x = snapshot.data!.docs[i];
                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(children: [
                                Text(
                                  'Montant total: ${x['montant']} F CFA',
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 20),
                                ),
                                FlatButton(
                                  color: Colors.blue,
                                  onPressed: () {
                                    // ScaffoldMessenger.of(context).showSnackBar(
                                    //     SnackBar(content: Text('Paiement .....')));
                                  },
                                  child: Text(
                                    'Commander',
                                    style: TextStyle(
                                        fontSize: 20, color: Colors.white),
                                  ),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(30)),
                                ),
                                Text(
                                    '${x['total_article']} articles dans le panier'),
                              ]),
                            );
                          }
                          if (!snapshot.hasData) {
                            return Container(
                              height: 70,
                              width: 70,
                              child: Text('Votre panier est vide'),
                            );
                          }
                          return Container(
                            child: Column(
                              children: [
                                Text('chargement en cours'),
                                CircularProgressIndicator(),
                              ],
                            ),
                          );
                        });
                  }))
          : null,
    );
  }
}
