import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import '/allscreens/search.dart';
import '/allwidgets/divider.dart';
import '/assistant/assistantMethod.dart';
import '/dataHandler/appdata.dart';

class Mainscreen extends StatefulWidget {
  const Mainscreen({Key? key}) : super(key: key);

  static const String idScreen = "mainScreen";

  @override
  State<Mainscreen> createState() => _MainscreenState();
}

class _MainscreenState extends State<Mainscreen> {

  Completer<GoogleMapController> _controllerGoogleMap = Completer();
  late GoogleMapController newGoogleMapController;

  GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();

  late Position currentPosition;
  var geolocator = Geolocator();
  double bottomPaddingOfMap = 0;

  void locatePosition() async{
    Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    currentPosition = position;

    LatLng latLatPosition = LatLng(position.latitude, position.longitude);

    CameraPosition cameraPosition = new CameraPosition(target: latLatPosition, zoom:14);
    newGoogleMapController.animateCamera(CameraUpdate.newCameraPosition(cameraPosition));

    String adress = await AssistantMethod.searchCoordinateAddress(position,context);
    print("Voici votre Adresse : " + adress);
  }

  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.42796133580664, -122.085749655962),
    zoom: 14.4746,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: Text("Main Screen"),
      ),
      drawer: Container(
        color: Colors.white,
        width: 255.0,
        child: Drawer(
          child: ListView(
            children: [
              Container(
                height: 165.0,
                child: DrawerHeader(
                  decoration: BoxDecoration(color: Colors.white),
                  child: Row(
                    children: [
                      Image.asset("images/user_icon.png",height: 65.0, width: 65.0,),
                      SizedBox(width: 16.0,),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text("Nom Profil", style: TextStyle(fontSize: 16.0),),
                          SizedBox(height: 6.0,),
                          Text("Voir Profil"),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              DividerWidget(),

              SizedBox(height: 12.0,),

              ListTile(
                leading: Icon(Icons.history),
                title: Text("History", style: TextStyle(fontSize:15.0),),
              ),
              ListTile(
                leading: Icon(Icons.person),
                title: Text("Voir Profile", style: TextStyle(fontSize:15.0),),
              ),
              ListTile(
                leading: Icon(Icons.info),
                title: Text("About", style: TextStyle(fontSize:15.0),),
              ),
            ],
          ),
        ),
      ),
      body: Stack(
        children:[
          GoogleMap(
            padding: EdgeInsets.only(bottom: bottomPaddingOfMap),
            mapType: MapType.normal,
            myLocationButtonEnabled: true,
            initialCameraPosition: _kGooglePlex,
            myLocationEnabled: true,
            zoomGesturesEnabled: true,
            zoomControlsEnabled: true,
            onMapCreated: (GoogleMapController controller){
              _controllerGoogleMap.complete(controller);
              newGoogleMapController = controller;

              setState(() {
                bottomPaddingOfMap = 300.0;
              });

              locatePosition();
            },
          ),

          //Hamburger boutton for drawer
          Positioned(
            top: 45.0,
            left: 22.0,
            child: GestureDetector(
              onTap: (){
                scaffoldKey.currentState?.openDrawer();
              },
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(22.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.white,
                      blurRadius: 6.0,
                      spreadRadius: 0.5,
                      offset: Offset(
                        0.7,
                        0.7,
                      ),
                    ),
                  ],
                ),
                child: CircleAvatar(
                  backgroundColor: Colors.white,
                  child: Icon(Icons.menu, color:Colors.black),
                  radius: 20.0,
                ),
              ),
            ),
          ),

          Positioned(
            left: 0.0,
            right: 0.0,
            bottom: 0.0,
            child: Container(
              height: 300.0,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(5.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black54,
                    blurRadius: 6.0,
                    spreadRadius: 0.5,
                    offset: Offset(0.7,0.7),
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 18.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 6.0),
                    Text("Hi there , ",style: TextStyle(fontSize: 12.0),),
                    Text("Where to ? , ",style: TextStyle(fontSize: 20.0)),
                    SizedBox(height: 20.0),

                    GestureDetector(

                      onTap: () async{
                        var res = await Navigator.push(context, MaterialPageRoute(builder: (context) => Search()));
                        if(res == "obtainDirection"){
                          getPlaceDirection();
                        }

                      },

                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(5.0),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black54,
                              blurRadius: 6.0,
                              spreadRadius: 0.5,
                              offset: Offset(0.7,0.7),
                            ),
                          ],
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Row(
                            children: [
                              Icon(Icons.search, color: Colors.blueAccent,),
                              SizedBox(width: 10.0,),
                              Text("Chercher votre destination"),
                            ],
                          ),
                        ),
                      ),
                    ),
                SizedBox(height: 24.0,),
                Row(
                  children:[
                    Icon(Icons.home,color: Colors.grey,),
                    SizedBox(width: 12.0,),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          Provider.of<Appdata>(context).pickUpLocation != null
                              ? Provider.of<Appdata>(context).pickUpLocation!.placeName
                              : "maison",
                        ),
                        SizedBox(height:4.0,),
                        Text("Maison", style: TextStyle(color: Colors.black54,fontSize: 12.0),),
                      ],
                    ),
                  ],
                ),

                SizedBox(height: 10.0,),

                DividerWidget(),

                SizedBox(height: 16.0,),

                Row(
                  children:[
                    Icon(Icons.work, color: Colors.grey,),
                    SizedBox(width: 12.0,),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("Ajouter adress travail"),
                        SizedBox(height:4.0,),
                        Text("Travail", style: TextStyle(color: Colors.black54,fontSize: 12.0),),
                      ],
                    ),
                    ],
                ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> getPlaceDirection() async{



    var initialPos = Provider.of<Appdata>(context, listen: false).pickUpLocation;
    var finalPos = Provider.of<Appdata>(context, listen: false).dropOffLocation;

    var pickUpLapLng = LatLng(initialPos!.latitude, initialPos.longitude);
    var dropUpLapLng = LatLng(finalPos!.latitude, finalPos.longitude);

    //showDialod(){}

    var details = await AssistantMethod.obtainDirectionDetails(pickUpLapLng,dropUpLapLng);
    Navigator.pop(context);
    
    print("voila votre point d'arret ::");
    print(details?.encodedPoints);
    
    
  }

}
