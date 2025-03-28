import 'dart:math';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:lastlightrandomizer/state/game_provider.dart';
import 'package:lastlightrandomizer/models/ring.dart';
import 'package:lastlightrandomizer/models/planet.dart';
import 'package:lastlightrandomizer/utils/position_calculator.dart';

/// Screen that displays the game board with the three rings and planets.
/// 
/// This screen shows:
/// - Three colored concentric rings
/// - Planets positioned on each ring based on game setup
/// - Controls to regenerate the setup or go back to player selection
class GameBoardScreen extends StatelessWidget {
  /// Creates a new game board screen
  const GameBoardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Access our game provider to get the game setup state
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
          // Game board area
          Expanded(
            flex: 5,
            // Using const for this widget subtree improves performance
            // since these widgets don't change based on external state
            child: const Padding(
              padding: EdgeInsets.all(16.0),
              child: Center(
                child: AspectRatio(
                  aspectRatio: 1.0,
                  child: GameBoardView(),
                ),
              ),
            ),
          ),
          
          // Action buttons
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                // Regenerate button
                ElevatedButton.icon(
                  onPressed: () {
                    // Generate a new random setup with the same player count
                    gameProvider.generateRandomSetup();
                  },
                  icon: const Icon(Icons.refresh),
                  label: const Text('Regenerate'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                    backgroundColor: theme.colorScheme.secondary,
                  ),
                ),
                
