import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:fluttertoast/fluttertoast.dart';
import '/allscreens/login.dart';
import '/allscreens/mainscreen.dart';
import '/main.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

import '../allwidgets/progres.dart';

class Register extends StatefulWidget {
  const Register({Key? key}) : super(key: key);

  static const String idScreen = "register";

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {

  TextEditingController nameTextEditingController = TextEditingController();
  TextEditingController phoneTextEditingController = TextEditingController();
  TextEditingController mailTextEditingController = TextEditingController();
  TextEditingController passwordTextEditingController = TextEditingController();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(8.0),
          child: Column(
            children: [
              SizedBox(height: 35.0,),
              Image(
                image: AssetImage("images/logo.png"),
                width: 350.0,
                height: 250.0,
                alignment: Alignment.center,
              ),

              SizedBox(height: 1.0,),
              Text(
                "Register as a Rider",
                style: TextStyle(fontSize: 24.0 ),
                textAlign: TextAlign.center,
              ),

              Padding(
                padding: EdgeInsets.all(20.0),
                child: Column(
                  children: [

                    SizedBox(height: 1.0,),
                    TextField(
                      controller: nameTextEditingController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        labelText: "Name",
                        labelStyle: TextStyle(
                          fontSize: 14.0,
                        ),
                        hintStyle: TextStyle(
                          color: Colors.grey,
                          fontSize: 10.0,
                        ),
                      ),
                      style: TextStyle(fontSize: 14.0),
                    ),

                    SizedBox(height: 1.0,),
                    TextField(
                      controller: phoneTextEditingController,
                      keyboardType: TextInputType.phone,
                      decoration: InputDecoration(
                        labelText: "Phone",
                        labelStyle: TextStyle(
                          fontSize: 14.0,
                        ),
                        hintStyle: TextStyle(
                          color: Colors.grey,
                          fontSize: 10.0,
                        ),
                      ),
                      style: TextStyle(fontSize: 14.0),
                    ),

                    SizedBox(height: 1.0,),
                    TextField(
                      controller: mailTextEditingController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        labelText: "Email",
                        labelStyle: TextStyle(
                          fontSize: 14.0,
                        ),
                        hintStyle: TextStyle(
                          color: Colors.grey,
                          fontSize: 10.0,
                        ),
                      ),
                      style: TextStyle(fontSize: 14.0),
                    ),

                    SizedBox(height: 1.0,),
                    TextField(
                      controller: passwordTextEditingController,
                      obscureText: true,
                      decoration: InputDecoration(
                        labelText: "Password",
                        labelStyle: TextStyle(
                          fontSize: 14.0,
                        ),
                        hintStyle: TextStyle(
                          color: Colors.grey,
                          fontSize: 10.0,
                        ),
                      ),
                      style: TextStyle(fontSize: 14.0),
                    ),

                    SizedBox(height: 1.0,),
                    RaisedButton(
                      color: Colors.yellow,
                      textColor: Colors.white,
                      child: Container(
                        height: 35.0,
                        child: Center(
                          child: Text(
                            "Créer un compte",
                            style: TextStyle(fontSize: 18.0),
                          ),
                        ),
                      ),
                      shape: new RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(24.0),
                      ),
                      onPressed: (){
                        if(phoneTextEditingController.text.length != 10){
                          displayToastMessage("Le numéro de téléphone doit contenire 10 chiffre !", context);
                        }
                        else if(!mailTextEditingController.text.contains("@")){
                          displayToastMessage("L'email doit contenire ' @ ' !", context);
                        }
                        else if(nameTextEditingController.text.isEmpty){
                          displayToastMessage("Le nom est obligatoire !", context);
                        }
                        else if(passwordTextEditingController.text.length<6){
                          displayToastMessage("Le mot de passe doit contenire au moins 6 charactere !", context);
                        }
                        else{
                          registerNewUser(context);
                        }

                      },
                    ),
                    FlatButton(
                      onPressed: (){
                        Navigator.pushNamedAndRemoveUntil(context, Login.idScreen, (route) => false);
                      },
                      child: Text(
                        "Already have an Account ?  Login here.",
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // créer une instance de firebase
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  void registerNewUser(BuildContext context) async{

    // showDialog(
    //     context: context,
    //     barrierDismissible: false,
    //     builder: (BuildContext context){
    //       return Progress(message:"Creation du votre Compte en Cours . . . ",);
    //     }
    // );

    final User? firebaseUser = (await _firebaseAuth
            .createUserWithEmailAndPassword(
                email: mailTextEditingController.text,
                password: passwordTextEditingController.text
            ).catchError((errMsg){
                //Navigator.pop(context);
                displayToastMessage("Erreur : "+errMsg.toString(), context);
              })
    ).user;

    if(firebaseUser != null){
      Map userDataMap = {
        "name" : nameTextEditingController.text.trim(),
        "phone" : phoneTextEditingController.text,
        "email" : mailTextEditingController.text.trim(),
        "password" : passwordTextEditingController.text.trim(),
      };

      usersRef.child(firebaseUser.uid).set(userDataMap);
      displayToastMessage("Utilisateur ajouter avec succés !", context);

      Navigator.pushNamedAndRemoveUntil(context, Mainscreen.idScreen, (route) => false);
    }
    else{
      //Navigator.pop(context);
      displayToastMessage("L'utilisateur n'est pas creer .", context);
    }
  }
}

displayToastMessage(String message, BuildContext context){
  Fluttertoast.showToast(msg:message);
}
