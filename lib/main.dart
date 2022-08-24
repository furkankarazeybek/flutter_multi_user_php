import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';

import 'multi_register_login/login.dart';

void main() async{

  await GetStorage.init();
  WidgetsFlutterBinding.ensureInitialized();
  runApp( MyApp());
}


class MyApp extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,



        home: LoginEkrani(),

    );
  }
}
