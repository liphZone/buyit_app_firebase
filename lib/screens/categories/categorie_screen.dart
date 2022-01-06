import 'package:buy_it_app/screens/articles/article_details.dart';
import 'package:buy_it_app/widgets/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class CategorieScreen extends StatefulWidget {
  final libelleCategorie;
  final referenceCategorie;
  const CategorieScreen(
      {Key? key, this.libelleCategorie, this.referenceCategorie})
      : super(key: key);

  @override
  _CategorieScreenState createState() => _CategorieScreenState();
}

class _CategorieScreenState extends State<CategorieScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: kTitle('${widget.libelleCategorie}'),
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
        child: Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            child: StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection('articles')
                    .where('categorie_id', isEqualTo: widget.referenceCategorie)
                    .snapshots(),
                builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  return GridView.builder(
                      shrinkWrap: true,
                      itemCount: snapshot.data?.docs.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 6,
                          mainAxisSpacing: 3),
                      itemBuilder: (context, i) {
                        if (snapshot.hasData) {
                          QueryDocumentSnapshot x = snapshot.data!.docs[i];
                          return GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => ArticleDetailScreen(
                                            reference: '${x['reference']}',
                                            libelle: '${x['libelle']}',
                                            description: '${x['libelle']}',
                                            prix: '${x['prix']}',
                                            quantite: '${x['quantite']}',
                                            image: '${x['image']}',
                                          )));
                            },
                            child: Column(children: [
                              Container(
                                padding: EdgeInsets.all(4),
                                height: 96,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(25),
                                    image: DecorationImage(
                                        image: NetworkImage('${x['image']}'),
                                        fit: BoxFit.cover)),
                              ),
                              Text('${x['libelle']}'),
                              Text('${x['prix']} F CFA'),
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
