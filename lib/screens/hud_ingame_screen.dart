import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rx_notifier/rx_notifier.dart';
import '../blocs/chronometer_bloc.dart';
import '../blocs/points_bloc.dart';
import '../time_beater.dart';

class HudIngame extends StatefulWidget {
  final TimeBeater game;

  const HudIngame(this.game, {super.key}) : super ();

  @override
  State<HudIngame> createState() => _HudIngameState();
}

class _HudIngameState extends State<HudIngame> {
  late TimeBeater game;
  final points = RxNotifier<int?>(0);

  @override
  void initState() {
    super.initState();
    game = widget.game; // Atribua o valor de widget.game à variável myGame no initState
  }


  final milliseconds = RxNotifier<int>(0);
  final seconds = RxNotifier<int>(0);
  final minutes = RxNotifier<int>(0);
  final hasReseted = RxNotifier<bool>(false);
  Timer? timerMilliseconds;
  Timer? timerSeconds;
  Timer? timerMinutes;

  @override
  void dispose() {
    timerMilliseconds?.cancel();
    timerSeconds?.cancel();
    timerMinutes?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.only(
          left: 180,
          right: 120,
          top: 15,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: [
                BlocBuilder<PointCounterBloc, PointCounterState> (
                  builder: (context, state) {
                    if (state is AddPointCounter) {
                      state.points != null ?  points.value = state.points : 0;
                      return _buildPointsCounter();
                    } else if (state is ResetPointCounter) {
                      return _buildPointsCounter();
                    } else {
                      return _buildPointsCounter();
                    }
                  },
                ),
              ],
            ),
            Column(
              children: [
                BlocBuilder<ChronometerBloc, ChronometerState> (
                  builder: (context, state) {
                    if (state is ResetChronometer) {
                      hasReseted.value = true;
                      _resetTimer(state);
                      return _buildTimerText(state);
                    } else if (state is RunningChronometer) {
                      _startTimer(state);
                      return _buildTimerText(state);
                    } else if (state is PauseChronometer) {
                      _pauseTimer();
                      return _buildTimerText(state);
                    } else {
                      return const Text("");
                    }
                  },
                ),
              ],
            ),
          ],
        ),
    );
  }

  void _startTimer(state) {
    timerMilliseconds?.cancel();
    timerSeconds?.cancel();
    timerMinutes?.cancel();
    if (game.gameHasReseted) {
      state.milliseconds = 0;
      state.seconds = 0;
      state.minutes = 0;
      milliseconds.value = 0;
      seconds.value = 0;
      minutes.value = 0;
      game.gameHasReseted = false;
      //hasReseted.value = false;
    }
    timerMilliseconds = Timer.periodic(const Duration(milliseconds: 1), (Timer timer) {
      milliseconds.value == 999 ? milliseconds.value = 0 : milliseconds.value += 1 ;
      state.milliseconds = milliseconds.value;
    });
    timerSeconds = Timer.periodic(const Duration(seconds: 1), (Timer timer) {
      seconds.value == 59 ? seconds.value = 0 : seconds.value += 1;
      state.seconds = seconds.value;
    });
    timerMinutes = Timer.periodic(const Duration(minutes: 1), (Timer timer) {
      minutes.value += 1;
      state.minutes = minutes.value;
    });
  }

  void _pauseTimer() {
    timerMilliseconds?.cancel();
    timerSeconds?.cancel();
    timerMinutes?.cancel();
    milliseconds.value = milliseconds.value;
    seconds.value = seconds.value;
    minutes.value = minutes.value;
    BlocProvider.of<ChronometerBloc>(context).emit(PauseChronometer(
      milliseconds: milliseconds.value,
      seconds: seconds.value,
      minutes: minutes.value,
    ));
  }

  void _resetTimer(state) {
    timerMilliseconds?.cancel();
    timerSeconds?.cancel();
    timerMinutes?.cancel();
  }

  Widget _buildTimerText(state) {
    return RxBuilder(
      builder: (context) {
        return Text(
          "${minutes.value.toString().padLeft(2, '0')}:${seconds.value.toString().padLeft(2, '0')}:${(milliseconds.value % 1000 ~/ 10).toString().padLeft(2, '0')}",
          style: const TextStyle(
            fontSize: 40,
          ),
        );
      },
    );
  }

  Widget _buildPointsCounter() {
    return RxBuilder(
        builder: (context) {
          return Row(
            children: [
              Image.asset(
                'assets/images/Items/Fruits/AppleIcon.png',
                height: 32,
                fit: BoxFit.cover,
              ),
              const SizedBox(width: 12.0),
              Text(
              "${points.value}",
                style: const TextStyle(
                  fontSize: 42,
                ),
              )
            ],
          );
        },
    );
  }
}