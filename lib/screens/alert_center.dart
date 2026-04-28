import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:res_q_route/theme/app_themes.dart';

class AlertCenterPage extends StatefulWidget {
  const AlertCenterPage({super.key});

  @override
  State<AlertCenterPage> createState() => _AlertCenterPageState();
}

class _AlertCenterPageState extends State<AlertCenterPage> with SingleTickerProviderStateMixin {
  String _filter = "All";
  late AnimationController _blinkController;

  final List<String> _filters = ["All", "Traffic", "Weather", "Road"];

  final List<Map<String, dynamic>> _alerts = [
    {
      'severity': 'critical',
      'dotColor': Color(0xFFBA1A1A),
      'title': 'NH-8 HIGHWAY — SEVERE CONGESTION',
      'time': '2 min ago',
      'body': '7km backup between Mahipalpur and Dhaula Kuan',
      'category': 'Traffic',
      'action': 'REROUTE NOW',
      'actionColor': Color(0xFFBA1A1A),
    },
    {
      'severity': 'critical',
      'dotColor': Color(0xFFBA1A1A),
      'title': 'SECTOR 21 UNDERPASS — BLOCKED',
      'time': '5 min ago',
      'body': 'Police barricade, accident clearance in progress',
      'category': 'Road',
      'action': 'AVOID ROUTE',
      'actionColor': Color(0xFFBA1A1A),
    },
    {
      'severity': 'advisory',
      'dotColor': Color(0xFFB46000),
      'title': 'FOG ADVISORY — OUTER RING ROAD',
      'time': '8 min ago',
      'body': 'Visibility 200m, AI speed recommendation: 40km/h',
      'category': 'Weather',
      'action': 'VIEW ON MAP',
      'actionColor': Color(0xFF00236f),
    },
    {
      'severity': 'advisory',
      'dotColor': Color(0xFFB46000),
      'title': 'CONSTRUCTION ZONE — MG ROAD',
      'time': '15 min ago',
      'body': 'Active until 6 PM, one lane open',
      'category': 'Road',
      'action': 'VIEW ON MAP',
      'actionColor': Color(0xFF00236f),
    },
    {
      'severity': 'info',
      'dotColor': Color(0xFF00236f),
      'title': 'HOSPITAL GATE STATUS — AIIMS GATE 3 OPEN',
      'time': '1 min ago',
      'body': 'Priority lane access confirmed for emergency vehicles',
      'category': 'Road',
      'action': null,
      'actionColor': null,
    },
  ];

  @override
  void initState() {
    super.initState();
    _blinkController = AnimationController(vsync: this, duration: const Duration(milliseconds: 800))..repeat(reverse: true);
  }

  @override
  void dispose() {
    _blinkController.dispose();
    super.dispose();
  }

