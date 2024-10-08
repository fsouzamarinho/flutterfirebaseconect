import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserProfileScreen extends StatefulWidget {
  final User user;

  const UserProfileScreen(this.user, {super.key});

  @override
  _UserProfileScreenState createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  Map<String, dynamic>? userData;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    try {
      // Carrega os dados do usuário a partir do Firestore
      DocumentSnapshot userDoc =
          await _firestore.collection('users').doc(widget.user.uid).get();
      setState(() {
        userData = userDoc.data() as Map<String, dynamic>?;
      });
    } catch (e) {
      print("Erro ao carregar dados do usuário: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Perfil do Usuário')),
      body: userData == null
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Nome: ${userData!['name'] ?? 'Nome não informado'}'),
                  Text('Idade: ${userData!['age'] ?? 'Idade não informada'}'),
                  Text(
                      'Cidade: ${userData!['city'] ?? 'Cidade não informada'}'),
                  Text('Email: ${widget.user.email}'),
                ],
              ),
            ),
    );
  }
}
