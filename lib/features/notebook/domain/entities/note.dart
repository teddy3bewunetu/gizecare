import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

import 'package:gizecare/features/notebook/domain/entities/note_type.dart';
import 'package:gizecare/features/notebook/domain/note_document_codec.dart';

/// A single note card inside a notebook.
class Note extends Equatable {
  const Note({
    required this.id,
    required this.notebookId,
    required this.title,
    required this.body,
    required this.noteType,
    required this.color,
    required this.isPinned,
    required this.isFavorite,
    required this.isLocked,
    required this.createdAt,
    required this.updatedAt,
    this.projectId,
    this.taskId,
  });

  final String id;
  final String notebookId;
  final String title;
  final String body;
  final NoteType noteType;
  final Color color;
  final bool isPinned;
  final bool isFavorite;
  final bool isLocked;
  final String? projectId;
  final String? taskId;
  final DateTime createdAt;
  final DateTime updatedAt;

  /// Preview text for sidebar rows (supports AppFlowy JSON + legacy plain).
  String get snippet => NoteDocumentCodec.snippetFromBody(body);

  Note copyWith({
    String? notebookId,
    String? title,
    String? body,
    NoteType? noteType,
    Color? color,
    bool? isPinned,
    bool? isFavorite,
    bool? isLocked,
    String? projectId,
    String? taskId,
    DateTime? updatedAt,
    bool clearProjectId = false,
    bool clearTaskId = false,
  }) {
    return Note(
      id: id,
      notebookId: notebookId ?? this.notebookId,
      title: title ?? this.title,
      body: body ?? this.body,
      noteType: noteType ?? this.noteType,
      color: color ?? this.color,
      isPinned: isPinned ?? this.isPinned,
      isFavorite: isFavorite ?? this.isFavorite,
      isLocked: isLocked ?? this.isLocked,
      projectId: clearProjectId ? null : projectId ?? this.projectId,
      taskId: clearTaskId ? null : taskId ?? this.taskId,
      createdAt: createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  List<Object?> get props => [
        id,
        notebookId,
        title,
        body,
        noteType,
        color,
        isPinned,
        isFavorite,
        isLocked,
        projectId,
        taskId,
        createdAt,
        updatedAt,
      ];
}
