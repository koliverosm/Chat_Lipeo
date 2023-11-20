// ignore_for_file: unnecessary_brace_in_string_interps, avoid_print, use_build_context_synchronously, non_constant_identifier_names, library_private_types_in_public_api

import 'package:chat_lipeo/screen/welcome/welcome_screen.dart';
import 'package:http/http.dart' as http;
import 'package:chat_lipeo/screen/contacts/contacts_page.dart';
import 'package:chat_lipeo/screen/login/sign_up_screen.dart';
import 'package:chat_lipeo/widget/bezier_container.dart';
import 'package:flutter/material.dart';
import 'dart:convert';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key, String? this.phone}) : super(key: key);

  final String? phone;

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class LoginResponse {
  final bool success;
  final List<dynamic>? userData;

  LoginResponse(this.success, this.userData);
}

class CallContac {
  final List<dynamic>? userid;

  CallContac(this.userid);
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _phoneNumberController =
      TextEditingController(text: '');
  final TextEditingController _passwordController =
      TextEditingController(text: "");
  final FocusNode _phoneNumberFocus = FocusNode();
  final FocusNode _passwordFocus = FocusNode();
//instanciamos los controladores
  String? miDato;
  @override
  void initState() {
    super.initState();

    // Verificar si datosphone no es null antes de asignar el valor
    if (widget.phone != null) {
      miDato = widget.phone!;
      _phoneNumberController.text = miDato!;
    } else {
      _phoneNumberController.text = '';
    }
  }

  Widget _backButton() {
    return InkWell(
      onTap: () {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => const WelcomeScreen()));
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Row(
          children: <Widget>[
            Container(
              padding: const EdgeInsets.only(left: 0, top: 10, bottom: 10),
              child: const Icon(Icons.keyboard_arrow_left, color: Colors.black),
            ),
            const Text('Back',
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.w500))
          ],
        ),
      ),
    );
  }

  Widget _entryField(String title,
      {bool isPassword = false, TextEditingController? controller}) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
          ),
          const SizedBox(
            height: 10,
          ),
          TextField(
              obscureText: isPassword,
              controller: controller,
              focusNode: isPassword ? _passwordFocus : _phoneNumberFocus,
              decoration: const InputDecoration(
                  border: InputBorder.none,
                  fillColor: Color(0xfff3f3f4),
                  filled: true))
        ],
      ),
    );
  }

  Widget _submitButton() {
    const snackBar = SnackBar(
      content: Text('Inicio de sesión exitoso'),
      duration: Duration(seconds: 2),
      backgroundColor: Color(0xff164863),
      behavior: SnackBarBehavior.floating,
    );
    return InkWell(
      onTap: () async {
        String phone = _phoneNumberController.text;
        String password = _passwordController.text;

        LoginResponse result = await login(phone, password);
        final datos = result.userData;
        print('Estoy en Login: ${datos}');

        if (result.success) {
          // Login exitoso, mostrar mensaje de éxito
          String id = datos!.isNotEmpty ? datos[0]['id'].toString() : '';
          CallContac contacts = await ListContact(id);
          final listcontacts = contacts.userid;
          print('Lista De Contactos ${contacts.userid}');
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ContactsPage(
                  userDataList: datos
                      .map((dynamic item) => UserData(
                          id: item['id'].toString(),
                          fullname: item['fullname'].toString(),
                          phone: phone))
                      .toList(),
                  ListContacts: listcontacts
                      ?.map((dynamic item) => ListData(
                          fullname: item['fullname'].toString(),
                          phone: item['phone'].toString()))
                      .toList(),
                ),
              ));

          _phoneNumberController.clear();
          _passwordController.clear();
        } else {
          const snackBar = SnackBar(
            content: Text('Verify your Credentials'),
            duration: Duration(seconds: 2),
            backgroundColor: Color.fromARGB(255, 233, 6, 25),
            behavior: SnackBarBehavior.floating,
          );
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        }
      },
      child: Container(
        width: MediaQuery.of(context).size.width,
        padding: const EdgeInsets.symmetric(vertical: 15),
        alignment: Alignment.center,
        decoration: BoxDecoration(
            borderRadius: const BorderRadius.all(Radius.circular(5)),
            boxShadow: <BoxShadow>[
              BoxShadow(
                  color: Colors.grey.shade200,
                  offset: const Offset(2, 4),
                  blurRadius: 5,
                  spreadRadius: 2)
            ],
            gradient: const LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: [Color(0xff427D9D), Color(0xff164863)])),
        child: const Text(
          'Login',
          style: TextStyle(fontSize: 20, color: Colors.white),
        ),
      ),
    );
  }

  Widget _createAccountLabel() {
    return InkWell(
      onTap: () {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => const SignUpScreen()));
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 20),
        padding: const EdgeInsets.all(15),
        alignment: Alignment.bottomCenter,
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Don\'t have an account ?',
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
            ),
            SizedBox(
              width: 10,
            ),
            Text(
              'Register',
              style: TextStyle(
                  color: Color(0xff427D9D),
                  fontSize: 13,
                  fontWeight: FontWeight.w600),
            ),
          ],
        ),
      ),
    );
  }

  Widget _title() {
    return RichText(
      textAlign: TextAlign.center,
      text: const TextSpan(
          style: TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.w700,
          ),
          children: [
            TextSpan(
              text: 'Chat',
              style: TextStyle(color: Colors.black, fontSize: 30),
            ),
            TextSpan(
              text: 'Lipeo',
              style: TextStyle(color: Color(0xff427D9D), fontSize: 30),
            ),
          ]),
    );
  }

  Widget _emailPasswordWidget() {
    return Column(
      children: <Widget>[
        _entryField("Phone Number", controller: _phoneNumberController),
        _entryField("Password",
            isPassword: true, controller: _passwordController),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return GestureDetector(
        onTap: () {
          _phoneNumberFocus.unfocus();
          _passwordFocus.unfocus();
        },
        child: Scaffold(
            body: InkWell(
                onTap: () {
                  _phoneNumberFocus.unfocus();
                  _passwordFocus.unfocus();
                },
                child: SizedBox(
                  height: height,
                  child: Stack(
                    children: <Widget>[
                      Positioned(
                          top: -height * .15,
                          right: -MediaQuery.of(context).size.width * .4,
                          child: const BezierContainer()),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              SizedBox(height: height * .2),
                              _title(),
                              const SizedBox(height: 50),
                              _emailPasswordWidget(),
                              const SizedBox(height: 20),
                              _submitButton(),
                              SizedBox(height: height * .055),
                              _createAccountLabel(),
                            ],
                          ),
                        ),
                      ),
                      Positioned(top: 40, left: 0, child: _backButton()),
                    ],
                  ),
                ))));
  }
}
/* body: SizedBox(
          height: height,
          child: Stack(
            children: <Widget>[
              Positioned(
                  top: -height * .15,
                  right: -MediaQuery.of(context).size.width * .4,
                  child: const BezierContainer()),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(height: height * .2),
                      _title(),
                      const SizedBox(height: 50),
                      _emailPasswordWidget(),
                      const SizedBox(height: 20),
                      _submitButton(),
                      SizedBox(height: height * .055),
                      _createAccountLabel(),
                    ],
                  ),
                ),
              ),
              Positioned(top: 40, left: 0, child: _backButton()),
            ],
          ),
        ) */

