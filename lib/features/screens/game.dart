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
          onPointerMove: GameController.to.handlePointerMove,
          onPointerDown: GameController.to.handlePointerDown,
          onPointerUp: GameController.to.handlePointerUp,
          onPointerCancel: GameController.to.handlePointerCancel,
          child: Obx(() {
            String header = "Tap to Play!";
            if (GameController.to.isPlaying) {
              header = GameController.to.seconds.toString();
            }
            return Stack(
              children: [
                Align(
                  alignment: Alignment.topCenter,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 75),
                    child: Text(header, style: Get.textTheme.headlineLarge),
                  ),
                ),
                for (var tap in GameController.to.taps.asMap().entries)
                  Positioned(
                    left: tap.value.position.dx - 50,
                    top: tap.value.position.dy - 50,
                    child: Tap(
                        key: ValueKey(tap.value.id),
                        state: GameController.to.selectedIndex == tap.key
                            ? TapState.success
                            : GameController.to.tapState),
                  ),
              ],
            );
          }),
        ),
      ),
    );
  }
}
