import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:userapp/constants.dart';
import '../methods/requests.dart';

class UserPage extends StatelessWidget {
  final int id;
  const UserPage(this.id, {super.key});

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark
      ),

    child:
    Scaffold(
     body: FutureBuilder(
        future: getUsersDetailsFromID(id),
        builder: (BuildContext context, AsyncSnapshot snapshot) { 
          if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(
                child: CircularProgressIndicator()
              );
          }
          else if(snapshot.connectionState == ConnectionState.done) {
              if (snapshot.hasError) {
                return Text(snapshot.error.toString());
              }
              else if(snapshot.hasData) {
                return Column(
                  children: [
                    buildTopContainer(
                      avatar: snapshot.data!.avatar, 
                      email: snapshot.data!.email, 
                      userName: "@${snapshot.data!.firstName}${Random().nextInt(1000) + 1}"
                    ),
                    buildBackButton(context),
                    buildBottomContainer(snapshot: snapshot)
                  ],
                );
              }
          else {
                return const Center(child: Text('Something went wrong!'));
              }
          }
          else {
                return const Center(child: Text('Something went wrong!'));
          }
        }
      ) 
    ));
  }

  Widget buildTopContainer(
    {
     required String avatar,
     required String email,
     required String userName,
    }
  ) {
    return Expanded(
      flex: 4,
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: containerGradient,
        ),
    
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            buildImageAvatar(imageUrl: avatar),
            const SizedBox(height: 20),
            Text(
              userName, 
              style: const TextStyle(
                fontSize: 34, 
                fontWeight: FontWeight.bold,
                color: Colors.white
              ),
            ),
            const SizedBox(height: 10),
            Text(
              email, 
              style: const TextStyle(
                fontSize: 16, 
                color: Colors.white
              ),
            )
          ]
        ),
      )
    );
  }


  Widget buildBottomContainer(
    {
      required AsyncSnapshot snapshot
    }
  ) {
    return Expanded(
      flex: 6,
      child: Padding(
        padding: const EdgeInsets.only(left: 22.0, right: 12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: const [
                Text(
                  "Account Info", 
                  style: TextStyle(
                    fontSize: 30, 
                    fontWeight: FontWeight.bold,
                    color: Colors.black
                  ),
                ),
              ],
            ),
            Expanded(
              child: ListView(
                physics: const BouncingScrollPhysics(),
                children: [
                  buildInfoTile(
                icon: Icons.enhanced_encryption,
                title: "USER ID",
                subtitle: snapshot.data!.id.toString(),
              ),
              buildInfoTile(
                icon: Icons.person,
                title: "Name",
                subtitle: snapshot.data!.firstName + ' ' + snapshot.data!.lastName,
              ),
              buildInfoTile(
                icon: Icons.phone_android,
                title: "Mobile number",
                subtitle: "+91-1234567890",
              ),
              buildInfoTile(
                icon: Icons.email,
                title: "Email",
                subtitle: snapshot.data!.email,
              ),
              buildInfoTile(
                icon: Icons.location_history,
                title: "Address",
                subtitle: "Lorem ipsum dolor sit amet, consectetur",
              )
              ],
            ),
            ),
          ],
        ),
      )
    );
  }

  Widget buildInfoTile(
    {
      required String title,
      required String subtitle,
      required IconData icon,
    }
  ) {
     return ListTile(       
        leading: CircleAvatar(
          backgroundColor: Colors.red,
          child: Icon(icon, color: Colors.white)),
        title: Text(
          title,
          style: titleStyle
          ),
        subtitle: Text(
          subtitle,
           style: subtitleStyle
        ),
      );
  }

  Stack buildImageAvatar(
    {
      required String imageUrl
    }){
    return Stack(
      alignment: Alignment.center,
      children: [
        Container(
          height: 100,
          width: 100,
          decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.circular(80)
          ),
        ),
        Container(
          height: 90,
          width: 90,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(70),
            image: DecorationImage(
              image: NetworkImage(
                imageUrl
              )
          )),
        ),
      ],
    );
  }

  Widget buildBackButton(context) {
    return Stack(
      children: [
         Transform.translate(
          offset: const Offset(0.0, -50 / 2.0),
          child: Center(
            child: Container(
              decoration: BoxDecoration(
                gradient: buttonGradient,
                borderRadius: borderRadius,
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black26, offset: Offset(0, 4), blurRadius: 5.0)
                ],
              ),
              child: ElevatedButton(
              onPressed: () => Navigator.of(context).pop(),
              style: ElevatedButton.styleFrom(
                primary: Colors.transparent,
                shadowColor: Colors.transparent,
                shape: RoundedRectangleBorder(borderRadius: borderRadius),
              ),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(0,8,8,8),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    InkWell(
                      onTap: () => Navigator.of(context).pop(),
                      child: const CircleAvatar(
                        radius: 14,
                        backgroundColor: Colors.white,
                        child: Icon(Icons.arrow_back, color: Colors.black)),
                    ),
                    const SizedBox(width: 50),
                    Text(
                      'Back to home',
                      style: buttonTextStyle,
                    ),
                   const SizedBox(width: 50),
                  ],
                ),
              ),
          ),
            ),
        ))
      ],
    );
  }
}