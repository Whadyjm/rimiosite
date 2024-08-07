import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:action_slider/action_slider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:rimiosite/models/user_model.dart';
import 'package:rimiosite/providers/user_provider.dart';
import 'package:rimiosite/view/authPages/login.dart';
import 'package:rimiosite/widgets/customButton.dart';
import 'package:rimiosite/widgets/loadingManager.dart';

class Perfil extends StatefulWidget {
  const Perfil({super.key});

  @override
  State<Perfil> createState() => _PerfilState();
}

class _PerfilState extends State<Perfil> {

  UserModel? userModel;
  User? user = FirebaseAuth.instance.currentUser;
  bool _isLoading = true;

  Future<void> fetchUserInfo() async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    try {
      setState(() {
        _isLoading = true;
      });
      userModel = await userProvider.fetchUserInfo();
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void initState() {
    fetchUserInfo();
    super.initState();
  }

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
  Future<void> galeriaPicker() async {
    final ImagePicker imagePicker = ImagePicker();
    _pickedImage = await imagePicker.pickImage(source: ImageSource.gallery);
    setState(() {});
  }

  void signOut(){
    FirebaseAuth.instance.signOut();
  }

  void confirmLogout() async {
    await showDialog(context: context, builder: (context){
      return AlertDialog(
        title: Column(
          children: [
            const Text('¿Seguro quieres cerrar sesión?'),
            Row(
              children: [
                TextButton(onPressed: (){Navigator.pop(context);}, child: const Text('Cancelar')),
                TextButton(onPressed: (){
                  signOut();
                  // Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context){
                  //   return const Login();
                  // }), (route) => false);
                  }, child: const Text('Confirmar')),
              ],
            )
          ],
        ),
      );
    });
  }

  TextEditingController nameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController displayNameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController emailController = TextEditingController();

  void editUser() {
    showDialog(context: context, builder: (context){
      return AlertDialog(
        content: Container(
          height: 320,
          width: 500,
          child: Column(
            children: [
              TextFormField(
                textCapitalization: TextCapitalization.words,
                controller: nameController,
                decoration: InputDecoration(
                    hintText: userModel!.userName
                ),
              ),
              TextFormField(
                textCapitalization: TextCapitalization.words,
                controller: lastNameController,
                decoration: InputDecoration(
                    hintText: userModel!.userLastName
                ),
              ),
              TextFormField(
                textCapitalization: TextCapitalization.words,
                controller: displayNameController,
                decoration: InputDecoration(
                    hintText: user!.displayName
                ),
              ),
              TextFormField(
                controller: phoneController,
                decoration: InputDecoration(
                    hintText: userModel!.phone
                ),
              ),
              TextFormField(
                controller: emailController,
                decoration: InputDecoration(
                    hintText: user!.email
                ),
              ),
              const SizedBox(height: 30,),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CustomButton(
                      onTap: (){
                        nameController.clear();
                        lastNameController.clear();
                        displayNameController.clear();
                        phoneController.clear();
                        emailController.clear();
                        Navigator.pop(context);
                      },
                      height: 40,
                      width: 100,
                      color: Colors.redAccent,
                      radius: 18,
                      text: 'Descartar',
                      textColor: Colors.white,
                      shadow: 2,
                      colorShadow: Colors.grey,
                      fontSize: 18),
                  const SizedBox(width: 20,),
                  CustomButton(
                      onTap: () async {
                        try {
                          await FirebaseFirestore.instance.collection('users').doc(user!.uid).update(
                              {
                                'userName': nameController.text.isEmpty ? userModel!.userName:nameController.text.trim(),
                                'userLastName': lastNameController.text.isEmpty ? userModel!.userLastName:lastNameController.text.trim(),
                                'displayName': displayNameController.text.isEmpty ? userModel!.displayName:displayNameController.text.trim(),
                                'phone': phoneController.text.isEmpty ? userModel!.phone:'+58${phoneController.text.trim()}',
                                'userEmail': emailController.text.isEmpty ? userModel!.userEmail:emailController.text.toLowerCase(),
                              });
                          user!.updateDisplayName(displayNameController.text.isEmpty ? userModel!.displayName:displayNameController.text.trim());
                          user!.updateEmail(emailController.text.isEmpty ? userModel!.userEmail:emailController.text.trim());
                          nameController.clear();
                          lastNameController.clear();
                          displayNameController.clear();
                          phoneController.clear();
                          emailController.clear();
                          Navigator.pop(context);
                        } catch (e) {

                        } finally {

                        }
                      },
                      height: 40,
                      width: 100,
                      color: Colors.deepPurpleAccent,
                      radius: 18,
                      text: 'Guardar',
                      textColor: Colors.white,
                      shadow: 2,
                      colorShadow: Colors.grey,
                      fontSize: 18),
                ],
              )
            ],
          ),
        ),
      );
    });
  }

  void eliminarCuenta() async {
    await showDialog(context: context, builder: (context){
      return AlertDialog(
        title: Container(
          height: 230,
          width: 500,
          child: Column(
            children: [
              const Text('¿Seguro deseas eliminar tu cuenta?'),
              const SizedBox(height: 30,),
              ActionSlider.standard(
                  icon: const Icon(Icons.delete_rounded,
                    color: Colors.white,),
                  loadingIcon: const CircularProgressIndicator(
                    color: Colors.white,),
                  successIcon: const Icon(
                    Icons.check, color: Colors.white,),
                  rolling: true,
                  child: const Row(
                    children: [
                      SizedBox(width: 50,),
                      Text('Desliza para eliminar',
                        style: TextStyle(fontSize: 15),),
                    ],
                  ),
                  action: (controller) async {
                    controller
                        .loading(); //starts loading animation
                    await Future.delayed(
                        const Duration(seconds: 3));
                    controller
                        .success();

                    await FirebaseFirestore.instance.collection('cuentasEliminadas').doc(user!.displayName).set(
                        {
                          'usuario': user!.displayName,
                          'uid': user!.uid,
                          'email': user!.email
                        });

                    await FirebaseFirestore.instance.collection('users').doc(user!.uid).delete();
                    await FirebaseAuth.instance.currentUser!.delete();
                    signOut();
                    // await Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context){
                    //   return const Login();
                    // }), (route) => false);
                  }),
              const SizedBox(height: 15,),
              Row(
                children: [
                  TextButton(onPressed: (){Navigator.pop(context);}, child: const Text('Cancelar')),
                ],
              ),
            ],
          ),
        ),
      );
    });
  }

  final userStream = FirebaseFirestore.instance.collection('users').snapshots();
  String? userImageUrl;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mi perfil', style: TextStyle(color: Colors.white),),
        backgroundColor: Theme.of(context).primaryColor,
        actions: [
          /*Padding(
            padding: const EdgeInsets.all(8.0),
            child: IconButton(onPressed: (){}, icon: const Icon(Icons.settings, color: Colors.white,)),
          ),*/
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: StreamBuilder<User?>(
                stream: FirebaseAuth.instance.authStateChanges(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return Row(
                      children: [
                        IconButton(onPressed: () async {
                          await showDialog(context: context, builder: (context){
                            return AlertDialog(
                              title: Column(
                                children: [
                                  SizedBox(
                                      height: 50, child: Image.asset('assets/Rimio_dp.png')),
                                  const SizedBox(height: 20,),
                                  const Text('Escríbenos al siguiente correo en caso de dudas, sugerencias o reporte de bugs y te contactaremos en la brevedad posible.', style: TextStyle(fontSize: 15),),
                                  const SizedBox(height: 20,),
                                  const Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text('info@rimio.shop', style: TextStyle(color: Colors.deepPurple),),
                                    ],
                                  ),
                                  const SizedBox(height: 20,),
                                ],
                              ),
                            );
                          },
                          );
                        }, icon: const Icon(Icons.help_outline_outlined, color: Colors.white, size: 25,)),
                        const SizedBox(width: 15,),
                        IconButton(onPressed: () async {
                          await showDialog(context: context, builder: (context){
                            return AlertDialog(
                                title: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    TextButton(
                                        onPressed: editUser,
                                        child: const Text("Editar datos de perfil")),
                                    const Divider(),
                                    TextButton(
                                        onPressed: confirmLogout,
                                        child: const Text("Cerrar sesión")),
                                    const Divider(),
                                    TextButton(
                                        onPressed: () {
                                          eliminarCuenta();
                                          //publishProvider.clearUserPublishItemFromFirestore();
                                        },
                                        child: const Text("Eliminar cuenta")),
                                  ],
                                )
                            );
                          },
                          );
                        }, icon: const Icon(Icons.settings, color: Colors.white,)),
                      ],
                    );
                  } else {
                    return Container();
                  }
                }
            ),
          ),
        ],
      ),
      body: LoadingManager(
        isLoading: _isLoading,
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Center(
                  child: Container(
                    height: 220,
                    width: 350,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: const [
                          BoxShadow(
                            blurRadius: 5,
                            color: Colors.grey,
                          )
                        ]
                    ),
                    child: userModel == null
                        ? Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Stack(
                          alignment: Alignment(0, 0),
                          children:[
                            CircleAvatar(radius: 60,),
                            Icon(Icons.person, color: Colors.white70, size: 100,)
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ElevatedButton(
                              onPressed: () {
                            Navigator.push(context,
                                MaterialPageRoute(builder: (context) {
                                  return const Login();
                                }));
                          }, child: const Text('Iniciar Sesión')),
                        ),
                      ],
                    )
                        :Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Stack(
                              alignment: const Alignment(0, 0),
                              children:[
                                userModel == null ? const SizedBox.shrink():
                                GestureDetector(
                                  onTap: () async {

                                    ImagePicker imagepicker = ImagePicker();

                                    XFile? file =
                                    await imagepicker.pickImage(source: ImageSource.gallery);

                                    Reference ref = FirebaseStorage.instance.ref();
                                    Reference referenceDirImages = ref.child('usersImages');

                                    Reference referenceImageToUpload = referenceDirImages.child('${userModel!.userEmail}.jpg');
                                    await referenceImageToUpload.putFile(File(file!.path));
                                    userImageUrl = await referenceImageToUpload.getDownloadURL();

                                    try {
                                      await FirebaseFirestore.instance.collection("users").doc(userModel!.userId).update({
                                        'userImage': userImageUrl,
                                      });
                                    } catch (e) {

                                    }
                                  },
                                  child: CircleAvatar(
                                    backgroundImage: NetworkImage(userModel!.userImage),
                                    radius: 50,
                                  ),
                                ),
                                /*SizedBox(
                                    height: 100,
                                    width: 100,
                                    child: editProfilePic(
                                      imagedPicked: _pickedImage,
                                      function: () async {
                                        pickImage();
                                        final ref = FirebaseStorage.instance.ref().child('usersImages');
                                        await ref.putFile(File(_pickedImage!.path));
                                        userImageUrl = await ref.getDownloadURL();
                                        await FirebaseFirestore.instance.collection("users").doc(userModel!.userId).update({
                                          'userImage': userImageUrl,
                                        });
                                      },)),*/
                                Visibility(visible: userModel == null ? true:false, child: const Icon(Icons.person, color: Colors.white70, size: 100,)),
                              ],
                            ),
                            const SizedBox(height: 10,),
                            if(userModel!.points < 10)
                              Image.asset(height: 40,'assets/bronze.png'),
                            if(userModel!.points >= 10 && userModel!.points<30)
                              Image.asset(height: 40,'assets/silver.png'),
                            if(userModel!.points >= 30 && userModel!.points<100)
                              Image.asset(height: 40,'assets/gold.png'),
                            if(userModel!.points >= 1000)
                              Image.asset(height: 40,'assets/medal.png'),
                          ],
                        ),
                        userModel == null
                            ? Container()
                            : Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const SizedBox(height: 10,),
                              Flexible(child: Text('${user!.displayName}', style: const TextStyle(overflow: TextOverflow.ellipsis),)),
                              const SizedBox(height: 10,),
                              Flexible(child: Text('${userModel!.userName} ${userModel!.userLastName}', style: const TextStyle(overflow: TextOverflow.ellipsis),)),
                              const SizedBox(height: 10,),
                              Flexible(child: Text(userModel!.userEmail, style: const TextStyle(overflow: TextOverflow.ellipsis),)),
                              Row(
                                children: [
                                  Text('Rimio Points: ${userModel!.points}', style: const TextStyle(fontSize: 15, overflow: TextOverflow.ellipsis),),
                                  const SizedBox(width: 5,),
                                  IconButton(icon: Icon(Icons.help, color: Colors.deepPurple,),
                                    onPressed: () async {
                                      await showDialog(context: context, builder: (context){
                                        return const AlertDialog(
                                          title: Column(
                                            children: [
                                              Text('Acumula Rimio Points con cada calificación que recibas para subir de reputación en la plataforma.',
                                                style: TextStyle(fontSize: 18),),
                                            ],
                                          ),
                                        );
                                      });
                                    },)
                                ],
                              ),
                              if(userModel!.points < 10)
                                const Text('Miembro: Bronce'),
                              if(userModel!.points >= 10 && userModel!.points<30)
                                const Text('Miembro: Plata'),
                              if(userModel!.points >= 30 && userModel!.points<100)
                                const Text('Miembro: Oro'),
                              if(userModel!.points >= 1000)
                                const Text('Miembro: Founder'),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Visibility(
                visible: user == null ? false:true,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Center(
                    child: Container(
                      height: 200,
                      width: 350,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: const [
                            BoxShadow(
                              blurRadius: 5,
                              color: Colors.grey,
                            )
                          ]
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              const Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Row(
                                  children: [
                                    Text('Historial', style: TextStyle(color: Colors.purple),)
                                  ],
                                ),
                              ),
                              GestureDetector(
                                // onTap: (){
                                //   Navigator.push(context, MaterialPageRoute(builder: (context){
                                //     return const MisCompras();
                                //   }));
                                // },
                                child: const Row(
                                  children: [
                                    Icon(Icons.shopping_basket_outlined),
                                    SizedBox(width: 10,),
                                    Text('Mis compras'),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 10,),
                              const Divider(),
                              const SizedBox(height: 10,),
                              GestureDetector(
                                // onTap: (){
                                //   Navigator.push(context, MaterialPageRoute(builder: (context){
                                //     return const Favoritos();
                                //   }));
                                // },
                                child: const Row(
                                  children: [
                                    Icon(Icons.favorite_outline_rounded),
                                    SizedBox(width: 10,),
                                    Text('Favoritos'),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 5,),
                              const Divider(),
                              const SizedBox(height: 5,),
                              GestureDetector(
                                // onTap: (){
                                //   Navigator.push(context, MaterialPageRoute(builder: (context){
                                //     return const VistosReciente();
                                //   }));
                                // },
                                child: const Row(
                                  children: [
                                    Icon(Icons.visibility_outlined),
                                    SizedBox(width: 10,),
                                    Text('Vistos recientemente'),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 10,),
                            ]
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Visibility(
                visible: user == null ? false:true,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Center(
                    child: Container(
                      height: 200,
                      width: 350,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: const [
                            BoxShadow(
                              blurRadius: 5,
                              color: Colors.grey,
                            )
                          ]
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              const Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Row(
                                  children: [
                                    Text('Ventas', style: TextStyle(color: Colors.purple),)
                                  ],
                                ),
                              ),
                              GestureDetector(
                                // onTap: (){
                                //   Navigator.push(context, MaterialPageRoute(builder: (context){
                                //     return const MisVentas();
                                //   }));
                                // },
                                child: const Row(
                                  children: [
                                    Icon(Icons.sell_outlined),
                                    SizedBox(width: 10,),
                                    Text('Mis Ventas'),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 10,),
                              const Divider(),
                              const SizedBox(height: 10,),
                              GestureDetector(
                                // onTap: (){
                                //   Navigator.push(context, MaterialPageRoute(builder: (context){
                                //     return const Favoritos();
                                //   }));
                                // },
                                child: GestureDetector(
                                  // onTap: (){
                                  //   Navigator.push(context, MaterialPageRoute(builder: (context){
                                  //     return const MisPublicaciones();
                                  //   }));
                                  // },
                                  child: const Row(
                                    children: [
                                      Icon(Icons.upload_outlined),
                                      SizedBox(width: 10,),
                                      Text('Mis publicaciones'),
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(height: 5,),
                            ]
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
