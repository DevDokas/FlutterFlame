import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

abstract class PointCounterEvent {
  bool reset;
  int? points;

  PointCounterEvent({
    required this.reset,
    this.points,
  });
}

class AddPointCounterEvent extends PointCounterEvent {
  AddPointCounterEvent({
    int? points
  }) : super(
    points: points,
    reset: false,
  );
}

class ReloadPointCounterEvent extends PointCounterEvent {
  ReloadPointCounterEvent({
    int? points
  }) : super(
     points: points,
    reset: false,
  );
}

class ResetPointCounterEvent extends PointCounterEvent {
  ResetPointCounterEvent({
    int? points
}) : super(
    points: points,
    reset: true,
  );
}

abstract class PointCounterState {
  final bool reset;
  final int? points;

  PointCounterState({
    required this.reset,
    this.points,
  });
}

class AddPointCounter extends PointCounterState {

  AddPointCounter({
    int? points
  }) : super(
    points: points,
    reset: false,
  );
}

class ReloadPointCounter extends PointCounterState {

  ReloadPointCounter({
    int? points
  }) : super (
    points: points,
    reset: false,
  );

}

class ResetPointCounter extends PointCounterState {

  ResetPointCounter({
    int? points
}) : super(
    points: points,
    reset: true,
  );

}

class PointCounterBloc extends Bloc<PointCounterEvent, PointCounterState> {
  PointCounterBloc() : super(AddPointCounter()) {
    on<AddPointCounterEvent>(_addPoints);
    on<ReloadPointCounterEvent>(_reloadPoints);
    on<ResetPointCounterEvent>(_resetPoints);
  }

  void _addPoints(AddPointCounterEvent event, Emitter<PointCounterState> emit) {
    if (state is AddPointCounter) {
      final currentPoints = (state as AddPointCounter).points;
      final newPoints = (currentPoints ?? 0) + 1;
      emit(AddPointCounter(points: newPoints));
    }
  }

  FutureOr<void> _reloadPoints(ReloadPointCounterEvent event, Emitter<PointCounterState> emit) {
    emit(ReloadPointCounter());
  }

  void _resetPoints(ResetPointCounterEvent event, Emitter<PointCounterState> emit) {
    emit(AddPointCounter(points: 0));
  }

}