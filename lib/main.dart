import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';

import 'login_page.dart';


void main() async {

   
  await GetStorage.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
     
      home: LoginPage(),
    );
  }
}
