// ignore_for_file: use_build_context_synchronously, non_constant_identifier_names, avoid_print, sort_child_properties_last, unrelated_type_equality_checks

import 'package:chat_lipeo/screen/chat/chat_page.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:chat_lipeo/screen/login/login_screen.dart';

class ContactsPage extends StatefulWidget {
  final List<UserData>? userDataList;
  final List<ListData>? ListContacts;
  const ContactsPage({Key? key, this.userDataList, this.ListContacts})
      : super(key: key);

  @override
  State<ContactsPage> createState() => _ContactsPageState();
}

class ListData {
  final String fullname;
  final String phone;
  ListData({required this.fullname, required this.phone});
}

class UserData {
  final String id;
  final String fullname;
  final String phone;

  UserData({required this.id, required this.fullname, required this.phone});
}

class _ContactsPageState extends State<ContactsPage> {
  Future<void> _refreshData() async {
    // Aquí puedes colocar la lógica para recargar los datos
    // Puedes llamar a funciones, hacer peticiones de red, etc.

    setState(() {
      // Aquí actualizas el estado para reflejar los nuevos datos
      // por ejemplo, puedes volver a cargar la lista de contactos
      // y asignarla a la variable 'contacts'
    });
  }

  late String MyID;
  late String Myfullname;
  late String phones;

  @override
  void initState() {
    super.initState();

    if (widget.userDataList != null && widget.userDataList!.isNotEmpty) {
      UserData firstUser = widget.userDataList![0];
      MyID = firstUser.id;
      Myfullname = firstUser.fullname;
      phones = firstUser.phone;
      print("Datos recibidos en ContactsPage:");
      print('ID: $MyID, Fullname: $Myfullname, Phone: $phones');
    }
    if (widget.ListContacts != null) {
      widget.ListContacts?.forEach((listData) {
        contacts.add(listData.fullname);
        number.add(listData.phone);
      });
    }
  }

  String combinarNombres(String nombre1, String nombre2) {
    String primeraPalabra1 = nombre1.split(' ').first;
    String primeraPalabra2 = nombre2.split(' ').first;

    return '${primeraPalabra1}and$primeraPalabra2';
  }

  List<String> contacts = [];
  List<String> number = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ChatLipeo $Myfullname'),
        leading: IconButton(
          icon: Image.asset(
            'assets/icons/hogar.png',
          ),
          onPressed: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => LoginScreen(phone: phones)));
            const snackBar = SnackBar(
              content: Text('closed session'),
              duration: Duration(seconds: 2),
              backgroundColor: Color.fromARGB(255, 31, 92, 133),
              behavior: SnackBarBehavior.floating,
            );
            ScaffoldMessenger.of(context).showSnackBar(snackBar);

            // Navigator.pop(context);
          },
        ),
      ),
      body: RefreshIndicator(
        onRefresh: _refreshData,
        child: ListView.builder(
          itemCount: contacts.length,
          itemBuilder: (context, index) {
            return ListTile(
              leading: CircleAvatar(
                child: Text(contacts[index][0]), // Este es el avatar
              ),
              title: Text(contacts[index]),
              onTap: () async {
                String nameconversation =
                    combinarNombres(Myfullname, contacts[index]);
                String numberContac = number[index].toString();

                ResponseConversation idconversacion = await createdconversation(
                    nameconversation, MyID, numberContac);
                if (idconversacion.success != Null) {
                  Navigator.push(context, MaterialPageRoute(builder: (_) {
                    return ChatPage(
                      iduser: MyID,
                      myname: Myfullname,
                      myphone: phones,
                      Otherid: '',
                      Othername: contacts[index],
                      Otherphone: number[index],
                      idconversation: '${idconversacion.success}',
                    );
                  }));
                } else {
                  const snackBar = SnackBar(
                    content: Text('An error has occurred'),
                    duration: Duration(seconds: 2),
                    backgroundColor: Color.fromARGB(255, 233, 6, 25),
                    behavior: SnackBarBehavior.floating,
                  );
                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                }
              },
            );
          },
        ),
      ),
      floatingActionButton: floatingActionButton(context),
    );
  }

  FloatingActionButton floatingActionButton(BuildContext context) {
    return FloatingActionButton.extended(
      backgroundColor: const Color(0xff427D9D),
      foregroundColor: Colors.white,
      onPressed: () {
        showAddContactModal(context);
      },
      label: const Text('Enviar Nuevo Mensaje'),
      icon: const Icon(Icons.message_outlined),
    );
  }

  Future<dynamic> showAddContactModal(BuildContext context) async {
    final TextEditingController nameController = TextEditingController();
    final TextEditingController phoneController = TextEditingController();

    await showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (_) {
        return Padding(
          padding: EdgeInsets.fromLTRB(
            8,
            8,
            8,
            MediaQuery.of(context).viewInsets.bottom,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(
                  labelText: 'Nombre',
                  hintText: 'Nombre no único',
                ),
              ),
              TextField(
                controller: phoneController,
                decoration: const InputDecoration(
                  labelText: 'Número de Teléfono',
                  hintText: 'Número único',
                ),
                keyboardType: TextInputType.phone,
              ),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                  onPressed: () async {
                    String namecontact = nameController.text;
                    String numbercontact = phoneController.text;
                    if (nameController.text.isNotEmpty &&
                        phoneController.text.isNotEmpty) {
                      ContactsReponse result =
                          await createcontact(MyID, namecontact, numbercontact);
                      int validation = result.success;
                      if (validation == 0) {
                        const snackBar0 = SnackBar(
                          content: Text(
                            'user is not registered in ChatLipeo',
                          ),
                          duration: Duration(seconds: 4),
                          backgroundColor: Color.fromARGB(255, 187, 57, 34),
                          behavior: SnackBarBehavior.floating,
                        );
                        ScaffoldMessenger.of(context).showSnackBar(snackBar0);
                      } else if (validation == 1) {
                        contacts.add(namecontact);
                        number.add(numbercontact);

                        const snackBar1 = SnackBar(
                          content: Text('added user',
                              style: TextStyle(
                                color: Colors.white,
                              )),
                          duration: Duration(seconds: 4),
                          backgroundColor: Color(0xff164863),
                          behavior: SnackBarBehavior.floating,
                        );
                        ScaffoldMessenger.of(context).showSnackBar(snackBar1);
                      } else if (validation == 2) {
                        const snackBar = SnackBar(
                          content: Text('user already exists in your list',
                              style: TextStyle(
                                color: Colors.white,
                              )),
                          duration: Duration(seconds: 4),
                          backgroundColor: Color.fromARGB(255, 19, 101, 145),
                          behavior: SnackBarBehavior.floating,
                        );
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      } else {
                        const snackBar = SnackBar(
                          content: Text('Error Code',
                              style: TextStyle(
                                color: Colors.white,
                              )),
                          duration: Duration(seconds: 4),
                          backgroundColor: Color(0xff164863),
                          behavior: SnackBarBehavior.floating,
                        );
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      }

                      Navigator.pop(context);
                    } else {
                      print("Campos Vacios");
                      const snackBar = SnackBar(
                        content: Text(
                          'Ambos campos deben ser completados',
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                        duration: Duration(seconds: 4),
                        backgroundColor: Color.fromARGB(255, 99, 27, 22),
                        behavior: SnackBarBehavior.floating,
                      );
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    }
                  },
                  icon: const Icon(Icons.add),
                  label: const Text('Agregar',
                      style:
                          TextStyle(color: Color.fromARGB(255, 253, 253, 253))),
                  style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xff427D9D))),
            ],
          ),
        );
      },
    );
  }
}

