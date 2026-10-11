import 'dart:math' as math;
import 'dart:ui' as ui;
import 'package:flutter/material.dart';

/// Available innovative loading styles for [CardPulseLoader]
enum CardLoadingStyle {
  /// Traveling glowing laser beam running around the card border
  borderRunner,

  /// Diagonal liquid glass / holographic gloss sheen sweep
  glossSweep,

  /// High-tech futuristic laser scanner beam sweeping vertically
  radarScan,

  /// Luminous ambient pulse & elevation breathing
  breathingAura,

  /// Combined Border Runner + Subtle Gloss Shimmer
  cyberCombo,
}

// ─────────────────────────────────────────────────────────────────────────────
// 1. ALL-IN-ONE CARD PULSE LOADER WIDGET
// ─────────────────────────────────────────────────────────────────────────────

/// An all-in-one wrapper widget that applies modern non-skeleton loading animations
/// to any child widget (cards, tiles, containers, dialogs).
class CardPulseLoader extends StatefulWidget {
  /// The widget to wrap with the loading animation.
  final Widget child;

  /// Whether the loading animation is currently active.
  final bool isLoading;

  /// The loading style to apply.
  final CardLoadingStyle style;

  /// Border radius of the card/child widget.
  final double borderRadius;

  /// Primary color for beams, glow, and scan lines.
  final Color primaryColor;

  /// Secondary/tail color for gradient trails.
  final Color? secondaryColor;

  /// Stroke width for border runner beam.
  final double strokeWidth;

  /// Duration for one complete animation cycle.
  final Duration duration;

  const CardPulseLoader({
    super.key,
    required this.child,
    required this.isLoading,
    this.style = CardLoadingStyle.borderRunner,
    this.borderRadius = 16.0,
    this.primaryColor = const Color(0xFF00E5FF),
    this.secondaryColor,
    this.strokeWidth = 3.0,
    this.duration = const Duration(milliseconds: 1800),
  });

  @override
  State<CardPulseLoader> createState() => _CardPulseLoaderState();
}

