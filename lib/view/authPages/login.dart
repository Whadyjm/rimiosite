import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:rimiosite/rootScreen.dart';
import 'package:rimiosite/view/authPages/registro.dart';
import 'package:rimiosite/view/webView.dart';
import 'package:rimiosite/widgets/customButton.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {

  bool visible = true;

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  final formKey = GlobalKey<FormState>(); // Para hacer validación de los TextField


  void wrongEmail() async {
    await showDialog(context: context, builder: (context){
      return const AlertDialog(title: Text('El correo o contraseña no son válidos.\n\nVerifique e intente nuevamente.', style: TextStyle(fontSize: 18),),);
    });
  }

  void wrongPassword(){
    showDialog(context: context, builder: (context){
      return const AlertDialog(title: Text('La contraseña suministrada es incorrecta'),);
    });
  }
  final auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {

    bool screenSize = MediaQuery.sizeOf(context).width > 600;

    return AlertDialog(
      content: Center(
        child: SizedBox(
          width: 500,
          child: SingleChildScrollView(
            child: Column(
              children: [
                Form(
                  key: formKey,
                  child: Column(
                    children: [
                      const SizedBox(height: 100,),
                      Image.asset(height: 100,'assets/Rimio_dp.png'),
                      const SizedBox(height: 50,),
                      Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: TextFormField(
                            controller: emailController,
                            obscureText: false,
                            keyboardType: TextInputType.emailAddress,
                            decoration: InputDecoration(
                                hintStyle: const TextStyle(color: Colors.grey, fontWeight: FontWeight.normal),
                                prefixIcon: const Icon(Icons.email_rounded, color: Colors.deepPurple,),
                                hintText: 'Ingrese su correo electrónico',
                                filled: true,
                                fillColor: Colors.grey.shade300,
                                border: OutlineInputBorder(
                                    borderSide: BorderSide.none,
                                    borderRadius: BorderRadius.circular(50)
                                )
                            ),
                            validator: (value){
                              if(value!.isEmpty){
                                return "Ingrese su correo registrado";
                              }else{
                                null;
                              }
                            }
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: TextFormField(
                            controller: passwordController,
                            obscureText: visible,
                            keyboardType: TextInputType.text,
                            decoration: InputDecoration(
                                hintStyle: const TextStyle(color: Colors.grey, fontWeight: FontWeight.normal),
                                prefixIcon: const Icon(Icons.lock, color: Colors.deepPurple,),
                                suffixIcon: IconButton(
                                  icon: Icon(visible ? Icons.visibility:Icons.visibility_off_rounded, color: Colors.deepPurple,),
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
                      const Padding(
                        padding: EdgeInsets.only(right: 30),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            // GestureDetector(
                            //     onTap: (){
                            //       Navigator.of(context).push(MaterialPageRoute(builder: (context){
                            //         return const Password();
                            //       }));
                            //     },
                            //     child: const Text('Recuperar contraseña', style: TextStyle(color: Colors.deepPurple, fontWeight: FontWeight.w600),)),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(30.0),
                        child: CustomButton(
                            onTap: () async {
                              showDialog(context: context, builder: (context){
                                return const Center(
                                    child: CircularProgressIndicator(
                                      color: Colors.deepPurple,
                                    ));
                              });
                              try {
                                final credential = await FirebaseAuth.instance.signInWithEmailAndPassword(
                                  email: emailController.text.trim(),
                                  password: passwordController.text.trim(),
                                );
                                Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context){
                                  return screenSize ? const WebView():const RootScreen();
                                }), (route) => false);
                              } on FirebaseAuthException catch (e) {
                                Navigator.pop(context);
                                if (e.code == 'invalid-credential') {
                                  wrongEmail();
                                } else if (formKey.currentState!.validate()) {
                                  Navigator.pop(context);
                                }
                              }
                            },
                            height: 50,
                            width: 180,
                            color: Colors.deepPurple,
                            radius: 50,
                            text: 'Iniciar sesión',
                            fontSize: 20,
                            textColor: Colors.white,
                            shadow: 0,
                            colorShadow: Colors.transparent),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text('¿No posees cuenta?'),
                          const SizedBox(width: 20,),
                          TextButton(onPressed: () {
                            Navigator.pop(context);
                            showDialog(context: context, builder: (context){
                              return const Registro();
                            });
                          },
                            child: const Text('Regístrate', style: TextStyle(fontSize: 18, color: Colors.deepPurple, fontWeight: FontWeight.w600),),),
                        ],
                      ),
                      const SizedBox(height: 30,),
                      //const GoogleBttn(),
                      const SizedBox(height: 30,),
                      // GestureDetector(
                      //     onTap: (){
                      //       Navigator.push(context, MaterialPageRoute(builder: (context){
                      //         return Agreement();
                      //       }));
                      //     },
                      //     child: const Text('Términos y condiciones', style: TextStyle(color: Colors.grey, decoration: TextDecoration.underline),))
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
