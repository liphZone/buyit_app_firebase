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

  double? montant;

//Verifier s'il ya quelque chose dans le panier
  // existPanier() async {
  //   await FirebaseFirestore.instance
  //       .collection('paniers')
  //       .get()
  //       .then((snapshot) {
  //     if (snapshot.size == 0) {
  //       return Container(
  //         height: 200,
  //         width: 200,
  //         child: Image.asset(
  //           'assets/images/panier_vide.png',
  //           height: 100,
  //         ),
  //       );
  //     }
  //   });
  // }

  addPanier() async {
    try {
      await FirebaseFirestore.instance.collection('ventes').doc(user?.uid).set({
        'user_id': user?.uid,
        'montant': montant,
      });
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Panier mis a jour')));

      Navigator.pop(context);
    } on FirebaseException catch (e) {
      print(e);
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Erreur $e')));
    }
  }

  @override
  void initState() {
    user = FirebaseAuth.instance.currentUser;
    // existPanier();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Text(
              'BUY IT',
              style: TextStyle(color: Colors.black),
            ),
            Spacer(),
            Text(
              'Mon Panier',
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
                        stream: FirebaseFirestore.instance
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
                                  var ds = snapshot.data!.docs;
                                  double sum = 0.0;
                                  for (var counter = 0;
                                      counter < ds.length;
                                      counter++) {
                                    sum += int.parse(ds[counter]['montant']);
                                      montant = sum;
                                  }

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
                                          width: 100,
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
                                              )
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
                                              onPressed: () {},
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
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    // vente == null
                    //     ? CircularProgressIndicator()
                    //     :
                    Text(
                      'Montant total: $montant F CFA',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                    ),
                    Row(
                      children: [
                        IconButton(onPressed: () {}, icon: Icon(Icons.refresh)),
                        FlatButton(
                          color: Colors.blue,
                          onPressed: () {
                            // ScaffoldMessenger.of(context).showSnackBar(
                            //     SnackBar(content: Text('Paiement .....')));
                            
                          },
                          child: Text(
                            'Commander',
                            style: TextStyle(fontSize: 20, color: Colors.white),
                          ),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30)),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            )
          : null,
    );
  }
}
