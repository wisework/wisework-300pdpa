import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Route Test'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text('Home page'),
            ElevatedButton(
                onPressed: () {
                  context.go(
                    Uri(
                      path: '/myhome'+'TEST',
                      queryParameters: {'id': 1},
                      
                    ).toString(),
                    
                  );
                },
                child: Text('GO'))
          ],
        ),
      ),
    );
  }
}
