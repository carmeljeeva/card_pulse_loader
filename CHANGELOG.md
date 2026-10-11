# Changelog

All notable changes to `card_pulse_loader` will be documented in this file.

## 1.0.0

- Initial release.
- Added `BorderRunnerLoader` for animated glowing laser beam traveling along card borders.
- Added `GlossSweepLoader` for diagonal liquid-glass shimmer sweep effect across cards.
- Added `RadarScannerLoader` for vertical holographic laser scan beam.
- Added `CardPulseLoader` all-in-one wrapper with `CardLoadingStyle` options (Border Runner, Gloss Sweep, Radar Scan, Breathing Aura, Cyber Combo).
- Non-skeleton optimistic loading: keeps card content readable and interactive while background sync is active.
- Pure Flutter implementation with zero external dependencies and 60/120 FPS performance.
- Interactive demo example app included.
