import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';

import 'login.dart';

class AdminPage extends StatelessWidget {

  GetStorage box  = GetStorage();
  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar:AppBar(
        backgroundColor: Colors.black,
        automaticallyImplyLeading: false,
        title: Text("Admin Page"),
        centerTitle: true,

      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [

            Text('Admin Page', style: TextStyle(fontSize: 25),),
            SizedBox(height: 20,),

            Icon(Icons.login, size: 30),
            SizedBox(height: 20,),

            ElevatedButton(
                style: ElevatedButton.styleFrom(
                  primary: Colors.white,
                  onPrimary: Colors.black,
                ),

                onPressed: () async{
                  GetStorage box = GetStorage();
                  await box.remove("kullanici");
                  Navigator.pushAndRemoveUntil(
                      context, MaterialPageRoute(builder: (context) => LoginEkrani()), (route) => false);
                }, child: Text("Çıkış Yap", style: TextStyle(fontSize: 15),) )


          ],

        ),
      ),
    );
  }
}

