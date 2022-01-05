import 'package:buy_it_app/widgets/constants.dart';
import 'package:flutter/material.dart';

class ArticleFormScreen extends StatefulWidget {
  final categorieReference;
  const ArticleFormScreen({Key? key, this.categorieReference})
      : super(key: key);

  @override
  _ArticleFormScreenState createState() => _ArticleFormScreenState();
}

class _ArticleFormScreenState extends State<ArticleFormScreen> {
  GlobalKey<FormState> articleFormKey = GlobalKey();
  TextEditingController libelleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController prixController = TextEditingController();
  TextEditingController quantiteController = TextEditingController();

  bool load = false;

  addArticle(){
    
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: kTitle('Ajouter article'),
      ),
      body: SingleChildScrollView(
        child: Form(
          key: articleFormKey,
          child: Container(
            margin: EdgeInsets.all(10),
            child: Column(
              children: [
                GestureDetector(
                  onTap: () {},
                  child: Column(
                    children: [
                      const Text('Choisissez votre image ici'),
                      Container(
                          height: 100,
                          width: 100,
                          decoration: BoxDecoration(
                              color: Colors.grey,
                              borderRadius: BorderRadius.circular(20))),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                TextFormField(
                  controller: libelleController,
                  keyboardType: TextInputType.text,
                  decoration: kInputDecoration('Libelle'),
                  validator: (val) => val!.isEmpty
                      ? 'Veuillez saisir le libelle de l\'article !'
                      : null,
                ),
                SizedBox(
                  height: 20,
                ),
                TextFormField(
                  controller: descriptionController,
                  keyboardType: TextInputType.text,
                  decoration: kInputDecoration('Description'),
                  validator: (val) => val!.isEmpty
                      ? 'Veuillez entrer une description de l\' article'
                      : null,
                ),
                SizedBox(
                  height: 20,
                ),
                TextFormField(
                  controller: prixController,
                  keyboardType: TextInputType.number,
                  decoration: kInputDecoration('Prix'),
                  validator: (val) => val!.isEmpty
                      ? 'Veuillez saisir le prix de l\'article !'
                      : null,
                ),
                SizedBox(
                  height: 20,
                ),
                TextFormField(
                  controller: quantiteController,
                  keyboardType: TextInputType.number,
                  decoration: kInputDecoration('Quantité'),
                  validator: (val) => val!.isEmpty
                      ? 'Veuillez saisir la quantité à enregistrer !'
                      : null,
                ),
                load
                    ? CircularProgressIndicator()
                    : FlatButton(
                        color: Colors.blue,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        onPressed: () {
                          if (articleFormKey.currentState!.validate()) {
                            setState(() {
                              load = !load;
                            });
                            // addArticle();
                          }
                        },
                        child: Text(
                          'Enregistrer',
                          style: TextStyle(color: Colors.white),
                        )),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
