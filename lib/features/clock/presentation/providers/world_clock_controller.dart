import 'dart:async';
import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:timezone/data/latest.dart' as tzdata;
import 'package:timezone/timezone.dart' as tz;

import 'package:gizecare/core/di/repository_providers.dart';
import 'package:gizecare/features/settings/domain/repositories/settings_repository.dart';

/// Curated world-clock cities (id == IANA timezone).
class WorldCity extends Equatable {
  const WorldCity({
    required this.id,
    required this.name,
    required this.region,
  });

  final String id;
  final String name;
  final String region;

  @override
  List<Object?> get props => [id, name, region];
}

const curatedWorldCities = <WorldCity>[
  WorldCity(id: 'Africa/Addis_Ababa', name: 'Addis Ababa', region: 'Ethiopia'),
  WorldCity(id: 'Europe/London', name: 'London', region: 'UK'),
  WorldCity(id: 'Europe/Oslo', name: 'Oslo', region: 'Norway'),
  WorldCity(id: 'Europe/Paris', name: 'Paris', region: 'France'),
  WorldCity(id: 'Europe/Berlin', name: 'Berlin', region: 'Germany'),
  WorldCity(id: 'America/New_York', name: 'New York', region: 'USA'),
  WorldCity(id: 'America/Los_Angeles', name: 'Los Angeles', region: 'USA'),
  WorldCity(id: 'America/Chicago', name: 'Chicago', region: 'USA'),
  WorldCity(id: 'Asia/Dubai', name: 'Dubai', region: 'UAE'),
  WorldCity(id: 'Asia/Tokyo', name: 'Tokyo', region: 'Japan'),
  WorldCity(id: 'Asia/Singapore', name: 'Singapore', region: 'Singapore'),
  WorldCity(id: 'Asia/Kolkata', name: 'Mumbai', region: 'India'),
  WorldCity(id: 'Australia/Sydney', name: 'Sydney', region: 'Australia'),
  WorldCity(id: 'Pacific/Auckland', name: 'Auckland', region: 'New Zealand'),
  WorldCity(id: 'Africa/Nairobi', name: 'Nairobi', region: 'Kenya'),
  WorldCity(id: 'Africa/Cairo', name: 'Cairo', region: 'Egypt'),
];

class WorldClockEntry extends Equatable {
  const WorldClockEntry({
    required this.city,
    required this.localTime,
    required this.offsetLabel,
  });

  final WorldCity city;
  final DateTime localTime;
  final String offsetLabel;

  @override
  List<Object?> get props => [city, localTime, offsetLabel];
}

class WorldClockState extends Equatable {
  const WorldClockState({
    this.cityIds = const ['Africa/Addis_Ababa', 'Europe/London', 'America/New_York'],
    this.entries = const [],
    this.initialized = false,
  });

  final List<String> cityIds;
  final List<WorldClockEntry> entries;
  final bool initialized;

  WorldClockState copyWith({
    List<String>? cityIds,
    List<WorldClockEntry>? entries,
    bool? initialized,
  }) {
    return WorldClockState(
      cityIds: cityIds ?? this.cityIds,
      entries: entries ?? this.entries,
      initialized: initialized ?? this.initialized,
    );
  }

  @override
  List<Object?> get props => [cityIds, entries, initialized];
}

class WorldClockController extends Notifier<WorldClockState> {
  Timer? _ticker;
  var _tzReady = false;

  @override
  WorldClockState build() {
    ref.onDispose(() => _ticker?.cancel());
    Future.microtask(_init);
    return const WorldClockState();
  }

  Future<void> _init() async {
    if (!_tzReady) {
      tzdata.initializeTimeZones();
      _tzReady = true;
    }
    final raw =
        await ref.read(settingsRepositoryProvider).get(SettingKeys.worldClockCities);
    final value = raw.when(onSuccess: (v) => v, onFailure: (_) => null);
    var ids = const [
      'Africa/Addis_Ababa',
      'Europe/London',
      'Europe/Oslo',
      'America/New_York',
    ];
    if (value != null) {
      try {
        ids = (jsonDecode(value) as List<dynamic>).cast<String>();
      } catch (_) {}
    }
    state = state.copyWith(cityIds: ids, initialized: true);
    _refresh();
    _ticker = Timer.periodic(const Duration(seconds: 1), (_) => _refresh());
  }

  Future<void> addCity(String id) async {
    if (state.cityIds.contains(id)) return;
    final next = [...state.cityIds, id];
    state = state.copyWith(cityIds: next);
    await _persist(next);
    _refresh();
  }

  Future<void> removeCity(String id) async {
    final next = state.cityIds.where((c) => c != id).toList();
    state = state.copyWith(cityIds: next);
    await _persist(next);
    _refresh();
  }

  Future<void> _persist(List<String> ids) async {
    await ref
        .read(settingsRepositoryProvider)
        .set(SettingKeys.worldClockCities, jsonEncode(ids));
  }

  void _refresh() {
    if (!_tzReady) return;
    final nowUtc = DateTime.now().toUtc();
    final local = DateTime.now();
    final localOffset = local.timeZoneOffset;
    final entries = <WorldClockEntry>[];
    for (final id in state.cityIds) {
      final city = curatedWorldCities.where((c) => c.id == id).firstOrNull ??
          WorldCity(id: id, name: id.split('/').last.replaceAll('_', ' '), region: '');
      try {
        final location = tz.getLocation(id);
        final there = tz.TZDateTime.from(nowUtc, location);
        final offset = there.timeZoneOffset;
        final diff = offset - localOffset;
        final hours = diff.inHours;
        final mins = diff.inMinutes.remainder(60).abs();
        final sign = diff.isNegative ? '-' : '+';
        final label = hours == 0 && mins == 0
            ? 'Same as local'
            : '$sign${hours.abs()}h${mins > 0 ? ' ${mins}m' : ''}';
        entries.add(
          WorldClockEntry(
            city: city,
            localTime: DateTime(
              there.year,
              there.month,
              there.day,
              there.hour,
              there.minute,
              there.second,
            ),
            offsetLabel: label,
          ),
        );
      } catch (_) {
        entries.add(
          WorldClockEntry(
            city: city,
            localTime: local,
            offsetLabel: 'Unavailable',
          ),
        );
      }
    }
    state = state.copyWith(entries: entries);
  }
}

final worldClockControllerProvider =
    NotifierProvider<WorldClockController, WorldClockState>(
  WorldClockController.new,
);