class ContactsReponse {
  final int success;

  ContactsReponse(this.success);
}

Future<ContactsReponse> createcontact(
    String iduser, String namecontact, String phonecontact) async {
  const String url =
      'https://api-chat-lipeo-7ed91d26c81f.herokuapp.com/usuarios/crear_contacto';
  final Map<String, dynamic> datecontact = {
    "id": iduser,
    "name": namecontact,
    "phone": phonecontact,
  };
  final String jsonDatosUsuario = jsonEncode(datecontact);
  try {
    final response = await http.post(
      Uri.parse(url),
      body: jsonDatosUsuario,
      headers: {'Content-Type': 'application/json'},
    );
    //  List<dynamic> responseData = json.decode(response.body);
    if (response.statusCode == 200) {
      print("Ya Existe Este Contacto Registrado En Tus Contactos");
      return ContactsReponse(2);
    } else if (response.statusCode == 205) {
      print('El Usuario No Esta Registrado En La Aplicacion');
      return ContactsReponse(0);
    } else if (response.statusCode == 201) {
      print('El Usario A Sido Registrado En Tus Contactos ');
      return ContactsReponse(1);
    } else {
      return ContactsReponse(3);
    }
  } catch (error) {
    print('Error: $error');
    return ContactsReponse(2);
  }
}

class ResponseConversation {
  final int success;

  ResponseConversation(this.success);
}

Future<ResponseConversation> createdconversation(
    String nameconversation, String iduser, String idOther) async {
  const String url =
      'https://api-chat-lipeo-7ed91d26c81f.herokuapp.com/usuarios/crear_conversacion';
  final Map<String, dynamic> data = {
    "name": nameconversation,
    "id": iduser,
    "id2": idOther,
  };
  final String jsonDatosUsuario = jsonEncode(data);
  try {
    final response = await http.post(
      Uri.parse(url),
      body: jsonDatosUsuario,
      headers: {'Content-Type': 'application/json'},
    );

    Map<String, dynamic> responseData = json.decode(response.body);
//3008264845
// Accede al valor de 'id'
    int? id = responseData['id'];
    if (response.statusCode == 200) {
      return ResponseConversation(id!);
    } else if (response.statusCode == 201) {
      return ResponseConversation(id!);
    } else if (response.statusCode == 404) {
      return ResponseConversation(id!);
    } else {
      return ResponseConversation(id!);
    }
  } catch (error) {
    print('Error: $error');
    return ResponseConversation(404);
  }
}
