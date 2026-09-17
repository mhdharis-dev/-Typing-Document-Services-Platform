import 'package:flutter/material.dart';
import '../../app/theme/app_colors.dart';
import '../../app/theme/app_text_styles.dart';

class FloatingWhatsappWidget extends StatefulWidget {
  const FloatingWhatsappWidget({super.key});

  @override
  State<FloatingWhatsappWidget> createState() => _FloatingWhatsappWidgetState();
}

class _FloatingWhatsappWidgetState extends State<FloatingWhatsappWidget> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 24,
      right: 24,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (_isExpanded) ...[
            AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              curve: Curves.easeOut,
              width: 260,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppColors.border),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.12),
                    blurRadius: 16,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 8,
                        height: 8,
                        decoration: const BoxDecoration(
                          color: AppColors.success,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'PRO Support Online',
                        style: AppTextStyles.caption.copyWith(
                          fontWeight: FontWeight.bold,
                          color: AppColors.success,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Need assistance with your document request?',
                    style: AppTextStyles.bodyMedium.copyWith(fontSize: 13),
                  ),
                  const SizedBox(height: 14),
                  ElevatedButton.icon(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Opening WhatsApp Chat (+971 4 123 4567)...'),
                          backgroundColor: AppColors.success,
                        ),
                      );
                    },
                    icon: const Icon(Icons.chat_bubble_outline_rounded, size: 16),
                    label: const Text('WhatsApp Us Now'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF25D366),
                      foregroundColor: Colors.white,
                      minimumSize: const Size(double.infinity, 38),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                  ),
                  const SizedBox(height: 8),
                  OutlinedButton.icon(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Calling Support Helpline: 800-DOCS (3627)...'),
                          backgroundColor: AppColors.primary,
                        ),
                      );
                    },
                    icon: const Icon(Icons.phone_in_talk_rounded, size: 16),
                    label: const Text('Call Toll-Free'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.primary,
                      minimumSize: const Size(double.infinity, 38),
                      side: const BorderSide(color: AppColors.primary),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
          ],
          FloatingActionButton.extended(
            heroTag: 'whatsapp_fab',
            onPressed: () => setState(() => _isExpanded = !_isExpanded),
            backgroundColor: const Color(0xFF25D366),
            elevation: 6,
            icon: Icon(
              _isExpanded ? Icons.close_rounded : Icons.chat_rounded,
              color: Colors.white,
            ),
            label: Text(
              _isExpanded ? 'Close' : 'Chat & Support',
              style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