Future<LoginResponse> login(
  String phoneNumber,
  String password,
) async {
  const String url =
      'https://api-chat-lipeo-7ed91d26c81f.herokuapp.com/usuarios/login';
  final Map<String, dynamic> datosUsuario = {
    "phone": phoneNumber,
    "password": password,
  };
  final String jsonDatosUsuario = jsonEncode(datosUsuario);
  try {
    final response = await http.post(
      Uri.parse(url),
      body: jsonDatosUsuario,
      headers: {'Content-Type': 'application/json'},
    );
    List<dynamic> responseData = json.decode(response.body);
    if (response.statusCode == 200) {
      return LoginResponse(true, responseData);
    } else if (response.statusCode == 401) {
      print('Usuario o Contraseña Incorrecto ${responseData}');
      return LoginResponse(false, responseData);
    } else {
      return LoginResponse(false, responseData);
    }
  } catch (error) {
    print('Error: $error');
    return LoginResponse(false, []);
  }
}

Future<CallContac> ListContact(String id) async {
  const String url =
      'https://api-chat-lipeo-7ed91d26c81f.herokuapp.com/usuarios/consultar_contactos';

  final Map<String, dynamic> datosUsuario = {"id": id};

  final String jsonDatosUsuario = jsonEncode(datosUsuario);

  try {
    final response = await http.post(
      Uri.parse(url),
      body: jsonDatosUsuario,
      headers: {'Content-Type': 'application/json'},
    );
    List<dynamic> responseData = json.decode(response.body);
    if (response.statusCode == 200) {
      return CallContac(responseData);
    }
  } catch (error) {
    print('Error: $error');
    return CallContac([]);
  }
  return CallContac([]);
}
