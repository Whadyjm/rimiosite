import 'dart:convert';
import 'dart:io' as Io;
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rimiosite/view/image_with_id_screen.dart';
import 'package:rimiosite/widgets/customButton.dart';
import 'package:rimiosite/widgets/image_picker_widget.dart';

class Registro extends StatefulWidget {
  const Registro({super.key});

  @override
  State<Registro> createState() => _RegistroState();
}

class _RegistroState extends State<Registro> {

  List<String> locationList = [
    'Amazonas',
    'Anzoátegui',
    'Apure',
    'Aragua',
    'Barinas',
    'Bolívar',
    'Carabobo',
    'Cojedes',
    "Falcón",
    "Delta Amacuro",
    "Dtto. Capital",
    "Guárico",
    "La Guaira",
    "Lara",
    "Mérida",
    "Miranda",
    "Monagas",
    "Nueva Esparta",
    "Portuguesa",
    "Sucre",
    "Táchira",
    "Trujillo",
    "Yaracuy",
    "Zulia",
  ];

  List<DropdownMenuItem<String>>? get locationDropDownList {
    List<DropdownMenuItem<String>>? menuItem =
    List<DropdownMenuItem<String>>.generate(
      locationList.length,
          (index) => DropdownMenuItem(
        value: locationList[index],
        child: Text(locationList[index]),
      ),
    );
    return menuItem;
  }

  bool visible = true;
  String? _locationValue;

  TextEditingController nameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController displayNameController = TextEditingController();
  TextEditingController cedulaController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController cityController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  //FirebaseFirestore firestore = FirebaseFirestore.instance;

  final formKey = GlobalKey<FormState>(); //Para hacer validación de los TextField

  XFile? _pickedImage;

  void pickImage() async {
    await showDialog(context: context, builder: (context){
      return AlertDialog(
        title: const Center(child: Text('Elije una opción')),
        content: SizedBox(
          height: 170,
          width: 150,
          child: Column(
            children: [
              const SizedBox(height: 5,),
              TextButton.icon(
                onPressed: (){
                  camaraPicker();
                  Navigator.pop(context);
                },
                icon: const Icon(Icons.camera_alt_rounded, color: Colors.deepPurple, size: 30,),
                label: const Text('Cámara', style: TextStyle(fontSize: 18),),
              ),
              const SizedBox(height: 5,),
              TextButton.icon(
                onPressed: (){
                  galeriaPicker();
                  Navigator.pop(context);
                },
                icon: const Icon(Icons.image, color: Colors.deepPurple, size: 30,),
                label: const Text('Galería', style: TextStyle(fontSize: 18),),
              ),
              const SizedBox(height: 5,),
              TextButton.icon(
                onPressed: (){
                  _pickedImage = null;
                  setState(() {});
                  Navigator.pop(context);
                },
                icon: const Icon(Icons.clear, color: Colors.redAccent, size: 30,),
                label: const Text('Eliminar', style: TextStyle(fontSize: 18),),
              ),
            ],
          ),
        ),
      );
    });
  }

  Future<void> camaraPicker() async {
    final ImagePicker imagePicker = ImagePicker();
    _pickedImage = await imagePicker.pickImage(source: ImageSource.camera);
    setState(() {});
  }

  String base64String = '';
  Future<void> galeriaPicker() async {
    final ImagePicker imagePicker = ImagePicker();
    _pickedImage = await imagePicker.pickImage(source: ImageSource.gallery);
    Uint8List _bytes = await _pickedImage!.readAsBytes();

    String _base64String = base64.encode(_bytes);
    setState(() {base64String = _base64String;});
  }



  void emailUsed() async {
    await showDialog(context: context, builder: (context){
      return AlertDialog(
        title: Column(
          children: [
            const Text('El correo proporcionado ya se encuentra en uso.'),
            Row(
              children: [
                TextButton(
                    onPressed: (){
                      Navigator.pop(context);
                    }, child: const Text('Reintentar')),
              ],
            )
          ],
        ),
      );
    });
  }

