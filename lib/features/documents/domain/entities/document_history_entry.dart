/// A recently opened markdown file or folder.
class DocumentHistoryEntry {
  const DocumentHistoryEntry({
    required this.path,
    required this.kind,
    required this.accessedAt,
    this.lastFilePath,
  });

  final String path;
  final DocumentHistoryKind kind;
  final DateTime accessedAt;
  final String? lastFilePath;

  DocumentHistoryEntry copyWith({
    String? path,
    DocumentHistoryKind? kind,
    DateTime? accessedAt,
    String? lastFilePath,
  }) {
    return DocumentHistoryEntry(
      path: path ?? this.path,
      kind: kind ?? this.kind,
      accessedAt: accessedAt ?? this.accessedAt,
      lastFilePath: lastFilePath ?? this.lastFilePath,
    );
  }

  Map<String, dynamic> toJson() => {
        'path': path,
        'kind': kind.name,
        'accessedAt': accessedAt.toIso8601String(),
        if (lastFilePath != null) 'lastFilePath': lastFilePath,
      };

  factory DocumentHistoryEntry.fromJson(Map<String, dynamic> json) {
    return DocumentHistoryEntry(
      path: json['path'] as String,
      kind: DocumentHistoryKind.values.byName(json['kind'] as String),
      accessedAt: DateTime.parse(json['accessedAt'] as String),
      lastFilePath: json['lastFilePath'] as String?,
    );
  }
}

enum DocumentHistoryKind {
  file,
  folder,
}
