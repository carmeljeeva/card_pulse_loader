import 'dart:async';
import 'package:flutter/material.dart';
import 'package:card_pulse_loader/card_pulse_loader.dart';

void main() {
  runApp(const SportsExampleApp());
}

class SportsExampleApp extends StatelessWidget {
  const SportsExampleApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'card_pulse_loader - Sports Example',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF0B0E14),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF00E676),
          brightness: Brightness.dark,
        ),
      ),
      home: const SportsMatchExamplePage(),
    );
  }
}

class SportsMatchExamplePage extends StatefulWidget {
  const SportsMatchExamplePage({super.key});

  @override
  State<SportsMatchExamplePage> createState() => _SportsMatchExamplePageState();
}

class _SportsMatchExamplePageState extends State<SportsMatchExamplePage> {
  bool _isLoading = false;
  CardLoadingStyle _selectedStyle = CardLoadingStyle.borderRunner;
  final Color _beamColor = const Color(0xFF00E676);
  int _homeScore = 2;
  int _awayScore = 1;
  String _matchMinute = "72'";

  void _simulateLiveScorePoll() {
    if (_isLoading) return;
    setState(() => _isLoading = true);

    Timer(const Duration(milliseconds: 2400), () {
      if (!mounted) return;
      setState(() {
        _isLoading = false;
        _homeScore = 3;
        _awayScore = 2;
        _matchMinute = "88' (GOAL!)";
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('⚽ Goal Confirmed! Live score updated to 3 - 2'),
          behavior: SnackBarBehavior.floating,
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0B0E14),
      appBar: AppBar(
        title: const Text('Live Sports Card Loader'),
        centerTitle: true,
        backgroundColor: const Color(0xFF131722),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Style Selector
              SegmentedButton<CardLoadingStyle>(
                segments: const [
                  ButtonSegment(
                    value: CardLoadingStyle.borderRunner,
                    label: Text('Border Runner'),
                  ),
                  ButtonSegment(
                    value: CardLoadingStyle.glossSweep,
                    label: Text('Gloss Sweep'),
                  ),
                  ButtonSegment(
                    value: CardLoadingStyle.radarScan,
                    label: Text('Radar Scan'),
                  ),
                ],
                selected: {_selectedStyle},
                onSelectionChanged: (val) {
                  setState(() => _selectedStyle = val.first);
                },
              ),

              const SizedBox(height: 24),

              // The Sports Card wrapped with CardPulseLoader
              CardPulseLoader(
                isLoading: _isLoading,
                style: _selectedStyle,
                primaryColor: _beamColor,
                borderRadius: 18.0,
                strokeWidth: 3.2,
                child: Container(
                  width: 360,
                  decoration: BoxDecoration(
                    color: const Color(0xFF131722),
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(color: const Color(0xFF232938), width: 1.2),
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0x3D000000),
                        blurRadius: 16,
                        offset: Offset(0, 6),
                      ),
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(18),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Competition & Live Status
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                              decoration: BoxDecoration(
                                color: const Color(0xFFEF0107).withValues(alpha: 0.2),
                                borderRadius: BorderRadius.circular(6),
                                border: Border.all(color: const Color(0xFFEF0107)),
                              ),
                              child: Text(
                                'LIVE $_matchMinute',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Text(
                              _isLoading ? '⚡ Syncing...' : 'UEFA Champions League',
                              style: TextStyle(
                                color: _isLoading ? const Color(0xFF00E676) : Colors.white54,
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 18),

                        // Scoreboard
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            const Text(
                              'Arsenal',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            Text(
                              '$_homeScore : $_awayScore',
                              style: const TextStyle(
                                fontSize: 30,
                                fontWeight: FontWeight.w900,
                                color: Colors.white,
                              ),
                            ),
                            const Text(
                              'Real Madrid',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 14),

                        // Possession Telemetry
                        const Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text('54%', style: TextStyle(color: Colors.white54, fontSize: 11)),
                            Text('POSSESSION', style: TextStyle(color: Colors.white38, fontSize: 9)),
                            Text('46%', style: TextStyle(color: Colors.white54, fontSize: 11)),
                          ],
                        ),
                        const SizedBox(height: 4),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(3),
                          child: SizedBox(
                            height: 4,
                            child: Row(
                              children: [
                                Expanded(flex: 54, child: Container(color: const Color(0xFFEF0107))),
                                const SizedBox(width: 2),
                                Expanded(flex: 46, child: Container(color: const Color(0xFF00E5FF))),
                              ],
                            ),
                          ),
                        ),

                        const SizedBox(height: 20),

                        // Simulation button
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton.icon(
                            onPressed: _isLoading ? null : _simulateLiveScorePoll,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF00E676),
                              foregroundColor: const Color(0xFF0B0E14),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            icon: const Icon(Icons.bolt, size: 16),
                            label: Text(
                              _isLoading ? 'Syncing Match Telemetry...' : 'Simulate Live API Poll',
                              style: const TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 24),

              const Text(
                '⚽ Live match data remains readable while background API syncs!',
                style: TextStyle(color: Colors.white38, fontSize: 12),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
