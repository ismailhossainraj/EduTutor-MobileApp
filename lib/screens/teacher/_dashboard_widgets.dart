// ignore_for_file: deprecated_member_use, prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';

/// Responsive Dashboard Stat Card
class DashboardStatCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;

  const DashboardStatCard({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: 0.95, end: 1.0),
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeOutBack,
      builder: (context, scale, child) {
        return Transform.scale(
          scale: scale,
          child: Card(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            elevation: 6,
            shadowColor: color.withValues(alpha: 0.35),
            child: ConstrainedBox(
              constraints: const BoxConstraints(
                  minWidth: 110, maxWidth: 260, minHeight: 100, maxHeight: 180),
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      color.withValues(alpha: 0.95),
                      color.withValues(alpha: 0.65)
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
                padding:
                    const EdgeInsets.symmetric(vertical: 12, horizontal: 14),
                child: LayoutBuilder(builder: (context, constraints) {
                  final isNarrow = constraints.maxWidth < 140;
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      CircleAvatar(
                        radius: isNarrow ? 18 : 22,
                        backgroundColor: Colors.white.withValues(alpha: 0.18),
                        child: Icon(icon,
                            color: Colors.white, size: isNarrow ? 20 : 24),
                      ),
                      SizedBox(height: isNarrow ? 8 : 12),
                      FittedBox(
                        fit: BoxFit.scaleDown,
                        child: Text(value,
                            style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.white)),
                      ),
                      SizedBox(height: isNarrow ? 4 : 6),
                      Text(label,
                          style: TextStyle(
                              fontSize: isNarrow ? 12 : 13,
                              color: Colors.white70)),
                    ],
                  );
                }),
              ),
            ),
          ),
        );
      },
    );
  }
}

/// Responsive Quick Action Button
class QuickActionButton extends StatefulWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const QuickActionButton({
    required this.icon,
    required this.label,
    required this.onTap,
    Key? key,
  }) : super(key: key);

  @override
  State<QuickActionButton> createState() => _QuickActionButtonState();
}

class _QuickActionButtonState extends State<QuickActionButton> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) {
        setState(() => _isPressed = false);
        widget.onTap();
      },
      onTapCancel: () => setState(() => _isPressed = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        curve: Curves.easeOut,
        transform: Matrix4.identity()..scale(_isPressed ? 0.97 : 1.0),
        child: ConstrainedBox(
          constraints: const BoxConstraints(
              minWidth: 100, maxWidth: 240, minHeight: 80, maxHeight: 120),
          child: Container(
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                  colors: [Colors.blueAccent, Colors.lightBlueAccent],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight),
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                    color: Colors.black12, blurRadius: 6, offset: Offset(0, 3))
              ],
            ),
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
            child: LayoutBuilder(builder: (context, constraints) {
              final isCompact = constraints.maxWidth < 140;
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(widget.icon,
                      size: isCompact ? 22 : 28, color: Colors.white),
                  SizedBox(height: isCompact ? 6 : 10),
                  Flexible(
                    child: Text(widget.label,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: isCompact ? 12 : 14, color: Colors.white),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis),
                  ),
                ],
              );
            }),
          ),
        ),
      ),
    );
  }
}
