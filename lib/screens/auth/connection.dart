import 'package:buy_it_app/widgets/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ConnectionScreen extends StatefulWidget {
  const ConnectionScreen({Key? key}) : super(key: key);

  @override
  _ConnectionScreenState createState() => _ConnectionScreenState();
}

class _ConnectionScreenState extends State<ConnectionScreen> {
  bool stateBar = true;
  bool _load = false;

  late User? user;

  GlobalKey<FormState> registerFormKey = GlobalKey();
  GlobalKey<FormState> loginFormKey = GlobalKey();
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController pwdController = TextEditingController();
  TextEditingController pwdConfirmController = TextEditingController();

  void userData() async {
    setState(() {
      user = FirebaseAuth.instance.currentUser;
    });
  }

  Future<void> registerUser() async {
    try {
      await FirebaseFirestore.instance.collection('users').doc().set({
        'name': nameController.text,
        'email': emailController.text,
        //le mot de passe n'est pas enregistré quelque soit la methode que j'utilise
        // 'password': pwdConfirmController.text,
        'status': 'customer',
      });

      UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
              email: emailController.text, password: pwdConfirmController.text);
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Votre compte a été crée')));
      Navigator.pop(context);
    } on FirebaseException catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('${e.message}')));
      print('Erreur : ${e.message}');
    }
  }

  Future<void> loginUser() async {
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(
              email: emailController.text, password: pwdController.text);
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Connexion réussie')));
      Navigator.pushNamed(context, 'home');
    } on FirebaseException catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('${e.message}')));
      print('Erreur : ${e.message}');
    }
  }

  @override
  void initState() {
    userData();
    super.initState();
  }

  @override
  void dispose() {
    emailController.dispose();
    pwdConfirmController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: stateBar ? kTitle('Inscription') : kTitle('Connexion'),
        ),
        body: SingleChildScrollView(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    SizedBox(
                      height: 50,
                    ),
                    TextButton(
                      onPressed: () {
                        setState(() {
                          stateBar = stateBar ? stateBar : !stateBar;
                        });
                      },
                      child: Text(
                        'S\'INSCRIRE',
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 20,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        setState(() {
                          stateBar = !stateBar ? stateBar : !stateBar;
                        });
                      },
                      child: Text(
                        'SE CONNECTER',
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 20,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Container(
                      margin: stateBar
                          ? EdgeInsets.only(right: 150)
                          : EdgeInsets.only(left: 150),
                      color: Colors.red,
                      width: stateBar ? 100 : 130,
                      height: 5,
                    ),
                  ],
                ),
                SizedBox(
                  height: 40,
                ),
                stateBar
                    ? Form(
                        key: registerFormKey,
                        child: Column(
                          children: [
                            Container(
                              height: 70,
                              width: 300,
                              child: TextFormField(
                                controller: nameController,
                                keyboardType: TextInputType.text,
                                decoration: kInputDecoration('nom utilisateur'),
                                validator: (val) => val!.isEmpty
                                    ? 'Veuillez saisir un nom  d\' utilisateur !'
                                    : null,
                              ),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Container(
                              height: 70,
                              width: 300,
                              child: TextFormField(
                                controller: emailController,
                                keyboardType: TextInputType.emailAddress,
                                decoration: kInputDecoration('adresse email'),
                                validator: (val) => val!.isEmpty
                                    ? 'Veuillez saisir une adresse email valide !'
                                    : null,
                              ),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Container(
                              height: 70,
                              width: 300,
                              child: TextFormField(
                                obscureText: true,
                                controller: pwdController,
                                keyboardType: TextInputType.text,
                                decoration: kInputDecoration('mot de passe'),
                                validator: (val) => val!.length < 6
                                    ? 'minimum 6 caratères requis !'
                                    : null,
                              ),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Container(
                              height: 70,
                              width: 300,
                              child: TextFormField(
                                obscureText: true,
                                controller: pwdConfirmController,
                                keyboardType: TextInputType.text,
                                decoration: kInputDecoration(
                                    'confirmation mot de passe'),
                                validator: (val) => val != pwdController.text
                                    ? 'Le mot de passe ne correspond pas !'
                                    : null,
                              ),
                            ),
                            _load
                                ? CircularProgressIndicator()
                                : TextButton(
                                    onPressed: () {
                                      if (registerFormKey.currentState!
                                          .validate()) {
                                        setState(() {
                                          _load = !_load;
                                        });
                                        registerUser();
                                      }
                                    },
                                    child: Text('S\'INSCRIRE')),
                          ],
                        ),
                      )
                    : Form(
                        key: loginFormKey,
                        child: Column(
                          children: [
                            Container(
                              height: 70,
                              width: 300,
                              child: TextFormField(
                                controller: emailController,
                                keyboardType: TextInputType.emailAddress,
                                decoration: kInputDecoration('adresse email'),
                                validator: (val) => val!.isEmpty
                                    ? 'Veuillez saisir une adresse email valide !'
                                    : null,
                              ),
                            ),
                            SizedBox(
                              height: 5,
                            ),
                            Container(
                              height: 70,
                              width: 300,
                              child: TextFormField(
                                obscureText: true,
                                controller: pwdController,
                                keyboardType: TextInputType.text,
                                decoration: kInputDecoration('mot de passe'),
                                validator: (val) => val!.length < 6
                                    ? 'minimum 6 caratères requis !'
                                    : null,
                              ),
                            ),
                            _load
                                ? CircularProgressIndicator()
                                : TextButton(
                                    onPressed: () {
                                      if (loginFormKey.currentState!
                                          .validate()) {
                                        setState(() {
                                          _load = !_load;
                                          loginUser();
                                        });
                                      }
                                    },
                                    child: Text('SE CONNECTER')),
                          ],
                        ),
                      ),
                Text('Accès rapide'),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextButton(
                        onPressed: () {},
                        child: Image(
                          image: AssetImage(
                            'assets/images/facebook.png',
                          ),
                          height: 25,
                          width: 25,
                        )),
                    TextButton(
                        onPressed: () {},
                        child: Image(
                          image: AssetImage(
                            'assets/images/google.png',
                          ),
                          height: 25,
                          width: 25,
                        )),
                  ],
                ),
                Container(
                  margin: EdgeInsets.only(top: 10),
                  decoration: BoxDecoration(
                      boxShadow: [
                        BoxShadow(
                          blurRadius: 4,
                        )
                      ],
                      color: Colors.red,
                      borderRadius: BorderRadius.circular(50)),
                  height: 50,
                  width: 50,
                  child: IconButton(
                      onPressed: () {
                        Navigator.pushNamed(context, 'home');
                      },
                      icon: Icon(
                        Icons.arrow_back,
                        color: Colors.white,
                      )),
                ),
              ],
            ),
          ),
        ));
  }
}
