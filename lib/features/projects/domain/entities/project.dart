import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

/// A trackable work project / contract.
class Project extends Equatable {
  const Project({
    required this.id,
    required this.name,
    required this.color,
    required this.archived,
    required this.createdAt,
    required this.updatedAt,
    this.clientName,
    this.description,
    this.hourlyRate,
    this.weeklyLimitHours = 40,
    this.contractType = 'Hourly',
  });

  final String id;
  final String name;
  final Color color;
  final bool archived;
  final String? clientName;
  final String? description;
  final double? hourlyRate;
  final int? weeklyLimitHours;
  final String? contractType;
  final DateTime createdAt;
  final DateTime updatedAt;

  Project copyWith({
    String? name,
    Color? color,
    bool? archived,
    String? clientName,
    String? description,
    double? hourlyRate,
    int? weeklyLimitHours,
    String? contractType,
    DateTime? updatedAt,
    bool clearClientName = false,
    bool clearDescription = false,
    bool clearHourlyRate = false,
  }) {
    return Project(
      id: id,
      name: name ?? this.name,
      color: color ?? this.color,
      archived: archived ?? this.archived,
      clientName: clearClientName ? null : clientName ?? this.clientName,
      description: clearDescription ? null : description ?? this.description,
      hourlyRate: clearHourlyRate ? null : hourlyRate ?? this.hourlyRate,
      weeklyLimitHours: weeklyLimitHours ?? this.weeklyLimitHours,
      contractType: contractType ?? this.contractType,
      createdAt: createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  List<Object?> get props => [
        id,
        name,
        color,
        archived,
        clientName,
        description,
        hourlyRate,
        weeklyLimitHours,
        contractType,
        createdAt,
        updatedAt,
      ];
}
