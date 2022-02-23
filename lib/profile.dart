import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:UI_scanAndVerifyApp/addAtrributes.dart';
import 'package:UI_scanAndVerifyApp/pendingAttributes.dart';
import 'package:UI_scanAndVerifyApp/approvedAttributes.dart';
import 'package:UI_scanAndVerifyApp/data.dart' as globals;
import 'package:UI_scanAndVerifyApp/designData.dart' as designData;


class ProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
          child: Column(
            children: <Widget>[
              ProfileHeader(
                avatar:globals.image,
                coverImage: AssetImage('coverpage.jpg'), //have to add a local image(install garda nai aako image) here also
                title:""
              ),
              const SizedBox(height: 10.0),
              // UserInfo),
              UserInfo(),
              const SizedBox(height: 10.0),
              Attributes()
            ],


          ),
        );
  }
}


class Attributes extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      child: Column(
        children: <Widget>[
          Container(
            padding: const EdgeInsets.only(left: 8.0, bottom: 4.0),
            alignment: Alignment.topLeft,
            child: const Text(
              "Attributes",
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

                  ListTile(
                    leading: Icon(Icons.add),
                    title: TextButton(
                        style: TextButton.styleFrom(
                          primary: Colors.black87,

                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text('Add Attributes'),
                            Icon(Icons.arrow_forward_ios)
                          ],
                        ),
                        onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => AddAttributesScreen(),
                ),
              );
            },

                    ),
                  ),
                  // Column(

                  ListTile(
                    leading: Icon(Icons.data_usage),
                    title: TextButton(
                        style: TextButton.styleFrom(
                          primary: Colors.black87,

                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text('Pending Attributes'),
                            Icon(Icons.arrow_forward_ios)
                          ],
                        ),
                        onPressed: () {
                  Navigator.push(
                  context,
                  MaterialPageRoute(
                  builder: (context) => PendingAttributesScreen(),
                  ),
                  );
                  },

                    ),
                  ),

                  ListTile(
                    leading: Icon(Icons.add_task),
                    title: TextButton(
                        style: TextButton.styleFrom(
                          primary: Colors.black87,

                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text('Approved Attributes'),
                            Icon(Icons.arrow_forward_ios)
                          ],
                        ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ApprovedAttributesScreen(),
                          ),
                        );
                      },


                    ),
                  ),

                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}

class UserInfo extends StatelessWidget {
  var userInfo = globals.userInfo;

  @override
  Widget build(BuildContext context) {
    List<Widget> _tiles = [];
    userInfo.forEach((key, value) =>
    {
      _tiles.add(
          ListTile(
            contentPadding: EdgeInsets.symmetric(
                horizontal: 12, vertical: 4),
            leading: Icon(designData.infoIcon[key]),
            title: Text(key),
            subtitle: Text(value.toString()),
          )
      )
    });

    return Container(
      padding: const EdgeInsets.all(10),
      child: Column(
        children: <Widget>[
          Container(
            padding: const EdgeInsets.only(left: 8.0, bottom: 4.0),
            alignment: Alignment.topLeft,
            child: const Text(
              "User Information",
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




class ProfileHeader extends StatelessWidget {
  final ImageProvider<dynamic> coverImage;
  final ImageProvider<dynamic> avatar;
  final String title;
  final String? subtitle;

  const ProfileHeader(
      {Key? key,
        required this.coverImage,
        required this.avatar,
        required this.title,
        this.subtitle,
      }
      )
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Ink(
          height: 200,
          decoration: BoxDecoration(
            image: DecorationImage(image: coverImage as ImageProvider<Object>, fit: BoxFit.cover),
          ),
        ),
        Ink(
          height: 200,
          decoration:const BoxDecoration(
            color: Colors.black38,
          ),
        ),
        Container(
          width: double.infinity,
          margin: const EdgeInsets.only(top: 160),
          child: Column(
            children: <Widget>[
              Avatar(
                image: avatar,
                radius: 40,
                backgroundColor: Colors.white,
                borderColor: Colors.grey.shade300,
                borderWidth: 4.0,
              ),
              Text(
                title,
                // style: Theme.of(context).textTheme.title,
              ),
              if (subtitle != null) ...[
                const SizedBox(height: 5.0),
                Text(
                  subtitle!,
                  // style: Theme.of(context).textTheme.subtitle,
                ),
              ]
            ],
          ),
        )
      ],
    );
  }
}

class Avatar extends StatelessWidget {
  final ImageProvider<dynamic> image;
  final Color borderColor;
  final Color? backgroundColor;
  final double radius;
  final double borderWidth;

  const Avatar({Key? key,
    required this.image,
    this.borderColor = Colors.grey,
    this.backgroundColor,
    this.radius = 30,
    this.borderWidth = 5})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: radius + borderWidth,
      backgroundColor: borderColor,
      child: CircleAvatar(
        radius: radius,
        backgroundColor: backgroundColor ?? Theme
            .of(context)
            .primaryColor,
        child: CircleAvatar(
          radius: radius - borderWidth,
          backgroundImage: image as ImageProvider<Object>?,
        ),
      ),
    );
  }

}