import 'dart:convert';
import 'package:http/http.dart' as http;

class UserDetail{
  int id;
  String email;
  String firstName;
  String lastName;
  String avatar;
  UserDetail(this.id, this.email, this.firstName, this.lastName, this.avatar);
}


Future<List<UserDetail>> getUsersFromApi(int pageNumber) async{
    List<UserDetail> userList = [];
    var url = Uri.parse('https://reqres.in/api/users?page=$pageNumber');
    var response = await http.get(url);
    var decodeJSon = jsonDecode(response.body);

    decodeJSon['data'].forEach((data) => {
      userList.add(
        UserDetail(
          data['id'],
          data['email'],
          data['first_name'],
          data['last_name'],
          data['avatar'],
        )
      )
    });
    return userList;
}
Future<UserDetail> getUsersDetailsFromID(int id) async{
    var url = Uri.parse('https://reqres.in/api/users/$id');
    var response = await http.get(url);
    var decodeJSon = jsonDecode(response.body);
    var data = decodeJSon['data'];

    return UserDetail(
      data['id'],
      data['email'],
      data['first_name'],
      data['last_name'],
      data['avatar'],
    );
}