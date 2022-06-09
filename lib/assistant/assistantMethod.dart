
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import 'package:ride/models/directDetails.dart';
import '../maps.dart';
import '/assistant/requestAssistant.dart';
import '/dataHandler/appdata.dart';
import '/models/adresse.dart';

class AssistantMethod
{
  static get latitude => null;

  static get placeId => null;

  static get placeName => null;

  static get longitude => null;

  static get placeFormattedAddress => null;

  get distanceText => null;

  get durationValue => null;

  get distanceValue => null;

  get encodedPoints => null;

  static Future<String> searchCoordinateAddress(Position position, context) async
  {
    String placeAddress = "";
    String st1,st2,st3,st4;
    String url = "https://maps.googleapis.com/maps/api/geocode/json?latlng=${position.latitude},${position.longitude}&key=$mapKey";

    var response = await RequestAssistant.getRequest(url);

    if(response != "failed"){
      //placeAddress = response["results"][0]["formatted_adress"];
      st1 = response["results"][0]["address_components"][1]["long_name"];
      st2 = response["results"][0]["address_components"][4]["long_name"];
      // st3 = response["results"][0]["address_components"][5]["long_name"];
      // st4 = response["results"][0]["address_components"][6]["long_name"];
      placeAddress = st1+", "+st2;

      Adresse userPickUpAddress = new Adresse(placeFormattedAddress: placeFormattedAddress, placeId: placeId, placeName: placeName, longitude: longitude, latitude: latitude);
      userPickUpAddress.longitude = position.longitude;
      userPickUpAddress.latitude = position.latitude;
      userPickUpAddress.placeName = placeAddress;

      Provider.of<Appdata>(context, listen: false).updatePickUpLocationAddress(userPickUpAddress);

    }
    return placeAddress;
  }

  static Future<DirectDetails?> obtainDirectionDetails(LatLng initialPosition, LatLng finalPosition) async{
    String directionUrl = "https://maps.googleapis.com/maps/api/directions/json?origin=${initialPosition.latitude},${initialPosition.longitude}&destination=${finalPosition.latitude},${finalPosition.longitude}&key=$mapKey";

    var res = await RequestAssistant.getRequest(directionUrl);

    if(res == "failed"){
      return null;
    }
    
    DirectDetails directDetails = DirectDetails(distanceText: "", distanceValue: 0, durationValue: 0, encodedPoints: "");

    directDetails.encodedPoints = res["routes"][0]["overview_polyline"]["points"];

    directDetails.distanceText = res["routes"][0]["legs"][0]["distance"]["text"];
    directDetails.distanceValue = res["routes"][0]["legs"][0]["distance"]["value"];

    directDetails.durationText = res["routes"][0]["legs"][0]["duration"]["text"];
    directDetails.durationValue = res["routes"][0]["legs"][0]["duration"]["value"];

    return directDetails;
  }
}