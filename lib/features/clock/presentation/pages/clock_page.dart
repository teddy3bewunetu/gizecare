import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:gizecare/core/widgets/app_panel.dart';
import 'package:gizecare/features/clock/presentation/tabs/alarm_tab.dart';
import 'package:gizecare/features/clock/presentation/tabs/countdown_tab.dart';
import 'package:gizecare/features/clock/presentation/tabs/stopwatch_tab.dart';
import 'package:gizecare/features/clock/presentation/tabs/world_clock_tab.dart';

/// Hub for Alarm, Stopwatch, Timer, and World Clock.
class ClockPage extends ConsumerStatefulWidget {
  const ClockPage({super.key});

  @override
  ConsumerState<ClockPage> createState() => _ClockPageState();
}

class _ClockPageState extends ConsumerState<ClockPage>
    with SingleTickerProviderStateMixin {
  late final TabController _tabs;

  @override
  void initState() {
    super.initState();
    _tabs = TabController(length: 4, vsync: this);
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
          title: 'Clock',
          subtitle: 'Alarm, stopwatch, timer, and world times',
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
              Tab(text: 'Alarm'),
              Tab(text: 'Stopwatch'),
              Tab(text: 'Timer'),
              Tab(text: 'World'),
            ],
          ),
        ),
        Expanded(
          child: TabBarView(
            controller: _tabs,
            children: const [
              AlarmTab(),
              StopwatchTab(),
              CountdownTab(),
              WorldClockTab(),
            ],
          ),
        ),
      ],
    );
  }
}
