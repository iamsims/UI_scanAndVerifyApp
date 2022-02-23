import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:UI_scanAndVerifyApp/data.dart' as globals;
import 'package:UI_scanAndVerifyApp/designData.dart' as designData;
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'dart:io';
import 'package:form_builder_image_picker/form_builder_image_picker.dart';
import 'package:image/image.dart' as img;



// TODO: image halne from hyai ko files

class RegisterScreen extends StatefulWidget {

  RegisterScreen(this.registerUser);
  final registerUser;

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  bool pendingRegistration = false;
  final _formKey = GlobalKey<FormBuilderState>();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pendingRegistration ?
      Text("Loading")
          :

      FormBuilder(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const SizedBox(height: 80.0),
            Stack(
              children: <Widget>[
                Positioned(
                  left: 20.0,
                  top: 15.0,
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.circular(20.0)),
                    width: 70.0,
                    height: 20.0,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 32.0),
                  child: Text(
                    "Register ",
                    style:
                    TextStyle(fontSize: 30.0, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 30.0),
            Padding(
              padding:
              const EdgeInsets.symmetric(horizontal: 32, vertical: 8.0),
              child: FormBuilderTextField(
                name: "Name",
                decoration: InputDecoration(
                  labelText: "Name",
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Choose an option';
                  }
                  return null;
                },
              ),
            ),

            Padding(
                padding:
                const EdgeInsets.symmetric(horizontal: 32, vertical: 8.0),
                child: FormBuilderImagePicker(
                  name: 'Profile Photo',
                  decoration: const InputDecoration(labelText: 'Profile Photo'),
                  maxImages: 1,
                  validator: (value) {
                  if (value == null || value.isEmpty) {
                  return 'Choose an option';
                  }
                  return null;
                  },
                )
            ),


            const SizedBox(height: 60.0),
            Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton(

                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.fromLTRB(40.0, 16.0, 30.0, 16.0),
                  shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(30.0),
                          bottomLeft: Radius.circular(30.0))),
                ),

                // elevation: 0,

                onPressed: () async {
                  _formKey.currentState?.save();
                  if (_formKey.currentState!.validate()) {
                    var data = _formKey.currentState?.value;

                    _formKey.currentState!.reset();

                    setState(() {
                      pendingRegistration = true;
                    }
                    );

                    //approved ki nai bhanera esma check garne
                    //send the image and the name
                    await Future.delayed(Duration(seconds: 5));
                    //if approved

                    globals.userInfo["Name"]= data!["Name"];
                    var bytes = await data["Profile Photo"][0].readAsBytes();
                    globals.image = MemoryImage(bytes);
                   // print();

                    // print(globals.userInfo["Name"]);
                    // print(globals.image);
                    // print(globals.image.image);

                    widget.registerUser();

                  }
                },
                child: Text(
                  "Register   >".toUpperCase(),
                  style: TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 16.0),
                ),
              ),
            ),
          ],
        ),
      ),


    );
  }
}
