import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ride/allwidgets/divider.dart';
import 'package:ride/allwidgets/progres.dart';
import 'package:ride/models/adresse.dart';
import '../models/places.dart';
import '/dataHandler/appdata.dart';

import '../assistant/requestAssistant.dart';
import '../maps.dart';

class Search extends StatefulWidget {
  const Search({Key? key}) : super(key: key);

  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {

  //creer controller
  TextEditingController departEditingController = TextEditingController();
  TextEditingController arriveEditingController = TextEditingController();
  List<Place> placePredictionList = [];

  @override
  Widget build(BuildContext context) {

    String placeAdress = Provider.of<Appdata>(context).pickUpLocation?.placeName ?? "";
    departEditingController.text = placeAdress;

    return Scaffold(
      body: Column(
        children: [
          Container(
            height: 215.0,
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black,
                  blurRadius: 6.0,
                  spreadRadius: 0.5,
                  offset: Offset(0.7,0.7),
                ),
              ],
            ),
            child: Padding(
              padding: EdgeInsets.only(left: 25.0, top: 40.0, right: 25.0, bottom: 20.0),
              child: Column(
                children: [
                  SizedBox(height: 5.0,),
                  Stack(
                    children: [
                      GestureDetector(
                        onTap:(){
                          Navigator.pop(context);
                        },

                        child: Icon(
                            Icons.arrow_back
                        ),
                      ),
                      Center(
                        child: Text("Votre Arret ! ", style: TextStyle(fontSize: 18.0),),
                      ),
                    ],
                  ),

                  SizedBox(height: 16.0),

                  Row(
                    children: [
                      Image.asset("images/desticon.png", height: 16.0, width: 16.0,),

                      SizedBox(width: 18.0,),

                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.grey[400],
                            borderRadius: BorderRadius.circular(7.0),
                          ),
                          child: Padding(
                            padding: EdgeInsets.all(3.0),
                            child: TextField(
                              controller: departEditingController,
                              decoration: InputDecoration(
                                hintText: "Point de départ.",
                                fillColor: Colors.grey[400],
                                filled: true,
                                border: InputBorder.none,
                                isDense: true,
                                contentPadding: EdgeInsets.only(left: 11.0, top: 8.0, bottom: 8.0),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  SizedBox(height: 10.0),

                  Row(
                    children: [
                      Image.asset("images/desticon.png", height: 16.0, width: 16.0,),

                      SizedBox(width: 18.0,),

                      Expanded(
                        child: Container(
                          decoration: BoxDecoration(
                            color: Colors.grey[400],
                            borderRadius: BorderRadius.circular(7.0),
                          ),
                          child: Padding(
                            padding: EdgeInsets.all(3.0),
                            child: TextField(
                              onChanged: (val){
                                findPlace(val);
                              },
                              controller: arriveEditingController,
                              decoration: InputDecoration(
                                hintText: "Point d'arrivée.",
                                fillColor: Colors.grey[400],
                                filled: true,
                                border: InputBorder.none,
                                isDense: true,
                                contentPadding: EdgeInsets.only(left: 11.0, top: 8.0, bottom: 8.0),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                ],
              ),
            ),
          ),

          // title of prediction
          SizedBox(height: 10.0,),
          (placePredictionList.length > 0)
              ? Padding(
                  padding: EdgeInsets.symmetric(vertical: 8.0, horizontal:16.0),
                  child: ListView.separated(
                      padding: EdgeInsets.all(0.0),
                      itemBuilder: (context, index){
                        return PredictionTile(place: placePredictionList[index],);
                      },
                      separatorBuilder: (BuildContext context, int index)=>DividerWidget(),
                      itemCount: placePredictionList.length,
                      shrinkWrap: true,
                      physics: ClampingScrollPhysics(),
                  ),
              )
              : Container(),
        ],
      ),
    );
  }

  void findPlace(String placeName) async{
    if(placeName.length > 1){
      //String autoCompleteUrl = "https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$placeName&key=$mapKey&sessiontoken=1234567890&components=country:ma";
      String autoCompleteUrl = "https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$placeName&types=geocode&key=$mapKey&components=country:ma";

      var res = await RequestAssistant.getRequest(autoCompleteUrl);

      if(res == "failed"){
        return;
      }

      if(res["status"] == "OK"){
        var predictions = res["predictions"];

        var placesList = (predictions as List).map((e) => Place.fromJson(e)).toList();

        setState((){
          placePredictionList = placesList;
        });
      }
    }
  }
}


class PredictionTile extends StatelessWidget {

  final Place place;

  const PredictionTile({Key? key, required this.place}) : super(key: key);

  get placeName => null;

  get placeFormattedAddress => null;

  get latitude => null;

  get longitude => null;

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      padding: EdgeInsets.all(0.0),
      onPressed: (){
        getPlaceAdressDetails(place.place_id, context);
      },
      child: Container(
        child: Column(
          children: [
            SizedBox(width: 10.0,),
            Row(
              children: [
                Icon(Icons.add_location),
                SizedBox(width: 14.0,),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 8.0,),
                      Text(place.main_text,overflow: TextOverflow.ellipsis, style: TextStyle(fontSize: 16.0),),
                      SizedBox(height: 2.0,),
                      Text(place.secondary_text,overflow: TextOverflow.ellipsis , style: TextStyle(fontSize: 12.0, color: Colors.grey),),
                      SizedBox(height: 8.0,),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(width: 10.0,),
          ],
        ),
      ),
    );
  }

  void getPlaceAdressDetails(String placeId, context) async{

    // showDialog(
    //     context: context,
    //     barrierDismissible: false,
    //     builder: (BuildContext context){
    //       return Progress(message:"En cours . . . ",);
    //     }
    // );

    String placeDetailUrl = "https://maps.googleapis.com/maps/api/place/details/json?place_id=$placeId&key=$mapKey";

    var res = await RequestAssistant.getRequest(placeDetailUrl);

    Navigator.pop(context);

    if(res == "failed"){
      return;
    }

    if(res["status"] == "OK"){
      Adresse adresse = Adresse(longitude: 0, latitude: 0, placeName: '', placeId: '', placeFormattedAddress: '');
      adresse.placeName = res["result"]["name"];
      adresse.placeId = placeId;
      adresse.latitude = res["result"]["geometry"]["location"]["lat"];
      adresse.longitude = res["result"]["geometry"]["location"]["lng"];
    
      
      Provider.of<Appdata>(context, listen: false).updatedropOffLocationAddress(adresse);
      print("Voila votre point d'arret");
      print(adresse.placeName);

      Navigator.pop(context, "obtainDirection");
    }

  }

}
