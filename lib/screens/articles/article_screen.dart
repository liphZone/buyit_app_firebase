import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ArticleScreen extends StatefulWidget {
  const ArticleScreen({Key? key}) : super(key: key);

  @override
  _ArticleScreenState createState() => _ArticleScreenState();
}

class _ArticleScreenState extends State<ArticleScreen> {
  TextEditingController searchController = TextEditingController();

  addArticle() async{
    //  await FirebaseFirestore.instance
    //     .collection('articles')
    //     .doc()
    //     .set({
    //       'libelle': 'Ryse of rome',
    //       'quantite' : 10,
    //       'prix' : 15000,
    //      'imageUrl': url});
    // print('URL IMAGE  $url');
  }

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
              child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: 3,
                  itemBuilder: (BuildContext context, int index) {
                    return GestureDetector(
                      child: Column(
                        children: [
                          Container(
                              margin: EdgeInsets.all(10),
                              height: 50,
                              width: 100,
                              decoration: BoxDecoration(
                                color: Colors.orange.shade300,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Icon(Icons.phone_android_outlined)),
                          Container(
                            child: Text('Text'),
                          ),
                        ],
                      ),
                      onTap: () {
                        Navigator.pushNamed(context, 'categorie');
                      },
                    );
                  }),
            ),
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
            GridView.builder(
                shrinkWrap: true,
                physics: ScrollPhysics(),
                itemCount: 8,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2),
                itemBuilder: (BuildContext context, int index) {
                  // Article article = articleList[index];
                  return Column(
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(context, 'article_detail');
                        },
                        child: Column(
                          children: [
                            //***Image produit
                            // Container(
                            //   padding: EdgeInsets.all(4),
                            //   height: 96,
                            //   decoration: BoxDecoration(
                            //       borderRadius:
                            //           BorderRadius.circular(25),
                            //       image: DecorationImage(
                            //           image: NetworkImage(
                            //               '${article.image}'),
                            //           fit: BoxFit.cover)),
                            // ),
                            Text('Spiderman'),
                            Text('5000 F CFA'),
                          ],
                        ),
                      ),
                    ],
                  );
                }),
          ]),
        ),
      ),
    );
  }
}
