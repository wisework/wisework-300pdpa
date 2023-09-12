import 'package:flutter/material.dart';

class PdpaApp extends StatelessWidget {
  const PdpaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PDPA Management Platform',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueAccent),
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(
          title: const Text('PDPA Management Platform'),
        ),
        body: const Column(
          children: <Widget>[
            Center(child: Text('PDPA Management Platform')),
          ],
        ),
      ),
    );
  }
}
