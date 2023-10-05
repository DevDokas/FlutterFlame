import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:time_beater/blocs/chronometer_bloc.dart';
import 'package:time_beater/components/chronometer.dart';
import 'package:time_beater/screens/character_selection_screen.dart';
import 'package:time_beater/screens/home_screen.dart';
import 'package:time_beater/screens/hud_ingame_screen.dart';
import 'package:time_beater/screens/load_screen.dart';
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

  runApp(
    /// Providers are above [MyApp] instead of inside it, so that tests
    /// can use [MyApp] while mocking the providers
    MultiProvider(
      providers: [
        Provider(create: (_) => ChronometerBloc()),
      ],
      child: MyApp(),
    ),
  );
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



  @override
  Widget build(BuildContext context) {
    TimeBeater game = TimeBeater(chronometerBloc: context.read<ChronometerBloc>());

    return GameWidget(
      game: TimeBeater(chronometerBloc: context.read<ChronometerBloc>()),
      overlayBuilderMap: {
        'HUDScreen': (BuildContext context, TimeBeater game) {
          return HudIngame();
        },
        'LoadScreen': (BuildContext context, TimeBeater game) {
          return LoadScreen(game);
        },
        'MainMenu': (BuildContext context, TimeBeater game) {
          return HomeScreen(game);
        },
        'CharacterSelection': (BuildContext context, TimeBeater game) {
          return CharacterSelectionScreen(game);
        },
        'PauseMenu': (BuildContext context, TimeBeater game) {
          return PauseScreen(game);
        },
        'AdmobBanner': (BuildContext context, TimeBeater game) {
          return const AdmobBanner();
        },
      },
    );
    throw UnimplementedError();
  }
}