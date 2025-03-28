import 'dart:math';
import 'package:lastlightrandomizer/models/planet.dart';
import 'package:lastlightrandomizer/models/ring.dart';
import 'package:lastlightrandomizer/models/game_config.dart';

/// GameSetup coordinates the creation and arrangement of planets on rings
/// based on the player count configuration.
///
/// This class:
/// - Manages the three rings (inner, middle, outer)
/// - Handles random planet selection
/// - Ensures the special planet is included
/// - Distributes planets according to game rules
class GameSetup {
  /// The number of players (2-8)
  final int playerCount;
  
  /// All available planets that can be used in the game
  final List<Planet> availablePlanets;
  
  /// The inner (smallest) ring of the game board
  late final Ring innerRing;
  
  /// The middle ring of the game board
  late final Ring middleRing;
  
  /// The outer (largest) ring of the game board
  late final Ring outerRing;
  
  /// Random number generator for planet selection
  final Random _random;

  /// Creates a new GameSetup for the specified player count.
  /// 
  /// @param playerCount The number of players (2-8)
  /// @param random Optional random number generator (facilitates testing)
  GameSetup({
    required this.playerCount,
    Random? random,
  }) : availablePlanets = PlanetFactory.createAllPlanets(),
       _random = random ?? Random() {
    // Validate player count (now only 2-8)
    if (playerCount < 2 || playerCount > 8) {
      throw ArgumentError(
        'Invalid player count: $playerCount. Must be between 2 and 8 inclusive.'
      );
    }
       
    // Initialize rings with the appropriate configurations
    final config = GameConfigManager.getConfigForPlayerCount(playerCount);
    
    // Initialize each ring with the proper type and maximum planet count for the given player configuration
    innerRing = Ring(type: RingType.inner, maxPlanets: config.innerRingCount);
    middleRing = Ring(type: RingType.middle, maxPlanets: config.middleRingCount);
    outerRing = Ring(type: RingType.outer, maxPlanets: config.outerRingCount);
  }

  /// Generates a random game setup based on player count.
  /// 
  /// This method:
  /// 1. Gets the correct configuration for the player count
  /// 2. Shuffles all available planets
  /// 3. Ensures the special planet (with all 4 colors) is included
  /// 4. Selects the appropriate number of random planets
  /// 5. Shuffles all selected planets to randomize the special planet's position
  /// 6. Distributes planets to each ring (outer → middle → inner)
  void generateRandomSetup() {
    // Get the specific configuration for this player count
    final playerConfig = GameConfigManager.getConfigForPlayerCount(playerCount);
    
    // Create a shuffled copy of all available planets to select from
    final shuffledPlanetPool = List<Planet>.from(availablePlanets)..shuffle(_random);
    
    // Always include the special planet (with all 4 colors) if it exists
    final specialPlanet = shuffledPlanetPool.firstWhere(
      (planet) => planet.isSpecial, 
      orElse: () => shuffledPlanetPool.first
    );
    shuffledPlanetPool.remove(specialPlanet);
    
    // Calculate how many additional planets we need beyond the special planet
    final remainingPlanetsNeeded = playerConfig.totalPlanets - 1;
    
    // Add randomly selected planets to our game set
    final randomPlanets = selectRandomPlanets(
      remainingPlanetsNeeded,
      shuffledPlanetPool
    );
    
    // Create the final planet list with the special planet included
    final selectedPlanetsForGame = <Planet>[specialPlanet, ...randomPlanets];
    
    // Shuffle the combined list to randomize the special planet's position
    // This ensures the special planet could end up in any ring
    selectedPlanetsForGame.shuffle(_random);

    // Distribute planets to rings from outer to inner (game board outside to center)
    
    // 1. Place planets in the outer ring first
    outerRing.placePlanets(selectedPlanetsForGame.take(playerConfig.outerRingCount).toList());
    selectedPlanetsForGame.removeRange(0, playerConfig.outerRingCount);

    // 2. Place planets in the middle ring next
    middleRing.placePlanets(selectedPlanetsForGame.take(playerConfig.middleRingCount).toList());
    selectedPlanetsForGame.removeRange(0, playerConfig.middleRingCount);

    // 3. Place remaining planets in the inner ring
    innerRing.placePlanets(selectedPlanetsForGame);
  }

  /// Selects a specified number of random planets from the given pool.
  /// 
  /// @param count The number of planets to select
  /// @param fromPool The pool of planets to select from
  /// @returns A list of randomly selected planets
  /// @throws ArgumentError if count is greater than the pool size
  List<Planet> selectRandomPlanets(int count, List<Planet> fromPool) {
    // Validate we have enough planets in the pool
    if (count > fromPool.length) {
      throw ArgumentError('Not enough planets in pool: requested $count but only ${fromPool.length} available');
    }

    // Create collections for tracking selected planets and available planets
    final selectedPlanets = <Planet>[];
    final availablePlanetPool = List<Planet>.from(fromPool);

    // Select random planets until we have enough or run out of options
    while (selectedPlanets.length < count && availablePlanetPool.isNotEmpty) {
      // Choose a random index from the remaining available planets
      final randomIndex = _random.nextInt(availablePlanetPool.length);
      
      // Add the selected planet to our result list
      selectedPlanets.add(availablePlanetPool[randomIndex]);
      
      // Remove the selected planet from the available pool to avoid duplicates
      availablePlanetPool.removeAt(randomIndex);
    }

    return selectedPlanets;
  }
}