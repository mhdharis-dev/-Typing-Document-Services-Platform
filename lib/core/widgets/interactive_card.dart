import 'package:flutter/material.dart';
import '../../app/theme/app_colors.dart';

class InteractiveCard extends StatefulWidget {
  final Widget child;
  final VoidCallback? onTap;
  final EdgeInsetsGeometry? padding;
  final Color? backgroundColor;
  final Color? borderColor;
  final double borderRadius;
  final double elevation;

  const InteractiveCard({
    super.key,
    required this.child,
    this.onTap,
    this.padding,
    this.backgroundColor,
    this.borderColor,
    this.borderRadius = 12.0,
    this.elevation = 0.0,
  });

  @override
  State<InteractiveCard> createState() => _InteractiveCardState();
}

class _InteractiveCardState extends State<InteractiveCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final effectiveBorderColor = _isHovered
        ? AppColors.primary
        : (widget.borderColor ?? AppColors.border);

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      cursor: widget.onTap != null ? SystemMouseCursors.click : SystemMouseCursors.basic,
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOutCubic,
          transform: _isHovered ? Matrix4.translationValues(0, -3, 0) : Matrix4.identity(),
          padding: widget.padding ?? const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: widget.backgroundColor ?? AppColors.surface,
            borderRadius: BorderRadius.circular(widget.borderRadius),
            border: Border.all(color: effectiveBorderColor, width: _isHovered ? 1.5 : 1.0),
            boxShadow: _isHovered
                ? [
                    BoxShadow(
                      color: AppColors.primary.withValues(alpha: 0.12),
                      blurRadius: 16,
                      offset: const Offset(0, 8),
                    ),
                  ]
                : (widget.elevation > 0
                    ? [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.04),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ]
                    : []),
          ),
          child: widget.child,
        ),
      ),
    );
  }
}
