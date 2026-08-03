import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

/// A collection that groups notes.
class Notebook extends Equatable {
  const Notebook({
    required this.id,
    required this.name,
    required this.coverColor,
    required this.sortOrder,
    required this.createdAt,
    required this.updatedAt,
    this.coverImagePath,
  });

  final String id;
  final String name;
  final Color coverColor;
  final String? coverImagePath;
  final int sortOrder;
  final DateTime createdAt;
  final DateTime updatedAt;

  Notebook copyWith({
    String? name,
    Color? coverColor,
    String? coverImagePath,
    int? sortOrder,
    DateTime? updatedAt,
    bool clearCoverImagePath = false,
  }) {
    return Notebook(
      id: id,
      name: name ?? this.name,
      coverColor: coverColor ?? this.coverColor,
      coverImagePath:
          clearCoverImagePath ? null : coverImagePath ?? this.coverImagePath,
      sortOrder: sortOrder ?? this.sortOrder,
      createdAt: createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  List<Object?> get props => [
        id,
        name,
        coverColor,
        coverImagePath,
        sortOrder,
        createdAt,
        updatedAt,
      ];
}
