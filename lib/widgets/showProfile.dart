import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ShowProfile extends StatefulWidget {
  const ShowProfile({super.key});

  @override
  State<ShowProfile> createState() => _ShowProfileState();
}

class _ShowProfileState extends State<ShowProfile> {

  User? user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Mi perfil'),
      content: Center(
        child: SizedBox(
          height: 500,
          child: Column(
            children: [
              CircleAvatar(
                radius: 80,
                backgroundImage: NetworkImage('${user?.photoURL}'),
              ),
              Text('${user?.displayName}'),
              Text('${user?.email}'),
            ],
          ),
        ),
      ),
    );
  }
}
