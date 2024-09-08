import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Home'),
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text('No products', textAlign: TextAlign.center,),
            FilledButton.tonal(
              onPressed: () {
                Navigator.pushNamed(context, '/new_product');
              },
              child: Text('Add new product'),
            )
          ],
        ),
      ),
    );
  }
}
