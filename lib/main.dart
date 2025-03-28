import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:lastlightrandomizer/state/game_provider.dart';
import 'package:lastlightrandomizer/screens/player_selection_screen.dart';

/// Entry point for the Last Light Randomizer application
void main() {
  runApp(const LastLightRandomizerApp());
}

/// Root widget for the Last Light Randomizer application
class LastLightRandomizerApp extends StatelessWidget {
  /// Creates a new instance of the Last Light Randomizer app
  const LastLightRandomizerApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Setup app with provider for state management
    return ChangeNotifierProvider(
      create: (context) => GameProvider(),
      child: MaterialApp(
        title: 'Last Light Randomizer',
        theme: ThemeData(
          // Dark theme that matches the space theme of the game
          brightness: Brightness.dark,
          // Using const for the entire ColorScheme improves performance
          colorScheme: const ColorScheme.dark(
            primary: Color(0xFFE91E63),      // Pink (inner ring color)
            secondary: Color(0xFF2196F3),    // Blue (middle ring color)
            tertiary: Color(0xFF4CAF50),     // Green (outer ring color)
            surface: Color(0xFF121212),      // Dark space background
          ),
          useMaterial3: true,
          // Set the scaffoldBackgroundColor to ensure consistency with our dark space theme
          scaffoldBackgroundColor: const Color(0xFF121212),
        ),
        // Use the player selection screen as the home screen
        home: const PlayerSelectionScreen(),
      ),
    );
  }
}