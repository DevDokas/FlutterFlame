import 'package:flutter/cupertino.dart';
import 'package:time_beater/screens/chronometer_screen.dart';

class HudIngame extends StatelessWidget {
  const HudIngame({super.key});



  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: ChronometerScreen(milliseconds: 0, seconds: 0, minutes: 0,),
    );
    throw UnimplementedError();
  }

}