import 'package:flutter/material.dart';
import 'package:res_q_route/theme/app_themes.dart';

class MissionPulse extends StatefulWidget {
  final Widget child;
  final Color color;
  const MissionPulse({super.key, required this.child, this.color = AppThemes.primaryBlue});

  @override
  State<MissionPulse> createState() => _MissionPulseState();
}

class _MissionPulseState extends State<MissionPulse> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return Container(
              width: 300 * _controller.value,
              height: 300 * _controller.value,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: RadialGradient(
                  colors: [
                    widget.color.withOpacity(0.15 * (1 - _controller.value)),
                    widget.color.withOpacity(0),
                  ],
                ),
              ),
            );
          },
        ),
        widget.child,
      ],
    );
  }
}
