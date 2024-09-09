import 'package:flutter/material.dart';

class DetailScreen extends StatelessWidget {
  const DetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Detail'),
        leading: BackButton(
          onPressed: () { Navigator.pop(context); },
        ),
      ),
      body: Center(
        child: Text('Detail')
      ),
    );
  }
}
