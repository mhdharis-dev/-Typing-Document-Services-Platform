import 'package:flutter/material.dart';
import '../../app/theme/app_colors.dart';
import '../../app/theme/app_text_styles.dart';

class AppSearchField extends StatelessWidget {
  final String hintText;
  final ValueChanged<String> onChanged;
  final TextEditingController? controller;
  final VoidCallback? onClear;

  const AppSearchField({
    super.key,
    this.hintText = 'Search for a service...',
    required this.onChanged,
    this.controller,
    this.onClear,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.border),
        boxShadow: const [
          BoxShadow(
            color: Color(0x05000000),
            blurRadius: 6,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: TextField(
        controller: controller,
        onChanged: onChanged,
        style: AppTextStyles.bodyMedium,
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: AppTextStyles.bodyMedium.copyWith(color: AppColors.textMuted),
          prefixIcon: const Icon(Icons.search_rounded, color: AppColors.primary, size: 22),
          suffixIcon: controller != null && controller!.text.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.close_rounded, size: 18, color: AppColors.textSecondary),
                  onPressed: () {
                    controller!.clear();
                    onChanged('');
                    if (onClear != null) onClear!();
                  },
                )
              : null,
          border: InputBorder.none,
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        ),
      ),
    );
  }
}