class _CardPulseLoaderState extends State<CardPulseLoader>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.duration);
    if (widget.isLoading) {
      _controller.repeat();
    }
  }

  @override
  void didUpdateWidget(covariant CardPulseLoader oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isLoading != oldWidget.isLoading) {
      if (widget.isLoading) {
        _controller.repeat();
      } else {
        _controller.stop();
        _controller.reset();
      }
    }
    if (widget.duration != oldWidget.duration) {
      _controller.duration = widget.duration;
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        final progress = _controller.value;

        return Stack(
          clipBehavior: Clip.none,
          children: [
            // Aura shadow pulse if breathingAura or cyberCombo is active
            if (widget.isLoading &&
                (widget.style == CardLoadingStyle.breathingAura ||
                    widget.style == CardLoadingStyle.cyberCombo))
              Positioned.fill(
                child: IgnorePointer(
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(widget.borderRadius),
                      boxShadow: [
                        BoxShadow(
                          color: widget.primaryColor.withValues(
                            alpha: 0.2 + (0.35 * (0.5 + 0.5 * math.sin(progress * 2 * math.pi))),
                          ),
                          blurRadius: 18 + (12 * (0.5 + 0.5 * math.sin(progress * 2 * math.pi))),
                          spreadRadius: 2 + (4 * (0.5 + 0.5 * math.sin(progress * 2 * math.pi))),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

            // Base child widget
            widget.child,

            // Active loading overlay
            if (widget.isLoading) ...[
              // Gloss Sweep
              if (widget.style == CardLoadingStyle.glossSweep ||
                  widget.style == CardLoadingStyle.cyberCombo)
                Positioned.fill(
                  child: GlossSweepOverlay(
                    progress: progress,
                    borderRadius: widget.borderRadius,
                    shimmerColor: widget.primaryColor == const Color(0xFF00E5FF)
                        ? Colors.white
                        : widget.primaryColor,
                  ),
                ),

              // Radar Scanner
              if (widget.style == CardLoadingStyle.radarScan)
                Positioned.fill(
                  child: RadarScannerOverlay(
                    progress: progress,
                    borderRadius: widget.borderRadius,
                    beamColor: widget.primaryColor,
                  ),
                ),

              // Border Runner
              if (widget.style == CardLoadingStyle.borderRunner ||
                  widget.style == CardLoadingStyle.cyberCombo)
                Positioned.fill(
                  child: IgnorePointer(
                    child: CustomPaint(
                      size: Size.infinite,
                      painter: BorderBeamPainter(
                        progress: progress,
                        borderRadius: widget.borderRadius,
                        strokeWidth: widget.strokeWidth,
                        primaryColor: widget.primaryColor,
                        secondaryColor: widget.secondaryColor ??
                            widget.primaryColor.withValues(alpha: 0.15),
                        beamFraction: 0.28,
                      ),
                    ),
                  ),
                ),
            ],
          ],
        );
      },
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// 2. DEDICATED BORDER RUNNER LOADER
// ─────────────────────────────────────────────────────────────────────────────

/// Wraps any widget with an animated laser beam traveling around its rounded border.
class BorderRunnerLoader extends StatefulWidget {
  final Widget child;
  final bool isLoading;
  final double borderRadius;
  final double strokeWidth;
  final Color beamColor;
  final Color? tailColor;
  final double beamFraction;
  final Duration duration;

  const BorderRunnerLoader({
    super.key,
    required this.child,
    required this.isLoading,
    this.borderRadius = 16.0,
    this.strokeWidth = 3.0,
    this.beamColor = const Color(0xFF00E5FF),
    this.tailColor,
    this.beamFraction = 0.28,
    this.duration = const Duration(milliseconds: 1800),
  });

  @override
  State<BorderRunnerLoader> createState() => _BorderRunnerLoaderState();
}

class _BorderRunnerLoaderState extends State<BorderRunnerLoader>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.duration);
    if (widget.isLoading) {
      _controller.repeat();
    }
  }

  @override
  void didUpdateWidget(covariant BorderRunnerLoader oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isLoading != oldWidget.isLoading) {
      if (widget.isLoading) {
        _controller.repeat();
      } else {
        _controller.stop();
        _controller.reset();
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        widget.child,
        if (widget.isLoading)
          Positioned.fill(
            child: IgnorePointer(
              child: AnimatedBuilder(
                animation: _controller,
                builder: (context, _) {
                  return CustomPaint(
                    size: Size.infinite,
                    painter: BorderBeamPainter(
                      progress: _controller.value,
                      borderRadius: widget.borderRadius,
                      strokeWidth: widget.strokeWidth,
                      primaryColor: widget.beamColor,
                      secondaryColor:
                          widget.tailColor ?? widget.beamColor.withValues(alpha: 0.1),
                      beamFraction: widget.beamFraction,
                    ),
                  );
                },
              ),
            ),
          ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// 3. DEDICATED GLOSS SWEEP LOADER
// ─────────────────────────────────────────────────────────────────────────────

/// Wraps any widget with a diagonal liquid-glass gloss sheen sweep effect.
class GlossSweepLoader extends StatefulWidget {
  final Widget child;
  final bool isLoading;
  final double borderRadius;
  final Color shimmerColor;
  final Duration duration;

  const GlossSweepLoader({
    super.key,
    required this.child,
    required this.isLoading,
    this.borderRadius = 16.0,
    this.shimmerColor = Colors.white,
    this.duration = const Duration(milliseconds: 1800),
  });

  @override
  State<GlossSweepLoader> createState() => _GlossSweepLoaderState();
}

class _GlossSweepLoaderState extends State<GlossSweepLoader>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.duration);
    if (widget.isLoading) {
      _controller.repeat();
    }
  }

  @override
  void didUpdateWidget(covariant GlossSweepLoader oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isLoading != oldWidget.isLoading) {
      if (widget.isLoading) {
        _controller.repeat();
      } else {
        _controller.stop();
        _controller.reset();
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        widget.child,
        if (widget.isLoading)
          Positioned.fill(
            child: AnimatedBuilder(
              animation: _controller,
              builder: (context, _) {
                return GlossSweepOverlay(
                  progress: _controller.value,
                  borderRadius: widget.borderRadius,
                  shimmerColor: widget.shimmerColor,
                );
              },
            ),
          ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// 4. DEDICATED RADAR SCANNER LOADER
// ─────────────────────────────────────────────────────────────────────────────

/// Wraps any widget with a vertical laser scanner beam effect.
class RadarScannerLoader extends StatefulWidget {
  final Widget child;
  final bool isLoading;
  final double borderRadius;
  final Color beamColor;
  final Duration duration;

  const RadarScannerLoader({
    super.key,
    required this.child,
    required this.isLoading,
    this.borderRadius = 16.0,
    this.beamColor = const Color(0xFF00E5FF),
    this.duration = const Duration(milliseconds: 1800),
  });

  @override
  State<RadarScannerLoader> createState() => _RadarScannerLoaderState();
}

class _RadarScannerLoaderState extends State<RadarScannerLoader>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.duration);
    if (widget.isLoading) {
      _controller.repeat();
    }
  }

  @override
  void didUpdateWidget(covariant RadarScannerLoader oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isLoading != oldWidget.isLoading) {
      if (widget.isLoading) {
        _controller.repeat();
      } else {
        _controller.stop();
        _controller.reset();
      }
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        widget.child,
        if (widget.isLoading)
          Positioned.fill(
            child: AnimatedBuilder(
              animation: _controller,
              builder: (context, _) {
                return RadarScannerOverlay(
                  progress: _controller.value,
                  borderRadius: widget.borderRadius,
                  beamColor: widget.beamColor,
                );
              },
            ),
          ),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// 5. LOW-LEVEL PAINTERS & OVERLAYS
// ─────────────────────────────────────────────────────────────────────────────

/// Painter that renders the glowing traveling border beam
class BorderBeamPainter extends CustomPainter {
  final double progress;
  final double borderRadius;
  final double strokeWidth;
  final Color primaryColor;
  final Color secondaryColor;
  final double beamFraction;

  BorderBeamPainter({
    required this.progress,
    required this.borderRadius,
    this.strokeWidth = 3.0,
    this.primaryColor = const Color(0xFF00E5FF),
    this.secondaryColor = const Color(0xFF001965),
    this.beamFraction = 0.28,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (size.width <= 0 || size.height <= 0) return;

    final rrect = RRect.fromRectAndRadius(
      Rect.fromLTWH(
        strokeWidth / 2,
        strokeWidth / 2,
        size.width - strokeWidth,
        size.height - strokeWidth,
      ),
      Radius.circular(math.max(0, borderRadius - (strokeWidth / 2))),
    );

    final basePath = Path()..addRRect(rrect);
    final metrics = basePath.computeMetrics().toList();
    if (metrics.isEmpty) return;

    final pathMetric = metrics.first;
    final totalLength = pathMetric.length;
    final beamLength = totalLength * beamFraction;

    final headPos = progress * totalLength;
    final tailPos = headPos - beamLength;

    Path beamPath = Path();

    if (tailPos >= 0) {
      beamPath = pathMetric.extractPath(tailPos, headPos);
    } else {
      beamPath = pathMetric.extractPath(totalLength + tailPos, totalLength);
      final headSegment = pathMetric.extractPath(0, headPos);
      beamPath.addPath(headSegment, Offset.zero);
    }

    // Glowing blur under-stroke
    final glowPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth * 2.6
      ..strokeCap = StrokeCap.round
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8)
      ..color = primaryColor.withValues(alpha: 0.5);

    canvas.drawPath(beamPath, glowPaint);

    // Core gradient stroke
    final tangent = pathMetric.getTangentForOffset(headPos % totalLength);
    final headOffset = tangent?.position ?? Offset.zero;

    final corePaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round
      ..shader = ui.Gradient.radial(
        headOffset,
        beamLength * 0.9,
        [
          Colors.white,
          primaryColor,
          secondaryColor.withValues(alpha: 0.2),
          Colors.transparent,
        ],
        [0.0, 0.35, 0.75, 1.0],
      );

    canvas.drawPath(beamPath, corePaint);

    // Comet flare head
    if (tangent != null) {
      final flarePaint = Paint()
        ..color = Colors.white
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 3);
      canvas.drawCircle(tangent.position, strokeWidth * 0.9, flarePaint);
      canvas.drawCircle(tangent.position, strokeWidth * 0.5, Paint()..color = Colors.white);
    }
  }

  @override
  bool shouldRepaint(covariant BorderBeamPainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.primaryColor != primaryColor ||
        oldDelegate.borderRadius != borderRadius ||
        oldDelegate.strokeWidth != strokeWidth;
  }
}

/// Overlay that renders the diagonal gloss sweep across the widget
class GlossSweepOverlay extends StatelessWidget {
  final double progress;
  final double borderRadius;
  final Color shimmerColor;

  const GlossSweepOverlay({
    super.key,
    required this.progress,
    required this.borderRadius,
    this.shimmerColor = Colors.white,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: IgnorePointer(
        child: CustomPaint(
          size: Size.infinite,
          painter: _GlossSweepPainter(
            progress: progress,
            shimmerColor: shimmerColor,
          ),
        ),
      ),
    );
  }
}

class _GlossSweepPainter extends CustomPainter {
  final double progress;
  final Color shimmerColor;

  _GlossSweepPainter({
    required this.progress,
    required this.shimmerColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (size.width <= 0 || size.height <= 0) return;

    final width = size.width;
    final height = size.height;

    final sweepX = -width * 0.6 + (progress * width * 2.2);
    final angle = -30 * math.pi / 180;

    canvas.save();
    canvas.translate(sweepX, height * 0.5);
    canvas.rotate(angle);

    final bandWidth = width * 0.75;
    final rect = Rect.fromCenter(
      center: Offset.zero,
      width: bandWidth,
      height: height * 3.0,
    );

    final paint = Paint()
      ..shader = ui.Gradient.linear(
        Offset(-bandWidth / 2, 0),
        Offset(bandWidth / 2, 0),
        [
          Colors.transparent,
          shimmerColor.withValues(alpha: 0.0),
          shimmerColor.withValues(alpha: 0.12),
          shimmerColor.withValues(alpha: 0.45),
          shimmerColor.withValues(alpha: 0.75),
          shimmerColor.withValues(alpha: 0.45),
          shimmerColor.withValues(alpha: 0.12),
          shimmerColor.withValues(alpha: 0.0),
          Colors.transparent,
        ],
        [0.0, 0.2, 0.35, 0.47, 0.5, 0.53, 0.65, 0.8, 1.0],
      )
      ..blendMode = BlendMode.screen;

    canvas.drawRect(rect, paint);
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _GlossSweepPainter oldDelegate) {
    return oldDelegate.progress != progress || oldDelegate.shimmerColor != shimmerColor;
  }
}

/// Overlay that renders the vertical laser scanner
class RadarScannerOverlay extends StatelessWidget {
  final double progress;
  final double borderRadius;
  final Color beamColor;

  const RadarScannerOverlay({
    super.key,
    required this.progress,
    required this.borderRadius,
    this.beamColor = const Color(0xFF00E5FF),
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: IgnorePointer(
        child: CustomPaint(
          size: Size.infinite,
          painter: _RadarScannerPainter(
            progress: progress,
            beamColor: beamColor,
          ),
        ),
      ),
    );
  }
}

class _RadarScannerPainter extends CustomPainter {
  final double progress;
  final Color beamColor;

  _RadarScannerPainter({
    required this.progress,
    required this.beamColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (size.width <= 0 || size.height <= 0) return;

    final width = size.width;
    final height = size.height;

    final scanY = progress * height;
    final trailHeight = height * 0.28;

    final trailRect = Rect.fromLTRB(0, math.max(0, scanY - trailHeight), width, scanY);
    final trailPaint = Paint()
      ..shader = ui.Gradient.linear(
        Offset(0, scanY - trailHeight),
        Offset(0, scanY),
        [
          Colors.transparent,
          beamColor.withValues(alpha: 0.03),
          beamColor.withValues(alpha: 0.15),
          beamColor.withValues(alpha: 0.30),
        ],
        [0.0, 0.4, 0.8, 1.0],
      )
      ..blendMode = BlendMode.srcOver;

    canvas.drawRect(trailRect, trailPaint);

    final linePaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0
      ..shader = ui.Gradient.linear(
        Offset.zero,
        Offset(width, 0),
        [
          Colors.transparent,
          beamColor.withValues(alpha: 0.6),
          Colors.white,
          beamColor.withValues(alpha: 0.6),
          Colors.transparent,
        ],
        [0.0, 0.2, 0.5, 0.8, 1.0],
      );

    canvas.drawLine(Offset(0, scanY), Offset(width, scanY), linePaint);

    final glowPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 5.0
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4)
      ..color = beamColor.withValues(alpha: 0.6);

    canvas.drawLine(Offset(0, scanY), Offset(width, scanY), glowPaint);
  }

  @override
  bool shouldRepaint(covariant _RadarScannerPainter oldDelegate) {
    return oldDelegate.progress != progress || oldDelegate.beamColor != beamColor;
  }
}
