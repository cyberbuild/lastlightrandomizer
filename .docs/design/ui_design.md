# Last Light Randomizer Mobile UI Design (Flutter)

## Overview
The Last Light Randomizer is a Flutter mobile application that displays a color-coded circle with three rings, where planets are randomly placed based on player count. The UI consists of two main screens:

1. **Player Selection Screen**
2. **Game Board Screen**

## Technology Stack
- Framework: Flutter/Dart
- State Management: Provider/Riverpod
- Custom Painting: CustomPainter for rings and planets

## Color Scheme
- **Outer Ring**: Green (Color(0xFF4CAF50))
- **Middle Ring**: Blue (Color(0xFF2196F3))
- **Inner Ring**: Pink (Color(0xFFE91E63))
- **Background**: Dark space-themed (Color(0xFF121212))
- **Text and UI Elements**: White (Color(0xFFFFFFFF)) and Light Gray (Color(0xFFE0E0E0))

## Player Selection Screen

```
┌─────────────────────────────────────┐
│                                     │
│         LAST LIGHT RANDOMIZER       │
│                                     │
│      [Planet Logo Illustration]     │
│                                     │
│       Select Number of Players      │
│                                     │
│     ┌───┐ ┌───┐ ┌───┐ ┌───┐        │
│     │ 1 │ │ 2 │ │ 3 │ │ 4 │        │
│     └───┘ └───┘ └───┘ └───┘        │
│                                     │
│     ┌───┐ ┌───┐ ┌───┐ ┌───┐        │
│     │ 5 │ │ 6 │ │ 7 │ │ 8 │        │
│     └───┘ └───┘ └───┘ └───┘        │
│                                     │
│          [Generate Button]          │
│                                     │
└─────────────────────────────────────┘
```

### Flutter Implementation Details:
- Use `GridView.count` for player count buttons
- Material Design elevated buttons with custom styling
- Responsive layout using `LayoutBuilder`
- Animated transitions using `Hero` widgets

## Game Board Screen

```
┌─────────────────────────────────────┐
│                                     │
│         LAST LIGHT RANDOMIZER       │
│                                     │
│               [Menu]                │
│                                     │
│    ┌───────────────────────────┐    │
│    │      [CustomPainter]      │    │
│    │     Three Ring System     │    │
│    │    with Planet Objects    │    │
│    │                           │    │
│    └───────────────────────────┘    │
│                                     │
│         [Regenerate Button]         │
│                                     │
│        [Back to Setup Button]       │
│                                     │
└─────────────────────────────────────┘
```

### Flutter Implementation Details:
- Use `CustomPainter` for drawing rings and planets
- `Stack` widget for layering UI elements
- `Transform` for planet rotations
- `GestureDetector` for planet interactions

### Ring System Implementation:
```dart
class RingsPainter extends CustomPainter {
  // Draws three concentric rings with different colors
  // Planets are positioned using math.cos and math.sin
  // for proper circular placement
}
```

## Planet Visualization
Implemented using `CustomPainter`:
- **Small Planets**: 30.0 logical pixels diameter
- **Medium Planets**: 50.0 logical pixels diameter
- **Large Planets**: 70.0 logical pixels diameter

Planet color sections implementation:
```dart
void drawPlanet(Canvas canvas, Planet planet) {
  // Draw circular segments for each color
  // Use Path and Paint objects for complex shapes
  // Apply gradients for better visual appeal
}
```

## Responsive Design
- Use `MediaQuery` to adapt to different screen sizes
- `LayoutBuilder` for responsive widget sizing
- `AspectRatio` to maintain circular shape
- `FittedBox` for content scaling

## Animations
Use Flutter's animation framework:
- `AnimationController` for managing animations
- `Tween` for ring rotation
- `Hero` animations between screens
- `AnimatedBuilder` for continuous animations

## Accessibility
Flutter accessibility features:
- Semantic labels for all interactive elements
- Large touch targets (minimum 48x48 logical pixels)
- High contrast colors
- Support for screen readers using `Semantics` widget
- `textScaleFactor` support for adjustable text sizes