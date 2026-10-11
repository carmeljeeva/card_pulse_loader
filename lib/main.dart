import 'dart:async';
import 'package:flutter/material.dart';
import 'package:card_pulse_loader/card.dart';
import 'package:card_pulse_loader/card_pulse_loader.dart';

void main() {
  runApp(const SportsCardLoaderApp());
}

class SportsCardLoaderApp extends StatelessWidget {
  const SportsCardLoaderApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'card_pulse_loader - Live Sports Edition',
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
      home: const SportsCardDemoPage(),
    );
  }
}

class SportsCardDemoPage extends StatefulWidget {
  const SportsCardDemoPage({super.key});

  @override
  State<SportsCardDemoPage> createState() => _SportsCardDemoPageState();
}

class _SportsCardDemoPageState extends State<SportsCardDemoPage> {
  bool _isLoading = false;
  bool _continuousMode = false;
  CardLoadingStyle _selectedStyle = CardLoadingStyle.borderRunner;
  Color _selectedColor = const Color(0xFF00E676); // Neon sports green
  int _eventIndex = 0;
  String _apiStatus = 'CONNECTED TO SPORTS WEBSOCKET (LIVE)';

  late SportsMatchData _currentMatch;

  final List<Color> _loaderColors = const [
    Color(0xFF00E676), // Stadium Neon Green
    Color(0xFF00E5FF), // Champions League Cyan
    Color(0xFFFFD700), // Victory Gold
    Color(0xFFFF1744), // Crimson Laser
    Color(0xFFD500F9), // Neon Violet
    Colors.white, // Pure Crystal Sheen
  ];

