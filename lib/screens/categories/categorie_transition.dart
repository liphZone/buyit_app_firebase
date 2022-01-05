// import 'package:buy_it_app/screens/articles/article_form.dart';
import 'package:buy_it_app/screens/articles/article_form.dart';
import 'package:buy_it_app/widgets/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
// import 'package:firebase_core/firebase_core.dart';

class CategorieTransitionScreen extends StatefulWidget {
  const CategorieTransitionScreen({Key? key}) : super(key: key);

  @override
  _CategorieTransitionScreenState createState() =>
      _CategorieTransitionScreenState();
}

class _CategorieTransitionScreenState extends State<CategorieTransitionScreen> {
  final FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<void> showCategories() async {
    DocumentSnapshot documentSnapshot;
    try {
      documentSnapshot = await firestore.collection('categories').doc().get();
      // ScaffoldMessenger.of(context)
      //     .showSnackBar(SnackBar(content: Text('Lecture réussi')));
      print('CATEGORIES : ${documentSnapshot.data()}');
    } on FirebaseException catch (e) {
      print(e);
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Erreur $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
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
        backgroundColor: Colors.white,
        title: kTitle('Catégorie de produit'),
      ),
      body: SingleChildScrollView(
        physics: const ScrollPhysics(),
        child: Column(
          children: [
            Padding(
              //Affichage categories
              padding: const EdgeInsets.all(5),
              child: Container(
                height: 300,
                width: MediaQuery.of(context).size.width,
                child: StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection('categories')
                        .snapshots(),
                    builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                      return ListView.builder(
                          shrinkWrap: true,
                          itemCount: snapshot.data?.docs.length,
                          itemBuilder: (context, i) {
                            if (snapshot.hasData) {
                              QueryDocumentSnapshot x = snapshot.data!.docs[i];
                              return Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Container(
                                  child: Row(children: [
                                    Container(
                                        child: Column(
                                      children: [
                                        Icon(Icons.phone_android_outlined),
                                        Text('${x['libelle']}'),
                                      ],
                                    )),
                                    PopupMenuButton(
                                      itemBuilder: (context) => [
                                        PopupMenuItem(
                                            child: Text('Poster article'),
                                            value: 'Poster')
                                      ],
                                      onSelected: (val) {
                                        if (val == 'Poster') {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      ArticleFormScreen(
                                                        categorieReference:
                                                            '${x['reference']}',
                                                      )));
                                        }
                                      },
                                    )
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
                    }),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
