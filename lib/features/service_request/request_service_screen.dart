import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../app/theme/app_colors.dart';
import '../../app/theme/app_text_styles.dart';
import '../../core/utils/responsive.dart';
import '../../core/validators/app_validators.dart';
import '../../core/widgets/app_text_field.dart';
import '../../core/widgets/responsive_layout.dart';
import '../../data/mock/mock_repositories.dart';
import '../../data/models/request_model.dart';
import '../../data/models/service_model.dart';

class RequestServiceScreen extends ConsumerStatefulWidget {
  final String? preselectedServiceId;

  const RequestServiceScreen({
    super.key,
    this.preselectedServiceId,
  });

  @override
  ConsumerState<RequestServiceScreen> createState() => _RequestServiceScreenState();
}

class _RequestServiceScreenState extends ConsumerState<RequestServiceScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController(text: 'Tariq Mansoor');
  final _phoneController = TextEditingController(text: '+971 50 892 4110');
  final _emailController = TextEditingController(text: 'tariq.mansoor@alhashimi.ae');
  final _emiratesIdController = TextEditingController(text: '784-1988-1234567-1');
  final _notesController = TextEditingController();

  String? _selectedCategoryId;
  String? _selectedServiceId;
  String _processingPriority = 'Standard';
  String _preferredChannel = 'WhatsApp (Instant)';
  int _documentPages = 2;
  bool _acceptTerms = true;
  bool _isSubmitting = false;

  final List<Map<String, String>> _uploadedFiles = [
    {'name': 'bachelor_degree_scan_notarized.pdf', 'size': '2.4 MB', 'status': 'Uploaded & Verified'},
    {'name': 'applicant_emirates_id_front_back.png', 'size': '1.1 MB', 'status': '100% Validated'},
  ];

  double get _baseFee => 150.0;
  double get _govtFee => 80.0;
  double get _priorityFee => _processingPriority == 'Express' ? 50.0 : 0.0;
  double get _subtotal => (_baseFee * _documentPages) + _govtFee + _priorityFee;
  double get _vat => _subtotal * 0.05;
  double get _totalEstimatedCost => _subtotal + _vat;

  @override
  void initState() {
    super.initState();
    _selectedServiceId = widget.preselectedServiceId;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _emiratesIdController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final categories = ref.watch(categoriesProvider);
    final services = ref.watch(servicesProvider);

    if (_selectedServiceId != null) {
      final selectedSrv = services.cast<ServiceModel?>().firstWhere((s) => s?.id == _selectedServiceId, orElse: () => null);
      if (selectedSrv != null && _selectedCategoryId != selectedSrv.categoryId) {
        _selectedCategoryId = selectedSrv.categoryId;
      }
    }

    final availableServices = _selectedCategoryId == null
        ? services
        : services.where((s) => s.categoryId == _selectedCategoryId).toList();

    final isDesktop = Responsive.isDesktop(context);

    return CustomerShellLayout(
      currentPath: '/request-service',
      child: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: isDesktop ? 64 : 16, vertical: 32),
        child: Center(
          child: Container(
            constraints: const BoxConstraints(maxWidth: 1240),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top Badge Header & Title
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(color: AppColors.primaryLight, borderRadius: BorderRadius.circular(20)),
                          child: Text('MINISTRY OF JUSTICE & ICP ACCREDITED', style: AppTextStyles.caption.copyWith(color: AppColors.primaryDark, fontWeight: FontWeight.bold, letterSpacing: 0.8)),
                        ),
                        const SizedBox(height: 8),
                        Text('Submit Service Request', style: AppTextStyles.h1.copyWith(fontSize: 20)),
                        const SizedBox(height: 4),
                        Text('Complete your application details below. Our certified PROs review and process requests within 2 business hours.', style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary)),
                      ],
                    ),
                    if (isDesktop)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                        decoration: BoxDecoration(color: AppColors.successLight, borderRadius: BorderRadius.circular(20), border: Border.all(color: AppColors.success.withValues(alpha: 0.3))),
                        child: Row(
                          children: [
                            Container(width: 8, height: 8, decoration: const BoxDecoration(color: AppColors.success, shape: BoxShape.circle)),
                            const SizedBox(width: 8),
                            Text('Typing Queue Active - Avg. Review: 42 mins', style: AppTextStyles.caption.copyWith(color: AppColors.success, fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ),
                  ],
                ),
                const SizedBox(height: 24),

                // 4-Step Visual Progress Stepper
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(14), border: Border.all(color: AppColors.border)),
                  child: Row(
                    children: [
                      _buildStepperTab('1', 'Service Selection', true),
                      _buildStepperDivider(),
                      _buildStepperTab('2', 'Applicant Info', true),
                      _buildStepperDivider(),
                      _buildStepperTab('3', 'Document Upload', true),
                      _buildStepperDivider(),
                      _buildStepperTab('4', 'Confirmation', false),
                    ],
                  ),
                ),
                const SizedBox(height: 32),

                // Main Form Content + Sticky Sidebar Row
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Form Controls Area (Left Side)
                    Expanded(
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // 1. Service Information Card
                            _buildFormCard(
                              sectionNumber: '1',
                              title: 'Service Information',
                              badge: 'Standard Clearance',
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text('Service Category *', style: AppTextStyles.subtitle2),
                                            const SizedBox(height: 6),
                                            DropdownButtonFormField<String>(
                                              initialValue: _selectedCategoryId ?? (categories.isNotEmpty ? categories.first.id : null),
                                              decoration: InputDecoration(contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14), border: OutlineInputBorder(borderRadius: BorderRadius.circular(8))),
                                              items: categories.map((c) => DropdownMenuItem(value: c.id, child: Text(c.name, style: AppTextStyles.bodyMedium))).toList(),
                                              onChanged: (val) {
                                                if (val != null) {
                                                  setState(() {
                                                    _selectedCategoryId = val;
                                                    _selectedServiceId = null;
                                                  });
                                                }
                                              },
                                            ),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(width: 16),
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text('Specific Service *', style: AppTextStyles.subtitle2),
                                            const SizedBox(height: 6),
                                            DropdownButtonFormField<String>(
                                              initialValue: _selectedServiceId ?? (availableServices.isNotEmpty ? availableServices.first.id : null),
                                              decoration: InputDecoration(contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14), border: OutlineInputBorder(borderRadius: BorderRadius.circular(8))),
                                              items: availableServices.map((s) => DropdownMenuItem(value: s.id, child: Text(s.name, style: AppTextStyles.bodyMedium, overflow: TextOverflow.ellipsis))).toList(),
                                              onChanged: (val) {
                                                if (val != null) setState(() => _selectedServiceId = val);
                                              },
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 20),
                                  Text('Processing Priority', style: AppTextStyles.subtitle2),
                                  const SizedBox(height: 8),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: _buildPriorityTile('Standard Service', '24 - 48 Hours Turnaround', 'Included in Base Price', _processingPriority == 'Standard', () => setState(() => _processingPriority = 'Standard')),
                                      ),
                                      const SizedBox(width: 12),
                                      Expanded(
                                        child: _buildPriorityTile('Urgent Express PRO', '2 - 4 Hours Expedited Delivery', '+ AED 50.00', _processingPriority == 'Express', () => setState(() => _processingPriority = 'Express')),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 24),

                            // 2. Applicant Information Card
                            _buildFormCard(
                              sectionNumber: '2',
                              title: 'Applicant Information',
                              badge: 'Verified against registry for legal attestation',
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Expanded(
                                        child: AppTextField(
                                          label: 'Full Legal Name *',
                                          hint: 'As printed on Passport / Emirates ID',
                                          controller: _nameController,
                                          prefixIcon: Icons.person_outline_rounded,
                                          validator: (val) => AppValidators.nameValidator(val, 'Full Name'),
                                        ),
                                      ),
                                      const SizedBox(width: 16),
                                      Expanded(
                                        child: AppTextField(
                                          label: 'UAE Mobile Number *',
                                          hint: '+971 50 123 4567',
                                          controller: _phoneController,
                                          prefixIcon: Icons.phone_android_rounded,
                                          validator: AppValidators.phoneValidator,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 16),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: AppTextField(
                                          label: 'Email Address *',
                                          hint: 'name@domain.ae',
                                          controller: _emailController,
                                          prefixIcon: Icons.email_outlined,
                                          validator: AppValidators.emailValidator,
                                        ),
                                      ),
                                      const SizedBox(width: 16),
                                      Expanded(
                                        child: AppTextField(
                                          label: 'Emirates ID (Optional for Residency)',
                                          hint: '784-1988-1234567-1',
                                          controller: _emiratesIdController,
                                          prefixIcon: Icons.badge_outlined,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 20),
                                  Text('Preferred PRO Follow-up Channel', style: AppTextStyles.subtitle2),
                                  const SizedBox(height: 8),
                                  Row(
                                    children: [
                                      _buildChannelRadio('WhatsApp (Instant)', Icons.chat_bubble_outline_rounded),
                                      const SizedBox(width: 12),
                                      _buildChannelRadio('Phone Call', Icons.phone_in_talk_rounded),
                                      const SizedBox(width: 12),
                                      _buildChannelRadio('Email Updates', Icons.mail_outline_rounded),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 24),

                            // 3. Service Specifics & Scope Card
                            _buildFormCard(
                              sectionNumber: '3',
                              title: 'Service Specifics & Scope',
                              badge: 'Custom Parameters',
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Column(
                                          crossAxisAlignment: CrossAxisAlignment.start,
                                          children: [
                                            Text('Language Pair / Target Authority *', style: AppTextStyles.subtitle2),
                                            const SizedBox(height: 6),
                                            DropdownButtonFormField<String>(
                                              initialValue: 'English -> Arabic (Official UAE Ministry Stamp)',
                                              decoration: InputDecoration(contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14), border: OutlineInputBorder(borderRadius: BorderRadius.circular(8))),
                                              items: const [
                                                DropdownMenuItem(value: 'English -> Arabic (Official UAE Ministry Stamp)', child: Text('English -> Arabic (Official UAE Ministry Stamp)')),
                                                DropdownMenuItem(value: 'Arabic -> English (MoJ Sworn)', child: Text('Arabic -> English (MoJ Sworn)')),
                                              ],
                                              onChanged: (_) {},
                                            ),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(width: 16),
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text('Number of Document Pages', style: AppTextStyles.subtitle2),
                                          const SizedBox(height: 6),
                                          Container(
                                            decoration: BoxDecoration(border: Border.all(color: AppColors.border), borderRadius: BorderRadius.circular(8)),
                                            child: Row(
                                              children: [
                                                IconButton(onPressed: _documentPages > 1 ? () => setState(() => _documentPages--) : null, icon: const Icon(Icons.remove_rounded, size: 18)),
                                                Text('$_documentPages', style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.bold)),
                                                IconButton(onPressed: () => setState(() => _documentPages++), icon: const Icon(Icons.add_rounded, size: 18)),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 16),
                                  AppTextField(
                                    label: 'Special Instructions or Ministry Deadline Notes',
                                    hint: 'Include details like court hearing dates, Golden Visa category, specific company trade license numbers...',
                                    controller: _notesController,
                                    maxLines: 3,
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 24),

                            // 4. Document Upload Area Card
                            _buildFormCard(
                              sectionNumber: '4',
                              title: 'Document Upload Area',
                              badge: '256-Bit Encrypted Storage',
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(24),
                                    decoration: BoxDecoration(
                                      color: AppColors.primaryLight.withValues(alpha: 0.4),
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(color: AppColors.primary.withValues(alpha: 0.2), style: BorderStyle.solid),
                                    ),
                                    child: Center(
                                      child: Column(
                                        children: [
                                          Container(
                                            padding: const EdgeInsets.all(12),
                                            decoration: const BoxDecoration(color: AppColors.surface, shape: BoxShape.circle),
                                            child: const Icon(Icons.cloud_upload_outlined, color: AppColors.primary, size: 32),
                                          ),
                                          const SizedBox(height: 12),
                                          Text('Drag & Drop Original Documents Here', style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.bold)),
                                          const SizedBox(height: 4),
                                          Text('or browse from computer to upload degrees, passports, or certificates.', style: AppTextStyles.caption.copyWith(color: AppColors.textSecondary)),
                                          const SizedBox(height: 12),
                                          ElevatedButton.icon(
                                            onPressed: () {
                                              setState(() {
                                                _uploadedFiles.add({
                                                  'name': 'additional_document_attachment_${DateTime.now().millisecondsSinceEpoch}.pdf',
                                                  'size': '1.8 MB',
                                                  'status': 'Uploaded & Verified',
                                                });
                                              });
                                            },
                                            icon: const Icon(Icons.file_upload_outlined, size: 16),
                                            label: const Text('Select Files'),
                                            style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary, padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10)),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 16),

                                  // Active Uploaded Files List
                                  Text('UPLOADED DOCUMENTS (${_uploadedFiles.length} ACTIVE)', style: AppTextStyles.caption.copyWith(fontWeight: FontWeight.bold, letterSpacing: 0.8)),
                                  const SizedBox(height: 10),
                                  ..._uploadedFiles.map((file) => Container(
                                    margin: const EdgeInsets.only(bottom: 8),
                                    padding: const EdgeInsets.all(12),
                                    decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(10), border: Border.all(color: AppColors.border)),
                                    child: Row(
                                      children: [
                                        const Icon(Icons.picture_as_pdf_rounded, color: AppColors.error, size: 24),
                                        const SizedBox(width: 12),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(file['name']!, style: AppTextStyles.bodySmall.copyWith(fontWeight: FontWeight.bold), overflow: TextOverflow.ellipsis),
                                              Text('${file['size']}  •  ${file['status']}', style: AppTextStyles.caption.copyWith(color: AppColors.success, fontSize: 10)),
                                            ],
                                          ),
                                        ),
                                        IconButton(onPressed: () {}, icon: const Icon(Icons.visibility_outlined, size: 18, color: AppColors.textSecondary)),
                                        IconButton(
                                          onPressed: () => setState(() => _uploadedFiles.remove(file)),
                                          icon: const Icon(Icons.delete_outline_rounded, size: 18, color: AppColors.error),
                                        ),
                                      ],
                                    ),
                                  )),
                                ],
                              ),
                            ),
                            const SizedBox(height: 24),

                            // Legal Authenticity Declaration & Submit Buttons
                            Container(
                              padding: const EdgeInsets.all(20),
                              decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(14), border: Border.all(color: AppColors.border)),
                              child: Column(
                                children: [
                                  CheckboxListTile(
                                    contentPadding: EdgeInsets.zero,
                                    title: Text('Legal Authenticity Declaration', style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.bold)),
                                    subtitle: Text('I confirm the documents and personal information submitted are authentic, unaltered, and belong to the applicant stated.', style: AppTextStyles.caption.copyWith(fontSize: 11)),
                                    value: _acceptTerms,
                                    activeColor: AppColors.primary,
                                    onChanged: (val) => setState(() => _acceptTerms = val ?? false),
                                  ),
                                  const Divider(height: 24),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      OutlinedButton.icon(
                                        onPressed: () {},
                                        icon: const Icon(Icons.save_outlined, size: 16),
                                        label: const Text('Save Draft'),
                                        style: OutlinedButton.styleFrom(padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16)),
                                      ),
                                      ElevatedButton.icon(
                                        onPressed: _isSubmitting ? null : _submitRequest,
                                        icon: _isSubmitting ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white)) : const Icon(Icons.send_rounded, size: 18),
                                        label: Text(_isSubmitting ? 'Submitting...' : 'Submit Service Request'),
                                        style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary, padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 16)),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    // Right Sticky Cost Summary Sidebar (Desktop)
                    if (isDesktop) ...[
                      const SizedBox(width: 32),
                      SizedBox(
                        width: 340,
                        child: Column(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(24),
                              decoration: BoxDecoration(
                                color: AppColors.surface,
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(color: AppColors.border),
                                boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 16, offset: const Offset(0, 4))],
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text('Estimated Cost', style: AppTextStyles.h3.copyWith(fontSize: 16)),
                                      Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                                        decoration: BoxDecoration(color: AppColors.successLight, borderRadius: BorderRadius.circular(10)),
                                        child: Text('Official Fee Estimate', style: AppTextStyles.caption.copyWith(color: AppColors.success, fontWeight: FontWeight.bold, fontSize: 10)),
                                      ),
                                    ],
                                  ),
                                  const Divider(height: 20),

                                  _buildCostRow('Base Translation Fee ($_documentPages pgs)', 'AED ${(_baseFee * _documentPages).toStringAsFixed(2)}'),
                                  _buildCostRow('Govt Portal & Typing Fee', 'AED ${_govtFee.toStringAsFixed(2)}'),
                                  if (_processingPriority == 'Express') _buildCostRow('Urgent Express Fee', 'AED ${_priorityFee.toStringAsFixed(2)}'),
                                  _buildCostRow('UAE Federal VAT (5%)', 'AED ${_vat.toStringAsFixed(2)}'),

                                  const Divider(height: 24),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text('TOTAL ESTIMATED', style: AppTextStyles.caption.copyWith(fontWeight: FontWeight.bold)),
                                      Text('AED ${_totalEstimatedCost.toStringAsFixed(2)}', style: AppTextStyles.h1.copyWith(fontSize: 20, color: AppColors.primaryDark)),
                                    ],
                                  ),
                                  const SizedBox(height: 6),
                                  Text('No payment required now. Pay upon PRO review.', style: AppTextStyles.caption.copyWith(fontSize: 11, color: AppColors.textSecondary)),
                                ],
                              ),
                            ),
                            const SizedBox(height: 16),

                            // SanadDocs Guarantee Card
                            Container(
                              padding: const EdgeInsets.all(20),
                              decoration: BoxDecoration(color: AppColors.successLight.withValues(alpha: 0.5), borderRadius: BorderRadius.circular(14), border: Border.all(color: AppColors.success.withValues(alpha: 0.2))),
                              child: Row(
                                children: [
                                  const Icon(Icons.verified_user_rounded, color: AppColors.success, size: 24),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text('SanadDocs Guarantee', style: AppTextStyles.bodySmall.copyWith(fontWeight: FontWeight.bold, color: AppColors.success)),
                                        Text('Ministry Accepted or 100% Refund guarantee on legal translations.', style: AppTextStyles.caption.copyWith(fontSize: 10)),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStepperTab(String step, String label, bool isActive) {
    return Row(
      children: [
        CircleAvatar(
          radius: 12,
          backgroundColor: isActive ? AppColors.primary : AppColors.border,
          child: Text(step, style: TextStyle(color: isActive ? Colors.white : AppColors.textSecondary, fontWeight: FontWeight.bold, fontSize: 11)),
        ),
        const SizedBox(width: 6),
        Text(label, style: AppTextStyles.caption.copyWith(fontWeight: isActive ? FontWeight.bold : FontWeight.normal, color: isActive ? AppColors.primaryDark : AppColors.textSecondary)),
      ],
    );
  }

  Widget _buildStepperDivider() {
    return Expanded(child: Container(margin: const EdgeInsets.symmetric(horizontal: 8), height: 2, color: AppColors.border));
  }

  Widget _buildFormCard({required String sectionNumber, required String title, required String badge, required Widget child}) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(color: AppColors.surface, borderRadius: BorderRadius.circular(14), border: Border.all(color: AppColors.border)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  CircleAvatar(radius: 12, backgroundColor: AppColors.primaryLight, child: Text(sectionNumber, style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold, fontSize: 12))),
                  const SizedBox(width: 10),
                  Text(title, style: AppTextStyles.h3),
                ],
              ),
              Container(padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3), decoration: BoxDecoration(color: AppColors.background, borderRadius: BorderRadius.circular(10)), child: Text(badge, style: AppTextStyles.caption.copyWith(fontSize: 10))),
            ],
          ),
          const Divider(height: 24),
          child,
        ],
      ),
    );
  }

  Widget _buildPriorityTile(String title, String subtitle, String price, bool isSelected, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primaryLight.withValues(alpha: 0.5) : AppColors.background,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: isSelected ? AppColors.primary : AppColors.border, width: isSelected ? 1.5 : 1.0),
        ),
        child: Row(
          children: [
            Icon(isSelected ? Icons.radio_button_checked_rounded : Icons.radio_button_unchecked_rounded, color: isSelected ? AppColors.primary : AppColors.textMuted, size: 18),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: AppTextStyles.bodySmall.copyWith(fontWeight: FontWeight.bold)),
                  Text(subtitle, style: AppTextStyles.caption.copyWith(fontSize: 10, color: AppColors.textSecondary)),
                ],
              ),
            ),
            Text(price, style: AppTextStyles.caption.copyWith(fontWeight: FontWeight.bold, color: isSelected ? AppColors.primaryDark : AppColors.textPrimary)),
          ],
        ),
      ),
    );
  }

  Widget _buildChannelRadio(String label, IconData icon) {
    final isSelected = _preferredChannel == label;
    return InkWell(
      onTap: () => setState(() => _preferredChannel = label),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primaryLight : AppColors.background,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: isSelected ? AppColors.primary : AppColors.border),
        ),
        child: Row(
          children: [
            Icon(icon, size: 14, color: isSelected ? AppColors.primary : AppColors.textMuted),
            const SizedBox(width: 6),
            Text(label, style: AppTextStyles.caption.copyWith(fontWeight: isSelected ? FontWeight.bold : FontWeight.normal, color: isSelected ? AppColors.primaryDark : AppColors.textPrimary)),
          ],
        ),
      ),
    );
  }

  Widget _buildCostRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary)),
          Text(value, style: AppTextStyles.bodySmall.copyWith(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Future<void> _submitRequest() async {
    if (!_formKey.currentState!.validate()) return;
    if (!_acceptTerms) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please accept the Legal Authenticity Declaration.'), backgroundColor: AppColors.error));
      return;
    }

    setState(() => _isSubmitting = true);
    final newReqId = 'REQ-2026-${1000 + (DateTime.now().millisecondsSinceEpoch % 8999)}';

    final newRequest = RequestModel(
      id: newReqId,
      customerId: 'cust_1',
      serviceId: _selectedServiceId ?? 'srv_1',
      serviceName: 'Certified MoJ Legal Translation',
      categoryName: 'Legal Translation & Attestation',
      customerName: _nameController.text.trim(),
      customerPhone: _phoneController.text.trim(),
      customerEmail: _emailController.text.trim(),
      preferredContact: _preferredChannel,
      message: _notesController.text.trim(),
      documents: _uploadedFiles.map((f) => RequestDocument(
        id: 'doc_${DateTime.now().millisecondsSinceEpoch}',
        fileName: f['name']!,
        fileType: 'PDF',
        fileSize: f['size']!,
        uploadedAt: DateTime.now(),
        status: 'Uploaded',
      )).toList(),
      status: 'Submitted',
      submittedAt: DateTime.now(),
      updatedAt: DateTime.now(),
      timeline: [
        TimelineStep(title: 'Request Submitted', description: 'Request successfully submitted to processing team.', timestamp: DateTime.now(), isCompleted: true),
        const TimelineStep(title: 'Under Review', description: 'Document specialist reviewing submitted details.', isCompleted: false),
        const TimelineStep(title: 'Processing', description: 'Application in progress with government portal.', isCompleted: false),
        const TimelineStep(title: 'Completed', description: 'Final documents stamped and delivered.', isCompleted: false),
      ],
      internalNotes: [],
    );

    await Future.delayed(const Duration(milliseconds: 600));
    ref.read(requestsProvider.notifier).addRequest(newRequest);

    if (mounted) {
      context.go('/requests/confirmation?id=$newReqId');
    }
  }
}
