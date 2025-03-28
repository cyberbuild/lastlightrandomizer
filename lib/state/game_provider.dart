import 'package:flutter/foundation.dart';
import 'package:lastlightrandomizer/models/game_setup.dart';
import 'package:lastlightrandomizer/models/planet.dart';
import 'package:lastlightrandomizer/models/ring.dart';

/// GameProvider manages the state of the Last Light Randomizer game
/// using the ChangeNotifier pattern for Flutter's Provider system.
/// 
/// It handles:
/// - Tracking the current player count
/// - Managing the game setup state
/// - Regenerating random planet configurations
class GameProvider extends ChangeNotifier {
  /// The current number of players (2-8)
  int _playerCount = 2;
  
  /// The current game setup, which manages rings and planets
  late GameSetup _gameSetup;
  
  /// Whether a game setup has been generated
  bool _isSetupGenerated = false;

  /// Creates a new GameProvider with an optional initial player count.
  GameProvider({int initialPlayerCount = 2}) {
    // Ensure initial player count is valid (now only 2-8)
    if (initialPlayerCount < 2 || initialPlayerCount > 8) {
      throw ArgumentError('Initial player count must be between 2 and 8');
    }
    
    _playerCount = initialPlayerCount;
    _gameSetup = GameSetup(playerCount: _playerCount);
  }
  
  /// Gets the current player count
  int get playerCount => _playerCount;
  
  /// Gets whether a setup has been generated
  bool get isSetupGenerated => _isSetupGenerated;
  
  /// Gets the inner ring from the current game setup
  Ring get innerRing => _gameSetup.innerRing;
  
  /// Gets the middle ring from the current game setup
  Ring get middleRing => _gameSetup.middleRing;
  
  /// Gets the outer ring from the current game setup
  Ring get outerRing => _gameSetup.outerRing;
  
  /// Gets all planets from all rings in the current setup
  List<Planet> get allPlanets {
    if (!_isSetupGenerated) return [];
    
    return [
      ...outerRing.getPlanets(),
      ...middleRing.getPlanets(),
      ...innerRing.getPlanets(),
    ];
  }
  
  /// Sets a new player count and resets the game setup.
  /// 
  /// @param count The new player count (2-8)
  void setPlayerCount(int count) {
    if (count < 2 || count > 8) {
      throw ArgumentError('Player count must be between 2 and 8');
    }
    
    if (count != _playerCount) {
      _playerCount = count;
      _gameSetup = GameSetup(playerCount: _playerCount);
      _isSetupGenerated = false;
      notifyListeners();
    }
  }
  
  /// Generates a new random planet distribution for the current player count
  void generateRandomSetup() {
    _gameSetup.generateRandomSetup();
    _isSetupGenerated = true;
    notifyListeners();
  }
}