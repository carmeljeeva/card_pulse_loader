import 'package:flutter/material.dart';
import 'package:card_pulse_loader/card_pulse_loader.dart';

/// Data Model representing a live sports fixture / match
class SportsMatchData {
  final String competition;
  final String stage;
  final String statusText;
  final bool isLive;
  final String matchMinute;
  final String homeTeam;
  final String homeTeamShort;
  final Color homeColor;
  final int homeScore;
  final String awayTeam;
  final String awayTeamShort;
  final Color awayColor;
  final int awayScore;
  final List<String> homeScorers;
  final List<String> awayScorers;
  final int homePossession;
  final int awayPossession;
  final String stadium;
  final String lastApiSync;

  const SportsMatchData({
    required this.competition,
    required this.stage,
    required this.statusText,
    required this.isLive,
    required this.matchMinute,
    required this.homeTeam,
    required this.homeTeamShort,
    required this.homeColor,
    required this.homeScore,
    required this.awayTeam,
    required this.awayTeamShort,
    required this.awayColor,
    required this.awayScore,
    required this.homeScorers,
    required this.awayScorers,
    required this.homePossession,
    required this.awayPossession,
    required this.stadium,
    required this.lastApiSync,
  });

  static SportsMatchData initial() => const SportsMatchData(
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
        lastApiSync: 'Live WebSocket connected',
      );
}

/// The Live Sports Match Card with integrated Card Pulse Loader
class LiveSportsMatchCard extends StatelessWidget {
  final double? width;
  final bool isLoading;
  final CardLoadingStyle loadingStyle;
  final Color loaderColor;
  final SportsMatchData? data;
  final VoidCallback? onStatsTap;
  final VoidCallback? onLineupTap;

  const LiveSportsMatchCard({
    super.key,
    this.width = 380.0,
    this.isLoading = false,
    this.loadingStyle = CardLoadingStyle.borderRunner,
    this.loaderColor = const Color(0xFF00E676),
    this.data,
    this.onStatsTap,
    this.onLineupTap,
  });

  static const double cardRadius = 18.0;

