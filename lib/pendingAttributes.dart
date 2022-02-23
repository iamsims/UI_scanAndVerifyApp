import 'package:flutter/material.dart';
import 'package:ui_major/data.dart' as globals;
import 'package:ui_major/designData.dart' as designData;

class PendingAttributesScreen extends StatelessWidget {
  const PendingAttributesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // List<Widget>
    // Use the Todo to create the UI.
    return Scaffold(
      appBar: AppBar(
        title: Text("Pending Attributes"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: PendingAttributes()
        ),
      ),
    );
  }
}


class PendingAttributes extends StatelessWidget {

  var allPendingAttributes = globals.Attributes.getAllPendingAttributes();

  @override
  Widget build(BuildContext context) {
    List<Widget> _tiles = [];
    allPendingAttributes.forEach((key, value) => {
      _tiles.add(
     ListTile(
        contentPadding: EdgeInsets.symmetric(
            horizontal: 12, vertical: 4),
        // leading: Icon(Icons.my_location),
       leading: Icon(designData.infoIcon[key]),
       title: Text(key),
        subtitle: Text(value.toString()),
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
              "Pending Attributes",
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
                        tiles: _tiles.isEmpty?[Center(child:Text("No Pending Attributes"))]:_tiles
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