  List<Map<String, dynamic>> get _filteredAlerts => _filter == "All"
      ? _alerts
      : _alerts.where((a) => a['category'] == _filter).toList();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppThemes.bgLight,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
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
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Alert Center", style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w800, fontSize: 20, color: AppThemes.textDark)),
                Text("${_filteredAlerts.length} active disruptions", style: GoogleFonts.manrope(fontSize: 12, color: AppThemes.textMuted)),
              ],
            ),
            bottom: PreferredSize(
              preferredSize: const Size.fromHeight(52),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
                child: SizedBox(
                  height: 36,
                  child: ListView.separated(
                    scrollDirection: Axis.horizontal,
                    itemCount: _filters.length,
                    separatorBuilder: (_, __) => const SizedBox(width: 8),
                    itemBuilder: (_, i) => _filterChip(_filters[i]),
                  ),
                ),
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.all(20),
            sliver: SliverList(
              delegate: SliverChildListDelegate([
                ..._buildSection("CRITICAL ALERTS", 'critical'),
                ..._buildSection("ADVISORY ALERTS", 'advisory'),
                ..._buildSection("INFORMATION", 'info'),
                const SizedBox(height: 80),
              ]),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          HapticFeedback.mediumImpact();
          _showReportSheet(context);
        },
        backgroundColor: AppThemes.primaryBlue,
        elevation: 4,
        child: const Icon(Icons.add_rounded, color: Colors.white, size: 28),
      ),
    );
  }

  List<Widget> _buildSection(String title, String severity) {
    final items = _filteredAlerts.where((a) => a['severity'] == severity).toList();
    if (items.isEmpty) return [];
    return [
      Text(title, style: GoogleFonts.plusJakartaSans(fontSize: 11, fontWeight: FontWeight.w800, color: AppThemes.textMuted, letterSpacing: 2)),
      const SizedBox(height: 12),
      ...items.map((alert) => Padding(padding: const EdgeInsets.only(bottom: 12), child: _buildAlertCard(alert))).toList(),
      const SizedBox(height: 20),
    ];
  }

  Widget _filterChip(String label) {
    final isSelected = _filter == label;
    return GestureDetector(
      onTap: () { HapticFeedback.selectionClick(); setState(() => _filter = label); },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected ? AppThemes.primaryBlue : Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(label, style: GoogleFonts.manrope(fontSize: 12, fontWeight: FontWeight.w700, color: isSelected ? Colors.white : AppThemes.textMuted)),
      ),
    );
  }

  Widget _buildAlertCard(Map<String, dynamic> alert) {
    final dotColor = alert['dotColor'] as Color;
    final severity = alert['severity'] as String;
    final isCritical = severity == 'critical';
    final isInfo = severity == 'info';

    Color? accentColor = isCritical ? const Color(0xFFBA1A1A) : (isInfo ? AppThemes.primaryBlue : const Color(0xFFB46000));

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppThemes.radiusXl),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 16, offset: const Offset(0, 4))],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(AppThemes.radiusXl),
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(width: 4, color: accentColor),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          AnimatedBuilder(
                            animation: _blinkController,
                            builder: (_, __) => Container(
                              width: 8, height: 8,
                              decoration: BoxDecoration(
                                color: isCritical ? dotColor.withOpacity(0.5 + 0.5 * _blinkController.value) : dotColor,
                                shape: BoxShape.circle,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(child: Text(alert['title'], style: GoogleFonts.plusJakartaSans(fontSize: 12, fontWeight: FontWeight.w800, color: AppThemes.textDark, letterSpacing: 0.2))),
                          Text(alert['time'], style: GoogleFonts.manrope(fontSize: 11, color: AppThemes.textMuted)),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(alert['body'], style: GoogleFonts.manrope(fontSize: 13, color: AppThemes.textMuted, height: 1.4)),
                      if (alert['action'] != null) ...[
                        const SizedBox(height: 12),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () => HapticFeedback.lightImpact(),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: (alert['actionColor'] as Color).withOpacity(0.1),
                              foregroundColor: alert['actionColor'] as Color,
                              elevation: 0,
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppThemes.radiusLg)),
                            ),
                            child: Text(alert['action'], style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w800, fontSize: 12, letterSpacing: 0.5)),
                          ),
                        ),
                      ],
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

  void _showReportSheet(BuildContext context) {
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
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Report New Incident", style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w800, fontSize: 22, color: AppThemes.textDark)),
              const SizedBox(height: 8),
              Text("Select incident type to report to the AI routing system.", style: GoogleFonts.manrope(fontSize: 14, color: AppThemes.textMuted)),
              const SizedBox(height: 24),
              ...["Traffic Congestion", "Road Blockage", "Accident", "Weather Hazard", "Construction Zone"].map((type) => ListTile(
                contentPadding: EdgeInsets.zero,
                leading: Container(width: 40, height: 40, decoration: BoxDecoration(color: AppThemes.primaryBlue.withOpacity(0.08), borderRadius: BorderRadius.circular(12)),
                  child: Icon(Icons.report_problem_outlined, color: AppThemes.primaryBlue, size: 20)),
                title: Text(type, style: GoogleFonts.manrope(fontWeight: FontWeight.w700, color: AppThemes.textDark)),
                trailing: const Icon(Icons.chevron_right_rounded, color: AppThemes.textMuted),
                onTap: () { HapticFeedback.lightImpact(); Navigator.pop(context); },
              )).toList(),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }
}
