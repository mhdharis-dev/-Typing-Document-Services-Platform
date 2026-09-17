import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_text_styles.dart';
import '../../../core/utils/responsive.dart';
import '../../../core/validators/app_validators.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_text_field.dart';
import '../../../core/widgets/responsive_layout.dart';
import '../../../data/mock/mock_repositories.dart';
import '../../../data/models/settings_model.dart';

class AdminSettingsScreen extends ConsumerStatefulWidget {
  const AdminSettingsScreen({super.key});

  @override
  ConsumerState<AdminSettingsScreen> createState() => _AdminSettingsScreenState();
}

class _AdminSettingsScreenState extends ConsumerState<AdminSettingsScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _businessNameCtrl;
  late TextEditingController _phoneCtrl;
  late TextEditingController _whatsappCtrl;
  late TextEditingController _emailCtrl;
  late TextEditingController _addressCtrl;
  late TextEditingController _hoursCtrl;

  late TextEditingController _instaCtrl;
  late TextEditingController _fbCtrl;
  late TextEditingController _linkedinCtrl;
  late TextEditingController _ytCtrl;

  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    final settings = ref.read(settingsProvider);
    _businessNameCtrl = TextEditingController(text: settings.businessName);
    _phoneCtrl = TextEditingController(text: settings.phone);
    _whatsappCtrl = TextEditingController(text: settings.whatsapp);
    _emailCtrl = TextEditingController(text: settings.email);
    _addressCtrl = TextEditingController(text: settings.address);
    _hoursCtrl = TextEditingController(text: settings.workingHours);

    _instaCtrl = TextEditingController(text: settings.instagramUrl);
    _fbCtrl = TextEditingController(text: settings.facebookUrl);
    _linkedinCtrl = TextEditingController(text: settings.linkedinUrl);
    _ytCtrl = TextEditingController(text: settings.youtubeUrl);
  }

  @override
  void dispose() {
    _businessNameCtrl.dispose();
    _phoneCtrl.dispose();
    _whatsappCtrl.dispose();
    _emailCtrl.dispose();
    _addressCtrl.dispose();
    _hoursCtrl.dispose();
    _instaCtrl.dispose();
    _fbCtrl.dispose();
    _linkedinCtrl.dispose();
    _ytCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDesktop = Responsive.isDesktop(context);

    return AdminShellLayout(
      currentPath: '/admin/settings',
      child: SingleChildScrollView(
        padding: EdgeInsets.all(isDesktop ? 32 : 16),
        child: Center(
          child: Container(
            constraints: const BoxConstraints(maxWidth: 850),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Business Platform Settings', style: AppTextStyles.h1),
                  const SizedBox(height: 4),
                  Text('Manage official contact information and social profiles', style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary)),
                  const SizedBox(height: 24),

                  // Business Information Card
                  Card(
                    elevation: 0,
                    child: Padding(
                      padding: const EdgeInsets.all(28),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('1. Business Information', style: AppTextStyles.h2),
                          const Divider(height: 24),

                          AppTextField(
                            label: 'Business / Agency Name',
                            controller: _businessNameCtrl,
                            validator: (val) => AppValidators.requiredValidator(val, 'Business Name'),
                          ),
                          const SizedBox(height: 16),

                          Row(
                            children: [
                              Expanded(
                                child: AppTextField(
                                  label: 'Phone Number',
                                  controller: _phoneCtrl,
                                  validator: AppValidators.phoneValidator,
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: AppTextField(
                                  label: 'WhatsApp Direct Number',
                                  controller: _whatsappCtrl,
                                  validator: AppValidators.phoneValidator,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),

                          AppTextField(
                            label: 'Official Contact Email',
                            controller: _emailCtrl,
                            keyboardType: TextInputType.emailAddress,
                            validator: AppValidators.emailValidator,
                          ),
                          const SizedBox(height: 16),

                          AppTextField(
                            label: 'Office Physical Address',
                            controller: _addressCtrl,
                            maxLines: 2,
                            validator: (val) => AppValidators.requiredValidator(val, 'Address'),
                          ),
                          const SizedBox(height: 16),

                          AppTextField(
                            label: 'Working Hours',
                            controller: _hoursCtrl,
                            validator: (val) => AppValidators.requiredValidator(val, 'Working Hours'),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Social Links Card
                  Card(
                    elevation: 0,
                    child: Padding(
                      padding: const EdgeInsets.all(28),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('2. Social Links', style: AppTextStyles.h2),
                          const Divider(height: 24),

                          AppTextField(
                            label: 'Instagram URL',
                            controller: _instaCtrl,
                            validator: (val) => AppValidators.urlValidator(val, 'Instagram URL'),
                          ),
                          const SizedBox(height: 16),

                          AppTextField(
                            label: 'Facebook URL',
                            controller: _fbCtrl,
                            validator: (val) => AppValidators.urlValidator(val, 'Facebook URL'),
                          ),
                          const SizedBox(height: 16),

                          AppTextField(
                            label: 'LinkedIn URL',
                            controller: _linkedinCtrl,
                            validator: (val) => AppValidators.urlValidator(val, 'LinkedIn URL'),
                          ),
                          const SizedBox(height: 16),

                          AppTextField(
                            label: 'YouTube Channel URL',
                            controller: _ytCtrl,
                            validator: (val) => AppValidators.urlValidator(val, 'YouTube URL'),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),

                  AppButton(
                    isFullWidth: true,
                    text: 'Save Business Settings',
                    icon: Icons.save_rounded,
                    isLoading: _isSaving,
                    onPressed: _saveSettings,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _saveSettings() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isSaving = true;
    });

    await Future.delayed(const Duration(milliseconds: 500));

    final updated = SettingsModel(
      businessName: _businessNameCtrl.text.trim(),
      phone: _phoneCtrl.text.trim(),
      whatsapp: _whatsappCtrl.text.trim(),
      email: _emailCtrl.text.trim(),
      address: _addressCtrl.text.trim(),
      workingHours: _hoursCtrl.text.trim(),
      instagramUrl: _instaCtrl.text.trim(),
      facebookUrl: _fbCtrl.text.trim(),
      linkedinUrl: _linkedinCtrl.text.trim(),
      youtubeUrl: _ytCtrl.text.trim(),
    );

    ref.read(settingsProvider.notifier).updateSettings(updated);

    setState(() {
      _isSaving = false;
    });

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Business settings updated successfully!'),
          backgroundColor: AppColors.success,
        ),
      );
    }
  }
}
