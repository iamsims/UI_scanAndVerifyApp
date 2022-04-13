import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:UI_scanAndVerifyApp/pendingAttributes.dart';
import 'package:UI_scanAndVerifyApp/data.dart' as globals;
import 'package:UI_scanAndVerifyApp/designData.dart' as designData;

//TODO: add validation in the fields copy from https://pub.dev/packages/flutter_form_builder


class VerifyScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Use the Todo to create the UI.
    return PickAttributes();
  }
}

class PickAttributes extends StatefulWidget {
  @override
  State<PickAttributes> createState() => _PickAttributesState();
}

class _PickAttributesState extends State<PickAttributes> {
  final _formKey = GlobalKey<FormBuilderState>();

  List<String> selectedAttributes = [];


  @override
  Widget build(BuildContext context) {
    List<FormBuilderFieldOption<String>> _options = [];

    globals.userInfo.forEach((key, value) {
      _options.add(
        FormBuilderFieldOption(
            value: key, child: Text(key)),
      );
    });


    return Column(
        children: [
          SizedBox(
            height: 10,
          ),
          Text("Pick Attributes to be Verified"),
          SizedBox(
            height: 10,
          ),
          FormBuilder(
            key: _formKey,
            child: Column(
              children:[
                FormBuilderFilterChip(
              name: 'filter_chip',
              options: _options,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Choose an option';
                }
                return null;
              },

            ),

                Padding(padding: EdgeInsets.all(20),
                    child:ElevatedButton(
                    onPressed: () {
                      _formKey.currentState?.save();
                      if (_formKey.currentState!.validate()) {

                        print("validated");
                        var data = _formKey.currentState?.value;
                        // print(data!["filter_chip"]);
                        // // print(data);

                        setState(() {
                            selectedAttributes = data!["filter_chip"];
                            print(selectedAttributes);
                        });

                        _formKey.currentState!.reset();
                        // Text(data.toString());
                        //navigator push to pending page, pending page pushes to the approved Attrributes

                      }
                    },
                    child: Text("Generate")
                ),
    )
            ]
            )
          ),
          if (selectedAttributes.isNotEmpty)
            Container(
              child:Text("hi")
            ),

          if (selectedAttributes.isEmpty)
            Container(
              child: Text("QR will be generated here")
            )


        ]
    );
  }
}

