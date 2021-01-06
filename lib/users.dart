import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_get_api/auth.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';
import 'package:flutter_get_api/utils/constants.dart';
import 'package:provider/provider.dart';

class User {
  final int id;
  final String name;
  final String email;
  User({this.id, this.name, this.email});
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['name'],
      email: json['email'],
    );
  }
}

class UserList extends StatefulWidget {
  @override
  _UserListState createState() => _UserListState();
}

class _UserListState extends State<UserList> {
  Future<List<User>> futureUsers;

  @override
  void initState() {
    super.initState();
    futureUsers = fetchUsers();
  }

  Future<List<User>> fetchUsers() async {
    List<User> users = new List<User>();
    String token =
        await Provider.of<AuthProvider>(context, listen: false).getToken();
    final response = await http.get('$API_URL/api/auth/all', headers: {
      'Authorization': 'Bearer $token',
    });
    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      for (int i = 0; i < data.length; i++) {
        users.add(User.fromJson(data[i]));
      }
      return users;
    } else {
      throw Exception('Problem loading users $token');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        RaisedButton(
          elevation: 5.0,
          child: Text('Logout'),
          onPressed: () {
            Provider.of<AuthProvider>(context, listen: false).logout();
          },
        ),
        UserListBuilder(futureUsers: futureUsers),
      ],
    );
  }
}

class UserListBuilder extends StatelessWidget {
  const UserListBuilder({
    Key key,
    @required this.futureUsers,
  }) : super(key: key);

  final Future<List<User>> futureUsers;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<User>>(
        future: futureUsers,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Expanded(
                child: ListView.builder(
              itemCount: snapshot.data.length,
              itemBuilder: (context, index) {
                User user = snapshot.data[index];
                return ListTile(
                  title: Text('${user.name}'),
                  subtitle: Text('${user.email}'),
                );
              },
            ));
          } else if (snapshot.hasError) {
            return Text("${snapshot.error}");
          }
          return CircularProgressIndicator();
        });
  }
}
