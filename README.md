# card_pulse_loader

[![pub package](https://img.shields.io/pub/v/card_pulse_loader.svg)](https://pub.dev/packages/card_pulse_loader)
[![license](https://img.shields.io/badge/license-MIT-blue.svg)](https://github.com/carmeljeeva/card_pulse_loader/blob/main/LICENSE)
[![Platform](https://img.shields.io/badge/platform-flutter%20%7C%20android%20%7C%20ios%20%7C%20web%20%7C%20macos%20%7C%20windows%20%7C%20linux-blue.svg)](https://pub.dev/packages/card_pulse_loader)

A high-performance Flutter package for **non-skeleton, optimistic card loading animations**. Instead of turning your UI into blank gray placeholder boxes, `card_pulse_loader` keeps your cached card content readable while providing elegant, futuristic visual feedback that live API updates are in progress.

---

## ✨ Features

- 🏃 **Border Runner (`BorderRunnerLoader`)**: A glowing neon laser beam that orbits continuously along the rounded perimeter of the card with a comet flare tip.
- ✨ **Gloss Sweep (`GlossSweepLoader`)**: A diagonal liquid-glass / holographic sheen sweep that reflects across the entire card surface.
- 📡 **Radar Scanner (`RadarScannerLoader`)**: A high-tech horizontal laser line sweeping vertically with a soft glowing trail.
- 🎯 **All-in-One (`CardPulseLoader`)**: Switch between `borderRunner`, `glossSweep`, `radarScan`, `breathingAura`, and `cyberCombo` seamlessly using the `CardLoadingStyle` enum.
- 🚀 **Zero Dependencies**: Pure Flutter Canvas API (`PathMetrics` & `ShaderMask`) running at 60/120 FPS.
- 🛡️ **Non-Blocking Touches**: Uses `IgnorePointer` on overlays so buttons, taps, and card interactions remain 100% responsive.
- 📱 **Multiplatform**: Supports Android, iOS, Web, macOS, Windows, and Linux out of the box.

---

## 📦 Installation

Add `card_pulse_loader` to your `pubspec.yaml`:

```yaml
dependencies:
  card_pulse_loader: ^1.0.0
```

Or install it via CLI:

```bash
flutter pub add card_pulse_loader
```

Import it:

```dart
import 'package:card_pulse_loader/card_pulse_loader.dart';
```

---

## 🚀 Quick Start

### 1. Border Runner Loader

```dart
BorderRunnerLoader(
  isLoading: isSyncingData, // bool
  borderRadius: 16.0,
  beamColor: const Color(0xFF00E5FF), // Neon cyan
  strokeWidth: 3.2,
  child: Card(
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
    child: const Padding(
      padding: EdgeInsets.all(20),
      child: Text('Your card content remains visible & interactive!'),
    ),
  ),
)
```

### 2. Gloss Sweep Loader

```dart
GlossSweepLoader(
  isLoading: isSyncingData,
  borderRadius: 16.0,
  shimmerColor: Colors.white,
  duration: const Duration(milliseconds: 1800),
  child: Container(
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
    ),
    child: YourCardWidget(),
  ),
)
```

### 3. All-in-One Switcher (`CardPulseLoader`)

```dart
CardPulseLoader(
  isLoading: isSyncingData,
  style: CardLoadingStyle.borderRunner, // or glossSweep, radarScan, cyberCombo
  borderRadius: 16.0,
  primaryColor: const Color(0xFF00E5FF),
  child: YourCardWidget(),
)
```

---

## ⚙️ Parameters

### `BorderRunnerLoader`

| Property | Type | Default | Description |
| :--- | :--- | :--- | :--- |
| `child` | `Widget` | *required* | The card/widget to wrap. |
| `isLoading` | `bool` | *required* | Toggles the laser beam animation. |
| `borderRadius` | `double` | `16.0` | Corner radius matching your card. |
| `strokeWidth` | `double` | `3.0` | Thickness of the laser beam. |
| `beamColor` | `Color` | `Color(0xFF00E5FF)` | Primary color of the laser head. |
| `tailColor` | `Color?` | `null` | Trailing gradient color of the beam. |
| `beamFraction` | `double` | `0.28` | Beam length as percentage of perimeter. |
| `duration` | `Duration` | `1800ms` | Duration per complete loop cycle. |

### `GlossSweepLoader`

| Property | Type | Default | Description |
| :--- | :--- | :--- | :--- |
| `child` | `Widget` | *required* | The card/widget to wrap. |
| `isLoading` | `bool` | *required* | Toggles the gloss sweep animation. |
| `borderRadius` | `double` | `16.0` | Corner radius matching your card. |
| `shimmerColor` | `Color` | `Colors.white` | Highlight/reflection color. |
| `duration` | `Duration` | `1800ms` | Duration per complete sweep cycle. |

---

## 💡 The Non-Skeleton Philosophy

Traditional skeleton loaders replace your card's content with gray boxes, causing:
1. **Layout shifts and flashes** during fast network responses.
2. **Loss of context**: Users can no longer read previously cached data.

With `card_pulse_loader`, your users can continue reading existing data uninterrupted while subtle, high-aesthetic light effects communicate background network sync.

---

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
