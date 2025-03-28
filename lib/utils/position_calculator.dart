import 'dart:math';
import 'package:lastlightrandomizer/models/ring.dart';
import 'package:lastlightrandomizer/models/planet.dart';

/// A utility class for calculating UI positions of planets on rings.
/// 
/// This class handles the conversion from angular positions (radians) to 
/// screen coordinates (x, y) for rendering planets on circular rings.
class PositionCalculator {
  /// Scaling factor for inner ring: positioned at 30% of container radius
  static const double innerRingRadiusFactor = 0.3;
  
  /// Scaling factor for middle ring: positioned at 60% of container radius
  static const double middleRingRadiusFactor = 0.6;
  
  /// Scaling factor for outer ring: positioned at 90% of container radius
  static const double outerRingRadiusFactor = 0.9;
  
  /// Base size for planets as percentage of container size
  static const double basePlanetSizeFactor = 0.05; // 5% of container size
  
  /// Scaling factor for small planets relative to the base size
  static const double smallPlanetSizeFactor = 0.6;
  
  /// Scaling factor for medium planets relative to the base size
  static const double mediumPlanetSizeFactor = 1.0;
  
  /// Scaling factor for large planets relative to the base size
  static const double largePlanetSizeFactor = 1.4;

  /// Calculates the screen coordinates for a planet on a ring.
  /// 
  /// @param ringRadius The radius of the ring in logical pixels
  /// @param angle The angle in radians (0 to 2π) where the planet should be placed
  /// @param centerX The x-coordinate of the ring's center
  /// @param centerY The y-coordinate of the ring's center
  /// @returns A Point containing the (x,y) coordinates for the planet
  static Point<double> calculatePlanetPosition(
    double ringRadius, 
    double angle, 
    double centerX, 
    double centerY
  ) {
    final x = centerX + ringRadius * cos(angle);
    final y = centerY + ringRadius * sin(angle);
    return Point<double>(x, y);
  }

  /// Calculates screen positions for all planets on a ring.
  /// 
  /// @param ring The ring containing the planets
  /// @param ringRadius The radius of the ring in logical pixels
  /// @param centerX The x-coordinate of the ring's center
  /// @param centerY The y-coordinate of the ring's center
  /// @returns A list of Points containing the (x,y) coordinates for each planet
  static List<Point<double>> calculateRingPlanetPositions(
    Ring ring,
    double ringRadius,
    double centerX,
    double centerY
  ) {
    final anglePositions = ring.getPlanetPositions();
    return anglePositions.map((angle) => 
      calculatePlanetPosition(ringRadius, angle, centerX, centerY)
    ).toList();
  }
  
  /// Returns the appropriate ring radius based on the ring type and container size
  /// 
  /// @param ringType The type of ring (inner, middle, outer)
  /// @param containerSize The size of the container (width or height, whichever is smaller)
  /// @returns The appropriate radius for the ring in logical pixels
  static double getRingRadius(RingType ringType, double containerSize) {
    final baseRadius = containerSize / 2;
    
    switch (ringType) {
      case RingType.inner:
        return baseRadius * innerRingRadiusFactor;
      case RingType.middle:
        return baseRadius * middleRingRadiusFactor;
      case RingType.outer:
        return baseRadius * outerRingRadiusFactor;
    }
  }
  
  /// Calculates the appropriate size for a planet based on its size category and container size
  /// 
  /// @param planetSize The size category of the planet
  /// @param containerSize The size of the container (width or height, whichever is smaller)
  /// @returns The radius to use when rendering the planet
  static double getPlanetRadius(PlanetSize planetSize, double containerSize) {
    // Base size reference (5% of container size)
    final baseSize = containerSize * basePlanetSizeFactor; 
    
    switch (planetSize) {
      case PlanetSize.small:
        return baseSize * smallPlanetSizeFactor;
      case PlanetSize.medium:
        return baseSize * mediumPlanetSizeFactor;
      case PlanetSize.large:
        return baseSize * largePlanetSizeFactor;
    }
  }
}