                // Back button
                ElevatedButton.icon(
                  onPressed: () {
                    // Return to the player selection screen
                    Navigator.pop(context);
                  },
                  icon: const Icon(Icons.arrow_back),
                  label: const Text('Back to Setup'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                    // Using withValues instead of deprecated withOpacity for semi-transparent background
                    // Preserves RGB values while setting alpha to 128 (50%)
                    backgroundColor: theme.colorScheme.surface.withValues(
                      alpha: 128, // 50% opacity (0-255 scale)
                    ),
                  ),
                ),
              ],
            ),
          ),
          
          // Player count display
          Padding(
            padding: const EdgeInsets.only(bottom: 16.0),
            child: Text(
              '${gameProvider.playerCount} Players',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Widget that renders the game board with three concentric rings and planets.
/// 
/// This widget:
/// - Creates a layout based on available screen space
/// - Draws the three colored rings using RingsPainter
/// - Positions planets on each ring at their calculated positions
/// - Handles dynamic sizing for different screen dimensions
class GameBoardView extends StatelessWidget {
  /// Creates a new game board view
  const GameBoardView({super.key});
  
  @override
  Widget build(BuildContext context) {
    // Get game provider for access to rings and planets
    final gameProvider = Provider.of<GameProvider>(context);
    
    // Check if a setup has been generated, auto-generate if needed
    if (!gameProvider.isSetupGenerated) {
      gameProvider.generateRandomSetup();
    }
    
    return LayoutBuilder(
      builder: (context, constraints) {
        // Determine the size of the game board (use the smaller dimension)
        final boardSize = constraints.maxWidth < constraints.maxHeight 
            ? constraints.maxWidth 
            : constraints.maxHeight;
        
        // Center point of the board
        final centerX = boardSize / 2;
        final centerY = boardSize / 2;
        
        return CustomPaint(
          size: Size(boardSize, boardSize),
          painter: RingsPainter(
            innerRing: gameProvider.innerRing,
            middleRing: gameProvider.middleRing,
            outerRing: gameProvider.outerRing,
            containerSize: boardSize,
          ),
          child: Stack(
            children: [
              // Outer ring planets
              ...buildPlanetsForRing(
                gameProvider.outerRing,
                boardSize,
                centerX,
                centerY,
                RingType.outer,
              ),
              
              // Middle ring planets
              ...buildPlanetsForRing(
                gameProvider.middleRing,
                boardSize,
                centerX,
                centerY,
                RingType.middle,
              ),
              
              // Inner ring planets
              ...buildPlanetsForRing(
                gameProvider.innerRing,
                boardSize,
                centerX,
                centerY,
                RingType.inner,
              ),
            ],
          ),
        );
      },
    );
  }

  /// Builds positioned planet widgets for a specific ring
  /// 
  /// @param ring The ring containing the planets to position
  /// @param containerSize The size of the container in logical pixels
  /// @param centerX The x-coordinate of the board center
  /// @param centerY The y-coordinate of the board center
  /// @param ringType The type of ring (inner, middle, or outer)
  /// @returns A list of positioned planet widgets
  List<Widget> buildPlanetsForRing(
    Ring ring, 
    double containerSize, 
    double centerX, 
    double centerY, 
    RingType ringType,
  ) {
    // Get planet positions (in radians)
    final positions = ring.getPlanetPositions();
    
    // Early exit if no planets
    if (positions.isEmpty) return [];
    
    // Get planets from the ring
    final planets = ring.getPlanets();
    
    // Calculate the radius for this ring type
    final ringRadius = PositionCalculator.getRingRadius(ringType, containerSize);
    
    // Create a positioned widget for each planet
    final widgets = <Widget>[];
    
    for (var i = 0; i < planets.length; i++) {
      final planet = planets[i];
      final angle = positions[i];
      
      // Calculate planet position
      final position = PositionCalculator.calculatePlanetPosition(
        ringRadius, angle, centerX, centerY
      );
      
      // Calculate planet size
      final planetRadius = PositionCalculator.getPlanetRadius(planet.size, containerSize);
      
      // Create positioned planet widget
      widgets.add(
        Positioned(
          left: position.x - planetRadius,
          top: position.y - planetRadius,
          width: planetRadius * 2,
          height: planetRadius * 2,
          child: PlanetWidget(planet: planet),
        ),
      );
    }
    
    return widgets;
  }
}

/// Custom painter for drawing the three rings
class RingsPainter extends CustomPainter {
  /// The inner ring of the game board
  final Ring innerRing;
  
  /// The middle ring of the game board
  final Ring middleRing;
  
  /// The outer ring of the game board
  final Ring outerRing;
  
  /// The size of the container the rings are being drawn in
  final double containerSize;

  /// Create a new rings painter
  RingsPainter({
    required this.innerRing,
    required this.middleRing,
    required this.outerRing,
    required this.containerSize,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // Center point of the canvas
    final centerX = size.width / 2;
    final centerY = size.height / 2;
    
    // Get radii for each ring
    final outerRadius = PositionCalculator.getRingRadius(RingType.outer, containerSize);
    final middleRadius = PositionCalculator.getRingRadius(RingType.middle, containerSize);
    final innerRadius = PositionCalculator.getRingRadius(RingType.inner, containerSize);
    
    // Ring stroke width
    final strokeWidth = containerSize * 0.015;
    
    // Create paint objects for each ring
    final outerPaint = Paint()
      ..color = Color(outerRing.color)
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round
      ..isAntiAlias = true;
    
    final middlePaint = Paint()
      ..color = Color(middleRing.color)
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round
      ..isAntiAlias = true;
    
    final innerPaint = Paint()
      ..color = Color(innerRing.color)
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round
      ..isAntiAlias = true;
    
    // Draw each ring
    canvas.drawCircle(Offset(centerX, centerY), outerRadius, outerPaint);
    canvas.drawCircle(Offset(centerX, centerY), middleRadius, middlePaint);
    canvas.drawCircle(Offset(centerX, centerY), innerRadius, innerPaint);
  }

  @override
  bool shouldRepaint(covariant RingsPainter oldDelegate) {
    return innerRing != oldDelegate.innerRing ||
           middleRing != oldDelegate.middleRing ||
           outerRing != oldDelegate.outerRing ||
           containerSize != oldDelegate.containerSize;
  }
}

/// Widget that displays a planet with its colors
class PlanetWidget extends StatelessWidget {
  /// The planet to display
  final Planet planet;

  /// Creates a new planet widget
  const PlanetWidget({
    super.key,
    required this.planet,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Show planet details in a dialog
        showDialog(
          context: context,
          builder: (context) => PlanetDetailsDialog(planet: planet),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          // Special highlight for the special planet with all 4 colors
          boxShadow: planet.isSpecial
              ? [
                  BoxShadow(
                    // Using withValues instead of deprecated withOpacity
                    // Preserves RGB values while setting alpha to 204 (80%)
                    color: Colors.white.withValues(alpha: 204), // 80% opacity
                    blurRadius: 10,
                    spreadRadius: 2,
                  ),
                ]
              : null,
        ),
        child: CustomPaint(
          painter: PlanetPainter(planet: planet),
        ),
      ),
    );
  }
}

/// Custom painter for drawing a planet with its colors
class PlanetPainter extends CustomPainter {
  /// The planet to paint
  final Planet planet;

  /// Mathematical constant pi used for angle calculations
  static const double pi = 3.14159;
  
  /// Mathematical constant for a full circle in radians
  static const double fullCircleRadians = 2 * pi;

  /// Creates a new planet painter
  PlanetPainter({required this.planet});

  @override
  void paint(Canvas canvas, Size size) {
    final radius = size.width / 2;
    final center = Offset(radius, radius);
    
    // Number of colors in this planet
    final colorCount = planet.colors.length;
    
    if (colorCount == 1) {
      // For single-color planets, fill the entire circle
      final paint = Paint()
        ..color = _getPlanetColor(planet.colors.first)
        ..style = PaintingStyle.fill;
      
      canvas.drawCircle(center, radius, paint);
    } else {
      // For multi-color planets, divide the circle into segments
      final segmentAngle = fullCircleRadians / colorCount;
      
      for (var i = 0; i < colorCount; i++) {
        // Start drawing segments from the top (negative pi/2)
        final startAngle = i * segmentAngle - (pi / 2); 
        
        final paint = Paint()
          ..color = _getPlanetColor(planet.colors[i])
          ..style = PaintingStyle.fill;
        
        // Create a pie-shaped path for this color segment
        final path = Path()
          ..moveTo(center.dx, center.dy)
          ..lineTo(
            center.dx + radius * cos(startAngle),
            center.dy + radius * sin(startAngle)
          )
          ..arcTo(
            Rect.fromCircle(center: center, radius: radius),
            startAngle,
            segmentAngle,
            false
          )
          ..close();
        
        canvas.drawPath(path, paint);
      }
    }
    
    // Draw a border around the planet
    final borderPaint = Paint()
      // Using withValues instead of deprecated withOpacity
      // Preserves RGB values while setting alpha to 128 (50%)
      ..color = Colors.white.withValues(alpha: 128) // 50% opacity
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5;
    
    canvas.drawCircle(center, radius, borderPaint);
  }
  
  /// Converts a PlanetColor enum to an actual Color object
  Color _getPlanetColor(PlanetColor color) {
    switch (color) {
      case PlanetColor.blue:
        return Colors.blue.shade500;
      case PlanetColor.green:
        return Colors.green.shade500;
      case PlanetColor.red:
        return Colors.red.shade500;
      case PlanetColor.yellow:
        return Colors.amber.shade500;
    }
  }

  @override
  bool shouldRepaint(covariant PlanetPainter oldDelegate) {
    return planet != oldDelegate.planet;
  }
}

/// Dialog that displays planet details when a planet is tapped
class PlanetDetailsDialog extends StatelessWidget {
  /// The planet to display details for
  final Planet planet;

  /// Creates a new planet details dialog
  const PlanetDetailsDialog({
    super.key,
    required this.planet,
  });

  @override
  Widget build(BuildContext context) {
    final sizeText = planet.size.name.substring(0, 1).toUpperCase() + 
                    planet.size.name.substring(1);
    
    final colorNames = planet.colors.map((color) => 
      color.name.substring(0, 1).toUpperCase() + color.name.substring(1)
    ).toList();
    
    return AlertDialog(
      title: Text(
        planet.isSpecial ? 'Special Planet' : 'Planet Details',
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 8),
          
          // Planet visualization
          Center(
            child: SizedBox(
              width: 80,
              height: 80,
              child: CustomPaint(
                painter: PlanetPainter(planet: planet),
              ),
            ),
          ),
          
          const SizedBox(height: 16),
          
          // Planet size
          Text(
            'Size: $sizeText',
            style: const TextStyle(fontSize: 16),
          ),
          
          const SizedBox(height: 8),
          
          // Planet colors
          Text(
            'Colors: ${colorNames.join(", ")}',
            style: const TextStyle(fontSize: 16),
          ),
          
          // Special planet indicator
          if (planet.isSpecial) ...[
            const SizedBox(height: 16),
            const Text(
              '✨ This is the special planet with all four colors',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.amber,
              ),
            ),
          ],
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Close'),
        ),
      ],
    );
  }
}