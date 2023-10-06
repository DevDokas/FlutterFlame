import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

abstract class ChronometerEvent {
  bool isRunning;
  bool reset;

  ChronometerEvent({
    required this.isRunning,
    required this.reset

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
  PauseChronometerEvent() : super(
    isRunning: false,
    reset: false,
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


  ChronometerState({
    required this.isRunning,
    required this.reset,
  });
}

class RunningChronometer extends ChronometerState {
  RunningChronometer() : super(
    isRunning: true,
    reset: false,
  );
}

class PauseChronometer extends ChronometerState {
  PauseChronometer() : super(
    isRunning: false,
    reset: false,
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

    }
  }


  FutureOr<void> _pauseChronometer(PauseChronometerEvent event, Emitter<ChronometerState> emit) {

    if (state.isRunning) {

      emit(PauseChronometer());

    }

  }

  FutureOr<void> _resetChronometer(ResetChronometerEvent event, Emitter<ChronometerState> emit) {

    emit(ResetChronometer());

  }
}