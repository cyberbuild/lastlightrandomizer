import 'package:lastlightrandomizer/models/planet.dart';

/// Represents one of the three ring types in the game
enum RingType { inner, middle, outer }

/// Maps ring types to their associated colors in ARGB format
class RingColors {
  /// Pink color for the inner ring (0xFFE91E63)
  static const innerRingColor = 0xFFE91E63;
  
  /// Blue color for the middle ring (0xFF2196F3)
  static const middleRingColor = 0xFF2196F3;
  
  /// Green color for the outer ring (0xFF4CAF50)
  static const outerRingColor = 0xFF4CAF50;
  
  /// Gets the appropriate color for a given ring type
  static int getColorForRingType(RingType type) {
    switch (type) {
      case RingType.inner:
        return innerRingColor;
      case RingType.middle:
        return middleRingColor;
      case RingType.outer:
        return outerRingColor;
    }
  }
}

/// A Ring represents one of the three concentric circles in the Last Light Randomizer game.
/// Each ring can hold a specific number of planets and maintains information about their
/// positions around the circle.
class Ring {
  /// The type of ring (inner, middle, or outer)
  final RingType type;
  
  /// The collection of planets currently placed on this ring
  final List<Planet> planets;
  
  /// The maximum number of planets this ring can hold based on player count
  final int maxPlanets;
  
  /// The color associated with this ring type
  final int color;

  /// Creates a new Ring with the specified type and capacity.
  /// 
  /// @param type The type of ring (inner, middle, or outer)
  /// @param maxPlanets The maximum number of planets this ring can hold
  /// @param planets Optional initial list of planets to place on the ring
  Ring({
    required this.type,
    required this.maxPlanets,
    List<Planet>? planets,
  }) : planets = planets ?? [],
       color = RingColors.getColorForRingType(type);

  /// Places a new collection of planets on this ring,
  /// replacing any planets that were previously there.
  /// 
  /// @param newPlanets The planets to place on this ring
  /// @throws ArgumentError if too many planets are provided
  void placePlanets(List<Planet> newPlanets) {
    // Ensure we don't exceed the maximum allowed planets for this ring
    if (newPlanets.length > maxPlanets) {
      throw ArgumentError('Too many planets for ${type.toString().split('.').last} ring: '
          '${newPlanets.length} provided, but maximum is $maxPlanets');
    }
    
    // Replace existing planets with the new ones
    planets.clear();
    planets.addAll(newPlanets);
  }

  /// Gets an unmodifiable view of the planets in this ring.
  /// 
  /// @returns An unmodifiable list of planets in this ring
  List<Planet> getPlanets() => List.unmodifiable(planets);

  /// Calculates the position angles (in radians) for each planet on the ring.
  /// 
  /// The positions are evenly distributed around the circle based on the maximum
  /// planet capacity of the ring, not just the current number of planets.
  /// This ensures consistent spacing regardless of how many planets are actually placed.
  /// 
  /// @returns A list of angle positions in radians (0 to 2π)
  List<double> getPlanetPositions() {
    // Return empty list if there are no planets
    if (planets.isEmpty) return [];
    
    // Calculate positions evenly around the circle
    final positions = <double>[];
    
    // Full circle (2π radians) divided by the maximum planets capacity
    // This ensures consistent spacing regardless of actual planet count
    final angleStepRadians = 2 * 3.14159 / maxPlanets; 
    
    // Calculate position for each planet
    for (var i = 0; i < planets.length; i++) {
      positions.add(i * angleStepRadians);
    }
    
    return positions;
  }
}