import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:gizecare/core/widgets/app_panel.dart';
import 'package:gizecare/features/reports/presentation/providers/system_metrics_providers.dart';
import 'package:gizecare/features/reports/presentation/tabs/system_reports_tab.dart';
import 'package:gizecare/features/reports/presentation/tabs/time_reports_tab.dart';

/// Reports hub: work-time analytics and host system usage.
class ReportsPage extends ConsumerStatefulWidget {
  const ReportsPage({super.key});

  @override
  ConsumerState<ReportsPage> createState() => _ReportsPageState();
}

class _ReportsPageState extends ConsumerState<ReportsPage>
    with SingleTickerProviderStateMixin {
  late final TabController _tabs;

  @override
  void initState() {
    super.initState();
    _tabs = TabController(length: 2, vsync: this);
    // Start periodic capture as soon as Reports is opened at least once.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(systemMetricsCaptureControllerProvider);
    });
  }

  @override
  void dispose() {
    _tabs.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const PageHeader(
          title: 'Reports',
          subtitle: 'Time analytics, host metrics, and feature usage',
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 28),
          child: TabBar(
            controller: _tabs,
            isScrollable: true,
            tabAlignment: TabAlignment.start,
            labelColor: scheme.primary,
            unselectedLabelColor: scheme.onSurfaceVariant,
            indicatorColor: scheme.primary,
            tabs: const [
              Tab(text: 'Time'),
              Tab(text: 'System'),
            ],
          ),
        ),
        Expanded(
          child: TabBarView(
            controller: _tabs,
            children: const [
              TimeReportsTab(),
              SystemReportsTab(),
            ],
          ),
        ),
      ],
    );
  }
}
