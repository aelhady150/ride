class Place{
  late String secondary_text;
  late String main_text;
  late String place_id;

  Place({required this.secondary_text, required this.main_text, required this.place_id});

  Place.fromJson(Map<String, dynamic> json){
    place_id = json["place_id"];
    main_text = json["structured_formatting"]["main_text"];
    secondary_text = json["structured_formatting"]["secondary_text"];
  }

}