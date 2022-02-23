//pending ko data - from local
//approved ko data
//already added attributes
//list of attributes


import 'package:ui_major/profile.dart';

var remainingAttributes = [ "DOB", "Location", "SLC Percentage", "Mother's Name", "Gender"];
//TODO: when rejected add to the remaining attributes

const allAttributes = ["Name", "Age", "Phone Number","Citizenship Number", "DOB", "Location", "SLC Percentage", "Father's Name", "Mother's Name", "Gender"];

const attributestoName = {
  "name":"Name",
  "citizenship_number":"Citizenship Number",
  "age":"Age",
  "dob":"DOB",
  "location":"Location",
  "slc_percentage":"SLC Percentage",
  "father_name":"Father's Name",
  "mother_name":"Mother's Name",
  "gender":"Gender",
  "phone_number":"Phone_Number"
};

bool userRegistered = false;

List<String> genderOptions = ["Male", "Female", "Non-binary"];


var fieldToType = const <String, String>{
  "Name" : "String",
  "Citizenship Number": "Number",
  "Phone Number": "Number",
  "Age" : "Number",
  "DOB" : "Date",
  "Location" : "String",
  "SLC Percentage" : "Number",
  "Father's Name" : "String",
  "Mother's Name" : "String",
  "Gender" : "Gender",
};

class Attributes{
  int? citizenship_number;
  int? phone_number;
  String? name;
  int? age;
  String? location;
  String? mother_name;
  DateTime? dob;
  String? father_name;
  double? slc_percentage;
  String? gender;

  Attributes();

  Attributes.fromJSON(json){
    name = json["Name"];
    citizenship_number = json["Citizenship Number"];
    phone_number = json["Phone Number"];
    age = json["Age"];
    location = json["Location"];
    mother_name = json["Mother's Name"];
    dob = json["DOB"];
    gender = json["Gender"];
    slc_percentage = json["SLC Percentage"];
    father_name = json["Father's Name"];
  }


  static getAllPendingAttributes(){
    int length = PendingInfo.length;

    // -- null aako chha hyai
// //print("j aako tei ");
//     //print(PendingInfo[0].age);
//     //print(PendingInfo[0].location);
//     //print(PendingInfo[0].mother_name);
//     //print(PendingInfo[0].dob);
//     //print(PendingInfo[0].father_name);
//     //print(PendingInfo[0].slc_percentage);
//     //print(PendingInfo[0].gender);


    var finalPending = {};
    for( var i = length -1 ; i >= 0; i-- ) {
      finalPending[attributestoName["age"]]??=PendingInfo[i].age;
      finalPending[attributestoName["name"]]??=PendingInfo[i].name;
      finalPending[attributestoName["citizenship_number"]]??=PendingInfo[i].citizenship_number;
      finalPending[attributestoName["phone_number"]]??=PendingInfo[i].phone_number;
      finalPending[attributestoName["location"]]??= PendingInfo[i].location;
      finalPending[attributestoName["mother_name"]]??= PendingInfo[i].mother_name;
      finalPending[attributestoName["dob"]]??= PendingInfo[i].dob;
      finalPending[attributestoName["father_name"]]??= PendingInfo[i].father_name;
      finalPending[attributestoName["slc_percentage"]]??= PendingInfo[i].slc_percentage;
      finalPending[attributestoName["gender"]]??= PendingInfo[i].gender;
    }

    // -- null aako chha hyai

    // for( var i = length -1 ; i >= 0; i-- ) {
    //   //print(finalPending[attributestoName["age"]]);
    //   //print(finalPending[attributestoName["location"]]);
    //   //print(finalPending[attributestoName["mother_name"]]);
    //   //print(finalPending[attributestoName["dob"]]);
    //   //print(finalPending[attributestoName["father_name"]]);
    //   //print(finalPending[attributestoName["slc_percentage"]]);
    //   //print(finalPending[attributestoName["gender"]]);
    // }

    finalPending.removeWhere((key, value) => value == null);
    // finalPending.forEach((key, value) => { print(key+value.toString())});


    return finalPending;
  }
}

 //approvedAttributes
List<Attributes> PendingInfo = [] ;

//TODO : fetches from the server
Map<String, dynamic> approvedAttributes = {"Age" : 45, "Father's Name" : "kkk"} ; //esto format ma huna parcha
Map<String, dynamic> userInfo ={"Citizenship Number": 12345678, "Phone Number": 1234};
late final image;