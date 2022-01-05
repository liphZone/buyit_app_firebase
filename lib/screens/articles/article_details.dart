import 'package:flutter/material.dart';

class ArticleDetailScreen extends StatefulWidget {
  const ArticleDetailScreen({Key? key}) : super(key: key);

  @override
  _ArticleDetailScreenState createState() => _ArticleDetailScreenState();
}

class _ArticleDetailScreenState extends State<ArticleDetailScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      appBar: AppBar(
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        title:
            Text('Article : spiderman', style: TextStyle(color: Colors.black)),
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
      body: SingleChildScrollView(
        child: Column(
          children: [
            //***Image du produit
            // Center(
            //     child: Container(
            //       margin: EdgeInsets.only(top: 6),
            //       height: 200,
            //       width: 200,
            //       decoration: BoxDecoration(
            //           borderRadius: BorderRadius.circular(15),
            //           image: DecorationImage(
            //               image: NetworkImage('${widget.article!.image}'),
            //               fit: BoxFit.cover)),
            //     ),
            //   ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                height: 200,
                width: 200,
                decoration: BoxDecoration(
                  color: Colors.blueAccent,
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Row(
              children: [
                IconButton(
                    onPressed: () {
                      // removeQuantite();
                      // qvChangeController.text = '$qValue';
                    },
                    icon: Icon(Icons.remove)),
                IconButton(
                    onPressed: () {
                      // addQuantite();
                      // qvChangeController.text = '$qValue';
                    },
                    icon: const Icon(Icons.add)),
                Container(
                  height: 50,
                  width: 50,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(30)),
                  child: Center(
                    child: TextFormField(
                      textAlign: TextAlign.center,
                      readOnly: true,
                      // controller: qvChangeController,
                      // decoration: kInputDecoration('$qValue'),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