  @override
  Widget build(BuildContext context) {
    final match = data ?? SportsMatchData.initial();

    return CardPulseLoader(
      isLoading: isLoading,
      style: loadingStyle,
      primaryColor: loaderColor,
      borderRadius: cardRadius,
      strokeWidth: 3.2,
      child: Container(
        width: width,
        decoration: BoxDecoration(
          color: const Color(0xFF131722), // Modern sports dark slate
          borderRadius: BorderRadius.circular(cardRadius),
          border: Border.all(
            color: isLoading
                ? loaderColor.withValues(alpha: 0.4)
                : const Color(0xFF232938),
            width: 1.2,
          ),
          boxShadow: const [
            BoxShadow(
              color: Color(0x3D000000),
              blurRadius: 16,
              offset: Offset(0, 6),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(cardRadius),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // ────────────── HEADER: COMPETITION & STATUS ──────────────
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: const BoxDecoration(
                  color: Color(0xFF1A2030),
                  border: Border(
                    bottom: BorderSide(color: Color(0xFF262E44), width: 1),
                  ),
                ),
                child: Row(
                  children: [
                    // Live match pill
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: match.isLive
                            ? const Color(0xFFEF0107).withValues(alpha: 0.2)
                            : const Color(0xFF37474F),
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(
                          color: match.isLive
                              ? const Color(0xFFEF0107)
                              : Colors.white24,
                          width: 1,
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (match.isLive) ...[
                            Container(
                              width: 6,
                              height: 6,
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: Color(0xFFEF0107),
                              ),
                            ),
                            const SizedBox(width: 5),
                          ],
                          Text(
                            '${match.statusText} ${match.matchMinute}',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 10.5,
                              fontWeight: FontWeight.w800,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            match.competition,
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 0.6,
                            ),
                          ),
                          Text(
                            match.stage,
                            style: const TextStyle(
                              color: Colors.white38,
                              fontSize: 10,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                    // Live Syncing Telemetry Tag
                    if (isLoading)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                        decoration: BoxDecoration(
                          color: loaderColor.withValues(alpha: 0.15),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: loaderColor.withValues(alpha: 0.6),
                            width: 0.8,
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            SizedBox(
                              width: 6,
                              height: 6,
                              child: DecoratedBox(
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: loaderColor,
                                ),
                              ),
                            ),
                            const SizedBox(width: 4),
                            Text(
                              'SYNCING',
                              style: TextStyle(
                                color: loaderColor,
                                fontSize: 9.5,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 0.4,
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),

              // ────────────── MAIN SCOREBOARD ──────────────
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 20, 16, 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    // Home Team
                    Expanded(
                      child: Column(
                        children: [
                          _buildTeamCrest(match.homeTeamShort, match.homeColor),
                          const SizedBox(height: 8),
                          Text(
                            match.homeTeam,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Central Live Score
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: Column(
                        children: [
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              AnimatedSwitcher(
                                duration: const Duration(milliseconds: 350),
                                transitionBuilder: (child, anim) => ScaleTransition(
                                  scale: anim,
                                  child: child,
                                ),
                                child: Text(
                                  '${match.homeScore}',
                                  key: ValueKey(match.homeScore),
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 34,
                                    fontWeight: FontWeight.w900,
                                    letterSpacing: -1,
                                  ),
                                ),
                              ),
                              const Padding(
                                padding: EdgeInsets.symmetric(horizontal: 8),
                                child: Text(
                                  ':',
                                  style: TextStyle(
                                    color: Colors.white38,
                                    fontSize: 28,
                                    fontWeight: FontWeight.w900,
                                  ),
                                ),
                              ),
                              AnimatedSwitcher(
                                duration: const Duration(milliseconds: 350),
                                transitionBuilder: (child, anim) => ScaleTransition(
                                  scale: anim,
                                  child: child,
                                ),
                                child: Text(
                                  '${match.awayScore}',
                                  key: ValueKey(match.awayScore),
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 34,
                                    fontWeight: FontWeight.w900,
                                    letterSpacing: -1,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: const Color(0xFF262E44),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: const Text(
                              'AGG 3-2',
                              style: TextStyle(
                                color: Color(0xFF00E5FF),
                                fontSize: 9.5,
                                fontWeight: FontWeight.bold,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Away Team
                    Expanded(
                      child: Column(
                        children: [
                          _buildTeamCrest(match.awayTeamShort, match.awayColor),
                          const SizedBox(height: 8),
                          Text(
                            match.awayTeam,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // ────────────── SCORERS SUMMARY ──────────────
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Home Scorers
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: match.homeScorers.map((s) {
                          return Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Text('⚽', style: TextStyle(fontSize: 10)),
                              const SizedBox(width: 4),
                              Flexible(
                                child: Text(
                                  s,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    color: Colors.white70,
                                    fontSize: 11,
                                  ),
                                ),
                              ),
                            ],
                          );
                        }).toList(),
                      ),
                    ),
                    const SizedBox(width: 12),
                    // Away Scorers
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: match.awayScorers.map((s) {
                          return Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Flexible(
                                child: Text(
                                  s,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    color: Colors.white70,
                                    fontSize: 11,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 4),
                              const Text('⚽', style: TextStyle(fontSize: 10)),
                            ],
                          );
                        }).toList(),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 14),

              // ────────────── LIVE POSSESSION TELEMETRY BAR ──────────────
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '${match.homePossession}%',
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const Text(
                          'POSSESSION',
                          style: TextStyle(
                            color: Colors.white38,
                            fontSize: 9.5,
                            fontWeight: FontWeight.w600,
                            letterSpacing: 0.6,
                          ),
                        ),
                        Text(
                          '${match.awayPossession}%',
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 5),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: SizedBox(
                        height: 5,
                        child: Row(
                          children: [
                            Expanded(
                              flex: match.homePossession,
                              child: Container(color: match.homeColor),
                            ),
                            const SizedBox(width: 2),
                            Expanded(
                              flex: match.awayPossession,
                              child: Container(color: const Color(0xFF00E5FF)),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 12),

              // ────────────── STADIUM & SYNC STATS ──────────────
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Row(
                        children: [
                          const Icon(Icons.stadium_outlined, size: 12, color: Colors.white38),
                          const SizedBox(width: 4),
                          Flexible(
                            child: Text(
                              match.stadium,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(color: Colors.white38, fontSize: 10.5),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 8),
                    Flexible(
                      child: Text(
                        match.lastApiSync,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(color: Colors.white38, fontSize: 10),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 12),

              // ────────────── DIVIDER & FOOTER ACTIONS ──────────────
              const Divider(height: 1, color: Color(0xFF232938)),
              Row(
                children: [
                  Expanded(
                    child: InkWell(
                      onTap: onStatsTap ?? () {},
                      child: const Padding(
                        padding: EdgeInsets.symmetric(vertical: 12, horizontal: 8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.bar_chart, size: 15, color: Color(0xFF00E5FF)),
                            SizedBox(width: 6),
                            Flexible(
                              child: Text(
                                'Match Stats',
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Container(width: 1, height: 20, color: const Color(0xFF232938)),
                  Expanded(
                    child: InkWell(
                      onTap: onLineupTap ?? () {},
                      child: const Padding(
                        padding: EdgeInsets.symmetric(vertical: 12, horizontal: 8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.people_outline, size: 15, color: Color(0xFF00E5FF)),
                            SizedBox(width: 6),
                            Flexible(
                              child: Text(
                                'Lineups',
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTeamCrest(String code, Color accentColor) {
    return Container(
      width: 46,
      height: 46,
      decoration: BoxDecoration(
        color: const Color(0xFF1E2538),
        shape: BoxShape.circle,
        border: Border.all(color: accentColor, width: 2),
        boxShadow: [
          BoxShadow(
            color: accentColor.withValues(alpha: 0.3),
            blurRadius: 8,
          ),
        ],
      ),
      child: Center(
        child: Text(
          code,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 13,
            fontWeight: FontWeight.w900,
            letterSpacing: 0.8,
          ),
        ),
      ),
    );
  }
}
