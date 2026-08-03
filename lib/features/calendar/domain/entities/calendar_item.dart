import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

/// Origin of a row on the hybrid calendar.
enum CalendarItemSource { google, task, timeEntry }

/// Unified calendar feed item (Google event, task due, or tracked time).
class CalendarItem extends Equatable {
  const CalendarItem({
    required this.id,
    required this.source,
    required this.title,
    required this.startAt,
    required this.endAt,
    required this.allDay,
    this.description,
    this.htmlLink,
    this.color,
    this.projectId,
    this.taskId,
  });

  final String id;
  final CalendarItemSource source;
  final String title;
  final DateTime startAt;
  final DateTime endAt;
  final bool allDay;
  final String? description;
  final String? htmlLink;
  final Color? color;
  final String? projectId;
  final String? taskId;

  @override
  List<Object?> get props => [
        id,
        source,
        title,
        startAt,
        endAt,
        allDay,
        description,
        htmlLink,
        color,
        projectId,
        taskId,
      ];
}

/// Connected Google Calendar account metadata (tokens live in secure storage).
class CalendarAccount extends Equatable {
  const CalendarAccount({
    required this.id,
    required this.provider,
    required this.email,
    required this.calendarId,
    required this.connectedAt,
    this.lastSyncAt,
  });

  final String id;
  final String provider;
  final String email;
  final String calendarId;
  final DateTime connectedAt;
  final DateTime? lastSyncAt;

  CalendarAccount copyWith({DateTime? lastSyncAt}) {
    return CalendarAccount(
      id: id,
      provider: provider,
      email: email,
      calendarId: calendarId,
      connectedAt: connectedAt,
      lastSyncAt: lastSyncAt ?? this.lastSyncAt,
    );
  }

  @override
  List<Object?> get props =>
      [id, provider, email, calendarId, connectedAt, lastSyncAt];
}
