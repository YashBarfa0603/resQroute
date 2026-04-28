import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:res_q_route/screens/alert_center.dart';
import 'package:res_q_route/screens/dispatch_communications.dart';
import 'package:res_q_route/screens/destination_selection.dart';
import 'package:res_q_route/screens/live_navigation.dart';
import 'package:res_q_route/theme/app_themes.dart';

class AIRouteIntelligencePage extends StatefulWidget {
  const AIRouteIntelligencePage({super.key});

  @override
  State<AIRouteIntelligencePage> createState() => _AIRouteIntelligencePageState();
}

class _AIRouteIntelligencePageState extends State<AIRouteIntelligencePage>
    with TickerProviderStateMixin {
  late AnimationController _pulseController;
  late AnimationController _etaController;
  int _navIndex = 0;

  final List<Map<String, dynamic>> _agentCards = [
    {'label': 'TRAFFIC AGENT', 'dotColor': Color(0xFFBA1A1A), 'status': 'CONGESTION DETECTED', 'detail': 'NH-8 blocked → alt via Ring Road', 'icon': Icons.traffic_rounded},
    {'label': 'WEATHER AGENT', 'dotColor': Color(0xFFB46000), 'status': 'FOG ADVISORY', 'detail': 'Visibility 200m · 40km/h recommended', 'icon': Icons.cloud_rounded},
    {'label': 'ROAD AGENT', 'dotColor': Colors.green, 'status': 'CLEAR AHEAD', 'detail': 'Route to AIIMS Hospital unobstructed', 'icon': Icons.route_rounded},
  ];

  final List<Map<String, dynamic>> _agentStatuses = [
    {'name': 'Traffic Agent', 'status': 'Active', 'color': Color(0xFFBA1A1A), 'icon': Icons.traffic_rounded},
    {'name': 'Weather Agent', 'status': 'Active', 'color': Color(0xFFB46000), 'icon': Icons.cloud_rounded},
    {'name': 'Road Agent', 'status': 'Active', 'color': Colors.green, 'icon': Icons.route_rounded},
    {'name': 'Decision Agent', 'status': 'Processing', 'color': Color(0xFF00236f), 'icon': Icons.psychology_rounded},
  ];

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(vsync: this, duration: const Duration(seconds: 3))..repeat();
    _etaController = AnimationController(vsync: this, duration: const Duration(milliseconds: 800))..repeat(reverse: true);
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _etaController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppThemes.bgLight,
      bottomNavigationBar: _buildNavBar(),
      body: CustomScrollView(
        slivers: [
          _buildAppBar(context),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),
                  _buildHeroCard(),
                  const SizedBox(height: 32),
                  _sectionHeader("LIVE ROUTE INTELLIGENCE"),
                  const SizedBox(height: 14),
                  _buildAgentFeed(),
                  const SizedBox(height: 32),
                  _sectionHeader("AI DECISION"),
                  const SizedBox(height: 14),
                  _buildAIDecisionCard(),
                  const SizedBox(height: 32),
                  _sectionHeader("AGENT STATUS"),
                  const SizedBox(height: 14),
                  _buildAgentStatusGrid(),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return SliverAppBar(
      pinned: true,
      backgroundColor: Colors.transparent,
      flexibleSpace: ClipRect(
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
          child: Container(color: AppThemes.bgLight.withOpacity(0.9)),
        ),
      ),
      leading: IconButton(
        icon: const Icon(Icons.arrow_back_ios_new_rounded, color: AppThemes.textDark),
        onPressed: () => Navigator.pop(context),
      ),
      title: Text("ResQRoute", style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w800, fontSize: 20, color: AppThemes.textDark)),
      actions: [
        Container(
          margin: const EdgeInsets.only(right: 16),
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          decoration: BoxDecoration(color: Colors.green.withOpacity(0.1), borderRadius: BorderRadius.circular(20)),
          child: Row(
            children: [
              Container(width: 6, height: 6, decoration: const BoxDecoration(color: Colors.green, shape: BoxShape.circle)),
              const SizedBox(width: 6),
              Text("AI ROUTING ACTIVE", style: GoogleFonts.manrope(color: Colors.green.shade700, fontWeight: FontWeight.w800, fontSize: 9, letterSpacing: 0.5)),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildHeroCard() {
    return GestureDetector(
      onTap: () { HapticFeedback.mediumImpact(); Navigator.push(context, MaterialPageRoute(builder: (_) => const LiveNavigationPage())); },
      child: Container(
        height: 220,
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            begin: Alignment.topLeft, end: Alignment.bottomRight,
            colors: [AppThemes.primaryBlue, Color(0xFF1E3A8A)],
          ),
          borderRadius: BorderRadius.circular(AppThemes.radiusXl),
          boxShadow: [BoxShadow(color: AppThemes.primaryBlue.withOpacity(0.3), blurRadius: 30, offset: const Offset(0, 12))],
        ),
        child: Stack(
          children: [
            Positioned(
              right: -30, top: -30,
              child: AnimatedBuilder(
                animation: _pulseController,
                builder: (_, __) => Container(
                  width: 250 * _pulseController.value,
                  height: 250 * _pulseController.value,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withOpacity(0.05 * (1 - _pulseController.value)),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(color: Colors.white.withOpacity(0.2), borderRadius: BorderRadius.circular(20)),
                        child: Text("UNIT PCR-07", style: GoogleFonts.manrope(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 10, letterSpacing: 0.5)),
                      ),
                      const Spacer(),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(color: Colors.white.withOpacity(0.15), borderRadius: BorderRadius.circular(20)),
                        child: Text("EN ROUTE", style: GoogleFonts.manrope(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 10, letterSpacing: 0.5)),
                      ),
                    ],
                  ),
                  const Spacer(),
                  Text("ETA", style: GoogleFonts.manrope(color: Colors.white.withOpacity(0.7), fontSize: 12, letterSpacing: 2, fontWeight: FontWeight.w600)),
                  Text("04:32", style: GoogleFonts.plusJakartaSans(color: Colors.white, fontSize: 64, fontWeight: FontWeight.w800, height: 1)),
                  Text("En Route to Emergency", style: GoogleFonts.manrope(color: Colors.white.withOpacity(0.8), fontSize: 13)),
                ],
              ),
            ),
            Positioned(
              right: 20, bottom: 20,
              child: Icon(Icons.navigation_rounded, color: Colors.white.withOpacity(0.15), size: 80),
            ),
          ],
        ),
      ),
    );
  }

  Widget _sectionHeader(String title) {
    return Text(title, style: GoogleFonts.plusJakartaSans(fontSize: 11, fontWeight: FontWeight.w800, color: AppThemes.textMuted, letterSpacing: 2));
  }

  Widget _buildAgentFeed() {
    return SizedBox(
      height: 150,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: _agentCards.length,
        separatorBuilder: (_, __) => const SizedBox(width: 12),
        itemBuilder: (_, i) => _buildAgentCard(_agentCards[i]),
      ),
    );
  }

  Widget _buildAgentCard(Map<String, dynamic> agent) {
    final dotColor = agent['dotColor'] as Color;
    return GestureDetector(
      onTap: () { HapticFeedback.lightImpact(); _showAgentDetail(agent); },
      child: Container(
        width: 200,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(AppThemes.radiusXl),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 16, offset: const Offset(0, 4))],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(width: 8, height: 8, decoration: BoxDecoration(color: dotColor, shape: BoxShape.circle, boxShadow: [BoxShadow(color: dotColor.withOpacity(0.4), blurRadius: 6)])),
                const SizedBox(width: 8),
                Expanded(child: Text(agent['label'], style: GoogleFonts.manrope(fontSize: 10, fontWeight: FontWeight.w800, color: AppThemes.textMuted, letterSpacing: 1))),
              ],
            ),
            const SizedBox(height: 12),
            Icon(agent['icon'] as IconData, color: dotColor, size: 22),
            const SizedBox(height: 8),
            Text(agent['status'], style: GoogleFonts.plusJakartaSans(fontSize: 13, fontWeight: FontWeight.w800, color: AppThemes.textDark)),
            const SizedBox(height: 4),
            Text(agent['detail'], style: GoogleFonts.manrope(fontSize: 11, color: AppThemes.textMuted, height: 1.3)),
          ],
        ),
      ),
    );
  }

  Widget _buildAIDecisionCard() {
    return GestureDetector(
      onTap: () { HapticFeedback.lightImpact(); _showMLDetail(); },
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(AppThemes.radiusXl),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 16, offset: const Offset(0, 4))],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(color: AppThemes.primaryBlue.withOpacity(0.08), borderRadius: BorderRadius.circular(12)),
                  child: const Icon(Icons.auto_awesome_rounded, color: AppThemes.primaryBlue, size: 20),
                ),
                const SizedBox(width: 12),
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text("OPTIMAL ROUTE SELECTED", style: GoogleFonts.manrope(fontSize: 10, fontWeight: FontWeight.w800, color: AppThemes.primaryBlue, letterSpacing: 1)),
                  Text("Ring Road → NH-8 Bypass", style: GoogleFonts.plusJakartaSans(fontSize: 16, fontWeight: FontWeight.w800, color: AppThemes.textDark)),
                ]),
              ],
            ),
            const SizedBox(height: 20),
            Row(children: [
              _decisionStat("8.2 km", "DISTANCE"),
              _decisionDivider(),
              _decisionStat("4m 32s", "PREDICTED ETA"),
              _decisionDivider(),
              _decisionStat("94%", "CONFIDENCE"),
            ]),
            const SizedBox(height: 16),
            Row(
              children: [
                Icon(Icons.lan_rounded, size: 12, color: AppThemes.textMuted),
                const SizedBox(width: 6),
                Text("ML Model: Random Forest", style: GoogleFonts.manrope(fontSize: 11, color: AppThemes.textMuted)),
                const Spacer(),
                Text("View analysis →", style: GoogleFonts.manrope(fontSize: 11, color: AppThemes.primaryBlue, fontWeight: FontWeight.w700)),
              ],
            ),
            const SizedBox(height: 12),
            ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: 0.94,
                backgroundColor: AppThemes.primaryBlue.withOpacity(0.1),
                valueColor: const AlwaysStoppedAnimation<Color>(AppThemes.primaryBlue),
                minHeight: 6,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _decisionStat(String value, String label) {
    return Expanded(
      child: Column(children: [
        Text(value, style: GoogleFonts.plusJakartaSans(fontSize: 18, fontWeight: FontWeight.w800, color: AppThemes.textDark)),
        Text(label, style: GoogleFonts.manrope(fontSize: 9, color: AppThemes.textMuted, fontWeight: FontWeight.w700, letterSpacing: 0.5)),
      ]),
    );
  }

  Widget _decisionDivider() => Container(width: 1, height: 32, color: AppThemes.bgLight);

  Widget _buildAgentStatusGrid() {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      childAspectRatio: 2.2,
      children: _agentStatuses.map((agent) => _buildStatusMiniCard(agent)).toList(),
    );
  }

  Widget _buildStatusMiniCard(Map<String, dynamic> agent) {
    final color = agent['color'] as Color;
    final isProcessing = agent['status'] == 'Processing';
    return GestureDetector(
      onTap: () => HapticFeedback.selectionClick(),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(AppThemes.radiusLg),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 10)],
        ),
        child: Row(children: [
          Container(
            width: 32, height: 32,
            decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(8)),
            child: Icon(agent['icon'] as IconData, color: color, size: 16),
          ),
          const SizedBox(width: 10),
          Expanded(child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(agent['name'], style: GoogleFonts.manrope(fontSize: 11, fontWeight: FontWeight.w700, color: AppThemes.textDark)),
              Text(agent['status'], style: GoogleFonts.manrope(fontSize: 10, color: isProcessing ? const Color(0xFFB46000) : Colors.green.shade600, fontWeight: FontWeight.w600)),
            ],
          )),
        ]),
      ),
    );
  }

  Widget _buildNavBar() {
    return ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 24, sigmaY: 24),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.92),
            boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.08), blurRadius: 24, offset: const Offset(0, -4))],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // AI Status Strip
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                decoration: BoxDecoration(color: AppThemes.primaryBlue.withOpacity(0.04)),
                child: Row(
                  children: [
                    const Icon(Icons.psychology_rounded, size: 12, color: AppThemes.primaryBlue),
                    const SizedBox(width: 6),
                    Text("AI AGENTS", style: GoogleFonts.manrope(fontSize: 9, fontWeight: FontWeight.w800, color: AppThemes.primaryBlue, letterSpacing: 1.5)),
                    const SizedBox(width: 12),
                    _agentDot("TRAFFIC", const Color(0xFFBA1A1A)),
                    const SizedBox(width: 8),
                    _agentDot("WEATHER", const Color(0xFFB46000)),
                    const SizedBox(width: 8),
                    _agentDot("ROAD", Colors.green),
                    const Spacer(),
                    AnimatedBuilder(
                      animation: _pulseController,
                      builder: (_, __) => Container(
                        width: 6, height: 6,
                        decoration: BoxDecoration(
                          color: Colors.green.withOpacity(0.5 + 0.5 * _pulseController.value),
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                    const SizedBox(width: 4),
                    Text("ALL ACTIVE", style: GoogleFonts.manrope(fontSize: 9, fontWeight: FontWeight.w700, color: Colors.green.shade600)),
                  ],
                ),
              ),
              // Navigation Tabs
              SafeArea(
                top: false,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                  child: Row(
                    children: [
                      _navItem(0, Icons.map_rounded, "Map", () => Navigator.push(context, MaterialPageRoute(builder: (_) => const LiveNavigationPage()))),
                      _navItem(1, Icons.warning_amber_rounded, "Alerts", () => Navigator.push(context, MaterialPageRoute(builder: (_) => const AlertCenterPage()))),
                      _navItem(2, Icons.chat_bubble_rounded, "Chat", () => Navigator.push(context, MaterialPageRoute(builder: (_) => const DispatchCommunicationsPage()))),
                      _navItem(3, Icons.add_location_alt_rounded, "Dispatch", () => Navigator.push(context, MaterialPageRoute(builder: (_) => const DestinationSelectionPage()))),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _agentDot(String label, Color color) {
    return Row(children: [
      Container(width: 6, height: 6, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
      const SizedBox(width: 3),
      Text(label, style: GoogleFonts.manrope(fontSize: 8, fontWeight: FontWeight.w700, color: color, letterSpacing: 0.5)),
    ]);
  }

  Widget _navItem(int index, IconData icon, String label, VoidCallback onTap) {
    final isActive = _navIndex == index;
    return Expanded(
      child: GestureDetector(
        onTap: () { HapticFeedback.selectionClick(); setState(() => _navIndex = index); onTap(); },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          margin: const EdgeInsets.symmetric(horizontal: 4),
          padding: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            color: isActive ? AppThemes.primaryBlue.withOpacity(0.08) : Colors.transparent,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: isActive ? AppThemes.primaryBlue : Colors.transparent,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, size: 20, color: isActive ? Colors.white : AppThemes.textMuted),
              ),
              const SizedBox(height: 4),
              Text(
                label,
                style: GoogleFonts.manrope(
                  fontSize: 10,
                  fontWeight: isActive ? FontWeight.w800 : FontWeight.w600,
                  color: isActive ? AppThemes.primaryBlue : AppThemes.textMuted,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showAgentDetail(Map<String, dynamic> agent) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
        child: Container(
          margin: const EdgeInsets.all(16),
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(AppThemes.radiusXl)),
          child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(children: [
              Icon(agent['icon'] as IconData, color: agent['dotColor'] as Color, size: 24),
              const SizedBox(width: 12),
              Text(agent['label'], style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w800, fontSize: 18, color: AppThemes.textDark)),
            ]),
            const SizedBox(height: 16),
            Text(agent['status'], style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w800, fontSize: 16, color: agent['dotColor'] as Color)),
            const SizedBox(height: 8),
            Text(agent['detail'], style: GoogleFonts.manrope(fontSize: 15, color: AppThemes.textMuted, height: 1.5)),
            const SizedBox(height: 20),
            Text("AI Recommendation", style: GoogleFonts.manrope(fontWeight: FontWeight.w700, color: AppThemes.textMuted, fontSize: 12)),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(color: AppThemes.bgLight, borderRadius: BorderRadius.circular(AppThemes.radiusLg)),
              child: Text("Reroute via Ring Road North to avoid identified disruption. Estimated delay savings: 14 minutes.", style: GoogleFonts.manrope(fontSize: 14, color: AppThemes.textDark, height: 1.5)),
            ),
            const SizedBox(height: 16),
          ]),
        ),
      ),
    );
  }

  void _showMLDetail() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (_) => Container(
        margin: const EdgeInsets.all(16),
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(AppThemes.radiusXl)),
        child: Column(mainAxisSize: MainAxisSize.min, crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text("ML Model Analysis", style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w800, fontSize: 20, color: AppThemes.textDark)),
          const SizedBox(height: 4),
          Text("Random Forest Regression", style: GoogleFonts.manrope(fontSize: 13, color: AppThemes.textMuted)),
          const SizedBox(height: 20),
          ...[["Distance", "8.2 km"], ["Traffic Density", "HIGH on NH-8, LOW on Ring Road"], ["Weather Condition", "Foggy — 200m visibility"], ["Road Blockage", "0 on selected route"]].map(
            (f) => Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Container(width: 4, height: 4, margin: const EdgeInsets.only(top: 6), decoration: const BoxDecoration(color: AppThemes.primaryBlue, shape: BoxShape.circle)),
                const SizedBox(width: 10),
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(f[0], style: GoogleFonts.manrope(fontSize: 11, fontWeight: FontWeight.w800, color: AppThemes.textMuted, letterSpacing: 1)),
                  Text(f[1], style: GoogleFonts.manrope(fontSize: 13, color: AppThemes.textDark)),
                ]),
              ]),
            ),
          ).toList(),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(color: AppThemes.primaryBlue.withOpacity(0.06), borderRadius: BorderRadius.circular(AppThemes.radiusLg)),
            child: Row(children: [
              const Icon(Icons.check_circle_rounded, color: AppThemes.primaryBlue, size: 20),
              const SizedBox(width: 12),
              Text("Predicted Travel Time: 4m 32s @ 94% confidence", style: GoogleFonts.manrope(fontSize: 13, fontWeight: FontWeight.w700, color: AppThemes.primaryBlue)),
            ]),
          ),
          const SizedBox(height: 8),
        ]),
      ),
    );
  }
}
