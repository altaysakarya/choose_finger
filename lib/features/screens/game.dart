import 'package:choose_game/core/controllers/game_controller.dart';
import 'package:choose_game/features/components/linear_background.dart';
import 'package:choose_game/features/components/tap.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class GameScreen extends StatefulWidget {
  static const String routeName = '/game';
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  List<int> seconds = [5, 10, 15];

  @override
  Widget build(BuildContext context) {
    if (!GameController.isRegistered) {
      GameController.put();
    }

    return Scaffold(
      body: LinearBackground(
        child: Listener(
          behavior: HitTestBehavior.translucent,
          onPointerMove: (event) {
            GameController.to.handlePointerMove(event);
          },
          onPointerDown: (event) {
            GameController.to.handlePointerDown(event);
          },
          onPointerUp: (event) {
            GameController.to.handlePointerUp(event);
          },
          onPointerCancel: (event) {
            GameController.to.handlePointerCancel(event);
          },
          child: Obx(() => Stack(
                children: [
                  Align(
                    alignment: Alignment.topCenter,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 75),
                      child: Text(
                          GameController.to.isPlaying
                              ? "${GameController.to.seconds}"
                              : "Tap To Play!",
                          style: Get.textTheme.headlineLarge),
                    ),
                  ),
                  for (int i = 0; i < GameController.to.taps.length; i++)
                    Positioned(
                      left: GameController.to.taps[i].position.dx - 50,
                      top: GameController.to.taps[i].position.dy - 50,
                      child: Tap(
                        key: ValueKey(GameController.to.taps[i].id),
                        state: GameController.to.selectedIndex == i
                            ? TapState.success
                            : GameController.to.tapState,
                      ),
                    ),
                ],
              )),
        ),
      ),
    );
  }
}
