import 'package:buy_it_app/widgets/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class CategorieScreen extends StatefulWidget {
  const CategorieScreen({Key? key}) : super(key: key);

  @override
  _CategorieScreenState createState() => _CategorieScreenState();
}

class _CategorieScreenState extends State<CategorieScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: kTitle('Categorie produit'),
        centerTitle: true,
        backgroundColor: Colors.white,
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
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child:  Container(
                height: 100,
                width: MediaQuery.of(context).size.width,
                child: StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection('categories')
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
                                  Container(
                                      margin: EdgeInsets.all(10),
                                      padding: EdgeInsets.all(5),
                                      height: 50,
                                      width: 100,
                                      decoration: BoxDecoration(
                                        color: Colors.orange.shade300,
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: Column(
                                        children: [
                                          Icon(Icons.phone_android_outlined),
                                          Text('${x['libelle']}'),
                                        ],
                                      )),
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
      ),
    );
  }
}
