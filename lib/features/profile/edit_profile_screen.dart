import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../app/theme/app_colors.dart';
import '../../app/theme/app_text_styles.dart';
import '../../core/utils/responsive.dart';
import '../../core/validators/app_validators.dart';
import '../../core/widgets/app_button.dart';
import '../../core/widgets/app_text_field.dart';
import '../../core/widgets/responsive_layout.dart';
import '../../data/mock/mock_repositories.dart';

class EditProfileScreen extends ConsumerStatefulWidget {
  const EditProfileScreen({super.key});

  @override
  ConsumerState<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends ConsumerState<EditProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  late TextEditingController _addressController;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    final user = ref.read(currentUserProvider);
    _nameController = TextEditingController(text: user.name);
    _emailController = TextEditingController(text: user.email);
    _phoneController = TextEditingController(text: user.phone);
    _addressController = TextEditingController(text: user.address);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDesktop = Responsive.isDesktop(context);

    return CustomerShellLayout(
      currentPath: '/profile',
      child: SingleChildScrollView(
        padding: EdgeInsets.symmetric(
          horizontal: isDesktop ? 64 : 16,
          vertical: 32,
        ),
        child: Center(
          child: Container(
            constraints: const BoxConstraints(maxWidth: 650),
            child: Card(
              elevation: 0,
              child: Padding(
                padding: const EdgeInsets.all(28),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextButton.icon(
                        onPressed: () => context.go('/profile'),
                        icon: const Icon(Icons.arrow_back_rounded, size: 18),
                        label: const Text('Back to Profile'),
                      ),
                      const SizedBox(height: 16),
                      Text('Edit Account Profile', style: AppTextStyles.h1.copyWith(fontSize: 20)),
                      const SizedBox(height: 8),
                      Text(
                        'Update your personal information and delivery address for official service filings.',
                        style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary),
                      ),
                      const Divider(height: 32),

                      AppTextField(
                        label: 'Full Name',
                        controller: _nameController,
                        prefixIcon: Icons.person_outline_rounded,
                        validator: (val) => AppValidators.nameValidator(val, 'Full Name'),
                      ),
                      const SizedBox(height: 16),

                      AppTextField(
                        label: 'Email Address',
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        prefixIcon: Icons.email_outlined,
                        validator: AppValidators.emailValidator,
                      ),
                      const SizedBox(height: 16),

                      AppTextField(
                        label: 'Phone Number',
                        controller: _phoneController,
                        keyboardType: TextInputType.phone,
                        prefixIcon: Icons.phone_outlined,
                        validator: AppValidators.phoneValidator,
                      ),
                      const SizedBox(height: 16),

                      AppTextField(
                        label: 'Physical / Tenancy Address',
                        controller: _addressController,
                        maxLines: 2,
                        prefixIcon: Icons.location_on_outlined,
                        validator: (val) => AppValidators.requiredValidator(val, 'Address'),
                      ),
                      const SizedBox(height: 32),

                      AppButton(
                        isFullWidth: true,
                        text: 'Save Profile Changes',
                        icon: Icons.check_rounded,
                        isLoading: _isSaving,
                        onPressed: _saveProfile,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _saveProfile() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isSaving = true;
    });

    await Future.delayed(const Duration(milliseconds: 500));

    final currentUser = ref.read(currentUserProvider);
    final updated = currentUser.copyWith(
      name: _nameController.text.trim(),
      email: _emailController.text.trim(),
      phone: _phoneController.text.trim(),
      address: _addressController.text.trim(),
    );

    ref.read(currentUserProvider.notifier).setUser(updated);

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Profile updated successfully!'),
          backgroundColor: AppColors.success,
        ),
      );
      context.go('/profile');
    }
  }
}