  void weakPassword() async {
    await showDialog(context: context, builder: (context){
      return AlertDialog(
        title: Column(
          children: [
            const Text('La contraseña proporcionada es muy débil.'),
            Row(
              children: [
                TextButton(
                    onPressed: (){
                      Navigator.pop(context);
                    }, child: const Text('Reintentar')),
              ],
            )
          ],
        ),
      );
    });
  }

  @override
  void dispose() {
    emailController.dispose();
    super.dispose();
  }

  bool isLoading = false;

  final auth = FirebaseAuth.instance;

  String? userImageUrl;


  @override
  Widget build(BuildContext context) {
    return AlertDialog(
        content: Center(
          child: SizedBox(
            width: 500,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Form(
                      key: formKey,
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            const SizedBox(height: 30,),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 10.0),
                              child: Align(
                                  alignment: Alignment.topLeft,
                                  child: Image.asset(height: 30,'assets/Rimio_dp.png')),
                            ),
                            const SizedBox(height: 20,),
                            SizedBox(
                                height: 100,
                                width: 100,
                                child: ImagePickerWidget(
                                  imagedPicked: _pickedImage,
                                  function: (){
                                    pickImage();
                                  },)),
                            //base64String != null ? Text(base64String, style: const TextStyle(overflow: TextOverflow.ellipsis),):const Text('No Data'),
                            const SizedBox(height: 15,),
                            Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: TextFormField(
                                      textCapitalization: TextCapitalization.words,
                                      controller: nameController,
                                      obscureText: false,
                                      keyboardType: TextInputType.text,
                                      decoration: InputDecoration(
                                          contentPadding: const EdgeInsets.all(15),
                                          hintStyle: const TextStyle(color: Colors.grey, fontWeight: FontWeight.normal),
                                          prefixIcon: const Icon(Icons.person_rounded, color: Colors.deepPurple,),
                                          hintText: 'Nombre',
                                          filled: true,
                                          fillColor: Colors.grey.shade300,
                                          border: OutlineInputBorder(
                                              borderSide: BorderSide.none,
                                              borderRadius: BorderRadius.circular(50)
                                          )
                                      ),
                                      validator: (value){
                                        if(value!.isEmpty){
                                          return "Ingrese su nombre";
                                        }else{
                                          null;
                                        }
                                      }
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: TextFormField(
                                      textCapitalization: TextCapitalization.words,
                                      controller: lastNameController,
                                      obscureText: false,
                                      keyboardType: TextInputType.text,
                                      decoration: InputDecoration(
                                          contentPadding: const EdgeInsets.all(15),
                                          hintStyle: const TextStyle(color: Colors.grey, fontWeight: FontWeight.normal),
                                          hintText: 'Apellido',
                                          filled: true,
                                          fillColor: Colors.grey.shade300,
                                          border: OutlineInputBorder(
                                              borderSide: BorderSide.none,
                                              borderRadius: BorderRadius.circular(50)
                                          )
                                      ),
                                      validator: (value){
                                        if(value!.isEmpty){
                                          return "Ingrese su apellido";
                                        }else{
                                          null;
                                        }
                                      }
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: TextFormField(
                                      textCapitalization: TextCapitalization.words,
                                      controller: displayNameController,
                                      obscureText: false,
                                      keyboardType: TextInputType.text,
                                      decoration: InputDecoration(
                                          contentPadding: const EdgeInsets.all(15),
                                          hintStyle: const TextStyle(color: Colors.grey, fontWeight: FontWeight.normal),
                                          hintText: 'Usuario',
                                          filled: true,
                                          fillColor: Colors.grey.shade300,
                                          border: OutlineInputBorder(
                                              borderSide: BorderSide.none,
                                              borderRadius: BorderRadius.circular(50)
                                          )
                                      ),
                                      validator: (value){
                                        if(value!.isEmpty){
                                          return "Establece un nombre de usuario";
                                        }else{
                                          null;
                                        }
                                      }
                                  ),
                                ),
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: TextFormField(
                                  controller: cedulaController,
                                  obscureText: false,
                                  keyboardType: TextInputType.number,
                                  decoration: InputDecoration(
                                      contentPadding: const EdgeInsets.all(15),
                                      hintStyle: const TextStyle(color: Colors.grey, fontWeight: FontWeight.normal),
                                      prefixIcon: const Icon(Icons.numbers_rounded, color: Colors.deepPurple,),
                                      hintText: 'Cédula de identidad',
                                      filled: true,
                                      fillColor: Colors.grey.shade300,
                                      border: OutlineInputBorder(
                                          borderSide: BorderSide.none,
                                          borderRadius: BorderRadius.circular(50)
                                      )
                                  ),
                                  validator: (value){
                                    if(value!.isEmpty){
                                      return "Ingrese su cédula de identidad";
                                    }else{
                                      null;
                                    }
                                  }
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: TextFormField(
                                  maxLength: 10,
                                  controller: phoneController,
                                  obscureText: false,
                                  keyboardType: TextInputType.number,
                                  decoration: InputDecoration(
                                      contentPadding: const EdgeInsets.all(15),
                                      hintStyle: const TextStyle(color: Colors.grey, fontWeight: FontWeight.normal),
                                      prefixIcon: const Icon(Icons.phone, color: Colors.deepPurple,),
                                      prefixText: '+58 ',
                                      prefixStyle: TextStyle(color: Colors.deepPurple, fontSize: 17),
                                      hintText: 'Ej.:4241234567',
                                      filled: true,
                                      fillColor: Colors.grey.shade300,
                                      border: OutlineInputBorder(
                                          borderSide: BorderSide.none,
                                          borderRadius: BorderRadius.circular(50)
                                      )
                                  ),
                                  validator: (value){
                                    if(value!.isEmpty){
                                      return "Ingrese su nro telefónico";
                                    }else{
                                      null;
                                    }
                                  }
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: DropdownButtonFormField(
                                  decoration: InputDecoration(
                                      hintText: "Selecciona tu ubicación",
                                      contentPadding: const EdgeInsets.all(15),
                                      hintStyle: const TextStyle(color: Colors.grey, fontWeight: FontWeight.normal),
                                      filled: true,
                                      fillColor: Colors.grey.shade300,
                                      border: OutlineInputBorder(
                                          borderSide: BorderSide.none,
                                          borderRadius: BorderRadius.circular(25)
                                      )
                                  ),
                                  dropdownColor: Colors.white,
                                  borderRadius: BorderRadius.circular(25),
                                  items: locationDropDownList,
                                  value: _locationValue,
                                  onChanged: (String? value) {
                                    setState(() {
                                      _locationValue = value;
                                    });
                                  }),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: TextFormField(
                                  controller: emailController,
                                  obscureText: false,
                                  keyboardType: TextInputType.emailAddress,
                                  decoration: InputDecoration(
                                      contentPadding: const EdgeInsets.all(15),
                                      hintStyle: const TextStyle(color: Colors.grey, fontWeight: FontWeight.normal),
                                      prefixIcon: const Icon(Icons.email_rounded, color: Colors.deepPurple,),
                                      hintText: 'Correo electrónico',
                                      filled: true,
                                      fillColor: Colors.grey.shade300,
                                      border: OutlineInputBorder(
                                          borderSide: BorderSide.none,
                                          borderRadius: BorderRadius.circular(50)
                                      )
                                  ),
                                  validator: (value){
                                    if(value!.isEmpty || !value.contains('@')){
                                      return "Ingrese un correo electrónico válido";
                                    }else{
                                      null;
                                    }
                                  }
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: TextFormField(
                                  controller: passwordController,
                                  obscureText: visible,
                                  keyboardType: TextInputType.text,
                                  decoration: InputDecoration(
                                      contentPadding: const EdgeInsets.all(15),
                                      hintStyle: const TextStyle(color: Colors.grey, fontWeight: FontWeight.normal),
                                      prefixIcon: const Icon(Icons.lock_rounded, color: Colors.deepPurple,),
                                      suffixIcon: IconButton(
                                        icon: Icon(visible ? Icons.visibility:Icons.visibility_off_rounded),
                                        onPressed: () {
                                          setState(() {
                                            visible = !visible;
                                          });
                                        },),
                                      hintText: 'Contraseña',
                                      filled: true,
                                      fillColor: Colors.grey.shade300,
                                      border: OutlineInputBorder(
                                          borderSide: BorderSide.none,
                                          borderRadius: BorderRadius.circular(50)
                                      )
                                  ),
                                  validator: (value){
                                    if(value!.isEmpty){
                                      return "Ingrese su contraseña";
                                    }else{
                                      null;
                                    }
                                  }
                              ),
                            ),
                            const SizedBox(height: 10)
                          ],
                        ),
                      )),
                  Padding(
                    padding: const EdgeInsets.all(30.0),
                    child: MaterialButton(
                      onPressed: () {  },
                      child: CustomButton(
                          onTap: () async {

                            if (_pickedImage == null){
                              showDialog(context: context, builder: (context){
                                return const AlertDialog(
                                  title: Column(
                                    children: [
                                      Text('Asegúrate de elegir una imagen para tu perfil.'),
                                    ],
                                  ),
                                );
                              });
                              return;
                            }

                            if (_locationValue == null){
                              showDialog(context: context, builder: (context){
                                return const AlertDialog(
                                  title: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text('Selecciona tu ubicación'),
                                    ],
                                  ),
                                );
                              });
                              return;
                            }

                            if (formKey.currentState!.validate()) {

                              showDialog(context: context, builder: (context){
                                return const Center(
                                    child: CircularProgressIndicator(
                                      color: Colors.deepPurple,
                                    ));
                              });

                              try {
                                setState(() {
                                  isLoading = true;
                                });

                                var body = {
                                  'displayName': displayNameController.text.trim(),
                                  'userName': nameController.text.trim(),
                                  'userLastName': lastNameController.text.trim(),
                                  'cedula': cedulaController.text.trim(),
                                  'phone': '+58${phoneController.text.trim()}',
                                  'location': _locationValue,
                                  'password': passwordController.text.trim(),
                                  'userImage': userImageUrl,
                                  'userEmail': emailController.text.toLowerCase(),
                                  'createdAt': Timestamp.now(),
                                  'userWish': [],
                                  'points': 5,
                                };

                                String email =
                                emailController.text.toLowerCase().trim();
                                String password =
                                passwordController.text.trim().trim();
                                Navigator.push(context,
                                    MaterialPageRoute(builder: (context) {
                                      return ImageWithIdScreen(
                                        body: body,
                                        profileImage: _pickedImage,
                                        email: email,
                                        password: password,
                                        displayNameController: displayNameController,
                                      );
                                    }));

                                /*ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(
                                          duration: Duration(seconds: 3),
                                          elevation: 10,
                                          content: Center(
                                            child: Text('¡Te has registrado con éxito!',
                                              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15),),
                                          ),
                                          backgroundColor: Colors.deepPurple,));*/
                                /*if (!mounted) return;
                                    Navigator.pushAndRemoveUntil(context,
                                        MaterialPageRoute(builder: (context) {
                                          return Login();
                                        }), (route) => false);*/
                              } on FirebaseAuthException catch (e) {
                                if (e.code == 'weak-password') {
                                  weakPassword();
                                } else if (e.code == 'email-already-in-use') {
                                  emailUsed();
                                }
                              } catch (e) {
                                print(e);
                              } finally {
                                isLoading = false;
                              }
                            };
                          },
                          height: 50,
                          width: 150,
                          color: Colors.deepPurple,
                          radius: 50,
                          text: 'Siguiente',
                          fontSize: 20,
                          textColor: Colors.white,
                          shadow: 8,
                          colorShadow: Colors.white38),
                    ),
                  )
                ],
              ),
            ),
          ),
        )
    );
  }
}

