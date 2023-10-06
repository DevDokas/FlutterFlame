import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

abstract class ChronometerEvent {
  bool isRunning;

  ChronometerEvent({
    required this.isRunning,

});
}

class RunningChronometerEvent extends ChronometerEvent {
  RunningChronometerEvent()
      : super(
    isRunning: true,
  );
}

class PauseChronometerEvent extends ChronometerEvent {
  PauseChronometerEvent({
    required bool isRunning,
  }) : super(
    isRunning: isRunning,

  );
}

class ResetChronometerEvent extends ChronometerEvent {
  ResetChronometerEvent({
    required bool isRunning,
  })
      : super(
    isRunning: false,
  );
}

abstract class ChronometerState {
  final bool isRunning;


  ChronometerState({
    required this.isRunning,
  });
}

class RunningChronometer extends ChronometerState {
  RunningChronometer({
    required bool isRunning,
  }) : super(
    isRunning: true,
  );
}

class PauseChronometer extends ChronometerState {
  PauseChronometer({
    required bool isRunning,
  }) : super(
    isRunning: false,

  );
}

class ResetChronometer extends ChronometerState {
  ResetChronometer({
    required bool isRunning,
  }) : super(
    isRunning: false,

  );
}

class ChronometerBloc extends Bloc<ChronometerEvent, ChronometerState> {
  ChronometerBloc() : super(PauseChronometer(isRunning: false)) {
    on<RunningChronometerEvent>(_startChronometer);
  }

  FutureOr<void> _startChronometer(RunningChronometerEvent event, Emitter<ChronometerState> emit) {

    if (!state.isRunning) {

      Future.delayed(const Duration(), () {

      });

      emit(RunningChronometer(isRunning: true));

    }
  }
}