import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:lastlightrandomizer/state/game_provider.dart';
import 'package:lastlightrandomizer/screens/game_board_screen.dart';

/// Screen for selecting the number of players (2-8) for the game setup.
/// 
/// This is the first screen users see when starting the app. It provides
/// buttons for each player count and a generate button to create the setup.
class PlayerSelectionScreen extends StatelessWidget {
  /// Creates a new player selection screen
  const PlayerSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Access our game provider to get and set player count
    final gameProvider = Provider.of<GameProvider>(context);
    final theme = Theme.of(context);
    
    return Scaffold(
      // Using surface instead of deprecated background property
      backgroundColor: theme.colorScheme.surface,
      appBar: AppBar(
        title: const Text('Last Light Randomizer'),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Column(
        children: [
          // Logo/Title area - can be replaced with a proper logo image later
          Expanded(
            flex: 2,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Planet logo illustration placeholder
                  Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      gradient: const RadialGradient(
                        colors: [Color(0xFF2196F3), Color(0xFF121212)],
                        radius: 0.8,
                      ),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          // Replace deprecated withOpacity with withValues for better precision
                          // Alpha 128 represents 50% opacity (0-255 scale)
                          color: Theme.of(context).colorScheme.primary.withValues(alpha: 128),
                          blurRadius: 15,
                          spreadRadius: 2,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'Select Number of Players',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ),
          
          // Player count selection buttons - using a more compact layout
          Expanded(
            flex: 3,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 16.0),
              child: GridView.count(
                crossAxisCount: 7,
                // Using a wider aspect ratio for more naturally sized buttons
                childAspectRatio: 1.2,
                mainAxisSpacing: 16.0,
                crossAxisSpacing: 16.0,
                children: List.generate(7, (index) {
                  // Player counts from 2-8
                  final playerCount = index + 2;
                  final isSelected = playerCount == gameProvider.playerCount;
                  
                  return PlayerCountButton(
                    playerCount: playerCount,
                    isSelected: isSelected,
                    onTap: () => gameProvider.setPlayerCount(playerCount),
                  );
                }),
              ),
            ),
          ),
          
          // Generate button with enhanced visibility
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: ElevatedButton.icon(
              onPressed: () {
                // Generate the random setup and navigate to the game board
                gameProvider.generateRandomSetup();
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const GameBoardScreen()),
                );
              },
              icon: const Icon(
                Icons.play_arrow,
                size: 28.0,
                // Ensuring icon has sufficient contrast
                color: Colors.white, 
              ),
              label: const Text(
                'Generate Game',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  // Ensuring text has sufficient contrast
                  color: Colors.white,
                ),
              ),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                // Using a more saturated color to ensure button stands out
                backgroundColor: theme.colorScheme.primary,
                // Adding elevation for better visibility
                elevation: 4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Custom button for selecting the player count.
/// 
/// Shows a circular button with the player count number inside.
/// When selected, it's highlighted with the primary theme color.
class PlayerCountButton extends StatelessWidget {
  /// The number of players this button represents (2-8)
  final int playerCount;
  
  /// Whether this button is currently selected
  final bool isSelected;
  
  /// Callback function called when the button is tapped
  final VoidCallback onTap;

  /// Creates a new player count selection button
  const PlayerCountButton({
    super.key,
    required this.playerCount,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        // Adding constraints to limit maximum size of buttons
        // regardless of screen size to avoid excessive scaling
        constraints: const BoxConstraints(
          maxWidth: 20,
          maxHeight: 20,
        ),
        decoration: BoxDecoration(
          // Using rounded rectangle instead of circle for a more modern look
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.circular(12),
          // Different styling based on selection state
          color: isSelected 
              ? theme.colorScheme.primary 
              // Replace deprecated withOpacity with withValues
              // Alpha 51 represents 20% opacity (0-255 scale)
              : theme.colorScheme.surface.withValues(alpha: 51),
          border: Border.all(
            color: isSelected 
                ? theme.colorScheme.primary 
                // Replace deprecated withOpacity with withValues
                // Alpha 51 represents 20% opacity (0-255 scale)
                : theme.colorScheme.onSurface.withValues(alpha: 51),
            width: 2,
          ),
          // Reduced shadow effect for a cleaner look
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: theme.colorScheme.primary.withValues(alpha: 100),
                    blurRadius: 4,
                    spreadRadius: 0.5,
                  ),
                ]
              : [],
        ),
        child: Center(
          child: Text(
            playerCount.toString(),
            style: TextStyle(
              // Slightly smaller font size for better proportions
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: isSelected ? Colors.white : theme.colorScheme.onSurface,
            ),
          ),
        ),
      ),
    );
  }
}