import 'dart:convert';
import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:my_ecommerce_app/Login_Page.dart';
import 'package:my_ecommerce_app/constants.dart';
import 'package:http/http.dart' as http;
class RegistrationPage extends StatefulWidget {
  const RegistrationPage({super.key});

  @override
  State<RegistrationPage> createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  String? name,phone,address,username,password;
  final GlobalKey<FormState>_formkey = GlobalKey<FormState>();
  Registration(String name,phone,address,username,password)async{
    print('webservice');
    print(username);
    print(password);
    var result;
    final Map<String , dynamic>regData ={
      'name': name,
      'phone': phone,
      'address': address,
      'username': username,
      'password': password,
    };
    final response = await http.post(
      Uri.parse('http://bootcamp.cyralearnings.com/registration.php'),
      body: regData,
    );
    print(response.statusCode);
    if(response.statusCode == 200){
      if(response.body.contains("success")){
        log('registration successfully completed');
        Navigator.push(context, MaterialPageRoute(
            builder: (context){
              return LoginPage();
            }));
      }else{
        log("registration failed");
      }
    }else{
      result={log(json.decode(response.body)['error'].toString())};
    }
    return result;
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 50,),
            Text("Register Account",
            style: TextStyle(
              color: Colors.black,
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),),
            Text("Complete your details \n"),
            SizedBox(height: 28,),
            Form(
              key: _formkey,
                child:Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        height: 50,
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                          color: Color(0xffE8E8E8),
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Center(
                            child: TextFormField(
                              onChanged: (text){
                                setState(() {
                                  name=text;
                                });
                              },
                              validator: (value){
                                if(value!.isEmpty){
                                  return 'Enter your Name';
                                }
                              },
                              style: TextStyle(
                                fontSize: 15,
                              ),
                              decoration: InputDecoration.collapsed(
                                  hintText: 'Name'),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        height: 50,
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                          color:  Color(0xffE8E8E8),
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Center(
                            child: TextFormField(
                              onChanged: (text){
                                setState(() {
                                  phone=text;
                                });
                              },
                              keyboardType: TextInputType.phone,
                              validator: (value1){
                                if(value1!.isEmpty){
                                  return "Please enter your Phone number";
                                }else if(value1.length>10||value1.length<10){
                                  return 'please enter your valid phone number';
                                }
                              },
                              style: TextStyle(
                                fontSize: 15,
                              ),
                              decoration: InputDecoration.collapsed(
                                  hintText: 'Phone'),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        height: 100,
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                          color:  Color(0xffE8E8E8),
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Center(
                            child: TextFormField(
                              maxLines: 4,
                              onChanged: (text){
                                setState(() {
                                  address=text;
                                });
                              },
                              validator: (value2){
                                if(value2!.isEmpty){
                                  return 'Enter your Address';
                                }
                              },
                              keyboardType: TextInputType.phone,
                              style: TextStyle(
                                fontSize: 15,
                              ),
                              decoration: InputDecoration.collapsed(
                                  hintText: 'Address',
                              ),

                            ),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        height: 50,
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                          color:  Color(0xffE8E8E8),
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Center(
                            child: TextFormField(
                              onChanged: (text){
                                setState(() {
                                  username=text;
                                });
                              },
                              validator: (value3){
                                if(value3!.isEmpty){
                                  return 'Enter your Username';
                                }
                              },
                              style: TextStyle(
                                fontSize: 15,
                              ),
                              decoration: InputDecoration.collapsed(
                                  hintText: 'Username'),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        height: 50,
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                          color: Color(0xffE8E8E8),
                          borderRadius: BorderRadius.all(Radius.circular(10)),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Center(
                            child: TextFormField(
                              obscureText: true,
                              onChanged: (text){
                                setState(() {
                                  password=text;
                                });
                              },
                              validator: (value4){
                                if(value4!.isEmpty){
                                  return 'Enter your Password';
                                }
                              },
                              style: TextStyle(
                                fontSize: 15,
                              ),
                              decoration: InputDecoration.collapsed(
                                  hintText: 'Password'),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 50,),
                    Container(
                      height: 50,
                      width: MediaQuery.of(context).size.width,
                      child: TextButton(
                        style: TextButton.styleFrom(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          primary: Colors.white,
                          backgroundColor: maincolor,
                        ),
                        onPressed: () {
                           if(_formkey.currentState!.validate()) {
                             Registration(name!, phone, address, username, password);
                           }
                        }, child: Text(
                        "Register",style: TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                      ),
                      ),
                      ),
                    )
                  ],
                ) ),
            Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Do you have an account?",style: TextStyle(
                    fontSize: 16,
                  ),),
                  TextButton(onPressed: (){
                    Navigator.pop(context,MaterialPageRoute(builder: (context){
                      return LoginPage();
                    }));
                  }, child: Text("Login",style: TextStyle(
                    fontSize: 16,
                    color: maincolor,
                    fontWeight: FontWeight.bold,
                  ))),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
