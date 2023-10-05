import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

abstract class ChronometerEvent {
  final bool isRunning;
  final int milliseconds;
  final int seconds;
  final int minutes;

  ChronometerEvent({
    required this.isRunning,
    required this.milliseconds,
    required this.seconds,
    required this.minutes,
});
}

class RunningChronometerEvent extends ChronometerEvent {
  RunningChronometerEvent()
      : super(
    isRunning: true,
    milliseconds: 0,
    seconds: 0,
    minutes: 0,
  );
}

class PauseChronometerEvent extends ChronometerEvent {
  PauseChronometerEvent({
    required bool isRunning,
    required int milliseconds,
    required int seconds,
    required int minutes,
  }) : super(
    isRunning: isRunning,
    milliseconds: milliseconds,
    seconds: seconds,
    minutes: minutes,
  );
}

class ResetChronometerEvent extends ChronometerEvent {
  ResetChronometerEvent()
      : super(
    isRunning: false,
    milliseconds: 0,
    seconds: 0,
    minutes: 0,
  );
}

abstract class ChronometerState {
  final bool isRunning;
  final int milliseconds;
  final int seconds;
  final int minutes;

  ChronometerState({
    required this.isRunning,
    required this.milliseconds,
    required this.seconds,
    required this.minutes,
  });
}

class RunningChronometer extends ChronometerState {
  RunningChronometer({
    required int milliseconds,
    required int seconds,
    required int minutes,
  }) : super(
    isRunning: true,
    milliseconds: milliseconds,
    seconds: seconds,
    minutes: minutes,
  );
}

class PauseChronometer extends ChronometerState {
  PauseChronometer({
    required int milliseconds,
    required int seconds,
    required int minutes,
  }) : super(
    isRunning: false,
    milliseconds: milliseconds,
    seconds: seconds,
    minutes: minutes,
  );
}

class ResetChronometer extends ChronometerState {
  ResetChronometer({
    required int milliseconds,
    required int seconds,
    required int minutes,
}) : super(
    isRunning: false,
    milliseconds: 0,
    seconds: 0,
    minutes: 0,
  );
}

class ChronometerBloc extends Bloc<ChronometerEvent, ChronometerState> {
  ChronometerBloc() : super(PauseChronometer(milliseconds: 0, seconds: 0, minutes: 0)) {
    on<RunningChronometerEvent>(_startChronometer);
  }

  /*FutureOr<void> _mapStartChronometerToState(RunningChronometerEvent event, Emitter<int> emit) {
    if (!event.isRunning) {
      int milliseconds = event.milliseconds;
      int seconds = event.seconds;
      int minutes = event.minutes;

      RunningChronometer(
        milliseconds: milliseconds,
        seconds: seconds,
        minutes: minutes,
      );

      while (true) {
        Future.delayed(Duration(milliseconds: 1)); // Aguarda 10ms (simulação de atualização)
        milliseconds += 1;

        // Verifica se os milissegundos atingiram 1000 para aumentar os segundos
        if (milliseconds >= 1000) {
          milliseconds = 0;
          seconds++;

          // Verifica se os segundos atingiram 60 para aumentar os minutos
          if (seconds >= 60) {
            seconds = 0;
            minutes++;
          }
        }

        emit(minutes);
        emit(seconds);
        emit(milliseconds);
        RunningChronometer(
          milliseconds: milliseconds,
          seconds: seconds,
          minutes: minutes,
        );
     }
    }
  }*/

/*  Stream<ChronometerState> _mapPauseChronometerToState(PauseChronometerEvent event) async* {
    if (event.isRunning) {
      // O cronômetro está em execução, pause-o
      int milliseconds = event.milliseconds;
      int seconds = event.seconds;
      int minutes = event.minutes;

      // Emita o estado de pausa com o tempo atual
      yield PauseChronometer(
        milliseconds: milliseconds,
        seconds: seconds,
        minutes: minutes,
      );
    }
  }

  Stream<ChronometerState> _mapResetGameToState(ResetChronometerEvent event) async* {
    yield ResetChronometer(
      milliseconds: 0,
      seconds: 0,
      minutes: 0,
    );
  }*/

  FutureOr<void> _startChronometer(RunningChronometerEvent event, Emitter<ChronometerState> emit) {

    if (!state.isRunning) {
      int milliseconds = event.milliseconds;
      int seconds = event.seconds;
      int minutes = event.minutes;

      print("OIOIOIOIOI");
      print(event.milliseconds);
      print(state.milliseconds);

      Future.delayed(const Duration(), () {

      });

      emit(RunningChronometer(
          milliseconds: milliseconds += 1,
          seconds: seconds,
          minutes: minutes
      ));
      print(state);
/*      Future.delayed(Duration(milliseconds: 1)); // Aguarda 10ms (simulação de atualização)
      milliseconds += 1;

      // Verifica se os milissegundos atingiram 1000 para aumentar os segundos
      if (milliseconds >= 1000) {
        milliseconds = 0;
        seconds++;

        // Verifica se os segundos atingiram 60 para aumentar os minutos
        if (seconds >= 60) {
          seconds = 0;
          minutes++;
        }
      }*/

/*      RunningChronometer(
        milliseconds: event.milliseconds,
        seconds: event.seconds,
        minutes: event.minutes,
      );*/

/*      while (true) {
        Future.delayed(Duration(milliseconds: 1)); // Aguarda 10ms (simulação de atualização)
        milliseconds += 1;

        // Verifica se os milissegundos atingiram 1000 para aumentar os segundos
        if (milliseconds >= 1000) {
          milliseconds = 0;
          seconds++;

          // Verifica se os segundos atingiram 60 para aumentar os minutos
          if (seconds >= 60) {
            seconds = 0;
            minutes++;
          }
        }

        RunningChronometer(
          milliseconds: event.milliseconds,
          seconds: event.seconds,
          minutes: event.minutes,
        );

        emit(state);
      }*/
    }
  }
}