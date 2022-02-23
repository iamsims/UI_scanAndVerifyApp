import 'package:flutter/material.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:UI_scanAndVerifyApp/pendingAttributes.dart';
import 'package:UI_scanAndVerifyApp/data.dart' as globals;
import 'package:UI_scanAndVerifyApp/designData.dart' as designData;

//TODO: add validation in the fields copy from https://pub.dev/packages/flutter_form_builder


Widget convertToWidget(String element){
 if (globals.fieldToType[element]=="Number"){
    return FormBuilderTextField(
      name: element,
      decoration: InputDecoration(
        labelText: element,
          icon: Icon(
              designData.infoIcon[element]
          )
      ),
      valueTransformer: (text) => num.tryParse(text!),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Choose an option';
        }
        return null;
      },
      keyboardType: TextInputType.number,

    );
  }

  else if (globals.fieldToType[element]=="Date") {
    return FormBuilderDateTimePicker(
      name: element,
      // onChanged: _onChanged,
      inputType: InputType.date,
      decoration: InputDecoration(
        labelText: element,
          icon: Icon(
              designData.infoIcon[element]
          )
      ),
      initialValue: DateTime.now(),
      // enabled: true,
    );
  }

  else if (globals.fieldToType[element]=="Gender"){
    return FormBuilderDropdown(
      name: element,
      decoration: InputDecoration(
        labelText: element,
      icon: Icon(
  designData.infoIcon[element]
  )
      ),

      initialValue: 'Male',
      allowClear: true,
      hint: Text('Select Gender'),
      validator: (value) {
        if (value == null) {
          return 'Choose an option';
        }
        return null;
      },
      // validator: FormBuilderValidators.compose(
      //     [FormBuilderValidators.required(context)]),
      items: globals.genderOptions
          .map((gender) => DropdownMenuItem(
        value: gender,
        child: Text('$gender'),
      ))
          .toList(),
    );
  }

  else {
    return FormBuilderTextField(
      name: element,
      decoration: InputDecoration(
        labelText: element,
          icon: Icon(
              designData.infoIcon[element.toString()]
          )
      ),
      // valueTransformer: (text) => num.tryParse(text),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Choose an option';
        }
        return null;
      },
      keyboardType: TextInputType.text,
    );
}

}



class AddAttributesScreen extends StatelessWidget {
  AddAttributesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Use the Todo to create the UI.
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Attributes"),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: ChooseAttributesForm(),
    ),
    );
    }
  }

class ChooseAttributesForm extends StatefulWidget {
  @override
  State<ChooseAttributesForm> createState() => _ChooseAttributesFormState();
}

class _ChooseAttributesFormState extends State<ChooseAttributesForm> {
  final _formKey = GlobalKey<FormBuilderState>();

  List<String> selectedAttributes=[];
  List<Widget> formAttributes = [];


  void getFormAttributes(){
    formAttributes=[];
    selectedAttributes.forEach((element) {
      // print(element);
      // print(globals.fieldToType[element]);
      // print(designData.infoIcon.containsKey(element));
      
      
      formAttributes.add(
        convertToWidget(element)
      );

    });

  }

  @override
  Widget build(BuildContext context) {
    List<FormBuilderFieldOption<String>> _options= [];

    globals.remainingAttributes.forEach((element) {
      _options.add(
        FormBuilderFieldOption(
            value: element, child: Text(element)),
      );
    });


    return FormBuilder(
          key: _formKey,
          child: Column(
            // mainAxisAlignment: MainAxisAlignment.spaceBetween,

            children: <Widget>[
              SizedBox(
                height: 10,
              ),
              Text("Select the attributes you want to fill"),
              SizedBox(
                height: 30,
              ),

              FormBuilderFilterChip(
                name: 'filter_chip',
                // decoration: InputDecoration(
                //   labelText: 'Attributes',
                // ),
                options: _options,

                onChanged: (list)=>{
                  setState((){
                    selectedAttributes= list as List<String>;
                    getFormAttributes();
                })
                },

                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Choose an option';
                  }
                  return null;
                },

              ),

              SizedBox(
                height: 30
              ),

              if(!formAttributes.isEmpty)
                Text("Fill the Form"),

              Column(
                  children: formAttributes
              ),

              Spacer(),


              Row(
                children: [
                  Spacer(),
                  ElevatedButton(
                  onPressed: () {
                  _formKey.currentState?.save();
                  if (_formKey.currentState!.validate()) {
                    var data = _formKey.currentState?.value;

                    var filled_fields = data?['filter_chip'];
                    var filled_values = {};
                    //
                    filled_fields.forEach(
                        (element)=>{
                          filled_values[element]= data?[element]
                        }
                    );


                    globals.PendingInfo.add(globals.Attributes.fromJSON(filled_values));
                    _formKey.currentState!.reset();

                    //TODO: if rejected add in approved attributes
                    filled_fields.forEach((element){
                      globals.remainingAttributes.remove(element);
                    }
                    );


                    //navigator push to pending page, pending page pushes to the approved Attrributes
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PendingAttributesScreen(),
                      ),
                    );
                  }
            },
                    child: Text("Submit >")
                  ),
                ],
              )


            ],




          ),

        );
  }
}
