import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../app/theme/app_colors.dart';
import '../../app/theme/app_text_styles.dart';
import '../../core/utils/responsive.dart';
import '../../core/validators/app_validators.dart';
import '../../core/widgets/app_button.dart';
import '../../core/widgets/app_text_field.dart';
import '../../core/widgets/responsive_layout.dart';
import '../../data/mock/mock_repositories.dart';

class ContactScreen extends ConsumerStatefulWidget {
  const ContactScreen({super.key});

  @override
  ConsumerState<ContactScreen> createState() => _ContactScreenState();
}

class _ContactScreenState extends ConsumerState<ContactScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _subjectController = TextEditingController();
  final _messageController = TextEditingController();

  bool _isSending = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _subjectController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final settings = ref.watch(settingsProvider);
    final isDesktop = Responsive.isDesktop(context);

    return CustomerShellLayout(
      currentPath: '/contact',
      child: SingleChildScrollView(
        padding: EdgeInsets.symmetric(
          horizontal: isDesktop ? 64 : 16,
          vertical: 32,
        ),
        child: Center(
          child: Container(
            constraints: const BoxConstraints(maxWidth: 1100),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Contact Us', style: AppTextStyles.h1),
                const SizedBox(height: 8),
                Text(
                  'Have questions about a service or need customized corporate PRO assistance? Send us a message.',
                  style: AppTextStyles.bodyLarge.copyWith(color: AppColors.textSecondary),
                ),
                const SizedBox(height: 32),

                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Contact Info & Map Card
                    Expanded(
                      flex: 4,
                      child: Column(
                        children: [
                          Card(
                            elevation: 0,
                            child: Padding(
                              padding: const EdgeInsets.all(24),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Contact Information', style: AppTextStyles.h3),
                                  const Divider(height: 24),
                                  _buildContactTile(Icons.phone_rounded, 'Phone Number', settings.phone),
                                  _buildContactTile(Icons.chat_bubble_rounded, 'WhatsApp Direct', settings.whatsapp),
                                  _buildContactTile(Icons.email_rounded, 'Email Address', settings.email),
                                  _buildContactTile(Icons.location_on_rounded, 'Office Address', settings.address),
                                  _buildContactTile(Icons.schedule_rounded, 'Working Hours', settings.workingHours),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),

                          // Map Placeholder
                          Container(
                            height: 180,
                            width: double.infinity,
                            decoration: BoxDecoration(
                              color: AppColors.primaryLight,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(color: AppColors.border),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(Icons.map_rounded, size: 40, color: AppColors.primary),
                                const SizedBox(height: 8),
                                Text(
                                  'Dubai Office Location Map Placeholder',
                                  style: AppTextStyles.bodyMedium.copyWith(color: AppColors.primaryDark, fontWeight: FontWeight.bold),
                                ),
                                Text('Sheikh Zayed Road, Dubai, UAE', style: AppTextStyles.bodySmall),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 24),

                    // Contact Form Card
                    Expanded(
                      flex: 5,
                      child: Card(
                        elevation: 0,
                        child: Padding(
                          padding: const EdgeInsets.all(28),
                          child: Form(
                            key: _formKey,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Send a Message', style: AppTextStyles.h2),
                                const SizedBox(height: 16),

                                AppTextField(
                                  label: 'Your Name',
                                  hint: 'Full legal name',
                                  controller: _nameController,
                                  prefixIcon: Icons.person_outline_rounded,
                                  validator: (val) => AppValidators.nameValidator(val, 'Name'),
                                ),
                                const SizedBox(height: 14),

                                Row(
                                  children: [
                                    Expanded(
                                      child: AppTextField(
                                        label: 'Email',
                                        hint: 'name@domain.com',
                                        controller: _emailController,
                                        keyboardType: TextInputType.emailAddress,
                                        validator: AppValidators.emailValidator,
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: AppTextField(
                                        label: 'Phone',
                                        hint: '+971 50 000 0000',
                                        controller: _phoneController,
                                        keyboardType: TextInputType.phone,
                                        validator: AppValidators.phoneValidator,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 14),

                                AppTextField(
                                  label: 'Subject',
                                  hint: 'Inquiry subject (e.g. Golden Visa Eligibility)',
                                  controller: _subjectController,
                                  validator: (val) => AppValidators.requiredValidator(val, 'Subject'),
                                ),
                                const SizedBox(height: 14),

                                AppTextField(
                                  label: 'Message',
                                  hint: 'Enter your inquiry details here...',
                                  controller: _messageController,
                                  maxLines: 4,
                                  validator: (val) => AppValidators.messageValidator(val, minLength: 10),
                                ),
                                const SizedBox(height: 24),

                                AppButton(
                                  isFullWidth: true,
                                  text: 'Send Inquiry Message',
                                  icon: Icons.send_rounded,
                                  isLoading: _isSending,
                                  onPressed: _submitContactForm,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildContactTile(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: AppColors.primary),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary)),
                Text(value, style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.w600)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _submitContactForm() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isSending = true;
    });

    await Future.delayed(const Duration(milliseconds: 600));

    setState(() {
      _isSending = false;
      _nameController.clear();
      _emailController.clear();
      _phoneController.clear();
      _subjectController.clear();
      _messageController.clear();
    });

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Thank you! Your message has been sent successfully. Our team will contact you shortly.'),
          backgroundColor: AppColors.success,
        ),
      );
    }
  }
}
