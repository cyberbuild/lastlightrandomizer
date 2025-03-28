import 'package:flutter_test/flutter_test.dart';
import 'package:lastlightrandomizer/models/ring.dart';
import 'package:lastlightrandomizer/models/planet.dart';
import 'dart:math' as math;

void main() {
  group('Ring Tests', () {
    late Ring ring;
    late List<Planet> testPlanets;

    setUp(() {
      ring = Ring(type: RingType.outer, maxPlanets: 12);
      testPlanets = [
        const Planet(id: 'test1', size: PlanetSize.small, colors: [PlanetColor.blue]),
        const Planet(id: 'test2', size: PlanetSize.medium, colors: [PlanetColor.green]),
        const Planet(id: 'test3', size: PlanetSize.large, colors: [PlanetColor.red]),
      ];
    });

    test('initializes with correct properties', () {
      expect(ring.type, RingType.outer);
      expect(ring.maxPlanets, 12);
      expect(ring.planets, isEmpty);
    });

    test('places planets correctly', () {
      ring.placePlanets(testPlanets);
      expect(ring.getPlanets().length, 3);
      expect(ring.getPlanets(), testPlanets);
    });

    test('throws error when placing too many planets', () {
      // Can't use const with string interpolation, so using non-const constructor here
      final tooManyPlanets = List.generate(
        13,
        (i) => Planet(id: 'p$i', size: PlanetSize.small, colors: const [PlanetColor.blue])
      );

      expect(
        () => ring.placePlanets(tooManyPlanets),
        throwsArgumentError
      );
    });

    test('calculates planet positions correctly', () {
      ring = Ring(type: RingType.outer, maxPlanets: 4);
      final planets = [
        const Planet(id: 'p1', size: PlanetSize.small, colors: [PlanetColor.blue]),
        const Planet(id: 'p2', size: PlanetSize.small, colors: [PlanetColor.green]),
      ];
      ring.placePlanets(planets);

      final positions = ring.getPlanetPositions();
      expect(positions.length, 2);
      
      // For 4 max planets, positions should be at 0 and pi/2 (quarter circle)
      expect(positions[0], closeTo(0, 0.001));
      expect(positions[1], closeTo(math.pi/2, 0.001));
    });

    test('returns empty positions for empty ring', () {
      expect(ring.getPlanetPositions(), isEmpty);
    });

    test('returns unmodifiable planet list', () {
      ring.placePlanets(testPlanets);
      final planets = ring.getPlanets();
      expect(
        () => planets.add(
          const Planet(id: 'test4', size: PlanetSize.small, colors: [PlanetColor.blue])
        ),
        throwsUnsupportedError
      );
    });
  });
}