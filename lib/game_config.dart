import 'dart:io';

import 'package:flame/game.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_flame/pixel_adventure.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class GameConfig extends StatefulWidget {
  const GameConfig({Key? key, required this.game}) : super(key: key);

  final PixelAdventure game;

  @override
  State<StatefulWidget> createState() => _BannerExampleState();

}

class _BannerExampleState extends State<GameConfig> {

  @override
  void initState() {
    super.initState();
    loadAd();
    if (_bannerAd != null) {

    }
  }

  BannerAd? _bannerAd;
  bool _isLoaded = false;

  // TODO: replace this test ad unit with your own ad unit.
  final adUnitId = Platform.isAndroid
      ? 'ca-app-pub-3940256099942544/6300978111'
      : 'ca-app-pub-3940256099942544/2934735716';

  /// Loads a banner ad.
  void loadAd() {
    _bannerAd = BannerAd(
      adUnitId: adUnitId,
      request: const AdRequest(),
      size: AdSize.banner,
      listener: BannerAdListener(
        // Called when an ad is successfully received.
        onAdLoaded: (ad) {
          debugPrint('$ad loaded.');
          setState(() {
            _isLoaded = true;
          });
        },
        // Called when an ad request failed.
        onAdFailedToLoad: (ad, err) {
          debugPrint('BannerAd failed to load: $err');
          // Dispose the ad here to free resources.
          ad.dispose();
        },
      ),
    )..load();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          GameWidget(game: kDebugMode ? PixelAdventure() : widget.game),
        ],
      ),
      bottomNavigationBar: _isLoaded ? SizedBox(
        height: _bannerAd?.size.height.toDouble(),
        width: _bannerAd?.size.width.toDouble(),
        child: AdWidget(ad: _bannerAd!),
      ) : const SizedBox(),
    );
    throw UnimplementedError();
  }
}
