import 'package:flutter_test/flutter_test.dart';
import 'package:lastlightrandomizer/state/game_provider.dart';

void main() {
  group('GameProvider Tests', () {
    late GameProvider provider;

    setUp(() {
      provider = GameProvider();
    });

    test('initializes with default player count', () {
      expect(provider.playerCount, 2);
      expect(provider.isSetupGenerated, false);
      expect(provider.allPlanets, isEmpty);
    });

    test('initializes with custom player count', () {
      provider = GameProvider(initialPlayerCount: 5);
      expect(provider.playerCount, 5);
    });

    test('throws error for invalid initial player count', () {
      expect(() => GameProvider(initialPlayerCount: 0), throwsArgumentError);
      expect(() => GameProvider(initialPlayerCount: 9), throwsArgumentError);
    });

    test('setPlayerCount updates player count', () {
      provider.setPlayerCount(4);
      expect(provider.playerCount, 4);
    });

    test('setPlayerCount throws error for invalid count', () {
      expect(() => provider.setPlayerCount(0), throwsArgumentError);
      expect(() => provider.setPlayerCount(9), throwsArgumentError);
    });

    test('generateRandomSetup populates planets and marks setup as generated', () {
      provider.generateRandomSetup();
      
      expect(provider.isSetupGenerated, true);
      expect(provider.allPlanets, isNotEmpty);
      expect(provider.innerRing.getPlanets(), isNotEmpty);
      expect(provider.middleRing.getPlanets(), isNotEmpty);
      expect(provider.outerRing.getPlanets(), isNotEmpty);
      
      // Verify correct planet counts for default 2-player game
      expect(provider.innerRing.getPlanets().length, 2);
      expect(provider.middleRing.getPlanets().length, 4);
      expect(provider.outerRing.getPlanets().length, 2);
    });

    test('changing player count resets setup state', () {
      provider.generateRandomSetup();
      expect(provider.isSetupGenerated, true);
      
      provider.setPlayerCount(3);
      expect(provider.isSetupGenerated, false);
      expect(provider.allPlanets, isEmpty);
    });
  });
}