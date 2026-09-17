import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import '../../../app/theme/app_colors.dart';
import '../../../app/theme/app_text_styles.dart';
import '../../../core/utils/responsive.dart';
import '../../../core/widgets/responsive_layout.dart';
import '../../../core/widgets/status_chip.dart';
import '../../../data/mock/mock_repositories.dart';

class AdminDashboardScreen extends ConsumerStatefulWidget {
  const AdminDashboardScreen({super.key});

  @override
  ConsumerState<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends ConsumerState<AdminDashboardScreen> {
  String _selectedStatusFilter = 'All';

  @override
  Widget build(BuildContext context) {
    final customers = ref.watch(customersProvider);
    final services = ref.watch(servicesProvider);
    final requests = ref.watch(requestsProvider);

    final newRequestsCount = requests.where((r) => r.status.toLowerCase() == 'submitted').length;
    final processingCount = requests.where((r) => r.status.toLowerCase() == 'processing' || r.status.toLowerCase() == 'reviewing').length;
    final completedCount = requests.where((r) => r.status.toLowerCase() == 'completed').length;

    // Filtered requests list
    var filteredRequests = requests;
    if (_selectedStatusFilter != 'All') {
      filteredRequests = requests.where((r) => r.status.toLowerCase() == _selectedStatusFilter.toLowerCase()).toList();
    }

    final isDesktop = Responsive.isDesktop(context);

    // 6 Stat items to render (Minimum 3 boxes per row)
    final stats = [
      _StatData(
        title: 'Total Customers',
        count: '${customers.length}',
        subtitle: '+14% active users',
        icon: Icons.people_alt_rounded,
        accentColor: AppColors.info,
      ),
      _StatData(
        title: 'Active Services',
        count: '${services.length}',
        subtitle: '56 Portals Live',
        icon: Icons.grid_view_rounded,
        accentColor: AppColors.primary,
      ),
      _StatData(
        title: 'New Requests',
        count: '$newRequestsCount',
        subtitle: 'Action Required',
        icon: Icons.fiber_new_rounded,
        accentColor: AppColors.warning,
      ),
      _StatData(
        title: 'In Processing',
        count: '$processingCount',
        subtitle: 'Govt Lodgement',
        icon: Icons.pending_actions_rounded,
        accentColor: AppColors.primaryDark,
      ),
      _StatData(
        title: 'Completed Filings',
        count: '$completedCount',
        subtitle: '99.8% Success Rate',
        icon: Icons.check_circle_rounded,
        accentColor: AppColors.success,
      ),
      _StatData(
        title: 'Est. Revenue',
        count: 'AED 48.2k',
        subtitle: 'Statutory & PRO',
        icon: Icons.account_balance_wallet_rounded,
        accentColor: AppColors.goldAccent,
      ),
    ];

    return AdminShellLayout(
      currentPath: '/admin/dashboard',
      child: SingleChildScrollView(
        padding: EdgeInsets.all(isDesktop ? 28 : 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Executive Header Section
            _buildExecutiveHeader(context),
            const SizedBox(height: 20),

            // System Health & SLA Strip
            _buildSystemHealthStrip(),
            const SizedBox(height: 24),

            // Stat Metric Grid (Strictly MINIMUM 3 Boxes Per Row, Height 120px)
            LayoutBuilder(
              builder: (context, constraints) {
                int cols = 3; // Always at least 3 boxes per row
                if (constraints.maxWidth > 1400) {
                  cols = 6;
                } else if (constraints.maxWidth >= 850) {
                  cols = 3;
                } else {
                  cols = 3; // Enforce min 3 boxes per row as requested
                }

                return GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: cols,
                    crossAxisSpacing: 14,
                    mainAxisSpacing: 14,
                    mainAxisExtent: 120, // Height fixed to 120px
                  ),
                  itemCount: stats.length,
                  itemBuilder: (context, index) {
                    final item = stats[index];
                    return _buildStatCard(item);
                  },
                );
              },
            ),
            const SizedBox(height: 28),

            // Request Analytics Chart Box
            _buildAnalyticsChartCard(),
            const SizedBox(height: 28),

            // Main Content Row: Recent Requests Table (Left) & Customer/Portal Health Panel (Right)
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Left Column: Recent Requests DataTable
                Expanded(
                  flex: 3,
                  child: _buildRecentRequestsCard(context, filteredRequests),
                ),

                // Right Side Desktop Column: Registered Customers & Govt Portals Status
                if (isDesktop) ...[
                  const SizedBox(width: 24),
                  Expanded(
                    flex: 2,
                    child: Column(
                      children: [
                        _buildRecentCustomersCard(customers),
                        const SizedBox(height: 20),
                        _buildGovernmentPortalsStatusCard(),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildExecutiveHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
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
                    'LIVE PLATFORM OPERATIONS',
                    style: AppTextStyles.caption.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppColors.primaryDark,
                      letterSpacing: 0.8,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Text('Executive Dashboard', style: AppTextStyles.h1.copyWith(fontSize: 20)),
              const SizedBox(height: 2),
              Text(
                'Real-time overview of document requests, customer accounts, and government SLA filings',
                style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary),
              ),
            ],
          ),
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              OutlinedButton.icon(
                onPressed: () => context.go('/admin/services'),
                icon: const Icon(Icons.add_rounded, size: 16),
                label: const Text('Manage Services'),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                  side: const BorderSide(color: AppColors.border),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
              ),
              ElevatedButton.icon(
                onPressed: () => context.go('/home'),
                icon: const Icon(Icons.open_in_new_rounded, size: 16),
                label: const Text('View Customer Portal'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSystemHealthStrip() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.primaryLight.withValues(alpha: 0.5),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.2)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildHealthMetricItem(Icons.verified_user_rounded, 'SLA Compliance Rate', '99.4%', AppColors.primaryDark),
          _buildHealthMetricItem(Icons.speed_rounded, 'Avg. Processing Time', '2.1 Hrs', AppColors.primaryDark),
          _buildHealthMetricItem(Icons.support_agent_rounded, 'Active PRO Officers', '12 Online', AppColors.success),
          _buildHealthMetricItem(Icons.cloud_done_rounded, 'MoJ Statutory Gateway', 'Synchronized', AppColors.primary),
        ],
      ),
    );
  }

  Widget _buildHealthMetricItem(IconData icon, String label, String value, Color color) {
    return Row(
      children: [
        Icon(icon, size: 16, color: color),
        const SizedBox(width: 6),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(label, style: AppTextStyles.caption.copyWith(fontSize: 10, color: AppColors.textSecondary)),
            Text(value, style: AppTextStyles.caption.copyWith(fontSize: 11, fontWeight: FontWeight.bold, color: color)),
          ],
        ),
      ],
    );
  }

  Widget _buildStatCard(_StatData data) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  data.title,
                  style: AppTextStyles.caption.copyWith(
                    color: AppColors.textSecondary,
                    fontWeight: FontWeight.w600,
                    fontSize: 11,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: data.accentColor.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(data.icon, size: 18, color: data.accentColor),
              ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                data.count,
                style: AppTextStyles.h1.copyWith(
                  fontSize: 20,
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w800,
                  height: 1.1,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                data.subtitle,
                style: AppTextStyles.caption.copyWith(
                  fontSize: 10,
                  color: data.accentColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAnalyticsChartCard() {
    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Service Request Volume Trend', style: AppTextStyles.h3.copyWith(fontSize: 16)),
                  Text('Daily application lodgements across typing portals', style: AppTextStyles.caption.copyWith(color: AppColors.textSecondary)),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.primaryLight,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text('Weekly Activity', style: AppTextStyles.caption.copyWith(color: AppColors.primaryDark, fontWeight: FontWeight.bold, fontSize: 10)),
              ),
            ],
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: 210,
            child: LineChart(
              LineChartData(
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  getDrawingHorizontalLine: (_) => const FlLine(color: AppColors.borderLight, strokeWidth: 1),
                ),
                titlesData: FlTitlesData(
                  leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: true, reservedSize: 28)),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
                        if (value.toInt() >= 0 && value.toInt() < days.length) {
                          return Padding(
                            padding: const EdgeInsets.only(top: 6),
                            child: Text(days[value.toInt()], style: AppTextStyles.caption.copyWith(fontSize: 10)),
                          );
                        }
                        return const Text('');
                      },
                    ),
                  ),
                  topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                ),
                borderData: FlBorderData(show: false),
                lineBarsData: [
                  LineChartBarData(
                    spots: const [
                      FlSpot(0, 4),
                      FlSpot(1, 8),
                      FlSpot(2, 5),
                      FlSpot(3, 12),
                      FlSpot(4, 10),
                      FlSpot(5, 16),
                      FlSpot(6, 14),
                    ],
                    isCurved: true,
                    color: AppColors.primary,
                    barWidth: 3,
                    isStrokeCapRound: true,
                    dotData: const FlDotData(show: true),
                    belowBarData: BarAreaData(
                      show: true,
                      color: AppColors.primary.withValues(alpha: 0.15),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecentRequestsCard(BuildContext context, List requests) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Recent Service Requests', style: AppTextStyles.h3.copyWith(fontSize: 16)),
                  Text('Active filings requiring administrative dispatch', style: AppTextStyles.caption.copyWith(color: AppColors.textSecondary)),
                ],
              ),
              TextButton(
                onPressed: () => context.go('/admin/requests'),
                child: Text('View All (${requests.length})', style: AppTextStyles.caption.copyWith(fontWeight: FontWeight.bold, color: AppColors.primary)),
              ),
            ],
          ),
          const SizedBox(height: 12),
          // Status filter chips
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: ['All', 'Submitted', 'Processing', 'Completed'].map((st) {
                final isSel = _selectedStatusFilter == st;
                return Padding(
                  padding: const EdgeInsets.only(right: 6),
                  child: FilterChip(
                    label: Text(st, style: TextStyle(fontSize: 11, color: isSel ? Colors.white : AppColors.textPrimary, fontWeight: isSel ? FontWeight.bold : FontWeight.normal)),
                    selected: isSel,
                    selectedColor: AppColors.primary,
                    backgroundColor: AppColors.background,
                    side: BorderSide(color: isSel ? AppColors.primary : AppColors.border),
                    showCheckmark: false,
                    onSelected: (val) {
                      setState(() => _selectedStatusFilter = st);
                    },
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 16),

          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(
              headingRowColor: WidgetStateProperty.all(AppColors.background),
              horizontalMargin: 12,
              columnSpacing: 24,
              columns: const [
                DataColumn(label: Text('Request ID', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold))),
                DataColumn(label: Text('Customer', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold))),
                DataColumn(label: Text('Service Verticals', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold))),
                DataColumn(label: Text('Submitted Date', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold))),
                DataColumn(label: Text('Status', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold))),
                DataColumn(label: Text('Action', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold))),
              ],
              rows: requests.take(6).map((req) {
                return DataRow(
                  cells: [
                    DataCell(SizedBox(
                      width: 120,
                      child: Text(req.id, style: AppTextStyles.bodySmall.copyWith(fontWeight: FontWeight.bold, color: AppColors.primary), maxLines: 1, overflow: TextOverflow.ellipsis),
                    )),
                    DataCell(SizedBox(
                      width: 160,
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: 12,
                            backgroundColor: AppColors.primaryLight,
                            child: Text(req.customerName.substring(0, 1), style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: AppColors.primaryDark)),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              req.customerName,
                              style: AppTextStyles.bodySmall.copyWith(fontWeight: FontWeight.w600),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                    )),
                    DataCell(SizedBox(
                      width: 170,
                      child: Text(req.serviceName, style: AppTextStyles.bodySmall, maxLines: 1, overflow: TextOverflow.ellipsis),
                    )),
                    DataCell(Text(DateFormat('MMM dd, yyyy').format(req.submittedAt), style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary))),
                    DataCell(StatusChip(status: req.status)),
                    DataCell(
                      IconButton(
                        icon: const Icon(Icons.arrow_forward_rounded, size: 16, color: AppColors.primary),
                        onPressed: () => context.go('/admin/requests/${req.id}'),
                      ),
                    ),
                  ],
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecentCustomersCard(List customers) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Registered Clients', style: AppTextStyles.h3.copyWith(fontSize: 15)),
              Text('Verified EID', style: AppTextStyles.caption.copyWith(color: AppColors.success, fontWeight: FontWeight.bold, fontSize: 10)),
            ],
          ),
          const SizedBox(height: 12),
          ...customers.take(4).map((c) => Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 16,
                      backgroundColor: AppColors.primaryLight,
                      child: Text(c.name.substring(0, 1), style: const TextStyle(color: AppColors.primaryDark, fontWeight: FontWeight.bold, fontSize: 12)),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(c.name, style: AppTextStyles.bodySmall.copyWith(fontWeight: FontWeight.bold)),
                          Text(c.email, style: AppTextStyles.caption.copyWith(fontSize: 10, color: AppColors.textSecondary)),
                        ],
                      ),
                    ),
                    const Icon(Icons.verified_rounded, size: 14, color: AppColors.primary),
                  ],
                ),
              )),
        ],
      ),
    );
  }

  Widget _buildGovernmentPortalsStatusCard() {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Government Gateway Status', style: AppTextStyles.h3.copyWith(fontSize: 15)),
          const SizedBox(height: 4),
          Text('Real-time API integrations with UAE authorities', style: AppTextStyles.caption.copyWith(fontSize: 10)),
          const SizedBox(height: 14),
          _buildPortalStatusRow('GDRFA Amer Visa System', 'Operational', AppColors.success),
          _buildPortalStatusRow('ICP Emirates ID Network', 'Operational', AppColors.success),
          _buildPortalStatusRow('MoJ Legal Translation Portal', 'Active', AppColors.primary),
          _buildPortalStatusRow('DED Business Services', 'Operational', AppColors.success),
        ],
      ),
    );
  }

  Widget _buildPortalStatusRow(String name, String status, Color color) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(name, style: AppTextStyles.caption.copyWith(color: AppColors.textPrimary)),
          Row(
            children: [
              Container(width: 6, height: 6, decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
              const SizedBox(width: 6),
              Text(status, style: AppTextStyles.caption.copyWith(color: color, fontWeight: FontWeight.bold, fontSize: 10)),
            ],
          ),
        ],
      ),
    );
  }
}

class _StatData {
  final String title;
  final String count;
  final String subtitle;
  final IconData icon;
  final Color accentColor;

  _StatData({
    required this.title,
    required this.count,
    required this.subtitle,
    required this.icon,
    required this.accentColor,
  });
}
