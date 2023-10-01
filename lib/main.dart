import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:time_beater/screens/pause_screen.dart';
import 'package:time_beater/time_beater.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import 'config/Admob/AdmobBanner.dart';

void main() async{
  var devices = ['1AC1C6C2D7CE5D4164E694CD0E20A045'];
  WidgetsFlutterBinding.ensureInitialized();
  await MobileAds.instance.initialize();
  await Flame.device.fullScreen();
  await Flame.device.setLandscape();

  RequestConfiguration requestConfiguration = RequestConfiguration(
    testDeviceIds: devices
  );
  MobileAds.instance.updateRequestConfiguration(requestConfiguration);

  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  MyAppState createState() => MyAppState();
}

class MyAppState extends State<MyApp> {

  @override
  void initState() {
    super.initState();
    // Load ads.
  }

  TimeBeater game = TimeBeater();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Stack(
          fit: StackFit.expand,
          children: [
            GameWidget(
                game: kDebugMode ? TimeBeater() : game,
                overlayBuilderMap: {
                'PauseMenu': (BuildContext context, TimeBeater game) {
                  return const PauseScreen();
                },
              },
            ),
            const AdmobBanner(),
          ],
        ),
      ),
    );
    throw UnimplementedError();
  }
}