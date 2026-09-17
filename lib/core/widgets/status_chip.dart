import 'package:flutter/material.dart';
import '../../app/theme/app_colors.dart';
import '../../app/theme/app_text_styles.dart';

class StatusChip extends StatelessWidget {
  final String status;

  const StatusChip({
    super.key,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    final styleConfig = _getStyleConfig(status);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: styleConfig.backgroundColor,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: styleConfig.borderColor, width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(
              color: styleConfig.textColor,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 6),
          Text(
            status,
            style: AppTextStyles.bodySmall.copyWith(
              color: styleConfig.textColor,
              fontWeight: FontWeight.w600,
              fontSize: 11,
            ),
          ),
        ],
      ),
    );
  }

  _StatusStyle _getStyleConfig(String status) {
    final lower = status.toLowerCase();
    if (lower.contains('submitted')) {
      return _StatusStyle(
        backgroundColor: AppColors.infoLight,
        borderColor: AppColors.info.withAlpha(80),
        textColor: AppColors.info,
      );
    } else if (lower.contains('review') || lower.contains('pending')) {
      return _StatusStyle(
        backgroundColor: AppColors.warningLight,
        borderColor: AppColors.warning.withAlpha(80),
        textColor: AppColors.warning,
      );
    } else if (lower.contains('document') || lower.contains('required')) {
      return _StatusStyle(
        backgroundColor: AppColors.errorLight,
        borderColor: AppColors.error.withAlpha(80),
        textColor: AppColors.error,
      );
    } else if (lower.contains('processing')) {
      return _StatusStyle(
        backgroundColor: AppColors.primaryLight,
        borderColor: AppColors.primary.withAlpha(80),
        textColor: AppColors.primary,
      );
    } else if (lower.contains('complete') || lower.contains('active')) {
      return _StatusStyle(
        backgroundColor: AppColors.successLight,
        borderColor: AppColors.success.withAlpha(80),
        textColor: AppColors.success,
      );
    } else if (lower.contains('cancel') || lower.contains('disable')) {
      return _StatusStyle(
        backgroundColor: AppColors.background,
        borderColor: AppColors.border,
        textColor: AppColors.textSecondary,
      );
    } else {
      return _StatusStyle(
        backgroundColor: AppColors.primaryLight,
        borderColor: AppColors.primary.withAlpha(80),
        textColor: AppColors.primary,
      );
    }
  }
}

class _StatusStyle {
  final Color backgroundColor;
  final Color borderColor;
  final Color textColor;

  _StatusStyle({
    required this.backgroundColor,
    required this.borderColor,
    required this.textColor,
  });
}