  // Live match progression states to simulate real-time score updates
  final List<SportsMatchData> _liveProgression = [
    const SportsMatchData(
      competition: 'UEFA CHAMPIONS LEAGUE',
      stage: 'Quarter-Final • 2nd Leg',
      statusText: 'LIVE',
      isLive: true,
      matchMinute: "72'",
      homeTeam: 'Arsenal',
      homeTeamShort: 'ARS',
      homeColor: Color(0xFFEF0107),
      homeScore: 2,
      awayTeam: 'Real Madrid',
      awayTeamShort: 'RMA',
      awayColor: Color(0xFF001965),
      awayScore: 1,
      homeScorers: ['B. Saka 24’', 'K. Havertz 68’'],
      awayScorers: ['V. Junior 41’'],
      homePossession: 54,
      awayPossession: 46,
      stadium: 'Emirates Stadium, London',
      lastApiSync: 'Telemetry synced 2s ago',
    ),
    const SportsMatchData(
      competition: 'UEFA CHAMPIONS LEAGUE',
      stage: 'Quarter-Final • 2nd Leg',
      statusText: 'GOAL!',
      isLive: true,
      matchMinute: "76'",
      homeTeam: 'Arsenal',
      homeTeamShort: 'ARS',
      homeColor: Color(0xFFEF0107),
      homeScore: 3,
      awayTeam: 'Real Madrid',
      awayTeamShort: 'RMA',
      awayColor: Color(0xFF001965),
      awayScore: 1,
      homeScorers: ['B. Saka 24’', 'K. Havertz 68’', 'M. Ødegaard 76’ (P)'],
      awayScorers: ['V. Junior 41’'],
      homePossession: 57,
      awayPossession: 43,
      stadium: 'Emirates Stadium, London',
      lastApiSync: 'Live Goal confirmation (VAR OK)',
    ),
    const SportsMatchData(
      competition: 'UEFA CHAMPIONS LEAGUE',
      stage: 'Quarter-Final • 2nd Leg',
      statusText: 'LIVE',
      isLive: true,
      matchMinute: "84'",
      homeTeam: 'Arsenal',
      homeTeamShort: 'ARS',
      homeColor: Color(0xFFEF0107),
      homeScore: 3,
      awayTeam: 'Real Madrid',
      awayTeamShort: 'RMA',
      awayColor: Color(0xFF001965),
      awayScore: 2,
      homeScorers: ['B. Saka 24’', 'K. Havertz 68’', 'M. Ødegaard 76’'],
      awayScorers: ['V. Junior 41’', 'J. Bellingham 84’'],
      homePossession: 52,
      awayPossession: 48,
      stadium: 'Emirates Stadium, London',
      lastApiSync: 'Score updated: 3 - 2',
    ),
    const SportsMatchData(
      competition: 'UEFA CHAMPIONS LEAGUE',
      stage: 'Quarter-Final • 2nd Leg',
      statusText: 'FULL TIME',
      isLive: false,
      matchMinute: "90+5'",
      homeTeam: 'Arsenal',
      homeTeamShort: 'ARS',
      homeColor: Color(0xFFEF0107),
      homeScore: 3,
      awayTeam: 'Real Madrid',
      awayTeamShort: 'RMA',
      awayColor: Color(0xFF001965),
      awayScore: 2,
      homeScorers: ['B. Saka 24’', 'K. Havertz 68’', 'M. Ødegaard 76’'],
      awayScorers: ['V. Junior 41’', 'J. Bellingham 84’'],
      homePossession: 53,
      awayPossession: 47,
      stadium: 'Emirates Stadium, London',
      lastApiSync: 'Arsenal advances on AGG (4-3)',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _currentMatch = _liveProgression.first;
  }

  void _simulateLiveApiPoll() {
    if (_isLoading) return;

    setState(() {
      _isLoading = true;
      _apiStatus = 'FETCHING LIVE MATCH TELEMETRY (GET /fixtures/live)...';
    });

    Timer(const Duration(milliseconds: 2400), () {
      if (!mounted) return;
      _eventIndex++;
      final updatedMatch = _liveProgression[_eventIndex % _liveProgression.length];

      setState(() {
        if (!_continuousMode) {
          _isLoading = false;
        }
        _currentMatch = updatedMatch;
        _apiStatus = 'SYNCED • ${updatedMatch.statusText} ${updatedMatch.matchMinute} (${updatedMatch.homeScore} - ${updatedMatch.awayScore})';
      });

      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.sports_soccer, color: Color(0xFF00E676), size: 20),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  'Match Event: ${updatedMatch.homeTeam} ${updatedMatch.homeScore} - ${updatedMatch.awayScore} ${updatedMatch.awayTeam}',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
          backgroundColor: const Color(0xFF1E2538),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          duration: const Duration(milliseconds: 2200),
        ),
      );
    });
  }

  void _toggleContinuousMode(bool value) {
    setState(() {
      _continuousMode = value;
      _isLoading = value;
      _apiStatus = value ? 'CONTINUOUS LIVE PULSE ACTIVE' : 'IDLE • Up to date';
    });
  }

  @override
  Widget build(BuildContext context) {
    final activeLoading = _isLoading || _continuousMode;

    return Scaffold(
      backgroundColor: const Color(0xFF0B0E14),
      appBar: AppBar(
        backgroundColor: const Color(0xFF131722),
        elevation: 0,
        title: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.sports_soccer, color: Color(0xFF00E676), size: 22),
            SizedBox(width: 8),
            Text(
              'Sports Live Card Loader',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w800,
                letterSpacing: 0.3,
              ),
            ),
          ],
        ),
        centerTitle: true,
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 16),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: activeLoading
                  ? const Color(0xFF00E676).withValues(alpha: 0.15)
                  : const Color(0xFF1E2538),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: activeLoading ? const Color(0xFF00E676) : Colors.white24,
                width: 1,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  activeLoading ? Icons.sync : Icons.wifi,
                  size: 13,
                  color: activeLoading ? const Color(0xFF00E676) : Colors.white54,
                ),
                const SizedBox(width: 5),
                Text(
                  activeLoading ? 'POLLING' : 'STANDBY',
                  style: TextStyle(
                    fontSize: 10.5,
                    fontWeight: FontWeight.w800,
                    color: activeLoading ? const Color(0xFF00E676) : Colors.white54,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // ─────────────────────────────────────────────────────────────
              // 1. SPORTS MATCH CARD (THE STAR OF THE SHOW)
              // ─────────────────────────────────────────────────────────────
              LiveSportsMatchCard(
                width: 380,
                isLoading: activeLoading,
                loadingStyle: _selectedStyle,
                loaderColor: _selectedColor,
                data: _currentMatch,
                onStatsTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Opening detailed match statistics & xG telemetry'),
                      duration: Duration(milliseconds: 1200),
                    ),
                  );
                },
                onLineupTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Opening formations, substitutions & heatmaps'),
                      duration: Duration(milliseconds: 1200),
                    ),
                  );
                },
              ),

              const SizedBox(height: 20),

              // Live Status Strip
              Container(
                width: 380,
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
                decoration: BoxDecoration(
                  color: activeLoading
                      ? const Color(0xFF00E676).withValues(alpha: 0.1)
                      : const Color(0xFF161B26),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(
                    color: activeLoading
                        ? const Color(0xFF00E676).withValues(alpha: 0.5)
                        : const Color(0xFF232938),
                    width: 0.8,
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      activeLoading ? Icons.sensors : Icons.info_outline,
                      size: 15,
                      color: activeLoading ? const Color(0xFF00E676) : Colors.white54,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        _apiStatus,
                        style: TextStyle(
                          fontSize: 11.5,
                          fontWeight: FontWeight.w600,
                          color: activeLoading ? const Color(0xFF00E676) : Colors.white70,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // ─────────────────────────────────────────────────────────────
              // 2. SPORTS API CONTROL PANEL
              // ─────────────────────────────────────────────────────────────
              Container(
                width: 380,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFF131722),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: const Color(0xFF232938), width: 1),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Main Action: Trigger Live Telemetry Fetch
                    ElevatedButton(
                      onPressed: activeLoading && !_continuousMode
                          ? null
                          : _simulateLiveApiPoll,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF00E676),
                        foregroundColor: const Color(0xFF0B0E14),
                        disabledBackgroundColor:
                            const Color(0xFF00E676).withValues(alpha: 0.4),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        elevation: 4,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (_isLoading && !_continuousMode) ...[
                            const SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  Color(0xFF0B0E14),
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            const Flexible(
                              child: Text(
                                'Polling Match API...',
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ),
                          ] else ...[
                            const Icon(Icons.bolt, size: 20),
                            const SizedBox(width: 6),
                            const Flexible(
                              child: Text(
                                'Simulate Live API Poll (2.4s)',
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w800,
                                  letterSpacing: 0.3,
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),

                    const SizedBox(height: 12),

                    // Continuous Loop Toggle
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Expanded(
                          child: Row(
                            children: [
                              Icon(Icons.loop, size: 16, color: Colors.white70),
                              SizedBox(width: 6),
                              Flexible(
                                child: Text(
                                  'Continuous Animation Loop',
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontSize: 12.5,
                                    fontWeight: FontWeight.w500,
                                    color: Colors.white70,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Switch.adaptive(
                          value: _continuousMode,
                          onChanged: _toggleContinuousMode,
                          activeTrackColor: const Color(0xFF00E676),
                          activeThumbColor: Colors.black,
                        ),
                      ],
                    ),

                    const Divider(height: 20, color: Color(0xFF232938)),

                    // Effect Style Selector Title
                    const Row(
                      children: [
                        Icon(Icons.auto_awesome, size: 15, color: Color(0xFF00E676)),
                        SizedBox(width: 6),
                        Flexible(
                          child: Text(
                            'Select Loader Effect Style:',
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w800,
                              color: Colors.white,
                              letterSpacing: 0.4,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),

                    // Effect Style Chips
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: [
                        _buildStyleChip(
                          title: '🏃 Border Runner',
                          style: CardLoadingStyle.borderRunner,
                        ),
                        _buildStyleChip(
                          title: '✨ Gloss Sweep',
                          style: CardLoadingStyle.glossSweep,
                        ),
                        _buildStyleChip(
                          title: '📡 Radar Scanner',
                          style: CardLoadingStyle.radarScan,
                        ),
                        _buildStyleChip(
                          title: '💓 Breathing Aura',
                          style: CardLoadingStyle.breathingAura,
                        ),
                        _buildStyleChip(
                          title: '🎭 Cyber Combo',
                          style: CardLoadingStyle.cyberCombo,
                        ),
                      ],
                    ),

                    const Divider(height: 20, color: Color(0xFF232938)),

                    // Glow Color Selector
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Beam Color:',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: Colors.white70,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            reverse: true,
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: _loaderColors.map((color) {
                                final isSelected = _selectedColor == color;
                                return GestureDetector(
                                  onTap: () => setState(() => _selectedColor = color),
                                  child: Container(
                                    margin: const EdgeInsets.only(left: 6),
                                    width: 22,
                                    height: 22,
                                    decoration: BoxDecoration(
                                      color: color,
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: isSelected
                                            ? Colors.white
                                            : Colors.transparent,
                                        width: 2.5,
                                      ),
                                      boxShadow: isSelected
                                          ? [
                                              BoxShadow(
                                                color: color.withValues(alpha: 0.8),
                                                blurRadius: 8,
                                              ),
                                            ]
                                          : null,
                                    ),
                                  ),
                                );
                              }).toList(),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 18),

              // Description note
              Container(
                width: 380,
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFF131722),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFF232938)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      '⚽ Why Sports Cards Need Non-Skeleton Loading',
                      style: TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 12,
                        color: Color(0xFF00E676),
                      ),
                    ),
                    const SizedBox(height: 6),
                    const Text(
                      'Live sports fixtures continuously poll or stream updates (goals, minutes, possession, cards). Replacing the scorecard with a blank gray skeleton ruins the broadcast experience. With CardPulseLoader, live scores remain visible while the Border Runner or Gloss Sweep indicates background telemetry synchronization.',
                      style: TextStyle(
                        fontSize: 11.5,
                        color: Colors.white54,
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStyleChip({
    required String title,
    required CardLoadingStyle style,
  }) {
    final isSelected = _selectedStyle == style;

    return InkWell(
      onTap: () => setState(() => _selectedStyle = style),
      borderRadius: BorderRadius.circular(10),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
        decoration: BoxDecoration(
          color: isSelected
              ? const Color(0xFF00E676).withValues(alpha: 0.2)
              : const Color(0xFF1A2030),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: isSelected ? const Color(0xFF00E676) : const Color(0xFF262E44),
            width: isSelected ? 1.5 : 1,
          ),
        ),
        child: Text(
          title,
          style: TextStyle(
            color: isSelected ? const Color(0xFF00E676) : Colors.white70,
            fontSize: 11.5,
            fontWeight: isSelected ? FontWeight.w800 : FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
