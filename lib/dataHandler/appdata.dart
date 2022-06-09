import 'package:flutter/cupertino.dart';
import '/models/adresse.dart';

class Appdata extends ChangeNotifier{
  Adresse? pickUpLocation, dropOffLocation;

  void updatePickUpLocationAddress(Adresse pickUpAddress){
    pickUpLocation = pickUpAddress;
    notifyListeners();
  }

  void updatedropOffLocationAddress(Adresse dropOffAddress){
    dropOffLocation = dropOffAddress;
    notifyListeners();
  }
}