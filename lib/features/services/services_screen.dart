import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../app/theme/app_colors.dart';
import '../../app/theme/app_text_styles.dart';
import '../../core/utils/responsive.dart';
import '../../core/widgets/app_search_field.dart';
import '../../core/widgets/empty_state.dart';
import '../../core/widgets/interactive_card.dart';
import '../../core/widgets/responsive_layout.dart';
import '../../data/mock/mock_repositories.dart';
import '../../data/models/service_model.dart';

class ServicesScreen extends ConsumerStatefulWidget {
  final String? initialCategory;
  final String? initialQuery;

  const ServicesScreen({
    super.key,
    this.initialCategory,
    this.initialQuery,
  });

  @override
  ConsumerState<ServicesScreen> createState() => _ServicesScreenState();
}

class _ServicesScreenState extends ConsumerState<ServicesScreen> {
  late TextEditingController _searchController;
  String _selectedAuthority = 'All';
  String _selectedScope = 'All';
  String _selectedSla = 'All';
  String _sortBy = 'featured';

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController(text: widget.initialQuery ?? '');
    if (widget.initialCategory != null) {
      _selectedScope = widget.initialCategory!;
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final categories = ref.watch(categoriesProvider);
    final allServices = ref.watch(servicesProvider);

    // Filtering logic
    List<ServiceModel> filtered = allServices.where((s) => s.isActive).toList();

    if (_selectedScope != 'All') {
      filtered = filtered.where((s) => s.categoryId == _selectedScope || s.categoryName.toLowerCase().contains(_selectedScope.toLowerCase())).toList();
    }

    final query = _searchController.text.trim().toLowerCase();
    if (query.isNotEmpty) {
      filtered = filtered.where((s) =>
          s.name.toLowerCase().contains(query) ||
          s.shortDescription.toLowerCase().contains(query) ||
          s.categoryName.toLowerCase().contains(query)).toList();
    }

    // Sorting logic
    if (_sortBy == 'price_low') {
      filtered.sort((a, b) => a.price.compareTo(b.price));
    } else if (_sortBy == 'price_high') {
      filtered.sort((a, b) => b.price.compareTo(a.price));
    } else if (_sortBy == 'name') {
      filtered.sort((a, b) => a.name.compareTo(b.name));
    }

    final isDesktop = Responsive.isDesktop(context);

    return CustomerShellLayout(
      currentPath: '/services',
      child: SingleChildScrollView(
        child: Column(
          children: [
            // Top Breadcrumb & Status Bar
            Container(
              color: AppColors.background,
              padding: EdgeInsets.symmetric(horizontal: isDesktop ? 64 : 20, vertical: 12),
              child: Center(
                child: Container(
                  constraints: const BoxConstraints(maxWidth: 1280),
                  child: Row(
                    children: [
                      const Icon(Icons.home_outlined, size: 14, color: AppColors.textSecondary),
                      const SizedBox(width: 6),
                      Text('Home', style: AppTextStyles.caption),
                      const Text('  /  ', style: TextStyle(color: AppColors.textMuted)),
                      Text('Services Catalog', style: AppTextStyles.caption.copyWith(color: AppColors.primary, fontWeight: FontWeight.bold)),
                      const Spacer(),
                      if (isDesktop) ...[
                        Row(
                          children: [
                            const Icon(Icons.verified_rounded, size: 14, color: AppColors.primary),
                            const SizedBox(width: 6),
                            Text('MoJ & ICP Authorized Agency', style: AppTextStyles.caption.copyWith(fontWeight: FontWeight.bold, color: AppColors.primaryDark)),
                            const SizedBox(width: 16),
                            Text('Active Services: 56 Portals', style: AppTextStyles.caption.copyWith(color: AppColors.textSecondary)),
                          ],
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ),

            // Page Hero Header & Search Section
            Container(
              color: AppColors.surface,
              padding: EdgeInsets.symmetric(horizontal: isDesktop ? 64 : 20, vertical: 36),
              child: Center(
                child: Container(
                  constraints: const BoxConstraints(maxWidth: 1280),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 6,
                            height: 6,
                            decoration: const BoxDecoration(color: AppColors.primary, shape: BoxShape.circle),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'UAE OFFICIAL PRO & TYPING GATEWAY',
                            style: AppTextStyles.caption.copyWith(fontWeight: FontWeight.bold, letterSpacing: 1.0, color: AppColors.primaryDark),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Explore UAE Typing & Document Assistance Services',
                        style: AppTextStyles.h1.copyWith(fontSize: 20),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Browse certified government, legal, immigration, and business services. Filter by authority or processing speed.',
                        style: AppTextStyles.bodyLarge.copyWith(color: AppColors.textSecondary),
                      ),
                      const SizedBox(height: 24),
                      AppSearchField(
                        controller: _searchController,
                        hintText: 'Search typing services (e.g., Golden Visa, Ejari, Attestation, MOFA, Emirates ID)...',
                        onChanged: (val) => setState(() {}),
                      ),
                      const SizedBox(height: 12),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            Text('Trending: ', style: AppTextStyles.caption.copyWith(fontWeight: FontWeight.bold)),
                            const SizedBox(width: 6),
                            _buildTrendingTag('All', true),
                            _buildTrendingTag('Amer / GDRFA', false),
                            _buildTrendingTag('ICP Emirates ID', false),
                            _buildTrendingTag('Legal Translation', false),
                            _buildTrendingTag('DED Corporate', false),
                            _buildTrendingTag('MOFA Attestation', false),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Main 2-Column Catalog Layout
            Container(
              color: AppColors.background,
              padding: EdgeInsets.symmetric(horizontal: isDesktop ? 64 : 20, vertical: 32),
              child: Center(
                child: Container(
                  constraints: const BoxConstraints(maxWidth: 1280),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Left Sidebar Filter Panel (Desktop)
                      if (isDesktop) ...[
                        SizedBox(
                          width: 280,
                          child: _buildFilterSidebar(categories),
                        ),
                        const SizedBox(width: 32),
                      ],

                      // Main Catalog Grid (Right Side)
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Catalog Bar Header
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                RichText(
                                  text: TextSpan(
                                    style: AppTextStyles.bodyMedium,
                                    children: [
                                      const TextSpan(text: 'Showing '),
                                      TextSpan(text: '${filtered.length} ', style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.primary)),
                                      const TextSpan(text: 'verified government & administrative services'),
                                    ],
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: AppColors.surface,
                                    borderRadius: BorderRadius.circular(8),
                                    border: Border.all(color: AppColors.border),
                                  ),
                                  child: DropdownButtonHideUnderline(
                                    child: DropdownButton<String>(
                                      value: _sortBy,
                                      style: AppTextStyles.bodySmall.copyWith(color: AppColors.textPrimary, fontWeight: FontWeight.bold),
                                      items: const [
                                        DropdownMenuItem(value: 'featured', child: Text('Featured & Recommended')),
                                        DropdownMenuItem(value: 'price_low', child: Text('Price: Low to High')),
                                        DropdownMenuItem(value: 'price_high', child: Text('Price: High to Low')),
                                        DropdownMenuItem(value: 'name', child: Text('Alphabetical')),
                                      ],
                                      onChanged: (val) {
                                        if (val != null) setState(() => _sortBy = val);
                                      },
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 20),

                            if (filtered.isEmpty)
                              EmptyState(
                                title: 'No Services Found',
                                description: 'No services match your active search term or selected authority filter.',
                                actionLabel: 'Reset All Filters',
                                onAction: () {
                                  setState(() {
                                    _searchController.clear();
                                    _selectedAuthority = 'All';
                                    _selectedScope = 'All';
                                    _selectedSla = 'All';
                                    _sortBy = 'featured';
                                  });
                                },
                              )
                            else
                              LayoutBuilder(
                                builder: (context, constraints) {
                                  int cols = 2; // Always at least 2 boxes per row
                                  if (constraints.maxWidth > 1100) {
                                    cols = 3;
                                  }

                                  return GridView.builder(
                                    shrinkWrap: true,
                                    physics: const NeverScrollableScrollPhysics(),
                                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: cols,
                                      crossAxisSpacing: 16,
                                      mainAxisSpacing: 16,
                                      mainAxisExtent: 240, // Fixed height: 240px
                                    ),
                                    itemCount: filtered.length,
                                    itemBuilder: (context, index) {
                                      return _buildCatalogServiceCard(context, filtered[index]);
                                    },
                                  );
                                },
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Bottom Direct Government Assistance Desk Banner
            _buildBottomAssistanceBanner(context),

            // Footer
            _buildFooter(),
          ],
        ),
      ),
    );
  }

  Widget _buildTrendingTag(String label, bool isSelected) {
    return Padding(
      padding: const EdgeInsets.only(right: 6),
      child: ActionChip(
        label: Text(label, style: TextStyle(fontSize: 11, color: isSelected ? Colors.white : AppColors.textPrimary, fontWeight: isSelected ? FontWeight.bold : FontWeight.normal)),
        backgroundColor: isSelected ? AppColors.primary : AppColors.surface,
        surfaceTintColor: Colors.transparent,
        side: BorderSide(color: isSelected ? AppColors.primary : AppColors.border),
        onPressed: () {
          if (label != 'All') {
            _searchController.text = label;
          } else {
            _searchController.clear();
          }
          setState(() {});
        },
      ),
    );
  }

  Widget _buildFilterSidebar(List categories) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Sidebar Container
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: AppColors.border),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.tune_rounded, size: 18, color: AppColors.primary),
                      const SizedBox(width: 8),
                      Text('Filter Catalog', style: AppTextStyles.h3.copyWith(fontSize: 16)),
                    ],
                  ),
                  TextButton(
                    onPressed: () {
                      setState(() {
                        _selectedAuthority = 'All';
                        _selectedScope = 'All';
                        _selectedSla = 'All';
                      });
                    },
                    child: Text('Reset', style: AppTextStyles.caption.copyWith(color: AppColors.textSecondary)),
                  ),
                ],
              ),
              const Divider(height: 20),

              // Government Authority Filter
              Text('GOVERNMENT AUTHORITY', style: AppTextStyles.caption.copyWith(fontWeight: FontWeight.bold, letterSpacing: 0.8, color: AppColors.textSecondary)),
              const SizedBox(height: 12),
              _buildFilterOption('All Authorities', 9, _selectedAuthority == 'All', () => setState(() => _selectedAuthority = 'All')),
              _buildFilterOption('Amer / GDRFA', 2, _selectedAuthority == 'Amer', () => setState(() => _selectedAuthority = 'Amer')),
              _buildFilterOption('ICP Federal Identity', 1, _selectedAuthority == 'ICP', () => setState(() => _selectedAuthority = 'ICP')),
              _buildFilterOption('MoJ & Notary Public', 2, _selectedAuthority == 'MoJ', () => setState(() => _selectedAuthority = 'MoJ')),
              _buildFilterOption('MOFA Foreign Affairs', 1, _selectedAuthority == 'MOFA', () => setState(() => _selectedAuthority = 'MOFA')),
              _buildFilterOption('DED Economy & Lands', 3, _selectedAuthority == 'DED', () => setState(() => _selectedAuthority = 'DED')),
              _buildFilterOption('Dubai / Federal Police', 1, _selectedAuthority == 'Police', () => setState(() => _selectedAuthority = 'Police')),

              const Divider(height: 28),

              // Service Scope Filter
              Text('SERVICE SCOPE', style: AppTextStyles.caption.copyWith(fontWeight: FontWeight.bold, letterSpacing: 0.8, color: AppColors.textSecondary)),
              const SizedBox(height: 12),
              ...categories.map((c) {
                final isSelected = _selectedScope == c.id;
                return Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: InkWell(
                    onTap: () => setState(() => _selectedScope = isSelected ? 'All' : c.id),
                    child: Row(
                      children: [
                        Icon(
                          isSelected ? Icons.check_circle_rounded : Icons.radio_button_unchecked_rounded,
                          size: 16,
                          color: isSelected ? AppColors.primary : AppColors.textMuted,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            c.name,
                            style: AppTextStyles.bodySmall.copyWith(
                              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                              color: isSelected ? AppColors.primaryDark : AppColors.textPrimary,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }),

              const Divider(height: 28),

              // Turnaround SLA
              Text('TURNAROUND SLA', style: AppTextStyles.caption.copyWith(fontWeight: FontWeight.bold, letterSpacing: 0.8, color: AppColors.textSecondary)),
              const SizedBox(height: 12),
              _buildSlaCheckbox('Express (2 - 4 Hrs)', _selectedSla == 'Express', () => setState(() => _selectedSla = 'Express')),
              _buildSlaCheckbox('Same Day Submission', _selectedSla == 'SameDay', () => setState(() => _selectedSla = 'SameDay')),
              _buildSlaCheckbox('Standard (1 - 3 Days)', _selectedSla == 'Standard', () => setState(() => _selectedSla = 'Standard')),
            ],
          ),
        ),
        const SizedBox(height: 16),

        // Typing Accuracy SLA Guarantee Card
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.primaryLight.withValues(alpha: 0.5),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: AppColors.primary.withValues(alpha: 0.2)),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: const BoxDecoration(color: AppColors.primary, shape: BoxShape.circle),
                child: const Icon(Icons.verified_user_rounded, color: Colors.white, size: 16),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Typing Accuracy SLA', style: AppTextStyles.bodySmall.copyWith(fontWeight: FontWeight.bold, color: AppColors.primaryDark)),
                    const SizedBox(height: 4),
                    Text(
                      'Zero-rejection protocol. Every application undergoes pre-scrutiny by licensed UAE PROs prior to department fee dispatch.',
                      style: AppTextStyles.caption.copyWith(fontSize: 11, height: 1.35),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildFilterOption(String label, int count, bool isSelected, VoidCallback onTap) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: InkWell(
        onTap: onTap,
        child: Row(
          children: [
            Icon(
              isSelected ? Icons.radio_button_checked_rounded : Icons.radio_button_unchecked_rounded,
              size: 16,
              color: isSelected ? AppColors.primary : AppColors.textMuted,
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                label,
                style: AppTextStyles.bodySmall.copyWith(
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  color: isSelected ? AppColors.primaryDark : AppColors.textPrimary,
                ),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: isSelected ? AppColors.primaryLight : AppColors.background,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                '$count',
                style: AppTextStyles.caption.copyWith(fontSize: 10, fontWeight: FontWeight.bold, color: isSelected ? AppColors.primary : AppColors.textSecondary),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSlaCheckbox(String label, bool isChecked, VoidCallback onTap) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: InkWell(
        onTap: onTap,
        child: Row(
          children: [
            Icon(
              isChecked ? Icons.check_box_rounded : Icons.check_box_outline_blank_rounded,
              size: 16,
              color: isChecked ? AppColors.primary : AppColors.textMuted,
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: AppTextStyles.bodySmall.copyWith(color: isChecked ? AppColors.primaryDark : AppColors.textPrimary, fontWeight: isChecked ? FontWeight.bold : FontWeight.normal),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCatalogServiceCard(BuildContext context, ServiceModel service) {
    return InteractiveCard(
      onTap: () => context.go('/services/${service.id}'),
      padding: const EdgeInsets.all(14),
      borderRadius: 12,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Authority & SLA Row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: AppColors.primaryLight,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.account_balance_rounded, size: 11, color: AppColors.primary),
                        const SizedBox(width: 4),
                        Text(
                          service.categoryName,
                          style: AppTextStyles.caption.copyWith(fontSize: 10, fontWeight: FontWeight.bold, color: AppColors.primaryDark),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: AppColors.infoLight,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      service.estimatedTime,
                      style: AppTextStyles.caption.copyWith(fontSize: 10, fontWeight: FontWeight.bold, color: AppColors.info),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),

              // Service Title
              Text(
                service.name,
                style: AppTextStyles.h3.copyWith(fontSize: 15, height: 1.2),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4),

              // Short Description
              Text(
                service.shortDescription,
                style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary, height: 1.3, fontSize: 11),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 8),

              // Required Document Tag Pills
              Wrap(
                spacing: 4,
                runSpacing: 4,
                children: service.requirements.take(2).map((r) => Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: AppColors.background,
                    borderRadius: BorderRadius.circular(4),
                    border: Border.all(color: AppColors.border),
                  ),
                  child: Text(
                    r,
                    style: AppTextStyles.caption.copyWith(fontSize: 9, color: AppColors.textSecondary),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                )).toList(),
              ),
            ],
          ),

          // Bottom Pricing & Actions Row
          Column(
            children: [
              const Divider(height: 12),
              Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Typing & PRO Fee', style: AppTextStyles.caption.copyWith(fontSize: 9)),
                      Text(
                        'AED ${service.price.toStringAsFixed(0)}',
                        style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.w900, color: AppColors.primaryDark),
                      ),
                    ],
                  ),
                  const Spacer(),
                  OutlinedButton(
                    onPressed: () => context.go('/services/${service.id}'),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      minimumSize: const Size(55, 30),
                      side: const BorderSide(color: AppColors.border),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                    ),
                    child: Text('Details', style: AppTextStyles.caption.copyWith(fontWeight: FontWeight.bold, fontSize: 11)),
                  ),
                  const SizedBox(width: 6),
                  ElevatedButton(
                    onPressed: () => context.go('/request-service?serviceId=${service.id}'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                      minimumSize: const Size(65, 30),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                    ),
                    child: Row(
                      children: const [
                        Text('Apply Now ', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
                        Icon(Icons.arrow_forward_rounded, size: 12),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBottomAssistanceBanner(BuildContext context) {
    final isDesktop = Responsive.isDesktop(context);

    return Container(
      width: double.infinity,
      color: AppColors.surface,
      padding: EdgeInsets.symmetric(horizontal: isDesktop ? 64 : 20, vertical: 40),
      child: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 1280),
          padding: const EdgeInsets.all(28),
          decoration: BoxDecoration(
            color: AppColors.lightGradient.colors.first,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.primary.withValues(alpha: 0.2)),
          ),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Icon(Icons.headset_mic_rounded, color: AppColors.primary, size: 18),
                        const SizedBox(width: 8),
                        Text(
                          'Direct Government Assistance Desk',
                          style: AppTextStyles.caption.copyWith(fontWeight: FontWeight.bold, color: AppColors.primaryDark),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Can\'t find the exact service or government department?',
                      style: AppTextStyles.h2.copyWith(fontSize: 20),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Connect with a certified UAE PRO consultant directly on WhatsApp or Call for a tailored quotation. We handle unique Ministry of Economy, Customs, MoHRE, and Judicial requirements.',
                      style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        const Icon(Icons.check_circle_outline_rounded, size: 14, color: AppColors.success),
                        const SizedBox(width: 4),
                        Text('Average response: under 5 minutes', style: AppTextStyles.caption.copyWith(color: AppColors.textSecondary)),
                        const SizedBox(width: 16),
                        const Icon(Icons.check_circle_outline_rounded, size: 14, color: AppColors.success),
                        const SizedBox(width: 4),
                        Text('Licensed under Dubai DED', style: AppTextStyles.caption.copyWith(color: AppColors.textSecondary)),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 24),
              Wrap(
                spacing: 12,
                runSpacing: 12,
                children: [
                  ElevatedButton.icon(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Opening WhatsApp PRO Desk (+971 4 200 8899)...'), backgroundColor: AppColors.success),
                      );
                    },
                    icon: const Icon(Icons.chat_bubble_rounded, size: 16),
                    label: const Text('WhatsApp PRO Desk'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF25D366),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                  ),
                  OutlinedButton.icon(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Calling Toll-Free Helpline: +971 4 200 8899...'), backgroundColor: AppColors.primary),
                      );
                    },
                    icon: const Icon(Icons.phone_in_talk_rounded, size: 16),
                    label: const Text('Call +971 4 200 8899'),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.primaryDark,
                      side: const BorderSide(color: AppColors.primary),
                      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFooter() {
    return Container(
      color: const Color(0xFF0F1B19),
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 36),
      child: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 1280),
          child: Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 2,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('SanadDocs', style: AppTextStyles.h2.copyWith(color: Colors.white, fontSize: 20)),
                        const SizedBox(height: 6),
                        Text(
                          'Accredited UAE administrative typing, legal translation, attestation, and PRO concierge service. Enabling streamlined personal and corporate government compliance across the Emirates.',
                          style: AppTextStyles.bodySmall.copyWith(color: Colors.white60, height: 1.4),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 32),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Quick Links', style: AppTextStyles.bodyMedium.copyWith(color: Colors.white, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 10),
                        Text('Home', style: AppTextStyles.caption.copyWith(color: Colors.white60)),
                        Text('All Services', style: AppTextStyles.caption.copyWith(color: Colors.white60)),
                        Text('Track Application', style: AppTextStyles.caption.copyWith(color: Colors.white60)),
                        Text('Submit Request', style: AppTextStyles.caption.copyWith(color: Colors.white60)),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Government Services', style: AppTextStyles.bodyMedium.copyWith(color: Colors.white, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 10),
                        Text('Amer (GDRFA Visa Services)', style: AppTextStyles.caption.copyWith(color: Colors.white60)),
                        Text('Tasheel (MoHRE Labor)', style: AppTextStyles.caption.copyWith(color: Colors.white60)),
                        Text('ICP Emirates ID & Residency', style: AppTextStyles.caption.copyWith(color: Colors.white60)),
                        Text('MOFA Attestation & Translation', style: AppTextStyles.caption.copyWith(color: Colors.white60)),
                      ],
                    ),
                  ),
                ],
              ),
              const Divider(color: Colors.white12, height: 36),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('© 2026 SanadDocs Administrative & PRO Services LLC. All rights reserved.', style: AppTextStyles.caption.copyWith(color: Colors.white38, fontSize: 11)),
                  Row(
                    children: [
                      Text('Privacy Policy', style: AppTextStyles.caption.copyWith(color: Colors.white38, fontSize: 11)),
                      const SizedBox(width: 16),
                      Text('Terms of Service', style: AppTextStyles.caption.copyWith(color: Colors.white38, fontSize: 11)),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
