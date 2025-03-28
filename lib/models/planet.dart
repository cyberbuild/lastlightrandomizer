/// Represents the size categories for planets in the game
enum PlanetSize { 
  /// Small planets (approx. 30px diameter in UI)
  small, 
  
  /// Medium planets (approx. 50px diameter in UI)
  medium, 
  
  /// Large planets (approx. 70px diameter in UI)
  large 
}

/// Represents the possible colors for planets in the game
enum PlanetColor { 
  /// Blue color (typically associated with water/ice planets)
  blue, 
  
  /// Green color (typically associated with vegetation/life)
  green, 
  
  /// Red color (typically associated with hot/desert planets)
  red, 
  
  /// Yellow color (typically associated with gas/energy planets)
  yellow 
}

/// Represents a planet in the Last Light Randomizer game.
/// 
/// Each planet has a unique ID, a size category, and one or more colors.
/// Some planets are designated as "special" (typically those with all four colors).
class Planet {
  /// Unique identifier for the planet
  final String id;
  
  /// Size category of the planet (small, medium, or large)
  final PlanetSize size;
  
  /// List of colors this planet possesses (1-4 colors)
  final List<PlanetColor> colors;
  
  /// Whether this is a special planet (the one with all 4 colors)
  final bool isSpecial;

  /// Creates a new Planet with the specified properties.
  /// 
  /// @param id Unique identifier for the planet
  /// @param size Size category (small, medium, or large)
  /// @param colors List of colors this planet possesses
  /// @param isSpecial Whether this is a special planet (defaults to false)
  const Planet({
    required this.id,
    required this.size,
    required this.colors,
    this.isSpecial = false,
  });

  /// Checks if this planet has a specific color.
  /// 
  /// @param color The color to check for
  /// @returns true if the planet has the specified color, false otherwise
  bool hasColor(PlanetColor color) => colors.contains(color);
  
  @override
  String toString() => 'Planet $id (${size.name}, colors: ${colors.map((c) => c.name).join(", ")})';
}

/// Factory class to create all planets as defined in the Last Light game rules.
/// 
/// The game has a total of 28 planets:
/// - 9 small planets
/// - 11 medium planets (including 1 special planet with all 4 colors)
/// - 8 large planets
class PlanetFactory {
  /// Creates all planets as defined in the game rules.
  /// 
  /// @returns A list of all 28 planets used in the game
  static List<Planet> createAllPlanets() {
    return [
      // Small planets (9 total)
      Planet(id: 's1', size: PlanetSize.small, colors: [PlanetColor.blue]),
      Planet(id: 's2', size: PlanetSize.small, colors: [PlanetColor.blue, PlanetColor.green]),
      Planet(id: 's3', size: PlanetSize.small, colors: [PlanetColor.blue, PlanetColor.green, PlanetColor.yellow]),
      Planet(id: 's4', size: PlanetSize.small, colors: [PlanetColor.green]),
      Planet(id: 's5', size: PlanetSize.small, colors: [PlanetColor.green, PlanetColor.red]),
      Planet(id: 's6', size: PlanetSize.small, colors: [PlanetColor.green, PlanetColor.red]),
      Planet(id: 's7', size: PlanetSize.small, colors: [PlanetColor.green, PlanetColor.red]),
      Planet(id: 's8', size: PlanetSize.small, colors: [PlanetColor.green, PlanetColor.yellow]),
      Planet(id: 's9', size: PlanetSize.small, colors: [PlanetColor.yellow]),
      
      // Medium planets (11 total)
      Planet(id: 'm1', size: PlanetSize.medium, colors: [PlanetColor.blue, PlanetColor.green]),
      Planet(id: 'm2', size: PlanetSize.medium, colors: [PlanetColor.blue, PlanetColor.green, PlanetColor.red]),
      Planet(id: 'm3', size: PlanetSize.medium, colors: [PlanetColor.blue, PlanetColor.green, PlanetColor.red]),
      Planet(id: 'm4', size: PlanetSize.medium, colors: [PlanetColor.blue, PlanetColor.green, PlanetColor.red]),
      
      // Special planet (medium size with all 4 colors)
      Planet(
        id: 'm5', 
        size: PlanetSize.medium, 
        colors: [PlanetColor.blue, PlanetColor.green, PlanetColor.red, PlanetColor.yellow], 
        isSpecial: true
      ),
      
      Planet(id: 'm6', size: PlanetSize.medium, colors: [PlanetColor.blue, PlanetColor.yellow]),
      Planet(id: 'm7', size: PlanetSize.medium, colors: [PlanetColor.blue, PlanetColor.yellow]),
      Planet(id: 'm8', size: PlanetSize.medium, colors: [PlanetColor.green, PlanetColor.yellow]),
      Planet(id: 'm9', size: PlanetSize.medium, colors: [PlanetColor.green, PlanetColor.yellow]),
      Planet(id: 'm10', size: PlanetSize.medium, colors: [PlanetColor.green, PlanetColor.yellow]),
      Planet(id: 'm11', size: PlanetSize.medium, colors: [PlanetColor.red, PlanetColor.yellow]),
      
      // Large planets (8 total)
      Planet(id: 'l1', size: PlanetSize.large, colors: [PlanetColor.blue, PlanetColor.green]),
      Planet(id: 'l2', size: PlanetSize.large, colors: [PlanetColor.blue, PlanetColor.green]),
      Planet(id: 'l3', size: PlanetSize.large, colors: [PlanetColor.blue, PlanetColor.green, PlanetColor.red]),
      Planet(id: 'l4', size: PlanetSize.large, colors: [PlanetColor.blue, PlanetColor.green, PlanetColor.yellow]),
      Planet(id: 'l5', size: PlanetSize.large, colors: [PlanetColor.blue, PlanetColor.red]),
      Planet(id: 'l6', size: PlanetSize.large, colors: [PlanetColor.blue, PlanetColor.yellow]),
      Planet(id: 'l7', size: PlanetSize.large, colors: [PlanetColor.green, PlanetColor.red, PlanetColor.yellow]),
      Planet(id: 'l8', size: PlanetSize.large, colors: [PlanetColor.green, PlanetColor.yellow]),
    ];
  }
}