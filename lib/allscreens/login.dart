import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import '/allscreens/mainscreen.dart';
import '/allscreens/register.dart';
import '/allwidgets/progres.dart';
import '/main.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  static const String idScreen = "login";

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {

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
                "Login as a Rider",
                style: TextStyle(fontSize: 24.0 ),
                textAlign: TextAlign.center,
              ),

              Padding(
                padding: EdgeInsets.all(20.0),
                child: Column(
                  children: [

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
                            "Login",
                            style: TextStyle(fontSize: 18.0),
                          ),
                        ),
                      ),
                      shape: new RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(24.0),
                        ),
                      onPressed: (){
                        loginUser(context);
                      },
                    ),
                  FlatButton(
                      onPressed: (){
                        Navigator.pushNamedAndRemoveUntil(context, Register.idScreen, (route) => false);
                      },
                      child: Text(
                        "Do not have an Account ?  Register here.",
                      ),
                    ),
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

  void loginUser(BuildContext context) async{

    // showDialog(
    //     context: context,
    //     barrierDismissible: false,
    //     builder: (BuildContext context){
    //       return Progress(message:"Connexion en Cours . . . ",);
    //     }
    // );

    final User? firebaseUser = (await _firebaseAuth
        .signInWithEmailAndPassword(
        email: mailTextEditingController.text,
        password: passwordTextEditingController.text
    ).catchError((errMsg){
      //Navigator.pop(context);
      displayToastMessage("Erreur : "+errMsg.toString(), context);
    })
    ).user;
    if(firebaseUser != null){
      usersRef.child(firebaseUser.uid).once().then((DatabaseEvent databaseEvent){
        if(databaseEvent.snapshot.value != null){
          displayToastMessage("Connexion avec succés !", context);
          Navigator.pushNamedAndRemoveUntil(context, Mainscreen.idScreen, (route) => false);
        }
        else{
          //Navigator.pop(context);
          _firebaseAuth.signOut();
          displayToastMessage("Compte n'existe pas, Créér un .", context);
        }
      });
    }
    else{
      //Navigator.pop(context);
      displayToastMessage("Probléme dans la connexion .", context);
    }
  }

}
