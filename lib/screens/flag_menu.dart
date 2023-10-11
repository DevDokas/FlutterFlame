import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:time_beater/blocs/chronometer_bloc.dart';
import 'package:time_beater/time_beater.dart';

class FlagMenu extends StatelessWidget {
  final TimeBeater game;

  const FlagMenu(this.game, {super.key});

  @override
  Widget build(BuildContext context) {
    final chronometerBloc = BlocProvider.of<ChronometerBloc>(context);
    final state = chronometerBloc.state;
    int? milliseconds = 0;
    int? seconds = 0;
    int? minutes = 0;

     if (state is PauseChronometer) {
      milliseconds = state.milliseconds;
      seconds = state.seconds;
      minutes = state.minutes;

      return Align(
        alignment: Alignment.center,
        child: Container(
          height: 300,
          width: 450,
          decoration: BoxDecoration(
              color: Colors.amber,
              borderRadius: BorderRadius.circular(10.0),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.black,
                  border: Border.all(color: Colors.blueGrey, width: 5),
                  borderRadius: BorderRadius.circular(10)
                ),
                child: Text(
                    "${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}:${milliseconds.toString().padLeft(3, '0')}",
                    style: const TextStyle(
                      fontSize: 44
                    ),
                ),
              ),
              const SizedBox(height: 24),
              TextButton(
                onPressed: () => _backToMainMenu(),
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.red), // Cor de fundo do botão
                  foregroundColor: MaterialStateProperty.all(Colors.white), // Cor do texto do botão
                  padding: MaterialStateProperty.all(EdgeInsets.symmetric(horizontal: 20, vertical: 10)), // Preenchimento do botão
                  shape: MaterialStateProperty.all(RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10), // Borda arredondada
                  )),
                ),
                child: Text("Voltar ao Menu"),
              )
            ],
          ),
        ),
      );
    } else {
      return Align(
        child: Text("${milliseconds}"),
      );
    }
  }

  _backToMainMenu() {
    game.overlays.remove(game.flagMenuOverlayIdentifier);
    game.overlays.add(game.mainMenuOverlayIdentifier);
  }

}