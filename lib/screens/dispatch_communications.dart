import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:res_q_route/theme/app_themes.dart';

class DispatchCommunicationsPage extends StatefulWidget {
  const DispatchCommunicationsPage({super.key});

  @override
  State<DispatchCommunicationsPage> createState() => _DispatchCommunicationsPageState();
}

class _DispatchCommunicationsPageState extends State<DispatchCommunicationsPage> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  final List<Map<String, dynamic>> _messages = [
    {'sender': 'DISPATCH', 'text': 'Unit PCR-07, reroute confirmed. Avoid NH-8. Ring Road bypass is clear.', 'time': '10:32 AM', 'type': 'received'},
    {'sender': 'UNIT PCR-07', 'text': 'Acknowledged. En route via Ring Road. ETA 4 min.', 'time': '10:33 AM', 'type': 'sent'},
    {'sender': 'AI AGENT', 'text': '⚡ ROUTE UPDATE: AI detected 2-min faster path via MG Road. Confidence: 94%. Applying in 10s unless overridden.', 'time': '10:34 AM', 'type': 'ai'},
    {'sender': 'DISPATCH', 'text': 'Confirm AI recommendation. Proceed via MG Road.', 'time': '10:34 AM', 'type': 'received'},
    {'sender': 'UNIT PCR-07', 'text': 'Confirmed. Switching to MG Road route.', 'time': '10:35 AM', 'type': 'sent'},
  ];

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _sendMessage() {
    if (_messageController.text.trim().isEmpty) return;
    HapticFeedback.lightImpact();
    setState(() {
      _messages.add({
        'sender': 'UNIT PCR-07',
        'text': _messageController.text.trim(),
        'time': _currentTime(),
        'type': 'sent',
      });
      _messageController.clear();
    });
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  String _currentTime() {
    final now = DateTime.now();
    final hour = now.hour > 12 ? now.hour - 12 : now.hour;
    final min = now.minute.toString().padLeft(2, '0');
    final ampm = now.hour >= 12 ? 'PM' : 'AM';
    return '$hour:$min $ampm';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF1F3F9),
      body: Column(
        children: [
          _buildAppBar(context),
          _buildStatusBanner(),
          Expanded(child: _buildMessageList()),
          _buildQuickActions(),
          _buildInputBar(),
        ],
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 24, sigmaY: 24),
        child: Container(
          padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top + 8, left: 16, right: 16, bottom: 12),
          color: Colors.white.withOpacity(0.85),
          child: Row(
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back_ios_new_rounded, color: AppThemes.textDark, size: 20),
                onPressed: () => Navigator.pop(context),
              ),
              const SizedBox(width: 4),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("DISPATCH OPS", style: GoogleFonts.plusJakartaSans(fontWeight: FontWeight.w800, fontSize: 16, color: AppThemes.textDark, letterSpacing: 0.5)),
                    Row(
                      children: [
                        Container(width: 6, height: 6, decoration: const BoxDecoration(color: Colors.green, shape: BoxShape.circle)),
                        const SizedBox(width: 6),
                        Text("SECURE CHANNEL • UNIT 402", style: GoogleFonts.manrope(fontSize: 10, color: AppThemes.textMuted, fontWeight: FontWeight.w700, letterSpacing: 0.5)),
                      ],
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(color: AppThemes.primaryBlue.withOpacity(0.08), borderRadius: BorderRadius.circular(12)),
                child: const Icon(Icons.hub_rounded, color: AppThemes.primaryBlue, size: 20),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatusBanner() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      decoration: const BoxDecoration(
        color: AppThemes.primaryBlue,
      ),
      child: Row(
        children: [
          const Icon(Icons.emergency_rounded, color: Colors.white, size: 18),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              "MISSION ACTIVE: SECTOR 12 DISPATCH",
              style: GoogleFonts.plusJakartaSans(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 11, letterSpacing: 1),
            ),
          ),
          Text(
            "ETA 4:32",
            style: GoogleFonts.plusJakartaSans(color: Colors.white, fontWeight: FontWeight.w900, fontSize: 11),
          ),
        ],
      ),
    );
  }

  Widget _buildMessageList() {
    return ListView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      itemCount: _messages.length,
      itemBuilder: (_, i) => _buildMessage(_messages[i]),
    );
  }

  Widget _buildMessage(Map<String, dynamic> msg) {
    final isSent = msg['type'] == 'sent';
    final isAI = msg['type'] == 'ai';

    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: isSent ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: isSent ? MainAxisAlignment.end : MainAxisAlignment.start,
            children: [
              if (!isSent) ...[
                Text(msg['sender'], style: GoogleFonts.manrope(fontSize: 9, fontWeight: FontWeight.w800, color: isAI ? const Color(0xFF0D9488) : AppThemes.textMuted, letterSpacing: 1)),
                const SizedBox(width: 8),
              ],
              Text(msg['time'], style: GoogleFonts.manrope(fontSize: 9, color: AppThemes.textMuted.withOpacity(0.5))),
              if (isSent) ...[
                const SizedBox(width: 8),
                Text("YOU", style: GoogleFonts.manrope(fontSize: 9, fontWeight: FontWeight.w800, color: AppThemes.primaryBlue, letterSpacing: 1)),
              ],
            ],
          ),
          const SizedBox(height: 6),
          Container(
            padding: const EdgeInsets.all(16),
            constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.75),
            decoration: BoxDecoration(
              color: isSent ? AppThemes.primaryBlue : (isAI ? const Color(0xFFF0FDFA) : Colors.white),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(isSent ? 20 : 4),
                topRight: Radius.circular(isSent ? 4 : 20),
                bottomLeft: const Radius.circular(20),
                bottomRight: const Radius.circular(20),
              ),
              boxShadow: [
                BoxShadow(
                  color: (isSent ? AppThemes.primaryBlue : Colors.black).withOpacity(isSent ? 0.2 : 0.04),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                )
              ],
              border: isAI ? Border.all(color: const Color(0xFF99F6E4), width: 1) : null,
            ),
            child: Text(
              msg['text'],
              style: GoogleFonts.manrope(
                fontSize: 14,
                color: isSent ? Colors.white : (isAI ? const Color(0xFF0F766E) : AppThemes.textDark),
                height: 1.5,
                fontWeight: isAI ? FontWeight.w600 : FontWeight.w500,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActions() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Colors.black.withOpacity(0.05))),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            _quickAction("Status Update", Icons.update_rounded, false),
            _quickAction("Req. Backup", Icons.groups_rounded, false),
            _quickAction("Arrival Signal", Icons.check_circle_rounded, true),
          ],
        ),
      ),
    );
  }

  Widget _quickAction(String label, IconData icon, bool primary) {
    return GestureDetector(
      onTap: () => HapticFeedback.lightImpact(),
      child: Container(
        margin: const EdgeInsets.only(right: 12),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: primary ? AppThemes.primaryBlue : const Color(0xFFF8FAFC),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: primary ? Colors.transparent : const Color(0xFFE2E8F0)),
        ),
        child: Row(
          children: [
            Icon(icon, size: 16, color: primary ? Colors.white : AppThemes.primaryBlue),
            const SizedBox(width: 8),
            Text(label, style: GoogleFonts.plusJakartaSans(fontSize: 12, fontWeight: FontWeight.w700, color: primary ? Colors.white : AppThemes.textDark)),
          ],
        ),
      ),
    );
  }

  Widget _buildInputBar() {
    return Container(
      padding: EdgeInsets.fromLTRB(20, 12, 20, MediaQuery.of(context).padding.bottom + 12),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 20, offset: const Offset(0, -5))],
      ),
      child: Row(
        children: [
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: const Color(0xFFF1F5F9),
                borderRadius: BorderRadius.circular(24),
              ),
              child: Row(
                children: [
                  const Icon(Icons.mic_none_rounded, color: AppThemes.textMuted, size: 20),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextField(
                      controller: _messageController,
                      style: GoogleFonts.manrope(fontSize: 14),
                      decoration: InputDecoration(
                        hintText: "Type a secure message...",
                        hintStyle: GoogleFonts.manrope(color: AppThemes.textMuted.withOpacity(0.5), fontSize: 14),
                        border: InputBorder.none,
                        isDense: true,
                        contentPadding: const EdgeInsets.symmetric(vertical: 12),
                      ),
                      onSubmitted: (_) => _sendMessage(),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(width: 12),
          GestureDetector(
            onTap: _sendMessage,
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: const BoxDecoration(
                color: AppThemes.primaryBlue,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.send_rounded, color: Colors.white, size: 20),
            ),
          ),
        ],
      ),
    );
  }
}
