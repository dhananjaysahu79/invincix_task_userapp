import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:userapp/constants.dart';
import 'package:userapp/methods/requests.dart';
import 'package:userapp/pages/userpage.dart';
class MessagePage extends StatefulWidget {
  const MessagePage({super.key});

  @override
  State<MessagePage> createState() => _MessagePageState();
}

class _MessagePageState extends State<MessagePage> {
  List<UserDetail> userList = [];
  int pageNumber = 1;

  @override
  void initState() {
    addUsers(1);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark
      ),

    child:
      Scaffold(
      appBar: buildAppBar(title: "Messages"),
      body: FutureBuilder(
        future: getUsers(),
        builder: (BuildContext context, AsyncSnapshot<List> snapshot) { 
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
                    Flexible(
                      fit: FlexFit.tight,
                      child: ListView.builder(
                        itemCount: snapshot.data!.length,
                        itemBuilder: (BuildContext context, int index) { 
                           return Column(
                             children: [
                             buildMessageTiles(
                               id: snapshot.data![index].id,
                               title: snapshot.data![index].firstName + ' ' + snapshot.data![index].lastName,
                               subtitle: "Lorem ipsum dolor sit amet, consectetur adipiscing elit",
                               avatar: snapshot.data![index].avatar,
                             ),
                             const Divider(),
                             index == snapshot.data!.length - 1 ? buildLoadMoreButton() : Container()
                             ],
                           );
                        }, 
                      ),
                    ),
                    // buildLoadMoreButton()
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

  AppBar buildAppBar(
    {
      required String title,
    }
  ) {
    return AppBar(
      centerTitle: true,
      title: Text(
        title,
        style: appBarTextStyle,
      ),
    );
  }

  Widget buildLoadMoreButton() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextButton(
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(Colors.grey.shade100)
        ), 
        onPressed: () { 
          addUsers(pageNumber + 1);
        },
        child: const Text("Load More"),
      ),
    );
  }

  Widget buildMessageTiles(
    {
      required int id,
      required String title,
      required String subtitle,
      required String avatar,
    }
  ) {
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListTile(
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => UserPage(id)),
        ),
        leading: CircleAvatar(
          radius: 22,
          backgroundImage: NetworkImage(avatar),
        ),
        title: Text(
          title,
          style: titleStyle
          ),
        subtitle: Text(
          subtitle,
          style: subtitleStyle
        ),
        trailing: const Icon(Icons.keyboard_arrow_right),
    ),
      );
  }
  
  Future addUsers(int pageNumber) async {
    var response = await getUsersFromApi(pageNumber);
    setState(() {
      userList.addAll(response);
    });
  }

  Future<List> getUsers() async {
    return userList;
  }
}