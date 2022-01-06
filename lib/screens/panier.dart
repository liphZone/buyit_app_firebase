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

  void userData() async {
    setState(() {
      user = FirebaseAuth.instance.currentUser;
    });
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
      body: SingleChildScrollView(
        child: Column(
          children: [
            user?.email == null
                ? Padding(
                    padding: const EdgeInsets.all(20),
                    child: Center(
                      child: Container(
                        margin: EdgeInsets.all(10),
                        height: 300,
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                          color: Colors.grey.shade50,
                          borderRadius: BorderRadius.circular(10),
                        ),
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
                : Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SizedBox(
                        height: MediaQuery.of(context).size.height,
                        width: MediaQuery.of(context).size.width,
                        child: StreamBuilder(
                            stream: FirebaseFirestore.instance
                                .collection('articles')
                                .where('user_id', isEqualTo: user?.email)
                                .snapshots(),
                            builder: (context,
                                AsyncSnapshot<QuerySnapshot> snapshot) {
                              return ListView.builder(
                                  shrinkWrap: true,
                                  scrollDirection: Axis.vertical,
                                  itemCount: snapshot.data?.docs.length,
                                  itemBuilder: (context, i) {
                                    if (snapshot.hasData) {
                                      QueryDocumentSnapshot x =
                                          snapshot.data!.docs[i];
                                      return Row(children: [
                                        Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Container(
                                            height: 150,
                                            width: 150,
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(25),
                                                image: DecorationImage(
                                                    image: NetworkImage(
                                                        '${x['image']}'),
                                                    fit: BoxFit.cover)),
                                          ),
                                        ),
                                        Column(
                                          children: [
                                            Text('${x['libelle']}'),
                                            Text('${x['prix']} F CFA'),
                                          ],
                                        ),
                                      ]);
                                    }

                                    if (!snapshot.hasData) {
                                      return Container();
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
                  ),
          ],
        ),
      ),
      bottomNavigationBar: user?.email != null
          ? Container(
              height: 100,
              decoration:
                  BoxDecoration(color: Colors.grey.shade100, boxShadow: [
                BoxShadow(blurRadius: 4),
              ]),
              child: Center(
                child: Column(
                  children: [
                    // vente == null
                    //     ? CircularProgressIndicator()
                    //     :
                    Text(
                      'Montant total : Montant total des produits dans le panier F CFA',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                    ),
                    Visibility(
                      // visible: articleList.length == 0 ? false : true,
                      child: FlatButton(
                        color: Colors.blue,
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Paiement .....')));
                          showDialog(
                              context: context,
                              builder: (_) => AlertDialog(
                                    title:
                                        Text('Veuillez saisir votre contact'),
                                    content: Container(
                                      height: 200,
                                      child: Column(
                                        children: [
                                          FlatButton(
                                              color: Colors.blue,
                                              textColor: Colors.white,
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          20)),
                                              onPressed: () {
                                                //Payment page
                                              },
                                              child: Text('Flooz ')),
                                          FlatButton(
                                              color: Colors.blue,
                                              textColor: Colors.white,
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          20)),
                                              onPressed: () {
                                                //Payment Tmoney
                                              },
                                              child: Text('Tmoney')),
                                        ],
                                      ),
                                    ),
                                    actions: [
                                      FlatButton(
                                          onPressed: () {
                                            // Navigator.pop(context);
                                            // addPayment();
                                          },
                                          child: Text('Verifier')),
                                    ],
                                  ));
                        },
                        child: Text(
                          'Commander',
                          style: TextStyle(fontSize: 20, color: Colors.white),
                        ),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30)),
                      ),
                    )
                  ],
                ),
              ),
            )
          : null,
    );
  }
}
