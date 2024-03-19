import 'package:flutter/material.dart';
import'./mapview.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
// Copyright 2019 the Dart project authors. All rights reserved.
// Use of this source code is governed by a BSD-style license
// that can be found in the LICENSE file.

import 'package:flutter/material.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  final String title;

  const MyHomePage({
    super.key,
    required this.title,
  });

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
      ),
      body: FutureBuilder<LocationPermission>(
        future: Geolocator.requestPermission(),
        builder: (  context,   snapshot){
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Image.asset("assets/logo1.png"),
                const SizedBox(height: 20),
                const Text(
                  'Welcome! Continue as a guest?',
                  style: TextStyle(fontSize: 20),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    // Navigate to the next page here
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const SavedParkingSpotsPage()),
                    );
                  },
                  child: const Text('Continue as Guest'),
                ),
              ],
            ),
          );
        }
      ),
    );
  }
}

class SavedParkingSpotsPage extends StatefulWidget {
  const SavedParkingSpotsPage({super.key});

  @override
  _SavedParkingSpotsPageState createState() => _SavedParkingSpotsPageState();
}

class _SavedParkingSpotsPageState extends State<SavedParkingSpotsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Main Page'),
      ),
      body: Column(
        children: <Widget>[
          const Text(
            'SAVED PARKING SPOT',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 20),
          const Text('Enter Starting Point: '),
          const TextField(),
          const SizedBox(height: 10),
          const Text('Enter Destination Address:'),
          const TextField(),
          Expanded(
            child: ListView(
              // ... list items (implement this later)
            ),
          ),
          const SizedBox(
            height: 200,
            child: Center( // Add a child widget here, e.g., a map or placeholder
              child: Text('Map or other content will go here'),

            ),
          ),SizedBox(
            height: 200,
            child: Center(
              child: ElevatedButton(
                onPressed: () {
                  // Navigate to the MapView page
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => MapView()),
                  );
                },
                child: const Text('View Map'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
