import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:multiuser_flutter/multi_register_login/login.dart';
import 'package:multiuser_flutter/multi_register_login/userpage.dart';
import 'package:lottie/lottie.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'admin_page.dart';



class Kayit extends StatefulWidget {
  @override
  _KayitState createState() => _KayitState();
}

class _KayitState extends State<Kayit> {

  bool _isLoading = false ;

  final _formKey = GlobalKey<FormState>();
  TextEditingController _fullnameTextController = TextEditingController();
  TextEditingController _usernameTextController = TextEditingController();
  TextEditingController _passwordTextController = TextEditingController();
  TextEditingController _usertypeController = TextEditingController();
  var scaffoldKey = new GlobalKey<ScaffoldState>();
  bool loading = false;
  void showInSnackBar(String value) {
    ScaffoldMessenger.of(context).showSnackBar(new SnackBar(content: Text(value)));

  }
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  Future<void> kullanicikayit() async {

    setState(() {
      _isLoading = true;
    });
    var fullname = _fullnameTextController.text;
    var username = _usernameTextController.text;
    var password = _passwordTextController.text;
    var usertype = _usertypeController.text;
    var scaffoldKey = GlobalKey<ScaffoldState>();
    GetStorage box = GetStorage();
    Map<String,String> headers = {'Content-Type':'application/json'};
    final msg = jsonEncode({ "fullname":fullname,"username":username, "password":password,"usertype":usertype});

    final response = await http.post(Uri.http("shy-clubs-fix-212-252-142-187.loca.lt", 'TasksAPI-WithUserAuth/v1/controller/users.php'), headers: headers,body:msg );
    Map<String,dynamic> data = json.decode(response.body);

    if(data["success"]) {
      data["messages"].forEach((dynamic mesajdata) => {

        alt_mesaj(context, "$mesajdata"),
      }
      );
      await box.write("kullanici", data);

      if(data["data"][ "usertype"]== "admin" ) {
        GetStorage box = GetStorage();

        await box.write("kullanici", data);

        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => AdminPage(),
            ));


      }

      else if (data["data"]["usertype"]=="user") {
        GetStorage box = GetStorage();

        await box.write("kullanici", data);

        Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => UserPage(),
            ));


      }


    }else{
      setState(() {
        _isLoading=false;
      });

      if (data["messages"] is List) {
        data["messages"].forEach((dynamic hata) =>
        {
          alt_mesaj(context, "$hata"),
        }
        );
      }else{
        data["messages"].forEach((dynamic hata) => {

          alt_mesaj(context, "$hata"),
        }
        );
      }
      //
    }
  }
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height / 3;
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
            color: Colors.white
        ),
        title: const Text('Hesap Oluştur', style: TextStyle(
            color: Colors.white
        )),
        backgroundColor:  Color(0xFFFD8080),
        elevation: 0,
        centerTitle: true,
      ),
      key: scaffoldKey,


      body: Container(
        decoration: BoxDecoration(
          color: Color(0xFFFD8080),
        ),
        alignment: Alignment.center,
        padding: EdgeInsets.all(10),
        child: SingleChildScrollView(
          child: Stack(
              children: [

                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(height: 20,),
                    TextField(
                      style:  TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                      controller: _fullnameTextController,
                      decoration: InputDecoration(
                        fillColor: Colors.pink.shade100,
                        hintText: "Fullname",
                        hintStyle: TextStyle(color: Colors.black, fontWeight: FontWeight.normal),
                        filled: true,
                        border: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.black, width: 20),
                        ),
                        focusedBorder: OutlineInputBorder(borderSide: BorderSide(color:Colors.black, width: 1)),
                      ),
                    ),
                    SizedBox(height: 20,),
                    TextField(
                      style:  TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                      controller: _usernameTextController,
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
                    SizedBox(height: 20),

                    TextField(
                      style:  TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                      obscureText: true,
                      controller: _passwordTextController,
                      decoration: InputDecoration(
                        fillColor: Colors.pink.shade100,
                        hintText: "Password Giriniz",
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
                              _usertypeController.text = "user";
                              alt_mesaj(context, "User Type USER olarak seçildi");


                            },
                            child: Text("USER") ),
                          ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                primary: Colors.white,
                                onPrimary: Colors.black,
                              ),
                              onPressed: () {

                                _usertypeController.text = "admin";
                                alt_mesaj(context, "User Type ADMIN olarak seçildi");
                              },
                              child: Text("ADMIN") ),
                        ]),
                    SizedBox(height: 20),

                    TextField(
                      style:  TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                      enabled: false,
                      focusNode: FocusNode(),
                      controller: _usertypeController,
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

                             if(_fullnameTextController.text.length <3) {
                              alt_mesaj(context, "Lütfen 3 karakterden fazla bir fullname Girin");
                            }
                            else if(_passwordTextController.text.length < 6) {
                              alt_mesaj(context, "Şifre En Az 6 Karakterden Oluşmalıdır");
                            }
                            else {
                              kullanicikayit();
                            }
                          },
                          child:  _isLoading ? Center(child: CircularProgressIndicator(color: Colors.white)):
                          Text(
                            "Hesap Oluştur",
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
                        Text('Zaten hesabın var mı ?',
                          style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold),
                        ),
                        SizedBox(width: 10,),
                        InkWell(
                          onTap: () {
                            Navigator.push(context,MaterialPageRoute(builder: (context) =>  LoginEkrani()));

                          },
                          child: Text(
                            'Giriş Yap',
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
                    )
                  ],
                ),
              ]
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