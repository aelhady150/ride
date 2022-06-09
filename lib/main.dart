import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '/allscreens/login.dart';
import '/allscreens/mainscreen.dart';
import '/allscreens/register.dart';
import '/dataHandler/appdata.dart';

void main() async{

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(const MyApp());
}

DatabaseReference usersRef = FirebaseDatabase.instance.reference().child("users");

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (BuildContext context) => Appdata(),

      child: MaterialApp(
        title: 'Ride Share',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        initialRoute: Mainscreen.idScreen,
        routes: {
          Register.idScreen: (context) => Register(),
          Login.idScreen: (context) => Login(),
          Mainscreen.idScreen: (context) => Mainscreen(),
        },
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}