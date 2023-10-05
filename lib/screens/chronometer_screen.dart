import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'package:time_beater/components/chronometer.dart';
import 'package:time_beater/screens/hud_ingame_screen.dart';

import '../blocs/chronometer_bloc.dart';

class ChronometerScreen extends StatelessWidget {
  final int milliseconds;
  final int seconds;
  final int minutes;

  ChronometerScreen({
    required this.milliseconds,
    required this.seconds,
    required this.minutes,
  });

  @override
  Widget build(BuildContext context) {

    return BlocBuilder<ChronometerBloc, ChronometerState>(
      builder: (context, state) {
        if (state is RunningChronometer) {
          // Exiba os valores do cronômetro enquanto ele estiver em execução
          return Text("${state.minutes}:${state.seconds}:${state.milliseconds}");
        } else if (state is PauseChronometer) {
          // Exiba os valores do cronômetro quando ele estiver pausado
          return Text("${state.minutes}:${state.seconds}:${state.milliseconds}");
        } else if (state is ResetChronometer) {
          // Exiba os valores do cronômetro quando ele estiver zerado
          return Text("${state.minutes}:${state.seconds}:${state.milliseconds}");
        } else {
          // Caso padrão: exiba algo quando o estado não for reconhecido
          return Text('Estado desconhecido');
        }
      },
    );
  }
}