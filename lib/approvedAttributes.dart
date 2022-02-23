import 'package:flutter/material.dart';
import 'package:UI_scanAndVerifyApp/data.dart' as globals;
import 'package:UI_scanAndVerifyApp/designData.dart' as designData;

class ApprovedAttributesScreen extends StatelessWidget {
  const ApprovedAttributesScreen({Key? key}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Approved Attributes"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ApprovedAttributes(),
      ),
    );
  }
}

class ApprovedAttributes extends StatefulWidget {

  @override
  State<ApprovedAttributes> createState() => _ApprovedAttributesState();
}

class _ApprovedAttributesState extends State<ApprovedAttributes> {
  var approvedAttributes = globals.approvedAttributes;

  @override
  Widget build(BuildContext context) {
    List<Widget> _tiles = [];
    approvedAttributes.forEach((key, value) => {
      _tiles.add(
        ListTile(
          contentPadding: EdgeInsets.symmetric(
              horizontal: 12, vertical: 4),
          leading: Icon(designData.infoIcon[key]),
          title: Text(key),
          subtitle: Text(value.toString()),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              IconButton(
                icon: Icon(
                  Icons.cloud_upload,
                  size: 20.0,
                  color: Colors.brown[900],
                ),
                onPressed: () {
                  //TODO: send to the IFS
                  setState(() {
                    globals.approvedAttributes.remove(key);
                  });
                  //when added, add to the User_Info
                },
              ),
              IconButton(
                icon: Icon(
                  Icons.delete_outline,
                  size: 20.0,
                  color: Colors.brown[900],
                ),
                onPressed: () {
                  setState(() {
                    globals.approvedAttributes.remove(key);
                    globals.remainingAttributes.add(key);
                  });
                  //   _onDeleteItemPressed(index);
                },
              ),
            ],
          ),
        ),)
    });

    return Container(
      padding: const EdgeInsets.all(10),
      child: Column(
        children: <Widget>[
          Container(
            padding: const EdgeInsets.only(left: 8.0, bottom: 4.0),
            alignment: Alignment.topLeft,
            child: const Text(
              "Approved Attributes",
              style: TextStyle(
                color: Colors.black87,
                fontWeight: FontWeight.w500,
                fontSize: 16,
              ),
              textAlign: TextAlign.left,
            ),
          ),
          Card(
            child: Container(
              alignment: Alignment.topLeft,
              padding: const EdgeInsets.all(15),
              child: Column(
                children: <Widget>[
                  Column(
                    children: <Widget>[
                      ...ListTile.divideTiles(
                          color: Colors.grey,
                          tiles: _tiles
                      ),
                    ],
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}

