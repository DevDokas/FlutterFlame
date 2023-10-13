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
  final hasReseted = RxNotifier<bool>(false);
  Timer? timer;

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: const Alignment(0.67, -0.95),
      child: BlocBuilder<ChronometerBloc, ChronometerState>(
        builder: (context, state) {
          if (state is ResetChronometer) {
            hasReseted.value = true;
            _resetTimer();
            return _buildTimerText();
          } else if (state is RunningChronometer) {
            if (!hasReseted.value) {
              _startTimer();
            }
            return _buildTimerText();
          } else if (state is PauseChronometer) {
            _pauseTimer();
            return _buildTimerText();
          } else {
            return const Text("00:00:00");
          }
        },
      ),
    );
  }

  void _startTimer() {
    timer?.cancel();
    if (hasReseted.value) {
      milliseconds.value = 0;
      seconds.value = 0;
      minutes.value = 0;
      hasReseted.value = false;
    }
    timer = Timer.periodic(const Duration(milliseconds: 1), (Timer timer) {
      milliseconds.value = (milliseconds.value + 1) % 1000;
      if (milliseconds.value == 0) {
        seconds.value = (seconds.value + 1);
        if (seconds.value >= 59) {
          seconds.value = 0;
          minutes.value += 1;
        }
      }
    });
  }

  void _pauseTimer() {
    timer?.cancel();
    BlocProvider.of<ChronometerBloc>(context).emit(PauseChronometer(
        milliseconds: milliseconds.value,
        seconds: seconds.value,
        minutes: minutes.value
    )
    );
  }

  void _resetTimer() {
    print('Passei pelo Reset');
    timer?.cancel();
  }

  Widget _buildTimerText() {
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
}