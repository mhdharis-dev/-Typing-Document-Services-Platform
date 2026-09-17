import 'package:flutter/material.dart';
import '../../app/theme/app_colors.dart';
import '../../app/theme/app_text_styles.dart';

class AppLogo extends StatelessWidget {
  final double iconSize;
  final TextStyle? textStyle;
  final bool showTagline;

  const AppLogo({
    super.key,
    this.iconSize = 28,
    this.textStyle,
    this.showTagline = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          padding: EdgeInsets.all(iconSize * 0.25),
          decoration: BoxDecoration(
            color: AppColors.primary,
            borderRadius: BorderRadius.circular(iconSize * 0.35),
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withAlpha(50),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Icon(
            Icons.verified_user_rounded,
            color: Colors.white,
            size: iconSize,
          ),
        ),
        const SizedBox(width: 10),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: 'APEX ',
                    style: (textStyle ?? AppTextStyles.h3).copyWith(
                      fontWeight: FontWeight.w800,
                      color: AppColors.primary,
                      letterSpacing: 0.5,
                    ),
                  ),
                  TextSpan(
                    text: 'SERVICES',
                    style: (textStyle ?? AppTextStyles.h3).copyWith(
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                      letterSpacing: 0.5,
                    ),
                  ),
                ],
              ),
            ),
            if (showTagline)
              Text(
                'Typing & Document Solutions',
                style: AppTextStyles.bodySmall.copyWith(
                  color: AppColors.textSecondary,
                  fontSize: 10,
                ),
              ),
          ],
        ),
      ],
    );
  }
}
