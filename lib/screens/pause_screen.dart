import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PauseScreen extends StatelessWidget {
  const PauseScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Align(
      child: Container(
        height: 300,
        width: 500,
        decoration: BoxDecoration(
          color: Colors.purple,
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: const Column(
          children: <Widget>[
            Text("Tela de Pause"),

          ],
        ),
      ),
    );
    throw UnimplementedError();
  }

}