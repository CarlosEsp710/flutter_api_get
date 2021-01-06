import 'package:flutter/material.dart';
import 'package:flutter_get_api/users.dart';
import 'package:flutter_get_api/views/login.dart';
import 'package:provider/provider.dart';

import 'auth.dart';

void main() {
  runApp(ChangeNotifierProvider(
    create: (BuildContext context) => AuthProvider(),
    child: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Sanctum Users',
        home: new Scaffold(
          body: Center(child: Consumer<AuthProvider>(
            builder: (context, auth, child) {
              switch (auth.isAuthenticated) {
                case true:
                  return UserList();
                default:
                  return LoginForm();
              }
            },
          )),
        ));
  }
}
