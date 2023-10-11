import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

abstract class ChronometerEvent {
  bool isRunning;
  bool reset;
  int? milliseconds;
  int? seconds;
  int? minutes;

  ChronometerEvent({
    required this.isRunning,
    required this.reset,
    this.milliseconds,
    this.seconds,
    this.minutes,
});
}

class RunningChronometerEvent extends ChronometerEvent {
  RunningChronometerEvent()
      : super(
    isRunning: true,
    reset: false,
  );
}

class PauseChronometerEvent extends ChronometerEvent {
  PauseChronometerEvent({
    int? milliseconds,
    int? seconds,
    int? minutes,
  }) : super(
    isRunning: false,
    reset: false,
    milliseconds: milliseconds,
    seconds: seconds,
    minutes: minutes,
  );
}

class ResetChronometerEvent extends ChronometerEvent {
  ResetChronometerEvent()
      : super(
    isRunning: false,
    reset: true,
  );
}

abstract class ChronometerState {
  final bool isRunning;
  final bool reset;
  final int? milliseconds;
  final int? seconds;
  final int? minutes;

  ChronometerState({
    required this.isRunning,
    required this.reset,
    this.milliseconds,
    this.seconds,
    this.minutes,
  });
}

class RunningChronometer extends ChronometerState {
  RunningChronometer() : super(
    isRunning: true,
    reset: false,
  );
}

class PauseChronometer extends ChronometerState {

  PauseChronometer({
    int? milliseconds,
    int? seconds,
    int? minutes,
  }) : super(
    isRunning: false,
    reset: false,
    milliseconds: milliseconds,
    seconds: seconds,
    minutes: minutes,
  );
}

class ResetChronometer extends ChronometerState {
  ResetChronometer() : super(
    isRunning: false,
    reset: true,
  );
}

class ChronometerBloc extends Bloc<ChronometerEvent, ChronometerState> {
  ChronometerBloc() : super(PauseChronometer()) {
    on<RunningChronometerEvent>(_startChronometer);
    on<PauseChronometerEvent>(_pauseChronometer);
    on<ResetChronometerEvent>(_resetChronometer);
  }

  FutureOr<void> _startChronometer(RunningChronometerEvent event, Emitter<ChronometerState> emit) {

    if (!state.isRunning) {

      emit(RunningChronometer());
      print(state);

    }
  }


  FutureOr<void> _pauseChronometer(PauseChronometerEvent event, Emitter<ChronometerState> emit) {

    if (state.isRunning) {

      emit(PauseChronometer());
      print(state);
    }

  }

  FutureOr<void> _resetChronometer(ResetChronometerEvent event, Emitter<ChronometerState> emit) {

    emit(ResetChronometer());
    print(state);
  }

}