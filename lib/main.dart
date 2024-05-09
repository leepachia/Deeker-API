import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:provider/provider.dart';
import 'songs_model.dart';
import 'home_widget.dart';

/// Author: Pachia Lee
/// Date: 22 March 2024
///  
/// Description: This app allows user to search songs based on the Deezer API: https://rapidapi.com/deezerdevs/api/deezer-1/

void main() {
  // Runs the app with a change notifier provider to provide the model
  runApp(ChangeNotifierProvider(create: (context) => SongsModel(),
  child: const MaterialApp(
    home: MainApp()
  )));
}

class MainApp extends StatefulWidget {
  const MainApp({super.key});

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  late Consumer consumer;

  // Widget that returns a scaffold with the consumer listening to the model
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Consumer<SongsModel>(builder: (context, songsModel, child) => HomeWidget(model: songsModel),
      ),
    ));
  }
}
