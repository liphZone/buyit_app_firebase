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
  @override
  void initState() {
    user = FirebaseAuth.instance.currentUser;
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
          child: Container(
            height: MediaQuery.of(context).size.height * .70,
            child: Column(children: [
              user?.email == null
                  ? Padding(
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
                    )
                  : Container(
                      height: 300,
                      width: MediaQuery.of(context).size.width,
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
                                        for (var s = 0; s < ds.length; s++) {
                                          sum  += int.parse(ds[s]['montant']);
                                          montant = sum;
                                        }

                                    return Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Column(children: [
                                        GestureDetector(
                                          onTap: () {
                                            Text('OK');
                                          },
                                          child: Container(
                                              margin: EdgeInsets.all(10),
                                              padding: EdgeInsets.all(5),
                                              height: 200,
                                              width: 100,
                                              decoration: BoxDecoration(
                                                color: Colors.orange.shade300,
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              ),
                                              child: Column(
                                                children: [
                                                  Icon(Icons
                                                      .phone_android_outlined),
                                                  Text('${x['montant']}'),
                                                  Text('Montant  $sum'),
                                                ],
                                              )),
                                        ),
                                      ]),
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
                      ' $montant F CFA',
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
