/// Configuration class for a ring setup based on player count.
/// 
/// This defines how many planets should be placed in each ring
/// for a specific player count.
class RingConfig {
  /// Number of planets to place in the outer ring
  final int outerRingCount;
  
  /// Number of planets to place in the middle ring
  final int middleRingCount;
  
  /// Number of planets to place in the inner ring
  final int innerRingCount;

  /// Creates a new ring configuration.
  const RingConfig({
    required this.outerRingCount,
    required this.middleRingCount,
    required this.innerRingCount,
  });

  /// Total number of planets required for this configuration
  int get totalPlanets => outerRingCount + middleRingCount + innerRingCount;
  
  @override
  String toString() => 'RingConfig(outer: $outerRingCount, middle: $middleRingCount, inner: $innerRingCount)';
}

/// Manages game configurations for different player counts.
/// 
/// This class stores the official Last Light Randomizer configurations
/// for planet distribution across rings based on player count.
class GameConfigManager {
  /// Map of player counts to their respective ring configurations
  /// 
  /// The key is the number of players (2-8)
  /// The value is the RingConfig specifying how many planets go in each ring
  static final Map<int, RingConfig> playerConfigurations = {
    // Configuration for 2 players: 8 planets total (2 outer, 4 middle, 2 inner)
    2: const RingConfig(outerRingCount: 2, middleRingCount: 4, innerRingCount: 2),
    
    // Configuration for 3 players: 10 planets total (3 outer, 4 middle, 3 inner)
    3: const RingConfig(outerRingCount: 3, middleRingCount: 4, innerRingCount: 3),
    
    // Configuration for 4 players: 15 planets total (6 outer, 6 middle, 3 inner)
    4: const RingConfig(outerRingCount: 6, middleRingCount: 6, innerRingCount: 3),
    
    // Configuration for 5 players: 19 planets total (7 outer, 8 middle, 4 inner)
    5: const RingConfig(outerRingCount: 7, middleRingCount: 8, innerRingCount: 4),
    
    // Configuration for 6 players: 25 planets total (12 outer, 8 middle, 5 inner)
    6: const RingConfig(outerRingCount: 12, middleRingCount: 8, innerRingCount: 5),
    
    // Configuration for 7-8 players: 26 planets total (11 outer, 10 middle, 5 inner)
    7: const RingConfig(outerRingCount: 11, middleRingCount: 10, innerRingCount: 5),
    8: const RingConfig(outerRingCount: 11, middleRingCount: 10, innerRingCount: 5),
  };

  /// Retrieves the appropriate ring configuration for the specified player count.
  /// 
  /// @param playerCount The number of players (2-8)
  /// @returns The ring configuration for the specified player count
  /// @throws ArgumentError if the player count is invalid (not 2-8)
  static RingConfig getConfigForPlayerCount(int playerCount) {
    // Validate the player count is within the supported range
    if (!playerConfigurations.containsKey(playerCount)) {
      throw ArgumentError(
        'Invalid player count: $playerCount. Must be between 2 and 8 inclusive.'
      );
    }
    
    return playerConfigurations[playerCount]!;
  }
}