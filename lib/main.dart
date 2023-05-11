import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:vote_app/views/screens/home_page.dart';
import 'package:vote_app/views/screens/party_vote.dart';
import 'package:vote_app/views/screens/vote_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.teal,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const Home_Page(),
        'vote_page': (context) => const Vote_Page(),
        'party_page': (context) => const Party_Page(),
      },
    ),
  );
}
