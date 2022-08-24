
import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:multiuser_flutter/multi_register_login/register.dart';
import 'package:multiuser_flutter/multi_register_login/userpage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:google_fonts/google_fonts.dart';

import 'admin_page.dart';

class LoginEkrani extends StatefulWidget {

  @override
  _LoginEkraniState createState() => _LoginEkraniState();
}

class _LoginEkraniState extends State<LoginEkrani> {

  bool _isLoading = false;




  var tfKullaniciAdi = TextEditingController();
  var tfSifre = TextEditingController();
  var tfUserType = TextEditingController();

  var scaffoldKey = GlobalKey<ScaffoldState>();



  Future<void> girisKontrol() async {


    GetStorage box = GetStorage();
    var ka = tfKullaniciAdi.text;
    var s = tfSifre.text;
    var ut = tfUserType.text;

    setState(() {
      _isLoading = true;
    });




    Map<String,String> headers = {"Content-Type":"application/json"};
    final msg = jsonEncode({ "username":ka, "password":s, "usertype": ut});

    final response = await http.post(Uri.http("shy-clubs-fix-212-252-142-187.loca.lt", 'TasksAPI-WithUserAuth/v1/controller/sessions.php'), headers: {"Content-Type":"application/json"},body:msg );
    Map<String,dynamic> data = json.decode(response.body);
    print(data);
    if(data["success"]){
      await box.write("kullanici", data);

      if(data["data"][ "user_type"]== "admin" ) {
        GetStorage box = GetStorage();

        await box.write("kullanici", data);

        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AdminPage(),
            ));


      }

       else if (data["data"]["user_type"]=="user") {
         GetStorage box = GetStorage();

         await box.write("kullanici", data);

         Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => UserPage(),
            ));
      }


    }

    else {
      setState(() {
        _isLoading=false;
      });
      var hata = data["messages"];
      alt_mesaj(context, "$hata");
    }
  }





  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
            color: Colors.white
        ),
        title: const Text('Giriş Yap', style: TextStyle(
            color: Colors.white
        )),
        backgroundColor:  Color(0xFFFD8080),
        elevation: 0,
        centerTitle: true,
      ),


      key: scaffoldKey,

      body: Container(
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
          color: Color(0xFFFD8080),
        ),

        child: Padding(


          padding: const EdgeInsets.all(8.0),
          
          child: SingleChildScrollView(
            child: Column(


              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[

            TextField(
            style:  TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
            controller: tfKullaniciAdi,
            decoration: InputDecoration(
            fillColor: Colors.pink.shade100,
            hintText: "Username",
            hintStyle: TextStyle(color: Colors.black, fontWeight: FontWeight.normal),
            filled: true,
            border: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.black, width: 20),
                ),
                focusedBorder: OutlineInputBorder(borderSide: BorderSide(color:Colors.black, width: 1)),
              ),
            ),
                SizedBox(height:20),
                TextField(
                  style:  TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                  obscureText: true,
                  controller: tfSifre,
                  decoration: InputDecoration(
                    fillColor: Colors.pink.shade100,
                    hintText: "Password",
                    hintStyle: TextStyle(color: Colors.black, fontWeight: FontWeight.normal),
                    filled: true,
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black, width: 20),
                    ),
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color:Colors.black, width: 1)),
                  ),
                ),
                SizedBox(height: 20),

                Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [ ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          primary: Colors.white,
                          onPrimary: Colors.black,
                        ),
                        onPressed: () {
                      tfUserType.text = "user";
                      alt_mesaj(context, "User Type USER olarak seçildi");


                    },
                        child: Text("USER") ),
                      ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            primary: Colors.white,
                            onPrimary: Colors.black,
                          ),
                          onPressed: () {

                        tfUserType.text = "admin";
                        alt_mesaj(context, "User Type ADMIN olarak seçildi");
                      },
                          child: Text("ADMIN") ),
                    ]),
                SizedBox(height: 20),

                TextField(
                  style:  TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                  enabled: false,
                  focusNode: FocusNode(),
                  enableInteractiveSelection: false,
                  controller: tfUserType,
                  decoration: InputDecoration(
                    fillColor: Colors.pink.shade100,
                    hintText: "USER-TYPE SEÇİNİZ",
                    hintStyle: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                    filled: true,
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black, width: 20),
                    ),
                    focusedBorder: OutlineInputBorder(borderSide: BorderSide(color:Colors.black, width: 1)),
                  ),
                ),



                SizedBox(height: 20),


                Container(
                  width: MediaQuery.of(context).size.width -40,
                  height: 50,
                  decoration: BoxDecoration(
                    color: Colors.black,
                  ),
                  child: Center(
                    child: InkWell(
                      onTap: () {
                        if(tfKullaniciAdi.text.length <3 ) {
                          alt_mesaj(context, "Lütfen Doğru Username Girin");
                        }
                        else if (tfSifre.text.length < 6) {
                          alt_mesaj(context, "Şifre En Az 6 Karakterden Oluşmalıdır");
                        }
                        else {
                          girisKontrol();
                          GetStorage box = GetStorage();
                          print(box.read("kullanici"));
                        }
                      },
                      child: _isLoading ? Center(child: CircularProgressIndicator(color:Colors.white),) :
                      Text(
                        "Giriş",
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 20,
                        ),
                      ),
                    ),
                  ),
                ),

                SizedBox(height: 20,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Hesabın yok mu ?',
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold),
                    ),
                    SizedBox(width: 10,),
                    InkWell(
                      onTap: () {
                        Navigator.push(context,MaterialPageRoute(builder: (context) =>  Kayit()));

                      },
                      child: Text(
                        'Hesap Oluştur',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                          shadows: [
                            Shadow( // bottomLeft
                              offset: Offset(-1, 0),
                              color: Colors.black,
                            )],
                        ),
                      ),
                    )
                  ],
                ),

              ],
            ),
          ),
        ),
      ),

    );
  }
}

alt_mesaj(BuildContext context, String mesaj, {int tur: 0}) {
  ScaffoldMessenger.of(context).clearSnackBars();
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(
        mesaj,
        style: GoogleFonts.quicksand(fontSize: 20, color: Colors.white),
        textAlign: TextAlign.center,
      ),
      margin: EdgeInsets.only(bottom: 30, right: 10, left: 10),
      behavior: SnackBarBehavior.floating,
      backgroundColor: tur == 0 ? Colors.red : Colors.green,
    ),
  );
}


