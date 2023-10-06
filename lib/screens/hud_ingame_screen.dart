import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rx_notifier/rx_notifier.dart';

import '../blocs/chronometer_bloc.dart';

class HudIngame extends StatefulWidget {
  const HudIngame({super.key});

  @override
  State<HudIngame> createState() => _HudIngameState();
}

class _HudIngameState extends State<HudIngame> {
  final milliseconds = RxNotifier<int>(0);
  final seconds = RxNotifier<int>(0);
  final minutes = RxNotifier<int>(0);
  final iniciou = RxNotifier<bool>(false);
  Timer? timerMilliseconds;
  Timer? timerSeconds;
  Timer? timerMinutes;


  @override
  Widget build(BuildContext context) {

    iniciou.value ? contador() : null;
    return Align(
      alignment: Alignment(0.67, -0.9),
      child: BlocBuilder<ChronometerBloc, ChronometerState>(
        builder: (context, state) {
          if (state is RunningChronometer) {
            iniciou.value = true;
            return RxBuilder(
                builder: (context) {
                  return Text(
                      "${minutes.value.toString().padLeft(2, '0')}:${seconds.value.toString().padLeft(2, '0')}:${(milliseconds.value % 1000 ~/ 10).toString().padLeft(2, '0')}",
                      style: const TextStyle(
                        fontSize: 40,
                      ),
                  );
                });
          } else if (state is PauseChronometer) {
            iniciou.value = false;
            timerMilliseconds?.cancel();
            timerSeconds?.cancel();
            timerMinutes?.cancel();
            return RxBuilder(
                builder: (context) {
                  return Text("${minutes.value.toString().padLeft(2, '0')}:${seconds.value.toString().padLeft(2, '0')}:${(milliseconds.value % 1000 ~/ 10).toString().padLeft(2, '0')}");
                });
          } else if (state is ResetChronometer) {
            iniciou.value = false;
            milliseconds.value = 0;
            seconds.value = 0;
            minutes.value = 0;
            timerMilliseconds?.cancel();
            timerSeconds?.cancel();
            timerMinutes?.cancel();
            return RxBuilder(
                builder: (context) {

                  return Text("${minutes.value.toString().padLeft(2, '0')}:${seconds.value.toString().padLeft(2, '0')}:${(milliseconds.value % 1000 ~/ 10).toString().padLeft(2, '0')}");
                });
          } else {
            // Caso padrão: exiba algo quando o estado não for reconhecido
            return RxBuilder(
                builder: (context) {
                  return Text("${minutes.value.toString().padLeft(2, '0')}:${seconds.value.toString().padLeft(2, '0')}:${(milliseconds.value % 1000 ~/ 10).toString().padLeft(2, '0')}");
                });
          }
        },
      ),
    );
  }

  void contador() {
    timerMilliseconds ??= Timer.periodic(const Duration(milliseconds: 1), (Timer timer) {
      milliseconds.value == 999 ? milliseconds.value = 0 : milliseconds.value += 1 ;
    });
    timerSeconds ??= Timer.periodic(const Duration(seconds: 1), (Timer timer) {
      seconds.value == 59 ? seconds.value = 0 : seconds.value += 1;
    });
    timerMinutes ??= Timer.periodic(const Duration(minutes: 1), (Timer timer) {
      minutes.value += 1;
    });
  }
}