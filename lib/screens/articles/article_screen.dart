import 'package:buy_it_app/screens/articles/article_details.dart';
import 'package:buy_it_app/screens/categories/categorie_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ArticleScreen extends StatefulWidget {
  const ArticleScreen({Key? key}) : super(key: key);

  @override
  _ArticleScreenState createState() => _ArticleScreenState();
}

class _ArticleScreenState extends State<ArticleScreen> {
  

  TextEditingController searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'BUY IT',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
        // shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(23)),
        actions: [
          Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                height: 50,
                width: 200,
                child: TextFormField(
                  controller: searchController,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20)),
                    hintText: 'Infinix Hot 10',
                    suffixIcon: IconButton(
                        hoverColor: Colors.blue,
                        onPressed: () {
                          // searchController.text.isNotEmpty
                          //     ? Navigator.push(
                          //         context,
                          //         MaterialPageRoute(
                          //             builder: (context) => ArticlSearchScreen(
                          //                   article: searchList,
                          //                 )))
                          //     : ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          //         content: Text(
                          //             'Veuillez saisir dans le champs de recherche')));

                          // searchArticle();
                        },
                        icon: Icon(
                          Icons.search,
                          color: Colors.black,
                        )),
                  ),
                ),
              )),
          // Padding(
          //   padding: const EdgeInsets.all(8.0),
          //   child: Container(
          //     height: 50,
          //     width: 50,
          //     decoration: BoxDecoration(
          //         color: Colors.blue.shade400,
          //         borderRadius: BorderRadius.circular(30)),
          //     child: IconButton(
          //         onPressed: () {
          //           Navigator.push(
          //               context,
          //               MaterialPageRoute(
          //                   builder: (context) => ArticlSearchScreen(
          //                         article: searchList,
          //                       )));
          //           searchArticle();
          //         },
          //         icon: Icon(Icons.search)),
          //   ),
          // ),
        ],
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        color: Colors.grey.shade200,
        child: SingleChildScrollView(
          physics: const ScrollPhysics(),
          child: Column(children: [
            //Annonce
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 30),
                height: 100,
                width: 300,
                decoration: BoxDecoration(
                    color: Colors.indigo,
                    borderRadius: BorderRadius.circular(30)),
                child: Text.rich(
                  TextSpan(
                      text: 'Cadeau de la semaine\n',
                      style: TextStyle(color: Colors.white, fontSize: 15),
                      children: [
                        TextSpan(
                            text: 'Réduction de 20% sur les articles',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 25,
                                fontWeight: FontWeight.bold))
                      ]),
                ),
              ),
            ),
            //Categories
            Container(
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
                                  GestureDetector(
                                    onTap:(){
                                      Navigator.push(context,
                                      MaterialPageRoute(builder: (context) =>CategorieScreen(
                                        referenceCategorie: '${x['reference']}',
                                        libelleCategorie: '${x['libelle']}',
                                      )));
                                    },
                                    child: Container(
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
            //Autres articles
            // Text('Special'),
            Container(
                height: 150,
                width: MediaQuery.of(context).size.width,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    Row(children: [
                      ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.asset(
                            'assets/images/phone2.jpg',
                            fit: BoxFit.cover,
                            height: 150,
                            width: 250,
                          )),
                      ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: Image.asset(
                            'assets/images/xbox1.jpg',
                            fit: BoxFit.contain,
                            height: 150,
                            width: 400,
                          )),
                    ])
                  ],
                )),
            //Articles
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: SizedBox(
                  height: 300,
                  width: MediaQuery.of(context).size.width,
                  child: StreamBuilder(
                      stream: FirebaseFirestore.instance
                          .collection('articles')
                          .snapshots(),
                      builder:
                          (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                        return GridView.builder(
                            shrinkWrap: true,
                            itemCount: snapshot.data?.docs.length,
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2,
                                    crossAxisSpacing: 6,
                                    mainAxisSpacing: 3),
                            itemBuilder: (context, i) {
                              if (snapshot.hasData) {
                                QueryDocumentSnapshot x =
                                    snapshot.data!.docs[i];
                                return GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                ArticleDetailScreen(
                                                  reference: '${x['reference']}',
                                                  libelle: '${x['libelle']}',
                                                  description : '${x['libelle']}',
                                                  prix : '${x['prix']}',
                                                  quantite : '${x['quantite']}',
                                                  image : '${x['image']}',
                                                  )));
                                  },
                                  child: Column(children: [
                                    Container(
                                      padding: EdgeInsets.all(4),
                                      height: 96,
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(25),
                                          image: DecorationImage(
                                              image:
                                                  NetworkImage('${x['image']}'),
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
          ]),
        ),
      ),
    );
  }
}
