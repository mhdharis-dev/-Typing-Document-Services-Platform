import 'package:flutter/material.dart';
import '../../app/theme/app_colors.dart';
import '../../app/theme/app_text_styles.dart';

enum AppButtonType { primary, secondary, outline, text, danger }

class AppButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final AppButtonType type;
  final IconData? icon;
  final bool isLoading;
  final bool isFullWidth;
  final double? width;
  final double height;

  const AppButton({
    super.key,
    required this.text,
    this.onPressed,
    this.type = AppButtonType.primary,
    this.icon,
    this.isLoading = false,
    this.isFullWidth = false,
    this.width,
    this.height = 46,
  });

  @override
  Widget build(BuildContext context) {
    final Widget child = isLoading
        ? SizedBox(
            height: 20,
            width: 20,
            child: CircularProgressIndicator(
              strokeWidth: 2.5,
              valueColor: AlwaysStoppedAnimation<Color>(
                type == AppButtonType.outline || type == AppButtonType.text
                    ? AppColors.primary
                    : Colors.white,
              ),
            ),
          )
        : Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (icon != null) ...[
                Icon(icon, size: 18),
                const SizedBox(width: 8),
              ],
              Text(
                text,
                style: _getTextStyle(),
              ),
            ],
          );

    final Widget buttonWidget;
    switch (type) {
      case AppButtonType.primary:
        buttonWidget = ElevatedButton(
          onPressed: isLoading ? null : onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primary,
            foregroundColor: Colors.white,
            minimumSize: Size(width ?? 0, height),
          ),
          child: child,
        );
        break;
      case AppButtonType.secondary:
        buttonWidget = ElevatedButton(
          onPressed: isLoading ? null : onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.primaryLight,
            foregroundColor: AppColors.primaryDark,
            minimumSize: Size(width ?? 0, height),
          ),
          child: child,
        );
        break;
      case AppButtonType.outline:
        buttonWidget = OutlinedButton(
          onPressed: isLoading ? null : onPressed,
          style: OutlinedButton.styleFrom(
            minimumSize: Size(width ?? 0, height),
          ),
          child: child,
        );
        break;
      case AppButtonType.text:
        buttonWidget = TextButton(
          onPressed: isLoading ? null : onPressed,
          style: TextButton.styleFrom(
            minimumSize: Size(width ?? 0, height),
          ),
          child: child,
        );
        break;
      case AppButtonType.danger:
        buttonWidget = ElevatedButton(
          onPressed: isLoading ? null : onPressed,
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.error,
            foregroundColor: Colors.white,
            minimumSize: Size(width ?? 0, height),
          ),
          child: child,
        );
        break;
    }

    if (isFullWidth) {
      return SizedBox(
        width: double.infinity,
        child: buttonWidget,
      );
    }

    return buttonWidget;
  }

  TextStyle _getTextStyle() {
    switch (type) {
      case AppButtonType.primary:
      case AppButtonType.danger:
        return AppTextStyles.button.copyWith(color: Colors.white);
      case AppButtonType.secondary:
        return AppTextStyles.button.copyWith(color: AppColors.primaryDark);
      case AppButtonType.outline:
      case AppButtonType.text:
        return AppTextStyles.button.copyWith(color: AppColors.primary);
    }
  }
}
