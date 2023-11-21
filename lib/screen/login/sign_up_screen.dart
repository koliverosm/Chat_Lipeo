// ignore_for_file: unused_local_variable, avoid_print, prefer_final_fields, use_build_context_synchronously

import 'dart:async';

import 'package:chat_lipeo/screen/login/login_screen.dart';
import 'package:chat_lipeo/widget/bezier_container.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key, this.title}) : super(key: key);

  final String? title;

  @override
  // ignore: library_private_types_in_public_api
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  TextEditingController _usernameController = TextEditingController();
  TextEditingController _phoneNumberController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  TextEditingController _fullnameController = TextEditingController();
  Widget _backButton() {
    return InkWell(
      onTap: () {
        Navigator.pop(context);
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
              decoration: const InputDecoration(
                  border: InputBorder.none,
                  fillColor: Color(0xfff3f3f4),
                  filled: true))
        ],
      ),
    );
  }

  Widget _submitButton() {
    return InkWell(
      onTap: () async {
        // Obtener valores de los controladores
        String fullname = _fullnameController.text;
        String username = _usernameController.text;
        String phoneNumber = _phoneNumberController.text;
        String password = _passwordController.text;
        print(
            "Fullname: $fullname username: $username password: $password phoneNumber: $phoneNumber");

        // Llamar a la función de registro
        bool respuesta =
            await registrarUsuario(fullname, username, password, phoneNumber);
        if (respuesta) {
          // Borrar contenido de las cajas de texto
          _fullnameController.clear();
          _usernameController.clear();
          _phoneNumberController.clear();
          _passwordController.clear();
          const snackBar = SnackBar(
            content: Text('¡Successful registration!'),
            duration: Duration(seconds: 3),
            backgroundColor: Color(0xff164863),
            behavior: SnackBarBehavior.floating,
          );
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
          Timer(const Duration(seconds: 1), () {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => const LoginScreen()));
          });
        } else {
          const snackBar = SnackBar(
            content: Text('¡error when registering!'),
            duration: Duration(seconds: 3),
            backgroundColor: Color.fromARGB(255, 99, 22, 22),
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
          'Register Now',
          style: TextStyle(fontSize: 20, color: Colors.white),
        ),
      ),
    );
  }

  Widget _loginAccountLabel() {
    return InkWell(
      onTap: () {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => const LoginScreen()));
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 20),
        padding: const EdgeInsets.all(15),
        alignment: Alignment.bottomCenter,
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Already have an account ?',
              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
            ),
            SizedBox(
              width: 10,
            ),
            Text(
              'Login',
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
        _entryField("Fullname", controller: _fullnameController),
        _entryField("Username", controller: _usernameController),
        _entryField("Password",
            isPassword: true, controller: _passwordController),
        _entryField("Phone Number", controller: _phoneNumberController),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    return Scaffold(
      body: SizedBox(
        height: height,
        child: Stack(
          children: <Widget>[
            Positioned(
              top: -MediaQuery.of(context).size.height * .15,
              right: -MediaQuery.of(context).size.width * .4,
              child: const BezierContainer(),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    SizedBox(height: height * .2),
                    _title(),
                    const SizedBox(
                      height: 50,
                    ),
                    _emailPasswordWidget(),
                    const SizedBox(
                      height: 20,
                    ),
                    _submitButton(),
                    SizedBox(height: height * .14),
                    _loginAccountLabel(),
                  ],
                ),
              ),
            ),
            Positioned(top: 40, left: 0, child: _backButton()),
          ],
        ),
      ),
    );
  }
}

Future<bool> registrarUsuario(String fullname, String username, String password,
    String phoneNumber) async {
  const String url =
      'https://api-chat-lipeo-7ed91d26c81f.herokuapp.com/usuarios/crear_usuario';
  var validacion = false;
  print("object");
  final Map<String, dynamic> datosUsuario = {
    "fullnames": fullname,
    "username": username,
    "password": password,
    "phone": phoneNumber,
  };
  print('Antes De la Peticion: $fullname:$username:$password:$phoneNumber');
  try {
    final response = await http.post(Uri.parse(url),
        body: json.encode(datosUsuario),
        headers: {'Content-Type': 'application/json'});
    print('Despues De la Peticion');
    if (response.statusCode == 201) {
      final Map<String, dynamic> responseData = json.decode(response.body);
      validacion = responseData['verify'];
      return validacion;
    } else {
      print(
          'Error al registrar el usuario. Código de estado: ${response.statusCode}');
      return validacion;
    }
  } catch (error) {
    print('Error: $error');
    return validacion;
  }
}
