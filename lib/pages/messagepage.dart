import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Messages'),
      ),
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
                               ListTile(
                                 onTap: () => Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => UserPage(snapshot.data![index].id)),
                                  ),
                                  leading: CircleAvatar(
                                    radius: 22,
                                    backgroundImage: NetworkImage(snapshot.data![index].avatar),
                                  ),
                                 title: Text(
                                   snapshot.data![index].firstName + ' ' + snapshot.data![index].lastName,
                                   style: const TextStyle(
                                      fontWeight: FontWeight.bold
                                    ),
                                   ),
                                  subtitle: const Text("Lorem ipsum dolor sit amet, consectetur adipiscing elit"),
                                  trailing: const Icon(Icons.keyboard_arrow_right),
                                ),
                             const Divider()
                             ],
                           );
                        }, 
                      ),
                    ),
                    Column(
                      children: [
                        TextButton(
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(Colors.grey.shade100)
                          ), 
                          onPressed: () { 
                            addUsers(pageNumber + 1);
                          },
                          child: const Text("Load More"),
                        ),
                      ],
                    )
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