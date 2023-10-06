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
  Timer? timer;

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
            // Exiba os valores do cronômetro quando ele estiver pausado
            return RxBuilder(
                builder: (context) {
                  iniciou.value = false;
                  return Text("${minutes.value.toString().padLeft(2, '0')}:${seconds.value.toString().padLeft(2, '0')}:${(milliseconds.value % 1000 ~/ 10).toString().padLeft(2, '0')}");
                });;
          } else if (state is ResetChronometer) {
            // Exiba os valores do cronômetro quando ele estiver zerado
            return RxBuilder(
                builder: (context) {
                  iniciou.value = false;
                  return Text("${minutes.value.toString().padLeft(2, '0')}:${seconds.value.toString().padLeft(2, '0')}:${(milliseconds.value % 1000 ~/ 10).toString().padLeft(2, '0')}");
                });;
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
    throw UnimplementedError();
  }

  void contador() {
    Timer.periodic(const Duration(milliseconds: 1), (Timer timer) {
      milliseconds.value == 999 ? milliseconds.value = 0 : milliseconds.value += 1 ;
      });
    Timer.periodic(const Duration(seconds: 1), (Timer timer) {
      seconds.value == 59 ? seconds.value = 0 : seconds.value += 1;
    });
    Timer.periodic(const Duration(minutes: 1), (Timer timer) {
      minutes.value += 1;
    });
  }
}