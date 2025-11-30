// ignore_for_file: deprecated_member_use, prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';

/// Dashboard Stat Card with attractive design
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
      tween: Tween<double>(begin: 0.9, end: 1.0),
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeOutBack,
      builder: (context, scale, child) {
        return Transform.scale(
          scale: scale,
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18),
            ),
            elevation: 6,
            shadowColor: color.withOpacity(0.4),
            child: Container(
              width: 120,
              height: 130,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [color.withOpacity(0.9), color.withOpacity(0.6)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(18),
              ),
              padding: const EdgeInsets.all(14),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircleAvatar(
                    radius: 24,
                    backgroundColor: Colors.white.withOpacity(0.2),
                    child: Icon(icon, color: Colors.white, size: 28),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    value,
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    label,
                    style: TextStyle(fontSize: 15, color: Colors.white70),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

/// Quick Action Button with press animation
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
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOut,
        transform: Matrix4.identity()..scale(_isPressed ? 0.95 : 1.0),
        width: 130,
        height: 100,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.blueAccent, Colors.lightBlueAccent],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.blue.withOpacity(0.2),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(widget.icon, size: 34, color: Colors.white),
            const SizedBox(height: 8),
            Text(
              widget.label,
              style: const TextStyle(fontSize: 15, color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}
