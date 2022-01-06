import 'package:buy_it_app/screens/articles/article_details.dart';
import 'package:buy_it_app/widgets/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class SearchScreen extends StatefulWidget {
  final search;
  const SearchScreen({Key? key, this.search}) : super(key: key);

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
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
        title: kTitle('Résultat : ${widget.search}'),
      ),
      body: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: SizedBox(
                height: 300,
                width: MediaQuery.of(context).size.width,
                child: StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection('articles')
                        .where('search_keywords', arrayContains: widget.search)
                        .snapshots(),
                    builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                      return GridView.builder(
                          shrinkWrap: true,
                          itemCount: snapshot.data?.docs.length,
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: 2,
                                  crossAxisSpacing: 10,
                                  mainAxisSpacing: 3),
                          itemBuilder: (context, i) {
                            if (snapshot.hasData) {
                              QueryDocumentSnapshot x = snapshot.data!.docs[i];
                              return GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              ArticleDetailScreen(
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
                                      height: 100,
                                      width: 100,
                                      child: Image.network('${x['image']}')),
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
        ),
      ),
    );
  }
}
