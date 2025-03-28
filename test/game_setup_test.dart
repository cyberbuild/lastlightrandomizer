import 'package:flutter_test/flutter_test.dart';
import 'package:lastlightrandomizer/models/game_setup.dart';
import 'package:lastlightrandomizer/models/planet.dart';
import 'package:lastlightrandomizer/models/ring.dart';
import 'dart:math';

void main() {
  group('GameSetup Tests', () {
    late GameSetup gameSetup;
    late Random mockRandom;

    setUp(() {
      // Use a seeded random for reproducible tests
      mockRandom = Random(42);
      gameSetup = GameSetup(playerCount: 5, random: mockRandom);
    });

    test('initializes with correct ring configurations', () {
      // Verify ring types are correct
      expect(gameSetup.innerRing.type, RingType.inner);
      expect(gameSetup.middleRing.type, RingType.middle);
      expect(gameSetup.outerRing.type, RingType.outer);
      
      // Verify max planets per ring matches the player count config
      expect(gameSetup.innerRing.maxPlanets, 4);
      expect(gameSetup.middleRing.maxPlanets, 8);
      expect(gameSetup.outerRing.maxPlanets, 7);
    });
    
    test('initializes with correct ring colors', () {
      expect(gameSetup.innerRing.color, RingColors.innerRingColor);
      expect(gameSetup.middleRing.color, RingColors.middleRingColor);
      expect(gameSetup.outerRing.color, RingColors.outerRingColor);
    });

    test('generates valid random setup for 5 players', () {
      gameSetup.generateRandomSetup();

      // Verify correct number of planets in each ring
      expect(gameSetup.outerRing.getPlanets().length, 7);
      expect(gameSetup.middleRing.getPlanets().length, 8);
      expect(gameSetup.innerRing.getPlanets().length, 4);

      // Verify special planet is included in the setup
      final allPlanets = [
        ...gameSetup.outerRing.getPlanets(),
        ...gameSetup.middleRing.getPlanets(),
        ...gameSetup.innerRing.getPlanets(),
      ];
      
      expect(
        allPlanets.any((p) => p.isSpecial),
        true,
        reason: 'Special planet should be included in setup'
      );

      // Verify no duplicate planets
      final planetIds = allPlanets.map((p) => p.id).toSet();
      expect(planetIds.length, allPlanets.length,
        reason: 'Should not have duplicate planets'
      );
    });

    test('generates different setups on multiple runs', () {
      gameSetup.generateRandomSetup();
      final firstSetup = [
        ...gameSetup.outerRing.getPlanets(),
        ...gameSetup.middleRing.getPlanets(),
        ...gameSetup.innerRing.getPlanets(),
      ].map((p) => p.id).toList();

      // Create new setup with different seed
      final differentGameSetup = GameSetup(playerCount: 5, random: Random(123));
      differentGameSetup.generateRandomSetup();
      final secondSetup = [
        ...differentGameSetup.outerRing.getPlanets(),
        ...differentGameSetup.middleRing.getPlanets(),
        ...differentGameSetup.innerRing.getPlanets(),
      ].map((p) => p.id).toList();

      expect(firstSetup, isNot(equals(secondSetup)),
        reason: 'Different random seeds should produce different setups'
      );
    });

    test('handles minimum player count (1 player)', () {
      gameSetup = GameSetup(playerCount: 1, random: mockRandom);
      gameSetup.generateRandomSetup();

      expect(gameSetup.outerRing.getPlanets().length, 1);
      expect(gameSetup.middleRing.getPlanets().length, 3);
      expect(gameSetup.innerRing.getPlanets().length, 1);
      
      // Make sure we still have the special planet
      final allPlanets = [
        ...gameSetup.outerRing.getPlanets(),
        ...gameSetup.middleRing.getPlanets(),
        ...gameSetup.innerRing.getPlanets(),
      ];
      expect(allPlanets.any((p) => p.isSpecial), true);
    });

    test('handles maximum player count (8 players)', () {
      gameSetup = GameSetup(playerCount: 8, random: mockRandom);
      gameSetup.generateRandomSetup();

      expect(gameSetup.outerRing.getPlanets().length, 11);
      expect(gameSetup.middleRing.getPlanets().length, 10);
      expect(gameSetup.innerRing.getPlanets().length, 5);
    });

    test('throws error for invalid player count', () {
      expect(
        () => GameSetup(playerCount: 9),
        throwsArgumentError,
        reason: 'Should throw error for player count > 8'
      );

      expect(
        () => GameSetup(playerCount: 0),
        throwsArgumentError,
        reason: 'Should throw error for player count < 1'
      );
    });

    test('planet selection preserves planet properties', () {
      gameSetup.generateRandomSetup();
      
      // Check all planets in all rings
      for (final ring in [gameSetup.outerRing, gameSetup.middleRing, gameSetup.innerRing]) {
        for (final planet in ring.getPlanets()) {
          expect(planet.id, isNotEmpty);
          expect(planet.colors, isNotEmpty);
          expect(planet.size, isIn([PlanetSize.small, PlanetSize.medium, PlanetSize.large]));
        }
      }
    });
    
    test('selectRandomPlanets returns correct number of planets', () {
      final allPlanets = PlanetFactory.createAllPlanets();
      final selectedPlanets = gameSetup.selectRandomPlanets(10, allPlanets);
      expect(selectedPlanets.length, 10);
      
      // Verify no duplicates in selected planets
      final uniqueIds = selectedPlanets.map((p) => p.id).toSet();
      expect(uniqueIds.length, 10);
    });
    
    test('selectRandomPlanets throws when requesting too many planets', () {
      final planets = [
        // Adding const to indicate these Planet objects are immutable and to improve performance
        const Planet(id: 'p1', size: PlanetSize.small, colors: [PlanetColor.blue]),
        const Planet(id: 'p2', size: PlanetSize.small, colors: [PlanetColor.green]),
      ];
      
      expect(
        () => gameSetup.selectRandomPlanets(3, planets),
        throwsArgumentError
      );
    });
    
    test('verify all planet types are represented in larger setups', () {
      gameSetup = GameSetup(playerCount: 6, random: mockRandom);
      gameSetup.generateRandomSetup();
      
      final allPlanets = [
        ...gameSetup.outerRing.getPlanets(),
        ...gameSetup.middleRing.getPlanets(),
        ...gameSetup.innerRing.getPlanets(),
      ];
      
      // Check that we have at least one of each size
      final hasSmall = allPlanets.any((p) => p.size == PlanetSize.small);
      final hasMedium = allPlanets.any((p) => p.size == PlanetSize.medium);
      final hasLarge = allPlanets.any((p) => p.size == PlanetSize.large);
      
      expect(hasSmall, true, reason: 'Setup should include at least one small planet');
      expect(hasMedium, true, reason: 'Setup should include at least one medium planet');
      expect(hasLarge, true, reason: 'Setup should include at least one large planet');
      
      // Check that all colors are represented
      final hasBlue = allPlanets.any((p) => p.hasColor(PlanetColor.blue));
      final hasGreen = allPlanets.any((p) => p.hasColor(PlanetColor.green));
      final hasRed = allPlanets.any((p) => p.hasColor(PlanetColor.red));
      final hasYellow = allPlanets.any((p) => p.hasColor(PlanetColor.yellow));
      
      expect(hasBlue, true, reason: 'Setup should include at least one planet with blue');
      expect(hasGreen, true, reason: 'Setup should include at least one planet with green');
      expect(hasRed, true, reason: 'Setup should include at least one planet with red');
      expect(hasYellow, true, reason: 'Setup should include at least one planet with yellow');
    });
  });
}