import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_text_styles.dart';
import '../../../core/utils/responsive.dart';
import '../../../core/validators/app_validators.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_text_field.dart';
import '../../../core/widgets/responsive_layout.dart';
import '../../../data/mock/mock_repositories.dart';
import '../../../data/models/service_model.dart';

class AdminServiceFormScreen extends ConsumerStatefulWidget {
  final String? serviceId;

  const AdminServiceFormScreen({
    super.key,
    this.serviceId,
  });

  @override
  ConsumerState<AdminServiceFormScreen> createState() => _AdminServiceFormScreenState();
}

class _AdminServiceFormScreenState extends ConsumerState<AdminServiceFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _shortDescController = TextEditingController();
  final _fullDescController = TextEditingController();
  final _reqsController = TextEditingController();
  final _timeController = TextEditingController();
  final _priceController = TextEditingController();

  String? _selectedCategoryId;
  bool _isActive = true;
  bool _isPopular = false;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    if (widget.serviceId != null) {
      final services = ref.read(servicesProvider);
      final existing = services.cast<ServiceModel?>().firstWhere(
            (s) => s?.id == widget.serviceId,
            orElse: () => null,
          );
      if (existing != null) {
        _nameController.text = existing.name;
        _selectedCategoryId = existing.categoryId;
        _shortDescController.text = existing.shortDescription;
        _fullDescController.text = existing.fullDescription;
        _reqsController.text = existing.requirements.join(', ');
        _timeController.text = existing.estimatedTime;
        _priceController.text = existing.price.toStringAsFixed(0);
        _isActive = existing.isActive;
        _isPopular = existing.isPopular;
      }
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _shortDescController.dispose();
    _fullDescController.dispose();
    _reqsController.dispose();
    _timeController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final categories = ref.watch(categoriesProvider);
    final isEditing = widget.serviceId != null;
    final isDesktop = Responsive.isDesktop(context);

    return AdminShellLayout(
      currentPath: '/admin/services',
      child: SingleChildScrollView(
        padding: EdgeInsets.all(isDesktop ? 32 : 16),
        child: Center(
          child: Container(
            constraints: const BoxConstraints(maxWidth: 800),
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
                        onPressed: () => context.go('/admin/services'),
                        icon: const Icon(Icons.arrow_back_rounded, size: 18),
                        label: const Text('Back to Services'),
                      ),
                      const SizedBox(height: 16),
                      Text(isEditing ? 'Edit Service' : 'Add New Service', style: AppTextStyles.h1.copyWith(fontSize: 20)),
                      const SizedBox(height: 8),
                      Text(
                        'Configure service metadata, price, turnaround, and requirements.',
                        style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary),
                      ),
                      const Divider(height: 32),

                      AppTextField(
                        label: 'Service Name',
                        hint: 'e.g., UAE Golden Visa Application',
                        controller: _nameController,
                        validator: (val) => AppValidators.requiredValidator(val, 'Service Name'),
                      ),
                      const SizedBox(height: 16),

                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Category', style: AppTextStyles.label.copyWith(color: AppColors.textPrimary)),
                          const SizedBox(height: 6),
                          DropdownButtonFormField<String>(
                            initialValue: _selectedCategoryId,
                            isExpanded: true,
                            hint: const Text('Select category'),
                            validator: (val) => val == null ? 'Please select a category.' : null,
                            onChanged: (val) {
                              setState(() {
                                _selectedCategoryId = val;
                              });
                            },
                            items: categories.map((cat) {
                              return DropdownMenuItem<String>(
                                value: cat.id,
                                child: Text(cat.name),
                              );
                            }).toList(),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      AppTextField(
                        label: 'Short Description',
                        hint: 'Brief summary for service card preview',
                        controller: _shortDescController,
                        validator: AppValidators.descriptionValidator,
                      ),
                      const SizedBox(height: 16),

                      AppTextField(
                        label: 'Full Detailed Description',
                        hint: 'Provide full scope of service details...',
                        controller: _fullDescController,
                        maxLines: 4,
                        validator: (val) => AppValidators.messageValidator(val, minLength: 10),
                      ),
                      const SizedBox(height: 16),

                      AppTextField(
                        label: 'Requirements (Comma-Separated)',
                        hint: 'Passport copy, Degree certificate, Bank statement',
                        controller: _reqsController,
                        validator: (val) => AppValidators.requiredValidator(val, 'Requirements'),
                      ),
                      const SizedBox(height: 16),

                      Row(
                        children: [
                          Expanded(
                            child: AppTextField(
                              label: 'Turnaround Time',
                              hint: 'e.g., 2 - 3 Working Days',
                              controller: _timeController,
                              validator: (val) => AppValidators.requiredValidator(val, 'Processing Time'),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: AppTextField(
                              label: 'Price (AED)',
                              hint: '1500',
                              controller: _priceController,
                              keyboardType: TextInputType.number,
                              validator: AppValidators.priceValidator,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),

                      Row(
                        children: [
                          Switch(
                            value: _isActive,
                            onChanged: (val) => setState(() => _isActive = val),
                          ),
                          const SizedBox(width: 8),
                          Text('Active Service Listing', style: AppTextStyles.bodyMedium),
                          const SizedBox(width: 24),
                          Switch(
                            value: _isPopular,
                            onChanged: (val) => setState(() => _isPopular = val),
                          ),
                          const SizedBox(width: 8),
                          Text('Feature on Home Popular', style: AppTextStyles.bodyMedium),
                        ],
                      ),
                      const SizedBox(height: 32),

                      AppButton(
                        isFullWidth: true,
                        text: isEditing ? 'Save Changes' : 'Create Service',
                        icon: Icons.check_rounded,
                        isLoading: _isSaving,
                        onPressed: _saveService,
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

  void _saveService() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isSaving = true;
    });

    await Future.delayed(const Duration(milliseconds: 500));

    final categories = ref.read(categoriesProvider);
    final catObj = categories.firstWhere((c) => c.id == _selectedCategoryId);

    final reqsList = _reqsController.text
        .split(',')
        .map((s) => s.trim())
        .where((s) => s.isNotEmpty)
        .toList();

    final newService = ServiceModel(
      id: widget.serviceId ?? 'srv_${DateTime.now().millisecondsSinceEpoch}',
      name: _nameController.text.trim(),
      categoryId: catObj.id,
      categoryName: catObj.name,
      shortDescription: _shortDescController.text.trim(),
      fullDescription: _fullDescController.text.trim(),
      requirements: reqsList,
      process: ['Initial Review', 'Government Portal Submission', 'Stamping & Delivery'],
      estimatedTime: _timeController.text.trim(),
      price: double.parse(_priceController.text.trim()),
      isActive: _isActive,
      isPopular: _isPopular,
    );

    if (widget.serviceId != null) {
      ref.read(servicesProvider.notifier).updateService(newService);
    } else {
      ref.read(servicesProvider.notifier).addService(newService);
    }

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(widget.serviceId != null ? 'Service updated successfully!' : 'New service created!'),
          backgroundColor: AppColors.success,
        ),
      );
      context.go('/admin/services');
    }
  }
}
