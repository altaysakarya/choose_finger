import 'package:choose_game/features/screens/game.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(const Main());
}

class Main extends StatelessWidget {
  const Main({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      theme: ThemeData(
          brightness: Brightness.dark,
          textTheme: GoogleFonts.poppinsTextTheme()),
      initialRoute: GameScreen.routeName,
      debugShowCheckedModeBanner: false,
      getPages: [
        GetPage(name: GameScreen.routeName, page: () => GameScreen()),
      ],
    );
  }
}
