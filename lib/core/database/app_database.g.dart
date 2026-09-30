// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $ProjectsTable extends Projects
    with TableInfo<$ProjectsTable, ProjectRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ProjectsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 120,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _colorMeta = const VerificationMeta('color');
  @override
  late final GeneratedColumn<int> color = GeneratedColumn<int>(
    'color',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _archivedMeta = const VerificationMeta(
    'archived',
  );
  @override
  late final GeneratedColumn<bool> archived = GeneratedColumn<bool>(
    'archived',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("archived" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _clientNameMeta = const VerificationMeta(
    'clientName',
  );
  @override
  late final GeneratedColumn<String> clientName = GeneratedColumn<String>(
    'client_name',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _descriptionMeta = const VerificationMeta(
    'description',
  );
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
    'description',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _hourlyRateMeta = const VerificationMeta(
    'hourlyRate',
  );
  @override
  late final GeneratedColumn<double> hourlyRate = GeneratedColumn<double>(
    'hourly_rate',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _weeklyLimitHoursMeta = const VerificationMeta(
    'weeklyLimitHours',
  );
  @override
  late final GeneratedColumn<int> weeklyLimitHours = GeneratedColumn<int>(
    'weekly_limit_hours',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(40),
  );
  static const VerificationMeta _contractTypeMeta = const VerificationMeta(
    'contractType',
  );
  @override
  late final GeneratedColumn<String> contractType = GeneratedColumn<String>(
    'contract_type',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('Hourly'),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
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
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'projects';
  @override
  VerificationContext validateIntegrity(
    Insertable<ProjectRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('color')) {
      context.handle(
        _colorMeta,
        color.isAcceptableOrUnknown(data['color']!, _colorMeta),
      );
    } else if (isInserting) {
      context.missing(_colorMeta);
    }
    if (data.containsKey('archived')) {
      context.handle(
        _archivedMeta,
        archived.isAcceptableOrUnknown(data['archived']!, _archivedMeta),
      );
    }
    if (data.containsKey('client_name')) {
      context.handle(
        _clientNameMeta,
        clientName.isAcceptableOrUnknown(data['client_name']!, _clientNameMeta),
      );
    }
    if (data.containsKey('description')) {
      context.handle(
        _descriptionMeta,
        description.isAcceptableOrUnknown(
          data['description']!,
          _descriptionMeta,
        ),
      );
    }
    if (data.containsKey('hourly_rate')) {
      context.handle(
        _hourlyRateMeta,
        hourlyRate.isAcceptableOrUnknown(data['hourly_rate']!, _hourlyRateMeta),
      );
    }
    if (data.containsKey('weekly_limit_hours')) {
      context.handle(
        _weeklyLimitHoursMeta,
        weeklyLimitHours.isAcceptableOrUnknown(
          data['weekly_limit_hours']!,
          _weeklyLimitHoursMeta,
        ),
      );
    }
    if (data.containsKey('contract_type')) {
      context.handle(
        _contractTypeMeta,
        contractType.isAcceptableOrUnknown(
          data['contract_type']!,
          _contractTypeMeta,
        ),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ProjectRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ProjectRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      color: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}color'],
      )!,
      archived: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}archived'],
      )!,
      clientName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}client_name'],
      ),
      description: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}description'],
      ),
      hourlyRate: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}hourly_rate'],
      ),
      weeklyLimitHours: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}weekly_limit_hours'],
      ),
      contractType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}contract_type'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $ProjectsTable createAlias(String alias) {
    return $ProjectsTable(attachedDatabase, alias);
  }
}

class ProjectRow extends DataClass implements Insertable<ProjectRow> {
  final String id;
  final String name;
  final int color;
  final bool archived;

  /// Client / contract counterpart display name.
  final String? clientName;

  /// Longer contract / project description.
  final String? description;

  /// Hourly rate in major currency units (e.g. 9.26).
  final double? hourlyRate;

  /// Soft weekly hour cap (Upwork-style).
  final int? weeklyLimitHours;

  /// e.g. Hourly, Fixed.
  final String? contractType;
  final DateTime createdAt;
  final DateTime updatedAt;
  const ProjectRow({
    required this.id,
    required this.name,
    required this.color,
    required this.archived,
    this.clientName,
    this.description,
    this.hourlyRate,
    this.weeklyLimitHours,
    this.contractType,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    map['color'] = Variable<int>(color);
    map['archived'] = Variable<bool>(archived);
    if (!nullToAbsent || clientName != null) {
      map['client_name'] = Variable<String>(clientName);
    }
    if (!nullToAbsent || description != null) {
      map['description'] = Variable<String>(description);
    }
    if (!nullToAbsent || hourlyRate != null) {
      map['hourly_rate'] = Variable<double>(hourlyRate);
    }
    if (!nullToAbsent || weeklyLimitHours != null) {
      map['weekly_limit_hours'] = Variable<int>(weeklyLimitHours);
    }
    if (!nullToAbsent || contractType != null) {
      map['contract_type'] = Variable<String>(contractType);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  ProjectsCompanion toCompanion(bool nullToAbsent) {
    return ProjectsCompanion(
      id: Value(id),
      name: Value(name),
      color: Value(color),
      archived: Value(archived),
      clientName: clientName == null && nullToAbsent
          ? const Value.absent()
          : Value(clientName),
      description: description == null && nullToAbsent
          ? const Value.absent()
          : Value(description),
      hourlyRate: hourlyRate == null && nullToAbsent
          ? const Value.absent()
          : Value(hourlyRate),
      weeklyLimitHours: weeklyLimitHours == null && nullToAbsent
          ? const Value.absent()
          : Value(weeklyLimitHours),
      contractType: contractType == null && nullToAbsent
          ? const Value.absent()
          : Value(contractType),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory ProjectRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ProjectRow(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      color: serializer.fromJson<int>(json['color']),
      archived: serializer.fromJson<bool>(json['archived']),
      clientName: serializer.fromJson<String?>(json['clientName']),
      description: serializer.fromJson<String?>(json['description']),
      hourlyRate: serializer.fromJson<double?>(json['hourlyRate']),
      weeklyLimitHours: serializer.fromJson<int?>(json['weeklyLimitHours']),
      contractType: serializer.fromJson<String?>(json['contractType']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'color': serializer.toJson<int>(color),
      'archived': serializer.toJson<bool>(archived),
      'clientName': serializer.toJson<String?>(clientName),
      'description': serializer.toJson<String?>(description),
      'hourlyRate': serializer.toJson<double?>(hourlyRate),
      'weeklyLimitHours': serializer.toJson<int?>(weeklyLimitHours),
      'contractType': serializer.toJson<String?>(contractType),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  ProjectRow copyWith({
    String? id,
    String? name,
    int? color,
    bool? archived,
    Value<String?> clientName = const Value.absent(),
    Value<String?> description = const Value.absent(),
    Value<double?> hourlyRate = const Value.absent(),
    Value<int?> weeklyLimitHours = const Value.absent(),
    Value<String?> contractType = const Value.absent(),
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => ProjectRow(
    id: id ?? this.id,
    name: name ?? this.name,
    color: color ?? this.color,
    archived: archived ?? this.archived,
    clientName: clientName.present ? clientName.value : this.clientName,
    description: description.present ? description.value : this.description,
    hourlyRate: hourlyRate.present ? hourlyRate.value : this.hourlyRate,
    weeklyLimitHours: weeklyLimitHours.present
        ? weeklyLimitHours.value
        : this.weeklyLimitHours,
    contractType: contractType.present ? contractType.value : this.contractType,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  ProjectRow copyWithCompanion(ProjectsCompanion data) {
    return ProjectRow(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      color: data.color.present ? data.color.value : this.color,
      archived: data.archived.present ? data.archived.value : this.archived,
      clientName: data.clientName.present
          ? data.clientName.value
          : this.clientName,
      description: data.description.present
          ? data.description.value
          : this.description,
      hourlyRate: data.hourlyRate.present
          ? data.hourlyRate.value
          : this.hourlyRate,
      weeklyLimitHours: data.weeklyLimitHours.present
          ? data.weeklyLimitHours.value
          : this.weeklyLimitHours,
      contractType: data.contractType.present
          ? data.contractType.value
          : this.contractType,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ProjectRow(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('color: $color, ')
          ..write('archived: $archived, ')
          ..write('clientName: $clientName, ')
          ..write('description: $description, ')
          ..write('hourlyRate: $hourlyRate, ')
          ..write('weeklyLimitHours: $weeklyLimitHours, ')
          ..write('contractType: $contractType, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
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
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ProjectRow &&
          other.id == this.id &&
          other.name == this.name &&
          other.color == this.color &&
          other.archived == this.archived &&
          other.clientName == this.clientName &&
          other.description == this.description &&
          other.hourlyRate == this.hourlyRate &&
          other.weeklyLimitHours == this.weeklyLimitHours &&
          other.contractType == this.contractType &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class ProjectsCompanion extends UpdateCompanion<ProjectRow> {
  final Value<String> id;
  final Value<String> name;
  final Value<int> color;
  final Value<bool> archived;
  final Value<String?> clientName;
  final Value<String?> description;
  final Value<double?> hourlyRate;
  final Value<int?> weeklyLimitHours;
  final Value<String?> contractType;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const ProjectsCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.color = const Value.absent(),
    this.archived = const Value.absent(),
    this.clientName = const Value.absent(),
    this.description = const Value.absent(),
    this.hourlyRate = const Value.absent(),
    this.weeklyLimitHours = const Value.absent(),
    this.contractType = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ProjectsCompanion.insert({
    required String id,
    required String name,
    required int color,
    this.archived = const Value.absent(),
    this.clientName = const Value.absent(),
    this.description = const Value.absent(),
    this.hourlyRate = const Value.absent(),
    this.weeklyLimitHours = const Value.absent(),
    this.contractType = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       name = Value(name),
       color = Value(color),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<ProjectRow> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<int>? color,
    Expression<bool>? archived,
    Expression<String>? clientName,
    Expression<String>? description,
    Expression<double>? hourlyRate,
    Expression<int>? weeklyLimitHours,
    Expression<String>? contractType,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (color != null) 'color': color,
      if (archived != null) 'archived': archived,
      if (clientName != null) 'client_name': clientName,
      if (description != null) 'description': description,
      if (hourlyRate != null) 'hourly_rate': hourlyRate,
      if (weeklyLimitHours != null) 'weekly_limit_hours': weeklyLimitHours,
      if (contractType != null) 'contract_type': contractType,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ProjectsCompanion copyWith({
    Value<String>? id,
    Value<String>? name,
    Value<int>? color,
    Value<bool>? archived,
    Value<String?>? clientName,
    Value<String?>? description,
    Value<double?>? hourlyRate,
    Value<int?>? weeklyLimitHours,
    Value<String?>? contractType,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return ProjectsCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      color: color ?? this.color,
      archived: archived ?? this.archived,
      clientName: clientName ?? this.clientName,
      description: description ?? this.description,
      hourlyRate: hourlyRate ?? this.hourlyRate,
      weeklyLimitHours: weeklyLimitHours ?? this.weeklyLimitHours,
      contractType: contractType ?? this.contractType,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (color.present) {
      map['color'] = Variable<int>(color.value);
    }
    if (archived.present) {
      map['archived'] = Variable<bool>(archived.value);
    }
    if (clientName.present) {
      map['client_name'] = Variable<String>(clientName.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (hourlyRate.present) {
      map['hourly_rate'] = Variable<double>(hourlyRate.value);
    }
    if (weeklyLimitHours.present) {
      map['weekly_limit_hours'] = Variable<int>(weeklyLimitHours.value);
    }
    if (contractType.present) {
      map['contract_type'] = Variable<String>(contractType.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ProjectsCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('color: $color, ')
          ..write('archived: $archived, ')
          ..write('clientName: $clientName, ')
          ..write('description: $description, ')
          ..write('hourlyRate: $hourlyRate, ')
          ..write('weeklyLimitHours: $weeklyLimitHours, ')
          ..write('contractType: $contractType, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $BoardColumnsTable extends BoardColumns
    with TableInfo<$BoardColumnsTable, BoardColumnRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $BoardColumnsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _projectIdMeta = const VerificationMeta(
    'projectId',
  );
  @override
  late final GeneratedColumn<String> projectId = GeneratedColumn<String>(
    'project_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES projects (id)',
    ),
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 80,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _sortOrderMeta = const VerificationMeta(
    'sortOrder',
  );
  @override
  late final GeneratedColumn<int> sortOrder = GeneratedColumn<int>(
    'sort_order',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _wipLimitMeta = const VerificationMeta(
    'wipLimit',
  );
  @override
  late final GeneratedColumn<int> wipLimit = GeneratedColumn<int>(
    'wip_limit',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    projectId,
    name,
    sortOrder,
    wipLimit,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'board_columns';
  @override
  VerificationContext validateIntegrity(
    Insertable<BoardColumnRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('project_id')) {
      context.handle(
        _projectIdMeta,
        projectId.isAcceptableOrUnknown(data['project_id']!, _projectIdMeta),
      );
    } else if (isInserting) {
      context.missing(_projectIdMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('sort_order')) {
      context.handle(
        _sortOrderMeta,
        sortOrder.isAcceptableOrUnknown(data['sort_order']!, _sortOrderMeta),
      );
    }
    if (data.containsKey('wip_limit')) {
      context.handle(
        _wipLimitMeta,
        wipLimit.isAcceptableOrUnknown(data['wip_limit']!, _wipLimitMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  BoardColumnRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return BoardColumnRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      projectId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}project_id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      sortOrder: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sort_order'],
      )!,
      wipLimit: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}wip_limit'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $BoardColumnsTable createAlias(String alias) {
    return $BoardColumnsTable(attachedDatabase, alias);
  }
}

class BoardColumnRow extends DataClass implements Insertable<BoardColumnRow> {
  final String id;
  final String projectId;
  final String name;
  final int sortOrder;
  final int? wipLimit;
  final DateTime createdAt;
  const BoardColumnRow({
    required this.id,
    required this.projectId,
    required this.name,
    required this.sortOrder,
    this.wipLimit,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['project_id'] = Variable<String>(projectId);
    map['name'] = Variable<String>(name);
    map['sort_order'] = Variable<int>(sortOrder);
    if (!nullToAbsent || wipLimit != null) {
      map['wip_limit'] = Variable<int>(wipLimit);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  BoardColumnsCompanion toCompanion(bool nullToAbsent) {
    return BoardColumnsCompanion(
      id: Value(id),
      projectId: Value(projectId),
      name: Value(name),
      sortOrder: Value(sortOrder),
      wipLimit: wipLimit == null && nullToAbsent
          ? const Value.absent()
          : Value(wipLimit),
      createdAt: Value(createdAt),
    );
  }

  factory BoardColumnRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return BoardColumnRow(
      id: serializer.fromJson<String>(json['id']),
      projectId: serializer.fromJson<String>(json['projectId']),
      name: serializer.fromJson<String>(json['name']),
      sortOrder: serializer.fromJson<int>(json['sortOrder']),
      wipLimit: serializer.fromJson<int?>(json['wipLimit']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'projectId': serializer.toJson<String>(projectId),
      'name': serializer.toJson<String>(name),
      'sortOrder': serializer.toJson<int>(sortOrder),
      'wipLimit': serializer.toJson<int?>(wipLimit),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  BoardColumnRow copyWith({
    String? id,
    String? projectId,
    String? name,
    int? sortOrder,
    Value<int?> wipLimit = const Value.absent(),
    DateTime? createdAt,
  }) => BoardColumnRow(
    id: id ?? this.id,
    projectId: projectId ?? this.projectId,
    name: name ?? this.name,
    sortOrder: sortOrder ?? this.sortOrder,
    wipLimit: wipLimit.present ? wipLimit.value : this.wipLimit,
    createdAt: createdAt ?? this.createdAt,
  );
  BoardColumnRow copyWithCompanion(BoardColumnsCompanion data) {
    return BoardColumnRow(
      id: data.id.present ? data.id.value : this.id,
      projectId: data.projectId.present ? data.projectId.value : this.projectId,
      name: data.name.present ? data.name.value : this.name,
      sortOrder: data.sortOrder.present ? data.sortOrder.value : this.sortOrder,
      wipLimit: data.wipLimit.present ? data.wipLimit.value : this.wipLimit,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('BoardColumnRow(')
          ..write('id: $id, ')
          ..write('projectId: $projectId, ')
          ..write('name: $name, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('wipLimit: $wipLimit, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, projectId, name, sortOrder, wipLimit, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is BoardColumnRow &&
          other.id == this.id &&
          other.projectId == this.projectId &&
          other.name == this.name &&
          other.sortOrder == this.sortOrder &&
          other.wipLimit == this.wipLimit &&
          other.createdAt == this.createdAt);
}

class BoardColumnsCompanion extends UpdateCompanion<BoardColumnRow> {
  final Value<String> id;
  final Value<String> projectId;
  final Value<String> name;
  final Value<int> sortOrder;
  final Value<int?> wipLimit;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const BoardColumnsCompanion({
    this.id = const Value.absent(),
    this.projectId = const Value.absent(),
    this.name = const Value.absent(),
    this.sortOrder = const Value.absent(),
    this.wipLimit = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  BoardColumnsCompanion.insert({
    required String id,
    required String projectId,
    required String name,
    this.sortOrder = const Value.absent(),
    this.wipLimit = const Value.absent(),
    required DateTime createdAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       projectId = Value(projectId),
       name = Value(name),
       createdAt = Value(createdAt);
  static Insertable<BoardColumnRow> custom({
    Expression<String>? id,
    Expression<String>? projectId,
    Expression<String>? name,
    Expression<int>? sortOrder,
    Expression<int>? wipLimit,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (projectId != null) 'project_id': projectId,
      if (name != null) 'name': name,
      if (sortOrder != null) 'sort_order': sortOrder,
      if (wipLimit != null) 'wip_limit': wipLimit,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  BoardColumnsCompanion copyWith({
    Value<String>? id,
    Value<String>? projectId,
    Value<String>? name,
    Value<int>? sortOrder,
    Value<int?>? wipLimit,
    Value<DateTime>? createdAt,
    Value<int>? rowid,
  }) {
    return BoardColumnsCompanion(
      id: id ?? this.id,
      projectId: projectId ?? this.projectId,
      name: name ?? this.name,
      sortOrder: sortOrder ?? this.sortOrder,
      wipLimit: wipLimit ?? this.wipLimit,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (projectId.present) {
      map['project_id'] = Variable<String>(projectId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (sortOrder.present) {
      map['sort_order'] = Variable<int>(sortOrder.value);
    }
    if (wipLimit.present) {
      map['wip_limit'] = Variable<int>(wipLimit.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('BoardColumnsCompanion(')
          ..write('id: $id, ')
          ..write('projectId: $projectId, ')
          ..write('name: $name, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('wipLimit: $wipLimit, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $TasksTable extends Tasks with TableInfo<$TasksTable, TaskRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TasksTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _projectIdMeta = const VerificationMeta(
    'projectId',
  );
  @override
  late final GeneratedColumn<String> projectId = GeneratedColumn<String>(
    'project_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES projects (id)',
    ),
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 200,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _descriptionMeta = const VerificationMeta(
    'description',
  );
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
    'description',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _columnIdMeta = const VerificationMeta(
    'columnId',
  );
  @override
  late final GeneratedColumn<String> columnId = GeneratedColumn<String>(
    'column_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES board_columns (id)',
    ),
  );
  static const VerificationMeta _sortOrderMeta = const VerificationMeta(
    'sortOrder',
  );
  @override
  late final GeneratedColumn<int> sortOrder = GeneratedColumn<int>(
    'sort_order',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _priorityMeta = const VerificationMeta(
    'priority',
  );
  @override
  late final GeneratedColumn<String> priority = GeneratedColumn<String>(
    'priority',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('none'),
  );
  static const VerificationMeta _dueAtMeta = const VerificationMeta('dueAt');
  @override
  late final GeneratedColumn<DateTime> dueAt = GeneratedColumn<DateTime>(
    'due_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _coverColorMeta = const VerificationMeta(
    'coverColor',
  );
  @override
  late final GeneratedColumn<int> coverColor = GeneratedColumn<int>(
    'cover_color',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _archivedMeta = const VerificationMeta(
    'archived',
  );
  @override
  late final GeneratedColumn<bool> archived = GeneratedColumn<bool>(
    'archived',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("archived" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
    defaultValue: currentDateAndTime,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    projectId,
    name,
    description,
    columnId,
    sortOrder,
    priority,
    dueAt,
    coverColor,
    archived,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'tasks';
  @override
  VerificationContext validateIntegrity(
    Insertable<TaskRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('project_id')) {
      context.handle(
        _projectIdMeta,
        projectId.isAcceptableOrUnknown(data['project_id']!, _projectIdMeta),
      );
    } else if (isInserting) {
      context.missing(_projectIdMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
        _descriptionMeta,
        description.isAcceptableOrUnknown(
          data['description']!,
          _descriptionMeta,
        ),
      );
    }
    if (data.containsKey('column_id')) {
      context.handle(
        _columnIdMeta,
        columnId.isAcceptableOrUnknown(data['column_id']!, _columnIdMeta),
      );
    }
    if (data.containsKey('sort_order')) {
      context.handle(
        _sortOrderMeta,
        sortOrder.isAcceptableOrUnknown(data['sort_order']!, _sortOrderMeta),
      );
    }
    if (data.containsKey('priority')) {
      context.handle(
        _priorityMeta,
        priority.isAcceptableOrUnknown(data['priority']!, _priorityMeta),
      );
    }
    if (data.containsKey('due_at')) {
      context.handle(
        _dueAtMeta,
        dueAt.isAcceptableOrUnknown(data['due_at']!, _dueAtMeta),
      );
    }
    if (data.containsKey('cover_color')) {
      context.handle(
        _coverColorMeta,
        coverColor.isAcceptableOrUnknown(data['cover_color']!, _coverColorMeta),
      );
    }
    if (data.containsKey('archived')) {
      context.handle(
        _archivedMeta,
        archived.isAcceptableOrUnknown(data['archived']!, _archivedMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  TaskRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TaskRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      projectId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}project_id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      description: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}description'],
      ),
      columnId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}column_id'],
      ),
      sortOrder: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sort_order'],
      )!,
      priority: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}priority'],
      )!,
      dueAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}due_at'],
      ),
      coverColor: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}cover_color'],
      ),
      archived: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}archived'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $TasksTable createAlias(String alias) {
    return $TasksTable(attachedDatabase, alias);
  }
}

class TaskRow extends DataClass implements Insertable<TaskRow> {
  final String id;
  final String projectId;
  final String name;
  final String? description;

  /// Board column; nullable only for migration safety — always set in app code.
  final String? columnId;
  final int sortOrder;

  /// none | low | medium | high | urgent
  final String priority;
  final DateTime? dueAt;
  final int? coverColor;
  final bool archived;
  final DateTime createdAt;
  final DateTime updatedAt;
  const TaskRow({
    required this.id,
    required this.projectId,
    required this.name,
    this.description,
    this.columnId,
    required this.sortOrder,
    required this.priority,
    this.dueAt,
    this.coverColor,
    required this.archived,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['project_id'] = Variable<String>(projectId);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || description != null) {
      map['description'] = Variable<String>(description);
    }
    if (!nullToAbsent || columnId != null) {
      map['column_id'] = Variable<String>(columnId);
    }
    map['sort_order'] = Variable<int>(sortOrder);
    map['priority'] = Variable<String>(priority);
    if (!nullToAbsent || dueAt != null) {
      map['due_at'] = Variable<DateTime>(dueAt);
    }
    if (!nullToAbsent || coverColor != null) {
      map['cover_color'] = Variable<int>(coverColor);
    }
    map['archived'] = Variable<bool>(archived);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  TasksCompanion toCompanion(bool nullToAbsent) {
    return TasksCompanion(
      id: Value(id),
      projectId: Value(projectId),
      name: Value(name),
      description: description == null && nullToAbsent
          ? const Value.absent()
          : Value(description),
      columnId: columnId == null && nullToAbsent
          ? const Value.absent()
          : Value(columnId),
      sortOrder: Value(sortOrder),
      priority: Value(priority),
      dueAt: dueAt == null && nullToAbsent
          ? const Value.absent()
          : Value(dueAt),
      coverColor: coverColor == null && nullToAbsent
          ? const Value.absent()
          : Value(coverColor),
      archived: Value(archived),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory TaskRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TaskRow(
      id: serializer.fromJson<String>(json['id']),
      projectId: serializer.fromJson<String>(json['projectId']),
      name: serializer.fromJson<String>(json['name']),
      description: serializer.fromJson<String?>(json['description']),
      columnId: serializer.fromJson<String?>(json['columnId']),
      sortOrder: serializer.fromJson<int>(json['sortOrder']),
      priority: serializer.fromJson<String>(json['priority']),
      dueAt: serializer.fromJson<DateTime?>(json['dueAt']),
      coverColor: serializer.fromJson<int?>(json['coverColor']),
      archived: serializer.fromJson<bool>(json['archived']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'projectId': serializer.toJson<String>(projectId),
      'name': serializer.toJson<String>(name),
      'description': serializer.toJson<String?>(description),
      'columnId': serializer.toJson<String?>(columnId),
      'sortOrder': serializer.toJson<int>(sortOrder),
      'priority': serializer.toJson<String>(priority),
      'dueAt': serializer.toJson<DateTime?>(dueAt),
      'coverColor': serializer.toJson<int?>(coverColor),
      'archived': serializer.toJson<bool>(archived),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  TaskRow copyWith({
    String? id,
    String? projectId,
    String? name,
    Value<String?> description = const Value.absent(),
    Value<String?> columnId = const Value.absent(),
    int? sortOrder,
    String? priority,
    Value<DateTime?> dueAt = const Value.absent(),
    Value<int?> coverColor = const Value.absent(),
    bool? archived,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => TaskRow(
    id: id ?? this.id,
    projectId: projectId ?? this.projectId,
    name: name ?? this.name,
    description: description.present ? description.value : this.description,
    columnId: columnId.present ? columnId.value : this.columnId,
    sortOrder: sortOrder ?? this.sortOrder,
    priority: priority ?? this.priority,
    dueAt: dueAt.present ? dueAt.value : this.dueAt,
    coverColor: coverColor.present ? coverColor.value : this.coverColor,
    archived: archived ?? this.archived,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  TaskRow copyWithCompanion(TasksCompanion data) {
    return TaskRow(
      id: data.id.present ? data.id.value : this.id,
      projectId: data.projectId.present ? data.projectId.value : this.projectId,
      name: data.name.present ? data.name.value : this.name,
      description: data.description.present
          ? data.description.value
          : this.description,
      columnId: data.columnId.present ? data.columnId.value : this.columnId,
      sortOrder: data.sortOrder.present ? data.sortOrder.value : this.sortOrder,
      priority: data.priority.present ? data.priority.value : this.priority,
      dueAt: data.dueAt.present ? data.dueAt.value : this.dueAt,
      coverColor: data.coverColor.present
          ? data.coverColor.value
          : this.coverColor,
      archived: data.archived.present ? data.archived.value : this.archived,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('TaskRow(')
          ..write('id: $id, ')
          ..write('projectId: $projectId, ')
          ..write('name: $name, ')
          ..write('description: $description, ')
          ..write('columnId: $columnId, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('priority: $priority, ')
          ..write('dueAt: $dueAt, ')
          ..write('coverColor: $coverColor, ')
          ..write('archived: $archived, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    projectId,
    name,
    description,
    columnId,
    sortOrder,
    priority,
    dueAt,
    coverColor,
    archived,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TaskRow &&
          other.id == this.id &&
          other.projectId == this.projectId &&
          other.name == this.name &&
          other.description == this.description &&
          other.columnId == this.columnId &&
          other.sortOrder == this.sortOrder &&
          other.priority == this.priority &&
          other.dueAt == this.dueAt &&
          other.coverColor == this.coverColor &&
          other.archived == this.archived &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class TasksCompanion extends UpdateCompanion<TaskRow> {
  final Value<String> id;
  final Value<String> projectId;
  final Value<String> name;
  final Value<String?> description;
  final Value<String?> columnId;
  final Value<int> sortOrder;
  final Value<String> priority;
  final Value<DateTime?> dueAt;
  final Value<int?> coverColor;
  final Value<bool> archived;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const TasksCompanion({
    this.id = const Value.absent(),
    this.projectId = const Value.absent(),
    this.name = const Value.absent(),
    this.description = const Value.absent(),
    this.columnId = const Value.absent(),
    this.sortOrder = const Value.absent(),
    this.priority = const Value.absent(),
    this.dueAt = const Value.absent(),
    this.coverColor = const Value.absent(),
    this.archived = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  TasksCompanion.insert({
    required String id,
    required String projectId,
    required String name,
    this.description = const Value.absent(),
    this.columnId = const Value.absent(),
    this.sortOrder = const Value.absent(),
    this.priority = const Value.absent(),
    this.dueAt = const Value.absent(),
    this.coverColor = const Value.absent(),
    this.archived = const Value.absent(),
    required DateTime createdAt,
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       projectId = Value(projectId),
       name = Value(name),
       createdAt = Value(createdAt);
  static Insertable<TaskRow> custom({
    Expression<String>? id,
    Expression<String>? projectId,
    Expression<String>? name,
    Expression<String>? description,
    Expression<String>? columnId,
    Expression<int>? sortOrder,
    Expression<String>? priority,
    Expression<DateTime>? dueAt,
    Expression<int>? coverColor,
    Expression<bool>? archived,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (projectId != null) 'project_id': projectId,
      if (name != null) 'name': name,
      if (description != null) 'description': description,
      if (columnId != null) 'column_id': columnId,
      if (sortOrder != null) 'sort_order': sortOrder,
      if (priority != null) 'priority': priority,
      if (dueAt != null) 'due_at': dueAt,
      if (coverColor != null) 'cover_color': coverColor,
      if (archived != null) 'archived': archived,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  TasksCompanion copyWith({
    Value<String>? id,
    Value<String>? projectId,
    Value<String>? name,
    Value<String?>? description,
    Value<String?>? columnId,
    Value<int>? sortOrder,
    Value<String>? priority,
    Value<DateTime?>? dueAt,
    Value<int?>? coverColor,
    Value<bool>? archived,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return TasksCompanion(
      id: id ?? this.id,
      projectId: projectId ?? this.projectId,
      name: name ?? this.name,
      description: description ?? this.description,
      columnId: columnId ?? this.columnId,
      sortOrder: sortOrder ?? this.sortOrder,
      priority: priority ?? this.priority,
      dueAt: dueAt ?? this.dueAt,
      coverColor: coverColor ?? this.coverColor,
      archived: archived ?? this.archived,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (projectId.present) {
      map['project_id'] = Variable<String>(projectId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (columnId.present) {
      map['column_id'] = Variable<String>(columnId.value);
    }
    if (sortOrder.present) {
      map['sort_order'] = Variable<int>(sortOrder.value);
    }
    if (priority.present) {
      map['priority'] = Variable<String>(priority.value);
    }
    if (dueAt.present) {
      map['due_at'] = Variable<DateTime>(dueAt.value);
    }
    if (coverColor.present) {
      map['cover_color'] = Variable<int>(coverColor.value);
    }
    if (archived.present) {
      map['archived'] = Variable<bool>(archived.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TasksCompanion(')
          ..write('id: $id, ')
          ..write('projectId: $projectId, ')
          ..write('name: $name, ')
          ..write('description: $description, ')
          ..write('columnId: $columnId, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('priority: $priority, ')
          ..write('dueAt: $dueAt, ')
          ..write('coverColor: $coverColor, ')
          ..write('archived: $archived, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ProjectLabelsTable extends ProjectLabels
    with TableInfo<$ProjectLabelsTable, ProjectLabelRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ProjectLabelsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _projectIdMeta = const VerificationMeta(
    'projectId',
  );
  @override
  late final GeneratedColumn<String> projectId = GeneratedColumn<String>(
    'project_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES projects (id)',
    ),
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 40,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _colorMeta = const VerificationMeta('color');
  @override
  late final GeneratedColumn<int> color = GeneratedColumn<int>(
    'color',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [id, projectId, name, color];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'project_labels';
  @override
  VerificationContext validateIntegrity(
    Insertable<ProjectLabelRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('project_id')) {
      context.handle(
        _projectIdMeta,
        projectId.isAcceptableOrUnknown(data['project_id']!, _projectIdMeta),
      );
    } else if (isInserting) {
      context.missing(_projectIdMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('color')) {
      context.handle(
        _colorMeta,
        color.isAcceptableOrUnknown(data['color']!, _colorMeta),
      );
    } else if (isInserting) {
      context.missing(_colorMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ProjectLabelRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ProjectLabelRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      projectId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}project_id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      color: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}color'],
      )!,
    );
  }

  @override
  $ProjectLabelsTable createAlias(String alias) {
    return $ProjectLabelsTable(attachedDatabase, alias);
  }
}

class ProjectLabelRow extends DataClass implements Insertable<ProjectLabelRow> {
  final String id;
  final String projectId;
  final String name;
  final int color;
  const ProjectLabelRow({
    required this.id,
    required this.projectId,
    required this.name,
    required this.color,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['project_id'] = Variable<String>(projectId);
    map['name'] = Variable<String>(name);
    map['color'] = Variable<int>(color);
    return map;
  }

  ProjectLabelsCompanion toCompanion(bool nullToAbsent) {
    return ProjectLabelsCompanion(
      id: Value(id),
      projectId: Value(projectId),
      name: Value(name),
      color: Value(color),
    );
  }

  factory ProjectLabelRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ProjectLabelRow(
      id: serializer.fromJson<String>(json['id']),
      projectId: serializer.fromJson<String>(json['projectId']),
      name: serializer.fromJson<String>(json['name']),
      color: serializer.fromJson<int>(json['color']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'projectId': serializer.toJson<String>(projectId),
      'name': serializer.toJson<String>(name),
      'color': serializer.toJson<int>(color),
    };
  }

  ProjectLabelRow copyWith({
    String? id,
    String? projectId,
    String? name,
    int? color,
  }) => ProjectLabelRow(
    id: id ?? this.id,
    projectId: projectId ?? this.projectId,
    name: name ?? this.name,
    color: color ?? this.color,
  );
  ProjectLabelRow copyWithCompanion(ProjectLabelsCompanion data) {
    return ProjectLabelRow(
      id: data.id.present ? data.id.value : this.id,
      projectId: data.projectId.present ? data.projectId.value : this.projectId,
      name: data.name.present ? data.name.value : this.name,
      color: data.color.present ? data.color.value : this.color,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ProjectLabelRow(')
          ..write('id: $id, ')
          ..write('projectId: $projectId, ')
          ..write('name: $name, ')
          ..write('color: $color')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, projectId, name, color);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ProjectLabelRow &&
          other.id == this.id &&
          other.projectId == this.projectId &&
          other.name == this.name &&
          other.color == this.color);
}

class ProjectLabelsCompanion extends UpdateCompanion<ProjectLabelRow> {
  final Value<String> id;
  final Value<String> projectId;
  final Value<String> name;
  final Value<int> color;
  final Value<int> rowid;
  const ProjectLabelsCompanion({
    this.id = const Value.absent(),
    this.projectId = const Value.absent(),
    this.name = const Value.absent(),
    this.color = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ProjectLabelsCompanion.insert({
    required String id,
    required String projectId,
    required String name,
    required int color,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       projectId = Value(projectId),
       name = Value(name),
       color = Value(color);
  static Insertable<ProjectLabelRow> custom({
    Expression<String>? id,
    Expression<String>? projectId,
    Expression<String>? name,
    Expression<int>? color,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (projectId != null) 'project_id': projectId,
      if (name != null) 'name': name,
      if (color != null) 'color': color,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ProjectLabelsCompanion copyWith({
    Value<String>? id,
    Value<String>? projectId,
    Value<String>? name,
    Value<int>? color,
    Value<int>? rowid,
  }) {
    return ProjectLabelsCompanion(
      id: id ?? this.id,
      projectId: projectId ?? this.projectId,
      name: name ?? this.name,
      color: color ?? this.color,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (projectId.present) {
      map['project_id'] = Variable<String>(projectId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (color.present) {
      map['color'] = Variable<int>(color.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ProjectLabelsCompanion(')
          ..write('id: $id, ')
          ..write('projectId: $projectId, ')
          ..write('name: $name, ')
          ..write('color: $color, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $TaskLabelLinksTable extends TaskLabelLinks
    with TableInfo<$TaskLabelLinksTable, TaskLabelLinkRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TaskLabelLinksTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _taskIdMeta = const VerificationMeta('taskId');
  @override
  late final GeneratedColumn<String> taskId = GeneratedColumn<String>(
    'task_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES tasks (id)',
    ),
  );
  static const VerificationMeta _labelIdMeta = const VerificationMeta(
    'labelId',
  );
  @override
  late final GeneratedColumn<String> labelId = GeneratedColumn<String>(
    'label_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES project_labels (id)',
    ),
  );
  @override
  List<GeneratedColumn> get $columns => [taskId, labelId];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'task_label_links';
  @override
  VerificationContext validateIntegrity(
    Insertable<TaskLabelLinkRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('task_id')) {
      context.handle(
        _taskIdMeta,
        taskId.isAcceptableOrUnknown(data['task_id']!, _taskIdMeta),
      );
    } else if (isInserting) {
      context.missing(_taskIdMeta);
    }
    if (data.containsKey('label_id')) {
      context.handle(
        _labelIdMeta,
        labelId.isAcceptableOrUnknown(data['label_id']!, _labelIdMeta),
      );
    } else if (isInserting) {
      context.missing(_labelIdMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {taskId, labelId};
  @override
  TaskLabelLinkRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TaskLabelLinkRow(
      taskId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}task_id'],
      )!,
      labelId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}label_id'],
      )!,
    );
  }

  @override
  $TaskLabelLinksTable createAlias(String alias) {
    return $TaskLabelLinksTable(attachedDatabase, alias);
  }
}

class TaskLabelLinkRow extends DataClass
    implements Insertable<TaskLabelLinkRow> {
  final String taskId;
  final String labelId;
  const TaskLabelLinkRow({required this.taskId, required this.labelId});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['task_id'] = Variable<String>(taskId);
    map['label_id'] = Variable<String>(labelId);
    return map;
  }

  TaskLabelLinksCompanion toCompanion(bool nullToAbsent) {
    return TaskLabelLinksCompanion(
      taskId: Value(taskId),
      labelId: Value(labelId),
    );
  }

  factory TaskLabelLinkRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TaskLabelLinkRow(
      taskId: serializer.fromJson<String>(json['taskId']),
      labelId: serializer.fromJson<String>(json['labelId']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'taskId': serializer.toJson<String>(taskId),
      'labelId': serializer.toJson<String>(labelId),
    };
  }

  TaskLabelLinkRow copyWith({String? taskId, String? labelId}) =>
      TaskLabelLinkRow(
        taskId: taskId ?? this.taskId,
        labelId: labelId ?? this.labelId,
      );
  TaskLabelLinkRow copyWithCompanion(TaskLabelLinksCompanion data) {
    return TaskLabelLinkRow(
      taskId: data.taskId.present ? data.taskId.value : this.taskId,
      labelId: data.labelId.present ? data.labelId.value : this.labelId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('TaskLabelLinkRow(')
          ..write('taskId: $taskId, ')
          ..write('labelId: $labelId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(taskId, labelId);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TaskLabelLinkRow &&
          other.taskId == this.taskId &&
          other.labelId == this.labelId);
}

class TaskLabelLinksCompanion extends UpdateCompanion<TaskLabelLinkRow> {
  final Value<String> taskId;
  final Value<String> labelId;
  final Value<int> rowid;
  const TaskLabelLinksCompanion({
    this.taskId = const Value.absent(),
    this.labelId = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  TaskLabelLinksCompanion.insert({
    required String taskId,
    required String labelId,
    this.rowid = const Value.absent(),
  }) : taskId = Value(taskId),
       labelId = Value(labelId);
  static Insertable<TaskLabelLinkRow> custom({
    Expression<String>? taskId,
    Expression<String>? labelId,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (taskId != null) 'task_id': taskId,
      if (labelId != null) 'label_id': labelId,
      if (rowid != null) 'rowid': rowid,
    });
  }

  TaskLabelLinksCompanion copyWith({
    Value<String>? taskId,
    Value<String>? labelId,
    Value<int>? rowid,
  }) {
    return TaskLabelLinksCompanion(
      taskId: taskId ?? this.taskId,
      labelId: labelId ?? this.labelId,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (taskId.present) {
      map['task_id'] = Variable<String>(taskId.value);
    }
    if (labelId.present) {
      map['label_id'] = Variable<String>(labelId.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TaskLabelLinksCompanion(')
          ..write('taskId: $taskId, ')
          ..write('labelId: $labelId, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $TaskChecklistsTable extends TaskChecklists
    with TableInfo<$TaskChecklistsTable, TaskChecklistRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TaskChecklistsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _taskIdMeta = const VerificationMeta('taskId');
  @override
  late final GeneratedColumn<String> taskId = GeneratedColumn<String>(
    'task_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES tasks (id)',
    ),
  );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 120,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _sortOrderMeta = const VerificationMeta(
    'sortOrder',
  );
  @override
  late final GeneratedColumn<int> sortOrder = GeneratedColumn<int>(
    'sort_order',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  @override
  List<GeneratedColumn> get $columns => [id, taskId, title, sortOrder];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'task_checklists';
  @override
  VerificationContext validateIntegrity(
    Insertable<TaskChecklistRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('task_id')) {
      context.handle(
        _taskIdMeta,
        taskId.isAcceptableOrUnknown(data['task_id']!, _taskIdMeta),
      );
    } else if (isInserting) {
      context.missing(_taskIdMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('sort_order')) {
      context.handle(
        _sortOrderMeta,
        sortOrder.isAcceptableOrUnknown(data['sort_order']!, _sortOrderMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  TaskChecklistRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TaskChecklistRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      taskId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}task_id'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      sortOrder: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sort_order'],
      )!,
    );
  }

  @override
  $TaskChecklistsTable createAlias(String alias) {
    return $TaskChecklistsTable(attachedDatabase, alias);
  }
}

class TaskChecklistRow extends DataClass
    implements Insertable<TaskChecklistRow> {
  final String id;
  final String taskId;
  final String title;
  final int sortOrder;
  const TaskChecklistRow({
    required this.id,
    required this.taskId,
    required this.title,
    required this.sortOrder,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['task_id'] = Variable<String>(taskId);
    map['title'] = Variable<String>(title);
    map['sort_order'] = Variable<int>(sortOrder);
    return map;
  }

  TaskChecklistsCompanion toCompanion(bool nullToAbsent) {
    return TaskChecklistsCompanion(
      id: Value(id),
      taskId: Value(taskId),
      title: Value(title),
      sortOrder: Value(sortOrder),
    );
  }

  factory TaskChecklistRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TaskChecklistRow(
      id: serializer.fromJson<String>(json['id']),
      taskId: serializer.fromJson<String>(json['taskId']),
      title: serializer.fromJson<String>(json['title']),
      sortOrder: serializer.fromJson<int>(json['sortOrder']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'taskId': serializer.toJson<String>(taskId),
      'title': serializer.toJson<String>(title),
      'sortOrder': serializer.toJson<int>(sortOrder),
    };
  }

  TaskChecklistRow copyWith({
    String? id,
    String? taskId,
    String? title,
    int? sortOrder,
  }) => TaskChecklistRow(
    id: id ?? this.id,
    taskId: taskId ?? this.taskId,
    title: title ?? this.title,
    sortOrder: sortOrder ?? this.sortOrder,
  );
  TaskChecklistRow copyWithCompanion(TaskChecklistsCompanion data) {
    return TaskChecklistRow(
      id: data.id.present ? data.id.value : this.id,
      taskId: data.taskId.present ? data.taskId.value : this.taskId,
      title: data.title.present ? data.title.value : this.title,
      sortOrder: data.sortOrder.present ? data.sortOrder.value : this.sortOrder,
    );
  }

  @override
  String toString() {
    return (StringBuffer('TaskChecklistRow(')
          ..write('id: $id, ')
          ..write('taskId: $taskId, ')
          ..write('title: $title, ')
          ..write('sortOrder: $sortOrder')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, taskId, title, sortOrder);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TaskChecklistRow &&
          other.id == this.id &&
          other.taskId == this.taskId &&
          other.title == this.title &&
          other.sortOrder == this.sortOrder);
}

class TaskChecklistsCompanion extends UpdateCompanion<TaskChecklistRow> {
  final Value<String> id;
  final Value<String> taskId;
  final Value<String> title;
  final Value<int> sortOrder;
  final Value<int> rowid;
  const TaskChecklistsCompanion({
    this.id = const Value.absent(),
    this.taskId = const Value.absent(),
    this.title = const Value.absent(),
    this.sortOrder = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  TaskChecklistsCompanion.insert({
    required String id,
    required String taskId,
    required String title,
    this.sortOrder = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       taskId = Value(taskId),
       title = Value(title);
  static Insertable<TaskChecklistRow> custom({
    Expression<String>? id,
    Expression<String>? taskId,
    Expression<String>? title,
    Expression<int>? sortOrder,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (taskId != null) 'task_id': taskId,
      if (title != null) 'title': title,
      if (sortOrder != null) 'sort_order': sortOrder,
      if (rowid != null) 'rowid': rowid,
    });
  }

  TaskChecklistsCompanion copyWith({
    Value<String>? id,
    Value<String>? taskId,
    Value<String>? title,
    Value<int>? sortOrder,
    Value<int>? rowid,
  }) {
    return TaskChecklistsCompanion(
      id: id ?? this.id,
      taskId: taskId ?? this.taskId,
      title: title ?? this.title,
      sortOrder: sortOrder ?? this.sortOrder,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (taskId.present) {
      map['task_id'] = Variable<String>(taskId.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (sortOrder.present) {
      map['sort_order'] = Variable<int>(sortOrder.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TaskChecklistsCompanion(')
          ..write('id: $id, ')
          ..write('taskId: $taskId, ')
          ..write('title: $title, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $TaskChecklistItemsTable extends TaskChecklistItems
    with TableInfo<$TaskChecklistItemsTable, TaskChecklistItemRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TaskChecklistItemsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _checklistIdMeta = const VerificationMeta(
    'checklistId',
  );
  @override
  late final GeneratedColumn<String> checklistId = GeneratedColumn<String>(
    'checklist_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES task_checklists (id)',
    ),
  );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 200,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _doneMeta = const VerificationMeta('done');
  @override
  late final GeneratedColumn<bool> done = GeneratedColumn<bool>(
    'done',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("done" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _sortOrderMeta = const VerificationMeta(
    'sortOrder',
  );
  @override
  late final GeneratedColumn<int> sortOrder = GeneratedColumn<int>(
    'sort_order',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    checklistId,
    title,
    done,
    sortOrder,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'task_checklist_items';
  @override
  VerificationContext validateIntegrity(
    Insertable<TaskChecklistItemRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('checklist_id')) {
      context.handle(
        _checklistIdMeta,
        checklistId.isAcceptableOrUnknown(
          data['checklist_id']!,
          _checklistIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_checklistIdMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('done')) {
      context.handle(
        _doneMeta,
        done.isAcceptableOrUnknown(data['done']!, _doneMeta),
      );
    }
    if (data.containsKey('sort_order')) {
      context.handle(
        _sortOrderMeta,
        sortOrder.isAcceptableOrUnknown(data['sort_order']!, _sortOrderMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  TaskChecklistItemRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TaskChecklistItemRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      checklistId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}checklist_id'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      done: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}done'],
      )!,
      sortOrder: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sort_order'],
      )!,
    );
  }

  @override
  $TaskChecklistItemsTable createAlias(String alias) {
    return $TaskChecklistItemsTable(attachedDatabase, alias);
  }
}

class TaskChecklistItemRow extends DataClass
    implements Insertable<TaskChecklistItemRow> {
  final String id;
  final String checklistId;
  final String title;
  final bool done;
  final int sortOrder;
  const TaskChecklistItemRow({
    required this.id,
    required this.checklistId,
    required this.title,
    required this.done,
    required this.sortOrder,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['checklist_id'] = Variable<String>(checklistId);
    map['title'] = Variable<String>(title);
    map['done'] = Variable<bool>(done);
    map['sort_order'] = Variable<int>(sortOrder);
    return map;
  }

  TaskChecklistItemsCompanion toCompanion(bool nullToAbsent) {
    return TaskChecklistItemsCompanion(
      id: Value(id),
      checklistId: Value(checklistId),
      title: Value(title),
      done: Value(done),
      sortOrder: Value(sortOrder),
    );
  }

  factory TaskChecklistItemRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TaskChecklistItemRow(
      id: serializer.fromJson<String>(json['id']),
      checklistId: serializer.fromJson<String>(json['checklistId']),
      title: serializer.fromJson<String>(json['title']),
      done: serializer.fromJson<bool>(json['done']),
      sortOrder: serializer.fromJson<int>(json['sortOrder']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'checklistId': serializer.toJson<String>(checklistId),
      'title': serializer.toJson<String>(title),
      'done': serializer.toJson<bool>(done),
      'sortOrder': serializer.toJson<int>(sortOrder),
    };
  }

  TaskChecklistItemRow copyWith({
    String? id,
    String? checklistId,
    String? title,
    bool? done,
    int? sortOrder,
  }) => TaskChecklistItemRow(
    id: id ?? this.id,
    checklistId: checklistId ?? this.checklistId,
    title: title ?? this.title,
    done: done ?? this.done,
    sortOrder: sortOrder ?? this.sortOrder,
  );
  TaskChecklistItemRow copyWithCompanion(TaskChecklistItemsCompanion data) {
    return TaskChecklistItemRow(
      id: data.id.present ? data.id.value : this.id,
      checklistId: data.checklistId.present
          ? data.checklistId.value
          : this.checklistId,
      title: data.title.present ? data.title.value : this.title,
      done: data.done.present ? data.done.value : this.done,
      sortOrder: data.sortOrder.present ? data.sortOrder.value : this.sortOrder,
    );
  }

  @override
  String toString() {
    return (StringBuffer('TaskChecklistItemRow(')
          ..write('id: $id, ')
          ..write('checklistId: $checklistId, ')
          ..write('title: $title, ')
          ..write('done: $done, ')
          ..write('sortOrder: $sortOrder')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, checklistId, title, done, sortOrder);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TaskChecklistItemRow &&
          other.id == this.id &&
          other.checklistId == this.checklistId &&
          other.title == this.title &&
          other.done == this.done &&
          other.sortOrder == this.sortOrder);
}

class TaskChecklistItemsCompanion
    extends UpdateCompanion<TaskChecklistItemRow> {
  final Value<String> id;
  final Value<String> checklistId;
  final Value<String> title;
  final Value<bool> done;
  final Value<int> sortOrder;
  final Value<int> rowid;
  const TaskChecklistItemsCompanion({
    this.id = const Value.absent(),
    this.checklistId = const Value.absent(),
    this.title = const Value.absent(),
    this.done = const Value.absent(),
    this.sortOrder = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  TaskChecklistItemsCompanion.insert({
    required String id,
    required String checklistId,
    required String title,
    this.done = const Value.absent(),
    this.sortOrder = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       checklistId = Value(checklistId),
       title = Value(title);
  static Insertable<TaskChecklistItemRow> custom({
    Expression<String>? id,
    Expression<String>? checklistId,
    Expression<String>? title,
    Expression<bool>? done,
    Expression<int>? sortOrder,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (checklistId != null) 'checklist_id': checklistId,
      if (title != null) 'title': title,
      if (done != null) 'done': done,
      if (sortOrder != null) 'sort_order': sortOrder,
      if (rowid != null) 'rowid': rowid,
    });
  }

  TaskChecklistItemsCompanion copyWith({
    Value<String>? id,
    Value<String>? checklistId,
    Value<String>? title,
    Value<bool>? done,
    Value<int>? sortOrder,
    Value<int>? rowid,
  }) {
    return TaskChecklistItemsCompanion(
      id: id ?? this.id,
      checklistId: checklistId ?? this.checklistId,
      title: title ?? this.title,
      done: done ?? this.done,
      sortOrder: sortOrder ?? this.sortOrder,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (checklistId.present) {
      map['checklist_id'] = Variable<String>(checklistId.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (done.present) {
      map['done'] = Variable<bool>(done.value);
    }
    if (sortOrder.present) {
      map['sort_order'] = Variable<int>(sortOrder.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TaskChecklistItemsCompanion(')
          ..write('id: $id, ')
          ..write('checklistId: $checklistId, ')
          ..write('title: $title, ')
          ..write('done: $done, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $TaskCommentsTable extends TaskComments
    with TableInfo<$TaskCommentsTable, TaskCommentRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TaskCommentsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _taskIdMeta = const VerificationMeta('taskId');
  @override
  late final GeneratedColumn<String> taskId = GeneratedColumn<String>(
    'task_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES tasks (id)',
    ),
  );
  static const VerificationMeta _bodyMeta = const VerificationMeta('body');
  @override
  late final GeneratedColumn<String> body = GeneratedColumn<String>(
    'body',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [id, taskId, body, createdAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'task_comments';
  @override
  VerificationContext validateIntegrity(
    Insertable<TaskCommentRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('task_id')) {
      context.handle(
        _taskIdMeta,
        taskId.isAcceptableOrUnknown(data['task_id']!, _taskIdMeta),
      );
    } else if (isInserting) {
      context.missing(_taskIdMeta);
    }
    if (data.containsKey('body')) {
      context.handle(
        _bodyMeta,
        body.isAcceptableOrUnknown(data['body']!, _bodyMeta),
      );
    } else if (isInserting) {
      context.missing(_bodyMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  TaskCommentRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TaskCommentRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      taskId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}task_id'],
      )!,
      body: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}body'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $TaskCommentsTable createAlias(String alias) {
    return $TaskCommentsTable(attachedDatabase, alias);
  }
}

class TaskCommentRow extends DataClass implements Insertable<TaskCommentRow> {
  final String id;
  final String taskId;
  final String body;
  final DateTime createdAt;
  const TaskCommentRow({
    required this.id,
    required this.taskId,
    required this.body,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['task_id'] = Variable<String>(taskId);
    map['body'] = Variable<String>(body);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  TaskCommentsCompanion toCompanion(bool nullToAbsent) {
    return TaskCommentsCompanion(
      id: Value(id),
      taskId: Value(taskId),
      body: Value(body),
      createdAt: Value(createdAt),
    );
  }

  factory TaskCommentRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TaskCommentRow(
      id: serializer.fromJson<String>(json['id']),
      taskId: serializer.fromJson<String>(json['taskId']),
      body: serializer.fromJson<String>(json['body']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'taskId': serializer.toJson<String>(taskId),
      'body': serializer.toJson<String>(body),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  TaskCommentRow copyWith({
    String? id,
    String? taskId,
    String? body,
    DateTime? createdAt,
  }) => TaskCommentRow(
    id: id ?? this.id,
    taskId: taskId ?? this.taskId,
    body: body ?? this.body,
    createdAt: createdAt ?? this.createdAt,
  );
  TaskCommentRow copyWithCompanion(TaskCommentsCompanion data) {
    return TaskCommentRow(
      id: data.id.present ? data.id.value : this.id,
      taskId: data.taskId.present ? data.taskId.value : this.taskId,
      body: data.body.present ? data.body.value : this.body,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('TaskCommentRow(')
          ..write('id: $id, ')
          ..write('taskId: $taskId, ')
          ..write('body: $body, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, taskId, body, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TaskCommentRow &&
          other.id == this.id &&
          other.taskId == this.taskId &&
          other.body == this.body &&
          other.createdAt == this.createdAt);
}

class TaskCommentsCompanion extends UpdateCompanion<TaskCommentRow> {
  final Value<String> id;
  final Value<String> taskId;
  final Value<String> body;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const TaskCommentsCompanion({
    this.id = const Value.absent(),
    this.taskId = const Value.absent(),
    this.body = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  TaskCommentsCompanion.insert({
    required String id,
    required String taskId,
    required String body,
    required DateTime createdAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       taskId = Value(taskId),
       body = Value(body),
       createdAt = Value(createdAt);
  static Insertable<TaskCommentRow> custom({
    Expression<String>? id,
    Expression<String>? taskId,
    Expression<String>? body,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (taskId != null) 'task_id': taskId,
      if (body != null) 'body': body,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  TaskCommentsCompanion copyWith({
    Value<String>? id,
    Value<String>? taskId,
    Value<String>? body,
    Value<DateTime>? createdAt,
    Value<int>? rowid,
  }) {
    return TaskCommentsCompanion(
      id: id ?? this.id,
      taskId: taskId ?? this.taskId,
      body: body ?? this.body,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (taskId.present) {
      map['task_id'] = Variable<String>(taskId.value);
    }
    if (body.present) {
      map['body'] = Variable<String>(body.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TaskCommentsCompanion(')
          ..write('id: $id, ')
          ..write('taskId: $taskId, ')
          ..write('body: $body, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $TaskAttachmentsTable extends TaskAttachments
    with TableInfo<$TaskAttachmentsTable, TaskAttachmentRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TaskAttachmentsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _taskIdMeta = const VerificationMeta('taskId');
  @override
  late final GeneratedColumn<String> taskId = GeneratedColumn<String>(
    'task_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES tasks (id)',
    ),
  );
  static const VerificationMeta _fileNameMeta = const VerificationMeta(
    'fileName',
  );
  @override
  late final GeneratedColumn<String> fileName = GeneratedColumn<String>(
    'file_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _filePathMeta = const VerificationMeta(
    'filePath',
  );
  @override
  late final GeneratedColumn<String> filePath = GeneratedColumn<String>(
    'file_path',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _mimeTypeMeta = const VerificationMeta(
    'mimeType',
  );
  @override
  late final GeneratedColumn<String> mimeType = GeneratedColumn<String>(
    'mime_type',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _byteSizeMeta = const VerificationMeta(
    'byteSize',
  );
  @override
  late final GeneratedColumn<int> byteSize = GeneratedColumn<int>(
    'byte_size',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    taskId,
    fileName,
    filePath,
    mimeType,
    byteSize,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'task_attachments';
  @override
  VerificationContext validateIntegrity(
    Insertable<TaskAttachmentRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('task_id')) {
      context.handle(
        _taskIdMeta,
        taskId.isAcceptableOrUnknown(data['task_id']!, _taskIdMeta),
      );
    } else if (isInserting) {
      context.missing(_taskIdMeta);
    }
    if (data.containsKey('file_name')) {
      context.handle(
        _fileNameMeta,
        fileName.isAcceptableOrUnknown(data['file_name']!, _fileNameMeta),
      );
    } else if (isInserting) {
      context.missing(_fileNameMeta);
    }
    if (data.containsKey('file_path')) {
      context.handle(
        _filePathMeta,
        filePath.isAcceptableOrUnknown(data['file_path']!, _filePathMeta),
      );
    } else if (isInserting) {
      context.missing(_filePathMeta);
    }
    if (data.containsKey('mime_type')) {
      context.handle(
        _mimeTypeMeta,
        mimeType.isAcceptableOrUnknown(data['mime_type']!, _mimeTypeMeta),
      );
    }
    if (data.containsKey('byte_size')) {
      context.handle(
        _byteSizeMeta,
        byteSize.isAcceptableOrUnknown(data['byte_size']!, _byteSizeMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  TaskAttachmentRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TaskAttachmentRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      taskId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}task_id'],
      )!,
      fileName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}file_name'],
      )!,
      filePath: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}file_path'],
      )!,
      mimeType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}mime_type'],
      ),
      byteSize: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}byte_size'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $TaskAttachmentsTable createAlias(String alias) {
    return $TaskAttachmentsTable(attachedDatabase, alias);
  }
}

class TaskAttachmentRow extends DataClass
    implements Insertable<TaskAttachmentRow> {
  final String id;
  final String taskId;
  final String fileName;
  final String filePath;
  final String? mimeType;
  final int byteSize;
  final DateTime createdAt;
  const TaskAttachmentRow({
    required this.id,
    required this.taskId,
    required this.fileName,
    required this.filePath,
    this.mimeType,
    required this.byteSize,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['task_id'] = Variable<String>(taskId);
    map['file_name'] = Variable<String>(fileName);
    map['file_path'] = Variable<String>(filePath);
    if (!nullToAbsent || mimeType != null) {
      map['mime_type'] = Variable<String>(mimeType);
    }
    map['byte_size'] = Variable<int>(byteSize);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  TaskAttachmentsCompanion toCompanion(bool nullToAbsent) {
    return TaskAttachmentsCompanion(
      id: Value(id),
      taskId: Value(taskId),
      fileName: Value(fileName),
      filePath: Value(filePath),
      mimeType: mimeType == null && nullToAbsent
          ? const Value.absent()
          : Value(mimeType),
      byteSize: Value(byteSize),
      createdAt: Value(createdAt),
    );
  }

  factory TaskAttachmentRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TaskAttachmentRow(
      id: serializer.fromJson<String>(json['id']),
      taskId: serializer.fromJson<String>(json['taskId']),
      fileName: serializer.fromJson<String>(json['fileName']),
      filePath: serializer.fromJson<String>(json['filePath']),
      mimeType: serializer.fromJson<String?>(json['mimeType']),
      byteSize: serializer.fromJson<int>(json['byteSize']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'taskId': serializer.toJson<String>(taskId),
      'fileName': serializer.toJson<String>(fileName),
      'filePath': serializer.toJson<String>(filePath),
      'mimeType': serializer.toJson<String?>(mimeType),
      'byteSize': serializer.toJson<int>(byteSize),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  TaskAttachmentRow copyWith({
    String? id,
    String? taskId,
    String? fileName,
    String? filePath,
    Value<String?> mimeType = const Value.absent(),
    int? byteSize,
    DateTime? createdAt,
  }) => TaskAttachmentRow(
    id: id ?? this.id,
    taskId: taskId ?? this.taskId,
    fileName: fileName ?? this.fileName,
    filePath: filePath ?? this.filePath,
    mimeType: mimeType.present ? mimeType.value : this.mimeType,
    byteSize: byteSize ?? this.byteSize,
    createdAt: createdAt ?? this.createdAt,
  );
  TaskAttachmentRow copyWithCompanion(TaskAttachmentsCompanion data) {
    return TaskAttachmentRow(
      id: data.id.present ? data.id.value : this.id,
      taskId: data.taskId.present ? data.taskId.value : this.taskId,
      fileName: data.fileName.present ? data.fileName.value : this.fileName,
      filePath: data.filePath.present ? data.filePath.value : this.filePath,
      mimeType: data.mimeType.present ? data.mimeType.value : this.mimeType,
      byteSize: data.byteSize.present ? data.byteSize.value : this.byteSize,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('TaskAttachmentRow(')
          ..write('id: $id, ')
          ..write('taskId: $taskId, ')
          ..write('fileName: $fileName, ')
          ..write('filePath: $filePath, ')
          ..write('mimeType: $mimeType, ')
          ..write('byteSize: $byteSize, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    taskId,
    fileName,
    filePath,
    mimeType,
    byteSize,
    createdAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TaskAttachmentRow &&
          other.id == this.id &&
          other.taskId == this.taskId &&
          other.fileName == this.fileName &&
          other.filePath == this.filePath &&
          other.mimeType == this.mimeType &&
          other.byteSize == this.byteSize &&
          other.createdAt == this.createdAt);
}

class TaskAttachmentsCompanion extends UpdateCompanion<TaskAttachmentRow> {
  final Value<String> id;
  final Value<String> taskId;
  final Value<String> fileName;
  final Value<String> filePath;
  final Value<String?> mimeType;
  final Value<int> byteSize;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const TaskAttachmentsCompanion({
    this.id = const Value.absent(),
    this.taskId = const Value.absent(),
    this.fileName = const Value.absent(),
    this.filePath = const Value.absent(),
    this.mimeType = const Value.absent(),
    this.byteSize = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  TaskAttachmentsCompanion.insert({
    required String id,
    required String taskId,
    required String fileName,
    required String filePath,
    this.mimeType = const Value.absent(),
    this.byteSize = const Value.absent(),
    required DateTime createdAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       taskId = Value(taskId),
       fileName = Value(fileName),
       filePath = Value(filePath),
       createdAt = Value(createdAt);
  static Insertable<TaskAttachmentRow> custom({
    Expression<String>? id,
    Expression<String>? taskId,
    Expression<String>? fileName,
    Expression<String>? filePath,
    Expression<String>? mimeType,
    Expression<int>? byteSize,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (taskId != null) 'task_id': taskId,
      if (fileName != null) 'file_name': fileName,
      if (filePath != null) 'file_path': filePath,
      if (mimeType != null) 'mime_type': mimeType,
      if (byteSize != null) 'byte_size': byteSize,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  TaskAttachmentsCompanion copyWith({
    Value<String>? id,
    Value<String>? taskId,
    Value<String>? fileName,
    Value<String>? filePath,
    Value<String?>? mimeType,
    Value<int>? byteSize,
    Value<DateTime>? createdAt,
    Value<int>? rowid,
  }) {
    return TaskAttachmentsCompanion(
      id: id ?? this.id,
      taskId: taskId ?? this.taskId,
      fileName: fileName ?? this.fileName,
      filePath: filePath ?? this.filePath,
      mimeType: mimeType ?? this.mimeType,
      byteSize: byteSize ?? this.byteSize,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (taskId.present) {
      map['task_id'] = Variable<String>(taskId.value);
    }
    if (fileName.present) {
      map['file_name'] = Variable<String>(fileName.value);
    }
    if (filePath.present) {
      map['file_path'] = Variable<String>(filePath.value);
    }
    if (mimeType.present) {
      map['mime_type'] = Variable<String>(mimeType.value);
    }
    if (byteSize.present) {
      map['byte_size'] = Variable<int>(byteSize.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TaskAttachmentsCompanion(')
          ..write('id: $id, ')
          ..write('taskId: $taskId, ')
          ..write('fileName: $fileName, ')
          ..write('filePath: $filePath, ')
          ..write('mimeType: $mimeType, ')
          ..write('byteSize: $byteSize, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $TaskActivityTable extends TaskActivity
    with TableInfo<$TaskActivityTable, TaskActivityRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TaskActivityTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _taskIdMeta = const VerificationMeta('taskId');
  @override
  late final GeneratedColumn<String> taskId = GeneratedColumn<String>(
    'task_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES tasks (id)',
    ),
  );
  static const VerificationMeta _typeMeta = const VerificationMeta('type');
  @override
  late final GeneratedColumn<String> type = GeneratedColumn<String>(
    'type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _payloadMeta = const VerificationMeta(
    'payload',
  );
  @override
  late final GeneratedColumn<String> payload = GeneratedColumn<String>(
    'payload',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [id, taskId, type, payload, createdAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'task_activity';
  @override
  VerificationContext validateIntegrity(
    Insertable<TaskActivityRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('task_id')) {
      context.handle(
        _taskIdMeta,
        taskId.isAcceptableOrUnknown(data['task_id']!, _taskIdMeta),
      );
    } else if (isInserting) {
      context.missing(_taskIdMeta);
    }
    if (data.containsKey('type')) {
      context.handle(
        _typeMeta,
        type.isAcceptableOrUnknown(data['type']!, _typeMeta),
      );
    } else if (isInserting) {
      context.missing(_typeMeta);
    }
    if (data.containsKey('payload')) {
      context.handle(
        _payloadMeta,
        payload.isAcceptableOrUnknown(data['payload']!, _payloadMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  TaskActivityRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TaskActivityRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      taskId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}task_id'],
      )!,
      type: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}type'],
      )!,
      payload: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}payload'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $TaskActivityTable createAlias(String alias) {
    return $TaskActivityTable(attachedDatabase, alias);
  }
}

class TaskActivityRow extends DataClass implements Insertable<TaskActivityRow> {
  final String id;
  final String taskId;
  final String type;
  final String? payload;
  final DateTime createdAt;
  const TaskActivityRow({
    required this.id,
    required this.taskId,
    required this.type,
    this.payload,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['task_id'] = Variable<String>(taskId);
    map['type'] = Variable<String>(type);
    if (!nullToAbsent || payload != null) {
      map['payload'] = Variable<String>(payload);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  TaskActivityCompanion toCompanion(bool nullToAbsent) {
    return TaskActivityCompanion(
      id: Value(id),
      taskId: Value(taskId),
      type: Value(type),
      payload: payload == null && nullToAbsent
          ? const Value.absent()
          : Value(payload),
      createdAt: Value(createdAt),
    );
  }

  factory TaskActivityRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TaskActivityRow(
      id: serializer.fromJson<String>(json['id']),
      taskId: serializer.fromJson<String>(json['taskId']),
      type: serializer.fromJson<String>(json['type']),
      payload: serializer.fromJson<String?>(json['payload']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'taskId': serializer.toJson<String>(taskId),
      'type': serializer.toJson<String>(type),
      'payload': serializer.toJson<String?>(payload),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  TaskActivityRow copyWith({
    String? id,
    String? taskId,
    String? type,
    Value<String?> payload = const Value.absent(),
    DateTime? createdAt,
  }) => TaskActivityRow(
    id: id ?? this.id,
    taskId: taskId ?? this.taskId,
    type: type ?? this.type,
    payload: payload.present ? payload.value : this.payload,
    createdAt: createdAt ?? this.createdAt,
  );
  TaskActivityRow copyWithCompanion(TaskActivityCompanion data) {
    return TaskActivityRow(
      id: data.id.present ? data.id.value : this.id,
      taskId: data.taskId.present ? data.taskId.value : this.taskId,
      type: data.type.present ? data.type.value : this.type,
      payload: data.payload.present ? data.payload.value : this.payload,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('TaskActivityRow(')
          ..write('id: $id, ')
          ..write('taskId: $taskId, ')
          ..write('type: $type, ')
          ..write('payload: $payload, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, taskId, type, payload, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TaskActivityRow &&
          other.id == this.id &&
          other.taskId == this.taskId &&
          other.type == this.type &&
          other.payload == this.payload &&
          other.createdAt == this.createdAt);
}

class TaskActivityCompanion extends UpdateCompanion<TaskActivityRow> {
  final Value<String> id;
  final Value<String> taskId;
  final Value<String> type;
  final Value<String?> payload;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const TaskActivityCompanion({
    this.id = const Value.absent(),
    this.taskId = const Value.absent(),
    this.type = const Value.absent(),
    this.payload = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  TaskActivityCompanion.insert({
    required String id,
    required String taskId,
    required String type,
    this.payload = const Value.absent(),
    required DateTime createdAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       taskId = Value(taskId),
       type = Value(type),
       createdAt = Value(createdAt);
  static Insertable<TaskActivityRow> custom({
    Expression<String>? id,
    Expression<String>? taskId,
    Expression<String>? type,
    Expression<String>? payload,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (taskId != null) 'task_id': taskId,
      if (type != null) 'type': type,
      if (payload != null) 'payload': payload,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  TaskActivityCompanion copyWith({
    Value<String>? id,
    Value<String>? taskId,
    Value<String>? type,
    Value<String?>? payload,
    Value<DateTime>? createdAt,
    Value<int>? rowid,
  }) {
    return TaskActivityCompanion(
      id: id ?? this.id,
      taskId: taskId ?? this.taskId,
      type: type ?? this.type,
      payload: payload ?? this.payload,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (taskId.present) {
      map['task_id'] = Variable<String>(taskId.value);
    }
    if (type.present) {
      map['type'] = Variable<String>(type.value);
    }
    if (payload.present) {
      map['payload'] = Variable<String>(payload.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TaskActivityCompanion(')
          ..write('id: $id, ')
          ..write('taskId: $taskId, ')
          ..write('type: $type, ')
          ..write('payload: $payload, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $TimeEntriesTable extends TimeEntries
    with TableInfo<$TimeEntriesTable, TimeEntryRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TimeEntriesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _projectIdMeta = const VerificationMeta(
    'projectId',
  );
  @override
  late final GeneratedColumn<String> projectId = GeneratedColumn<String>(
    'project_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES projects (id)',
    ),
  );
  static const VerificationMeta _taskIdMeta = const VerificationMeta('taskId');
  @override
  late final GeneratedColumn<String> taskId = GeneratedColumn<String>(
    'task_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES tasks (id)',
    ),
  );
  static const VerificationMeta _startTimeMeta = const VerificationMeta(
    'startTime',
  );
  @override
  late final GeneratedColumn<DateTime> startTime = GeneratedColumn<DateTime>(
    'start_time',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _endTimeMeta = const VerificationMeta(
    'endTime',
  );
  @override
  late final GeneratedColumn<DateTime> endTime = GeneratedColumn<DateTime>(
    'end_time',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _durationSecondsMeta = const VerificationMeta(
    'durationSeconds',
  );
  @override
  late final GeneratedColumn<int> durationSeconds = GeneratedColumn<int>(
    'duration_seconds',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _activityPercentageMeta =
      const VerificationMeta('activityPercentage');
  @override
  late final GeneratedColumn<int> activityPercentage = GeneratedColumn<int>(
    'activity_percentage',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _isManualMeta = const VerificationMeta(
    'isManual',
  );
  @override
  late final GeneratedColumn<bool> isManual = GeneratedColumn<bool>(
    'is_manual',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_manual" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _notesMeta = const VerificationMeta('notes');
  @override
  late final GeneratedColumn<String> notes = GeneratedColumn<String>(
    'notes',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    projectId,
    taskId,
    startTime,
    endTime,
    durationSeconds,
    activityPercentage,
    isManual,
    notes,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'time_entries';
  @override
  VerificationContext validateIntegrity(
    Insertable<TimeEntryRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('project_id')) {
      context.handle(
        _projectIdMeta,
        projectId.isAcceptableOrUnknown(data['project_id']!, _projectIdMeta),
      );
    } else if (isInserting) {
      context.missing(_projectIdMeta);
    }
    if (data.containsKey('task_id')) {
      context.handle(
        _taskIdMeta,
        taskId.isAcceptableOrUnknown(data['task_id']!, _taskIdMeta),
      );
    }
    if (data.containsKey('start_time')) {
      context.handle(
        _startTimeMeta,
        startTime.isAcceptableOrUnknown(data['start_time']!, _startTimeMeta),
      );
    } else if (isInserting) {
      context.missing(_startTimeMeta);
    }
    if (data.containsKey('end_time')) {
      context.handle(
        _endTimeMeta,
        endTime.isAcceptableOrUnknown(data['end_time']!, _endTimeMeta),
      );
    }
    if (data.containsKey('duration_seconds')) {
      context.handle(
        _durationSecondsMeta,
        durationSeconds.isAcceptableOrUnknown(
          data['duration_seconds']!,
          _durationSecondsMeta,
        ),
      );
    }
    if (data.containsKey('activity_percentage')) {
      context.handle(
        _activityPercentageMeta,
        activityPercentage.isAcceptableOrUnknown(
          data['activity_percentage']!,
          _activityPercentageMeta,
        ),
      );
    }
    if (data.containsKey('is_manual')) {
      context.handle(
        _isManualMeta,
        isManual.isAcceptableOrUnknown(data['is_manual']!, _isManualMeta),
      );
    }
    if (data.containsKey('notes')) {
      context.handle(
        _notesMeta,
        notes.isAcceptableOrUnknown(data['notes']!, _notesMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  TimeEntryRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TimeEntryRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      projectId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}project_id'],
      )!,
      taskId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}task_id'],
      ),
      startTime: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}start_time'],
      )!,
      endTime: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}end_time'],
      ),
      durationSeconds: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}duration_seconds'],
      )!,
      activityPercentage: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}activity_percentage'],
      ),
      isManual: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_manual'],
      )!,
      notes: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notes'],
      ),
    );
  }

  @override
  $TimeEntriesTable createAlias(String alias) {
    return $TimeEntriesTable(attachedDatabase, alias);
  }
}

class TimeEntryRow extends DataClass implements Insertable<TimeEntryRow> {
  final String id;
  final String projectId;
  final String? taskId;
  final DateTime startTime;
  final DateTime? endTime;
  final int durationSeconds;
  final int? activityPercentage;
  final bool isManual;
  final String? notes;
  const TimeEntryRow({
    required this.id,
    required this.projectId,
    this.taskId,
    required this.startTime,
    this.endTime,
    required this.durationSeconds,
    this.activityPercentage,
    required this.isManual,
    this.notes,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['project_id'] = Variable<String>(projectId);
    if (!nullToAbsent || taskId != null) {
      map['task_id'] = Variable<String>(taskId);
    }
    map['start_time'] = Variable<DateTime>(startTime);
    if (!nullToAbsent || endTime != null) {
      map['end_time'] = Variable<DateTime>(endTime);
    }
    map['duration_seconds'] = Variable<int>(durationSeconds);
    if (!nullToAbsent || activityPercentage != null) {
      map['activity_percentage'] = Variable<int>(activityPercentage);
    }
    map['is_manual'] = Variable<bool>(isManual);
    if (!nullToAbsent || notes != null) {
      map['notes'] = Variable<String>(notes);
    }
    return map;
  }

  TimeEntriesCompanion toCompanion(bool nullToAbsent) {
    return TimeEntriesCompanion(
      id: Value(id),
      projectId: Value(projectId),
      taskId: taskId == null && nullToAbsent
          ? const Value.absent()
          : Value(taskId),
      startTime: Value(startTime),
      endTime: endTime == null && nullToAbsent
          ? const Value.absent()
          : Value(endTime),
      durationSeconds: Value(durationSeconds),
      activityPercentage: activityPercentage == null && nullToAbsent
          ? const Value.absent()
          : Value(activityPercentage),
      isManual: Value(isManual),
      notes: notes == null && nullToAbsent
          ? const Value.absent()
          : Value(notes),
    );
  }

  factory TimeEntryRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TimeEntryRow(
      id: serializer.fromJson<String>(json['id']),
      projectId: serializer.fromJson<String>(json['projectId']),
      taskId: serializer.fromJson<String?>(json['taskId']),
      startTime: serializer.fromJson<DateTime>(json['startTime']),
      endTime: serializer.fromJson<DateTime?>(json['endTime']),
      durationSeconds: serializer.fromJson<int>(json['durationSeconds']),
      activityPercentage: serializer.fromJson<int?>(json['activityPercentage']),
      isManual: serializer.fromJson<bool>(json['isManual']),
      notes: serializer.fromJson<String?>(json['notes']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'projectId': serializer.toJson<String>(projectId),
      'taskId': serializer.toJson<String?>(taskId),
      'startTime': serializer.toJson<DateTime>(startTime),
      'endTime': serializer.toJson<DateTime?>(endTime),
      'durationSeconds': serializer.toJson<int>(durationSeconds),
      'activityPercentage': serializer.toJson<int?>(activityPercentage),
      'isManual': serializer.toJson<bool>(isManual),
      'notes': serializer.toJson<String?>(notes),
    };
  }

  TimeEntryRow copyWith({
    String? id,
    String? projectId,
    Value<String?> taskId = const Value.absent(),
    DateTime? startTime,
    Value<DateTime?> endTime = const Value.absent(),
    int? durationSeconds,
    Value<int?> activityPercentage = const Value.absent(),
    bool? isManual,
    Value<String?> notes = const Value.absent(),
  }) => TimeEntryRow(
    id: id ?? this.id,
    projectId: projectId ?? this.projectId,
    taskId: taskId.present ? taskId.value : this.taskId,
    startTime: startTime ?? this.startTime,
    endTime: endTime.present ? endTime.value : this.endTime,
    durationSeconds: durationSeconds ?? this.durationSeconds,
    activityPercentage: activityPercentage.present
        ? activityPercentage.value
        : this.activityPercentage,
    isManual: isManual ?? this.isManual,
    notes: notes.present ? notes.value : this.notes,
  );
  TimeEntryRow copyWithCompanion(TimeEntriesCompanion data) {
    return TimeEntryRow(
      id: data.id.present ? data.id.value : this.id,
      projectId: data.projectId.present ? data.projectId.value : this.projectId,
      taskId: data.taskId.present ? data.taskId.value : this.taskId,
      startTime: data.startTime.present ? data.startTime.value : this.startTime,
      endTime: data.endTime.present ? data.endTime.value : this.endTime,
      durationSeconds: data.durationSeconds.present
          ? data.durationSeconds.value
          : this.durationSeconds,
      activityPercentage: data.activityPercentage.present
          ? data.activityPercentage.value
          : this.activityPercentage,
      isManual: data.isManual.present ? data.isManual.value : this.isManual,
      notes: data.notes.present ? data.notes.value : this.notes,
    );
  }

  @override
  String toString() {
    return (StringBuffer('TimeEntryRow(')
          ..write('id: $id, ')
          ..write('projectId: $projectId, ')
          ..write('taskId: $taskId, ')
          ..write('startTime: $startTime, ')
          ..write('endTime: $endTime, ')
          ..write('durationSeconds: $durationSeconds, ')
          ..write('activityPercentage: $activityPercentage, ')
          ..write('isManual: $isManual, ')
          ..write('notes: $notes')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    projectId,
    taskId,
    startTime,
    endTime,
    durationSeconds,
    activityPercentage,
    isManual,
    notes,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TimeEntryRow &&
          other.id == this.id &&
          other.projectId == this.projectId &&
          other.taskId == this.taskId &&
          other.startTime == this.startTime &&
          other.endTime == this.endTime &&
          other.durationSeconds == this.durationSeconds &&
          other.activityPercentage == this.activityPercentage &&
          other.isManual == this.isManual &&
          other.notes == this.notes);
}

class TimeEntriesCompanion extends UpdateCompanion<TimeEntryRow> {
  final Value<String> id;
  final Value<String> projectId;
  final Value<String?> taskId;
  final Value<DateTime> startTime;
  final Value<DateTime?> endTime;
  final Value<int> durationSeconds;
  final Value<int?> activityPercentage;
  final Value<bool> isManual;
  final Value<String?> notes;
  final Value<int> rowid;
  const TimeEntriesCompanion({
    this.id = const Value.absent(),
    this.projectId = const Value.absent(),
    this.taskId = const Value.absent(),
    this.startTime = const Value.absent(),
    this.endTime = const Value.absent(),
    this.durationSeconds = const Value.absent(),
    this.activityPercentage = const Value.absent(),
    this.isManual = const Value.absent(),
    this.notes = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  TimeEntriesCompanion.insert({
    required String id,
    required String projectId,
    this.taskId = const Value.absent(),
    required DateTime startTime,
    this.endTime = const Value.absent(),
    this.durationSeconds = const Value.absent(),
    this.activityPercentage = const Value.absent(),
    this.isManual = const Value.absent(),
    this.notes = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       projectId = Value(projectId),
       startTime = Value(startTime);
  static Insertable<TimeEntryRow> custom({
    Expression<String>? id,
    Expression<String>? projectId,
    Expression<String>? taskId,
    Expression<DateTime>? startTime,
    Expression<DateTime>? endTime,
    Expression<int>? durationSeconds,
    Expression<int>? activityPercentage,
    Expression<bool>? isManual,
    Expression<String>? notes,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (projectId != null) 'project_id': projectId,
      if (taskId != null) 'task_id': taskId,
      if (startTime != null) 'start_time': startTime,
      if (endTime != null) 'end_time': endTime,
      if (durationSeconds != null) 'duration_seconds': durationSeconds,
      if (activityPercentage != null) 'activity_percentage': activityPercentage,
      if (isManual != null) 'is_manual': isManual,
      if (notes != null) 'notes': notes,
      if (rowid != null) 'rowid': rowid,
    });
  }

  TimeEntriesCompanion copyWith({
    Value<String>? id,
    Value<String>? projectId,
    Value<String?>? taskId,
    Value<DateTime>? startTime,
    Value<DateTime?>? endTime,
    Value<int>? durationSeconds,
    Value<int?>? activityPercentage,
    Value<bool>? isManual,
    Value<String?>? notes,
    Value<int>? rowid,
  }) {
    return TimeEntriesCompanion(
      id: id ?? this.id,
      projectId: projectId ?? this.projectId,
      taskId: taskId ?? this.taskId,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      durationSeconds: durationSeconds ?? this.durationSeconds,
      activityPercentage: activityPercentage ?? this.activityPercentage,
      isManual: isManual ?? this.isManual,
      notes: notes ?? this.notes,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (projectId.present) {
      map['project_id'] = Variable<String>(projectId.value);
    }
    if (taskId.present) {
      map['task_id'] = Variable<String>(taskId.value);
    }
    if (startTime.present) {
      map['start_time'] = Variable<DateTime>(startTime.value);
    }
    if (endTime.present) {
      map['end_time'] = Variable<DateTime>(endTime.value);
    }
    if (durationSeconds.present) {
      map['duration_seconds'] = Variable<int>(durationSeconds.value);
    }
    if (activityPercentage.present) {
      map['activity_percentage'] = Variable<int>(activityPercentage.value);
    }
    if (isManual.present) {
      map['is_manual'] = Variable<bool>(isManual.value);
    }
    if (notes.present) {
      map['notes'] = Variable<String>(notes.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TimeEntriesCompanion(')
          ..write('id: $id, ')
          ..write('projectId: $projectId, ')
          ..write('taskId: $taskId, ')
          ..write('startTime: $startTime, ')
          ..write('endTime: $endTime, ')
          ..write('durationSeconds: $durationSeconds, ')
          ..write('activityPercentage: $activityPercentage, ')
          ..write('isManual: $isManual, ')
          ..write('notes: $notes, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ScreenshotsTable extends Screenshots
    with TableInfo<$ScreenshotsTable, ScreenshotRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ScreenshotsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _timeEntryIdMeta = const VerificationMeta(
    'timeEntryId',
  );
  @override
  late final GeneratedColumn<String> timeEntryId = GeneratedColumn<String>(
    'time_entry_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES time_entries (id)',
    ),
  );
  static const VerificationMeta _filePathMeta = const VerificationMeta(
    'filePath',
  );
  @override
  late final GeneratedColumn<String> filePath = GeneratedColumn<String>(
    'file_path',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _takenAtMeta = const VerificationMeta(
    'takenAt',
  );
  @override
  late final GeneratedColumn<DateTime> takenAt = GeneratedColumn<DateTime>(
    'taken_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [id, timeEntryId, filePath, takenAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'screenshots';
  @override
  VerificationContext validateIntegrity(
    Insertable<ScreenshotRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('time_entry_id')) {
      context.handle(
        _timeEntryIdMeta,
        timeEntryId.isAcceptableOrUnknown(
          data['time_entry_id']!,
          _timeEntryIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_timeEntryIdMeta);
    }
    if (data.containsKey('file_path')) {
      context.handle(
        _filePathMeta,
        filePath.isAcceptableOrUnknown(data['file_path']!, _filePathMeta),
      );
    } else if (isInserting) {
      context.missing(_filePathMeta);
    }
    if (data.containsKey('taken_at')) {
      context.handle(
        _takenAtMeta,
        takenAt.isAcceptableOrUnknown(data['taken_at']!, _takenAtMeta),
      );
    } else if (isInserting) {
      context.missing(_takenAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ScreenshotRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ScreenshotRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      timeEntryId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}time_entry_id'],
      )!,
      filePath: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}file_path'],
      )!,
      takenAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}taken_at'],
      )!,
    );
  }

  @override
  $ScreenshotsTable createAlias(String alias) {
    return $ScreenshotsTable(attachedDatabase, alias);
  }
}

class ScreenshotRow extends DataClass implements Insertable<ScreenshotRow> {
  final String id;
  final String timeEntryId;
  final String filePath;
  final DateTime takenAt;
  const ScreenshotRow({
    required this.id,
    required this.timeEntryId,
    required this.filePath,
    required this.takenAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['time_entry_id'] = Variable<String>(timeEntryId);
    map['file_path'] = Variable<String>(filePath);
    map['taken_at'] = Variable<DateTime>(takenAt);
    return map;
  }

  ScreenshotsCompanion toCompanion(bool nullToAbsent) {
    return ScreenshotsCompanion(
      id: Value(id),
      timeEntryId: Value(timeEntryId),
      filePath: Value(filePath),
      takenAt: Value(takenAt),
    );
  }

  factory ScreenshotRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ScreenshotRow(
      id: serializer.fromJson<String>(json['id']),
      timeEntryId: serializer.fromJson<String>(json['timeEntryId']),
      filePath: serializer.fromJson<String>(json['filePath']),
      takenAt: serializer.fromJson<DateTime>(json['takenAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'timeEntryId': serializer.toJson<String>(timeEntryId),
      'filePath': serializer.toJson<String>(filePath),
      'takenAt': serializer.toJson<DateTime>(takenAt),
    };
  }

  ScreenshotRow copyWith({
    String? id,
    String? timeEntryId,
    String? filePath,
    DateTime? takenAt,
  }) => ScreenshotRow(
    id: id ?? this.id,
    timeEntryId: timeEntryId ?? this.timeEntryId,
    filePath: filePath ?? this.filePath,
    takenAt: takenAt ?? this.takenAt,
  );
  ScreenshotRow copyWithCompanion(ScreenshotsCompanion data) {
    return ScreenshotRow(
      id: data.id.present ? data.id.value : this.id,
      timeEntryId: data.timeEntryId.present
          ? data.timeEntryId.value
          : this.timeEntryId,
      filePath: data.filePath.present ? data.filePath.value : this.filePath,
      takenAt: data.takenAt.present ? data.takenAt.value : this.takenAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ScreenshotRow(')
          ..write('id: $id, ')
          ..write('timeEntryId: $timeEntryId, ')
          ..write('filePath: $filePath, ')
          ..write('takenAt: $takenAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, timeEntryId, filePath, takenAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ScreenshotRow &&
          other.id == this.id &&
          other.timeEntryId == this.timeEntryId &&
          other.filePath == this.filePath &&
          other.takenAt == this.takenAt);
}

class ScreenshotsCompanion extends UpdateCompanion<ScreenshotRow> {
  final Value<String> id;
  final Value<String> timeEntryId;
  final Value<String> filePath;
  final Value<DateTime> takenAt;
  final Value<int> rowid;
  const ScreenshotsCompanion({
    this.id = const Value.absent(),
    this.timeEntryId = const Value.absent(),
    this.filePath = const Value.absent(),
    this.takenAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ScreenshotsCompanion.insert({
    required String id,
    required String timeEntryId,
    required String filePath,
    required DateTime takenAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       timeEntryId = Value(timeEntryId),
       filePath = Value(filePath),
       takenAt = Value(takenAt);
  static Insertable<ScreenshotRow> custom({
    Expression<String>? id,
    Expression<String>? timeEntryId,
    Expression<String>? filePath,
    Expression<DateTime>? takenAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (timeEntryId != null) 'time_entry_id': timeEntryId,
      if (filePath != null) 'file_path': filePath,
      if (takenAt != null) 'taken_at': takenAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ScreenshotsCompanion copyWith({
    Value<String>? id,
    Value<String>? timeEntryId,
    Value<String>? filePath,
    Value<DateTime>? takenAt,
    Value<int>? rowid,
  }) {
    return ScreenshotsCompanion(
      id: id ?? this.id,
      timeEntryId: timeEntryId ?? this.timeEntryId,
      filePath: filePath ?? this.filePath,
      takenAt: takenAt ?? this.takenAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (timeEntryId.present) {
      map['time_entry_id'] = Variable<String>(timeEntryId.value);
    }
    if (filePath.present) {
      map['file_path'] = Variable<String>(filePath.value);
    }
    if (takenAt.present) {
      map['taken_at'] = Variable<DateTime>(takenAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ScreenshotsCompanion(')
          ..write('id: $id, ')
          ..write('timeEntryId: $timeEntryId, ')
          ..write('filePath: $filePath, ')
          ..write('takenAt: $takenAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $AppSettingsTable extends AppSettings
    with TableInfo<$AppSettingsTable, SettingRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AppSettingsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _keyMeta = const VerificationMeta('key');
  @override
  late final GeneratedColumn<String> key = GeneratedColumn<String>(
    'key',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _valueMeta = const VerificationMeta('value');
  @override
  late final GeneratedColumn<String> value = GeneratedColumn<String>(
    'value',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [key, value];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'app_settings';
  @override
  VerificationContext validateIntegrity(
    Insertable<SettingRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('key')) {
      context.handle(
        _keyMeta,
        key.isAcceptableOrUnknown(data['key']!, _keyMeta),
      );
    } else if (isInserting) {
      context.missing(_keyMeta);
    }
    if (data.containsKey('value')) {
      context.handle(
        _valueMeta,
        value.isAcceptableOrUnknown(data['value']!, _valueMeta),
      );
    } else if (isInserting) {
      context.missing(_valueMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {key};
  @override
  SettingRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SettingRow(
      key: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}key'],
      )!,
      value: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}value'],
      )!,
    );
  }

  @override
  $AppSettingsTable createAlias(String alias) {
    return $AppSettingsTable(attachedDatabase, alias);
  }
}

class SettingRow extends DataClass implements Insertable<SettingRow> {
  final String key;
  final String value;
  const SettingRow({required this.key, required this.value});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['key'] = Variable<String>(key);
    map['value'] = Variable<String>(value);
    return map;
  }

  AppSettingsCompanion toCompanion(bool nullToAbsent) {
    return AppSettingsCompanion(key: Value(key), value: Value(value));
  }

  factory SettingRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SettingRow(
      key: serializer.fromJson<String>(json['key']),
      value: serializer.fromJson<String>(json['value']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'key': serializer.toJson<String>(key),
      'value': serializer.toJson<String>(value),
    };
  }

  SettingRow copyWith({String? key, String? value}) =>
      SettingRow(key: key ?? this.key, value: value ?? this.value);
  SettingRow copyWithCompanion(AppSettingsCompanion data) {
    return SettingRow(
      key: data.key.present ? data.key.value : this.key,
      value: data.value.present ? data.value.value : this.value,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SettingRow(')
          ..write('key: $key, ')
          ..write('value: $value')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(key, value);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SettingRow &&
          other.key == this.key &&
          other.value == this.value);
}

class AppSettingsCompanion extends UpdateCompanion<SettingRow> {
  final Value<String> key;
  final Value<String> value;
  final Value<int> rowid;
  const AppSettingsCompanion({
    this.key = const Value.absent(),
    this.value = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  AppSettingsCompanion.insert({
    required String key,
    required String value,
    this.rowid = const Value.absent(),
  }) : key = Value(key),
       value = Value(value);
  static Insertable<SettingRow> custom({
    Expression<String>? key,
    Expression<String>? value,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (key != null) 'key': key,
      if (value != null) 'value': value,
      if (rowid != null) 'rowid': rowid,
    });
  }

  AppSettingsCompanion copyWith({
    Value<String>? key,
    Value<String>? value,
    Value<int>? rowid,
  }) {
    return AppSettingsCompanion(
      key: key ?? this.key,
      value: value ?? this.value,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (key.present) {
      map['key'] = Variable<String>(key.value);
    }
    if (value.present) {
      map['value'] = Variable<String>(value.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AppSettingsCompanion(')
          ..write('key: $key, ')
          ..write('value: $value, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $AlarmsTable extends Alarms with TableInfo<$AlarmsTable, AlarmRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $AlarmsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _labelMeta = const VerificationMeta('label');
  @override
  late final GeneratedColumn<String> label = GeneratedColumn<String>(
    'label',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('Alarm'),
  );
  static const VerificationMeta _hourMeta = const VerificationMeta('hour');
  @override
  late final GeneratedColumn<int> hour = GeneratedColumn<int>(
    'hour',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _minuteMeta = const VerificationMeta('minute');
  @override
  late final GeneratedColumn<int> minute = GeneratedColumn<int>(
    'minute',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _enabledMeta = const VerificationMeta(
    'enabled',
  );
  @override
  late final GeneratedColumn<bool> enabled = GeneratedColumn<bool>(
    'enabled',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("enabled" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _repeatDaysMeta = const VerificationMeta(
    'repeatDays',
  );
  @override
  late final GeneratedColumn<int> repeatDays = GeneratedColumn<int>(
    'repeat_days',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    label,
    hour,
    minute,
    enabled,
    repeatDays,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'alarms';
  @override
  VerificationContext validateIntegrity(
    Insertable<AlarmRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('label')) {
      context.handle(
        _labelMeta,
        label.isAcceptableOrUnknown(data['label']!, _labelMeta),
      );
    }
    if (data.containsKey('hour')) {
      context.handle(
        _hourMeta,
        hour.isAcceptableOrUnknown(data['hour']!, _hourMeta),
      );
    } else if (isInserting) {
      context.missing(_hourMeta);
    }
    if (data.containsKey('minute')) {
      context.handle(
        _minuteMeta,
        minute.isAcceptableOrUnknown(data['minute']!, _minuteMeta),
      );
    } else if (isInserting) {
      context.missing(_minuteMeta);
    }
    if (data.containsKey('enabled')) {
      context.handle(
        _enabledMeta,
        enabled.isAcceptableOrUnknown(data['enabled']!, _enabledMeta),
      );
    }
    if (data.containsKey('repeat_days')) {
      context.handle(
        _repeatDaysMeta,
        repeatDays.isAcceptableOrUnknown(data['repeat_days']!, _repeatDaysMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  AlarmRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return AlarmRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      label: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}label'],
      )!,
      hour: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}hour'],
      )!,
      minute: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}minute'],
      )!,
      enabled: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}enabled'],
      )!,
      repeatDays: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}repeat_days'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $AlarmsTable createAlias(String alias) {
    return $AlarmsTable(attachedDatabase, alias);
  }
}

class AlarmRow extends DataClass implements Insertable<AlarmRow> {
  final String id;
  final String label;
  final int hour;
  final int minute;
  final bool enabled;

  /// Bitmask: bit0=Mon … bit6=Sun. 0 = one-shot (next matching time).
  final int repeatDays;
  final DateTime createdAt;
  final DateTime updatedAt;
  const AlarmRow({
    required this.id,
    required this.label,
    required this.hour,
    required this.minute,
    required this.enabled,
    required this.repeatDays,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['label'] = Variable<String>(label);
    map['hour'] = Variable<int>(hour);
    map['minute'] = Variable<int>(minute);
    map['enabled'] = Variable<bool>(enabled);
    map['repeat_days'] = Variable<int>(repeatDays);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  AlarmsCompanion toCompanion(bool nullToAbsent) {
    return AlarmsCompanion(
      id: Value(id),
      label: Value(label),
      hour: Value(hour),
      minute: Value(minute),
      enabled: Value(enabled),
      repeatDays: Value(repeatDays),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory AlarmRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return AlarmRow(
      id: serializer.fromJson<String>(json['id']),
      label: serializer.fromJson<String>(json['label']),
      hour: serializer.fromJson<int>(json['hour']),
      minute: serializer.fromJson<int>(json['minute']),
      enabled: serializer.fromJson<bool>(json['enabled']),
      repeatDays: serializer.fromJson<int>(json['repeatDays']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'label': serializer.toJson<String>(label),
      'hour': serializer.toJson<int>(hour),
      'minute': serializer.toJson<int>(minute),
      'enabled': serializer.toJson<bool>(enabled),
      'repeatDays': serializer.toJson<int>(repeatDays),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  AlarmRow copyWith({
    String? id,
    String? label,
    int? hour,
    int? minute,
    bool? enabled,
    int? repeatDays,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => AlarmRow(
    id: id ?? this.id,
    label: label ?? this.label,
    hour: hour ?? this.hour,
    minute: minute ?? this.minute,
    enabled: enabled ?? this.enabled,
    repeatDays: repeatDays ?? this.repeatDays,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  AlarmRow copyWithCompanion(AlarmsCompanion data) {
    return AlarmRow(
      id: data.id.present ? data.id.value : this.id,
      label: data.label.present ? data.label.value : this.label,
      hour: data.hour.present ? data.hour.value : this.hour,
      minute: data.minute.present ? data.minute.value : this.minute,
      enabled: data.enabled.present ? data.enabled.value : this.enabled,
      repeatDays: data.repeatDays.present
          ? data.repeatDays.value
          : this.repeatDays,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('AlarmRow(')
          ..write('id: $id, ')
          ..write('label: $label, ')
          ..write('hour: $hour, ')
          ..write('minute: $minute, ')
          ..write('enabled: $enabled, ')
          ..write('repeatDays: $repeatDays, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    label,
    hour,
    minute,
    enabled,
    repeatDays,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AlarmRow &&
          other.id == this.id &&
          other.label == this.label &&
          other.hour == this.hour &&
          other.minute == this.minute &&
          other.enabled == this.enabled &&
          other.repeatDays == this.repeatDays &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class AlarmsCompanion extends UpdateCompanion<AlarmRow> {
  final Value<String> id;
  final Value<String> label;
  final Value<int> hour;
  final Value<int> minute;
  final Value<bool> enabled;
  final Value<int> repeatDays;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const AlarmsCompanion({
    this.id = const Value.absent(),
    this.label = const Value.absent(),
    this.hour = const Value.absent(),
    this.minute = const Value.absent(),
    this.enabled = const Value.absent(),
    this.repeatDays = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  AlarmsCompanion.insert({
    required String id,
    this.label = const Value.absent(),
    required int hour,
    required int minute,
    this.enabled = const Value.absent(),
    this.repeatDays = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       hour = Value(hour),
       minute = Value(minute),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<AlarmRow> custom({
    Expression<String>? id,
    Expression<String>? label,
    Expression<int>? hour,
    Expression<int>? minute,
    Expression<bool>? enabled,
    Expression<int>? repeatDays,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (label != null) 'label': label,
      if (hour != null) 'hour': hour,
      if (minute != null) 'minute': minute,
      if (enabled != null) 'enabled': enabled,
      if (repeatDays != null) 'repeat_days': repeatDays,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  AlarmsCompanion copyWith({
    Value<String>? id,
    Value<String>? label,
    Value<int>? hour,
    Value<int>? minute,
    Value<bool>? enabled,
    Value<int>? repeatDays,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return AlarmsCompanion(
      id: id ?? this.id,
      label: label ?? this.label,
      hour: hour ?? this.hour,
      minute: minute ?? this.minute,
      enabled: enabled ?? this.enabled,
      repeatDays: repeatDays ?? this.repeatDays,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (label.present) {
      map['label'] = Variable<String>(label.value);
    }
    if (hour.present) {
      map['hour'] = Variable<int>(hour.value);
    }
    if (minute.present) {
      map['minute'] = Variable<int>(minute.value);
    }
    if (enabled.present) {
      map['enabled'] = Variable<bool>(enabled.value);
    }
    if (repeatDays.present) {
      map['repeat_days'] = Variable<int>(repeatDays.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('AlarmsCompanion(')
          ..write('id: $id, ')
          ..write('label: $label, ')
          ..write('hour: $hour, ')
          ..write('minute: $minute, ')
          ..write('enabled: $enabled, ')
          ..write('repeatDays: $repeatDays, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $StopwatchLapsTable extends StopwatchLaps
    with TableInfo<$StopwatchLapsTable, StopwatchLapRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $StopwatchLapsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _sessionIdMeta = const VerificationMeta(
    'sessionId',
  );
  @override
  late final GeneratedColumn<String> sessionId = GeneratedColumn<String>(
    'session_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _lapIndexMeta = const VerificationMeta(
    'lapIndex',
  );
  @override
  late final GeneratedColumn<int> lapIndex = GeneratedColumn<int>(
    'lap_index',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _lapMsMeta = const VerificationMeta('lapMs');
  @override
  late final GeneratedColumn<int> lapMs = GeneratedColumn<int>(
    'lap_ms',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _totalMsMeta = const VerificationMeta(
    'totalMs',
  );
  @override
  late final GeneratedColumn<int> totalMs = GeneratedColumn<int>(
    'total_ms',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    sessionId,
    lapIndex,
    lapMs,
    totalMs,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'stopwatch_laps';
  @override
  VerificationContext validateIntegrity(
    Insertable<StopwatchLapRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('session_id')) {
      context.handle(
        _sessionIdMeta,
        sessionId.isAcceptableOrUnknown(data['session_id']!, _sessionIdMeta),
      );
    } else if (isInserting) {
      context.missing(_sessionIdMeta);
    }
    if (data.containsKey('lap_index')) {
      context.handle(
        _lapIndexMeta,
        lapIndex.isAcceptableOrUnknown(data['lap_index']!, _lapIndexMeta),
      );
    } else if (isInserting) {
      context.missing(_lapIndexMeta);
    }
    if (data.containsKey('lap_ms')) {
      context.handle(
        _lapMsMeta,
        lapMs.isAcceptableOrUnknown(data['lap_ms']!, _lapMsMeta),
      );
    } else if (isInserting) {
      context.missing(_lapMsMeta);
    }
    if (data.containsKey('total_ms')) {
      context.handle(
        _totalMsMeta,
        totalMs.isAcceptableOrUnknown(data['total_ms']!, _totalMsMeta),
      );
    } else if (isInserting) {
      context.missing(_totalMsMeta);
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  StopwatchLapRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return StopwatchLapRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      sessionId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}session_id'],
      )!,
      lapIndex: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}lap_index'],
      )!,
      lapMs: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}lap_ms'],
      )!,
      totalMs: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}total_ms'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $StopwatchLapsTable createAlias(String alias) {
    return $StopwatchLapsTable(attachedDatabase, alias);
  }
}

class StopwatchLapRow extends DataClass implements Insertable<StopwatchLapRow> {
  final String id;
  final String sessionId;
  final int lapIndex;
  final int lapMs;
  final int totalMs;
  final DateTime createdAt;
  const StopwatchLapRow({
    required this.id,
    required this.sessionId,
    required this.lapIndex,
    required this.lapMs,
    required this.totalMs,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['session_id'] = Variable<String>(sessionId);
    map['lap_index'] = Variable<int>(lapIndex);
    map['lap_ms'] = Variable<int>(lapMs);
    map['total_ms'] = Variable<int>(totalMs);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  StopwatchLapsCompanion toCompanion(bool nullToAbsent) {
    return StopwatchLapsCompanion(
      id: Value(id),
      sessionId: Value(sessionId),
      lapIndex: Value(lapIndex),
      lapMs: Value(lapMs),
      totalMs: Value(totalMs),
      createdAt: Value(createdAt),
    );
  }

  factory StopwatchLapRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return StopwatchLapRow(
      id: serializer.fromJson<String>(json['id']),
      sessionId: serializer.fromJson<String>(json['sessionId']),
      lapIndex: serializer.fromJson<int>(json['lapIndex']),
      lapMs: serializer.fromJson<int>(json['lapMs']),
      totalMs: serializer.fromJson<int>(json['totalMs']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'sessionId': serializer.toJson<String>(sessionId),
      'lapIndex': serializer.toJson<int>(lapIndex),
      'lapMs': serializer.toJson<int>(lapMs),
      'totalMs': serializer.toJson<int>(totalMs),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  StopwatchLapRow copyWith({
    String? id,
    String? sessionId,
    int? lapIndex,
    int? lapMs,
    int? totalMs,
    DateTime? createdAt,
  }) => StopwatchLapRow(
    id: id ?? this.id,
    sessionId: sessionId ?? this.sessionId,
    lapIndex: lapIndex ?? this.lapIndex,
    lapMs: lapMs ?? this.lapMs,
    totalMs: totalMs ?? this.totalMs,
    createdAt: createdAt ?? this.createdAt,
  );
  StopwatchLapRow copyWithCompanion(StopwatchLapsCompanion data) {
    return StopwatchLapRow(
      id: data.id.present ? data.id.value : this.id,
      sessionId: data.sessionId.present ? data.sessionId.value : this.sessionId,
      lapIndex: data.lapIndex.present ? data.lapIndex.value : this.lapIndex,
      lapMs: data.lapMs.present ? data.lapMs.value : this.lapMs,
      totalMs: data.totalMs.present ? data.totalMs.value : this.totalMs,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('StopwatchLapRow(')
          ..write('id: $id, ')
          ..write('sessionId: $sessionId, ')
          ..write('lapIndex: $lapIndex, ')
          ..write('lapMs: $lapMs, ')
          ..write('totalMs: $totalMs, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, sessionId, lapIndex, lapMs, totalMs, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is StopwatchLapRow &&
          other.id == this.id &&
          other.sessionId == this.sessionId &&
          other.lapIndex == this.lapIndex &&
          other.lapMs == this.lapMs &&
          other.totalMs == this.totalMs &&
          other.createdAt == this.createdAt);
}

class StopwatchLapsCompanion extends UpdateCompanion<StopwatchLapRow> {
  final Value<String> id;
  final Value<String> sessionId;
  final Value<int> lapIndex;
  final Value<int> lapMs;
  final Value<int> totalMs;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const StopwatchLapsCompanion({
    this.id = const Value.absent(),
    this.sessionId = const Value.absent(),
    this.lapIndex = const Value.absent(),
    this.lapMs = const Value.absent(),
    this.totalMs = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  StopwatchLapsCompanion.insert({
    required String id,
    required String sessionId,
    required int lapIndex,
    required int lapMs,
    required int totalMs,
    required DateTime createdAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       sessionId = Value(sessionId),
       lapIndex = Value(lapIndex),
       lapMs = Value(lapMs),
       totalMs = Value(totalMs),
       createdAt = Value(createdAt);
  static Insertable<StopwatchLapRow> custom({
    Expression<String>? id,
    Expression<String>? sessionId,
    Expression<int>? lapIndex,
    Expression<int>? lapMs,
    Expression<int>? totalMs,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (sessionId != null) 'session_id': sessionId,
      if (lapIndex != null) 'lap_index': lapIndex,
      if (lapMs != null) 'lap_ms': lapMs,
      if (totalMs != null) 'total_ms': totalMs,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  StopwatchLapsCompanion copyWith({
    Value<String>? id,
    Value<String>? sessionId,
    Value<int>? lapIndex,
    Value<int>? lapMs,
    Value<int>? totalMs,
    Value<DateTime>? createdAt,
    Value<int>? rowid,
  }) {
    return StopwatchLapsCompanion(
      id: id ?? this.id,
      sessionId: sessionId ?? this.sessionId,
      lapIndex: lapIndex ?? this.lapIndex,
      lapMs: lapMs ?? this.lapMs,
      totalMs: totalMs ?? this.totalMs,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (sessionId.present) {
      map['session_id'] = Variable<String>(sessionId.value);
    }
    if (lapIndex.present) {
      map['lap_index'] = Variable<int>(lapIndex.value);
    }
    if (lapMs.present) {
      map['lap_ms'] = Variable<int>(lapMs.value);
    }
    if (totalMs.present) {
      map['total_ms'] = Variable<int>(totalMs.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('StopwatchLapsCompanion(')
          ..write('id: $id, ')
          ..write('sessionId: $sessionId, ')
          ..write('lapIndex: $lapIndex, ')
          ..write('lapMs: $lapMs, ')
          ..write('totalMs: $totalMs, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $KeystrokeCountsTable extends KeystrokeCounts
    with TableInfo<$KeystrokeCountsTable, KeystrokeCountRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $KeystrokeCountsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _timeEntryIdMeta = const VerificationMeta(
    'timeEntryId',
  );
  @override
  late final GeneratedColumn<String> timeEntryId = GeneratedColumn<String>(
    'time_entry_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES time_entries (id)',
    ),
  );
  static const VerificationMeta _keyLabelMeta = const VerificationMeta(
    'keyLabel',
  );
  @override
  late final GeneratedColumn<String> keyLabel = GeneratedColumn<String>(
    'key_label',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _countMeta = const VerificationMeta('count');
  @override
  late final GeneratedColumn<int> count = GeneratedColumn<int>(
    'count',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  @override
  List<GeneratedColumn> get $columns => [id, timeEntryId, keyLabel, count];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'keystroke_counts';
  @override
  VerificationContext validateIntegrity(
    Insertable<KeystrokeCountRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('time_entry_id')) {
      context.handle(
        _timeEntryIdMeta,
        timeEntryId.isAcceptableOrUnknown(
          data['time_entry_id']!,
          _timeEntryIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_timeEntryIdMeta);
    }
    if (data.containsKey('key_label')) {
      context.handle(
        _keyLabelMeta,
        keyLabel.isAcceptableOrUnknown(data['key_label']!, _keyLabelMeta),
      );
    } else if (isInserting) {
      context.missing(_keyLabelMeta);
    }
    if (data.containsKey('count')) {
      context.handle(
        _countMeta,
        count.isAcceptableOrUnknown(data['count']!, _countMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  KeystrokeCountRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return KeystrokeCountRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      timeEntryId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}time_entry_id'],
      )!,
      keyLabel: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}key_label'],
      )!,
      count: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}count'],
      )!,
    );
  }

  @override
  $KeystrokeCountsTable createAlias(String alias) {
    return $KeystrokeCountsTable(attachedDatabase, alias);
  }
}

class KeystrokeCountRow extends DataClass
    implements Insertable<KeystrokeCountRow> {
  final String id;
  final String timeEntryId;
  final String keyLabel;
  final int count;
  const KeystrokeCountRow({
    required this.id,
    required this.timeEntryId,
    required this.keyLabel,
    required this.count,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['time_entry_id'] = Variable<String>(timeEntryId);
    map['key_label'] = Variable<String>(keyLabel);
    map['count'] = Variable<int>(count);
    return map;
  }

  KeystrokeCountsCompanion toCompanion(bool nullToAbsent) {
    return KeystrokeCountsCompanion(
      id: Value(id),
      timeEntryId: Value(timeEntryId),
      keyLabel: Value(keyLabel),
      count: Value(count),
    );
  }

  factory KeystrokeCountRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return KeystrokeCountRow(
      id: serializer.fromJson<String>(json['id']),
      timeEntryId: serializer.fromJson<String>(json['timeEntryId']),
      keyLabel: serializer.fromJson<String>(json['keyLabel']),
      count: serializer.fromJson<int>(json['count']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'timeEntryId': serializer.toJson<String>(timeEntryId),
      'keyLabel': serializer.toJson<String>(keyLabel),
      'count': serializer.toJson<int>(count),
    };
  }

  KeystrokeCountRow copyWith({
    String? id,
    String? timeEntryId,
    String? keyLabel,
    int? count,
  }) => KeystrokeCountRow(
    id: id ?? this.id,
    timeEntryId: timeEntryId ?? this.timeEntryId,
    keyLabel: keyLabel ?? this.keyLabel,
    count: count ?? this.count,
  );
  KeystrokeCountRow copyWithCompanion(KeystrokeCountsCompanion data) {
    return KeystrokeCountRow(
      id: data.id.present ? data.id.value : this.id,
      timeEntryId: data.timeEntryId.present
          ? data.timeEntryId.value
          : this.timeEntryId,
      keyLabel: data.keyLabel.present ? data.keyLabel.value : this.keyLabel,
      count: data.count.present ? data.count.value : this.count,
    );
  }

  @override
  String toString() {
    return (StringBuffer('KeystrokeCountRow(')
          ..write('id: $id, ')
          ..write('timeEntryId: $timeEntryId, ')
          ..write('keyLabel: $keyLabel, ')
          ..write('count: $count')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, timeEntryId, keyLabel, count);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is KeystrokeCountRow &&
          other.id == this.id &&
          other.timeEntryId == this.timeEntryId &&
          other.keyLabel == this.keyLabel &&
          other.count == this.count);
}

class KeystrokeCountsCompanion extends UpdateCompanion<KeystrokeCountRow> {
  final Value<String> id;
  final Value<String> timeEntryId;
  final Value<String> keyLabel;
  final Value<int> count;
  final Value<int> rowid;
  const KeystrokeCountsCompanion({
    this.id = const Value.absent(),
    this.timeEntryId = const Value.absent(),
    this.keyLabel = const Value.absent(),
    this.count = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  KeystrokeCountsCompanion.insert({
    required String id,
    required String timeEntryId,
    required String keyLabel,
    this.count = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       timeEntryId = Value(timeEntryId),
       keyLabel = Value(keyLabel);
  static Insertable<KeystrokeCountRow> custom({
    Expression<String>? id,
    Expression<String>? timeEntryId,
    Expression<String>? keyLabel,
    Expression<int>? count,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (timeEntryId != null) 'time_entry_id': timeEntryId,
      if (keyLabel != null) 'key_label': keyLabel,
      if (count != null) 'count': count,
      if (rowid != null) 'rowid': rowid,
    });
  }

  KeystrokeCountsCompanion copyWith({
    Value<String>? id,
    Value<String>? timeEntryId,
    Value<String>? keyLabel,
    Value<int>? count,
    Value<int>? rowid,
  }) {
    return KeystrokeCountsCompanion(
      id: id ?? this.id,
      timeEntryId: timeEntryId ?? this.timeEntryId,
      keyLabel: keyLabel ?? this.keyLabel,
      count: count ?? this.count,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (timeEntryId.present) {
      map['time_entry_id'] = Variable<String>(timeEntryId.value);
    }
    if (keyLabel.present) {
      map['key_label'] = Variable<String>(keyLabel.value);
    }
    if (count.present) {
      map['count'] = Variable<int>(count.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('KeystrokeCountsCompanion(')
          ..write('id: $id, ')
          ..write('timeEntryId: $timeEntryId, ')
          ..write('keyLabel: $keyLabel, ')
          ..write('count: $count, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $NotebooksTable extends Notebooks
    with TableInfo<$NotebooksTable, NotebookRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $NotebooksTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 120,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _coverColorMeta = const VerificationMeta(
    'coverColor',
  );
  @override
  late final GeneratedColumn<int> coverColor = GeneratedColumn<int>(
    'cover_color',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _coverImagePathMeta = const VerificationMeta(
    'coverImagePath',
  );
  @override
  late final GeneratedColumn<String> coverImagePath = GeneratedColumn<String>(
    'cover_image_path',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _sortOrderMeta = const VerificationMeta(
    'sortOrder',
  );
  @override
  late final GeneratedColumn<int> sortOrder = GeneratedColumn<int>(
    'sort_order',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    coverColor,
    coverImagePath,
    sortOrder,
    createdAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'notebooks';
  @override
  VerificationContext validateIntegrity(
    Insertable<NotebookRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('cover_color')) {
      context.handle(
        _coverColorMeta,
        coverColor.isAcceptableOrUnknown(data['cover_color']!, _coverColorMeta),
      );
    } else if (isInserting) {
      context.missing(_coverColorMeta);
    }
    if (data.containsKey('cover_image_path')) {
      context.handle(
        _coverImagePathMeta,
        coverImagePath.isAcceptableOrUnknown(
          data['cover_image_path']!,
          _coverImagePathMeta,
        ),
      );
    }
    if (data.containsKey('sort_order')) {
      context.handle(
        _sortOrderMeta,
        sortOrder.isAcceptableOrUnknown(data['sort_order']!, _sortOrderMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  NotebookRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return NotebookRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      coverColor: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}cover_color'],
      )!,
      coverImagePath: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}cover_image_path'],
      ),
      sortOrder: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sort_order'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $NotebooksTable createAlias(String alias) {
    return $NotebooksTable(attachedDatabase, alias);
  }
}

class NotebookRow extends DataClass implements Insertable<NotebookRow> {
  final String id;
  final String name;
  final int coverColor;
  final String? coverImagePath;
  final int sortOrder;
  final DateTime createdAt;
  final DateTime updatedAt;
  const NotebookRow({
    required this.id,
    required this.name,
    required this.coverColor,
    this.coverImagePath,
    required this.sortOrder,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    map['cover_color'] = Variable<int>(coverColor);
    if (!nullToAbsent || coverImagePath != null) {
      map['cover_image_path'] = Variable<String>(coverImagePath);
    }
    map['sort_order'] = Variable<int>(sortOrder);
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  NotebooksCompanion toCompanion(bool nullToAbsent) {
    return NotebooksCompanion(
      id: Value(id),
      name: Value(name),
      coverColor: Value(coverColor),
      coverImagePath: coverImagePath == null && nullToAbsent
          ? const Value.absent()
          : Value(coverImagePath),
      sortOrder: Value(sortOrder),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory NotebookRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return NotebookRow(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      coverColor: serializer.fromJson<int>(json['coverColor']),
      coverImagePath: serializer.fromJson<String?>(json['coverImagePath']),
      sortOrder: serializer.fromJson<int>(json['sortOrder']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'coverColor': serializer.toJson<int>(coverColor),
      'coverImagePath': serializer.toJson<String?>(coverImagePath),
      'sortOrder': serializer.toJson<int>(sortOrder),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  NotebookRow copyWith({
    String? id,
    String? name,
    int? coverColor,
    Value<String?> coverImagePath = const Value.absent(),
    int? sortOrder,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => NotebookRow(
    id: id ?? this.id,
    name: name ?? this.name,
    coverColor: coverColor ?? this.coverColor,
    coverImagePath: coverImagePath.present
        ? coverImagePath.value
        : this.coverImagePath,
    sortOrder: sortOrder ?? this.sortOrder,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  NotebookRow copyWithCompanion(NotebooksCompanion data) {
    return NotebookRow(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      coverColor: data.coverColor.present
          ? data.coverColor.value
          : this.coverColor,
      coverImagePath: data.coverImagePath.present
          ? data.coverImagePath.value
          : this.coverImagePath,
      sortOrder: data.sortOrder.present ? data.sortOrder.value : this.sortOrder,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('NotebookRow(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('coverColor: $coverColor, ')
          ..write('coverImagePath: $coverImagePath, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    name,
    coverColor,
    coverImagePath,
    sortOrder,
    createdAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is NotebookRow &&
          other.id == this.id &&
          other.name == this.name &&
          other.coverColor == this.coverColor &&
          other.coverImagePath == this.coverImagePath &&
          other.sortOrder == this.sortOrder &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class NotebooksCompanion extends UpdateCompanion<NotebookRow> {
  final Value<String> id;
  final Value<String> name;
  final Value<int> coverColor;
  final Value<String?> coverImagePath;
  final Value<int> sortOrder;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const NotebooksCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.coverColor = const Value.absent(),
    this.coverImagePath = const Value.absent(),
    this.sortOrder = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  NotebooksCompanion.insert({
    required String id,
    required String name,
    required int coverColor,
    this.coverImagePath = const Value.absent(),
    this.sortOrder = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       name = Value(name),
       coverColor = Value(coverColor),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<NotebookRow> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<int>? coverColor,
    Expression<String>? coverImagePath,
    Expression<int>? sortOrder,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (coverColor != null) 'cover_color': coverColor,
      if (coverImagePath != null) 'cover_image_path': coverImagePath,
      if (sortOrder != null) 'sort_order': sortOrder,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  NotebooksCompanion copyWith({
    Value<String>? id,
    Value<String>? name,
    Value<int>? coverColor,
    Value<String?>? coverImagePath,
    Value<int>? sortOrder,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return NotebooksCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      coverColor: coverColor ?? this.coverColor,
      coverImagePath: coverImagePath ?? this.coverImagePath,
      sortOrder: sortOrder ?? this.sortOrder,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (coverColor.present) {
      map['cover_color'] = Variable<int>(coverColor.value);
    }
    if (coverImagePath.present) {
      map['cover_image_path'] = Variable<String>(coverImagePath.value);
    }
    if (sortOrder.present) {
      map['sort_order'] = Variable<int>(sortOrder.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('NotebooksCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('coverColor: $coverColor, ')
          ..write('coverImagePath: $coverImagePath, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $NotesTable extends Notes with TableInfo<$NotesTable, NoteRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $NotesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _notebookIdMeta = const VerificationMeta(
    'notebookId',
  );
  @override
  late final GeneratedColumn<String> notebookId = GeneratedColumn<String>(
    'notebook_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES notebooks (id)',
    ),
  );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _bodyMeta = const VerificationMeta('body');
  @override
  late final GeneratedColumn<String> body = GeneratedColumn<String>(
    'body',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _noteTypeMeta = const VerificationMeta(
    'noteType',
  );
  @override
  late final GeneratedColumn<String> noteType = GeneratedColumn<String>(
    'note_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('text'),
  );
  static const VerificationMeta _colorMeta = const VerificationMeta('color');
  @override
  late final GeneratedColumn<int> color = GeneratedColumn<int>(
    'color',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _isPinnedMeta = const VerificationMeta(
    'isPinned',
  );
  @override
  late final GeneratedColumn<bool> isPinned = GeneratedColumn<bool>(
    'is_pinned',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_pinned" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _isFavoriteMeta = const VerificationMeta(
    'isFavorite',
  );
  @override
  late final GeneratedColumn<bool> isFavorite = GeneratedColumn<bool>(
    'is_favorite',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_favorite" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _isLockedMeta = const VerificationMeta(
    'isLocked',
  );
  @override
  late final GeneratedColumn<bool> isLocked = GeneratedColumn<bool>(
    'is_locked',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_locked" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _projectIdMeta = const VerificationMeta(
    'projectId',
  );
  @override
  late final GeneratedColumn<String> projectId = GeneratedColumn<String>(
    'project_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES projects (id) ON DELETE SET NULL',
    ),
  );
  static const VerificationMeta _taskIdMeta = const VerificationMeta('taskId');
  @override
  late final GeneratedColumn<String> taskId = GeneratedColumn<String>(
    'task_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES tasks (id) ON DELETE SET NULL',
    ),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
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
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'notes';
  @override
  VerificationContext validateIntegrity(
    Insertable<NoteRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('notebook_id')) {
      context.handle(
        _notebookIdMeta,
        notebookId.isAcceptableOrUnknown(data['notebook_id']!, _notebookIdMeta),
      );
    } else if (isInserting) {
      context.missing(_notebookIdMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    }
    if (data.containsKey('body')) {
      context.handle(
        _bodyMeta,
        body.isAcceptableOrUnknown(data['body']!, _bodyMeta),
      );
    }
    if (data.containsKey('note_type')) {
      context.handle(
        _noteTypeMeta,
        noteType.isAcceptableOrUnknown(data['note_type']!, _noteTypeMeta),
      );
    }
    if (data.containsKey('color')) {
      context.handle(
        _colorMeta,
        color.isAcceptableOrUnknown(data['color']!, _colorMeta),
      );
    } else if (isInserting) {
      context.missing(_colorMeta);
    }
    if (data.containsKey('is_pinned')) {
      context.handle(
        _isPinnedMeta,
        isPinned.isAcceptableOrUnknown(data['is_pinned']!, _isPinnedMeta),
      );
    }
    if (data.containsKey('is_favorite')) {
      context.handle(
        _isFavoriteMeta,
        isFavorite.isAcceptableOrUnknown(data['is_favorite']!, _isFavoriteMeta),
      );
    }
    if (data.containsKey('is_locked')) {
      context.handle(
        _isLockedMeta,
        isLocked.isAcceptableOrUnknown(data['is_locked']!, _isLockedMeta),
      );
    }
    if (data.containsKey('project_id')) {
      context.handle(
        _projectIdMeta,
        projectId.isAcceptableOrUnknown(data['project_id']!, _projectIdMeta),
      );
    }
    if (data.containsKey('task_id')) {
      context.handle(
        _taskIdMeta,
        taskId.isAcceptableOrUnknown(data['task_id']!, _taskIdMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  NoteRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return NoteRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      notebookId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}notebook_id'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      body: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}body'],
      )!,
      noteType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}note_type'],
      )!,
      color: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}color'],
      )!,
      isPinned: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_pinned'],
      )!,
      isFavorite: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_favorite'],
      )!,
      isLocked: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_locked'],
      )!,
      projectId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}project_id'],
      ),
      taskId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}task_id'],
      ),
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $NotesTable createAlias(String alias) {
    return $NotesTable(attachedDatabase, alias);
  }
}

class NoteRow extends DataClass implements Insertable<NoteRow> {
  final String id;
  final String notebookId;
  final String title;
  final String body;

  /// text | todo
  final String noteType;
  final int color;
  final bool isPinned;
  final bool isFavorite;
  final bool isLocked;
  final String? projectId;
  final String? taskId;
  final DateTime createdAt;
  final DateTime updatedAt;
  const NoteRow({
    required this.id,
    required this.notebookId,
    required this.title,
    required this.body,
    required this.noteType,
    required this.color,
    required this.isPinned,
    required this.isFavorite,
    required this.isLocked,
    this.projectId,
    this.taskId,
    required this.createdAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['notebook_id'] = Variable<String>(notebookId);
    map['title'] = Variable<String>(title);
    map['body'] = Variable<String>(body);
    map['note_type'] = Variable<String>(noteType);
    map['color'] = Variable<int>(color);
    map['is_pinned'] = Variable<bool>(isPinned);
    map['is_favorite'] = Variable<bool>(isFavorite);
    map['is_locked'] = Variable<bool>(isLocked);
    if (!nullToAbsent || projectId != null) {
      map['project_id'] = Variable<String>(projectId);
    }
    if (!nullToAbsent || taskId != null) {
      map['task_id'] = Variable<String>(taskId);
    }
    map['created_at'] = Variable<DateTime>(createdAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  NotesCompanion toCompanion(bool nullToAbsent) {
    return NotesCompanion(
      id: Value(id),
      notebookId: Value(notebookId),
      title: Value(title),
      body: Value(body),
      noteType: Value(noteType),
      color: Value(color),
      isPinned: Value(isPinned),
      isFavorite: Value(isFavorite),
      isLocked: Value(isLocked),
      projectId: projectId == null && nullToAbsent
          ? const Value.absent()
          : Value(projectId),
      taskId: taskId == null && nullToAbsent
          ? const Value.absent()
          : Value(taskId),
      createdAt: Value(createdAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory NoteRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return NoteRow(
      id: serializer.fromJson<String>(json['id']),
      notebookId: serializer.fromJson<String>(json['notebookId']),
      title: serializer.fromJson<String>(json['title']),
      body: serializer.fromJson<String>(json['body']),
      noteType: serializer.fromJson<String>(json['noteType']),
      color: serializer.fromJson<int>(json['color']),
      isPinned: serializer.fromJson<bool>(json['isPinned']),
      isFavorite: serializer.fromJson<bool>(json['isFavorite']),
      isLocked: serializer.fromJson<bool>(json['isLocked']),
      projectId: serializer.fromJson<String?>(json['projectId']),
      taskId: serializer.fromJson<String?>(json['taskId']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'notebookId': serializer.toJson<String>(notebookId),
      'title': serializer.toJson<String>(title),
      'body': serializer.toJson<String>(body),
      'noteType': serializer.toJson<String>(noteType),
      'color': serializer.toJson<int>(color),
      'isPinned': serializer.toJson<bool>(isPinned),
      'isFavorite': serializer.toJson<bool>(isFavorite),
      'isLocked': serializer.toJson<bool>(isLocked),
      'projectId': serializer.toJson<String?>(projectId),
      'taskId': serializer.toJson<String?>(taskId),
      'createdAt': serializer.toJson<DateTime>(createdAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  NoteRow copyWith({
    String? id,
    String? notebookId,
    String? title,
    String? body,
    String? noteType,
    int? color,
    bool? isPinned,
    bool? isFavorite,
    bool? isLocked,
    Value<String?> projectId = const Value.absent(),
    Value<String?> taskId = const Value.absent(),
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => NoteRow(
    id: id ?? this.id,
    notebookId: notebookId ?? this.notebookId,
    title: title ?? this.title,
    body: body ?? this.body,
    noteType: noteType ?? this.noteType,
    color: color ?? this.color,
    isPinned: isPinned ?? this.isPinned,
    isFavorite: isFavorite ?? this.isFavorite,
    isLocked: isLocked ?? this.isLocked,
    projectId: projectId.present ? projectId.value : this.projectId,
    taskId: taskId.present ? taskId.value : this.taskId,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  NoteRow copyWithCompanion(NotesCompanion data) {
    return NoteRow(
      id: data.id.present ? data.id.value : this.id,
      notebookId: data.notebookId.present
          ? data.notebookId.value
          : this.notebookId,
      title: data.title.present ? data.title.value : this.title,
      body: data.body.present ? data.body.value : this.body,
      noteType: data.noteType.present ? data.noteType.value : this.noteType,
      color: data.color.present ? data.color.value : this.color,
      isPinned: data.isPinned.present ? data.isPinned.value : this.isPinned,
      isFavorite: data.isFavorite.present
          ? data.isFavorite.value
          : this.isFavorite,
      isLocked: data.isLocked.present ? data.isLocked.value : this.isLocked,
      projectId: data.projectId.present ? data.projectId.value : this.projectId,
      taskId: data.taskId.present ? data.taskId.value : this.taskId,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('NoteRow(')
          ..write('id: $id, ')
          ..write('notebookId: $notebookId, ')
          ..write('title: $title, ')
          ..write('body: $body, ')
          ..write('noteType: $noteType, ')
          ..write('color: $color, ')
          ..write('isPinned: $isPinned, ')
          ..write('isFavorite: $isFavorite, ')
          ..write('isLocked: $isLocked, ')
          ..write('projectId: $projectId, ')
          ..write('taskId: $taskId, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
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
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is NoteRow &&
          other.id == this.id &&
          other.notebookId == this.notebookId &&
          other.title == this.title &&
          other.body == this.body &&
          other.noteType == this.noteType &&
          other.color == this.color &&
          other.isPinned == this.isPinned &&
          other.isFavorite == this.isFavorite &&
          other.isLocked == this.isLocked &&
          other.projectId == this.projectId &&
          other.taskId == this.taskId &&
          other.createdAt == this.createdAt &&
          other.updatedAt == this.updatedAt);
}

class NotesCompanion extends UpdateCompanion<NoteRow> {
  final Value<String> id;
  final Value<String> notebookId;
  final Value<String> title;
  final Value<String> body;
  final Value<String> noteType;
  final Value<int> color;
  final Value<bool> isPinned;
  final Value<bool> isFavorite;
  final Value<bool> isLocked;
  final Value<String?> projectId;
  final Value<String?> taskId;
  final Value<DateTime> createdAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const NotesCompanion({
    this.id = const Value.absent(),
    this.notebookId = const Value.absent(),
    this.title = const Value.absent(),
    this.body = const Value.absent(),
    this.noteType = const Value.absent(),
    this.color = const Value.absent(),
    this.isPinned = const Value.absent(),
    this.isFavorite = const Value.absent(),
    this.isLocked = const Value.absent(),
    this.projectId = const Value.absent(),
    this.taskId = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  NotesCompanion.insert({
    required String id,
    required String notebookId,
    this.title = const Value.absent(),
    this.body = const Value.absent(),
    this.noteType = const Value.absent(),
    required int color,
    this.isPinned = const Value.absent(),
    this.isFavorite = const Value.absent(),
    this.isLocked = const Value.absent(),
    this.projectId = const Value.absent(),
    this.taskId = const Value.absent(),
    required DateTime createdAt,
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       notebookId = Value(notebookId),
       color = Value(color),
       createdAt = Value(createdAt),
       updatedAt = Value(updatedAt);
  static Insertable<NoteRow> custom({
    Expression<String>? id,
    Expression<String>? notebookId,
    Expression<String>? title,
    Expression<String>? body,
    Expression<String>? noteType,
    Expression<int>? color,
    Expression<bool>? isPinned,
    Expression<bool>? isFavorite,
    Expression<bool>? isLocked,
    Expression<String>? projectId,
    Expression<String>? taskId,
    Expression<DateTime>? createdAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (notebookId != null) 'notebook_id': notebookId,
      if (title != null) 'title': title,
      if (body != null) 'body': body,
      if (noteType != null) 'note_type': noteType,
      if (color != null) 'color': color,
      if (isPinned != null) 'is_pinned': isPinned,
      if (isFavorite != null) 'is_favorite': isFavorite,
      if (isLocked != null) 'is_locked': isLocked,
      if (projectId != null) 'project_id': projectId,
      if (taskId != null) 'task_id': taskId,
      if (createdAt != null) 'created_at': createdAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  NotesCompanion copyWith({
    Value<String>? id,
    Value<String>? notebookId,
    Value<String>? title,
    Value<String>? body,
    Value<String>? noteType,
    Value<int>? color,
    Value<bool>? isPinned,
    Value<bool>? isFavorite,
    Value<bool>? isLocked,
    Value<String?>? projectId,
    Value<String?>? taskId,
    Value<DateTime>? createdAt,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return NotesCompanion(
      id: id ?? this.id,
      notebookId: notebookId ?? this.notebookId,
      title: title ?? this.title,
      body: body ?? this.body,
      noteType: noteType ?? this.noteType,
      color: color ?? this.color,
      isPinned: isPinned ?? this.isPinned,
      isFavorite: isFavorite ?? this.isFavorite,
      isLocked: isLocked ?? this.isLocked,
      projectId: projectId ?? this.projectId,
      taskId: taskId ?? this.taskId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (notebookId.present) {
      map['notebook_id'] = Variable<String>(notebookId.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (body.present) {
      map['body'] = Variable<String>(body.value);
    }
    if (noteType.present) {
      map['note_type'] = Variable<String>(noteType.value);
    }
    if (color.present) {
      map['color'] = Variable<int>(color.value);
    }
    if (isPinned.present) {
      map['is_pinned'] = Variable<bool>(isPinned.value);
    }
    if (isFavorite.present) {
      map['is_favorite'] = Variable<bool>(isFavorite.value);
    }
    if (isLocked.present) {
      map['is_locked'] = Variable<bool>(isLocked.value);
    }
    if (projectId.present) {
      map['project_id'] = Variable<String>(projectId.value);
    }
    if (taskId.present) {
      map['task_id'] = Variable<String>(taskId.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('NotesCompanion(')
          ..write('id: $id, ')
          ..write('notebookId: $notebookId, ')
          ..write('title: $title, ')
          ..write('body: $body, ')
          ..write('noteType: $noteType, ')
          ..write('color: $color, ')
          ..write('isPinned: $isPinned, ')
          ..write('isFavorite: $isFavorite, ')
          ..write('isLocked: $isLocked, ')
          ..write('projectId: $projectId, ')
          ..write('taskId: $taskId, ')
          ..write('createdAt: $createdAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $CalendarAccountsTable extends CalendarAccounts
    with TableInfo<$CalendarAccountsTable, CalendarAccountRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CalendarAccountsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _providerMeta = const VerificationMeta(
    'provider',
  );
  @override
  late final GeneratedColumn<String> provider = GeneratedColumn<String>(
    'provider',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _emailMeta = const VerificationMeta('email');
  @override
  late final GeneratedColumn<String> email = GeneratedColumn<String>(
    'email',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _calendarIdMeta = const VerificationMeta(
    'calendarId',
  );
  @override
  late final GeneratedColumn<String> calendarId = GeneratedColumn<String>(
    'calendar_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _connectedAtMeta = const VerificationMeta(
    'connectedAt',
  );
  @override
  late final GeneratedColumn<DateTime> connectedAt = GeneratedColumn<DateTime>(
    'connected_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _lastSyncAtMeta = const VerificationMeta(
    'lastSyncAt',
  );
  @override
  late final GeneratedColumn<DateTime> lastSyncAt = GeneratedColumn<DateTime>(
    'last_sync_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    provider,
    email,
    calendarId,
    connectedAt,
    lastSyncAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'calendar_accounts';
  @override
  VerificationContext validateIntegrity(
    Insertable<CalendarAccountRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('provider')) {
      context.handle(
        _providerMeta,
        provider.isAcceptableOrUnknown(data['provider']!, _providerMeta),
      );
    } else if (isInserting) {
      context.missing(_providerMeta);
    }
    if (data.containsKey('email')) {
      context.handle(
        _emailMeta,
        email.isAcceptableOrUnknown(data['email']!, _emailMeta),
      );
    } else if (isInserting) {
      context.missing(_emailMeta);
    }
    if (data.containsKey('calendar_id')) {
      context.handle(
        _calendarIdMeta,
        calendarId.isAcceptableOrUnknown(data['calendar_id']!, _calendarIdMeta),
      );
    } else if (isInserting) {
      context.missing(_calendarIdMeta);
    }
    if (data.containsKey('connected_at')) {
      context.handle(
        _connectedAtMeta,
        connectedAt.isAcceptableOrUnknown(
          data['connected_at']!,
          _connectedAtMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_connectedAtMeta);
    }
    if (data.containsKey('last_sync_at')) {
      context.handle(
        _lastSyncAtMeta,
        lastSyncAt.isAcceptableOrUnknown(
          data['last_sync_at']!,
          _lastSyncAtMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  CalendarAccountRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CalendarAccountRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      provider: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}provider'],
      )!,
      email: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}email'],
      )!,
      calendarId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}calendar_id'],
      )!,
      connectedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}connected_at'],
      )!,
      lastSyncAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}last_sync_at'],
      ),
    );
  }

  @override
  $CalendarAccountsTable createAlias(String alias) {
    return $CalendarAccountsTable(attachedDatabase, alias);
  }
}

class CalendarAccountRow extends DataClass
    implements Insertable<CalendarAccountRow> {
  final String id;

  /// google
  final String provider;
  final String email;
  final String calendarId;
  final DateTime connectedAt;
  final DateTime? lastSyncAt;
  const CalendarAccountRow({
    required this.id,
    required this.provider,
    required this.email,
    required this.calendarId,
    required this.connectedAt,
    this.lastSyncAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['provider'] = Variable<String>(provider);
    map['email'] = Variable<String>(email);
    map['calendar_id'] = Variable<String>(calendarId);
    map['connected_at'] = Variable<DateTime>(connectedAt);
    if (!nullToAbsent || lastSyncAt != null) {
      map['last_sync_at'] = Variable<DateTime>(lastSyncAt);
    }
    return map;
  }

  CalendarAccountsCompanion toCompanion(bool nullToAbsent) {
    return CalendarAccountsCompanion(
      id: Value(id),
      provider: Value(provider),
      email: Value(email),
      calendarId: Value(calendarId),
      connectedAt: Value(connectedAt),
      lastSyncAt: lastSyncAt == null && nullToAbsent
          ? const Value.absent()
          : Value(lastSyncAt),
    );
  }

  factory CalendarAccountRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CalendarAccountRow(
      id: serializer.fromJson<String>(json['id']),
      provider: serializer.fromJson<String>(json['provider']),
      email: serializer.fromJson<String>(json['email']),
      calendarId: serializer.fromJson<String>(json['calendarId']),
      connectedAt: serializer.fromJson<DateTime>(json['connectedAt']),
      lastSyncAt: serializer.fromJson<DateTime?>(json['lastSyncAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'provider': serializer.toJson<String>(provider),
      'email': serializer.toJson<String>(email),
      'calendarId': serializer.toJson<String>(calendarId),
      'connectedAt': serializer.toJson<DateTime>(connectedAt),
      'lastSyncAt': serializer.toJson<DateTime?>(lastSyncAt),
    };
  }

  CalendarAccountRow copyWith({
    String? id,
    String? provider,
    String? email,
    String? calendarId,
    DateTime? connectedAt,
    Value<DateTime?> lastSyncAt = const Value.absent(),
  }) => CalendarAccountRow(
    id: id ?? this.id,
    provider: provider ?? this.provider,
    email: email ?? this.email,
    calendarId: calendarId ?? this.calendarId,
    connectedAt: connectedAt ?? this.connectedAt,
    lastSyncAt: lastSyncAt.present ? lastSyncAt.value : this.lastSyncAt,
  );
  CalendarAccountRow copyWithCompanion(CalendarAccountsCompanion data) {
    return CalendarAccountRow(
      id: data.id.present ? data.id.value : this.id,
      provider: data.provider.present ? data.provider.value : this.provider,
      email: data.email.present ? data.email.value : this.email,
      calendarId: data.calendarId.present
          ? data.calendarId.value
          : this.calendarId,
      connectedAt: data.connectedAt.present
          ? data.connectedAt.value
          : this.connectedAt,
      lastSyncAt: data.lastSyncAt.present
          ? data.lastSyncAt.value
          : this.lastSyncAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CalendarAccountRow(')
          ..write('id: $id, ')
          ..write('provider: $provider, ')
          ..write('email: $email, ')
          ..write('calendarId: $calendarId, ')
          ..write('connectedAt: $connectedAt, ')
          ..write('lastSyncAt: $lastSyncAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, provider, email, calendarId, connectedAt, lastSyncAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CalendarAccountRow &&
          other.id == this.id &&
          other.provider == this.provider &&
          other.email == this.email &&
          other.calendarId == this.calendarId &&
          other.connectedAt == this.connectedAt &&
          other.lastSyncAt == this.lastSyncAt);
}

class CalendarAccountsCompanion extends UpdateCompanion<CalendarAccountRow> {
  final Value<String> id;
  final Value<String> provider;
  final Value<String> email;
  final Value<String> calendarId;
  final Value<DateTime> connectedAt;
  final Value<DateTime?> lastSyncAt;
  final Value<int> rowid;
  const CalendarAccountsCompanion({
    this.id = const Value.absent(),
    this.provider = const Value.absent(),
    this.email = const Value.absent(),
    this.calendarId = const Value.absent(),
    this.connectedAt = const Value.absent(),
    this.lastSyncAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CalendarAccountsCompanion.insert({
    required String id,
    required String provider,
    required String email,
    required String calendarId,
    required DateTime connectedAt,
    this.lastSyncAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       provider = Value(provider),
       email = Value(email),
       calendarId = Value(calendarId),
       connectedAt = Value(connectedAt);
  static Insertable<CalendarAccountRow> custom({
    Expression<String>? id,
    Expression<String>? provider,
    Expression<String>? email,
    Expression<String>? calendarId,
    Expression<DateTime>? connectedAt,
    Expression<DateTime>? lastSyncAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (provider != null) 'provider': provider,
      if (email != null) 'email': email,
      if (calendarId != null) 'calendar_id': calendarId,
      if (connectedAt != null) 'connected_at': connectedAt,
      if (lastSyncAt != null) 'last_sync_at': lastSyncAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CalendarAccountsCompanion copyWith({
    Value<String>? id,
    Value<String>? provider,
    Value<String>? email,
    Value<String>? calendarId,
    Value<DateTime>? connectedAt,
    Value<DateTime?>? lastSyncAt,
    Value<int>? rowid,
  }) {
    return CalendarAccountsCompanion(
      id: id ?? this.id,
      provider: provider ?? this.provider,
      email: email ?? this.email,
      calendarId: calendarId ?? this.calendarId,
      connectedAt: connectedAt ?? this.connectedAt,
      lastSyncAt: lastSyncAt ?? this.lastSyncAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (provider.present) {
      map['provider'] = Variable<String>(provider.value);
    }
    if (email.present) {
      map['email'] = Variable<String>(email.value);
    }
    if (calendarId.present) {
      map['calendar_id'] = Variable<String>(calendarId.value);
    }
    if (connectedAt.present) {
      map['connected_at'] = Variable<DateTime>(connectedAt.value);
    }
    if (lastSyncAt.present) {
      map['last_sync_at'] = Variable<DateTime>(lastSyncAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CalendarAccountsCompanion(')
          ..write('id: $id, ')
          ..write('provider: $provider, ')
          ..write('email: $email, ')
          ..write('calendarId: $calendarId, ')
          ..write('connectedAt: $connectedAt, ')
          ..write('lastSyncAt: $lastSyncAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $CachedCalendarEventsTable extends CachedCalendarEvents
    with TableInfo<$CachedCalendarEventsTable, CachedCalendarEventRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CachedCalendarEventsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _accountIdMeta = const VerificationMeta(
    'accountId',
  );
  @override
  late final GeneratedColumn<String> accountId = GeneratedColumn<String>(
    'account_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES calendar_accounts (id)',
    ),
  );
  static const VerificationMeta _googleEventIdMeta = const VerificationMeta(
    'googleEventId',
  );
  @override
  late final GeneratedColumn<String> googleEventId = GeneratedColumn<String>(
    'google_event_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _descriptionMeta = const VerificationMeta(
    'description',
  );
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
    'description',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _startAtMeta = const VerificationMeta(
    'startAt',
  );
  @override
  late final GeneratedColumn<DateTime> startAt = GeneratedColumn<DateTime>(
    'start_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _endAtMeta = const VerificationMeta('endAt');
  @override
  late final GeneratedColumn<DateTime> endAt = GeneratedColumn<DateTime>(
    'end_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _allDayMeta = const VerificationMeta('allDay');
  @override
  late final GeneratedColumn<bool> allDay = GeneratedColumn<bool>(
    'all_day',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("all_day" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _htmlLinkMeta = const VerificationMeta(
    'htmlLink',
  );
  @override
  late final GeneratedColumn<String> htmlLink = GeneratedColumn<String>(
    'html_link',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _etagMeta = const VerificationMeta('etag');
  @override
  late final GeneratedColumn<String> etag = GeneratedColumn<String>(
    'etag',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    accountId,
    googleEventId,
    title,
    description,
    startAt,
    endAt,
    allDay,
    htmlLink,
    etag,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'cached_calendar_events';
  @override
  VerificationContext validateIntegrity(
    Insertable<CachedCalendarEventRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('account_id')) {
      context.handle(
        _accountIdMeta,
        accountId.isAcceptableOrUnknown(data['account_id']!, _accountIdMeta),
      );
    } else if (isInserting) {
      context.missing(_accountIdMeta);
    }
    if (data.containsKey('google_event_id')) {
      context.handle(
        _googleEventIdMeta,
        googleEventId.isAcceptableOrUnknown(
          data['google_event_id']!,
          _googleEventIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_googleEventIdMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
        _descriptionMeta,
        description.isAcceptableOrUnknown(
          data['description']!,
          _descriptionMeta,
        ),
      );
    }
    if (data.containsKey('start_at')) {
      context.handle(
        _startAtMeta,
        startAt.isAcceptableOrUnknown(data['start_at']!, _startAtMeta),
      );
    } else if (isInserting) {
      context.missing(_startAtMeta);
    }
    if (data.containsKey('end_at')) {
      context.handle(
        _endAtMeta,
        endAt.isAcceptableOrUnknown(data['end_at']!, _endAtMeta),
      );
    } else if (isInserting) {
      context.missing(_endAtMeta);
    }
    if (data.containsKey('all_day')) {
      context.handle(
        _allDayMeta,
        allDay.isAcceptableOrUnknown(data['all_day']!, _allDayMeta),
      );
    }
    if (data.containsKey('html_link')) {
      context.handle(
        _htmlLinkMeta,
        htmlLink.isAcceptableOrUnknown(data['html_link']!, _htmlLinkMeta),
      );
    }
    if (data.containsKey('etag')) {
      context.handle(
        _etagMeta,
        etag.isAcceptableOrUnknown(data['etag']!, _etagMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  CachedCalendarEventRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CachedCalendarEventRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      accountId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}account_id'],
      )!,
      googleEventId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}google_event_id'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      description: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}description'],
      ),
      startAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}start_at'],
      )!,
      endAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}end_at'],
      )!,
      allDay: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}all_day'],
      )!,
      htmlLink: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}html_link'],
      ),
      etag: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}etag'],
      ),
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $CachedCalendarEventsTable createAlias(String alias) {
    return $CachedCalendarEventsTable(attachedDatabase, alias);
  }
}

class CachedCalendarEventRow extends DataClass
    implements Insertable<CachedCalendarEventRow> {
  final String id;
  final String accountId;
  final String googleEventId;
  final String title;
  final String? description;
  final DateTime startAt;
  final DateTime endAt;
  final bool allDay;
  final String? htmlLink;
  final String? etag;
  final DateTime updatedAt;
  const CachedCalendarEventRow({
    required this.id,
    required this.accountId,
    required this.googleEventId,
    required this.title,
    this.description,
    required this.startAt,
    required this.endAt,
    required this.allDay,
    this.htmlLink,
    this.etag,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['account_id'] = Variable<String>(accountId);
    map['google_event_id'] = Variable<String>(googleEventId);
    map['title'] = Variable<String>(title);
    if (!nullToAbsent || description != null) {
      map['description'] = Variable<String>(description);
    }
    map['start_at'] = Variable<DateTime>(startAt);
    map['end_at'] = Variable<DateTime>(endAt);
    map['all_day'] = Variable<bool>(allDay);
    if (!nullToAbsent || htmlLink != null) {
      map['html_link'] = Variable<String>(htmlLink);
    }
    if (!nullToAbsent || etag != null) {
      map['etag'] = Variable<String>(etag);
    }
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  CachedCalendarEventsCompanion toCompanion(bool nullToAbsent) {
    return CachedCalendarEventsCompanion(
      id: Value(id),
      accountId: Value(accountId),
      googleEventId: Value(googleEventId),
      title: Value(title),
      description: description == null && nullToAbsent
          ? const Value.absent()
          : Value(description),
      startAt: Value(startAt),
      endAt: Value(endAt),
      allDay: Value(allDay),
      htmlLink: htmlLink == null && nullToAbsent
          ? const Value.absent()
          : Value(htmlLink),
      etag: etag == null && nullToAbsent ? const Value.absent() : Value(etag),
      updatedAt: Value(updatedAt),
    );
  }

  factory CachedCalendarEventRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CachedCalendarEventRow(
      id: serializer.fromJson<String>(json['id']),
      accountId: serializer.fromJson<String>(json['accountId']),
      googleEventId: serializer.fromJson<String>(json['googleEventId']),
      title: serializer.fromJson<String>(json['title']),
      description: serializer.fromJson<String?>(json['description']),
      startAt: serializer.fromJson<DateTime>(json['startAt']),
      endAt: serializer.fromJson<DateTime>(json['endAt']),
      allDay: serializer.fromJson<bool>(json['allDay']),
      htmlLink: serializer.fromJson<String?>(json['htmlLink']),
      etag: serializer.fromJson<String?>(json['etag']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'accountId': serializer.toJson<String>(accountId),
      'googleEventId': serializer.toJson<String>(googleEventId),
      'title': serializer.toJson<String>(title),
      'description': serializer.toJson<String?>(description),
      'startAt': serializer.toJson<DateTime>(startAt),
      'endAt': serializer.toJson<DateTime>(endAt),
      'allDay': serializer.toJson<bool>(allDay),
      'htmlLink': serializer.toJson<String?>(htmlLink),
      'etag': serializer.toJson<String?>(etag),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  CachedCalendarEventRow copyWith({
    String? id,
    String? accountId,
    String? googleEventId,
    String? title,
    Value<String?> description = const Value.absent(),
    DateTime? startAt,
    DateTime? endAt,
    bool? allDay,
    Value<String?> htmlLink = const Value.absent(),
    Value<String?> etag = const Value.absent(),
    DateTime? updatedAt,
  }) => CachedCalendarEventRow(
    id: id ?? this.id,
    accountId: accountId ?? this.accountId,
    googleEventId: googleEventId ?? this.googleEventId,
    title: title ?? this.title,
    description: description.present ? description.value : this.description,
    startAt: startAt ?? this.startAt,
    endAt: endAt ?? this.endAt,
    allDay: allDay ?? this.allDay,
    htmlLink: htmlLink.present ? htmlLink.value : this.htmlLink,
    etag: etag.present ? etag.value : this.etag,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  CachedCalendarEventRow copyWithCompanion(CachedCalendarEventsCompanion data) {
    return CachedCalendarEventRow(
      id: data.id.present ? data.id.value : this.id,
      accountId: data.accountId.present ? data.accountId.value : this.accountId,
      googleEventId: data.googleEventId.present
          ? data.googleEventId.value
          : this.googleEventId,
      title: data.title.present ? data.title.value : this.title,
      description: data.description.present
          ? data.description.value
          : this.description,
      startAt: data.startAt.present ? data.startAt.value : this.startAt,
      endAt: data.endAt.present ? data.endAt.value : this.endAt,
      allDay: data.allDay.present ? data.allDay.value : this.allDay,
      htmlLink: data.htmlLink.present ? data.htmlLink.value : this.htmlLink,
      etag: data.etag.present ? data.etag.value : this.etag,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CachedCalendarEventRow(')
          ..write('id: $id, ')
          ..write('accountId: $accountId, ')
          ..write('googleEventId: $googleEventId, ')
          ..write('title: $title, ')
          ..write('description: $description, ')
          ..write('startAt: $startAt, ')
          ..write('endAt: $endAt, ')
          ..write('allDay: $allDay, ')
          ..write('htmlLink: $htmlLink, ')
          ..write('etag: $etag, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    accountId,
    googleEventId,
    title,
    description,
    startAt,
    endAt,
    allDay,
    htmlLink,
    etag,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CachedCalendarEventRow &&
          other.id == this.id &&
          other.accountId == this.accountId &&
          other.googleEventId == this.googleEventId &&
          other.title == this.title &&
          other.description == this.description &&
          other.startAt == this.startAt &&
          other.endAt == this.endAt &&
          other.allDay == this.allDay &&
          other.htmlLink == this.htmlLink &&
          other.etag == this.etag &&
          other.updatedAt == this.updatedAt);
}

class CachedCalendarEventsCompanion
    extends UpdateCompanion<CachedCalendarEventRow> {
  final Value<String> id;
  final Value<String> accountId;
  final Value<String> googleEventId;
  final Value<String> title;
  final Value<String?> description;
  final Value<DateTime> startAt;
  final Value<DateTime> endAt;
  final Value<bool> allDay;
  final Value<String?> htmlLink;
  final Value<String?> etag;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const CachedCalendarEventsCompanion({
    this.id = const Value.absent(),
    this.accountId = const Value.absent(),
    this.googleEventId = const Value.absent(),
    this.title = const Value.absent(),
    this.description = const Value.absent(),
    this.startAt = const Value.absent(),
    this.endAt = const Value.absent(),
    this.allDay = const Value.absent(),
    this.htmlLink = const Value.absent(),
    this.etag = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CachedCalendarEventsCompanion.insert({
    required String id,
    required String accountId,
    required String googleEventId,
    required String title,
    this.description = const Value.absent(),
    required DateTime startAt,
    required DateTime endAt,
    this.allDay = const Value.absent(),
    this.htmlLink = const Value.absent(),
    this.etag = const Value.absent(),
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       accountId = Value(accountId),
       googleEventId = Value(googleEventId),
       title = Value(title),
       startAt = Value(startAt),
       endAt = Value(endAt),
       updatedAt = Value(updatedAt);
  static Insertable<CachedCalendarEventRow> custom({
    Expression<String>? id,
    Expression<String>? accountId,
    Expression<String>? googleEventId,
    Expression<String>? title,
    Expression<String>? description,
    Expression<DateTime>? startAt,
    Expression<DateTime>? endAt,
    Expression<bool>? allDay,
    Expression<String>? htmlLink,
    Expression<String>? etag,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (accountId != null) 'account_id': accountId,
      if (googleEventId != null) 'google_event_id': googleEventId,
      if (title != null) 'title': title,
      if (description != null) 'description': description,
      if (startAt != null) 'start_at': startAt,
      if (endAt != null) 'end_at': endAt,
      if (allDay != null) 'all_day': allDay,
      if (htmlLink != null) 'html_link': htmlLink,
      if (etag != null) 'etag': etag,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CachedCalendarEventsCompanion copyWith({
    Value<String>? id,
    Value<String>? accountId,
    Value<String>? googleEventId,
    Value<String>? title,
    Value<String?>? description,
    Value<DateTime>? startAt,
    Value<DateTime>? endAt,
    Value<bool>? allDay,
    Value<String?>? htmlLink,
    Value<String?>? etag,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return CachedCalendarEventsCompanion(
      id: id ?? this.id,
      accountId: accountId ?? this.accountId,
      googleEventId: googleEventId ?? this.googleEventId,
      title: title ?? this.title,
      description: description ?? this.description,
      startAt: startAt ?? this.startAt,
      endAt: endAt ?? this.endAt,
      allDay: allDay ?? this.allDay,
      htmlLink: htmlLink ?? this.htmlLink,
      etag: etag ?? this.etag,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (accountId.present) {
      map['account_id'] = Variable<String>(accountId.value);
    }
    if (googleEventId.present) {
      map['google_event_id'] = Variable<String>(googleEventId.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (startAt.present) {
      map['start_at'] = Variable<DateTime>(startAt.value);
    }
    if (endAt.present) {
      map['end_at'] = Variable<DateTime>(endAt.value);
    }
    if (allDay.present) {
      map['all_day'] = Variable<bool>(allDay.value);
    }
    if (htmlLink.present) {
      map['html_link'] = Variable<String>(htmlLink.value);
    }
    if (etag.present) {
      map['etag'] = Variable<String>(etag.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CachedCalendarEventsCompanion(')
          ..write('id: $id, ')
          ..write('accountId: $accountId, ')
          ..write('googleEventId: $googleEventId, ')
          ..write('title: $title, ')
          ..write('description: $description, ')
          ..write('startAt: $startAt, ')
          ..write('endAt: $endAt, ')
          ..write('allDay: $allDay, ')
          ..write('htmlLink: $htmlLink, ')
          ..write('etag: $etag, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $TelegramAccountsTable extends TelegramAccounts
    with TableInfo<$TelegramAccountsTable, TelegramAccountRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TelegramAccountsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _phoneNumberMeta = const VerificationMeta(
    'phoneNumber',
  );
  @override
  late final GeneratedColumn<String> phoneNumber = GeneratedColumn<String>(
    'phone_number',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _telegramUserIdMeta = const VerificationMeta(
    'telegramUserId',
  );
  @override
  late final GeneratedColumn<String> telegramUserId = GeneratedColumn<String>(
    'telegram_user_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _usernameMeta = const VerificationMeta(
    'username',
  );
  @override
  late final GeneratedColumn<String> username = GeneratedColumn<String>(
    'username',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _displayNameMeta = const VerificationMeta(
    'displayName',
  );
  @override
  late final GeneratedColumn<String> displayName = GeneratedColumn<String>(
    'display_name',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _connectedAtMeta = const VerificationMeta(
    'connectedAt',
  );
  @override
  late final GeneratedColumn<DateTime> connectedAt = GeneratedColumn<DateTime>(
    'connected_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _lastSyncAtMeta = const VerificationMeta(
    'lastSyncAt',
  );
  @override
  late final GeneratedColumn<DateTime> lastSyncAt = GeneratedColumn<DateTime>(
    'last_sync_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    phoneNumber,
    telegramUserId,
    username,
    displayName,
    connectedAt,
    lastSyncAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'telegram_accounts';
  @override
  VerificationContext validateIntegrity(
    Insertable<TelegramAccountRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('phone_number')) {
      context.handle(
        _phoneNumberMeta,
        phoneNumber.isAcceptableOrUnknown(
          data['phone_number']!,
          _phoneNumberMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_phoneNumberMeta);
    }
    if (data.containsKey('telegram_user_id')) {
      context.handle(
        _telegramUserIdMeta,
        telegramUserId.isAcceptableOrUnknown(
          data['telegram_user_id']!,
          _telegramUserIdMeta,
        ),
      );
    }
    if (data.containsKey('username')) {
      context.handle(
        _usernameMeta,
        username.isAcceptableOrUnknown(data['username']!, _usernameMeta),
      );
    }
    if (data.containsKey('display_name')) {
      context.handle(
        _displayNameMeta,
        displayName.isAcceptableOrUnknown(
          data['display_name']!,
          _displayNameMeta,
        ),
      );
    }
    if (data.containsKey('connected_at')) {
      context.handle(
        _connectedAtMeta,
        connectedAt.isAcceptableOrUnknown(
          data['connected_at']!,
          _connectedAtMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_connectedAtMeta);
    }
    if (data.containsKey('last_sync_at')) {
      context.handle(
        _lastSyncAtMeta,
        lastSyncAt.isAcceptableOrUnknown(
          data['last_sync_at']!,
          _lastSyncAtMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  TelegramAccountRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TelegramAccountRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      phoneNumber: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}phone_number'],
      )!,
      telegramUserId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}telegram_user_id'],
      ),
      username: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}username'],
      ),
      displayName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}display_name'],
      ),
      connectedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}connected_at'],
      )!,
      lastSyncAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}last_sync_at'],
      ),
    );
  }

  @override
  $TelegramAccountsTable createAlias(String alias) {
    return $TelegramAccountsTable(attachedDatabase, alias);
  }
}

class TelegramAccountRow extends DataClass
    implements Insertable<TelegramAccountRow> {
  final String id;
  final String phoneNumber;
  final String? telegramUserId;
  final String? username;
  final String? displayName;
  final DateTime connectedAt;
  final DateTime? lastSyncAt;
  const TelegramAccountRow({
    required this.id,
    required this.phoneNumber,
    this.telegramUserId,
    this.username,
    this.displayName,
    required this.connectedAt,
    this.lastSyncAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['phone_number'] = Variable<String>(phoneNumber);
    if (!nullToAbsent || telegramUserId != null) {
      map['telegram_user_id'] = Variable<String>(telegramUserId);
    }
    if (!nullToAbsent || username != null) {
      map['username'] = Variable<String>(username);
    }
    if (!nullToAbsent || displayName != null) {
      map['display_name'] = Variable<String>(displayName);
    }
    map['connected_at'] = Variable<DateTime>(connectedAt);
    if (!nullToAbsent || lastSyncAt != null) {
      map['last_sync_at'] = Variable<DateTime>(lastSyncAt);
    }
    return map;
  }

  TelegramAccountsCompanion toCompanion(bool nullToAbsent) {
    return TelegramAccountsCompanion(
      id: Value(id),
      phoneNumber: Value(phoneNumber),
      telegramUserId: telegramUserId == null && nullToAbsent
          ? const Value.absent()
          : Value(telegramUserId),
      username: username == null && nullToAbsent
          ? const Value.absent()
          : Value(username),
      displayName: displayName == null && nullToAbsent
          ? const Value.absent()
          : Value(displayName),
      connectedAt: Value(connectedAt),
      lastSyncAt: lastSyncAt == null && nullToAbsent
          ? const Value.absent()
          : Value(lastSyncAt),
    );
  }

  factory TelegramAccountRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TelegramAccountRow(
      id: serializer.fromJson<String>(json['id']),
      phoneNumber: serializer.fromJson<String>(json['phoneNumber']),
      telegramUserId: serializer.fromJson<String?>(json['telegramUserId']),
      username: serializer.fromJson<String?>(json['username']),
      displayName: serializer.fromJson<String?>(json['displayName']),
      connectedAt: serializer.fromJson<DateTime>(json['connectedAt']),
      lastSyncAt: serializer.fromJson<DateTime?>(json['lastSyncAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'phoneNumber': serializer.toJson<String>(phoneNumber),
      'telegramUserId': serializer.toJson<String?>(telegramUserId),
      'username': serializer.toJson<String?>(username),
      'displayName': serializer.toJson<String?>(displayName),
      'connectedAt': serializer.toJson<DateTime>(connectedAt),
      'lastSyncAt': serializer.toJson<DateTime?>(lastSyncAt),
    };
  }

  TelegramAccountRow copyWith({
    String? id,
    String? phoneNumber,
    Value<String?> telegramUserId = const Value.absent(),
    Value<String?> username = const Value.absent(),
    Value<String?> displayName = const Value.absent(),
    DateTime? connectedAt,
    Value<DateTime?> lastSyncAt = const Value.absent(),
  }) => TelegramAccountRow(
    id: id ?? this.id,
    phoneNumber: phoneNumber ?? this.phoneNumber,
    telegramUserId: telegramUserId.present
        ? telegramUserId.value
        : this.telegramUserId,
    username: username.present ? username.value : this.username,
    displayName: displayName.present ? displayName.value : this.displayName,
    connectedAt: connectedAt ?? this.connectedAt,
    lastSyncAt: lastSyncAt.present ? lastSyncAt.value : this.lastSyncAt,
  );
  TelegramAccountRow copyWithCompanion(TelegramAccountsCompanion data) {
    return TelegramAccountRow(
      id: data.id.present ? data.id.value : this.id,
      phoneNumber: data.phoneNumber.present
          ? data.phoneNumber.value
          : this.phoneNumber,
      telegramUserId: data.telegramUserId.present
          ? data.telegramUserId.value
          : this.telegramUserId,
      username: data.username.present ? data.username.value : this.username,
      displayName: data.displayName.present
          ? data.displayName.value
          : this.displayName,
      connectedAt: data.connectedAt.present
          ? data.connectedAt.value
          : this.connectedAt,
      lastSyncAt: data.lastSyncAt.present
          ? data.lastSyncAt.value
          : this.lastSyncAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('TelegramAccountRow(')
          ..write('id: $id, ')
          ..write('phoneNumber: $phoneNumber, ')
          ..write('telegramUserId: $telegramUserId, ')
          ..write('username: $username, ')
          ..write('displayName: $displayName, ')
          ..write('connectedAt: $connectedAt, ')
          ..write('lastSyncAt: $lastSyncAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    phoneNumber,
    telegramUserId,
    username,
    displayName,
    connectedAt,
    lastSyncAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TelegramAccountRow &&
          other.id == this.id &&
          other.phoneNumber == this.phoneNumber &&
          other.telegramUserId == this.telegramUserId &&
          other.username == this.username &&
          other.displayName == this.displayName &&
          other.connectedAt == this.connectedAt &&
          other.lastSyncAt == this.lastSyncAt);
}

class TelegramAccountsCompanion extends UpdateCompanion<TelegramAccountRow> {
  final Value<String> id;
  final Value<String> phoneNumber;
  final Value<String?> telegramUserId;
  final Value<String?> username;
  final Value<String?> displayName;
  final Value<DateTime> connectedAt;
  final Value<DateTime?> lastSyncAt;
  final Value<int> rowid;
  const TelegramAccountsCompanion({
    this.id = const Value.absent(),
    this.phoneNumber = const Value.absent(),
    this.telegramUserId = const Value.absent(),
    this.username = const Value.absent(),
    this.displayName = const Value.absent(),
    this.connectedAt = const Value.absent(),
    this.lastSyncAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  TelegramAccountsCompanion.insert({
    required String id,
    required String phoneNumber,
    this.telegramUserId = const Value.absent(),
    this.username = const Value.absent(),
    this.displayName = const Value.absent(),
    required DateTime connectedAt,
    this.lastSyncAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       phoneNumber = Value(phoneNumber),
       connectedAt = Value(connectedAt);
  static Insertable<TelegramAccountRow> custom({
    Expression<String>? id,
    Expression<String>? phoneNumber,
    Expression<String>? telegramUserId,
    Expression<String>? username,
    Expression<String>? displayName,
    Expression<DateTime>? connectedAt,
    Expression<DateTime>? lastSyncAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (phoneNumber != null) 'phone_number': phoneNumber,
      if (telegramUserId != null) 'telegram_user_id': telegramUserId,
      if (username != null) 'username': username,
      if (displayName != null) 'display_name': displayName,
      if (connectedAt != null) 'connected_at': connectedAt,
      if (lastSyncAt != null) 'last_sync_at': lastSyncAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  TelegramAccountsCompanion copyWith({
    Value<String>? id,
    Value<String>? phoneNumber,
    Value<String?>? telegramUserId,
    Value<String?>? username,
    Value<String?>? displayName,
    Value<DateTime>? connectedAt,
    Value<DateTime?>? lastSyncAt,
    Value<int>? rowid,
  }) {
    return TelegramAccountsCompanion(
      id: id ?? this.id,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      telegramUserId: telegramUserId ?? this.telegramUserId,
      username: username ?? this.username,
      displayName: displayName ?? this.displayName,
      connectedAt: connectedAt ?? this.connectedAt,
      lastSyncAt: lastSyncAt ?? this.lastSyncAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (phoneNumber.present) {
      map['phone_number'] = Variable<String>(phoneNumber.value);
    }
    if (telegramUserId.present) {
      map['telegram_user_id'] = Variable<String>(telegramUserId.value);
    }
    if (username.present) {
      map['username'] = Variable<String>(username.value);
    }
    if (displayName.present) {
      map['display_name'] = Variable<String>(displayName.value);
    }
    if (connectedAt.present) {
      map['connected_at'] = Variable<DateTime>(connectedAt.value);
    }
    if (lastSyncAt.present) {
      map['last_sync_at'] = Variable<DateTime>(lastSyncAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TelegramAccountsCompanion(')
          ..write('id: $id, ')
          ..write('phoneNumber: $phoneNumber, ')
          ..write('telegramUserId: $telegramUserId, ')
          ..write('username: $username, ')
          ..write('displayName: $displayName, ')
          ..write('connectedAt: $connectedAt, ')
          ..write('lastSyncAt: $lastSyncAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $TelegramChatsTable extends TelegramChats
    with TableInfo<$TelegramChatsTable, TelegramChatRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TelegramChatsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _accountIdMeta = const VerificationMeta(
    'accountId',
  );
  @override
  late final GeneratedColumn<String> accountId = GeneratedColumn<String>(
    'account_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES telegram_accounts (id)',
    ),
  );
  static const VerificationMeta _telegramChatIdMeta = const VerificationMeta(
    'telegramChatId',
  );
  @override
  late final GeneratedColumn<String> telegramChatId = GeneratedColumn<String>(
    'telegram_chat_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _chatTypeMeta = const VerificationMeta(
    'chatType',
  );
  @override
  late final GeneratedColumn<String> chatType = GeneratedColumn<String>(
    'chat_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _usernameMeta = const VerificationMeta(
    'username',
  );
  @override
  late final GeneratedColumn<String> username = GeneratedColumn<String>(
    'username',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _isAllowedMeta = const VerificationMeta(
    'isAllowed',
  );
  @override
  late final GeneratedColumn<bool> isAllowed = GeneratedColumn<bool>(
    'is_allowed',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_allowed" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _lastMessageAtMeta = const VerificationMeta(
    'lastMessageAt',
  );
  @override
  late final GeneratedColumn<DateTime> lastMessageAt =
      GeneratedColumn<DateTime>(
        'last_message_at',
        aliasedName,
        true,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _unreadCountMeta = const VerificationMeta(
    'unreadCount',
  );
  @override
  late final GeneratedColumn<int> unreadCount = GeneratedColumn<int>(
    'unread_count',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _photoPathMeta = const VerificationMeta(
    'photoPath',
  );
  @override
  late final GeneratedColumn<String> photoPath = GeneratedColumn<String>(
    'photo_path',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    accountId,
    telegramChatId,
    title,
    chatType,
    username,
    isAllowed,
    lastMessageAt,
    unreadCount,
    photoPath,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'telegram_chats';
  @override
  VerificationContext validateIntegrity(
    Insertable<TelegramChatRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('account_id')) {
      context.handle(
        _accountIdMeta,
        accountId.isAcceptableOrUnknown(data['account_id']!, _accountIdMeta),
      );
    } else if (isInserting) {
      context.missing(_accountIdMeta);
    }
    if (data.containsKey('telegram_chat_id')) {
      context.handle(
        _telegramChatIdMeta,
        telegramChatId.isAcceptableOrUnknown(
          data['telegram_chat_id']!,
          _telegramChatIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_telegramChatIdMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('chat_type')) {
      context.handle(
        _chatTypeMeta,
        chatType.isAcceptableOrUnknown(data['chat_type']!, _chatTypeMeta),
      );
    } else if (isInserting) {
      context.missing(_chatTypeMeta);
    }
    if (data.containsKey('username')) {
      context.handle(
        _usernameMeta,
        username.isAcceptableOrUnknown(data['username']!, _usernameMeta),
      );
    }
    if (data.containsKey('is_allowed')) {
      context.handle(
        _isAllowedMeta,
        isAllowed.isAcceptableOrUnknown(data['is_allowed']!, _isAllowedMeta),
      );
    }
    if (data.containsKey('last_message_at')) {
      context.handle(
        _lastMessageAtMeta,
        lastMessageAt.isAcceptableOrUnknown(
          data['last_message_at']!,
          _lastMessageAtMeta,
        ),
      );
    }
    if (data.containsKey('unread_count')) {
      context.handle(
        _unreadCountMeta,
        unreadCount.isAcceptableOrUnknown(
          data['unread_count']!,
          _unreadCountMeta,
        ),
      );
    }
    if (data.containsKey('photo_path')) {
      context.handle(
        _photoPathMeta,
        photoPath.isAcceptableOrUnknown(data['photo_path']!, _photoPathMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  TelegramChatRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TelegramChatRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      accountId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}account_id'],
      )!,
      telegramChatId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}telegram_chat_id'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      chatType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}chat_type'],
      )!,
      username: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}username'],
      ),
      isAllowed: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_allowed'],
      )!,
      lastMessageAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}last_message_at'],
      ),
      unreadCount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}unread_count'],
      )!,
      photoPath: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}photo_path'],
      ),
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $TelegramChatsTable createAlias(String alias) {
    return $TelegramChatsTable(attachedDatabase, alias);
  }
}

class TelegramChatRow extends DataClass implements Insertable<TelegramChatRow> {
  final String id;
  final String accountId;

  /// Telegram chat id as string (may be negative for groups/channels).
  final String telegramChatId;
  final String title;

  /// private | group | channel | secret | unknown
  final String chatType;
  final String? username;
  final bool isAllowed;
  final DateTime? lastMessageAt;
  final int unreadCount;

  /// Local path to downloaded chat avatar (small).
  final String? photoPath;
  final DateTime updatedAt;
  const TelegramChatRow({
    required this.id,
    required this.accountId,
    required this.telegramChatId,
    required this.title,
    required this.chatType,
    this.username,
    required this.isAllowed,
    this.lastMessageAt,
    required this.unreadCount,
    this.photoPath,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['account_id'] = Variable<String>(accountId);
    map['telegram_chat_id'] = Variable<String>(telegramChatId);
    map['title'] = Variable<String>(title);
    map['chat_type'] = Variable<String>(chatType);
    if (!nullToAbsent || username != null) {
      map['username'] = Variable<String>(username);
    }
    map['is_allowed'] = Variable<bool>(isAllowed);
    if (!nullToAbsent || lastMessageAt != null) {
      map['last_message_at'] = Variable<DateTime>(lastMessageAt);
    }
    map['unread_count'] = Variable<int>(unreadCount);
    if (!nullToAbsent || photoPath != null) {
      map['photo_path'] = Variable<String>(photoPath);
    }
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  TelegramChatsCompanion toCompanion(bool nullToAbsent) {
    return TelegramChatsCompanion(
      id: Value(id),
      accountId: Value(accountId),
      telegramChatId: Value(telegramChatId),
      title: Value(title),
      chatType: Value(chatType),
      username: username == null && nullToAbsent
          ? const Value.absent()
          : Value(username),
      isAllowed: Value(isAllowed),
      lastMessageAt: lastMessageAt == null && nullToAbsent
          ? const Value.absent()
          : Value(lastMessageAt),
      unreadCount: Value(unreadCount),
      photoPath: photoPath == null && nullToAbsent
          ? const Value.absent()
          : Value(photoPath),
      updatedAt: Value(updatedAt),
    );
  }

  factory TelegramChatRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TelegramChatRow(
      id: serializer.fromJson<String>(json['id']),
      accountId: serializer.fromJson<String>(json['accountId']),
      telegramChatId: serializer.fromJson<String>(json['telegramChatId']),
      title: serializer.fromJson<String>(json['title']),
      chatType: serializer.fromJson<String>(json['chatType']),
      username: serializer.fromJson<String?>(json['username']),
      isAllowed: serializer.fromJson<bool>(json['isAllowed']),
      lastMessageAt: serializer.fromJson<DateTime?>(json['lastMessageAt']),
      unreadCount: serializer.fromJson<int>(json['unreadCount']),
      photoPath: serializer.fromJson<String?>(json['photoPath']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'accountId': serializer.toJson<String>(accountId),
      'telegramChatId': serializer.toJson<String>(telegramChatId),
      'title': serializer.toJson<String>(title),
      'chatType': serializer.toJson<String>(chatType),
      'username': serializer.toJson<String?>(username),
      'isAllowed': serializer.toJson<bool>(isAllowed),
      'lastMessageAt': serializer.toJson<DateTime?>(lastMessageAt),
      'unreadCount': serializer.toJson<int>(unreadCount),
      'photoPath': serializer.toJson<String?>(photoPath),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  TelegramChatRow copyWith({
    String? id,
    String? accountId,
    String? telegramChatId,
    String? title,
    String? chatType,
    Value<String?> username = const Value.absent(),
    bool? isAllowed,
    Value<DateTime?> lastMessageAt = const Value.absent(),
    int? unreadCount,
    Value<String?> photoPath = const Value.absent(),
    DateTime? updatedAt,
  }) => TelegramChatRow(
    id: id ?? this.id,
    accountId: accountId ?? this.accountId,
    telegramChatId: telegramChatId ?? this.telegramChatId,
    title: title ?? this.title,
    chatType: chatType ?? this.chatType,
    username: username.present ? username.value : this.username,
    isAllowed: isAllowed ?? this.isAllowed,
    lastMessageAt: lastMessageAt.present
        ? lastMessageAt.value
        : this.lastMessageAt,
    unreadCount: unreadCount ?? this.unreadCount,
    photoPath: photoPath.present ? photoPath.value : this.photoPath,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  TelegramChatRow copyWithCompanion(TelegramChatsCompanion data) {
    return TelegramChatRow(
      id: data.id.present ? data.id.value : this.id,
      accountId: data.accountId.present ? data.accountId.value : this.accountId,
      telegramChatId: data.telegramChatId.present
          ? data.telegramChatId.value
          : this.telegramChatId,
      title: data.title.present ? data.title.value : this.title,
      chatType: data.chatType.present ? data.chatType.value : this.chatType,
      username: data.username.present ? data.username.value : this.username,
      isAllowed: data.isAllowed.present ? data.isAllowed.value : this.isAllowed,
      lastMessageAt: data.lastMessageAt.present
          ? data.lastMessageAt.value
          : this.lastMessageAt,
      unreadCount: data.unreadCount.present
          ? data.unreadCount.value
          : this.unreadCount,
      photoPath: data.photoPath.present ? data.photoPath.value : this.photoPath,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('TelegramChatRow(')
          ..write('id: $id, ')
          ..write('accountId: $accountId, ')
          ..write('telegramChatId: $telegramChatId, ')
          ..write('title: $title, ')
          ..write('chatType: $chatType, ')
          ..write('username: $username, ')
          ..write('isAllowed: $isAllowed, ')
          ..write('lastMessageAt: $lastMessageAt, ')
          ..write('unreadCount: $unreadCount, ')
          ..write('photoPath: $photoPath, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    accountId,
    telegramChatId,
    title,
    chatType,
    username,
    isAllowed,
    lastMessageAt,
    unreadCount,
    photoPath,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TelegramChatRow &&
          other.id == this.id &&
          other.accountId == this.accountId &&
          other.telegramChatId == this.telegramChatId &&
          other.title == this.title &&
          other.chatType == this.chatType &&
          other.username == this.username &&
          other.isAllowed == this.isAllowed &&
          other.lastMessageAt == this.lastMessageAt &&
          other.unreadCount == this.unreadCount &&
          other.photoPath == this.photoPath &&
          other.updatedAt == this.updatedAt);
}

class TelegramChatsCompanion extends UpdateCompanion<TelegramChatRow> {
  final Value<String> id;
  final Value<String> accountId;
  final Value<String> telegramChatId;
  final Value<String> title;
  final Value<String> chatType;
  final Value<String?> username;
  final Value<bool> isAllowed;
  final Value<DateTime?> lastMessageAt;
  final Value<int> unreadCount;
  final Value<String?> photoPath;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const TelegramChatsCompanion({
    this.id = const Value.absent(),
    this.accountId = const Value.absent(),
    this.telegramChatId = const Value.absent(),
    this.title = const Value.absent(),
    this.chatType = const Value.absent(),
    this.username = const Value.absent(),
    this.isAllowed = const Value.absent(),
    this.lastMessageAt = const Value.absent(),
    this.unreadCount = const Value.absent(),
    this.photoPath = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  TelegramChatsCompanion.insert({
    required String id,
    required String accountId,
    required String telegramChatId,
    required String title,
    required String chatType,
    this.username = const Value.absent(),
    this.isAllowed = const Value.absent(),
    this.lastMessageAt = const Value.absent(),
    this.unreadCount = const Value.absent(),
    this.photoPath = const Value.absent(),
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       accountId = Value(accountId),
       telegramChatId = Value(telegramChatId),
       title = Value(title),
       chatType = Value(chatType),
       updatedAt = Value(updatedAt);
  static Insertable<TelegramChatRow> custom({
    Expression<String>? id,
    Expression<String>? accountId,
    Expression<String>? telegramChatId,
    Expression<String>? title,
    Expression<String>? chatType,
    Expression<String>? username,
    Expression<bool>? isAllowed,
    Expression<DateTime>? lastMessageAt,
    Expression<int>? unreadCount,
    Expression<String>? photoPath,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (accountId != null) 'account_id': accountId,
      if (telegramChatId != null) 'telegram_chat_id': telegramChatId,
      if (title != null) 'title': title,
      if (chatType != null) 'chat_type': chatType,
      if (username != null) 'username': username,
      if (isAllowed != null) 'is_allowed': isAllowed,
      if (lastMessageAt != null) 'last_message_at': lastMessageAt,
      if (unreadCount != null) 'unread_count': unreadCount,
      if (photoPath != null) 'photo_path': photoPath,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  TelegramChatsCompanion copyWith({
    Value<String>? id,
    Value<String>? accountId,
    Value<String>? telegramChatId,
    Value<String>? title,
    Value<String>? chatType,
    Value<String?>? username,
    Value<bool>? isAllowed,
    Value<DateTime?>? lastMessageAt,
    Value<int>? unreadCount,
    Value<String?>? photoPath,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return TelegramChatsCompanion(
      id: id ?? this.id,
      accountId: accountId ?? this.accountId,
      telegramChatId: telegramChatId ?? this.telegramChatId,
      title: title ?? this.title,
      chatType: chatType ?? this.chatType,
      username: username ?? this.username,
      isAllowed: isAllowed ?? this.isAllowed,
      lastMessageAt: lastMessageAt ?? this.lastMessageAt,
      unreadCount: unreadCount ?? this.unreadCount,
      photoPath: photoPath ?? this.photoPath,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (accountId.present) {
      map['account_id'] = Variable<String>(accountId.value);
    }
    if (telegramChatId.present) {
      map['telegram_chat_id'] = Variable<String>(telegramChatId.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (chatType.present) {
      map['chat_type'] = Variable<String>(chatType.value);
    }
    if (username.present) {
      map['username'] = Variable<String>(username.value);
    }
    if (isAllowed.present) {
      map['is_allowed'] = Variable<bool>(isAllowed.value);
    }
    if (lastMessageAt.present) {
      map['last_message_at'] = Variable<DateTime>(lastMessageAt.value);
    }
    if (unreadCount.present) {
      map['unread_count'] = Variable<int>(unreadCount.value);
    }
    if (photoPath.present) {
      map['photo_path'] = Variable<String>(photoPath.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TelegramChatsCompanion(')
          ..write('id: $id, ')
          ..write('accountId: $accountId, ')
          ..write('telegramChatId: $telegramChatId, ')
          ..write('title: $title, ')
          ..write('chatType: $chatType, ')
          ..write('username: $username, ')
          ..write('isAllowed: $isAllowed, ')
          ..write('lastMessageAt: $lastMessageAt, ')
          ..write('unreadCount: $unreadCount, ')
          ..write('photoPath: $photoPath, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $TelegramMessagesTable extends TelegramMessages
    with TableInfo<$TelegramMessagesTable, TelegramMessageRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $TelegramMessagesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _accountIdMeta = const VerificationMeta(
    'accountId',
  );
  @override
  late final GeneratedColumn<String> accountId = GeneratedColumn<String>(
    'account_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES telegram_accounts (id)',
    ),
  );
  static const VerificationMeta _telegramChatIdMeta = const VerificationMeta(
    'telegramChatId',
  );
  @override
  late final GeneratedColumn<String> telegramChatId = GeneratedColumn<String>(
    'telegram_chat_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _telegramMessageIdMeta = const VerificationMeta(
    'telegramMessageId',
  );
  @override
  late final GeneratedColumn<String> telegramMessageId =
      GeneratedColumn<String>(
        'telegram_message_id',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
      );
  static const VerificationMeta _senderNameMeta = const VerificationMeta(
    'senderName',
  );
  @override
  late final GeneratedColumn<String> senderName = GeneratedColumn<String>(
    'sender_name',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _bodyMeta = const VerificationMeta('body');
  @override
  late final GeneratedColumn<String> body = GeneratedColumn<String>(
    'body',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _contentTypeMeta = const VerificationMeta(
    'contentType',
  );
  @override
  late final GeneratedColumn<String> contentType = GeneratedColumn<String>(
    'content_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('text'),
  );
  static const VerificationMeta _mediaPathMeta = const VerificationMeta(
    'mediaPath',
  );
  @override
  late final GeneratedColumn<String> mediaPath = GeneratedColumn<String>(
    'media_path',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _mediaFileIdMeta = const VerificationMeta(
    'mediaFileId',
  );
  @override
  late final GeneratedColumn<int> mediaFileId = GeneratedColumn<int>(
    'media_file_id',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _replyToMessageIdMeta = const VerificationMeta(
    'replyToMessageId',
  );
  @override
  late final GeneratedColumn<String> replyToMessageId = GeneratedColumn<String>(
    'reply_to_message_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _replyPreviewMeta = const VerificationMeta(
    'replyPreview',
  );
  @override
  late final GeneratedColumn<String> replyPreview = GeneratedColumn<String>(
    'reply_preview',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _sentAtMeta = const VerificationMeta('sentAt');
  @override
  late final GeneratedColumn<DateTime> sentAt = GeneratedColumn<DateTime>(
    'sent_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _isOutgoingMeta = const VerificationMeta(
    'isOutgoing',
  );
  @override
  late final GeneratedColumn<bool> isOutgoing = GeneratedColumn<bool>(
    'is_outgoing',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_outgoing" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _isEditedMeta = const VerificationMeta(
    'isEdited',
  );
  @override
  late final GeneratedColumn<bool> isEdited = GeneratedColumn<bool>(
    'is_edited',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_edited" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    accountId,
    telegramChatId,
    telegramMessageId,
    senderName,
    body,
    contentType,
    mediaPath,
    mediaFileId,
    replyToMessageId,
    replyPreview,
    sentAt,
    isOutgoing,
    isEdited,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'telegram_messages';
  @override
  VerificationContext validateIntegrity(
    Insertable<TelegramMessageRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('account_id')) {
      context.handle(
        _accountIdMeta,
        accountId.isAcceptableOrUnknown(data['account_id']!, _accountIdMeta),
      );
    } else if (isInserting) {
      context.missing(_accountIdMeta);
    }
    if (data.containsKey('telegram_chat_id')) {
      context.handle(
        _telegramChatIdMeta,
        telegramChatId.isAcceptableOrUnknown(
          data['telegram_chat_id']!,
          _telegramChatIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_telegramChatIdMeta);
    }
    if (data.containsKey('telegram_message_id')) {
      context.handle(
        _telegramMessageIdMeta,
        telegramMessageId.isAcceptableOrUnknown(
          data['telegram_message_id']!,
          _telegramMessageIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_telegramMessageIdMeta);
    }
    if (data.containsKey('sender_name')) {
      context.handle(
        _senderNameMeta,
        senderName.isAcceptableOrUnknown(data['sender_name']!, _senderNameMeta),
      );
    }
    if (data.containsKey('body')) {
      context.handle(
        _bodyMeta,
        body.isAcceptableOrUnknown(data['body']!, _bodyMeta),
      );
    } else if (isInserting) {
      context.missing(_bodyMeta);
    }
    if (data.containsKey('content_type')) {
      context.handle(
        _contentTypeMeta,
        contentType.isAcceptableOrUnknown(
          data['content_type']!,
          _contentTypeMeta,
        ),
      );
    }
    if (data.containsKey('media_path')) {
      context.handle(
        _mediaPathMeta,
        mediaPath.isAcceptableOrUnknown(data['media_path']!, _mediaPathMeta),
      );
    }
    if (data.containsKey('media_file_id')) {
      context.handle(
        _mediaFileIdMeta,
        mediaFileId.isAcceptableOrUnknown(
          data['media_file_id']!,
          _mediaFileIdMeta,
        ),
      );
    }
    if (data.containsKey('reply_to_message_id')) {
      context.handle(
        _replyToMessageIdMeta,
        replyToMessageId.isAcceptableOrUnknown(
          data['reply_to_message_id']!,
          _replyToMessageIdMeta,
        ),
      );
    }
    if (data.containsKey('reply_preview')) {
      context.handle(
        _replyPreviewMeta,
        replyPreview.isAcceptableOrUnknown(
          data['reply_preview']!,
          _replyPreviewMeta,
        ),
      );
    }
    if (data.containsKey('sent_at')) {
      context.handle(
        _sentAtMeta,
        sentAt.isAcceptableOrUnknown(data['sent_at']!, _sentAtMeta),
      );
    } else if (isInserting) {
      context.missing(_sentAtMeta);
    }
    if (data.containsKey('is_outgoing')) {
      context.handle(
        _isOutgoingMeta,
        isOutgoing.isAcceptableOrUnknown(data['is_outgoing']!, _isOutgoingMeta),
      );
    }
    if (data.containsKey('is_edited')) {
      context.handle(
        _isEditedMeta,
        isEdited.isAcceptableOrUnknown(data['is_edited']!, _isEditedMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  TelegramMessageRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return TelegramMessageRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      accountId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}account_id'],
      )!,
      telegramChatId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}telegram_chat_id'],
      )!,
      telegramMessageId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}telegram_message_id'],
      )!,
      senderName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}sender_name'],
      ),
      body: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}body'],
      )!,
      contentType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}content_type'],
      )!,
      mediaPath: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}media_path'],
      ),
      mediaFileId: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}media_file_id'],
      ),
      replyToMessageId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}reply_to_message_id'],
      ),
      replyPreview: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}reply_preview'],
      ),
      sentAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}sent_at'],
      )!,
      isOutgoing: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_outgoing'],
      )!,
      isEdited: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_edited'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $TelegramMessagesTable createAlias(String alias) {
    return $TelegramMessagesTable(attachedDatabase, alias);
  }
}

class TelegramMessageRow extends DataClass
    implements Insertable<TelegramMessageRow> {
  final String id;
  final String accountId;
  final String telegramChatId;
  final String telegramMessageId;
  final String? senderName;
  final String body;

  /// text | photo | document | voice | video | sticker | other
  final String contentType;

  /// Local path for downloaded photo / document preview / voice file.
  final String? mediaPath;
  final int? mediaFileId;

  /// Telegram message id this message replies to (if any).
  final String? replyToMessageId;
  final String? replyPreview;
  final DateTime sentAt;
  final bool isOutgoing;
  final bool isEdited;
  final DateTime updatedAt;
  const TelegramMessageRow({
    required this.id,
    required this.accountId,
    required this.telegramChatId,
    required this.telegramMessageId,
    this.senderName,
    required this.body,
    required this.contentType,
    this.mediaPath,
    this.mediaFileId,
    this.replyToMessageId,
    this.replyPreview,
    required this.sentAt,
    required this.isOutgoing,
    required this.isEdited,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['account_id'] = Variable<String>(accountId);
    map['telegram_chat_id'] = Variable<String>(telegramChatId);
    map['telegram_message_id'] = Variable<String>(telegramMessageId);
    if (!nullToAbsent || senderName != null) {
      map['sender_name'] = Variable<String>(senderName);
    }
    map['body'] = Variable<String>(body);
    map['content_type'] = Variable<String>(contentType);
    if (!nullToAbsent || mediaPath != null) {
      map['media_path'] = Variable<String>(mediaPath);
    }
    if (!nullToAbsent || mediaFileId != null) {
      map['media_file_id'] = Variable<int>(mediaFileId);
    }
    if (!nullToAbsent || replyToMessageId != null) {
      map['reply_to_message_id'] = Variable<String>(replyToMessageId);
    }
    if (!nullToAbsent || replyPreview != null) {
      map['reply_preview'] = Variable<String>(replyPreview);
    }
    map['sent_at'] = Variable<DateTime>(sentAt);
    map['is_outgoing'] = Variable<bool>(isOutgoing);
    map['is_edited'] = Variable<bool>(isEdited);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  TelegramMessagesCompanion toCompanion(bool nullToAbsent) {
    return TelegramMessagesCompanion(
      id: Value(id),
      accountId: Value(accountId),
      telegramChatId: Value(telegramChatId),
      telegramMessageId: Value(telegramMessageId),
      senderName: senderName == null && nullToAbsent
          ? const Value.absent()
          : Value(senderName),
      body: Value(body),
      contentType: Value(contentType),
      mediaPath: mediaPath == null && nullToAbsent
          ? const Value.absent()
          : Value(mediaPath),
      mediaFileId: mediaFileId == null && nullToAbsent
          ? const Value.absent()
          : Value(mediaFileId),
      replyToMessageId: replyToMessageId == null && nullToAbsent
          ? const Value.absent()
          : Value(replyToMessageId),
      replyPreview: replyPreview == null && nullToAbsent
          ? const Value.absent()
          : Value(replyPreview),
      sentAt: Value(sentAt),
      isOutgoing: Value(isOutgoing),
      isEdited: Value(isEdited),
      updatedAt: Value(updatedAt),
    );
  }

  factory TelegramMessageRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return TelegramMessageRow(
      id: serializer.fromJson<String>(json['id']),
      accountId: serializer.fromJson<String>(json['accountId']),
      telegramChatId: serializer.fromJson<String>(json['telegramChatId']),
      telegramMessageId: serializer.fromJson<String>(json['telegramMessageId']),
      senderName: serializer.fromJson<String?>(json['senderName']),
      body: serializer.fromJson<String>(json['body']),
      contentType: serializer.fromJson<String>(json['contentType']),
      mediaPath: serializer.fromJson<String?>(json['mediaPath']),
      mediaFileId: serializer.fromJson<int?>(json['mediaFileId']),
      replyToMessageId: serializer.fromJson<String?>(json['replyToMessageId']),
      replyPreview: serializer.fromJson<String?>(json['replyPreview']),
      sentAt: serializer.fromJson<DateTime>(json['sentAt']),
      isOutgoing: serializer.fromJson<bool>(json['isOutgoing']),
      isEdited: serializer.fromJson<bool>(json['isEdited']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'accountId': serializer.toJson<String>(accountId),
      'telegramChatId': serializer.toJson<String>(telegramChatId),
      'telegramMessageId': serializer.toJson<String>(telegramMessageId),
      'senderName': serializer.toJson<String?>(senderName),
      'body': serializer.toJson<String>(body),
      'contentType': serializer.toJson<String>(contentType),
      'mediaPath': serializer.toJson<String?>(mediaPath),
      'mediaFileId': serializer.toJson<int?>(mediaFileId),
      'replyToMessageId': serializer.toJson<String?>(replyToMessageId),
      'replyPreview': serializer.toJson<String?>(replyPreview),
      'sentAt': serializer.toJson<DateTime>(sentAt),
      'isOutgoing': serializer.toJson<bool>(isOutgoing),
      'isEdited': serializer.toJson<bool>(isEdited),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  TelegramMessageRow copyWith({
    String? id,
    String? accountId,
    String? telegramChatId,
    String? telegramMessageId,
    Value<String?> senderName = const Value.absent(),
    String? body,
    String? contentType,
    Value<String?> mediaPath = const Value.absent(),
    Value<int?> mediaFileId = const Value.absent(),
    Value<String?> replyToMessageId = const Value.absent(),
    Value<String?> replyPreview = const Value.absent(),
    DateTime? sentAt,
    bool? isOutgoing,
    bool? isEdited,
    DateTime? updatedAt,
  }) => TelegramMessageRow(
    id: id ?? this.id,
    accountId: accountId ?? this.accountId,
    telegramChatId: telegramChatId ?? this.telegramChatId,
    telegramMessageId: telegramMessageId ?? this.telegramMessageId,
    senderName: senderName.present ? senderName.value : this.senderName,
    body: body ?? this.body,
    contentType: contentType ?? this.contentType,
    mediaPath: mediaPath.present ? mediaPath.value : this.mediaPath,
    mediaFileId: mediaFileId.present ? mediaFileId.value : this.mediaFileId,
    replyToMessageId: replyToMessageId.present
        ? replyToMessageId.value
        : this.replyToMessageId,
    replyPreview: replyPreview.present ? replyPreview.value : this.replyPreview,
    sentAt: sentAt ?? this.sentAt,
    isOutgoing: isOutgoing ?? this.isOutgoing,
    isEdited: isEdited ?? this.isEdited,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  TelegramMessageRow copyWithCompanion(TelegramMessagesCompanion data) {
    return TelegramMessageRow(
      id: data.id.present ? data.id.value : this.id,
      accountId: data.accountId.present ? data.accountId.value : this.accountId,
      telegramChatId: data.telegramChatId.present
          ? data.telegramChatId.value
          : this.telegramChatId,
      telegramMessageId: data.telegramMessageId.present
          ? data.telegramMessageId.value
          : this.telegramMessageId,
      senderName: data.senderName.present
          ? data.senderName.value
          : this.senderName,
      body: data.body.present ? data.body.value : this.body,
      contentType: data.contentType.present
          ? data.contentType.value
          : this.contentType,
      mediaPath: data.mediaPath.present ? data.mediaPath.value : this.mediaPath,
      mediaFileId: data.mediaFileId.present
          ? data.mediaFileId.value
          : this.mediaFileId,
      replyToMessageId: data.replyToMessageId.present
          ? data.replyToMessageId.value
          : this.replyToMessageId,
      replyPreview: data.replyPreview.present
          ? data.replyPreview.value
          : this.replyPreview,
      sentAt: data.sentAt.present ? data.sentAt.value : this.sentAt,
      isOutgoing: data.isOutgoing.present
          ? data.isOutgoing.value
          : this.isOutgoing,
      isEdited: data.isEdited.present ? data.isEdited.value : this.isEdited,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('TelegramMessageRow(')
          ..write('id: $id, ')
          ..write('accountId: $accountId, ')
          ..write('telegramChatId: $telegramChatId, ')
          ..write('telegramMessageId: $telegramMessageId, ')
          ..write('senderName: $senderName, ')
          ..write('body: $body, ')
          ..write('contentType: $contentType, ')
          ..write('mediaPath: $mediaPath, ')
          ..write('mediaFileId: $mediaFileId, ')
          ..write('replyToMessageId: $replyToMessageId, ')
          ..write('replyPreview: $replyPreview, ')
          ..write('sentAt: $sentAt, ')
          ..write('isOutgoing: $isOutgoing, ')
          ..write('isEdited: $isEdited, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    accountId,
    telegramChatId,
    telegramMessageId,
    senderName,
    body,
    contentType,
    mediaPath,
    mediaFileId,
    replyToMessageId,
    replyPreview,
    sentAt,
    isOutgoing,
    isEdited,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is TelegramMessageRow &&
          other.id == this.id &&
          other.accountId == this.accountId &&
          other.telegramChatId == this.telegramChatId &&
          other.telegramMessageId == this.telegramMessageId &&
          other.senderName == this.senderName &&
          other.body == this.body &&
          other.contentType == this.contentType &&
          other.mediaPath == this.mediaPath &&
          other.mediaFileId == this.mediaFileId &&
          other.replyToMessageId == this.replyToMessageId &&
          other.replyPreview == this.replyPreview &&
          other.sentAt == this.sentAt &&
          other.isOutgoing == this.isOutgoing &&
          other.isEdited == this.isEdited &&
          other.updatedAt == this.updatedAt);
}

class TelegramMessagesCompanion extends UpdateCompanion<TelegramMessageRow> {
  final Value<String> id;
  final Value<String> accountId;
  final Value<String> telegramChatId;
  final Value<String> telegramMessageId;
  final Value<String?> senderName;
  final Value<String> body;
  final Value<String> contentType;
  final Value<String?> mediaPath;
  final Value<int?> mediaFileId;
  final Value<String?> replyToMessageId;
  final Value<String?> replyPreview;
  final Value<DateTime> sentAt;
  final Value<bool> isOutgoing;
  final Value<bool> isEdited;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const TelegramMessagesCompanion({
    this.id = const Value.absent(),
    this.accountId = const Value.absent(),
    this.telegramChatId = const Value.absent(),
    this.telegramMessageId = const Value.absent(),
    this.senderName = const Value.absent(),
    this.body = const Value.absent(),
    this.contentType = const Value.absent(),
    this.mediaPath = const Value.absent(),
    this.mediaFileId = const Value.absent(),
    this.replyToMessageId = const Value.absent(),
    this.replyPreview = const Value.absent(),
    this.sentAt = const Value.absent(),
    this.isOutgoing = const Value.absent(),
    this.isEdited = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  TelegramMessagesCompanion.insert({
    required String id,
    required String accountId,
    required String telegramChatId,
    required String telegramMessageId,
    this.senderName = const Value.absent(),
    required String body,
    this.contentType = const Value.absent(),
    this.mediaPath = const Value.absent(),
    this.mediaFileId = const Value.absent(),
    this.replyToMessageId = const Value.absent(),
    this.replyPreview = const Value.absent(),
    required DateTime sentAt,
    this.isOutgoing = const Value.absent(),
    this.isEdited = const Value.absent(),
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       accountId = Value(accountId),
       telegramChatId = Value(telegramChatId),
       telegramMessageId = Value(telegramMessageId),
       body = Value(body),
       sentAt = Value(sentAt),
       updatedAt = Value(updatedAt);
  static Insertable<TelegramMessageRow> custom({
    Expression<String>? id,
    Expression<String>? accountId,
    Expression<String>? telegramChatId,
    Expression<String>? telegramMessageId,
    Expression<String>? senderName,
    Expression<String>? body,
    Expression<String>? contentType,
    Expression<String>? mediaPath,
    Expression<int>? mediaFileId,
    Expression<String>? replyToMessageId,
    Expression<String>? replyPreview,
    Expression<DateTime>? sentAt,
    Expression<bool>? isOutgoing,
    Expression<bool>? isEdited,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (accountId != null) 'account_id': accountId,
      if (telegramChatId != null) 'telegram_chat_id': telegramChatId,
      if (telegramMessageId != null) 'telegram_message_id': telegramMessageId,
      if (senderName != null) 'sender_name': senderName,
      if (body != null) 'body': body,
      if (contentType != null) 'content_type': contentType,
      if (mediaPath != null) 'media_path': mediaPath,
      if (mediaFileId != null) 'media_file_id': mediaFileId,
      if (replyToMessageId != null) 'reply_to_message_id': replyToMessageId,
      if (replyPreview != null) 'reply_preview': replyPreview,
      if (sentAt != null) 'sent_at': sentAt,
      if (isOutgoing != null) 'is_outgoing': isOutgoing,
      if (isEdited != null) 'is_edited': isEdited,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  TelegramMessagesCompanion copyWith({
    Value<String>? id,
    Value<String>? accountId,
    Value<String>? telegramChatId,
    Value<String>? telegramMessageId,
    Value<String?>? senderName,
    Value<String>? body,
    Value<String>? contentType,
    Value<String?>? mediaPath,
    Value<int?>? mediaFileId,
    Value<String?>? replyToMessageId,
    Value<String?>? replyPreview,
    Value<DateTime>? sentAt,
    Value<bool>? isOutgoing,
    Value<bool>? isEdited,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return TelegramMessagesCompanion(
      id: id ?? this.id,
      accountId: accountId ?? this.accountId,
      telegramChatId: telegramChatId ?? this.telegramChatId,
      telegramMessageId: telegramMessageId ?? this.telegramMessageId,
      senderName: senderName ?? this.senderName,
      body: body ?? this.body,
      contentType: contentType ?? this.contentType,
      mediaPath: mediaPath ?? this.mediaPath,
      mediaFileId: mediaFileId ?? this.mediaFileId,
      replyToMessageId: replyToMessageId ?? this.replyToMessageId,
      replyPreview: replyPreview ?? this.replyPreview,
      sentAt: sentAt ?? this.sentAt,
      isOutgoing: isOutgoing ?? this.isOutgoing,
      isEdited: isEdited ?? this.isEdited,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (accountId.present) {
      map['account_id'] = Variable<String>(accountId.value);
    }
    if (telegramChatId.present) {
      map['telegram_chat_id'] = Variable<String>(telegramChatId.value);
    }
    if (telegramMessageId.present) {
      map['telegram_message_id'] = Variable<String>(telegramMessageId.value);
    }
    if (senderName.present) {
      map['sender_name'] = Variable<String>(senderName.value);
    }
    if (body.present) {
      map['body'] = Variable<String>(body.value);
    }
    if (contentType.present) {
      map['content_type'] = Variable<String>(contentType.value);
    }
    if (mediaPath.present) {
      map['media_path'] = Variable<String>(mediaPath.value);
    }
    if (mediaFileId.present) {
      map['media_file_id'] = Variable<int>(mediaFileId.value);
    }
    if (replyToMessageId.present) {
      map['reply_to_message_id'] = Variable<String>(replyToMessageId.value);
    }
    if (replyPreview.present) {
      map['reply_preview'] = Variable<String>(replyPreview.value);
    }
    if (sentAt.present) {
      map['sent_at'] = Variable<DateTime>(sentAt.value);
    }
    if (isOutgoing.present) {
      map['is_outgoing'] = Variable<bool>(isOutgoing.value);
    }
    if (isEdited.present) {
      map['is_edited'] = Variable<bool>(isEdited.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('TelegramMessagesCompanion(')
          ..write('id: $id, ')
          ..write('accountId: $accountId, ')
          ..write('telegramChatId: $telegramChatId, ')
          ..write('telegramMessageId: $telegramMessageId, ')
          ..write('senderName: $senderName, ')
          ..write('body: $body, ')
          ..write('contentType: $contentType, ')
          ..write('mediaPath: $mediaPath, ')
          ..write('mediaFileId: $mediaFileId, ')
          ..write('replyToMessageId: $replyToMessageId, ')
          ..write('replyPreview: $replyPreview, ')
          ..write('sentAt: $sentAt, ')
          ..write('isOutgoing: $isOutgoing, ')
          ..write('isEdited: $isEdited, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $GmailAccountsTable extends GmailAccounts
    with TableInfo<$GmailAccountsTable, GmailAccountRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $GmailAccountsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _emailMeta = const VerificationMeta('email');
  @override
  late final GeneratedColumn<String> email = GeneratedColumn<String>(
    'email',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _connectedAtMeta = const VerificationMeta(
    'connectedAt',
  );
  @override
  late final GeneratedColumn<DateTime> connectedAt = GeneratedColumn<DateTime>(
    'connected_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _lastSyncAtMeta = const VerificationMeta(
    'lastSyncAt',
  );
  @override
  late final GeneratedColumn<DateTime> lastSyncAt = GeneratedColumn<DateTime>(
    'last_sync_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [id, email, connectedAt, lastSyncAt];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'gmail_accounts';
  @override
  VerificationContext validateIntegrity(
    Insertable<GmailAccountRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('email')) {
      context.handle(
        _emailMeta,
        email.isAcceptableOrUnknown(data['email']!, _emailMeta),
      );
    } else if (isInserting) {
      context.missing(_emailMeta);
    }
    if (data.containsKey('connected_at')) {
      context.handle(
        _connectedAtMeta,
        connectedAt.isAcceptableOrUnknown(
          data['connected_at']!,
          _connectedAtMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_connectedAtMeta);
    }
    if (data.containsKey('last_sync_at')) {
      context.handle(
        _lastSyncAtMeta,
        lastSyncAt.isAcceptableOrUnknown(
          data['last_sync_at']!,
          _lastSyncAtMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  GmailAccountRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return GmailAccountRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      email: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}email'],
      )!,
      connectedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}connected_at'],
      )!,
      lastSyncAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}last_sync_at'],
      ),
    );
  }

  @override
  $GmailAccountsTable createAlias(String alias) {
    return $GmailAccountsTable(attachedDatabase, alias);
  }
}

class GmailAccountRow extends DataClass implements Insertable<GmailAccountRow> {
  final String id;
  final String email;
  final DateTime connectedAt;
  final DateTime? lastSyncAt;
  const GmailAccountRow({
    required this.id,
    required this.email,
    required this.connectedAt,
    this.lastSyncAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['email'] = Variable<String>(email);
    map['connected_at'] = Variable<DateTime>(connectedAt);
    if (!nullToAbsent || lastSyncAt != null) {
      map['last_sync_at'] = Variable<DateTime>(lastSyncAt);
    }
    return map;
  }

  GmailAccountsCompanion toCompanion(bool nullToAbsent) {
    return GmailAccountsCompanion(
      id: Value(id),
      email: Value(email),
      connectedAt: Value(connectedAt),
      lastSyncAt: lastSyncAt == null && nullToAbsent
          ? const Value.absent()
          : Value(lastSyncAt),
    );
  }

  factory GmailAccountRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return GmailAccountRow(
      id: serializer.fromJson<String>(json['id']),
      email: serializer.fromJson<String>(json['email']),
      connectedAt: serializer.fromJson<DateTime>(json['connectedAt']),
      lastSyncAt: serializer.fromJson<DateTime?>(json['lastSyncAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'email': serializer.toJson<String>(email),
      'connectedAt': serializer.toJson<DateTime>(connectedAt),
      'lastSyncAt': serializer.toJson<DateTime?>(lastSyncAt),
    };
  }

  GmailAccountRow copyWith({
    String? id,
    String? email,
    DateTime? connectedAt,
    Value<DateTime?> lastSyncAt = const Value.absent(),
  }) => GmailAccountRow(
    id: id ?? this.id,
    email: email ?? this.email,
    connectedAt: connectedAt ?? this.connectedAt,
    lastSyncAt: lastSyncAt.present ? lastSyncAt.value : this.lastSyncAt,
  );
  GmailAccountRow copyWithCompanion(GmailAccountsCompanion data) {
    return GmailAccountRow(
      id: data.id.present ? data.id.value : this.id,
      email: data.email.present ? data.email.value : this.email,
      connectedAt: data.connectedAt.present
          ? data.connectedAt.value
          : this.connectedAt,
      lastSyncAt: data.lastSyncAt.present
          ? data.lastSyncAt.value
          : this.lastSyncAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('GmailAccountRow(')
          ..write('id: $id, ')
          ..write('email: $email, ')
          ..write('connectedAt: $connectedAt, ')
          ..write('lastSyncAt: $lastSyncAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, email, connectedAt, lastSyncAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is GmailAccountRow &&
          other.id == this.id &&
          other.email == this.email &&
          other.connectedAt == this.connectedAt &&
          other.lastSyncAt == this.lastSyncAt);
}

class GmailAccountsCompanion extends UpdateCompanion<GmailAccountRow> {
  final Value<String> id;
  final Value<String> email;
  final Value<DateTime> connectedAt;
  final Value<DateTime?> lastSyncAt;
  final Value<int> rowid;
  const GmailAccountsCompanion({
    this.id = const Value.absent(),
    this.email = const Value.absent(),
    this.connectedAt = const Value.absent(),
    this.lastSyncAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  GmailAccountsCompanion.insert({
    required String id,
    required String email,
    required DateTime connectedAt,
    this.lastSyncAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       email = Value(email),
       connectedAt = Value(connectedAt);
  static Insertable<GmailAccountRow> custom({
    Expression<String>? id,
    Expression<String>? email,
    Expression<DateTime>? connectedAt,
    Expression<DateTime>? lastSyncAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (email != null) 'email': email,
      if (connectedAt != null) 'connected_at': connectedAt,
      if (lastSyncAt != null) 'last_sync_at': lastSyncAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  GmailAccountsCompanion copyWith({
    Value<String>? id,
    Value<String>? email,
    Value<DateTime>? connectedAt,
    Value<DateTime?>? lastSyncAt,
    Value<int>? rowid,
  }) {
    return GmailAccountsCompanion(
      id: id ?? this.id,
      email: email ?? this.email,
      connectedAt: connectedAt ?? this.connectedAt,
      lastSyncAt: lastSyncAt ?? this.lastSyncAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (email.present) {
      map['email'] = Variable<String>(email.value);
    }
    if (connectedAt.present) {
      map['connected_at'] = Variable<DateTime>(connectedAt.value);
    }
    if (lastSyncAt.present) {
      map['last_sync_at'] = Variable<DateTime>(lastSyncAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('GmailAccountsCompanion(')
          ..write('id: $id, ')
          ..write('email: $email, ')
          ..write('connectedAt: $connectedAt, ')
          ..write('lastSyncAt: $lastSyncAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $GmailThreadsTable extends GmailThreads
    with TableInfo<$GmailThreadsTable, GmailThreadRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $GmailThreadsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _accountIdMeta = const VerificationMeta(
    'accountId',
  );
  @override
  late final GeneratedColumn<String> accountId = GeneratedColumn<String>(
    'account_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES gmail_accounts (id)',
    ),
  );
  static const VerificationMeta _gmailThreadIdMeta = const VerificationMeta(
    'gmailThreadId',
  );
  @override
  late final GeneratedColumn<String> gmailThreadId = GeneratedColumn<String>(
    'gmail_thread_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _subjectMeta = const VerificationMeta(
    'subject',
  );
  @override
  late final GeneratedColumn<String> subject = GeneratedColumn<String>(
    'subject',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _snippetMeta = const VerificationMeta(
    'snippet',
  );
  @override
  late final GeneratedColumn<String> snippet = GeneratedColumn<String>(
    'snippet',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _fromNameMeta = const VerificationMeta(
    'fromName',
  );
  @override
  late final GeneratedColumn<String> fromName = GeneratedColumn<String>(
    'from_name',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _fromEmailMeta = const VerificationMeta(
    'fromEmail',
  );
  @override
  late final GeneratedColumn<String> fromEmail = GeneratedColumn<String>(
    'from_email',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<DateTime> date = GeneratedColumn<DateTime>(
    'date',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _isUnreadMeta = const VerificationMeta(
    'isUnread',
  );
  @override
  late final GeneratedColumn<bool> isUnread = GeneratedColumn<bool>(
    'is_unread',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_unread" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    accountId,
    gmailThreadId,
    subject,
    snippet,
    fromName,
    fromEmail,
    date,
    isUnread,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'gmail_threads';
  @override
  VerificationContext validateIntegrity(
    Insertable<GmailThreadRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('account_id')) {
      context.handle(
        _accountIdMeta,
        accountId.isAcceptableOrUnknown(data['account_id']!, _accountIdMeta),
      );
    } else if (isInserting) {
      context.missing(_accountIdMeta);
    }
    if (data.containsKey('gmail_thread_id')) {
      context.handle(
        _gmailThreadIdMeta,
        gmailThreadId.isAcceptableOrUnknown(
          data['gmail_thread_id']!,
          _gmailThreadIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_gmailThreadIdMeta);
    }
    if (data.containsKey('subject')) {
      context.handle(
        _subjectMeta,
        subject.isAcceptableOrUnknown(data['subject']!, _subjectMeta),
      );
    } else if (isInserting) {
      context.missing(_subjectMeta);
    }
    if (data.containsKey('snippet')) {
      context.handle(
        _snippetMeta,
        snippet.isAcceptableOrUnknown(data['snippet']!, _snippetMeta),
      );
    } else if (isInserting) {
      context.missing(_snippetMeta);
    }
    if (data.containsKey('from_name')) {
      context.handle(
        _fromNameMeta,
        fromName.isAcceptableOrUnknown(data['from_name']!, _fromNameMeta),
      );
    }
    if (data.containsKey('from_email')) {
      context.handle(
        _fromEmailMeta,
        fromEmail.isAcceptableOrUnknown(data['from_email']!, _fromEmailMeta),
      );
    }
    if (data.containsKey('date')) {
      context.handle(
        _dateMeta,
        date.isAcceptableOrUnknown(data['date']!, _dateMeta),
      );
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    if (data.containsKey('is_unread')) {
      context.handle(
        _isUnreadMeta,
        isUnread.isAcceptableOrUnknown(data['is_unread']!, _isUnreadMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  GmailThreadRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return GmailThreadRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      accountId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}account_id'],
      )!,
      gmailThreadId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}gmail_thread_id'],
      )!,
      subject: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}subject'],
      )!,
      snippet: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}snippet'],
      )!,
      fromName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}from_name'],
      ),
      fromEmail: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}from_email'],
      ),
      date: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}date'],
      )!,
      isUnread: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_unread'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $GmailThreadsTable createAlias(String alias) {
    return $GmailThreadsTable(attachedDatabase, alias);
  }
}

class GmailThreadRow extends DataClass implements Insertable<GmailThreadRow> {
  final String id;
  final String accountId;
  final String gmailThreadId;
  final String subject;
  final String snippet;
  final String? fromName;
  final String? fromEmail;
  final DateTime date;
  final bool isUnread;
  final DateTime updatedAt;
  const GmailThreadRow({
    required this.id,
    required this.accountId,
    required this.gmailThreadId,
    required this.subject,
    required this.snippet,
    this.fromName,
    this.fromEmail,
    required this.date,
    required this.isUnread,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['account_id'] = Variable<String>(accountId);
    map['gmail_thread_id'] = Variable<String>(gmailThreadId);
    map['subject'] = Variable<String>(subject);
    map['snippet'] = Variable<String>(snippet);
    if (!nullToAbsent || fromName != null) {
      map['from_name'] = Variable<String>(fromName);
    }
    if (!nullToAbsent || fromEmail != null) {
      map['from_email'] = Variable<String>(fromEmail);
    }
    map['date'] = Variable<DateTime>(date);
    map['is_unread'] = Variable<bool>(isUnread);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  GmailThreadsCompanion toCompanion(bool nullToAbsent) {
    return GmailThreadsCompanion(
      id: Value(id),
      accountId: Value(accountId),
      gmailThreadId: Value(gmailThreadId),
      subject: Value(subject),
      snippet: Value(snippet),
      fromName: fromName == null && nullToAbsent
          ? const Value.absent()
          : Value(fromName),
      fromEmail: fromEmail == null && nullToAbsent
          ? const Value.absent()
          : Value(fromEmail),
      date: Value(date),
      isUnread: Value(isUnread),
      updatedAt: Value(updatedAt),
    );
  }

  factory GmailThreadRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return GmailThreadRow(
      id: serializer.fromJson<String>(json['id']),
      accountId: serializer.fromJson<String>(json['accountId']),
      gmailThreadId: serializer.fromJson<String>(json['gmailThreadId']),
      subject: serializer.fromJson<String>(json['subject']),
      snippet: serializer.fromJson<String>(json['snippet']),
      fromName: serializer.fromJson<String?>(json['fromName']),
      fromEmail: serializer.fromJson<String?>(json['fromEmail']),
      date: serializer.fromJson<DateTime>(json['date']),
      isUnread: serializer.fromJson<bool>(json['isUnread']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'accountId': serializer.toJson<String>(accountId),
      'gmailThreadId': serializer.toJson<String>(gmailThreadId),
      'subject': serializer.toJson<String>(subject),
      'snippet': serializer.toJson<String>(snippet),
      'fromName': serializer.toJson<String?>(fromName),
      'fromEmail': serializer.toJson<String?>(fromEmail),
      'date': serializer.toJson<DateTime>(date),
      'isUnread': serializer.toJson<bool>(isUnread),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  GmailThreadRow copyWith({
    String? id,
    String? accountId,
    String? gmailThreadId,
    String? subject,
    String? snippet,
    Value<String?> fromName = const Value.absent(),
    Value<String?> fromEmail = const Value.absent(),
    DateTime? date,
    bool? isUnread,
    DateTime? updatedAt,
  }) => GmailThreadRow(
    id: id ?? this.id,
    accountId: accountId ?? this.accountId,
    gmailThreadId: gmailThreadId ?? this.gmailThreadId,
    subject: subject ?? this.subject,
    snippet: snippet ?? this.snippet,
    fromName: fromName.present ? fromName.value : this.fromName,
    fromEmail: fromEmail.present ? fromEmail.value : this.fromEmail,
    date: date ?? this.date,
    isUnread: isUnread ?? this.isUnread,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  GmailThreadRow copyWithCompanion(GmailThreadsCompanion data) {
    return GmailThreadRow(
      id: data.id.present ? data.id.value : this.id,
      accountId: data.accountId.present ? data.accountId.value : this.accountId,
      gmailThreadId: data.gmailThreadId.present
          ? data.gmailThreadId.value
          : this.gmailThreadId,
      subject: data.subject.present ? data.subject.value : this.subject,
      snippet: data.snippet.present ? data.snippet.value : this.snippet,
      fromName: data.fromName.present ? data.fromName.value : this.fromName,
      fromEmail: data.fromEmail.present ? data.fromEmail.value : this.fromEmail,
      date: data.date.present ? data.date.value : this.date,
      isUnread: data.isUnread.present ? data.isUnread.value : this.isUnread,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('GmailThreadRow(')
          ..write('id: $id, ')
          ..write('accountId: $accountId, ')
          ..write('gmailThreadId: $gmailThreadId, ')
          ..write('subject: $subject, ')
          ..write('snippet: $snippet, ')
          ..write('fromName: $fromName, ')
          ..write('fromEmail: $fromEmail, ')
          ..write('date: $date, ')
          ..write('isUnread: $isUnread, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    accountId,
    gmailThreadId,
    subject,
    snippet,
    fromName,
    fromEmail,
    date,
    isUnread,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is GmailThreadRow &&
          other.id == this.id &&
          other.accountId == this.accountId &&
          other.gmailThreadId == this.gmailThreadId &&
          other.subject == this.subject &&
          other.snippet == this.snippet &&
          other.fromName == this.fromName &&
          other.fromEmail == this.fromEmail &&
          other.date == this.date &&
          other.isUnread == this.isUnread &&
          other.updatedAt == this.updatedAt);
}

class GmailThreadsCompanion extends UpdateCompanion<GmailThreadRow> {
  final Value<String> id;
  final Value<String> accountId;
  final Value<String> gmailThreadId;
  final Value<String> subject;
  final Value<String> snippet;
  final Value<String?> fromName;
  final Value<String?> fromEmail;
  final Value<DateTime> date;
  final Value<bool> isUnread;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const GmailThreadsCompanion({
    this.id = const Value.absent(),
    this.accountId = const Value.absent(),
    this.gmailThreadId = const Value.absent(),
    this.subject = const Value.absent(),
    this.snippet = const Value.absent(),
    this.fromName = const Value.absent(),
    this.fromEmail = const Value.absent(),
    this.date = const Value.absent(),
    this.isUnread = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  GmailThreadsCompanion.insert({
    required String id,
    required String accountId,
    required String gmailThreadId,
    required String subject,
    required String snippet,
    this.fromName = const Value.absent(),
    this.fromEmail = const Value.absent(),
    required DateTime date,
    this.isUnread = const Value.absent(),
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       accountId = Value(accountId),
       gmailThreadId = Value(gmailThreadId),
       subject = Value(subject),
       snippet = Value(snippet),
       date = Value(date),
       updatedAt = Value(updatedAt);
  static Insertable<GmailThreadRow> custom({
    Expression<String>? id,
    Expression<String>? accountId,
    Expression<String>? gmailThreadId,
    Expression<String>? subject,
    Expression<String>? snippet,
    Expression<String>? fromName,
    Expression<String>? fromEmail,
    Expression<DateTime>? date,
    Expression<bool>? isUnread,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (accountId != null) 'account_id': accountId,
      if (gmailThreadId != null) 'gmail_thread_id': gmailThreadId,
      if (subject != null) 'subject': subject,
      if (snippet != null) 'snippet': snippet,
      if (fromName != null) 'from_name': fromName,
      if (fromEmail != null) 'from_email': fromEmail,
      if (date != null) 'date': date,
      if (isUnread != null) 'is_unread': isUnread,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  GmailThreadsCompanion copyWith({
    Value<String>? id,
    Value<String>? accountId,
    Value<String>? gmailThreadId,
    Value<String>? subject,
    Value<String>? snippet,
    Value<String?>? fromName,
    Value<String?>? fromEmail,
    Value<DateTime>? date,
    Value<bool>? isUnread,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return GmailThreadsCompanion(
      id: id ?? this.id,
      accountId: accountId ?? this.accountId,
      gmailThreadId: gmailThreadId ?? this.gmailThreadId,
      subject: subject ?? this.subject,
      snippet: snippet ?? this.snippet,
      fromName: fromName ?? this.fromName,
      fromEmail: fromEmail ?? this.fromEmail,
      date: date ?? this.date,
      isUnread: isUnread ?? this.isUnread,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (accountId.present) {
      map['account_id'] = Variable<String>(accountId.value);
    }
    if (gmailThreadId.present) {
      map['gmail_thread_id'] = Variable<String>(gmailThreadId.value);
    }
    if (subject.present) {
      map['subject'] = Variable<String>(subject.value);
    }
    if (snippet.present) {
      map['snippet'] = Variable<String>(snippet.value);
    }
    if (fromName.present) {
      map['from_name'] = Variable<String>(fromName.value);
    }
    if (fromEmail.present) {
      map['from_email'] = Variable<String>(fromEmail.value);
    }
    if (date.present) {
      map['date'] = Variable<DateTime>(date.value);
    }
    if (isUnread.present) {
      map['is_unread'] = Variable<bool>(isUnread.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('GmailThreadsCompanion(')
          ..write('id: $id, ')
          ..write('accountId: $accountId, ')
          ..write('gmailThreadId: $gmailThreadId, ')
          ..write('subject: $subject, ')
          ..write('snippet: $snippet, ')
          ..write('fromName: $fromName, ')
          ..write('fromEmail: $fromEmail, ')
          ..write('date: $date, ')
          ..write('isUnread: $isUnread, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $GmailMessagesTable extends GmailMessages
    with TableInfo<$GmailMessagesTable, GmailMessageRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $GmailMessagesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _accountIdMeta = const VerificationMeta(
    'accountId',
  );
  @override
  late final GeneratedColumn<String> accountId = GeneratedColumn<String>(
    'account_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES gmail_accounts (id)',
    ),
  );
  static const VerificationMeta _gmailThreadIdMeta = const VerificationMeta(
    'gmailThreadId',
  );
  @override
  late final GeneratedColumn<String> gmailThreadId = GeneratedColumn<String>(
    'gmail_thread_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _gmailMessageIdMeta = const VerificationMeta(
    'gmailMessageId',
  );
  @override
  late final GeneratedColumn<String> gmailMessageId = GeneratedColumn<String>(
    'gmail_message_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _fromNameMeta = const VerificationMeta(
    'fromName',
  );
  @override
  late final GeneratedColumn<String> fromName = GeneratedColumn<String>(
    'from_name',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _fromEmailMeta = const VerificationMeta(
    'fromEmail',
  );
  @override
  late final GeneratedColumn<String> fromEmail = GeneratedColumn<String>(
    'from_email',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _toEmailsMeta = const VerificationMeta(
    'toEmails',
  );
  @override
  late final GeneratedColumn<String> toEmails = GeneratedColumn<String>(
    'to_emails',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _subjectMeta = const VerificationMeta(
    'subject',
  );
  @override
  late final GeneratedColumn<String> subject = GeneratedColumn<String>(
    'subject',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _bodyTextMeta = const VerificationMeta(
    'bodyText',
  );
  @override
  late final GeneratedColumn<String> bodyText = GeneratedColumn<String>(
    'body_text',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _bodyHtmlMeta = const VerificationMeta(
    'bodyHtml',
  );
  @override
  late final GeneratedColumn<String> bodyHtml = GeneratedColumn<String>(
    'body_html',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<DateTime> date = GeneratedColumn<DateTime>(
    'date',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _isUnreadMeta = const VerificationMeta(
    'isUnread',
  );
  @override
  late final GeneratedColumn<bool> isUnread = GeneratedColumn<bool>(
    'is_unread',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_unread" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    accountId,
    gmailThreadId,
    gmailMessageId,
    fromName,
    fromEmail,
    toEmails,
    subject,
    bodyText,
    bodyHtml,
    date,
    isUnread,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'gmail_messages';
  @override
  VerificationContext validateIntegrity(
    Insertable<GmailMessageRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('account_id')) {
      context.handle(
        _accountIdMeta,
        accountId.isAcceptableOrUnknown(data['account_id']!, _accountIdMeta),
      );
    } else if (isInserting) {
      context.missing(_accountIdMeta);
    }
    if (data.containsKey('gmail_thread_id')) {
      context.handle(
        _gmailThreadIdMeta,
        gmailThreadId.isAcceptableOrUnknown(
          data['gmail_thread_id']!,
          _gmailThreadIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_gmailThreadIdMeta);
    }
    if (data.containsKey('gmail_message_id')) {
      context.handle(
        _gmailMessageIdMeta,
        gmailMessageId.isAcceptableOrUnknown(
          data['gmail_message_id']!,
          _gmailMessageIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_gmailMessageIdMeta);
    }
    if (data.containsKey('from_name')) {
      context.handle(
        _fromNameMeta,
        fromName.isAcceptableOrUnknown(data['from_name']!, _fromNameMeta),
      );
    }
    if (data.containsKey('from_email')) {
      context.handle(
        _fromEmailMeta,
        fromEmail.isAcceptableOrUnknown(data['from_email']!, _fromEmailMeta),
      );
    }
    if (data.containsKey('to_emails')) {
      context.handle(
        _toEmailsMeta,
        toEmails.isAcceptableOrUnknown(data['to_emails']!, _toEmailsMeta),
      );
    }
    if (data.containsKey('subject')) {
      context.handle(
        _subjectMeta,
        subject.isAcceptableOrUnknown(data['subject']!, _subjectMeta),
      );
    } else if (isInserting) {
      context.missing(_subjectMeta);
    }
    if (data.containsKey('body_text')) {
      context.handle(
        _bodyTextMeta,
        bodyText.isAcceptableOrUnknown(data['body_text']!, _bodyTextMeta),
      );
    } else if (isInserting) {
      context.missing(_bodyTextMeta);
    }
    if (data.containsKey('body_html')) {
      context.handle(
        _bodyHtmlMeta,
        bodyHtml.isAcceptableOrUnknown(data['body_html']!, _bodyHtmlMeta),
      );
    }
    if (data.containsKey('date')) {
      context.handle(
        _dateMeta,
        date.isAcceptableOrUnknown(data['date']!, _dateMeta),
      );
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    if (data.containsKey('is_unread')) {
      context.handle(
        _isUnreadMeta,
        isUnread.isAcceptableOrUnknown(data['is_unread']!, _isUnreadMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  GmailMessageRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return GmailMessageRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      accountId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}account_id'],
      )!,
      gmailThreadId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}gmail_thread_id'],
      )!,
      gmailMessageId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}gmail_message_id'],
      )!,
      fromName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}from_name'],
      ),
      fromEmail: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}from_email'],
      ),
      toEmails: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}to_emails'],
      )!,
      subject: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}subject'],
      )!,
      bodyText: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}body_text'],
      )!,
      bodyHtml: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}body_html'],
      ),
      date: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}date'],
      )!,
      isUnread: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_unread'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $GmailMessagesTable createAlias(String alias) {
    return $GmailMessagesTable(attachedDatabase, alias);
  }
}

class GmailMessageRow extends DataClass implements Insertable<GmailMessageRow> {
  final String id;
  final String accountId;
  final String gmailThreadId;
  final String gmailMessageId;
  final String? fromName;
  final String? fromEmail;
  final String toEmails;
  final String subject;
  final String bodyText;

  /// Original HTML body when available (for styled rendering).
  final String? bodyHtml;
  final DateTime date;
  final bool isUnread;
  final DateTime updatedAt;
  const GmailMessageRow({
    required this.id,
    required this.accountId,
    required this.gmailThreadId,
    required this.gmailMessageId,
    this.fromName,
    this.fromEmail,
    required this.toEmails,
    required this.subject,
    required this.bodyText,
    this.bodyHtml,
    required this.date,
    required this.isUnread,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['account_id'] = Variable<String>(accountId);
    map['gmail_thread_id'] = Variable<String>(gmailThreadId);
    map['gmail_message_id'] = Variable<String>(gmailMessageId);
    if (!nullToAbsent || fromName != null) {
      map['from_name'] = Variable<String>(fromName);
    }
    if (!nullToAbsent || fromEmail != null) {
      map['from_email'] = Variable<String>(fromEmail);
    }
    map['to_emails'] = Variable<String>(toEmails);
    map['subject'] = Variable<String>(subject);
    map['body_text'] = Variable<String>(bodyText);
    if (!nullToAbsent || bodyHtml != null) {
      map['body_html'] = Variable<String>(bodyHtml);
    }
    map['date'] = Variable<DateTime>(date);
    map['is_unread'] = Variable<bool>(isUnread);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  GmailMessagesCompanion toCompanion(bool nullToAbsent) {
    return GmailMessagesCompanion(
      id: Value(id),
      accountId: Value(accountId),
      gmailThreadId: Value(gmailThreadId),
      gmailMessageId: Value(gmailMessageId),
      fromName: fromName == null && nullToAbsent
          ? const Value.absent()
          : Value(fromName),
      fromEmail: fromEmail == null && nullToAbsent
          ? const Value.absent()
          : Value(fromEmail),
      toEmails: Value(toEmails),
      subject: Value(subject),
      bodyText: Value(bodyText),
      bodyHtml: bodyHtml == null && nullToAbsent
          ? const Value.absent()
          : Value(bodyHtml),
      date: Value(date),
      isUnread: Value(isUnread),
      updatedAt: Value(updatedAt),
    );
  }

  factory GmailMessageRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return GmailMessageRow(
      id: serializer.fromJson<String>(json['id']),
      accountId: serializer.fromJson<String>(json['accountId']),
      gmailThreadId: serializer.fromJson<String>(json['gmailThreadId']),
      gmailMessageId: serializer.fromJson<String>(json['gmailMessageId']),
      fromName: serializer.fromJson<String?>(json['fromName']),
      fromEmail: serializer.fromJson<String?>(json['fromEmail']),
      toEmails: serializer.fromJson<String>(json['toEmails']),
      subject: serializer.fromJson<String>(json['subject']),
      bodyText: serializer.fromJson<String>(json['bodyText']),
      bodyHtml: serializer.fromJson<String?>(json['bodyHtml']),
      date: serializer.fromJson<DateTime>(json['date']),
      isUnread: serializer.fromJson<bool>(json['isUnread']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'accountId': serializer.toJson<String>(accountId),
      'gmailThreadId': serializer.toJson<String>(gmailThreadId),
      'gmailMessageId': serializer.toJson<String>(gmailMessageId),
      'fromName': serializer.toJson<String?>(fromName),
      'fromEmail': serializer.toJson<String?>(fromEmail),
      'toEmails': serializer.toJson<String>(toEmails),
      'subject': serializer.toJson<String>(subject),
      'bodyText': serializer.toJson<String>(bodyText),
      'bodyHtml': serializer.toJson<String?>(bodyHtml),
      'date': serializer.toJson<DateTime>(date),
      'isUnread': serializer.toJson<bool>(isUnread),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  GmailMessageRow copyWith({
    String? id,
    String? accountId,
    String? gmailThreadId,
    String? gmailMessageId,
    Value<String?> fromName = const Value.absent(),
    Value<String?> fromEmail = const Value.absent(),
    String? toEmails,
    String? subject,
    String? bodyText,
    Value<String?> bodyHtml = const Value.absent(),
    DateTime? date,
    bool? isUnread,
    DateTime? updatedAt,
  }) => GmailMessageRow(
    id: id ?? this.id,
    accountId: accountId ?? this.accountId,
    gmailThreadId: gmailThreadId ?? this.gmailThreadId,
    gmailMessageId: gmailMessageId ?? this.gmailMessageId,
    fromName: fromName.present ? fromName.value : this.fromName,
    fromEmail: fromEmail.present ? fromEmail.value : this.fromEmail,
    toEmails: toEmails ?? this.toEmails,
    subject: subject ?? this.subject,
    bodyText: bodyText ?? this.bodyText,
    bodyHtml: bodyHtml.present ? bodyHtml.value : this.bodyHtml,
    date: date ?? this.date,
    isUnread: isUnread ?? this.isUnread,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  GmailMessageRow copyWithCompanion(GmailMessagesCompanion data) {
    return GmailMessageRow(
      id: data.id.present ? data.id.value : this.id,
      accountId: data.accountId.present ? data.accountId.value : this.accountId,
      gmailThreadId: data.gmailThreadId.present
          ? data.gmailThreadId.value
          : this.gmailThreadId,
      gmailMessageId: data.gmailMessageId.present
          ? data.gmailMessageId.value
          : this.gmailMessageId,
      fromName: data.fromName.present ? data.fromName.value : this.fromName,
      fromEmail: data.fromEmail.present ? data.fromEmail.value : this.fromEmail,
      toEmails: data.toEmails.present ? data.toEmails.value : this.toEmails,
      subject: data.subject.present ? data.subject.value : this.subject,
      bodyText: data.bodyText.present ? data.bodyText.value : this.bodyText,
      bodyHtml: data.bodyHtml.present ? data.bodyHtml.value : this.bodyHtml,
      date: data.date.present ? data.date.value : this.date,
      isUnread: data.isUnread.present ? data.isUnread.value : this.isUnread,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('GmailMessageRow(')
          ..write('id: $id, ')
          ..write('accountId: $accountId, ')
          ..write('gmailThreadId: $gmailThreadId, ')
          ..write('gmailMessageId: $gmailMessageId, ')
          ..write('fromName: $fromName, ')
          ..write('fromEmail: $fromEmail, ')
          ..write('toEmails: $toEmails, ')
          ..write('subject: $subject, ')
          ..write('bodyText: $bodyText, ')
          ..write('bodyHtml: $bodyHtml, ')
          ..write('date: $date, ')
          ..write('isUnread: $isUnread, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    accountId,
    gmailThreadId,
    gmailMessageId,
    fromName,
    fromEmail,
    toEmails,
    subject,
    bodyText,
    bodyHtml,
    date,
    isUnread,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is GmailMessageRow &&
          other.id == this.id &&
          other.accountId == this.accountId &&
          other.gmailThreadId == this.gmailThreadId &&
          other.gmailMessageId == this.gmailMessageId &&
          other.fromName == this.fromName &&
          other.fromEmail == this.fromEmail &&
          other.toEmails == this.toEmails &&
          other.subject == this.subject &&
          other.bodyText == this.bodyText &&
          other.bodyHtml == this.bodyHtml &&
          other.date == this.date &&
          other.isUnread == this.isUnread &&
          other.updatedAt == this.updatedAt);
}

class GmailMessagesCompanion extends UpdateCompanion<GmailMessageRow> {
  final Value<String> id;
  final Value<String> accountId;
  final Value<String> gmailThreadId;
  final Value<String> gmailMessageId;
  final Value<String?> fromName;
  final Value<String?> fromEmail;
  final Value<String> toEmails;
  final Value<String> subject;
  final Value<String> bodyText;
  final Value<String?> bodyHtml;
  final Value<DateTime> date;
  final Value<bool> isUnread;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const GmailMessagesCompanion({
    this.id = const Value.absent(),
    this.accountId = const Value.absent(),
    this.gmailThreadId = const Value.absent(),
    this.gmailMessageId = const Value.absent(),
    this.fromName = const Value.absent(),
    this.fromEmail = const Value.absent(),
    this.toEmails = const Value.absent(),
    this.subject = const Value.absent(),
    this.bodyText = const Value.absent(),
    this.bodyHtml = const Value.absent(),
    this.date = const Value.absent(),
    this.isUnread = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  GmailMessagesCompanion.insert({
    required String id,
    required String accountId,
    required String gmailThreadId,
    required String gmailMessageId,
    this.fromName = const Value.absent(),
    this.fromEmail = const Value.absent(),
    this.toEmails = const Value.absent(),
    required String subject,
    required String bodyText,
    this.bodyHtml = const Value.absent(),
    required DateTime date,
    this.isUnread = const Value.absent(),
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       accountId = Value(accountId),
       gmailThreadId = Value(gmailThreadId),
       gmailMessageId = Value(gmailMessageId),
       subject = Value(subject),
       bodyText = Value(bodyText),
       date = Value(date),
       updatedAt = Value(updatedAt);
  static Insertable<GmailMessageRow> custom({
    Expression<String>? id,
    Expression<String>? accountId,
    Expression<String>? gmailThreadId,
    Expression<String>? gmailMessageId,
    Expression<String>? fromName,
    Expression<String>? fromEmail,
    Expression<String>? toEmails,
    Expression<String>? subject,
    Expression<String>? bodyText,
    Expression<String>? bodyHtml,
    Expression<DateTime>? date,
    Expression<bool>? isUnread,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (accountId != null) 'account_id': accountId,
      if (gmailThreadId != null) 'gmail_thread_id': gmailThreadId,
      if (gmailMessageId != null) 'gmail_message_id': gmailMessageId,
      if (fromName != null) 'from_name': fromName,
      if (fromEmail != null) 'from_email': fromEmail,
      if (toEmails != null) 'to_emails': toEmails,
      if (subject != null) 'subject': subject,
      if (bodyText != null) 'body_text': bodyText,
      if (bodyHtml != null) 'body_html': bodyHtml,
      if (date != null) 'date': date,
      if (isUnread != null) 'is_unread': isUnread,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  GmailMessagesCompanion copyWith({
    Value<String>? id,
    Value<String>? accountId,
    Value<String>? gmailThreadId,
    Value<String>? gmailMessageId,
    Value<String?>? fromName,
    Value<String?>? fromEmail,
    Value<String>? toEmails,
    Value<String>? subject,
    Value<String>? bodyText,
    Value<String?>? bodyHtml,
    Value<DateTime>? date,
    Value<bool>? isUnread,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return GmailMessagesCompanion(
      id: id ?? this.id,
      accountId: accountId ?? this.accountId,
      gmailThreadId: gmailThreadId ?? this.gmailThreadId,
      gmailMessageId: gmailMessageId ?? this.gmailMessageId,
      fromName: fromName ?? this.fromName,
      fromEmail: fromEmail ?? this.fromEmail,
      toEmails: toEmails ?? this.toEmails,
      subject: subject ?? this.subject,
      bodyText: bodyText ?? this.bodyText,
      bodyHtml: bodyHtml ?? this.bodyHtml,
      date: date ?? this.date,
      isUnread: isUnread ?? this.isUnread,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (accountId.present) {
      map['account_id'] = Variable<String>(accountId.value);
    }
    if (gmailThreadId.present) {
      map['gmail_thread_id'] = Variable<String>(gmailThreadId.value);
    }
    if (gmailMessageId.present) {
      map['gmail_message_id'] = Variable<String>(gmailMessageId.value);
    }
    if (fromName.present) {
      map['from_name'] = Variable<String>(fromName.value);
    }
    if (fromEmail.present) {
      map['from_email'] = Variable<String>(fromEmail.value);
    }
    if (toEmails.present) {
      map['to_emails'] = Variable<String>(toEmails.value);
    }
    if (subject.present) {
      map['subject'] = Variable<String>(subject.value);
    }
    if (bodyText.present) {
      map['body_text'] = Variable<String>(bodyText.value);
    }
    if (bodyHtml.present) {
      map['body_html'] = Variable<String>(bodyHtml.value);
    }
    if (date.present) {
      map['date'] = Variable<DateTime>(date.value);
    }
    if (isUnread.present) {
      map['is_unread'] = Variable<bool>(isUnread.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('GmailMessagesCompanion(')
          ..write('id: $id, ')
          ..write('accountId: $accountId, ')
          ..write('gmailThreadId: $gmailThreadId, ')
          ..write('gmailMessageId: $gmailMessageId, ')
          ..write('fromName: $fromName, ')
          ..write('fromEmail: $fromEmail, ')
          ..write('toEmails: $toEmails, ')
          ..write('subject: $subject, ')
          ..write('bodyText: $bodyText, ')
          ..write('bodyHtml: $bodyHtml, ')
          ..write('date: $date, ')
          ..write('isUnread: $isUnread, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $SlackAccountsTable extends SlackAccounts
    with TableInfo<$SlackAccountsTable, SlackAccountRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SlackAccountsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _teamIdMeta = const VerificationMeta('teamId');
  @override
  late final GeneratedColumn<String> teamId = GeneratedColumn<String>(
    'team_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _teamNameMeta = const VerificationMeta(
    'teamName',
  );
  @override
  late final GeneratedColumn<String> teamName = GeneratedColumn<String>(
    'team_name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _userIdMeta = const VerificationMeta('userId');
  @override
  late final GeneratedColumn<String> userId = GeneratedColumn<String>(
    'user_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _displayNameMeta = const VerificationMeta(
    'displayName',
  );
  @override
  late final GeneratedColumn<String> displayName = GeneratedColumn<String>(
    'display_name',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _connectedAtMeta = const VerificationMeta(
    'connectedAt',
  );
  @override
  late final GeneratedColumn<DateTime> connectedAt = GeneratedColumn<DateTime>(
    'connected_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _lastSyncAtMeta = const VerificationMeta(
    'lastSyncAt',
  );
  @override
  late final GeneratedColumn<DateTime> lastSyncAt = GeneratedColumn<DateTime>(
    'last_sync_at',
    aliasedName,
    true,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    teamId,
    teamName,
    userId,
    displayName,
    connectedAt,
    lastSyncAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'slack_accounts';
  @override
  VerificationContext validateIntegrity(
    Insertable<SlackAccountRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('team_id')) {
      context.handle(
        _teamIdMeta,
        teamId.isAcceptableOrUnknown(data['team_id']!, _teamIdMeta),
      );
    } else if (isInserting) {
      context.missing(_teamIdMeta);
    }
    if (data.containsKey('team_name')) {
      context.handle(
        _teamNameMeta,
        teamName.isAcceptableOrUnknown(data['team_name']!, _teamNameMeta),
      );
    } else if (isInserting) {
      context.missing(_teamNameMeta);
    }
    if (data.containsKey('user_id')) {
      context.handle(
        _userIdMeta,
        userId.isAcceptableOrUnknown(data['user_id']!, _userIdMeta),
      );
    } else if (isInserting) {
      context.missing(_userIdMeta);
    }
    if (data.containsKey('display_name')) {
      context.handle(
        _displayNameMeta,
        displayName.isAcceptableOrUnknown(
          data['display_name']!,
          _displayNameMeta,
        ),
      );
    }
    if (data.containsKey('connected_at')) {
      context.handle(
        _connectedAtMeta,
        connectedAt.isAcceptableOrUnknown(
          data['connected_at']!,
          _connectedAtMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_connectedAtMeta);
    }
    if (data.containsKey('last_sync_at')) {
      context.handle(
        _lastSyncAtMeta,
        lastSyncAt.isAcceptableOrUnknown(
          data['last_sync_at']!,
          _lastSyncAtMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SlackAccountRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SlackAccountRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      teamId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}team_id'],
      )!,
      teamName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}team_name'],
      )!,
      userId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}user_id'],
      )!,
      displayName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}display_name'],
      ),
      connectedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}connected_at'],
      )!,
      lastSyncAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}last_sync_at'],
      ),
    );
  }

  @override
  $SlackAccountsTable createAlias(String alias) {
    return $SlackAccountsTable(attachedDatabase, alias);
  }
}

class SlackAccountRow extends DataClass implements Insertable<SlackAccountRow> {
  final String id;
  final String teamId;
  final String teamName;
  final String userId;
  final String? displayName;
  final DateTime connectedAt;
  final DateTime? lastSyncAt;
  const SlackAccountRow({
    required this.id,
    required this.teamId,
    required this.teamName,
    required this.userId,
    this.displayName,
    required this.connectedAt,
    this.lastSyncAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['team_id'] = Variable<String>(teamId);
    map['team_name'] = Variable<String>(teamName);
    map['user_id'] = Variable<String>(userId);
    if (!nullToAbsent || displayName != null) {
      map['display_name'] = Variable<String>(displayName);
    }
    map['connected_at'] = Variable<DateTime>(connectedAt);
    if (!nullToAbsent || lastSyncAt != null) {
      map['last_sync_at'] = Variable<DateTime>(lastSyncAt);
    }
    return map;
  }

  SlackAccountsCompanion toCompanion(bool nullToAbsent) {
    return SlackAccountsCompanion(
      id: Value(id),
      teamId: Value(teamId),
      teamName: Value(teamName),
      userId: Value(userId),
      displayName: displayName == null && nullToAbsent
          ? const Value.absent()
          : Value(displayName),
      connectedAt: Value(connectedAt),
      lastSyncAt: lastSyncAt == null && nullToAbsent
          ? const Value.absent()
          : Value(lastSyncAt),
    );
  }

  factory SlackAccountRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SlackAccountRow(
      id: serializer.fromJson<String>(json['id']),
      teamId: serializer.fromJson<String>(json['teamId']),
      teamName: serializer.fromJson<String>(json['teamName']),
      userId: serializer.fromJson<String>(json['userId']),
      displayName: serializer.fromJson<String?>(json['displayName']),
      connectedAt: serializer.fromJson<DateTime>(json['connectedAt']),
      lastSyncAt: serializer.fromJson<DateTime?>(json['lastSyncAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'teamId': serializer.toJson<String>(teamId),
      'teamName': serializer.toJson<String>(teamName),
      'userId': serializer.toJson<String>(userId),
      'displayName': serializer.toJson<String?>(displayName),
      'connectedAt': serializer.toJson<DateTime>(connectedAt),
      'lastSyncAt': serializer.toJson<DateTime?>(lastSyncAt),
    };
  }

  SlackAccountRow copyWith({
    String? id,
    String? teamId,
    String? teamName,
    String? userId,
    Value<String?> displayName = const Value.absent(),
    DateTime? connectedAt,
    Value<DateTime?> lastSyncAt = const Value.absent(),
  }) => SlackAccountRow(
    id: id ?? this.id,
    teamId: teamId ?? this.teamId,
    teamName: teamName ?? this.teamName,
    userId: userId ?? this.userId,
    displayName: displayName.present ? displayName.value : this.displayName,
    connectedAt: connectedAt ?? this.connectedAt,
    lastSyncAt: lastSyncAt.present ? lastSyncAt.value : this.lastSyncAt,
  );
  SlackAccountRow copyWithCompanion(SlackAccountsCompanion data) {
    return SlackAccountRow(
      id: data.id.present ? data.id.value : this.id,
      teamId: data.teamId.present ? data.teamId.value : this.teamId,
      teamName: data.teamName.present ? data.teamName.value : this.teamName,
      userId: data.userId.present ? data.userId.value : this.userId,
      displayName: data.displayName.present
          ? data.displayName.value
          : this.displayName,
      connectedAt: data.connectedAt.present
          ? data.connectedAt.value
          : this.connectedAt,
      lastSyncAt: data.lastSyncAt.present
          ? data.lastSyncAt.value
          : this.lastSyncAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SlackAccountRow(')
          ..write('id: $id, ')
          ..write('teamId: $teamId, ')
          ..write('teamName: $teamName, ')
          ..write('userId: $userId, ')
          ..write('displayName: $displayName, ')
          ..write('connectedAt: $connectedAt, ')
          ..write('lastSyncAt: $lastSyncAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    teamId,
    teamName,
    userId,
    displayName,
    connectedAt,
    lastSyncAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SlackAccountRow &&
          other.id == this.id &&
          other.teamId == this.teamId &&
          other.teamName == this.teamName &&
          other.userId == this.userId &&
          other.displayName == this.displayName &&
          other.connectedAt == this.connectedAt &&
          other.lastSyncAt == this.lastSyncAt);
}

class SlackAccountsCompanion extends UpdateCompanion<SlackAccountRow> {
  final Value<String> id;
  final Value<String> teamId;
  final Value<String> teamName;
  final Value<String> userId;
  final Value<String?> displayName;
  final Value<DateTime> connectedAt;
  final Value<DateTime?> lastSyncAt;
  final Value<int> rowid;
  const SlackAccountsCompanion({
    this.id = const Value.absent(),
    this.teamId = const Value.absent(),
    this.teamName = const Value.absent(),
    this.userId = const Value.absent(),
    this.displayName = const Value.absent(),
    this.connectedAt = const Value.absent(),
    this.lastSyncAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SlackAccountsCompanion.insert({
    required String id,
    required String teamId,
    required String teamName,
    required String userId,
    this.displayName = const Value.absent(),
    required DateTime connectedAt,
    this.lastSyncAt = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       teamId = Value(teamId),
       teamName = Value(teamName),
       userId = Value(userId),
       connectedAt = Value(connectedAt);
  static Insertable<SlackAccountRow> custom({
    Expression<String>? id,
    Expression<String>? teamId,
    Expression<String>? teamName,
    Expression<String>? userId,
    Expression<String>? displayName,
    Expression<DateTime>? connectedAt,
    Expression<DateTime>? lastSyncAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (teamId != null) 'team_id': teamId,
      if (teamName != null) 'team_name': teamName,
      if (userId != null) 'user_id': userId,
      if (displayName != null) 'display_name': displayName,
      if (connectedAt != null) 'connected_at': connectedAt,
      if (lastSyncAt != null) 'last_sync_at': lastSyncAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SlackAccountsCompanion copyWith({
    Value<String>? id,
    Value<String>? teamId,
    Value<String>? teamName,
    Value<String>? userId,
    Value<String?>? displayName,
    Value<DateTime>? connectedAt,
    Value<DateTime?>? lastSyncAt,
    Value<int>? rowid,
  }) {
    return SlackAccountsCompanion(
      id: id ?? this.id,
      teamId: teamId ?? this.teamId,
      teamName: teamName ?? this.teamName,
      userId: userId ?? this.userId,
      displayName: displayName ?? this.displayName,
      connectedAt: connectedAt ?? this.connectedAt,
      lastSyncAt: lastSyncAt ?? this.lastSyncAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (teamId.present) {
      map['team_id'] = Variable<String>(teamId.value);
    }
    if (teamName.present) {
      map['team_name'] = Variable<String>(teamName.value);
    }
    if (userId.present) {
      map['user_id'] = Variable<String>(userId.value);
    }
    if (displayName.present) {
      map['display_name'] = Variable<String>(displayName.value);
    }
    if (connectedAt.present) {
      map['connected_at'] = Variable<DateTime>(connectedAt.value);
    }
    if (lastSyncAt.present) {
      map['last_sync_at'] = Variable<DateTime>(lastSyncAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SlackAccountsCompanion(')
          ..write('id: $id, ')
          ..write('teamId: $teamId, ')
          ..write('teamName: $teamName, ')
          ..write('userId: $userId, ')
          ..write('displayName: $displayName, ')
          ..write('connectedAt: $connectedAt, ')
          ..write('lastSyncAt: $lastSyncAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $SlackConversationsTable extends SlackConversations
    with TableInfo<$SlackConversationsTable, SlackConversationRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SlackConversationsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _accountIdMeta = const VerificationMeta(
    'accountId',
  );
  @override
  late final GeneratedColumn<String> accountId = GeneratedColumn<String>(
    'account_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES slack_accounts (id)',
    ),
  );
  static const VerificationMeta _conversationIdMeta = const VerificationMeta(
    'conversationId',
  );
  @override
  late final GeneratedColumn<String> conversationId = GeneratedColumn<String>(
    'conversation_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _conversationTypeMeta = const VerificationMeta(
    'conversationType',
  );
  @override
  late final GeneratedColumn<String> conversationType = GeneratedColumn<String>(
    'conversation_type',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _isMutedMeta = const VerificationMeta(
    'isMuted',
  );
  @override
  late final GeneratedColumn<bool> isMuted = GeneratedColumn<bool>(
    'is_muted',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_muted" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _isAllowedMeta = const VerificationMeta(
    'isAllowed',
  );
  @override
  late final GeneratedColumn<bool> isAllowed = GeneratedColumn<bool>(
    'is_allowed',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_allowed" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _unreadCountMeta = const VerificationMeta(
    'unreadCount',
  );
  @override
  late final GeneratedColumn<int> unreadCount = GeneratedColumn<int>(
    'unread_count',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _lastMessageAtMeta = const VerificationMeta(
    'lastMessageAt',
  );
  @override
  late final GeneratedColumn<DateTime> lastMessageAt =
      GeneratedColumn<DateTime>(
        'last_message_at',
        aliasedName,
        true,
        type: DriftSqlType.dateTime,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    accountId,
    conversationId,
    name,
    conversationType,
    isMuted,
    isAllowed,
    unreadCount,
    lastMessageAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'slack_conversations';
  @override
  VerificationContext validateIntegrity(
    Insertable<SlackConversationRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('account_id')) {
      context.handle(
        _accountIdMeta,
        accountId.isAcceptableOrUnknown(data['account_id']!, _accountIdMeta),
      );
    } else if (isInserting) {
      context.missing(_accountIdMeta);
    }
    if (data.containsKey('conversation_id')) {
      context.handle(
        _conversationIdMeta,
        conversationId.isAcceptableOrUnknown(
          data['conversation_id']!,
          _conversationIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_conversationIdMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('conversation_type')) {
      context.handle(
        _conversationTypeMeta,
        conversationType.isAcceptableOrUnknown(
          data['conversation_type']!,
          _conversationTypeMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_conversationTypeMeta);
    }
    if (data.containsKey('is_muted')) {
      context.handle(
        _isMutedMeta,
        isMuted.isAcceptableOrUnknown(data['is_muted']!, _isMutedMeta),
      );
    }
    if (data.containsKey('is_allowed')) {
      context.handle(
        _isAllowedMeta,
        isAllowed.isAcceptableOrUnknown(data['is_allowed']!, _isAllowedMeta),
      );
    }
    if (data.containsKey('unread_count')) {
      context.handle(
        _unreadCountMeta,
        unreadCount.isAcceptableOrUnknown(
          data['unread_count']!,
          _unreadCountMeta,
        ),
      );
    }
    if (data.containsKey('last_message_at')) {
      context.handle(
        _lastMessageAtMeta,
        lastMessageAt.isAcceptableOrUnknown(
          data['last_message_at']!,
          _lastMessageAtMeta,
        ),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SlackConversationRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SlackConversationRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      accountId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}account_id'],
      )!,
      conversationId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}conversation_id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      conversationType: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}conversation_type'],
      )!,
      isMuted: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_muted'],
      )!,
      isAllowed: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_allowed'],
      )!,
      unreadCount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}unread_count'],
      )!,
      lastMessageAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}last_message_at'],
      ),
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $SlackConversationsTable createAlias(String alias) {
    return $SlackConversationsTable(attachedDatabase, alias);
  }
}

class SlackConversationRow extends DataClass
    implements Insertable<SlackConversationRow> {
  final String id;
  final String accountId;
  final String conversationId;
  final String name;

  /// channel | group | im | mpim
  final String conversationType;
  final bool isMuted;
  final bool isAllowed;
  final int unreadCount;
  final DateTime? lastMessageAt;
  final DateTime updatedAt;
  const SlackConversationRow({
    required this.id,
    required this.accountId,
    required this.conversationId,
    required this.name,
    required this.conversationType,
    required this.isMuted,
    required this.isAllowed,
    required this.unreadCount,
    this.lastMessageAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['account_id'] = Variable<String>(accountId);
    map['conversation_id'] = Variable<String>(conversationId);
    map['name'] = Variable<String>(name);
    map['conversation_type'] = Variable<String>(conversationType);
    map['is_muted'] = Variable<bool>(isMuted);
    map['is_allowed'] = Variable<bool>(isAllowed);
    map['unread_count'] = Variable<int>(unreadCount);
    if (!nullToAbsent || lastMessageAt != null) {
      map['last_message_at'] = Variable<DateTime>(lastMessageAt);
    }
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  SlackConversationsCompanion toCompanion(bool nullToAbsent) {
    return SlackConversationsCompanion(
      id: Value(id),
      accountId: Value(accountId),
      conversationId: Value(conversationId),
      name: Value(name),
      conversationType: Value(conversationType),
      isMuted: Value(isMuted),
      isAllowed: Value(isAllowed),
      unreadCount: Value(unreadCount),
      lastMessageAt: lastMessageAt == null && nullToAbsent
          ? const Value.absent()
          : Value(lastMessageAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory SlackConversationRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SlackConversationRow(
      id: serializer.fromJson<String>(json['id']),
      accountId: serializer.fromJson<String>(json['accountId']),
      conversationId: serializer.fromJson<String>(json['conversationId']),
      name: serializer.fromJson<String>(json['name']),
      conversationType: serializer.fromJson<String>(json['conversationType']),
      isMuted: serializer.fromJson<bool>(json['isMuted']),
      isAllowed: serializer.fromJson<bool>(json['isAllowed']),
      unreadCount: serializer.fromJson<int>(json['unreadCount']),
      lastMessageAt: serializer.fromJson<DateTime?>(json['lastMessageAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'accountId': serializer.toJson<String>(accountId),
      'conversationId': serializer.toJson<String>(conversationId),
      'name': serializer.toJson<String>(name),
      'conversationType': serializer.toJson<String>(conversationType),
      'isMuted': serializer.toJson<bool>(isMuted),
      'isAllowed': serializer.toJson<bool>(isAllowed),
      'unreadCount': serializer.toJson<int>(unreadCount),
      'lastMessageAt': serializer.toJson<DateTime?>(lastMessageAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  SlackConversationRow copyWith({
    String? id,
    String? accountId,
    String? conversationId,
    String? name,
    String? conversationType,
    bool? isMuted,
    bool? isAllowed,
    int? unreadCount,
    Value<DateTime?> lastMessageAt = const Value.absent(),
    DateTime? updatedAt,
  }) => SlackConversationRow(
    id: id ?? this.id,
    accountId: accountId ?? this.accountId,
    conversationId: conversationId ?? this.conversationId,
    name: name ?? this.name,
    conversationType: conversationType ?? this.conversationType,
    isMuted: isMuted ?? this.isMuted,
    isAllowed: isAllowed ?? this.isAllowed,
    unreadCount: unreadCount ?? this.unreadCount,
    lastMessageAt: lastMessageAt.present
        ? lastMessageAt.value
        : this.lastMessageAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  SlackConversationRow copyWithCompanion(SlackConversationsCompanion data) {
    return SlackConversationRow(
      id: data.id.present ? data.id.value : this.id,
      accountId: data.accountId.present ? data.accountId.value : this.accountId,
      conversationId: data.conversationId.present
          ? data.conversationId.value
          : this.conversationId,
      name: data.name.present ? data.name.value : this.name,
      conversationType: data.conversationType.present
          ? data.conversationType.value
          : this.conversationType,
      isMuted: data.isMuted.present ? data.isMuted.value : this.isMuted,
      isAllowed: data.isAllowed.present ? data.isAllowed.value : this.isAllowed,
      unreadCount: data.unreadCount.present
          ? data.unreadCount.value
          : this.unreadCount,
      lastMessageAt: data.lastMessageAt.present
          ? data.lastMessageAt.value
          : this.lastMessageAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SlackConversationRow(')
          ..write('id: $id, ')
          ..write('accountId: $accountId, ')
          ..write('conversationId: $conversationId, ')
          ..write('name: $name, ')
          ..write('conversationType: $conversationType, ')
          ..write('isMuted: $isMuted, ')
          ..write('isAllowed: $isAllowed, ')
          ..write('unreadCount: $unreadCount, ')
          ..write('lastMessageAt: $lastMessageAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    accountId,
    conversationId,
    name,
    conversationType,
    isMuted,
    isAllowed,
    unreadCount,
    lastMessageAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SlackConversationRow &&
          other.id == this.id &&
          other.accountId == this.accountId &&
          other.conversationId == this.conversationId &&
          other.name == this.name &&
          other.conversationType == this.conversationType &&
          other.isMuted == this.isMuted &&
          other.isAllowed == this.isAllowed &&
          other.unreadCount == this.unreadCount &&
          other.lastMessageAt == this.lastMessageAt &&
          other.updatedAt == this.updatedAt);
}

class SlackConversationsCompanion
    extends UpdateCompanion<SlackConversationRow> {
  final Value<String> id;
  final Value<String> accountId;
  final Value<String> conversationId;
  final Value<String> name;
  final Value<String> conversationType;
  final Value<bool> isMuted;
  final Value<bool> isAllowed;
  final Value<int> unreadCount;
  final Value<DateTime?> lastMessageAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const SlackConversationsCompanion({
    this.id = const Value.absent(),
    this.accountId = const Value.absent(),
    this.conversationId = const Value.absent(),
    this.name = const Value.absent(),
    this.conversationType = const Value.absent(),
    this.isMuted = const Value.absent(),
    this.isAllowed = const Value.absent(),
    this.unreadCount = const Value.absent(),
    this.lastMessageAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SlackConversationsCompanion.insert({
    required String id,
    required String accountId,
    required String conversationId,
    required String name,
    required String conversationType,
    this.isMuted = const Value.absent(),
    this.isAllowed = const Value.absent(),
    this.unreadCount = const Value.absent(),
    this.lastMessageAt = const Value.absent(),
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       accountId = Value(accountId),
       conversationId = Value(conversationId),
       name = Value(name),
       conversationType = Value(conversationType),
       updatedAt = Value(updatedAt);
  static Insertable<SlackConversationRow> custom({
    Expression<String>? id,
    Expression<String>? accountId,
    Expression<String>? conversationId,
    Expression<String>? name,
    Expression<String>? conversationType,
    Expression<bool>? isMuted,
    Expression<bool>? isAllowed,
    Expression<int>? unreadCount,
    Expression<DateTime>? lastMessageAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (accountId != null) 'account_id': accountId,
      if (conversationId != null) 'conversation_id': conversationId,
      if (name != null) 'name': name,
      if (conversationType != null) 'conversation_type': conversationType,
      if (isMuted != null) 'is_muted': isMuted,
      if (isAllowed != null) 'is_allowed': isAllowed,
      if (unreadCount != null) 'unread_count': unreadCount,
      if (lastMessageAt != null) 'last_message_at': lastMessageAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SlackConversationsCompanion copyWith({
    Value<String>? id,
    Value<String>? accountId,
    Value<String>? conversationId,
    Value<String>? name,
    Value<String>? conversationType,
    Value<bool>? isMuted,
    Value<bool>? isAllowed,
    Value<int>? unreadCount,
    Value<DateTime?>? lastMessageAt,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return SlackConversationsCompanion(
      id: id ?? this.id,
      accountId: accountId ?? this.accountId,
      conversationId: conversationId ?? this.conversationId,
      name: name ?? this.name,
      conversationType: conversationType ?? this.conversationType,
      isMuted: isMuted ?? this.isMuted,
      isAllowed: isAllowed ?? this.isAllowed,
      unreadCount: unreadCount ?? this.unreadCount,
      lastMessageAt: lastMessageAt ?? this.lastMessageAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (accountId.present) {
      map['account_id'] = Variable<String>(accountId.value);
    }
    if (conversationId.present) {
      map['conversation_id'] = Variable<String>(conversationId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (conversationType.present) {
      map['conversation_type'] = Variable<String>(conversationType.value);
    }
    if (isMuted.present) {
      map['is_muted'] = Variable<bool>(isMuted.value);
    }
    if (isAllowed.present) {
      map['is_allowed'] = Variable<bool>(isAllowed.value);
    }
    if (unreadCount.present) {
      map['unread_count'] = Variable<int>(unreadCount.value);
    }
    if (lastMessageAt.present) {
      map['last_message_at'] = Variable<DateTime>(lastMessageAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SlackConversationsCompanion(')
          ..write('id: $id, ')
          ..write('accountId: $accountId, ')
          ..write('conversationId: $conversationId, ')
          ..write('name: $name, ')
          ..write('conversationType: $conversationType, ')
          ..write('isMuted: $isMuted, ')
          ..write('isAllowed: $isAllowed, ')
          ..write('unreadCount: $unreadCount, ')
          ..write('lastMessageAt: $lastMessageAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $SlackMessagesTable extends SlackMessages
    with TableInfo<$SlackMessagesTable, SlackMessageRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SlackMessagesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _accountIdMeta = const VerificationMeta(
    'accountId',
  );
  @override
  late final GeneratedColumn<String> accountId = GeneratedColumn<String>(
    'account_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES slack_accounts (id)',
    ),
  );
  static const VerificationMeta _conversationIdMeta = const VerificationMeta(
    'conversationId',
  );
  @override
  late final GeneratedColumn<String> conversationId = GeneratedColumn<String>(
    'conversation_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _messageTsMeta = const VerificationMeta(
    'messageTs',
  );
  @override
  late final GeneratedColumn<String> messageTs = GeneratedColumn<String>(
    'message_ts',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _threadTsMeta = const VerificationMeta(
    'threadTs',
  );
  @override
  late final GeneratedColumn<String> threadTs = GeneratedColumn<String>(
    'thread_ts',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _senderNameMeta = const VerificationMeta(
    'senderName',
  );
  @override
  late final GeneratedColumn<String> senderName = GeneratedColumn<String>(
    'sender_name',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _senderUserIdMeta = const VerificationMeta(
    'senderUserId',
  );
  @override
  late final GeneratedColumn<String> senderUserId = GeneratedColumn<String>(
    'sender_user_id',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _bodyMeta = const VerificationMeta('body');
  @override
  late final GeneratedColumn<String> body = GeneratedColumn<String>(
    'body',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _isOutgoingMeta = const VerificationMeta(
    'isOutgoing',
  );
  @override
  late final GeneratedColumn<bool> isOutgoing = GeneratedColumn<bool>(
    'is_outgoing',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_outgoing" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _replyCountMeta = const VerificationMeta(
    'replyCount',
  );
  @override
  late final GeneratedColumn<int> replyCount = GeneratedColumn<int>(
    'reply_count',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _reactionsJsonMeta = const VerificationMeta(
    'reactionsJson',
  );
  @override
  late final GeneratedColumn<String> reactionsJson = GeneratedColumn<String>(
    'reactions_json',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('[]'),
  );
  static const VerificationMeta _filesJsonMeta = const VerificationMeta(
    'filesJson',
  );
  @override
  late final GeneratedColumn<String> filesJson = GeneratedColumn<String>(
    'files_json',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('[]'),
  );
  static const VerificationMeta _isEditedMeta = const VerificationMeta(
    'isEdited',
  );
  @override
  late final GeneratedColumn<bool> isEdited = GeneratedColumn<bool>(
    'is_edited',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_edited" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _sentAtMeta = const VerificationMeta('sentAt');
  @override
  late final GeneratedColumn<DateTime> sentAt = GeneratedColumn<DateTime>(
    'sent_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<DateTime> updatedAt = GeneratedColumn<DateTime>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    accountId,
    conversationId,
    messageTs,
    threadTs,
    senderName,
    senderUserId,
    body,
    isOutgoing,
    replyCount,
    reactionsJson,
    filesJson,
    isEdited,
    sentAt,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'slack_messages';
  @override
  VerificationContext validateIntegrity(
    Insertable<SlackMessageRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('account_id')) {
      context.handle(
        _accountIdMeta,
        accountId.isAcceptableOrUnknown(data['account_id']!, _accountIdMeta),
      );
    } else if (isInserting) {
      context.missing(_accountIdMeta);
    }
    if (data.containsKey('conversation_id')) {
      context.handle(
        _conversationIdMeta,
        conversationId.isAcceptableOrUnknown(
          data['conversation_id']!,
          _conversationIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_conversationIdMeta);
    }
    if (data.containsKey('message_ts')) {
      context.handle(
        _messageTsMeta,
        messageTs.isAcceptableOrUnknown(data['message_ts']!, _messageTsMeta),
      );
    } else if (isInserting) {
      context.missing(_messageTsMeta);
    }
    if (data.containsKey('thread_ts')) {
      context.handle(
        _threadTsMeta,
        threadTs.isAcceptableOrUnknown(data['thread_ts']!, _threadTsMeta),
      );
    }
    if (data.containsKey('sender_name')) {
      context.handle(
        _senderNameMeta,
        senderName.isAcceptableOrUnknown(data['sender_name']!, _senderNameMeta),
      );
    }
    if (data.containsKey('sender_user_id')) {
      context.handle(
        _senderUserIdMeta,
        senderUserId.isAcceptableOrUnknown(
          data['sender_user_id']!,
          _senderUserIdMeta,
        ),
      );
    }
    if (data.containsKey('body')) {
      context.handle(
        _bodyMeta,
        body.isAcceptableOrUnknown(data['body']!, _bodyMeta),
      );
    } else if (isInserting) {
      context.missing(_bodyMeta);
    }
    if (data.containsKey('is_outgoing')) {
      context.handle(
        _isOutgoingMeta,
        isOutgoing.isAcceptableOrUnknown(data['is_outgoing']!, _isOutgoingMeta),
      );
    }
    if (data.containsKey('reply_count')) {
      context.handle(
        _replyCountMeta,
        replyCount.isAcceptableOrUnknown(data['reply_count']!, _replyCountMeta),
      );
    }
    if (data.containsKey('reactions_json')) {
      context.handle(
        _reactionsJsonMeta,
        reactionsJson.isAcceptableOrUnknown(
          data['reactions_json']!,
          _reactionsJsonMeta,
        ),
      );
    }
    if (data.containsKey('files_json')) {
      context.handle(
        _filesJsonMeta,
        filesJson.isAcceptableOrUnknown(data['files_json']!, _filesJsonMeta),
      );
    }
    if (data.containsKey('is_edited')) {
      context.handle(
        _isEditedMeta,
        isEdited.isAcceptableOrUnknown(data['is_edited']!, _isEditedMeta),
      );
    }
    if (data.containsKey('sent_at')) {
      context.handle(
        _sentAtMeta,
        sentAt.isAcceptableOrUnknown(data['sent_at']!, _sentAtMeta),
      );
    } else if (isInserting) {
      context.missing(_sentAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SlackMessageRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SlackMessageRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      accountId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}account_id'],
      )!,
      conversationId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}conversation_id'],
      )!,
      messageTs: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}message_ts'],
      )!,
      threadTs: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}thread_ts'],
      ),
      senderName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}sender_name'],
      ),
      senderUserId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}sender_user_id'],
      ),
      body: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}body'],
      )!,
      isOutgoing: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_outgoing'],
      )!,
      replyCount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}reply_count'],
      )!,
      reactionsJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}reactions_json'],
      )!,
      filesJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}files_json'],
      )!,
      isEdited: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_edited'],
      )!,
      sentAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}sent_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $SlackMessagesTable createAlias(String alias) {
    return $SlackMessagesTable(attachedDatabase, alias);
  }
}

class SlackMessageRow extends DataClass implements Insertable<SlackMessageRow> {
  final String id;
  final String accountId;
  final String conversationId;
  final String messageTs;
  final String? threadTs;
  final String? senderName;
  final String? senderUserId;
  final String body;
  final bool isOutgoing;
  final int replyCount;

  /// JSON list of {name, count, isMine}.
  final String reactionsJson;

  /// JSON list of {id, name, mimetype, urlPrivate, thumbUrl}.
  final String filesJson;
  final bool isEdited;
  final DateTime sentAt;
  final DateTime updatedAt;
  const SlackMessageRow({
    required this.id,
    required this.accountId,
    required this.conversationId,
    required this.messageTs,
    this.threadTs,
    this.senderName,
    this.senderUserId,
    required this.body,
    required this.isOutgoing,
    required this.replyCount,
    required this.reactionsJson,
    required this.filesJson,
    required this.isEdited,
    required this.sentAt,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['account_id'] = Variable<String>(accountId);
    map['conversation_id'] = Variable<String>(conversationId);
    map['message_ts'] = Variable<String>(messageTs);
    if (!nullToAbsent || threadTs != null) {
      map['thread_ts'] = Variable<String>(threadTs);
    }
    if (!nullToAbsent || senderName != null) {
      map['sender_name'] = Variable<String>(senderName);
    }
    if (!nullToAbsent || senderUserId != null) {
      map['sender_user_id'] = Variable<String>(senderUserId);
    }
    map['body'] = Variable<String>(body);
    map['is_outgoing'] = Variable<bool>(isOutgoing);
    map['reply_count'] = Variable<int>(replyCount);
    map['reactions_json'] = Variable<String>(reactionsJson);
    map['files_json'] = Variable<String>(filesJson);
    map['is_edited'] = Variable<bool>(isEdited);
    map['sent_at'] = Variable<DateTime>(sentAt);
    map['updated_at'] = Variable<DateTime>(updatedAt);
    return map;
  }

  SlackMessagesCompanion toCompanion(bool nullToAbsent) {
    return SlackMessagesCompanion(
      id: Value(id),
      accountId: Value(accountId),
      conversationId: Value(conversationId),
      messageTs: Value(messageTs),
      threadTs: threadTs == null && nullToAbsent
          ? const Value.absent()
          : Value(threadTs),
      senderName: senderName == null && nullToAbsent
          ? const Value.absent()
          : Value(senderName),
      senderUserId: senderUserId == null && nullToAbsent
          ? const Value.absent()
          : Value(senderUserId),
      body: Value(body),
      isOutgoing: Value(isOutgoing),
      replyCount: Value(replyCount),
      reactionsJson: Value(reactionsJson),
      filesJson: Value(filesJson),
      isEdited: Value(isEdited),
      sentAt: Value(sentAt),
      updatedAt: Value(updatedAt),
    );
  }

  factory SlackMessageRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SlackMessageRow(
      id: serializer.fromJson<String>(json['id']),
      accountId: serializer.fromJson<String>(json['accountId']),
      conversationId: serializer.fromJson<String>(json['conversationId']),
      messageTs: serializer.fromJson<String>(json['messageTs']),
      threadTs: serializer.fromJson<String?>(json['threadTs']),
      senderName: serializer.fromJson<String?>(json['senderName']),
      senderUserId: serializer.fromJson<String?>(json['senderUserId']),
      body: serializer.fromJson<String>(json['body']),
      isOutgoing: serializer.fromJson<bool>(json['isOutgoing']),
      replyCount: serializer.fromJson<int>(json['replyCount']),
      reactionsJson: serializer.fromJson<String>(json['reactionsJson']),
      filesJson: serializer.fromJson<String>(json['filesJson']),
      isEdited: serializer.fromJson<bool>(json['isEdited']),
      sentAt: serializer.fromJson<DateTime>(json['sentAt']),
      updatedAt: serializer.fromJson<DateTime>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'accountId': serializer.toJson<String>(accountId),
      'conversationId': serializer.toJson<String>(conversationId),
      'messageTs': serializer.toJson<String>(messageTs),
      'threadTs': serializer.toJson<String?>(threadTs),
      'senderName': serializer.toJson<String?>(senderName),
      'senderUserId': serializer.toJson<String?>(senderUserId),
      'body': serializer.toJson<String>(body),
      'isOutgoing': serializer.toJson<bool>(isOutgoing),
      'replyCount': serializer.toJson<int>(replyCount),
      'reactionsJson': serializer.toJson<String>(reactionsJson),
      'filesJson': serializer.toJson<String>(filesJson),
      'isEdited': serializer.toJson<bool>(isEdited),
      'sentAt': serializer.toJson<DateTime>(sentAt),
      'updatedAt': serializer.toJson<DateTime>(updatedAt),
    };
  }

  SlackMessageRow copyWith({
    String? id,
    String? accountId,
    String? conversationId,
    String? messageTs,
    Value<String?> threadTs = const Value.absent(),
    Value<String?> senderName = const Value.absent(),
    Value<String?> senderUserId = const Value.absent(),
    String? body,
    bool? isOutgoing,
    int? replyCount,
    String? reactionsJson,
    String? filesJson,
    bool? isEdited,
    DateTime? sentAt,
    DateTime? updatedAt,
  }) => SlackMessageRow(
    id: id ?? this.id,
    accountId: accountId ?? this.accountId,
    conversationId: conversationId ?? this.conversationId,
    messageTs: messageTs ?? this.messageTs,
    threadTs: threadTs.present ? threadTs.value : this.threadTs,
    senderName: senderName.present ? senderName.value : this.senderName,
    senderUserId: senderUserId.present ? senderUserId.value : this.senderUserId,
    body: body ?? this.body,
    isOutgoing: isOutgoing ?? this.isOutgoing,
    replyCount: replyCount ?? this.replyCount,
    reactionsJson: reactionsJson ?? this.reactionsJson,
    filesJson: filesJson ?? this.filesJson,
    isEdited: isEdited ?? this.isEdited,
    sentAt: sentAt ?? this.sentAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  SlackMessageRow copyWithCompanion(SlackMessagesCompanion data) {
    return SlackMessageRow(
      id: data.id.present ? data.id.value : this.id,
      accountId: data.accountId.present ? data.accountId.value : this.accountId,
      conversationId: data.conversationId.present
          ? data.conversationId.value
          : this.conversationId,
      messageTs: data.messageTs.present ? data.messageTs.value : this.messageTs,
      threadTs: data.threadTs.present ? data.threadTs.value : this.threadTs,
      senderName: data.senderName.present
          ? data.senderName.value
          : this.senderName,
      senderUserId: data.senderUserId.present
          ? data.senderUserId.value
          : this.senderUserId,
      body: data.body.present ? data.body.value : this.body,
      isOutgoing: data.isOutgoing.present
          ? data.isOutgoing.value
          : this.isOutgoing,
      replyCount: data.replyCount.present
          ? data.replyCount.value
          : this.replyCount,
      reactionsJson: data.reactionsJson.present
          ? data.reactionsJson.value
          : this.reactionsJson,
      filesJson: data.filesJson.present ? data.filesJson.value : this.filesJson,
      isEdited: data.isEdited.present ? data.isEdited.value : this.isEdited,
      sentAt: data.sentAt.present ? data.sentAt.value : this.sentAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SlackMessageRow(')
          ..write('id: $id, ')
          ..write('accountId: $accountId, ')
          ..write('conversationId: $conversationId, ')
          ..write('messageTs: $messageTs, ')
          ..write('threadTs: $threadTs, ')
          ..write('senderName: $senderName, ')
          ..write('senderUserId: $senderUserId, ')
          ..write('body: $body, ')
          ..write('isOutgoing: $isOutgoing, ')
          ..write('replyCount: $replyCount, ')
          ..write('reactionsJson: $reactionsJson, ')
          ..write('filesJson: $filesJson, ')
          ..write('isEdited: $isEdited, ')
          ..write('sentAt: $sentAt, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    accountId,
    conversationId,
    messageTs,
    threadTs,
    senderName,
    senderUserId,
    body,
    isOutgoing,
    replyCount,
    reactionsJson,
    filesJson,
    isEdited,
    sentAt,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SlackMessageRow &&
          other.id == this.id &&
          other.accountId == this.accountId &&
          other.conversationId == this.conversationId &&
          other.messageTs == this.messageTs &&
          other.threadTs == this.threadTs &&
          other.senderName == this.senderName &&
          other.senderUserId == this.senderUserId &&
          other.body == this.body &&
          other.isOutgoing == this.isOutgoing &&
          other.replyCount == this.replyCount &&
          other.reactionsJson == this.reactionsJson &&
          other.filesJson == this.filesJson &&
          other.isEdited == this.isEdited &&
          other.sentAt == this.sentAt &&
          other.updatedAt == this.updatedAt);
}

class SlackMessagesCompanion extends UpdateCompanion<SlackMessageRow> {
  final Value<String> id;
  final Value<String> accountId;
  final Value<String> conversationId;
  final Value<String> messageTs;
  final Value<String?> threadTs;
  final Value<String?> senderName;
  final Value<String?> senderUserId;
  final Value<String> body;
  final Value<bool> isOutgoing;
  final Value<int> replyCount;
  final Value<String> reactionsJson;
  final Value<String> filesJson;
  final Value<bool> isEdited;
  final Value<DateTime> sentAt;
  final Value<DateTime> updatedAt;
  final Value<int> rowid;
  const SlackMessagesCompanion({
    this.id = const Value.absent(),
    this.accountId = const Value.absent(),
    this.conversationId = const Value.absent(),
    this.messageTs = const Value.absent(),
    this.threadTs = const Value.absent(),
    this.senderName = const Value.absent(),
    this.senderUserId = const Value.absent(),
    this.body = const Value.absent(),
    this.isOutgoing = const Value.absent(),
    this.replyCount = const Value.absent(),
    this.reactionsJson = const Value.absent(),
    this.filesJson = const Value.absent(),
    this.isEdited = const Value.absent(),
    this.sentAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SlackMessagesCompanion.insert({
    required String id,
    required String accountId,
    required String conversationId,
    required String messageTs,
    this.threadTs = const Value.absent(),
    this.senderName = const Value.absent(),
    this.senderUserId = const Value.absent(),
    required String body,
    this.isOutgoing = const Value.absent(),
    this.replyCount = const Value.absent(),
    this.reactionsJson = const Value.absent(),
    this.filesJson = const Value.absent(),
    this.isEdited = const Value.absent(),
    required DateTime sentAt,
    required DateTime updatedAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       accountId = Value(accountId),
       conversationId = Value(conversationId),
       messageTs = Value(messageTs),
       body = Value(body),
       sentAt = Value(sentAt),
       updatedAt = Value(updatedAt);
  static Insertable<SlackMessageRow> custom({
    Expression<String>? id,
    Expression<String>? accountId,
    Expression<String>? conversationId,
    Expression<String>? messageTs,
    Expression<String>? threadTs,
    Expression<String>? senderName,
    Expression<String>? senderUserId,
    Expression<String>? body,
    Expression<bool>? isOutgoing,
    Expression<int>? replyCount,
    Expression<String>? reactionsJson,
    Expression<String>? filesJson,
    Expression<bool>? isEdited,
    Expression<DateTime>? sentAt,
    Expression<DateTime>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (accountId != null) 'account_id': accountId,
      if (conversationId != null) 'conversation_id': conversationId,
      if (messageTs != null) 'message_ts': messageTs,
      if (threadTs != null) 'thread_ts': threadTs,
      if (senderName != null) 'sender_name': senderName,
      if (senderUserId != null) 'sender_user_id': senderUserId,
      if (body != null) 'body': body,
      if (isOutgoing != null) 'is_outgoing': isOutgoing,
      if (replyCount != null) 'reply_count': replyCount,
      if (reactionsJson != null) 'reactions_json': reactionsJson,
      if (filesJson != null) 'files_json': filesJson,
      if (isEdited != null) 'is_edited': isEdited,
      if (sentAt != null) 'sent_at': sentAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SlackMessagesCompanion copyWith({
    Value<String>? id,
    Value<String>? accountId,
    Value<String>? conversationId,
    Value<String>? messageTs,
    Value<String?>? threadTs,
    Value<String?>? senderName,
    Value<String?>? senderUserId,
    Value<String>? body,
    Value<bool>? isOutgoing,
    Value<int>? replyCount,
    Value<String>? reactionsJson,
    Value<String>? filesJson,
    Value<bool>? isEdited,
    Value<DateTime>? sentAt,
    Value<DateTime>? updatedAt,
    Value<int>? rowid,
  }) {
    return SlackMessagesCompanion(
      id: id ?? this.id,
      accountId: accountId ?? this.accountId,
      conversationId: conversationId ?? this.conversationId,
      messageTs: messageTs ?? this.messageTs,
      threadTs: threadTs ?? this.threadTs,
      senderName: senderName ?? this.senderName,
      senderUserId: senderUserId ?? this.senderUserId,
      body: body ?? this.body,
      isOutgoing: isOutgoing ?? this.isOutgoing,
      replyCount: replyCount ?? this.replyCount,
      reactionsJson: reactionsJson ?? this.reactionsJson,
      filesJson: filesJson ?? this.filesJson,
      isEdited: isEdited ?? this.isEdited,
      sentAt: sentAt ?? this.sentAt,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (accountId.present) {
      map['account_id'] = Variable<String>(accountId.value);
    }
    if (conversationId.present) {
      map['conversation_id'] = Variable<String>(conversationId.value);
    }
    if (messageTs.present) {
      map['message_ts'] = Variable<String>(messageTs.value);
    }
    if (threadTs.present) {
      map['thread_ts'] = Variable<String>(threadTs.value);
    }
    if (senderName.present) {
      map['sender_name'] = Variable<String>(senderName.value);
    }
    if (senderUserId.present) {
      map['sender_user_id'] = Variable<String>(senderUserId.value);
    }
    if (body.present) {
      map['body'] = Variable<String>(body.value);
    }
    if (isOutgoing.present) {
      map['is_outgoing'] = Variable<bool>(isOutgoing.value);
    }
    if (replyCount.present) {
      map['reply_count'] = Variable<int>(replyCount.value);
    }
    if (reactionsJson.present) {
      map['reactions_json'] = Variable<String>(reactionsJson.value);
    }
    if (filesJson.present) {
      map['files_json'] = Variable<String>(filesJson.value);
    }
    if (isEdited.present) {
      map['is_edited'] = Variable<bool>(isEdited.value);
    }
    if (sentAt.present) {
      map['sent_at'] = Variable<DateTime>(sentAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<DateTime>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SlackMessagesCompanion(')
          ..write('id: $id, ')
          ..write('accountId: $accountId, ')
          ..write('conversationId: $conversationId, ')
          ..write('messageTs: $messageTs, ')
          ..write('threadTs: $threadTs, ')
          ..write('senderName: $senderName, ')
          ..write('senderUserId: $senderUserId, ')
          ..write('body: $body, ')
          ..write('isOutgoing: $isOutgoing, ')
          ..write('replyCount: $replyCount, ')
          ..write('reactionsJson: $reactionsJson, ')
          ..write('filesJson: $filesJson, ')
          ..write('isEdited: $isEdited, ')
          ..write('sentAt: $sentAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $BrowserBookmarksTable extends BrowserBookmarks
    with TableInfo<$BrowserBookmarksTable, BrowserBookmarkRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $BrowserBookmarksTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _titleMeta = const VerificationMeta('title');
  @override
  late final GeneratedColumn<String> title = GeneratedColumn<String>(
    'title',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 200,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _urlMeta = const VerificationMeta('url');
  @override
  late final GeneratedColumn<String> url = GeneratedColumn<String>(
    'url',
    aliasedName,
    false,
    additionalChecks: GeneratedColumn.checkTextLength(
      minTextLength: 1,
      maxTextLength: 2000,
    ),
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _faviconUrlMeta = const VerificationMeta(
    'faviconUrl',
  );
  @override
  late final GeneratedColumn<String> faviconUrl = GeneratedColumn<String>(
    'favicon_url',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _sortOrderMeta = const VerificationMeta(
    'sortOrder',
  );
  @override
  late final GeneratedColumn<int> sortOrder = GeneratedColumn<int>(
    'sort_order',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _createdAtMeta = const VerificationMeta(
    'createdAt',
  );
  @override
  late final GeneratedColumn<DateTime> createdAt = GeneratedColumn<DateTime>(
    'created_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    title,
    url,
    faviconUrl,
    sortOrder,
    createdAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'browser_bookmarks';
  @override
  VerificationContext validateIntegrity(
    Insertable<BrowserBookmarkRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('title')) {
      context.handle(
        _titleMeta,
        title.isAcceptableOrUnknown(data['title']!, _titleMeta),
      );
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('url')) {
      context.handle(
        _urlMeta,
        url.isAcceptableOrUnknown(data['url']!, _urlMeta),
      );
    } else if (isInserting) {
      context.missing(_urlMeta);
    }
    if (data.containsKey('favicon_url')) {
      context.handle(
        _faviconUrlMeta,
        faviconUrl.isAcceptableOrUnknown(data['favicon_url']!, _faviconUrlMeta),
      );
    }
    if (data.containsKey('sort_order')) {
      context.handle(
        _sortOrderMeta,
        sortOrder.isAcceptableOrUnknown(data['sort_order']!, _sortOrderMeta),
      );
    }
    if (data.containsKey('created_at')) {
      context.handle(
        _createdAtMeta,
        createdAt.isAcceptableOrUnknown(data['created_at']!, _createdAtMeta),
      );
    } else if (isInserting) {
      context.missing(_createdAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  BrowserBookmarkRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return BrowserBookmarkRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      title: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}title'],
      )!,
      url: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}url'],
      )!,
      faviconUrl: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}favicon_url'],
      ),
      sortOrder: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sort_order'],
      )!,
      createdAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}created_at'],
      )!,
    );
  }

  @override
  $BrowserBookmarksTable createAlias(String alias) {
    return $BrowserBookmarksTable(attachedDatabase, alias);
  }
}

class BrowserBookmarkRow extends DataClass
    implements Insertable<BrowserBookmarkRow> {
  final String id;
  final String title;
  final String url;
  final String? faviconUrl;
  final int sortOrder;
  final DateTime createdAt;
  const BrowserBookmarkRow({
    required this.id,
    required this.title,
    required this.url,
    this.faviconUrl,
    required this.sortOrder,
    required this.createdAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['title'] = Variable<String>(title);
    map['url'] = Variable<String>(url);
    if (!nullToAbsent || faviconUrl != null) {
      map['favicon_url'] = Variable<String>(faviconUrl);
    }
    map['sort_order'] = Variable<int>(sortOrder);
    map['created_at'] = Variable<DateTime>(createdAt);
    return map;
  }

  BrowserBookmarksCompanion toCompanion(bool nullToAbsent) {
    return BrowserBookmarksCompanion(
      id: Value(id),
      title: Value(title),
      url: Value(url),
      faviconUrl: faviconUrl == null && nullToAbsent
          ? const Value.absent()
          : Value(faviconUrl),
      sortOrder: Value(sortOrder),
      createdAt: Value(createdAt),
    );
  }

  factory BrowserBookmarkRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return BrowserBookmarkRow(
      id: serializer.fromJson<String>(json['id']),
      title: serializer.fromJson<String>(json['title']),
      url: serializer.fromJson<String>(json['url']),
      faviconUrl: serializer.fromJson<String?>(json['faviconUrl']),
      sortOrder: serializer.fromJson<int>(json['sortOrder']),
      createdAt: serializer.fromJson<DateTime>(json['createdAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'title': serializer.toJson<String>(title),
      'url': serializer.toJson<String>(url),
      'faviconUrl': serializer.toJson<String?>(faviconUrl),
      'sortOrder': serializer.toJson<int>(sortOrder),
      'createdAt': serializer.toJson<DateTime>(createdAt),
    };
  }

  BrowserBookmarkRow copyWith({
    String? id,
    String? title,
    String? url,
    Value<String?> faviconUrl = const Value.absent(),
    int? sortOrder,
    DateTime? createdAt,
  }) => BrowserBookmarkRow(
    id: id ?? this.id,
    title: title ?? this.title,
    url: url ?? this.url,
    faviconUrl: faviconUrl.present ? faviconUrl.value : this.faviconUrl,
    sortOrder: sortOrder ?? this.sortOrder,
    createdAt: createdAt ?? this.createdAt,
  );
  BrowserBookmarkRow copyWithCompanion(BrowserBookmarksCompanion data) {
    return BrowserBookmarkRow(
      id: data.id.present ? data.id.value : this.id,
      title: data.title.present ? data.title.value : this.title,
      url: data.url.present ? data.url.value : this.url,
      faviconUrl: data.faviconUrl.present
          ? data.faviconUrl.value
          : this.faviconUrl,
      sortOrder: data.sortOrder.present ? data.sortOrder.value : this.sortOrder,
      createdAt: data.createdAt.present ? data.createdAt.value : this.createdAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('BrowserBookmarkRow(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('url: $url, ')
          ..write('faviconUrl: $faviconUrl, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('createdAt: $createdAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode =>
      Object.hash(id, title, url, faviconUrl, sortOrder, createdAt);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is BrowserBookmarkRow &&
          other.id == this.id &&
          other.title == this.title &&
          other.url == this.url &&
          other.faviconUrl == this.faviconUrl &&
          other.sortOrder == this.sortOrder &&
          other.createdAt == this.createdAt);
}

class BrowserBookmarksCompanion extends UpdateCompanion<BrowserBookmarkRow> {
  final Value<String> id;
  final Value<String> title;
  final Value<String> url;
  final Value<String?> faviconUrl;
  final Value<int> sortOrder;
  final Value<DateTime> createdAt;
  final Value<int> rowid;
  const BrowserBookmarksCompanion({
    this.id = const Value.absent(),
    this.title = const Value.absent(),
    this.url = const Value.absent(),
    this.faviconUrl = const Value.absent(),
    this.sortOrder = const Value.absent(),
    this.createdAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  BrowserBookmarksCompanion.insert({
    required String id,
    required String title,
    required String url,
    this.faviconUrl = const Value.absent(),
    this.sortOrder = const Value.absent(),
    required DateTime createdAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       title = Value(title),
       url = Value(url),
       createdAt = Value(createdAt);
  static Insertable<BrowserBookmarkRow> custom({
    Expression<String>? id,
    Expression<String>? title,
    Expression<String>? url,
    Expression<String>? faviconUrl,
    Expression<int>? sortOrder,
    Expression<DateTime>? createdAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (title != null) 'title': title,
      if (url != null) 'url': url,
      if (faviconUrl != null) 'favicon_url': faviconUrl,
      if (sortOrder != null) 'sort_order': sortOrder,
      if (createdAt != null) 'created_at': createdAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  BrowserBookmarksCompanion copyWith({
    Value<String>? id,
    Value<String>? title,
    Value<String>? url,
    Value<String?>? faviconUrl,
    Value<int>? sortOrder,
    Value<DateTime>? createdAt,
    Value<int>? rowid,
  }) {
    return BrowserBookmarksCompanion(
      id: id ?? this.id,
      title: title ?? this.title,
      url: url ?? this.url,
      faviconUrl: faviconUrl ?? this.faviconUrl,
      sortOrder: sortOrder ?? this.sortOrder,
      createdAt: createdAt ?? this.createdAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (url.present) {
      map['url'] = Variable<String>(url.value);
    }
    if (faviconUrl.present) {
      map['favicon_url'] = Variable<String>(faviconUrl.value);
    }
    if (sortOrder.present) {
      map['sort_order'] = Variable<int>(sortOrder.value);
    }
    if (createdAt.present) {
      map['created_at'] = Variable<DateTime>(createdAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('BrowserBookmarksCompanion(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('url: $url, ')
          ..write('faviconUrl: $faviconUrl, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('createdAt: $createdAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $SystemMetricSamplesTable extends SystemMetricSamples
    with TableInfo<$SystemMetricSamplesTable, SystemMetricSampleRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SystemMetricSamplesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _capturedAtMeta = const VerificationMeta(
    'capturedAt',
  );
  @override
  late final GeneratedColumn<DateTime> capturedAt = GeneratedColumn<DateTime>(
    'captured_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _ramUsedMbMeta = const VerificationMeta(
    'ramUsedMb',
  );
  @override
  late final GeneratedColumn<int> ramUsedMb = GeneratedColumn<int>(
    'ram_used_mb',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _ramTotalMbMeta = const VerificationMeta(
    'ramTotalMb',
  );
  @override
  late final GeneratedColumn<int> ramTotalMb = GeneratedColumn<int>(
    'ram_total_mb',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _cpuPercentMeta = const VerificationMeta(
    'cpuPercent',
  );
  @override
  late final GeneratedColumn<double> cpuPercent = GeneratedColumn<double>(
    'cpu_percent',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _diskUsedMbMeta = const VerificationMeta(
    'diskUsedMb',
  );
  @override
  late final GeneratedColumn<int> diskUsedMb = GeneratedColumn<int>(
    'disk_used_mb',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _diskTotalMbMeta = const VerificationMeta(
    'diskTotalMb',
  );
  @override
  late final GeneratedColumn<int> diskTotalMb = GeneratedColumn<int>(
    'disk_total_mb',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _loadAvg1Meta = const VerificationMeta(
    'loadAvg1',
  );
  @override
  late final GeneratedColumn<double> loadAvg1 = GeneratedColumn<double>(
    'load_avg1',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _hostnameMeta = const VerificationMeta(
    'hostname',
  );
  @override
  late final GeneratedColumn<String> hostname = GeneratedColumn<String>(
    'hostname',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _platformLabelMeta = const VerificationMeta(
    'platformLabel',
  );
  @override
  late final GeneratedColumn<String> platformLabel = GeneratedColumn<String>(
    'platform_label',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    capturedAt,
    ramUsedMb,
    ramTotalMb,
    cpuPercent,
    diskUsedMb,
    diskTotalMb,
    loadAvg1,
    hostname,
    platformLabel,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'system_metric_samples';
  @override
  VerificationContext validateIntegrity(
    Insertable<SystemMetricSampleRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('captured_at')) {
      context.handle(
        _capturedAtMeta,
        capturedAt.isAcceptableOrUnknown(data['captured_at']!, _capturedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_capturedAtMeta);
    }
    if (data.containsKey('ram_used_mb')) {
      context.handle(
        _ramUsedMbMeta,
        ramUsedMb.isAcceptableOrUnknown(data['ram_used_mb']!, _ramUsedMbMeta),
      );
    } else if (isInserting) {
      context.missing(_ramUsedMbMeta);
    }
    if (data.containsKey('ram_total_mb')) {
      context.handle(
        _ramTotalMbMeta,
        ramTotalMb.isAcceptableOrUnknown(
          data['ram_total_mb']!,
          _ramTotalMbMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_ramTotalMbMeta);
    }
    if (data.containsKey('cpu_percent')) {
      context.handle(
        _cpuPercentMeta,
        cpuPercent.isAcceptableOrUnknown(data['cpu_percent']!, _cpuPercentMeta),
      );
    } else if (isInserting) {
      context.missing(_cpuPercentMeta);
    }
    if (data.containsKey('disk_used_mb')) {
      context.handle(
        _diskUsedMbMeta,
        diskUsedMb.isAcceptableOrUnknown(
          data['disk_used_mb']!,
          _diskUsedMbMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_diskUsedMbMeta);
    }
    if (data.containsKey('disk_total_mb')) {
      context.handle(
        _diskTotalMbMeta,
        diskTotalMb.isAcceptableOrUnknown(
          data['disk_total_mb']!,
          _diskTotalMbMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_diskTotalMbMeta);
    }
    if (data.containsKey('load_avg1')) {
      context.handle(
        _loadAvg1Meta,
        loadAvg1.isAcceptableOrUnknown(data['load_avg1']!, _loadAvg1Meta),
      );
    }
    if (data.containsKey('hostname')) {
      context.handle(
        _hostnameMeta,
        hostname.isAcceptableOrUnknown(data['hostname']!, _hostnameMeta),
      );
    }
    if (data.containsKey('platform_label')) {
      context.handle(
        _platformLabelMeta,
        platformLabel.isAcceptableOrUnknown(
          data['platform_label']!,
          _platformLabelMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SystemMetricSampleRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SystemMetricSampleRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      capturedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}captured_at'],
      )!,
      ramUsedMb: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}ram_used_mb'],
      )!,
      ramTotalMb: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}ram_total_mb'],
      )!,
      cpuPercent: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}cpu_percent'],
      )!,
      diskUsedMb: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}disk_used_mb'],
      )!,
      diskTotalMb: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}disk_total_mb'],
      )!,
      loadAvg1: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}load_avg1'],
      ),
      hostname: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}hostname'],
      ),
      platformLabel: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}platform_label'],
      ),
    );
  }

  @override
  $SystemMetricSamplesTable createAlias(String alias) {
    return $SystemMetricSamplesTable(attachedDatabase, alias);
  }
}

class SystemMetricSampleRow extends DataClass
    implements Insertable<SystemMetricSampleRow> {
  final String id;
  final DateTime capturedAt;

  /// Host RAM used, megabytes.
  final int ramUsedMb;
  final int ramTotalMb;

  /// 0–100 CPU utilization estimate.
  final double cpuPercent;

  /// Root (or primary) volume used / total, megabytes.
  final int diskUsedMb;
  final int diskTotalMb;

  /// 1-minute load average when available.
  final double? loadAvg1;
  final String? hostname;
  final String? platformLabel;
  const SystemMetricSampleRow({
    required this.id,
    required this.capturedAt,
    required this.ramUsedMb,
    required this.ramTotalMb,
    required this.cpuPercent,
    required this.diskUsedMb,
    required this.diskTotalMb,
    this.loadAvg1,
    this.hostname,
    this.platformLabel,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['captured_at'] = Variable<DateTime>(capturedAt);
    map['ram_used_mb'] = Variable<int>(ramUsedMb);
    map['ram_total_mb'] = Variable<int>(ramTotalMb);
    map['cpu_percent'] = Variable<double>(cpuPercent);
    map['disk_used_mb'] = Variable<int>(diskUsedMb);
    map['disk_total_mb'] = Variable<int>(diskTotalMb);
    if (!nullToAbsent || loadAvg1 != null) {
      map['load_avg1'] = Variable<double>(loadAvg1);
    }
    if (!nullToAbsent || hostname != null) {
      map['hostname'] = Variable<String>(hostname);
    }
    if (!nullToAbsent || platformLabel != null) {
      map['platform_label'] = Variable<String>(platformLabel);
    }
    return map;
  }

  SystemMetricSamplesCompanion toCompanion(bool nullToAbsent) {
    return SystemMetricSamplesCompanion(
      id: Value(id),
      capturedAt: Value(capturedAt),
      ramUsedMb: Value(ramUsedMb),
      ramTotalMb: Value(ramTotalMb),
      cpuPercent: Value(cpuPercent),
      diskUsedMb: Value(diskUsedMb),
      diskTotalMb: Value(diskTotalMb),
      loadAvg1: loadAvg1 == null && nullToAbsent
          ? const Value.absent()
          : Value(loadAvg1),
      hostname: hostname == null && nullToAbsent
          ? const Value.absent()
          : Value(hostname),
      platformLabel: platformLabel == null && nullToAbsent
          ? const Value.absent()
          : Value(platformLabel),
    );
  }

  factory SystemMetricSampleRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SystemMetricSampleRow(
      id: serializer.fromJson<String>(json['id']),
      capturedAt: serializer.fromJson<DateTime>(json['capturedAt']),
      ramUsedMb: serializer.fromJson<int>(json['ramUsedMb']),
      ramTotalMb: serializer.fromJson<int>(json['ramTotalMb']),
      cpuPercent: serializer.fromJson<double>(json['cpuPercent']),
      diskUsedMb: serializer.fromJson<int>(json['diskUsedMb']),
      diskTotalMb: serializer.fromJson<int>(json['diskTotalMb']),
      loadAvg1: serializer.fromJson<double?>(json['loadAvg1']),
      hostname: serializer.fromJson<String?>(json['hostname']),
      platformLabel: serializer.fromJson<String?>(json['platformLabel']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'capturedAt': serializer.toJson<DateTime>(capturedAt),
      'ramUsedMb': serializer.toJson<int>(ramUsedMb),
      'ramTotalMb': serializer.toJson<int>(ramTotalMb),
      'cpuPercent': serializer.toJson<double>(cpuPercent),
      'diskUsedMb': serializer.toJson<int>(diskUsedMb),
      'diskTotalMb': serializer.toJson<int>(diskTotalMb),
      'loadAvg1': serializer.toJson<double?>(loadAvg1),
      'hostname': serializer.toJson<String?>(hostname),
      'platformLabel': serializer.toJson<String?>(platformLabel),
    };
  }

  SystemMetricSampleRow copyWith({
    String? id,
    DateTime? capturedAt,
    int? ramUsedMb,
    int? ramTotalMb,
    double? cpuPercent,
    int? diskUsedMb,
    int? diskTotalMb,
    Value<double?> loadAvg1 = const Value.absent(),
    Value<String?> hostname = const Value.absent(),
    Value<String?> platformLabel = const Value.absent(),
  }) => SystemMetricSampleRow(
    id: id ?? this.id,
    capturedAt: capturedAt ?? this.capturedAt,
    ramUsedMb: ramUsedMb ?? this.ramUsedMb,
    ramTotalMb: ramTotalMb ?? this.ramTotalMb,
    cpuPercent: cpuPercent ?? this.cpuPercent,
    diskUsedMb: diskUsedMb ?? this.diskUsedMb,
    diskTotalMb: diskTotalMb ?? this.diskTotalMb,
    loadAvg1: loadAvg1.present ? loadAvg1.value : this.loadAvg1,
    hostname: hostname.present ? hostname.value : this.hostname,
    platformLabel: platformLabel.present
        ? platformLabel.value
        : this.platformLabel,
  );
  SystemMetricSampleRow copyWithCompanion(SystemMetricSamplesCompanion data) {
    return SystemMetricSampleRow(
      id: data.id.present ? data.id.value : this.id,
      capturedAt: data.capturedAt.present
          ? data.capturedAt.value
          : this.capturedAt,
      ramUsedMb: data.ramUsedMb.present ? data.ramUsedMb.value : this.ramUsedMb,
      ramTotalMb: data.ramTotalMb.present
          ? data.ramTotalMb.value
          : this.ramTotalMb,
      cpuPercent: data.cpuPercent.present
          ? data.cpuPercent.value
          : this.cpuPercent,
      diskUsedMb: data.diskUsedMb.present
          ? data.diskUsedMb.value
          : this.diskUsedMb,
      diskTotalMb: data.diskTotalMb.present
          ? data.diskTotalMb.value
          : this.diskTotalMb,
      loadAvg1: data.loadAvg1.present ? data.loadAvg1.value : this.loadAvg1,
      hostname: data.hostname.present ? data.hostname.value : this.hostname,
      platformLabel: data.platformLabel.present
          ? data.platformLabel.value
          : this.platformLabel,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SystemMetricSampleRow(')
          ..write('id: $id, ')
          ..write('capturedAt: $capturedAt, ')
          ..write('ramUsedMb: $ramUsedMb, ')
          ..write('ramTotalMb: $ramTotalMb, ')
          ..write('cpuPercent: $cpuPercent, ')
          ..write('diskUsedMb: $diskUsedMb, ')
          ..write('diskTotalMb: $diskTotalMb, ')
          ..write('loadAvg1: $loadAvg1, ')
          ..write('hostname: $hostname, ')
          ..write('platformLabel: $platformLabel')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    capturedAt,
    ramUsedMb,
    ramTotalMb,
    cpuPercent,
    diskUsedMb,
    diskTotalMb,
    loadAvg1,
    hostname,
    platformLabel,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SystemMetricSampleRow &&
          other.id == this.id &&
          other.capturedAt == this.capturedAt &&
          other.ramUsedMb == this.ramUsedMb &&
          other.ramTotalMb == this.ramTotalMb &&
          other.cpuPercent == this.cpuPercent &&
          other.diskUsedMb == this.diskUsedMb &&
          other.diskTotalMb == this.diskTotalMb &&
          other.loadAvg1 == this.loadAvg1 &&
          other.hostname == this.hostname &&
          other.platformLabel == this.platformLabel);
}

class SystemMetricSamplesCompanion
    extends UpdateCompanion<SystemMetricSampleRow> {
  final Value<String> id;
  final Value<DateTime> capturedAt;
  final Value<int> ramUsedMb;
  final Value<int> ramTotalMb;
  final Value<double> cpuPercent;
  final Value<int> diskUsedMb;
  final Value<int> diskTotalMb;
  final Value<double?> loadAvg1;
  final Value<String?> hostname;
  final Value<String?> platformLabel;
  final Value<int> rowid;
  const SystemMetricSamplesCompanion({
    this.id = const Value.absent(),
    this.capturedAt = const Value.absent(),
    this.ramUsedMb = const Value.absent(),
    this.ramTotalMb = const Value.absent(),
    this.cpuPercent = const Value.absent(),
    this.diskUsedMb = const Value.absent(),
    this.diskTotalMb = const Value.absent(),
    this.loadAvg1 = const Value.absent(),
    this.hostname = const Value.absent(),
    this.platformLabel = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SystemMetricSamplesCompanion.insert({
    required String id,
    required DateTime capturedAt,
    required int ramUsedMb,
    required int ramTotalMb,
    required double cpuPercent,
    required int diskUsedMb,
    required int diskTotalMb,
    this.loadAvg1 = const Value.absent(),
    this.hostname = const Value.absent(),
    this.platformLabel = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       capturedAt = Value(capturedAt),
       ramUsedMb = Value(ramUsedMb),
       ramTotalMb = Value(ramTotalMb),
       cpuPercent = Value(cpuPercent),
       diskUsedMb = Value(diskUsedMb),
       diskTotalMb = Value(diskTotalMb);
  static Insertable<SystemMetricSampleRow> custom({
    Expression<String>? id,
    Expression<DateTime>? capturedAt,
    Expression<int>? ramUsedMb,
    Expression<int>? ramTotalMb,
    Expression<double>? cpuPercent,
    Expression<int>? diskUsedMb,
    Expression<int>? diskTotalMb,
    Expression<double>? loadAvg1,
    Expression<String>? hostname,
    Expression<String>? platformLabel,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (capturedAt != null) 'captured_at': capturedAt,
      if (ramUsedMb != null) 'ram_used_mb': ramUsedMb,
      if (ramTotalMb != null) 'ram_total_mb': ramTotalMb,
      if (cpuPercent != null) 'cpu_percent': cpuPercent,
      if (diskUsedMb != null) 'disk_used_mb': diskUsedMb,
      if (diskTotalMb != null) 'disk_total_mb': diskTotalMb,
      if (loadAvg1 != null) 'load_avg1': loadAvg1,
      if (hostname != null) 'hostname': hostname,
      if (platformLabel != null) 'platform_label': platformLabel,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SystemMetricSamplesCompanion copyWith({
    Value<String>? id,
    Value<DateTime>? capturedAt,
    Value<int>? ramUsedMb,
    Value<int>? ramTotalMb,
    Value<double>? cpuPercent,
    Value<int>? diskUsedMb,
    Value<int>? diskTotalMb,
    Value<double?>? loadAvg1,
    Value<String?>? hostname,
    Value<String?>? platformLabel,
    Value<int>? rowid,
  }) {
    return SystemMetricSamplesCompanion(
      id: id ?? this.id,
      capturedAt: capturedAt ?? this.capturedAt,
      ramUsedMb: ramUsedMb ?? this.ramUsedMb,
      ramTotalMb: ramTotalMb ?? this.ramTotalMb,
      cpuPercent: cpuPercent ?? this.cpuPercent,
      diskUsedMb: diskUsedMb ?? this.diskUsedMb,
      diskTotalMb: diskTotalMb ?? this.diskTotalMb,
      loadAvg1: loadAvg1 ?? this.loadAvg1,
      hostname: hostname ?? this.hostname,
      platformLabel: platformLabel ?? this.platformLabel,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (capturedAt.present) {
      map['captured_at'] = Variable<DateTime>(capturedAt.value);
    }
    if (ramUsedMb.present) {
      map['ram_used_mb'] = Variable<int>(ramUsedMb.value);
    }
    if (ramTotalMb.present) {
      map['ram_total_mb'] = Variable<int>(ramTotalMb.value);
    }
    if (cpuPercent.present) {
      map['cpu_percent'] = Variable<double>(cpuPercent.value);
    }
    if (diskUsedMb.present) {
      map['disk_used_mb'] = Variable<int>(diskUsedMb.value);
    }
    if (diskTotalMb.present) {
      map['disk_total_mb'] = Variable<int>(diskTotalMb.value);
    }
    if (loadAvg1.present) {
      map['load_avg1'] = Variable<double>(loadAvg1.value);
    }
    if (hostname.present) {
      map['hostname'] = Variable<String>(hostname.value);
    }
    if (platformLabel.present) {
      map['platform_label'] = Variable<String>(platformLabel.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SystemMetricSamplesCompanion(')
          ..write('id: $id, ')
          ..write('capturedAt: $capturedAt, ')
          ..write('ramUsedMb: $ramUsedMb, ')
          ..write('ramTotalMb: $ramTotalMb, ')
          ..write('cpuPercent: $cpuPercent, ')
          ..write('diskUsedMb: $diskUsedMb, ')
          ..write('diskTotalMb: $diskTotalMb, ')
          ..write('loadAvg1: $loadAvg1, ')
          ..write('hostname: $hostname, ')
          ..write('platformLabel: $platformLabel, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $FeatureUsageSessionsTable extends FeatureUsageSessions
    with TableInfo<$FeatureUsageSessionsTable, FeatureUsageSessionRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $FeatureUsageSessionsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _featureKeyMeta = const VerificationMeta(
    'featureKey',
  );
  @override
  late final GeneratedColumn<String> featureKey = GeneratedColumn<String>(
    'feature_key',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _featureLabelMeta = const VerificationMeta(
    'featureLabel',
  );
  @override
  late final GeneratedColumn<String> featureLabel = GeneratedColumn<String>(
    'feature_label',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _startedAtMeta = const VerificationMeta(
    'startedAt',
  );
  @override
  late final GeneratedColumn<DateTime> startedAt = GeneratedColumn<DateTime>(
    'started_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _endedAtMeta = const VerificationMeta(
    'endedAt',
  );
  @override
  late final GeneratedColumn<DateTime> endedAt = GeneratedColumn<DateTime>(
    'ended_at',
    aliasedName,
    false,
    type: DriftSqlType.dateTime,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _durationMsMeta = const VerificationMeta(
    'durationMs',
  );
  @override
  late final GeneratedColumn<int> durationMs = GeneratedColumn<int>(
    'duration_ms',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _avgRamPercentMeta = const VerificationMeta(
    'avgRamPercent',
  );
  @override
  late final GeneratedColumn<double> avgRamPercent = GeneratedColumn<double>(
    'avg_ram_percent',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _avgCpuPercentMeta = const VerificationMeta(
    'avgCpuPercent',
  );
  @override
  late final GeneratedColumn<double> avgCpuPercent = GeneratedColumn<double>(
    'avg_cpu_percent',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    featureKey,
    featureLabel,
    startedAt,
    endedAt,
    durationMs,
    avgRamPercent,
    avgCpuPercent,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'feature_usage_sessions';
  @override
  VerificationContext validateIntegrity(
    Insertable<FeatureUsageSessionRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('feature_key')) {
      context.handle(
        _featureKeyMeta,
        featureKey.isAcceptableOrUnknown(data['feature_key']!, _featureKeyMeta),
      );
    } else if (isInserting) {
      context.missing(_featureKeyMeta);
    }
    if (data.containsKey('feature_label')) {
      context.handle(
        _featureLabelMeta,
        featureLabel.isAcceptableOrUnknown(
          data['feature_label']!,
          _featureLabelMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_featureLabelMeta);
    }
    if (data.containsKey('started_at')) {
      context.handle(
        _startedAtMeta,
        startedAt.isAcceptableOrUnknown(data['started_at']!, _startedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_startedAtMeta);
    }
    if (data.containsKey('ended_at')) {
      context.handle(
        _endedAtMeta,
        endedAt.isAcceptableOrUnknown(data['ended_at']!, _endedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_endedAtMeta);
    }
    if (data.containsKey('duration_ms')) {
      context.handle(
        _durationMsMeta,
        durationMs.isAcceptableOrUnknown(data['duration_ms']!, _durationMsMeta),
      );
    } else if (isInserting) {
      context.missing(_durationMsMeta);
    }
    if (data.containsKey('avg_ram_percent')) {
      context.handle(
        _avgRamPercentMeta,
        avgRamPercent.isAcceptableOrUnknown(
          data['avg_ram_percent']!,
          _avgRamPercentMeta,
        ),
      );
    }
    if (data.containsKey('avg_cpu_percent')) {
      context.handle(
        _avgCpuPercentMeta,
        avgCpuPercent.isAcceptableOrUnknown(
          data['avg_cpu_percent']!,
          _avgCpuPercentMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  FeatureUsageSessionRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return FeatureUsageSessionRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      featureKey: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}feature_key'],
      )!,
      featureLabel: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}feature_label'],
      )!,
      startedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}started_at'],
      )!,
      endedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.dateTime,
        data['${effectivePrefix}ended_at'],
      )!,
      durationMs: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}duration_ms'],
      )!,
      avgRamPercent: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}avg_ram_percent'],
      ),
      avgCpuPercent: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}avg_cpu_percent'],
      ),
    );
  }

  @override
  $FeatureUsageSessionsTable createAlias(String alias) {
    return $FeatureUsageSessionsTable(attachedDatabase, alias);
  }
}

class FeatureUsageSessionRow extends DataClass
    implements Insertable<FeatureUsageSessionRow> {
  final String id;

  /// Stable key, e.g. `notes`, `chatgpt`, `gmail`.
  final String featureKey;
  final String featureLabel;
  final DateTime startedAt;
  final DateTime endedAt;

  /// Closed interval length in milliseconds.
  final int durationMs;

  /// Average host RAM % while this feature was open (0–100).
  final double? avgRamPercent;

  /// Average host CPU % while this feature was open (0–100).
  final double? avgCpuPercent;
  const FeatureUsageSessionRow({
    required this.id,
    required this.featureKey,
    required this.featureLabel,
    required this.startedAt,
    required this.endedAt,
    required this.durationMs,
    this.avgRamPercent,
    this.avgCpuPercent,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['feature_key'] = Variable<String>(featureKey);
    map['feature_label'] = Variable<String>(featureLabel);
    map['started_at'] = Variable<DateTime>(startedAt);
    map['ended_at'] = Variable<DateTime>(endedAt);
    map['duration_ms'] = Variable<int>(durationMs);
    if (!nullToAbsent || avgRamPercent != null) {
      map['avg_ram_percent'] = Variable<double>(avgRamPercent);
    }
    if (!nullToAbsent || avgCpuPercent != null) {
      map['avg_cpu_percent'] = Variable<double>(avgCpuPercent);
    }
    return map;
  }

  FeatureUsageSessionsCompanion toCompanion(bool nullToAbsent) {
    return FeatureUsageSessionsCompanion(
      id: Value(id),
      featureKey: Value(featureKey),
      featureLabel: Value(featureLabel),
      startedAt: Value(startedAt),
      endedAt: Value(endedAt),
      durationMs: Value(durationMs),
      avgRamPercent: avgRamPercent == null && nullToAbsent
          ? const Value.absent()
          : Value(avgRamPercent),
      avgCpuPercent: avgCpuPercent == null && nullToAbsent
          ? const Value.absent()
          : Value(avgCpuPercent),
    );
  }

  factory FeatureUsageSessionRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return FeatureUsageSessionRow(
      id: serializer.fromJson<String>(json['id']),
      featureKey: serializer.fromJson<String>(json['featureKey']),
      featureLabel: serializer.fromJson<String>(json['featureLabel']),
      startedAt: serializer.fromJson<DateTime>(json['startedAt']),
      endedAt: serializer.fromJson<DateTime>(json['endedAt']),
      durationMs: serializer.fromJson<int>(json['durationMs']),
      avgRamPercent: serializer.fromJson<double?>(json['avgRamPercent']),
      avgCpuPercent: serializer.fromJson<double?>(json['avgCpuPercent']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'featureKey': serializer.toJson<String>(featureKey),
      'featureLabel': serializer.toJson<String>(featureLabel),
      'startedAt': serializer.toJson<DateTime>(startedAt),
      'endedAt': serializer.toJson<DateTime>(endedAt),
      'durationMs': serializer.toJson<int>(durationMs),
      'avgRamPercent': serializer.toJson<double?>(avgRamPercent),
      'avgCpuPercent': serializer.toJson<double?>(avgCpuPercent),
    };
  }

  FeatureUsageSessionRow copyWith({
    String? id,
    String? featureKey,
    String? featureLabel,
    DateTime? startedAt,
    DateTime? endedAt,
    int? durationMs,
    Value<double?> avgRamPercent = const Value.absent(),
    Value<double?> avgCpuPercent = const Value.absent(),
  }) => FeatureUsageSessionRow(
    id: id ?? this.id,
    featureKey: featureKey ?? this.featureKey,
    featureLabel: featureLabel ?? this.featureLabel,
    startedAt: startedAt ?? this.startedAt,
    endedAt: endedAt ?? this.endedAt,
    durationMs: durationMs ?? this.durationMs,
    avgRamPercent: avgRamPercent.present
        ? avgRamPercent.value
        : this.avgRamPercent,
    avgCpuPercent: avgCpuPercent.present
        ? avgCpuPercent.value
        : this.avgCpuPercent,
  );
  FeatureUsageSessionRow copyWithCompanion(FeatureUsageSessionsCompanion data) {
    return FeatureUsageSessionRow(
      id: data.id.present ? data.id.value : this.id,
      featureKey: data.featureKey.present
          ? data.featureKey.value
          : this.featureKey,
      featureLabel: data.featureLabel.present
          ? data.featureLabel.value
          : this.featureLabel,
      startedAt: data.startedAt.present ? data.startedAt.value : this.startedAt,
      endedAt: data.endedAt.present ? data.endedAt.value : this.endedAt,
      durationMs: data.durationMs.present
          ? data.durationMs.value
          : this.durationMs,
      avgRamPercent: data.avgRamPercent.present
          ? data.avgRamPercent.value
          : this.avgRamPercent,
      avgCpuPercent: data.avgCpuPercent.present
          ? data.avgCpuPercent.value
          : this.avgCpuPercent,
    );
  }

  @override
  String toString() {
    return (StringBuffer('FeatureUsageSessionRow(')
          ..write('id: $id, ')
          ..write('featureKey: $featureKey, ')
          ..write('featureLabel: $featureLabel, ')
          ..write('startedAt: $startedAt, ')
          ..write('endedAt: $endedAt, ')
          ..write('durationMs: $durationMs, ')
          ..write('avgRamPercent: $avgRamPercent, ')
          ..write('avgCpuPercent: $avgCpuPercent')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    featureKey,
    featureLabel,
    startedAt,
    endedAt,
    durationMs,
    avgRamPercent,
    avgCpuPercent,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is FeatureUsageSessionRow &&
          other.id == this.id &&
          other.featureKey == this.featureKey &&
          other.featureLabel == this.featureLabel &&
          other.startedAt == this.startedAt &&
          other.endedAt == this.endedAt &&
          other.durationMs == this.durationMs &&
          other.avgRamPercent == this.avgRamPercent &&
          other.avgCpuPercent == this.avgCpuPercent);
}

class FeatureUsageSessionsCompanion
    extends UpdateCompanion<FeatureUsageSessionRow> {
  final Value<String> id;
  final Value<String> featureKey;
  final Value<String> featureLabel;
  final Value<DateTime> startedAt;
  final Value<DateTime> endedAt;
  final Value<int> durationMs;
  final Value<double?> avgRamPercent;
  final Value<double?> avgCpuPercent;
  final Value<int> rowid;
  const FeatureUsageSessionsCompanion({
    this.id = const Value.absent(),
    this.featureKey = const Value.absent(),
    this.featureLabel = const Value.absent(),
    this.startedAt = const Value.absent(),
    this.endedAt = const Value.absent(),
    this.durationMs = const Value.absent(),
    this.avgRamPercent = const Value.absent(),
    this.avgCpuPercent = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  FeatureUsageSessionsCompanion.insert({
    required String id,
    required String featureKey,
    required String featureLabel,
    required DateTime startedAt,
    required DateTime endedAt,
    required int durationMs,
    this.avgRamPercent = const Value.absent(),
    this.avgCpuPercent = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       featureKey = Value(featureKey),
       featureLabel = Value(featureLabel),
       startedAt = Value(startedAt),
       endedAt = Value(endedAt),
       durationMs = Value(durationMs);
  static Insertable<FeatureUsageSessionRow> custom({
    Expression<String>? id,
    Expression<String>? featureKey,
    Expression<String>? featureLabel,
    Expression<DateTime>? startedAt,
    Expression<DateTime>? endedAt,
    Expression<int>? durationMs,
    Expression<double>? avgRamPercent,
    Expression<double>? avgCpuPercent,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (featureKey != null) 'feature_key': featureKey,
      if (featureLabel != null) 'feature_label': featureLabel,
      if (startedAt != null) 'started_at': startedAt,
      if (endedAt != null) 'ended_at': endedAt,
      if (durationMs != null) 'duration_ms': durationMs,
      if (avgRamPercent != null) 'avg_ram_percent': avgRamPercent,
      if (avgCpuPercent != null) 'avg_cpu_percent': avgCpuPercent,
      if (rowid != null) 'rowid': rowid,
    });
  }

  FeatureUsageSessionsCompanion copyWith({
    Value<String>? id,
    Value<String>? featureKey,
    Value<String>? featureLabel,
    Value<DateTime>? startedAt,
    Value<DateTime>? endedAt,
    Value<int>? durationMs,
    Value<double?>? avgRamPercent,
    Value<double?>? avgCpuPercent,
    Value<int>? rowid,
  }) {
    return FeatureUsageSessionsCompanion(
      id: id ?? this.id,
      featureKey: featureKey ?? this.featureKey,
      featureLabel: featureLabel ?? this.featureLabel,
      startedAt: startedAt ?? this.startedAt,
      endedAt: endedAt ?? this.endedAt,
      durationMs: durationMs ?? this.durationMs,
      avgRamPercent: avgRamPercent ?? this.avgRamPercent,
      avgCpuPercent: avgCpuPercent ?? this.avgCpuPercent,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (featureKey.present) {
      map['feature_key'] = Variable<String>(featureKey.value);
    }
    if (featureLabel.present) {
      map['feature_label'] = Variable<String>(featureLabel.value);
    }
    if (startedAt.present) {
      map['started_at'] = Variable<DateTime>(startedAt.value);
    }
    if (endedAt.present) {
      map['ended_at'] = Variable<DateTime>(endedAt.value);
    }
    if (durationMs.present) {
      map['duration_ms'] = Variable<int>(durationMs.value);
    }
    if (avgRamPercent.present) {
      map['avg_ram_percent'] = Variable<double>(avgRamPercent.value);
    }
    if (avgCpuPercent.present) {
      map['avg_cpu_percent'] = Variable<double>(avgCpuPercent.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('FeatureUsageSessionsCompanion(')
          ..write('id: $id, ')
          ..write('featureKey: $featureKey, ')
          ..write('featureLabel: $featureLabel, ')
          ..write('startedAt: $startedAt, ')
          ..write('endedAt: $endedAt, ')
          ..write('durationMs: $durationMs, ')
          ..write('avgRamPercent: $avgRamPercent, ')
          ..write('avgCpuPercent: $avgCpuPercent, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $ProjectsTable projects = $ProjectsTable(this);
  late final $BoardColumnsTable boardColumns = $BoardColumnsTable(this);
  late final $TasksTable tasks = $TasksTable(this);
  late final $ProjectLabelsTable projectLabels = $ProjectLabelsTable(this);
  late final $TaskLabelLinksTable taskLabelLinks = $TaskLabelLinksTable(this);
  late final $TaskChecklistsTable taskChecklists = $TaskChecklistsTable(this);
  late final $TaskChecklistItemsTable taskChecklistItems =
      $TaskChecklistItemsTable(this);
  late final $TaskCommentsTable taskComments = $TaskCommentsTable(this);
  late final $TaskAttachmentsTable taskAttachments = $TaskAttachmentsTable(
    this,
  );
  late final $TaskActivityTable taskActivity = $TaskActivityTable(this);
  late final $TimeEntriesTable timeEntries = $TimeEntriesTable(this);
  late final $ScreenshotsTable screenshots = $ScreenshotsTable(this);
  late final $AppSettingsTable appSettings = $AppSettingsTable(this);
  late final $AlarmsTable alarms = $AlarmsTable(this);
  late final $StopwatchLapsTable stopwatchLaps = $StopwatchLapsTable(this);
  late final $KeystrokeCountsTable keystrokeCounts = $KeystrokeCountsTable(
    this,
  );
  late final $NotebooksTable notebooks = $NotebooksTable(this);
  late final $NotesTable notes = $NotesTable(this);
  late final $CalendarAccountsTable calendarAccounts = $CalendarAccountsTable(
    this,
  );
  late final $CachedCalendarEventsTable cachedCalendarEvents =
      $CachedCalendarEventsTable(this);
  late final $TelegramAccountsTable telegramAccounts = $TelegramAccountsTable(
    this,
  );
  late final $TelegramChatsTable telegramChats = $TelegramChatsTable(this);
  late final $TelegramMessagesTable telegramMessages = $TelegramMessagesTable(
    this,
  );
  late final $GmailAccountsTable gmailAccounts = $GmailAccountsTable(this);
  late final $GmailThreadsTable gmailThreads = $GmailThreadsTable(this);
  late final $GmailMessagesTable gmailMessages = $GmailMessagesTable(this);
  late final $SlackAccountsTable slackAccounts = $SlackAccountsTable(this);
  late final $SlackConversationsTable slackConversations =
      $SlackConversationsTable(this);
  late final $SlackMessagesTable slackMessages = $SlackMessagesTable(this);
  late final $BrowserBookmarksTable browserBookmarks = $BrowserBookmarksTable(
    this,
  );
  late final $SystemMetricSamplesTable systemMetricSamples =
      $SystemMetricSamplesTable(this);
  late final $FeatureUsageSessionsTable featureUsageSessions =
      $FeatureUsageSessionsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    projects,
    boardColumns,
    tasks,
    projectLabels,
    taskLabelLinks,
    taskChecklists,
    taskChecklistItems,
    taskComments,
    taskAttachments,
    taskActivity,
    timeEntries,
    screenshots,
    appSettings,
    alarms,
    stopwatchLaps,
    keystrokeCounts,
    notebooks,
    notes,
    calendarAccounts,
    cachedCalendarEvents,
    telegramAccounts,
    telegramChats,
    telegramMessages,
    gmailAccounts,
    gmailThreads,
    gmailMessages,
    slackAccounts,
    slackConversations,
    slackMessages,
    browserBookmarks,
    systemMetricSamples,
    featureUsageSessions,
  ];
  @override
  StreamQueryUpdateRules get streamUpdateRules => const StreamQueryUpdateRules([
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'projects',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('notes', kind: UpdateKind.update)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'tasks',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('notes', kind: UpdateKind.update)],
    ),
  ]);
}

typedef $$ProjectsTableCreateCompanionBuilder =
    ProjectsCompanion Function({
      required String id,
      required String name,
      required int color,
      Value<bool> archived,
      Value<String?> clientName,
      Value<String?> description,
      Value<double?> hourlyRate,
      Value<int?> weeklyLimitHours,
      Value<String?> contractType,
      required DateTime createdAt,
      required DateTime updatedAt,
      Value<int> rowid,
    });
typedef $$ProjectsTableUpdateCompanionBuilder =
    ProjectsCompanion Function({
      Value<String> id,
      Value<String> name,
      Value<int> color,
      Value<bool> archived,
      Value<String?> clientName,
      Value<String?> description,
      Value<double?> hourlyRate,
      Value<int?> weeklyLimitHours,
      Value<String?> contractType,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });

final class $$ProjectsTableReferences
    extends BaseReferences<_$AppDatabase, $ProjectsTable, ProjectRow> {
  $$ProjectsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$BoardColumnsTable, List<BoardColumnRow>>
  _boardColumnsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.boardColumns,
    aliasName: $_aliasNameGenerator(db.projects.id, db.boardColumns.projectId),
  );

  $$BoardColumnsTableProcessedTableManager get boardColumnsRefs {
    final manager = $$BoardColumnsTableTableManager(
      $_db,
      $_db.boardColumns,
    ).filter((f) => f.projectId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_boardColumnsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$TasksTable, List<TaskRow>> _tasksRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.tasks,
    aliasName: $_aliasNameGenerator(db.projects.id, db.tasks.projectId),
  );

  $$TasksTableProcessedTableManager get tasksRefs {
    final manager = $$TasksTableTableManager(
      $_db,
      $_db.tasks,
    ).filter((f) => f.projectId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_tasksRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$ProjectLabelsTable, List<ProjectLabelRow>>
  _projectLabelsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.projectLabels,
    aliasName: $_aliasNameGenerator(db.projects.id, db.projectLabels.projectId),
  );

  $$ProjectLabelsTableProcessedTableManager get projectLabelsRefs {
    final manager = $$ProjectLabelsTableTableManager(
      $_db,
      $_db.projectLabels,
    ).filter((f) => f.projectId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_projectLabelsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$TimeEntriesTable, List<TimeEntryRow>>
  _timeEntriesRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.timeEntries,
    aliasName: $_aliasNameGenerator(db.projects.id, db.timeEntries.projectId),
  );

  $$TimeEntriesTableProcessedTableManager get timeEntriesRefs {
    final manager = $$TimeEntriesTableTableManager(
      $_db,
      $_db.timeEntries,
    ).filter((f) => f.projectId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_timeEntriesRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$NotesTable, List<NoteRow>> _notesRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.notes,
    aliasName: $_aliasNameGenerator(db.projects.id, db.notes.projectId),
  );

  $$NotesTableProcessedTableManager get notesRefs {
    final manager = $$NotesTableTableManager(
      $_db,
      $_db.notes,
    ).filter((f) => f.projectId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_notesRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$ProjectsTableFilterComposer
    extends Composer<_$AppDatabase, $ProjectsTable> {
  $$ProjectsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get color => $composableBuilder(
    column: $table.color,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get archived => $composableBuilder(
    column: $table.archived,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get clientName => $composableBuilder(
    column: $table.clientName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get hourlyRate => $composableBuilder(
    column: $table.hourlyRate,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get weeklyLimitHours => $composableBuilder(
    column: $table.weeklyLimitHours,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get contractType => $composableBuilder(
    column: $table.contractType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> boardColumnsRefs(
    Expression<bool> Function($$BoardColumnsTableFilterComposer f) f,
  ) {
    final $$BoardColumnsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.boardColumns,
      getReferencedColumn: (t) => t.projectId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$BoardColumnsTableFilterComposer(
            $db: $db,
            $table: $db.boardColumns,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> tasksRefs(
    Expression<bool> Function($$TasksTableFilterComposer f) f,
  ) {
    final $$TasksTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.tasks,
      getReferencedColumn: (t) => t.projectId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TasksTableFilterComposer(
            $db: $db,
            $table: $db.tasks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> projectLabelsRefs(
    Expression<bool> Function($$ProjectLabelsTableFilterComposer f) f,
  ) {
    final $$ProjectLabelsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.projectLabels,
      getReferencedColumn: (t) => t.projectId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProjectLabelsTableFilterComposer(
            $db: $db,
            $table: $db.projectLabels,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> timeEntriesRefs(
    Expression<bool> Function($$TimeEntriesTableFilterComposer f) f,
  ) {
    final $$TimeEntriesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.timeEntries,
      getReferencedColumn: (t) => t.projectId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TimeEntriesTableFilterComposer(
            $db: $db,
            $table: $db.timeEntries,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> notesRefs(
    Expression<bool> Function($$NotesTableFilterComposer f) f,
  ) {
    final $$NotesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.notes,
      getReferencedColumn: (t) => t.projectId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$NotesTableFilterComposer(
            $db: $db,
            $table: $db.notes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$ProjectsTableOrderingComposer
    extends Composer<_$AppDatabase, $ProjectsTable> {
  $$ProjectsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get color => $composableBuilder(
    column: $table.color,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get archived => $composableBuilder(
    column: $table.archived,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get clientName => $composableBuilder(
    column: $table.clientName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get hourlyRate => $composableBuilder(
    column: $table.hourlyRate,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get weeklyLimitHours => $composableBuilder(
    column: $table.weeklyLimitHours,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get contractType => $composableBuilder(
    column: $table.contractType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$ProjectsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ProjectsTable> {
  $$ProjectsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<int> get color =>
      $composableBuilder(column: $table.color, builder: (column) => column);

  GeneratedColumn<bool> get archived =>
      $composableBuilder(column: $table.archived, builder: (column) => column);

  GeneratedColumn<String> get clientName => $composableBuilder(
    column: $table.clientName,
    builder: (column) => column,
  );

  GeneratedColumn<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => column,
  );

  GeneratedColumn<double> get hourlyRate => $composableBuilder(
    column: $table.hourlyRate,
    builder: (column) => column,
  );

  GeneratedColumn<int> get weeklyLimitHours => $composableBuilder(
    column: $table.weeklyLimitHours,
    builder: (column) => column,
  );

  GeneratedColumn<String> get contractType => $composableBuilder(
    column: $table.contractType,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  Expression<T> boardColumnsRefs<T extends Object>(
    Expression<T> Function($$BoardColumnsTableAnnotationComposer a) f,
  ) {
    final $$BoardColumnsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.boardColumns,
      getReferencedColumn: (t) => t.projectId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$BoardColumnsTableAnnotationComposer(
            $db: $db,
            $table: $db.boardColumns,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> tasksRefs<T extends Object>(
    Expression<T> Function($$TasksTableAnnotationComposer a) f,
  ) {
    final $$TasksTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.tasks,
      getReferencedColumn: (t) => t.projectId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TasksTableAnnotationComposer(
            $db: $db,
            $table: $db.tasks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> projectLabelsRefs<T extends Object>(
    Expression<T> Function($$ProjectLabelsTableAnnotationComposer a) f,
  ) {
    final $$ProjectLabelsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.projectLabels,
      getReferencedColumn: (t) => t.projectId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProjectLabelsTableAnnotationComposer(
            $db: $db,
            $table: $db.projectLabels,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> timeEntriesRefs<T extends Object>(
    Expression<T> Function($$TimeEntriesTableAnnotationComposer a) f,
  ) {
    final $$TimeEntriesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.timeEntries,
      getReferencedColumn: (t) => t.projectId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TimeEntriesTableAnnotationComposer(
            $db: $db,
            $table: $db.timeEntries,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> notesRefs<T extends Object>(
    Expression<T> Function($$NotesTableAnnotationComposer a) f,
  ) {
    final $$NotesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.notes,
      getReferencedColumn: (t) => t.projectId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$NotesTableAnnotationComposer(
            $db: $db,
            $table: $db.notes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$ProjectsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ProjectsTable,
          ProjectRow,
          $$ProjectsTableFilterComposer,
          $$ProjectsTableOrderingComposer,
          $$ProjectsTableAnnotationComposer,
          $$ProjectsTableCreateCompanionBuilder,
          $$ProjectsTableUpdateCompanionBuilder,
          (ProjectRow, $$ProjectsTableReferences),
          ProjectRow,
          PrefetchHooks Function({
            bool boardColumnsRefs,
            bool tasksRefs,
            bool projectLabelsRefs,
            bool timeEntriesRefs,
            bool notesRefs,
          })
        > {
  $$ProjectsTableTableManager(_$AppDatabase db, $ProjectsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ProjectsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ProjectsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ProjectsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<int> color = const Value.absent(),
                Value<bool> archived = const Value.absent(),
                Value<String?> clientName = const Value.absent(),
                Value<String?> description = const Value.absent(),
                Value<double?> hourlyRate = const Value.absent(),
                Value<int?> weeklyLimitHours = const Value.absent(),
                Value<String?> contractType = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ProjectsCompanion(
                id: id,
                name: name,
                color: color,
                archived: archived,
                clientName: clientName,
                description: description,
                hourlyRate: hourlyRate,
                weeklyLimitHours: weeklyLimitHours,
                contractType: contractType,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String name,
                required int color,
                Value<bool> archived = const Value.absent(),
                Value<String?> clientName = const Value.absent(),
                Value<String?> description = const Value.absent(),
                Value<double?> hourlyRate = const Value.absent(),
                Value<int?> weeklyLimitHours = const Value.absent(),
                Value<String?> contractType = const Value.absent(),
                required DateTime createdAt,
                required DateTime updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => ProjectsCompanion.insert(
                id: id,
                name: name,
                color: color,
                archived: archived,
                clientName: clientName,
                description: description,
                hourlyRate: hourlyRate,
                weeklyLimitHours: weeklyLimitHours,
                contractType: contractType,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$ProjectsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                boardColumnsRefs = false,
                tasksRefs = false,
                projectLabelsRefs = false,
                timeEntriesRefs = false,
                notesRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (boardColumnsRefs) db.boardColumns,
                    if (tasksRefs) db.tasks,
                    if (projectLabelsRefs) db.projectLabels,
                    if (timeEntriesRefs) db.timeEntries,
                    if (notesRefs) db.notes,
                  ],
                  addJoins: null,
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (boardColumnsRefs)
                        await $_getPrefetchedData<
                          ProjectRow,
                          $ProjectsTable,
                          BoardColumnRow
                        >(
                          currentTable: table,
                          referencedTable: $$ProjectsTableReferences
                              ._boardColumnsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$ProjectsTableReferences(
                                db,
                                table,
                                p0,
                              ).boardColumnsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.projectId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (tasksRefs)
                        await $_getPrefetchedData<
                          ProjectRow,
                          $ProjectsTable,
                          TaskRow
                        >(
                          currentTable: table,
                          referencedTable: $$ProjectsTableReferences
                              ._tasksRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$ProjectsTableReferences(
                                db,
                                table,
                                p0,
                              ).tasksRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.projectId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (projectLabelsRefs)
                        await $_getPrefetchedData<
                          ProjectRow,
                          $ProjectsTable,
                          ProjectLabelRow
                        >(
                          currentTable: table,
                          referencedTable: $$ProjectsTableReferences
                              ._projectLabelsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$ProjectsTableReferences(
                                db,
                                table,
                                p0,
                              ).projectLabelsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.projectId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (timeEntriesRefs)
                        await $_getPrefetchedData<
                          ProjectRow,
                          $ProjectsTable,
                          TimeEntryRow
                        >(
                          currentTable: table,
                          referencedTable: $$ProjectsTableReferences
                              ._timeEntriesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$ProjectsTableReferences(
                                db,
                                table,
                                p0,
                              ).timeEntriesRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.projectId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (notesRefs)
                        await $_getPrefetchedData<
                          ProjectRow,
                          $ProjectsTable,
                          NoteRow
                        >(
                          currentTable: table,
                          referencedTable: $$ProjectsTableReferences
                              ._notesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$ProjectsTableReferences(
                                db,
                                table,
                                p0,
                              ).notesRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.projectId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$ProjectsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ProjectsTable,
      ProjectRow,
      $$ProjectsTableFilterComposer,
      $$ProjectsTableOrderingComposer,
      $$ProjectsTableAnnotationComposer,
      $$ProjectsTableCreateCompanionBuilder,
      $$ProjectsTableUpdateCompanionBuilder,
      (ProjectRow, $$ProjectsTableReferences),
      ProjectRow,
      PrefetchHooks Function({
        bool boardColumnsRefs,
        bool tasksRefs,
        bool projectLabelsRefs,
        bool timeEntriesRefs,
        bool notesRefs,
      })
    >;
typedef $$BoardColumnsTableCreateCompanionBuilder =
    BoardColumnsCompanion Function({
      required String id,
      required String projectId,
      required String name,
      Value<int> sortOrder,
      Value<int?> wipLimit,
      required DateTime createdAt,
      Value<int> rowid,
    });
typedef $$BoardColumnsTableUpdateCompanionBuilder =
    BoardColumnsCompanion Function({
      Value<String> id,
      Value<String> projectId,
      Value<String> name,
      Value<int> sortOrder,
      Value<int?> wipLimit,
      Value<DateTime> createdAt,
      Value<int> rowid,
    });

final class $$BoardColumnsTableReferences
    extends BaseReferences<_$AppDatabase, $BoardColumnsTable, BoardColumnRow> {
  $$BoardColumnsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $ProjectsTable _projectIdTable(_$AppDatabase db) =>
      db.projects.createAlias(
        $_aliasNameGenerator(db.boardColumns.projectId, db.projects.id),
      );

  $$ProjectsTableProcessedTableManager get projectId {
    final $_column = $_itemColumn<String>('project_id')!;

    final manager = $$ProjectsTableTableManager(
      $_db,
      $_db.projects,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_projectIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$TasksTable, List<TaskRow>> _tasksRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.tasks,
    aliasName: $_aliasNameGenerator(db.boardColumns.id, db.tasks.columnId),
  );

  $$TasksTableProcessedTableManager get tasksRefs {
    final manager = $$TasksTableTableManager(
      $_db,
      $_db.tasks,
    ).filter((f) => f.columnId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_tasksRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$BoardColumnsTableFilterComposer
    extends Composer<_$AppDatabase, $BoardColumnsTable> {
  $$BoardColumnsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get wipLimit => $composableBuilder(
    column: $table.wipLimit,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  $$ProjectsTableFilterComposer get projectId {
    final $$ProjectsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.projectId,
      referencedTable: $db.projects,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProjectsTableFilterComposer(
            $db: $db,
            $table: $db.projects,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> tasksRefs(
    Expression<bool> Function($$TasksTableFilterComposer f) f,
  ) {
    final $$TasksTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.tasks,
      getReferencedColumn: (t) => t.columnId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TasksTableFilterComposer(
            $db: $db,
            $table: $db.tasks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$BoardColumnsTableOrderingComposer
    extends Composer<_$AppDatabase, $BoardColumnsTable> {
  $$BoardColumnsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get wipLimit => $composableBuilder(
    column: $table.wipLimit,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$ProjectsTableOrderingComposer get projectId {
    final $$ProjectsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.projectId,
      referencedTable: $db.projects,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProjectsTableOrderingComposer(
            $db: $db,
            $table: $db.projects,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$BoardColumnsTableAnnotationComposer
    extends Composer<_$AppDatabase, $BoardColumnsTable> {
  $$BoardColumnsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<int> get sortOrder =>
      $composableBuilder(column: $table.sortOrder, builder: (column) => column);

  GeneratedColumn<int> get wipLimit =>
      $composableBuilder(column: $table.wipLimit, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  $$ProjectsTableAnnotationComposer get projectId {
    final $$ProjectsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.projectId,
      referencedTable: $db.projects,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProjectsTableAnnotationComposer(
            $db: $db,
            $table: $db.projects,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> tasksRefs<T extends Object>(
    Expression<T> Function($$TasksTableAnnotationComposer a) f,
  ) {
    final $$TasksTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.tasks,
      getReferencedColumn: (t) => t.columnId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TasksTableAnnotationComposer(
            $db: $db,
            $table: $db.tasks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$BoardColumnsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $BoardColumnsTable,
          BoardColumnRow,
          $$BoardColumnsTableFilterComposer,
          $$BoardColumnsTableOrderingComposer,
          $$BoardColumnsTableAnnotationComposer,
          $$BoardColumnsTableCreateCompanionBuilder,
          $$BoardColumnsTableUpdateCompanionBuilder,
          (BoardColumnRow, $$BoardColumnsTableReferences),
          BoardColumnRow,
          PrefetchHooks Function({bool projectId, bool tasksRefs})
        > {
  $$BoardColumnsTableTableManager(_$AppDatabase db, $BoardColumnsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$BoardColumnsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$BoardColumnsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$BoardColumnsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> projectId = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<int> sortOrder = const Value.absent(),
                Value<int?> wipLimit = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => BoardColumnsCompanion(
                id: id,
                projectId: projectId,
                name: name,
                sortOrder: sortOrder,
                wipLimit: wipLimit,
                createdAt: createdAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String projectId,
                required String name,
                Value<int> sortOrder = const Value.absent(),
                Value<int?> wipLimit = const Value.absent(),
                required DateTime createdAt,
                Value<int> rowid = const Value.absent(),
              }) => BoardColumnsCompanion.insert(
                id: id,
                projectId: projectId,
                name: name,
                sortOrder: sortOrder,
                wipLimit: wipLimit,
                createdAt: createdAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$BoardColumnsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({projectId = false, tasksRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (tasksRefs) db.tasks],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (projectId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.projectId,
                                referencedTable: $$BoardColumnsTableReferences
                                    ._projectIdTable(db),
                                referencedColumn: $$BoardColumnsTableReferences
                                    ._projectIdTable(db)
                                    .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [
                  if (tasksRefs)
                    await $_getPrefetchedData<
                      BoardColumnRow,
                      $BoardColumnsTable,
                      TaskRow
                    >(
                      currentTable: table,
                      referencedTable: $$BoardColumnsTableReferences
                          ._tasksRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$BoardColumnsTableReferences(
                            db,
                            table,
                            p0,
                          ).tasksRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.columnId == item.id),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$BoardColumnsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $BoardColumnsTable,
      BoardColumnRow,
      $$BoardColumnsTableFilterComposer,
      $$BoardColumnsTableOrderingComposer,
      $$BoardColumnsTableAnnotationComposer,
      $$BoardColumnsTableCreateCompanionBuilder,
      $$BoardColumnsTableUpdateCompanionBuilder,
      (BoardColumnRow, $$BoardColumnsTableReferences),
      BoardColumnRow,
      PrefetchHooks Function({bool projectId, bool tasksRefs})
    >;
typedef $$TasksTableCreateCompanionBuilder =
    TasksCompanion Function({
      required String id,
      required String projectId,
      required String name,
      Value<String?> description,
      Value<String?> columnId,
      Value<int> sortOrder,
      Value<String> priority,
      Value<DateTime?> dueAt,
      Value<int?> coverColor,
      Value<bool> archived,
      required DateTime createdAt,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });
typedef $$TasksTableUpdateCompanionBuilder =
    TasksCompanion Function({
      Value<String> id,
      Value<String> projectId,
      Value<String> name,
      Value<String?> description,
      Value<String?> columnId,
      Value<int> sortOrder,
      Value<String> priority,
      Value<DateTime?> dueAt,
      Value<int?> coverColor,
      Value<bool> archived,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });

final class $$TasksTableReferences
    extends BaseReferences<_$AppDatabase, $TasksTable, TaskRow> {
  $$TasksTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $ProjectsTable _projectIdTable(_$AppDatabase db) => db.projects
      .createAlias($_aliasNameGenerator(db.tasks.projectId, db.projects.id));

  $$ProjectsTableProcessedTableManager get projectId {
    final $_column = $_itemColumn<String>('project_id')!;

    final manager = $$ProjectsTableTableManager(
      $_db,
      $_db.projects,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_projectIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $BoardColumnsTable _columnIdTable(_$AppDatabase db) => db.boardColumns
      .createAlias($_aliasNameGenerator(db.tasks.columnId, db.boardColumns.id));

  $$BoardColumnsTableProcessedTableManager? get columnId {
    final $_column = $_itemColumn<String>('column_id');
    if ($_column == null) return null;
    final manager = $$BoardColumnsTableTableManager(
      $_db,
      $_db.boardColumns,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_columnIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$TaskLabelLinksTable, List<TaskLabelLinkRow>>
  _taskLabelLinksRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.taskLabelLinks,
    aliasName: $_aliasNameGenerator(db.tasks.id, db.taskLabelLinks.taskId),
  );

  $$TaskLabelLinksTableProcessedTableManager get taskLabelLinksRefs {
    final manager = $$TaskLabelLinksTableTableManager(
      $_db,
      $_db.taskLabelLinks,
    ).filter((f) => f.taskId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_taskLabelLinksRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$TaskChecklistsTable, List<TaskChecklistRow>>
  _taskChecklistsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.taskChecklists,
    aliasName: $_aliasNameGenerator(db.tasks.id, db.taskChecklists.taskId),
  );

  $$TaskChecklistsTableProcessedTableManager get taskChecklistsRefs {
    final manager = $$TaskChecklistsTableTableManager(
      $_db,
      $_db.taskChecklists,
    ).filter((f) => f.taskId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_taskChecklistsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$TaskCommentsTable, List<TaskCommentRow>>
  _taskCommentsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.taskComments,
    aliasName: $_aliasNameGenerator(db.tasks.id, db.taskComments.taskId),
  );

  $$TaskCommentsTableProcessedTableManager get taskCommentsRefs {
    final manager = $$TaskCommentsTableTableManager(
      $_db,
      $_db.taskComments,
    ).filter((f) => f.taskId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_taskCommentsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$TaskAttachmentsTable, List<TaskAttachmentRow>>
  _taskAttachmentsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.taskAttachments,
    aliasName: $_aliasNameGenerator(db.tasks.id, db.taskAttachments.taskId),
  );

  $$TaskAttachmentsTableProcessedTableManager get taskAttachmentsRefs {
    final manager = $$TaskAttachmentsTableTableManager(
      $_db,
      $_db.taskAttachments,
    ).filter((f) => f.taskId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _taskAttachmentsRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$TaskActivityTable, List<TaskActivityRow>>
  _taskActivityRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.taskActivity,
    aliasName: $_aliasNameGenerator(db.tasks.id, db.taskActivity.taskId),
  );

  $$TaskActivityTableProcessedTableManager get taskActivityRefs {
    final manager = $$TaskActivityTableTableManager(
      $_db,
      $_db.taskActivity,
    ).filter((f) => f.taskId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_taskActivityRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$TimeEntriesTable, List<TimeEntryRow>>
  _timeEntriesRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.timeEntries,
    aliasName: $_aliasNameGenerator(db.tasks.id, db.timeEntries.taskId),
  );

  $$TimeEntriesTableProcessedTableManager get timeEntriesRefs {
    final manager = $$TimeEntriesTableTableManager(
      $_db,
      $_db.timeEntries,
    ).filter((f) => f.taskId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_timeEntriesRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$NotesTable, List<NoteRow>> _notesRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.notes,
    aliasName: $_aliasNameGenerator(db.tasks.id, db.notes.taskId),
  );

  $$NotesTableProcessedTableManager get notesRefs {
    final manager = $$NotesTableTableManager(
      $_db,
      $_db.notes,
    ).filter((f) => f.taskId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_notesRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$TasksTableFilterComposer extends Composer<_$AppDatabase, $TasksTable> {
  $$TasksTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get priority => $composableBuilder(
    column: $table.priority,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get dueAt => $composableBuilder(
    column: $table.dueAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get coverColor => $composableBuilder(
    column: $table.coverColor,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get archived => $composableBuilder(
    column: $table.archived,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  $$ProjectsTableFilterComposer get projectId {
    final $$ProjectsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.projectId,
      referencedTable: $db.projects,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProjectsTableFilterComposer(
            $db: $db,
            $table: $db.projects,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$BoardColumnsTableFilterComposer get columnId {
    final $$BoardColumnsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.columnId,
      referencedTable: $db.boardColumns,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$BoardColumnsTableFilterComposer(
            $db: $db,
            $table: $db.boardColumns,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> taskLabelLinksRefs(
    Expression<bool> Function($$TaskLabelLinksTableFilterComposer f) f,
  ) {
    final $$TaskLabelLinksTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.taskLabelLinks,
      getReferencedColumn: (t) => t.taskId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TaskLabelLinksTableFilterComposer(
            $db: $db,
            $table: $db.taskLabelLinks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> taskChecklistsRefs(
    Expression<bool> Function($$TaskChecklistsTableFilterComposer f) f,
  ) {
    final $$TaskChecklistsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.taskChecklists,
      getReferencedColumn: (t) => t.taskId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TaskChecklistsTableFilterComposer(
            $db: $db,
            $table: $db.taskChecklists,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> taskCommentsRefs(
    Expression<bool> Function($$TaskCommentsTableFilterComposer f) f,
  ) {
    final $$TaskCommentsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.taskComments,
      getReferencedColumn: (t) => t.taskId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TaskCommentsTableFilterComposer(
            $db: $db,
            $table: $db.taskComments,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> taskAttachmentsRefs(
    Expression<bool> Function($$TaskAttachmentsTableFilterComposer f) f,
  ) {
    final $$TaskAttachmentsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.taskAttachments,
      getReferencedColumn: (t) => t.taskId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TaskAttachmentsTableFilterComposer(
            $db: $db,
            $table: $db.taskAttachments,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> taskActivityRefs(
    Expression<bool> Function($$TaskActivityTableFilterComposer f) f,
  ) {
    final $$TaskActivityTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.taskActivity,
      getReferencedColumn: (t) => t.taskId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TaskActivityTableFilterComposer(
            $db: $db,
            $table: $db.taskActivity,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> timeEntriesRefs(
    Expression<bool> Function($$TimeEntriesTableFilterComposer f) f,
  ) {
    final $$TimeEntriesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.timeEntries,
      getReferencedColumn: (t) => t.taskId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TimeEntriesTableFilterComposer(
            $db: $db,
            $table: $db.timeEntries,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> notesRefs(
    Expression<bool> Function($$NotesTableFilterComposer f) f,
  ) {
    final $$NotesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.notes,
      getReferencedColumn: (t) => t.taskId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$NotesTableFilterComposer(
            $db: $db,
            $table: $db.notes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$TasksTableOrderingComposer
    extends Composer<_$AppDatabase, $TasksTable> {
  $$TasksTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get priority => $composableBuilder(
    column: $table.priority,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get dueAt => $composableBuilder(
    column: $table.dueAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get coverColor => $composableBuilder(
    column: $table.coverColor,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get archived => $composableBuilder(
    column: $table.archived,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$ProjectsTableOrderingComposer get projectId {
    final $$ProjectsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.projectId,
      referencedTable: $db.projects,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProjectsTableOrderingComposer(
            $db: $db,
            $table: $db.projects,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$BoardColumnsTableOrderingComposer get columnId {
    final $$BoardColumnsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.columnId,
      referencedTable: $db.boardColumns,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$BoardColumnsTableOrderingComposer(
            $db: $db,
            $table: $db.boardColumns,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$TasksTableAnnotationComposer
    extends Composer<_$AppDatabase, $TasksTable> {
  $$TasksTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => column,
  );

  GeneratedColumn<int> get sortOrder =>
      $composableBuilder(column: $table.sortOrder, builder: (column) => column);

  GeneratedColumn<String> get priority =>
      $composableBuilder(column: $table.priority, builder: (column) => column);

  GeneratedColumn<DateTime> get dueAt =>
      $composableBuilder(column: $table.dueAt, builder: (column) => column);

  GeneratedColumn<int> get coverColor => $composableBuilder(
    column: $table.coverColor,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get archived =>
      $composableBuilder(column: $table.archived, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  $$ProjectsTableAnnotationComposer get projectId {
    final $$ProjectsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.projectId,
      referencedTable: $db.projects,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProjectsTableAnnotationComposer(
            $db: $db,
            $table: $db.projects,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$BoardColumnsTableAnnotationComposer get columnId {
    final $$BoardColumnsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.columnId,
      referencedTable: $db.boardColumns,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$BoardColumnsTableAnnotationComposer(
            $db: $db,
            $table: $db.boardColumns,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> taskLabelLinksRefs<T extends Object>(
    Expression<T> Function($$TaskLabelLinksTableAnnotationComposer a) f,
  ) {
    final $$TaskLabelLinksTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.taskLabelLinks,
      getReferencedColumn: (t) => t.taskId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TaskLabelLinksTableAnnotationComposer(
            $db: $db,
            $table: $db.taskLabelLinks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> taskChecklistsRefs<T extends Object>(
    Expression<T> Function($$TaskChecklistsTableAnnotationComposer a) f,
  ) {
    final $$TaskChecklistsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.taskChecklists,
      getReferencedColumn: (t) => t.taskId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TaskChecklistsTableAnnotationComposer(
            $db: $db,
            $table: $db.taskChecklists,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> taskCommentsRefs<T extends Object>(
    Expression<T> Function($$TaskCommentsTableAnnotationComposer a) f,
  ) {
    final $$TaskCommentsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.taskComments,
      getReferencedColumn: (t) => t.taskId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TaskCommentsTableAnnotationComposer(
            $db: $db,
            $table: $db.taskComments,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> taskAttachmentsRefs<T extends Object>(
    Expression<T> Function($$TaskAttachmentsTableAnnotationComposer a) f,
  ) {
    final $$TaskAttachmentsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.taskAttachments,
      getReferencedColumn: (t) => t.taskId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TaskAttachmentsTableAnnotationComposer(
            $db: $db,
            $table: $db.taskAttachments,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> taskActivityRefs<T extends Object>(
    Expression<T> Function($$TaskActivityTableAnnotationComposer a) f,
  ) {
    final $$TaskActivityTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.taskActivity,
      getReferencedColumn: (t) => t.taskId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TaskActivityTableAnnotationComposer(
            $db: $db,
            $table: $db.taskActivity,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> timeEntriesRefs<T extends Object>(
    Expression<T> Function($$TimeEntriesTableAnnotationComposer a) f,
  ) {
    final $$TimeEntriesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.timeEntries,
      getReferencedColumn: (t) => t.taskId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TimeEntriesTableAnnotationComposer(
            $db: $db,
            $table: $db.timeEntries,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> notesRefs<T extends Object>(
    Expression<T> Function($$NotesTableAnnotationComposer a) f,
  ) {
    final $$NotesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.notes,
      getReferencedColumn: (t) => t.taskId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$NotesTableAnnotationComposer(
            $db: $db,
            $table: $db.notes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$TasksTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $TasksTable,
          TaskRow,
          $$TasksTableFilterComposer,
          $$TasksTableOrderingComposer,
          $$TasksTableAnnotationComposer,
          $$TasksTableCreateCompanionBuilder,
          $$TasksTableUpdateCompanionBuilder,
          (TaskRow, $$TasksTableReferences),
          TaskRow,
          PrefetchHooks Function({
            bool projectId,
            bool columnId,
            bool taskLabelLinksRefs,
            bool taskChecklistsRefs,
            bool taskCommentsRefs,
            bool taskAttachmentsRefs,
            bool taskActivityRefs,
            bool timeEntriesRefs,
            bool notesRefs,
          })
        > {
  $$TasksTableTableManager(_$AppDatabase db, $TasksTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TasksTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TasksTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TasksTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> projectId = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String?> description = const Value.absent(),
                Value<String?> columnId = const Value.absent(),
                Value<int> sortOrder = const Value.absent(),
                Value<String> priority = const Value.absent(),
                Value<DateTime?> dueAt = const Value.absent(),
                Value<int?> coverColor = const Value.absent(),
                Value<bool> archived = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => TasksCompanion(
                id: id,
                projectId: projectId,
                name: name,
                description: description,
                columnId: columnId,
                sortOrder: sortOrder,
                priority: priority,
                dueAt: dueAt,
                coverColor: coverColor,
                archived: archived,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String projectId,
                required String name,
                Value<String?> description = const Value.absent(),
                Value<String?> columnId = const Value.absent(),
                Value<int> sortOrder = const Value.absent(),
                Value<String> priority = const Value.absent(),
                Value<DateTime?> dueAt = const Value.absent(),
                Value<int?> coverColor = const Value.absent(),
                Value<bool> archived = const Value.absent(),
                required DateTime createdAt,
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => TasksCompanion.insert(
                id: id,
                projectId: projectId,
                name: name,
                description: description,
                columnId: columnId,
                sortOrder: sortOrder,
                priority: priority,
                dueAt: dueAt,
                coverColor: coverColor,
                archived: archived,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) =>
                    (e.readTable(table), $$TasksTableReferences(db, table, e)),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                projectId = false,
                columnId = false,
                taskLabelLinksRefs = false,
                taskChecklistsRefs = false,
                taskCommentsRefs = false,
                taskAttachmentsRefs = false,
                taskActivityRefs = false,
                timeEntriesRefs = false,
                notesRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (taskLabelLinksRefs) db.taskLabelLinks,
                    if (taskChecklistsRefs) db.taskChecklists,
                    if (taskCommentsRefs) db.taskComments,
                    if (taskAttachmentsRefs) db.taskAttachments,
                    if (taskActivityRefs) db.taskActivity,
                    if (timeEntriesRefs) db.timeEntries,
                    if (notesRefs) db.notes,
                  ],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (projectId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.projectId,
                                    referencedTable: $$TasksTableReferences
                                        ._projectIdTable(db),
                                    referencedColumn: $$TasksTableReferences
                                        ._projectIdTable(db)
                                        .id,
                                  )
                                  as T;
                        }
                        if (columnId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.columnId,
                                    referencedTable: $$TasksTableReferences
                                        ._columnIdTable(db),
                                    referencedColumn: $$TasksTableReferences
                                        ._columnIdTable(db)
                                        .id,
                                  )
                                  as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (taskLabelLinksRefs)
                        await $_getPrefetchedData<
                          TaskRow,
                          $TasksTable,
                          TaskLabelLinkRow
                        >(
                          currentTable: table,
                          referencedTable: $$TasksTableReferences
                              ._taskLabelLinksRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$TasksTableReferences(
                                db,
                                table,
                                p0,
                              ).taskLabelLinksRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.taskId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (taskChecklistsRefs)
                        await $_getPrefetchedData<
                          TaskRow,
                          $TasksTable,
                          TaskChecklistRow
                        >(
                          currentTable: table,
                          referencedTable: $$TasksTableReferences
                              ._taskChecklistsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$TasksTableReferences(
                                db,
                                table,
                                p0,
                              ).taskChecklistsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.taskId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (taskCommentsRefs)
                        await $_getPrefetchedData<
                          TaskRow,
                          $TasksTable,
                          TaskCommentRow
                        >(
                          currentTable: table,
                          referencedTable: $$TasksTableReferences
                              ._taskCommentsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$TasksTableReferences(
                                db,
                                table,
                                p0,
                              ).taskCommentsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.taskId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (taskAttachmentsRefs)
                        await $_getPrefetchedData<
                          TaskRow,
                          $TasksTable,
                          TaskAttachmentRow
                        >(
                          currentTable: table,
                          referencedTable: $$TasksTableReferences
                              ._taskAttachmentsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$TasksTableReferences(
                                db,
                                table,
                                p0,
                              ).taskAttachmentsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.taskId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (taskActivityRefs)
                        await $_getPrefetchedData<
                          TaskRow,
                          $TasksTable,
                          TaskActivityRow
                        >(
                          currentTable: table,
                          referencedTable: $$TasksTableReferences
                              ._taskActivityRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$TasksTableReferences(
                                db,
                                table,
                                p0,
                              ).taskActivityRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.taskId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (timeEntriesRefs)
                        await $_getPrefetchedData<
                          TaskRow,
                          $TasksTable,
                          TimeEntryRow
                        >(
                          currentTable: table,
                          referencedTable: $$TasksTableReferences
                              ._timeEntriesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$TasksTableReferences(
                                db,
                                table,
                                p0,
                              ).timeEntriesRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.taskId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (notesRefs)
                        await $_getPrefetchedData<
                          TaskRow,
                          $TasksTable,
                          NoteRow
                        >(
                          currentTable: table,
                          referencedTable: $$TasksTableReferences
                              ._notesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$TasksTableReferences(db, table, p0).notesRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.taskId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$TasksTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $TasksTable,
      TaskRow,
      $$TasksTableFilterComposer,
      $$TasksTableOrderingComposer,
      $$TasksTableAnnotationComposer,
      $$TasksTableCreateCompanionBuilder,
      $$TasksTableUpdateCompanionBuilder,
      (TaskRow, $$TasksTableReferences),
      TaskRow,
      PrefetchHooks Function({
        bool projectId,
        bool columnId,
        bool taskLabelLinksRefs,
        bool taskChecklistsRefs,
        bool taskCommentsRefs,
        bool taskAttachmentsRefs,
        bool taskActivityRefs,
        bool timeEntriesRefs,
        bool notesRefs,
      })
    >;
typedef $$ProjectLabelsTableCreateCompanionBuilder =
    ProjectLabelsCompanion Function({
      required String id,
      required String projectId,
      required String name,
      required int color,
      Value<int> rowid,
    });
typedef $$ProjectLabelsTableUpdateCompanionBuilder =
    ProjectLabelsCompanion Function({
      Value<String> id,
      Value<String> projectId,
      Value<String> name,
      Value<int> color,
      Value<int> rowid,
    });

final class $$ProjectLabelsTableReferences
    extends
        BaseReferences<_$AppDatabase, $ProjectLabelsTable, ProjectLabelRow> {
  $$ProjectLabelsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $ProjectsTable _projectIdTable(_$AppDatabase db) =>
      db.projects.createAlias(
        $_aliasNameGenerator(db.projectLabels.projectId, db.projects.id),
      );

  $$ProjectsTableProcessedTableManager get projectId {
    final $_column = $_itemColumn<String>('project_id')!;

    final manager = $$ProjectsTableTableManager(
      $_db,
      $_db.projects,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_projectIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$TaskLabelLinksTable, List<TaskLabelLinkRow>>
  _taskLabelLinksRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.taskLabelLinks,
    aliasName: $_aliasNameGenerator(
      db.projectLabels.id,
      db.taskLabelLinks.labelId,
    ),
  );

  $$TaskLabelLinksTableProcessedTableManager get taskLabelLinksRefs {
    final manager = $$TaskLabelLinksTableTableManager(
      $_db,
      $_db.taskLabelLinks,
    ).filter((f) => f.labelId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_taskLabelLinksRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$ProjectLabelsTableFilterComposer
    extends Composer<_$AppDatabase, $ProjectLabelsTable> {
  $$ProjectLabelsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get color => $composableBuilder(
    column: $table.color,
    builder: (column) => ColumnFilters(column),
  );

  $$ProjectsTableFilterComposer get projectId {
    final $$ProjectsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.projectId,
      referencedTable: $db.projects,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProjectsTableFilterComposer(
            $db: $db,
            $table: $db.projects,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> taskLabelLinksRefs(
    Expression<bool> Function($$TaskLabelLinksTableFilterComposer f) f,
  ) {
    final $$TaskLabelLinksTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.taskLabelLinks,
      getReferencedColumn: (t) => t.labelId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TaskLabelLinksTableFilterComposer(
            $db: $db,
            $table: $db.taskLabelLinks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$ProjectLabelsTableOrderingComposer
    extends Composer<_$AppDatabase, $ProjectLabelsTable> {
  $$ProjectLabelsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get color => $composableBuilder(
    column: $table.color,
    builder: (column) => ColumnOrderings(column),
  );

  $$ProjectsTableOrderingComposer get projectId {
    final $$ProjectsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.projectId,
      referencedTable: $db.projects,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProjectsTableOrderingComposer(
            $db: $db,
            $table: $db.projects,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ProjectLabelsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ProjectLabelsTable> {
  $$ProjectLabelsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<int> get color =>
      $composableBuilder(column: $table.color, builder: (column) => column);

  $$ProjectsTableAnnotationComposer get projectId {
    final $$ProjectsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.projectId,
      referencedTable: $db.projects,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProjectsTableAnnotationComposer(
            $db: $db,
            $table: $db.projects,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> taskLabelLinksRefs<T extends Object>(
    Expression<T> Function($$TaskLabelLinksTableAnnotationComposer a) f,
  ) {
    final $$TaskLabelLinksTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.taskLabelLinks,
      getReferencedColumn: (t) => t.labelId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TaskLabelLinksTableAnnotationComposer(
            $db: $db,
            $table: $db.taskLabelLinks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$ProjectLabelsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ProjectLabelsTable,
          ProjectLabelRow,
          $$ProjectLabelsTableFilterComposer,
          $$ProjectLabelsTableOrderingComposer,
          $$ProjectLabelsTableAnnotationComposer,
          $$ProjectLabelsTableCreateCompanionBuilder,
          $$ProjectLabelsTableUpdateCompanionBuilder,
          (ProjectLabelRow, $$ProjectLabelsTableReferences),
          ProjectLabelRow,
          PrefetchHooks Function({bool projectId, bool taskLabelLinksRefs})
        > {
  $$ProjectLabelsTableTableManager(_$AppDatabase db, $ProjectLabelsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ProjectLabelsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ProjectLabelsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ProjectLabelsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> projectId = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<int> color = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ProjectLabelsCompanion(
                id: id,
                projectId: projectId,
                name: name,
                color: color,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String projectId,
                required String name,
                required int color,
                Value<int> rowid = const Value.absent(),
              }) => ProjectLabelsCompanion.insert(
                id: id,
                projectId: projectId,
                name: name,
                color: color,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$ProjectLabelsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({projectId = false, taskLabelLinksRefs = false}) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (taskLabelLinksRefs) db.taskLabelLinks,
                  ],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (projectId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.projectId,
                                    referencedTable:
                                        $$ProjectLabelsTableReferences
                                            ._projectIdTable(db),
                                    referencedColumn:
                                        $$ProjectLabelsTableReferences
                                            ._projectIdTable(db)
                                            .id,
                                  )
                                  as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (taskLabelLinksRefs)
                        await $_getPrefetchedData<
                          ProjectLabelRow,
                          $ProjectLabelsTable,
                          TaskLabelLinkRow
                        >(
                          currentTable: table,
                          referencedTable: $$ProjectLabelsTableReferences
                              ._taskLabelLinksRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$ProjectLabelsTableReferences(
                                db,
                                table,
                                p0,
                              ).taskLabelLinksRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.labelId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$ProjectLabelsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ProjectLabelsTable,
      ProjectLabelRow,
      $$ProjectLabelsTableFilterComposer,
      $$ProjectLabelsTableOrderingComposer,
      $$ProjectLabelsTableAnnotationComposer,
      $$ProjectLabelsTableCreateCompanionBuilder,
      $$ProjectLabelsTableUpdateCompanionBuilder,
      (ProjectLabelRow, $$ProjectLabelsTableReferences),
      ProjectLabelRow,
      PrefetchHooks Function({bool projectId, bool taskLabelLinksRefs})
    >;
typedef $$TaskLabelLinksTableCreateCompanionBuilder =
    TaskLabelLinksCompanion Function({
      required String taskId,
      required String labelId,
      Value<int> rowid,
    });
typedef $$TaskLabelLinksTableUpdateCompanionBuilder =
    TaskLabelLinksCompanion Function({
      Value<String> taskId,
      Value<String> labelId,
      Value<int> rowid,
    });

final class $$TaskLabelLinksTableReferences
    extends
        BaseReferences<_$AppDatabase, $TaskLabelLinksTable, TaskLabelLinkRow> {
  $$TaskLabelLinksTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $TasksTable _taskIdTable(_$AppDatabase db) => db.tasks.createAlias(
    $_aliasNameGenerator(db.taskLabelLinks.taskId, db.tasks.id),
  );

  $$TasksTableProcessedTableManager get taskId {
    final $_column = $_itemColumn<String>('task_id')!;

    final manager = $$TasksTableTableManager(
      $_db,
      $_db.tasks,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_taskIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $ProjectLabelsTable _labelIdTable(_$AppDatabase db) =>
      db.projectLabels.createAlias(
        $_aliasNameGenerator(db.taskLabelLinks.labelId, db.projectLabels.id),
      );

  $$ProjectLabelsTableProcessedTableManager get labelId {
    final $_column = $_itemColumn<String>('label_id')!;

    final manager = $$ProjectLabelsTableTableManager(
      $_db,
      $_db.projectLabels,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_labelIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$TaskLabelLinksTableFilterComposer
    extends Composer<_$AppDatabase, $TaskLabelLinksTable> {
  $$TaskLabelLinksTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  $$TasksTableFilterComposer get taskId {
    final $$TasksTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.taskId,
      referencedTable: $db.tasks,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TasksTableFilterComposer(
            $db: $db,
            $table: $db.tasks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ProjectLabelsTableFilterComposer get labelId {
    final $$ProjectLabelsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.labelId,
      referencedTable: $db.projectLabels,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProjectLabelsTableFilterComposer(
            $db: $db,
            $table: $db.projectLabels,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$TaskLabelLinksTableOrderingComposer
    extends Composer<_$AppDatabase, $TaskLabelLinksTable> {
  $$TaskLabelLinksTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  $$TasksTableOrderingComposer get taskId {
    final $$TasksTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.taskId,
      referencedTable: $db.tasks,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TasksTableOrderingComposer(
            $db: $db,
            $table: $db.tasks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ProjectLabelsTableOrderingComposer get labelId {
    final $$ProjectLabelsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.labelId,
      referencedTable: $db.projectLabels,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProjectLabelsTableOrderingComposer(
            $db: $db,
            $table: $db.projectLabels,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$TaskLabelLinksTableAnnotationComposer
    extends Composer<_$AppDatabase, $TaskLabelLinksTable> {
  $$TaskLabelLinksTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  $$TasksTableAnnotationComposer get taskId {
    final $$TasksTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.taskId,
      referencedTable: $db.tasks,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TasksTableAnnotationComposer(
            $db: $db,
            $table: $db.tasks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ProjectLabelsTableAnnotationComposer get labelId {
    final $$ProjectLabelsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.labelId,
      referencedTable: $db.projectLabels,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProjectLabelsTableAnnotationComposer(
            $db: $db,
            $table: $db.projectLabels,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$TaskLabelLinksTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $TaskLabelLinksTable,
          TaskLabelLinkRow,
          $$TaskLabelLinksTableFilterComposer,
          $$TaskLabelLinksTableOrderingComposer,
          $$TaskLabelLinksTableAnnotationComposer,
          $$TaskLabelLinksTableCreateCompanionBuilder,
          $$TaskLabelLinksTableUpdateCompanionBuilder,
          (TaskLabelLinkRow, $$TaskLabelLinksTableReferences),
          TaskLabelLinkRow,
          PrefetchHooks Function({bool taskId, bool labelId})
        > {
  $$TaskLabelLinksTableTableManager(
    _$AppDatabase db,
    $TaskLabelLinksTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TaskLabelLinksTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TaskLabelLinksTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TaskLabelLinksTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> taskId = const Value.absent(),
                Value<String> labelId = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => TaskLabelLinksCompanion(
                taskId: taskId,
                labelId: labelId,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String taskId,
                required String labelId,
                Value<int> rowid = const Value.absent(),
              }) => TaskLabelLinksCompanion.insert(
                taskId: taskId,
                labelId: labelId,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$TaskLabelLinksTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({taskId = false, labelId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (taskId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.taskId,
                                referencedTable: $$TaskLabelLinksTableReferences
                                    ._taskIdTable(db),
                                referencedColumn:
                                    $$TaskLabelLinksTableReferences
                                        ._taskIdTable(db)
                                        .id,
                              )
                              as T;
                    }
                    if (labelId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.labelId,
                                referencedTable: $$TaskLabelLinksTableReferences
                                    ._labelIdTable(db),
                                referencedColumn:
                                    $$TaskLabelLinksTableReferences
                                        ._labelIdTable(db)
                                        .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$TaskLabelLinksTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $TaskLabelLinksTable,
      TaskLabelLinkRow,
      $$TaskLabelLinksTableFilterComposer,
      $$TaskLabelLinksTableOrderingComposer,
      $$TaskLabelLinksTableAnnotationComposer,
      $$TaskLabelLinksTableCreateCompanionBuilder,
      $$TaskLabelLinksTableUpdateCompanionBuilder,
      (TaskLabelLinkRow, $$TaskLabelLinksTableReferences),
      TaskLabelLinkRow,
      PrefetchHooks Function({bool taskId, bool labelId})
    >;
typedef $$TaskChecklistsTableCreateCompanionBuilder =
    TaskChecklistsCompanion Function({
      required String id,
      required String taskId,
      required String title,
      Value<int> sortOrder,
      Value<int> rowid,
    });
typedef $$TaskChecklistsTableUpdateCompanionBuilder =
    TaskChecklistsCompanion Function({
      Value<String> id,
      Value<String> taskId,
      Value<String> title,
      Value<int> sortOrder,
      Value<int> rowid,
    });

final class $$TaskChecklistsTableReferences
    extends
        BaseReferences<_$AppDatabase, $TaskChecklistsTable, TaskChecklistRow> {
  $$TaskChecklistsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $TasksTable _taskIdTable(_$AppDatabase db) => db.tasks.createAlias(
    $_aliasNameGenerator(db.taskChecklists.taskId, db.tasks.id),
  );

  $$TasksTableProcessedTableManager get taskId {
    final $_column = $_itemColumn<String>('task_id')!;

    final manager = $$TasksTableTableManager(
      $_db,
      $_db.tasks,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_taskIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<
    $TaskChecklistItemsTable,
    List<TaskChecklistItemRow>
  >
  _taskChecklistItemsRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.taskChecklistItems,
        aliasName: $_aliasNameGenerator(
          db.taskChecklists.id,
          db.taskChecklistItems.checklistId,
        ),
      );

  $$TaskChecklistItemsTableProcessedTableManager get taskChecklistItemsRefs {
    final manager = $$TaskChecklistItemsTableTableManager(
      $_db,
      $_db.taskChecklistItems,
    ).filter((f) => f.checklistId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _taskChecklistItemsRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$TaskChecklistsTableFilterComposer
    extends Composer<_$AppDatabase, $TaskChecklistsTable> {
  $$TaskChecklistsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnFilters(column),
  );

  $$TasksTableFilterComposer get taskId {
    final $$TasksTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.taskId,
      referencedTable: $db.tasks,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TasksTableFilterComposer(
            $db: $db,
            $table: $db.tasks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> taskChecklistItemsRefs(
    Expression<bool> Function($$TaskChecklistItemsTableFilterComposer f) f,
  ) {
    final $$TaskChecklistItemsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.taskChecklistItems,
      getReferencedColumn: (t) => t.checklistId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TaskChecklistItemsTableFilterComposer(
            $db: $db,
            $table: $db.taskChecklistItems,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$TaskChecklistsTableOrderingComposer
    extends Composer<_$AppDatabase, $TaskChecklistsTable> {
  $$TaskChecklistsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnOrderings(column),
  );

  $$TasksTableOrderingComposer get taskId {
    final $$TasksTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.taskId,
      referencedTable: $db.tasks,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TasksTableOrderingComposer(
            $db: $db,
            $table: $db.tasks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$TaskChecklistsTableAnnotationComposer
    extends Composer<_$AppDatabase, $TaskChecklistsTable> {
  $$TaskChecklistsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<int> get sortOrder =>
      $composableBuilder(column: $table.sortOrder, builder: (column) => column);

  $$TasksTableAnnotationComposer get taskId {
    final $$TasksTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.taskId,
      referencedTable: $db.tasks,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TasksTableAnnotationComposer(
            $db: $db,
            $table: $db.tasks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> taskChecklistItemsRefs<T extends Object>(
    Expression<T> Function($$TaskChecklistItemsTableAnnotationComposer a) f,
  ) {
    final $$TaskChecklistItemsTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.taskChecklistItems,
          getReferencedColumn: (t) => t.checklistId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$TaskChecklistItemsTableAnnotationComposer(
                $db: $db,
                $table: $db.taskChecklistItems,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }
}

class $$TaskChecklistsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $TaskChecklistsTable,
          TaskChecklistRow,
          $$TaskChecklistsTableFilterComposer,
          $$TaskChecklistsTableOrderingComposer,
          $$TaskChecklistsTableAnnotationComposer,
          $$TaskChecklistsTableCreateCompanionBuilder,
          $$TaskChecklistsTableUpdateCompanionBuilder,
          (TaskChecklistRow, $$TaskChecklistsTableReferences),
          TaskChecklistRow,
          PrefetchHooks Function({bool taskId, bool taskChecklistItemsRefs})
        > {
  $$TaskChecklistsTableTableManager(
    _$AppDatabase db,
    $TaskChecklistsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TaskChecklistsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TaskChecklistsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TaskChecklistsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> taskId = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<int> sortOrder = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => TaskChecklistsCompanion(
                id: id,
                taskId: taskId,
                title: title,
                sortOrder: sortOrder,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String taskId,
                required String title,
                Value<int> sortOrder = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => TaskChecklistsCompanion.insert(
                id: id,
                taskId: taskId,
                title: title,
                sortOrder: sortOrder,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$TaskChecklistsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({taskId = false, taskChecklistItemsRefs = false}) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (taskChecklistItemsRefs) db.taskChecklistItems,
                  ],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (taskId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.taskId,
                                    referencedTable:
                                        $$TaskChecklistsTableReferences
                                            ._taskIdTable(db),
                                    referencedColumn:
                                        $$TaskChecklistsTableReferences
                                            ._taskIdTable(db)
                                            .id,
                                  )
                                  as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (taskChecklistItemsRefs)
                        await $_getPrefetchedData<
                          TaskChecklistRow,
                          $TaskChecklistsTable,
                          TaskChecklistItemRow
                        >(
                          currentTable: table,
                          referencedTable: $$TaskChecklistsTableReferences
                              ._taskChecklistItemsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$TaskChecklistsTableReferences(
                                db,
                                table,
                                p0,
                              ).taskChecklistItemsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.checklistId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$TaskChecklistsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $TaskChecklistsTable,
      TaskChecklistRow,
      $$TaskChecklistsTableFilterComposer,
      $$TaskChecklistsTableOrderingComposer,
      $$TaskChecklistsTableAnnotationComposer,
      $$TaskChecklistsTableCreateCompanionBuilder,
      $$TaskChecklistsTableUpdateCompanionBuilder,
      (TaskChecklistRow, $$TaskChecklistsTableReferences),
      TaskChecklistRow,
      PrefetchHooks Function({bool taskId, bool taskChecklistItemsRefs})
    >;
typedef $$TaskChecklistItemsTableCreateCompanionBuilder =
    TaskChecklistItemsCompanion Function({
      required String id,
      required String checklistId,
      required String title,
      Value<bool> done,
      Value<int> sortOrder,
      Value<int> rowid,
    });
typedef $$TaskChecklistItemsTableUpdateCompanionBuilder =
    TaskChecklistItemsCompanion Function({
      Value<String> id,
      Value<String> checklistId,
      Value<String> title,
      Value<bool> done,
      Value<int> sortOrder,
      Value<int> rowid,
    });

final class $$TaskChecklistItemsTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $TaskChecklistItemsTable,
          TaskChecklistItemRow
        > {
  $$TaskChecklistItemsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $TaskChecklistsTable _checklistIdTable(_$AppDatabase db) =>
      db.taskChecklists.createAlias(
        $_aliasNameGenerator(
          db.taskChecklistItems.checklistId,
          db.taskChecklists.id,
        ),
      );

  $$TaskChecklistsTableProcessedTableManager get checklistId {
    final $_column = $_itemColumn<String>('checklist_id')!;

    final manager = $$TaskChecklistsTableTableManager(
      $_db,
      $_db.taskChecklists,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_checklistIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$TaskChecklistItemsTableFilterComposer
    extends Composer<_$AppDatabase, $TaskChecklistItemsTable> {
  $$TaskChecklistItemsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get done => $composableBuilder(
    column: $table.done,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnFilters(column),
  );

  $$TaskChecklistsTableFilterComposer get checklistId {
    final $$TaskChecklistsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.checklistId,
      referencedTable: $db.taskChecklists,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TaskChecklistsTableFilterComposer(
            $db: $db,
            $table: $db.taskChecklists,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$TaskChecklistItemsTableOrderingComposer
    extends Composer<_$AppDatabase, $TaskChecklistItemsTable> {
  $$TaskChecklistItemsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get done => $composableBuilder(
    column: $table.done,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnOrderings(column),
  );

  $$TaskChecklistsTableOrderingComposer get checklistId {
    final $$TaskChecklistsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.checklistId,
      referencedTable: $db.taskChecklists,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TaskChecklistsTableOrderingComposer(
            $db: $db,
            $table: $db.taskChecklists,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$TaskChecklistItemsTableAnnotationComposer
    extends Composer<_$AppDatabase, $TaskChecklistItemsTable> {
  $$TaskChecklistItemsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<bool> get done =>
      $composableBuilder(column: $table.done, builder: (column) => column);

  GeneratedColumn<int> get sortOrder =>
      $composableBuilder(column: $table.sortOrder, builder: (column) => column);

  $$TaskChecklistsTableAnnotationComposer get checklistId {
    final $$TaskChecklistsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.checklistId,
      referencedTable: $db.taskChecklists,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TaskChecklistsTableAnnotationComposer(
            $db: $db,
            $table: $db.taskChecklists,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$TaskChecklistItemsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $TaskChecklistItemsTable,
          TaskChecklistItemRow,
          $$TaskChecklistItemsTableFilterComposer,
          $$TaskChecklistItemsTableOrderingComposer,
          $$TaskChecklistItemsTableAnnotationComposer,
          $$TaskChecklistItemsTableCreateCompanionBuilder,
          $$TaskChecklistItemsTableUpdateCompanionBuilder,
          (TaskChecklistItemRow, $$TaskChecklistItemsTableReferences),
          TaskChecklistItemRow,
          PrefetchHooks Function({bool checklistId})
        > {
  $$TaskChecklistItemsTableTableManager(
    _$AppDatabase db,
    $TaskChecklistItemsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TaskChecklistItemsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TaskChecklistItemsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TaskChecklistItemsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> checklistId = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<bool> done = const Value.absent(),
                Value<int> sortOrder = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => TaskChecklistItemsCompanion(
                id: id,
                checklistId: checklistId,
                title: title,
                done: done,
                sortOrder: sortOrder,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String checklistId,
                required String title,
                Value<bool> done = const Value.absent(),
                Value<int> sortOrder = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => TaskChecklistItemsCompanion.insert(
                id: id,
                checklistId: checklistId,
                title: title,
                done: done,
                sortOrder: sortOrder,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$TaskChecklistItemsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({checklistId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (checklistId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.checklistId,
                                referencedTable:
                                    $$TaskChecklistItemsTableReferences
                                        ._checklistIdTable(db),
                                referencedColumn:
                                    $$TaskChecklistItemsTableReferences
                                        ._checklistIdTable(db)
                                        .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$TaskChecklistItemsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $TaskChecklistItemsTable,
      TaskChecklistItemRow,
      $$TaskChecklistItemsTableFilterComposer,
      $$TaskChecklistItemsTableOrderingComposer,
      $$TaskChecklistItemsTableAnnotationComposer,
      $$TaskChecklistItemsTableCreateCompanionBuilder,
      $$TaskChecklistItemsTableUpdateCompanionBuilder,
      (TaskChecklistItemRow, $$TaskChecklistItemsTableReferences),
      TaskChecklistItemRow,
      PrefetchHooks Function({bool checklistId})
    >;
typedef $$TaskCommentsTableCreateCompanionBuilder =
    TaskCommentsCompanion Function({
      required String id,
      required String taskId,
      required String body,
      required DateTime createdAt,
      Value<int> rowid,
    });
typedef $$TaskCommentsTableUpdateCompanionBuilder =
    TaskCommentsCompanion Function({
      Value<String> id,
      Value<String> taskId,
      Value<String> body,
      Value<DateTime> createdAt,
      Value<int> rowid,
    });

final class $$TaskCommentsTableReferences
    extends BaseReferences<_$AppDatabase, $TaskCommentsTable, TaskCommentRow> {
  $$TaskCommentsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $TasksTable _taskIdTable(_$AppDatabase db) => db.tasks.createAlias(
    $_aliasNameGenerator(db.taskComments.taskId, db.tasks.id),
  );

  $$TasksTableProcessedTableManager get taskId {
    final $_column = $_itemColumn<String>('task_id')!;

    final manager = $$TasksTableTableManager(
      $_db,
      $_db.tasks,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_taskIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$TaskCommentsTableFilterComposer
    extends Composer<_$AppDatabase, $TaskCommentsTable> {
  $$TaskCommentsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get body => $composableBuilder(
    column: $table.body,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  $$TasksTableFilterComposer get taskId {
    final $$TasksTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.taskId,
      referencedTable: $db.tasks,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TasksTableFilterComposer(
            $db: $db,
            $table: $db.tasks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$TaskCommentsTableOrderingComposer
    extends Composer<_$AppDatabase, $TaskCommentsTable> {
  $$TaskCommentsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get body => $composableBuilder(
    column: $table.body,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$TasksTableOrderingComposer get taskId {
    final $$TasksTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.taskId,
      referencedTable: $db.tasks,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TasksTableOrderingComposer(
            $db: $db,
            $table: $db.tasks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$TaskCommentsTableAnnotationComposer
    extends Composer<_$AppDatabase, $TaskCommentsTable> {
  $$TaskCommentsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get body =>
      $composableBuilder(column: $table.body, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  $$TasksTableAnnotationComposer get taskId {
    final $$TasksTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.taskId,
      referencedTable: $db.tasks,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TasksTableAnnotationComposer(
            $db: $db,
            $table: $db.tasks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$TaskCommentsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $TaskCommentsTable,
          TaskCommentRow,
          $$TaskCommentsTableFilterComposer,
          $$TaskCommentsTableOrderingComposer,
          $$TaskCommentsTableAnnotationComposer,
          $$TaskCommentsTableCreateCompanionBuilder,
          $$TaskCommentsTableUpdateCompanionBuilder,
          (TaskCommentRow, $$TaskCommentsTableReferences),
          TaskCommentRow,
          PrefetchHooks Function({bool taskId})
        > {
  $$TaskCommentsTableTableManager(_$AppDatabase db, $TaskCommentsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TaskCommentsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TaskCommentsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TaskCommentsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> taskId = const Value.absent(),
                Value<String> body = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => TaskCommentsCompanion(
                id: id,
                taskId: taskId,
                body: body,
                createdAt: createdAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String taskId,
                required String body,
                required DateTime createdAt,
                Value<int> rowid = const Value.absent(),
              }) => TaskCommentsCompanion.insert(
                id: id,
                taskId: taskId,
                body: body,
                createdAt: createdAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$TaskCommentsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({taskId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (taskId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.taskId,
                                referencedTable: $$TaskCommentsTableReferences
                                    ._taskIdTable(db),
                                referencedColumn: $$TaskCommentsTableReferences
                                    ._taskIdTable(db)
                                    .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$TaskCommentsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $TaskCommentsTable,
      TaskCommentRow,
      $$TaskCommentsTableFilterComposer,
      $$TaskCommentsTableOrderingComposer,
      $$TaskCommentsTableAnnotationComposer,
      $$TaskCommentsTableCreateCompanionBuilder,
      $$TaskCommentsTableUpdateCompanionBuilder,
      (TaskCommentRow, $$TaskCommentsTableReferences),
      TaskCommentRow,
      PrefetchHooks Function({bool taskId})
    >;
typedef $$TaskAttachmentsTableCreateCompanionBuilder =
    TaskAttachmentsCompanion Function({
      required String id,
      required String taskId,
      required String fileName,
      required String filePath,
      Value<String?> mimeType,
      Value<int> byteSize,
      required DateTime createdAt,
      Value<int> rowid,
    });
typedef $$TaskAttachmentsTableUpdateCompanionBuilder =
    TaskAttachmentsCompanion Function({
      Value<String> id,
      Value<String> taskId,
      Value<String> fileName,
      Value<String> filePath,
      Value<String?> mimeType,
      Value<int> byteSize,
      Value<DateTime> createdAt,
      Value<int> rowid,
    });

final class $$TaskAttachmentsTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $TaskAttachmentsTable,
          TaskAttachmentRow
        > {
  $$TaskAttachmentsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $TasksTable _taskIdTable(_$AppDatabase db) => db.tasks.createAlias(
    $_aliasNameGenerator(db.taskAttachments.taskId, db.tasks.id),
  );

  $$TasksTableProcessedTableManager get taskId {
    final $_column = $_itemColumn<String>('task_id')!;

    final manager = $$TasksTableTableManager(
      $_db,
      $_db.tasks,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_taskIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$TaskAttachmentsTableFilterComposer
    extends Composer<_$AppDatabase, $TaskAttachmentsTable> {
  $$TaskAttachmentsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get fileName => $composableBuilder(
    column: $table.fileName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get filePath => $composableBuilder(
    column: $table.filePath,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get mimeType => $composableBuilder(
    column: $table.mimeType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get byteSize => $composableBuilder(
    column: $table.byteSize,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  $$TasksTableFilterComposer get taskId {
    final $$TasksTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.taskId,
      referencedTable: $db.tasks,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TasksTableFilterComposer(
            $db: $db,
            $table: $db.tasks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$TaskAttachmentsTableOrderingComposer
    extends Composer<_$AppDatabase, $TaskAttachmentsTable> {
  $$TaskAttachmentsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get fileName => $composableBuilder(
    column: $table.fileName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get filePath => $composableBuilder(
    column: $table.filePath,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get mimeType => $composableBuilder(
    column: $table.mimeType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get byteSize => $composableBuilder(
    column: $table.byteSize,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$TasksTableOrderingComposer get taskId {
    final $$TasksTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.taskId,
      referencedTable: $db.tasks,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TasksTableOrderingComposer(
            $db: $db,
            $table: $db.tasks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$TaskAttachmentsTableAnnotationComposer
    extends Composer<_$AppDatabase, $TaskAttachmentsTable> {
  $$TaskAttachmentsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get fileName =>
      $composableBuilder(column: $table.fileName, builder: (column) => column);

  GeneratedColumn<String> get filePath =>
      $composableBuilder(column: $table.filePath, builder: (column) => column);

  GeneratedColumn<String> get mimeType =>
      $composableBuilder(column: $table.mimeType, builder: (column) => column);

  GeneratedColumn<int> get byteSize =>
      $composableBuilder(column: $table.byteSize, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  $$TasksTableAnnotationComposer get taskId {
    final $$TasksTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.taskId,
      referencedTable: $db.tasks,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TasksTableAnnotationComposer(
            $db: $db,
            $table: $db.tasks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$TaskAttachmentsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $TaskAttachmentsTable,
          TaskAttachmentRow,
          $$TaskAttachmentsTableFilterComposer,
          $$TaskAttachmentsTableOrderingComposer,
          $$TaskAttachmentsTableAnnotationComposer,
          $$TaskAttachmentsTableCreateCompanionBuilder,
          $$TaskAttachmentsTableUpdateCompanionBuilder,
          (TaskAttachmentRow, $$TaskAttachmentsTableReferences),
          TaskAttachmentRow,
          PrefetchHooks Function({bool taskId})
        > {
  $$TaskAttachmentsTableTableManager(
    _$AppDatabase db,
    $TaskAttachmentsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TaskAttachmentsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TaskAttachmentsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TaskAttachmentsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> taskId = const Value.absent(),
                Value<String> fileName = const Value.absent(),
                Value<String> filePath = const Value.absent(),
                Value<String?> mimeType = const Value.absent(),
                Value<int> byteSize = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => TaskAttachmentsCompanion(
                id: id,
                taskId: taskId,
                fileName: fileName,
                filePath: filePath,
                mimeType: mimeType,
                byteSize: byteSize,
                createdAt: createdAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String taskId,
                required String fileName,
                required String filePath,
                Value<String?> mimeType = const Value.absent(),
                Value<int> byteSize = const Value.absent(),
                required DateTime createdAt,
                Value<int> rowid = const Value.absent(),
              }) => TaskAttachmentsCompanion.insert(
                id: id,
                taskId: taskId,
                fileName: fileName,
                filePath: filePath,
                mimeType: mimeType,
                byteSize: byteSize,
                createdAt: createdAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$TaskAttachmentsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({taskId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (taskId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.taskId,
                                referencedTable:
                                    $$TaskAttachmentsTableReferences
                                        ._taskIdTable(db),
                                referencedColumn:
                                    $$TaskAttachmentsTableReferences
                                        ._taskIdTable(db)
                                        .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$TaskAttachmentsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $TaskAttachmentsTable,
      TaskAttachmentRow,
      $$TaskAttachmentsTableFilterComposer,
      $$TaskAttachmentsTableOrderingComposer,
      $$TaskAttachmentsTableAnnotationComposer,
      $$TaskAttachmentsTableCreateCompanionBuilder,
      $$TaskAttachmentsTableUpdateCompanionBuilder,
      (TaskAttachmentRow, $$TaskAttachmentsTableReferences),
      TaskAttachmentRow,
      PrefetchHooks Function({bool taskId})
    >;
typedef $$TaskActivityTableCreateCompanionBuilder =
    TaskActivityCompanion Function({
      required String id,
      required String taskId,
      required String type,
      Value<String?> payload,
      required DateTime createdAt,
      Value<int> rowid,
    });
typedef $$TaskActivityTableUpdateCompanionBuilder =
    TaskActivityCompanion Function({
      Value<String> id,
      Value<String> taskId,
      Value<String> type,
      Value<String?> payload,
      Value<DateTime> createdAt,
      Value<int> rowid,
    });

final class $$TaskActivityTableReferences
    extends BaseReferences<_$AppDatabase, $TaskActivityTable, TaskActivityRow> {
  $$TaskActivityTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $TasksTable _taskIdTable(_$AppDatabase db) => db.tasks.createAlias(
    $_aliasNameGenerator(db.taskActivity.taskId, db.tasks.id),
  );

  $$TasksTableProcessedTableManager get taskId {
    final $_column = $_itemColumn<String>('task_id')!;

    final manager = $$TasksTableTableManager(
      $_db,
      $_db.tasks,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_taskIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$TaskActivityTableFilterComposer
    extends Composer<_$AppDatabase, $TaskActivityTable> {
  $$TaskActivityTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get payload => $composableBuilder(
    column: $table.payload,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  $$TasksTableFilterComposer get taskId {
    final $$TasksTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.taskId,
      referencedTable: $db.tasks,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TasksTableFilterComposer(
            $db: $db,
            $table: $db.tasks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$TaskActivityTableOrderingComposer
    extends Composer<_$AppDatabase, $TaskActivityTable> {
  $$TaskActivityTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get type => $composableBuilder(
    column: $table.type,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get payload => $composableBuilder(
    column: $table.payload,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$TasksTableOrderingComposer get taskId {
    final $$TasksTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.taskId,
      referencedTable: $db.tasks,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TasksTableOrderingComposer(
            $db: $db,
            $table: $db.tasks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$TaskActivityTableAnnotationComposer
    extends Composer<_$AppDatabase, $TaskActivityTable> {
  $$TaskActivityTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get type =>
      $composableBuilder(column: $table.type, builder: (column) => column);

  GeneratedColumn<String> get payload =>
      $composableBuilder(column: $table.payload, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  $$TasksTableAnnotationComposer get taskId {
    final $$TasksTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.taskId,
      referencedTable: $db.tasks,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TasksTableAnnotationComposer(
            $db: $db,
            $table: $db.tasks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$TaskActivityTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $TaskActivityTable,
          TaskActivityRow,
          $$TaskActivityTableFilterComposer,
          $$TaskActivityTableOrderingComposer,
          $$TaskActivityTableAnnotationComposer,
          $$TaskActivityTableCreateCompanionBuilder,
          $$TaskActivityTableUpdateCompanionBuilder,
          (TaskActivityRow, $$TaskActivityTableReferences),
          TaskActivityRow,
          PrefetchHooks Function({bool taskId})
        > {
  $$TaskActivityTableTableManager(_$AppDatabase db, $TaskActivityTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TaskActivityTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TaskActivityTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TaskActivityTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> taskId = const Value.absent(),
                Value<String> type = const Value.absent(),
                Value<String?> payload = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => TaskActivityCompanion(
                id: id,
                taskId: taskId,
                type: type,
                payload: payload,
                createdAt: createdAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String taskId,
                required String type,
                Value<String?> payload = const Value.absent(),
                required DateTime createdAt,
                Value<int> rowid = const Value.absent(),
              }) => TaskActivityCompanion.insert(
                id: id,
                taskId: taskId,
                type: type,
                payload: payload,
                createdAt: createdAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$TaskActivityTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({taskId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (taskId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.taskId,
                                referencedTable: $$TaskActivityTableReferences
                                    ._taskIdTable(db),
                                referencedColumn: $$TaskActivityTableReferences
                                    ._taskIdTable(db)
                                    .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$TaskActivityTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $TaskActivityTable,
      TaskActivityRow,
      $$TaskActivityTableFilterComposer,
      $$TaskActivityTableOrderingComposer,
      $$TaskActivityTableAnnotationComposer,
      $$TaskActivityTableCreateCompanionBuilder,
      $$TaskActivityTableUpdateCompanionBuilder,
      (TaskActivityRow, $$TaskActivityTableReferences),
      TaskActivityRow,
      PrefetchHooks Function({bool taskId})
    >;
typedef $$TimeEntriesTableCreateCompanionBuilder =
    TimeEntriesCompanion Function({
      required String id,
      required String projectId,
      Value<String?> taskId,
      required DateTime startTime,
      Value<DateTime?> endTime,
      Value<int> durationSeconds,
      Value<int?> activityPercentage,
      Value<bool> isManual,
      Value<String?> notes,
      Value<int> rowid,
    });
typedef $$TimeEntriesTableUpdateCompanionBuilder =
    TimeEntriesCompanion Function({
      Value<String> id,
      Value<String> projectId,
      Value<String?> taskId,
      Value<DateTime> startTime,
      Value<DateTime?> endTime,
      Value<int> durationSeconds,
      Value<int?> activityPercentage,
      Value<bool> isManual,
      Value<String?> notes,
      Value<int> rowid,
    });

final class $$TimeEntriesTableReferences
    extends BaseReferences<_$AppDatabase, $TimeEntriesTable, TimeEntryRow> {
  $$TimeEntriesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $ProjectsTable _projectIdTable(_$AppDatabase db) =>
      db.projects.createAlias(
        $_aliasNameGenerator(db.timeEntries.projectId, db.projects.id),
      );

  $$ProjectsTableProcessedTableManager get projectId {
    final $_column = $_itemColumn<String>('project_id')!;

    final manager = $$ProjectsTableTableManager(
      $_db,
      $_db.projects,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_projectIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $TasksTable _taskIdTable(_$AppDatabase db) => db.tasks.createAlias(
    $_aliasNameGenerator(db.timeEntries.taskId, db.tasks.id),
  );

  $$TasksTableProcessedTableManager? get taskId {
    final $_column = $_itemColumn<String>('task_id');
    if ($_column == null) return null;
    final manager = $$TasksTableTableManager(
      $_db,
      $_db.tasks,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_taskIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$ScreenshotsTable, List<ScreenshotRow>>
  _screenshotsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.screenshots,
    aliasName: $_aliasNameGenerator(
      db.timeEntries.id,
      db.screenshots.timeEntryId,
    ),
  );

  $$ScreenshotsTableProcessedTableManager get screenshotsRefs {
    final manager = $$ScreenshotsTableTableManager(
      $_db,
      $_db.screenshots,
    ).filter((f) => f.timeEntryId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_screenshotsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$KeystrokeCountsTable, List<KeystrokeCountRow>>
  _keystrokeCountsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.keystrokeCounts,
    aliasName: $_aliasNameGenerator(
      db.timeEntries.id,
      db.keystrokeCounts.timeEntryId,
    ),
  );

  $$KeystrokeCountsTableProcessedTableManager get keystrokeCountsRefs {
    final manager = $$KeystrokeCountsTableTableManager(
      $_db,
      $_db.keystrokeCounts,
    ).filter((f) => f.timeEntryId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _keystrokeCountsRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$TimeEntriesTableFilterComposer
    extends Composer<_$AppDatabase, $TimeEntriesTable> {
  $$TimeEntriesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get startTime => $composableBuilder(
    column: $table.startTime,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get endTime => $composableBuilder(
    column: $table.endTime,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get durationSeconds => $composableBuilder(
    column: $table.durationSeconds,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get activityPercentage => $composableBuilder(
    column: $table.activityPercentage,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isManual => $composableBuilder(
    column: $table.isManual,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnFilters(column),
  );

  $$ProjectsTableFilterComposer get projectId {
    final $$ProjectsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.projectId,
      referencedTable: $db.projects,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProjectsTableFilterComposer(
            $db: $db,
            $table: $db.projects,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$TasksTableFilterComposer get taskId {
    final $$TasksTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.taskId,
      referencedTable: $db.tasks,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TasksTableFilterComposer(
            $db: $db,
            $table: $db.tasks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> screenshotsRefs(
    Expression<bool> Function($$ScreenshotsTableFilterComposer f) f,
  ) {
    final $$ScreenshotsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.screenshots,
      getReferencedColumn: (t) => t.timeEntryId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ScreenshotsTableFilterComposer(
            $db: $db,
            $table: $db.screenshots,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> keystrokeCountsRefs(
    Expression<bool> Function($$KeystrokeCountsTableFilterComposer f) f,
  ) {
    final $$KeystrokeCountsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.keystrokeCounts,
      getReferencedColumn: (t) => t.timeEntryId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$KeystrokeCountsTableFilterComposer(
            $db: $db,
            $table: $db.keystrokeCounts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$TimeEntriesTableOrderingComposer
    extends Composer<_$AppDatabase, $TimeEntriesTable> {
  $$TimeEntriesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get startTime => $composableBuilder(
    column: $table.startTime,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get endTime => $composableBuilder(
    column: $table.endTime,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get durationSeconds => $composableBuilder(
    column: $table.durationSeconds,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get activityPercentage => $composableBuilder(
    column: $table.activityPercentage,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isManual => $composableBuilder(
    column: $table.isManual,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get notes => $composableBuilder(
    column: $table.notes,
    builder: (column) => ColumnOrderings(column),
  );

  $$ProjectsTableOrderingComposer get projectId {
    final $$ProjectsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.projectId,
      referencedTable: $db.projects,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProjectsTableOrderingComposer(
            $db: $db,
            $table: $db.projects,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$TasksTableOrderingComposer get taskId {
    final $$TasksTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.taskId,
      referencedTable: $db.tasks,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TasksTableOrderingComposer(
            $db: $db,
            $table: $db.tasks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$TimeEntriesTableAnnotationComposer
    extends Composer<_$AppDatabase, $TimeEntriesTable> {
  $$TimeEntriesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get startTime =>
      $composableBuilder(column: $table.startTime, builder: (column) => column);

  GeneratedColumn<DateTime> get endTime =>
      $composableBuilder(column: $table.endTime, builder: (column) => column);

  GeneratedColumn<int> get durationSeconds => $composableBuilder(
    column: $table.durationSeconds,
    builder: (column) => column,
  );

  GeneratedColumn<int> get activityPercentage => $composableBuilder(
    column: $table.activityPercentage,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isManual =>
      $composableBuilder(column: $table.isManual, builder: (column) => column);

  GeneratedColumn<String> get notes =>
      $composableBuilder(column: $table.notes, builder: (column) => column);

  $$ProjectsTableAnnotationComposer get projectId {
    final $$ProjectsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.projectId,
      referencedTable: $db.projects,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProjectsTableAnnotationComposer(
            $db: $db,
            $table: $db.projects,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$TasksTableAnnotationComposer get taskId {
    final $$TasksTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.taskId,
      referencedTable: $db.tasks,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TasksTableAnnotationComposer(
            $db: $db,
            $table: $db.tasks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> screenshotsRefs<T extends Object>(
    Expression<T> Function($$ScreenshotsTableAnnotationComposer a) f,
  ) {
    final $$ScreenshotsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.screenshots,
      getReferencedColumn: (t) => t.timeEntryId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ScreenshotsTableAnnotationComposer(
            $db: $db,
            $table: $db.screenshots,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> keystrokeCountsRefs<T extends Object>(
    Expression<T> Function($$KeystrokeCountsTableAnnotationComposer a) f,
  ) {
    final $$KeystrokeCountsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.keystrokeCounts,
      getReferencedColumn: (t) => t.timeEntryId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$KeystrokeCountsTableAnnotationComposer(
            $db: $db,
            $table: $db.keystrokeCounts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$TimeEntriesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $TimeEntriesTable,
          TimeEntryRow,
          $$TimeEntriesTableFilterComposer,
          $$TimeEntriesTableOrderingComposer,
          $$TimeEntriesTableAnnotationComposer,
          $$TimeEntriesTableCreateCompanionBuilder,
          $$TimeEntriesTableUpdateCompanionBuilder,
          (TimeEntryRow, $$TimeEntriesTableReferences),
          TimeEntryRow,
          PrefetchHooks Function({
            bool projectId,
            bool taskId,
            bool screenshotsRefs,
            bool keystrokeCountsRefs,
          })
        > {
  $$TimeEntriesTableTableManager(_$AppDatabase db, $TimeEntriesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TimeEntriesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TimeEntriesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TimeEntriesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> projectId = const Value.absent(),
                Value<String?> taskId = const Value.absent(),
                Value<DateTime> startTime = const Value.absent(),
                Value<DateTime?> endTime = const Value.absent(),
                Value<int> durationSeconds = const Value.absent(),
                Value<int?> activityPercentage = const Value.absent(),
                Value<bool> isManual = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => TimeEntriesCompanion(
                id: id,
                projectId: projectId,
                taskId: taskId,
                startTime: startTime,
                endTime: endTime,
                durationSeconds: durationSeconds,
                activityPercentage: activityPercentage,
                isManual: isManual,
                notes: notes,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String projectId,
                Value<String?> taskId = const Value.absent(),
                required DateTime startTime,
                Value<DateTime?> endTime = const Value.absent(),
                Value<int> durationSeconds = const Value.absent(),
                Value<int?> activityPercentage = const Value.absent(),
                Value<bool> isManual = const Value.absent(),
                Value<String?> notes = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => TimeEntriesCompanion.insert(
                id: id,
                projectId: projectId,
                taskId: taskId,
                startTime: startTime,
                endTime: endTime,
                durationSeconds: durationSeconds,
                activityPercentage: activityPercentage,
                isManual: isManual,
                notes: notes,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$TimeEntriesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                projectId = false,
                taskId = false,
                screenshotsRefs = false,
                keystrokeCountsRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (screenshotsRefs) db.screenshots,
                    if (keystrokeCountsRefs) db.keystrokeCounts,
                  ],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (projectId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.projectId,
                                    referencedTable:
                                        $$TimeEntriesTableReferences
                                            ._projectIdTable(db),
                                    referencedColumn:
                                        $$TimeEntriesTableReferences
                                            ._projectIdTable(db)
                                            .id,
                                  )
                                  as T;
                        }
                        if (taskId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.taskId,
                                    referencedTable:
                                        $$TimeEntriesTableReferences
                                            ._taskIdTable(db),
                                    referencedColumn:
                                        $$TimeEntriesTableReferences
                                            ._taskIdTable(db)
                                            .id,
                                  )
                                  as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (screenshotsRefs)
                        await $_getPrefetchedData<
                          TimeEntryRow,
                          $TimeEntriesTable,
                          ScreenshotRow
                        >(
                          currentTable: table,
                          referencedTable: $$TimeEntriesTableReferences
                              ._screenshotsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$TimeEntriesTableReferences(
                                db,
                                table,
                                p0,
                              ).screenshotsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.timeEntryId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (keystrokeCountsRefs)
                        await $_getPrefetchedData<
                          TimeEntryRow,
                          $TimeEntriesTable,
                          KeystrokeCountRow
                        >(
                          currentTable: table,
                          referencedTable: $$TimeEntriesTableReferences
                              ._keystrokeCountsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$TimeEntriesTableReferences(
                                db,
                                table,
                                p0,
                              ).keystrokeCountsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.timeEntryId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$TimeEntriesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $TimeEntriesTable,
      TimeEntryRow,
      $$TimeEntriesTableFilterComposer,
      $$TimeEntriesTableOrderingComposer,
      $$TimeEntriesTableAnnotationComposer,
      $$TimeEntriesTableCreateCompanionBuilder,
      $$TimeEntriesTableUpdateCompanionBuilder,
      (TimeEntryRow, $$TimeEntriesTableReferences),
      TimeEntryRow,
      PrefetchHooks Function({
        bool projectId,
        bool taskId,
        bool screenshotsRefs,
        bool keystrokeCountsRefs,
      })
    >;
typedef $$ScreenshotsTableCreateCompanionBuilder =
    ScreenshotsCompanion Function({
      required String id,
      required String timeEntryId,
      required String filePath,
      required DateTime takenAt,
      Value<int> rowid,
    });
typedef $$ScreenshotsTableUpdateCompanionBuilder =
    ScreenshotsCompanion Function({
      Value<String> id,
      Value<String> timeEntryId,
      Value<String> filePath,
      Value<DateTime> takenAt,
      Value<int> rowid,
    });

final class $$ScreenshotsTableReferences
    extends BaseReferences<_$AppDatabase, $ScreenshotsTable, ScreenshotRow> {
  $$ScreenshotsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $TimeEntriesTable _timeEntryIdTable(_$AppDatabase db) =>
      db.timeEntries.createAlias(
        $_aliasNameGenerator(db.screenshots.timeEntryId, db.timeEntries.id),
      );

  $$TimeEntriesTableProcessedTableManager get timeEntryId {
    final $_column = $_itemColumn<String>('time_entry_id')!;

    final manager = $$TimeEntriesTableTableManager(
      $_db,
      $_db.timeEntries,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_timeEntryIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$ScreenshotsTableFilterComposer
    extends Composer<_$AppDatabase, $ScreenshotsTable> {
  $$ScreenshotsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get filePath => $composableBuilder(
    column: $table.filePath,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get takenAt => $composableBuilder(
    column: $table.takenAt,
    builder: (column) => ColumnFilters(column),
  );

  $$TimeEntriesTableFilterComposer get timeEntryId {
    final $$TimeEntriesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.timeEntryId,
      referencedTable: $db.timeEntries,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TimeEntriesTableFilterComposer(
            $db: $db,
            $table: $db.timeEntries,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ScreenshotsTableOrderingComposer
    extends Composer<_$AppDatabase, $ScreenshotsTable> {
  $$ScreenshotsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get filePath => $composableBuilder(
    column: $table.filePath,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get takenAt => $composableBuilder(
    column: $table.takenAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$TimeEntriesTableOrderingComposer get timeEntryId {
    final $$TimeEntriesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.timeEntryId,
      referencedTable: $db.timeEntries,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TimeEntriesTableOrderingComposer(
            $db: $db,
            $table: $db.timeEntries,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ScreenshotsTableAnnotationComposer
    extends Composer<_$AppDatabase, $ScreenshotsTable> {
  $$ScreenshotsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get filePath =>
      $composableBuilder(column: $table.filePath, builder: (column) => column);

  GeneratedColumn<DateTime> get takenAt =>
      $composableBuilder(column: $table.takenAt, builder: (column) => column);

  $$TimeEntriesTableAnnotationComposer get timeEntryId {
    final $$TimeEntriesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.timeEntryId,
      referencedTable: $db.timeEntries,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TimeEntriesTableAnnotationComposer(
            $db: $db,
            $table: $db.timeEntries,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ScreenshotsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ScreenshotsTable,
          ScreenshotRow,
          $$ScreenshotsTableFilterComposer,
          $$ScreenshotsTableOrderingComposer,
          $$ScreenshotsTableAnnotationComposer,
          $$ScreenshotsTableCreateCompanionBuilder,
          $$ScreenshotsTableUpdateCompanionBuilder,
          (ScreenshotRow, $$ScreenshotsTableReferences),
          ScreenshotRow,
          PrefetchHooks Function({bool timeEntryId})
        > {
  $$ScreenshotsTableTableManager(_$AppDatabase db, $ScreenshotsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ScreenshotsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ScreenshotsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ScreenshotsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> timeEntryId = const Value.absent(),
                Value<String> filePath = const Value.absent(),
                Value<DateTime> takenAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ScreenshotsCompanion(
                id: id,
                timeEntryId: timeEntryId,
                filePath: filePath,
                takenAt: takenAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String timeEntryId,
                required String filePath,
                required DateTime takenAt,
                Value<int> rowid = const Value.absent(),
              }) => ScreenshotsCompanion.insert(
                id: id,
                timeEntryId: timeEntryId,
                filePath: filePath,
                takenAt: takenAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$ScreenshotsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({timeEntryId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (timeEntryId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.timeEntryId,
                                referencedTable: $$ScreenshotsTableReferences
                                    ._timeEntryIdTable(db),
                                referencedColumn: $$ScreenshotsTableReferences
                                    ._timeEntryIdTable(db)
                                    .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$ScreenshotsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ScreenshotsTable,
      ScreenshotRow,
      $$ScreenshotsTableFilterComposer,
      $$ScreenshotsTableOrderingComposer,
      $$ScreenshotsTableAnnotationComposer,
      $$ScreenshotsTableCreateCompanionBuilder,
      $$ScreenshotsTableUpdateCompanionBuilder,
      (ScreenshotRow, $$ScreenshotsTableReferences),
      ScreenshotRow,
      PrefetchHooks Function({bool timeEntryId})
    >;
typedef $$AppSettingsTableCreateCompanionBuilder =
    AppSettingsCompanion Function({
      required String key,
      required String value,
      Value<int> rowid,
    });
typedef $$AppSettingsTableUpdateCompanionBuilder =
    AppSettingsCompanion Function({
      Value<String> key,
      Value<String> value,
      Value<int> rowid,
    });

class $$AppSettingsTableFilterComposer
    extends Composer<_$AppDatabase, $AppSettingsTable> {
  $$AppSettingsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get key => $composableBuilder(
    column: $table.key,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get value => $composableBuilder(
    column: $table.value,
    builder: (column) => ColumnFilters(column),
  );
}

class $$AppSettingsTableOrderingComposer
    extends Composer<_$AppDatabase, $AppSettingsTable> {
  $$AppSettingsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get key => $composableBuilder(
    column: $table.key,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get value => $composableBuilder(
    column: $table.value,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$AppSettingsTableAnnotationComposer
    extends Composer<_$AppDatabase, $AppSettingsTable> {
  $$AppSettingsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get key =>
      $composableBuilder(column: $table.key, builder: (column) => column);

  GeneratedColumn<String> get value =>
      $composableBuilder(column: $table.value, builder: (column) => column);
}

class $$AppSettingsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $AppSettingsTable,
          SettingRow,
          $$AppSettingsTableFilterComposer,
          $$AppSettingsTableOrderingComposer,
          $$AppSettingsTableAnnotationComposer,
          $$AppSettingsTableCreateCompanionBuilder,
          $$AppSettingsTableUpdateCompanionBuilder,
          (
            SettingRow,
            BaseReferences<_$AppDatabase, $AppSettingsTable, SettingRow>,
          ),
          SettingRow,
          PrefetchHooks Function()
        > {
  $$AppSettingsTableTableManager(_$AppDatabase db, $AppSettingsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AppSettingsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AppSettingsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AppSettingsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> key = const Value.absent(),
                Value<String> value = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => AppSettingsCompanion(key: key, value: value, rowid: rowid),
          createCompanionCallback:
              ({
                required String key,
                required String value,
                Value<int> rowid = const Value.absent(),
              }) => AppSettingsCompanion.insert(
                key: key,
                value: value,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$AppSettingsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $AppSettingsTable,
      SettingRow,
      $$AppSettingsTableFilterComposer,
      $$AppSettingsTableOrderingComposer,
      $$AppSettingsTableAnnotationComposer,
      $$AppSettingsTableCreateCompanionBuilder,
      $$AppSettingsTableUpdateCompanionBuilder,
      (
        SettingRow,
        BaseReferences<_$AppDatabase, $AppSettingsTable, SettingRow>,
      ),
      SettingRow,
      PrefetchHooks Function()
    >;
typedef $$AlarmsTableCreateCompanionBuilder =
    AlarmsCompanion Function({
      required String id,
      Value<String> label,
      required int hour,
      required int minute,
      Value<bool> enabled,
      Value<int> repeatDays,
      required DateTime createdAt,
      required DateTime updatedAt,
      Value<int> rowid,
    });
typedef $$AlarmsTableUpdateCompanionBuilder =
    AlarmsCompanion Function({
      Value<String> id,
      Value<String> label,
      Value<int> hour,
      Value<int> minute,
      Value<bool> enabled,
      Value<int> repeatDays,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });

class $$AlarmsTableFilterComposer
    extends Composer<_$AppDatabase, $AlarmsTable> {
  $$AlarmsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get label => $composableBuilder(
    column: $table.label,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get hour => $composableBuilder(
    column: $table.hour,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get minute => $composableBuilder(
    column: $table.minute,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get enabled => $composableBuilder(
    column: $table.enabled,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get repeatDays => $composableBuilder(
    column: $table.repeatDays,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$AlarmsTableOrderingComposer
    extends Composer<_$AppDatabase, $AlarmsTable> {
  $$AlarmsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get label => $composableBuilder(
    column: $table.label,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get hour => $composableBuilder(
    column: $table.hour,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get minute => $composableBuilder(
    column: $table.minute,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get enabled => $composableBuilder(
    column: $table.enabled,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get repeatDays => $composableBuilder(
    column: $table.repeatDays,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$AlarmsTableAnnotationComposer
    extends Composer<_$AppDatabase, $AlarmsTable> {
  $$AlarmsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get label =>
      $composableBuilder(column: $table.label, builder: (column) => column);

  GeneratedColumn<int> get hour =>
      $composableBuilder(column: $table.hour, builder: (column) => column);

  GeneratedColumn<int> get minute =>
      $composableBuilder(column: $table.minute, builder: (column) => column);

  GeneratedColumn<bool> get enabled =>
      $composableBuilder(column: $table.enabled, builder: (column) => column);

  GeneratedColumn<int> get repeatDays => $composableBuilder(
    column: $table.repeatDays,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$AlarmsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $AlarmsTable,
          AlarmRow,
          $$AlarmsTableFilterComposer,
          $$AlarmsTableOrderingComposer,
          $$AlarmsTableAnnotationComposer,
          $$AlarmsTableCreateCompanionBuilder,
          $$AlarmsTableUpdateCompanionBuilder,
          (AlarmRow, BaseReferences<_$AppDatabase, $AlarmsTable, AlarmRow>),
          AlarmRow,
          PrefetchHooks Function()
        > {
  $$AlarmsTableTableManager(_$AppDatabase db, $AlarmsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$AlarmsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$AlarmsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$AlarmsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> label = const Value.absent(),
                Value<int> hour = const Value.absent(),
                Value<int> minute = const Value.absent(),
                Value<bool> enabled = const Value.absent(),
                Value<int> repeatDays = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => AlarmsCompanion(
                id: id,
                label: label,
                hour: hour,
                minute: minute,
                enabled: enabled,
                repeatDays: repeatDays,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                Value<String> label = const Value.absent(),
                required int hour,
                required int minute,
                Value<bool> enabled = const Value.absent(),
                Value<int> repeatDays = const Value.absent(),
                required DateTime createdAt,
                required DateTime updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => AlarmsCompanion.insert(
                id: id,
                label: label,
                hour: hour,
                minute: minute,
                enabled: enabled,
                repeatDays: repeatDays,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$AlarmsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $AlarmsTable,
      AlarmRow,
      $$AlarmsTableFilterComposer,
      $$AlarmsTableOrderingComposer,
      $$AlarmsTableAnnotationComposer,
      $$AlarmsTableCreateCompanionBuilder,
      $$AlarmsTableUpdateCompanionBuilder,
      (AlarmRow, BaseReferences<_$AppDatabase, $AlarmsTable, AlarmRow>),
      AlarmRow,
      PrefetchHooks Function()
    >;
typedef $$StopwatchLapsTableCreateCompanionBuilder =
    StopwatchLapsCompanion Function({
      required String id,
      required String sessionId,
      required int lapIndex,
      required int lapMs,
      required int totalMs,
      required DateTime createdAt,
      Value<int> rowid,
    });
typedef $$StopwatchLapsTableUpdateCompanionBuilder =
    StopwatchLapsCompanion Function({
      Value<String> id,
      Value<String> sessionId,
      Value<int> lapIndex,
      Value<int> lapMs,
      Value<int> totalMs,
      Value<DateTime> createdAt,
      Value<int> rowid,
    });

class $$StopwatchLapsTableFilterComposer
    extends Composer<_$AppDatabase, $StopwatchLapsTable> {
  $$StopwatchLapsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get sessionId => $composableBuilder(
    column: $table.sessionId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get lapIndex => $composableBuilder(
    column: $table.lapIndex,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get lapMs => $composableBuilder(
    column: $table.lapMs,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get totalMs => $composableBuilder(
    column: $table.totalMs,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$StopwatchLapsTableOrderingComposer
    extends Composer<_$AppDatabase, $StopwatchLapsTable> {
  $$StopwatchLapsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get sessionId => $composableBuilder(
    column: $table.sessionId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get lapIndex => $composableBuilder(
    column: $table.lapIndex,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get lapMs => $composableBuilder(
    column: $table.lapMs,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get totalMs => $composableBuilder(
    column: $table.totalMs,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$StopwatchLapsTableAnnotationComposer
    extends Composer<_$AppDatabase, $StopwatchLapsTable> {
  $$StopwatchLapsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get sessionId =>
      $composableBuilder(column: $table.sessionId, builder: (column) => column);

  GeneratedColumn<int> get lapIndex =>
      $composableBuilder(column: $table.lapIndex, builder: (column) => column);

  GeneratedColumn<int> get lapMs =>
      $composableBuilder(column: $table.lapMs, builder: (column) => column);

  GeneratedColumn<int> get totalMs =>
      $composableBuilder(column: $table.totalMs, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$StopwatchLapsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $StopwatchLapsTable,
          StopwatchLapRow,
          $$StopwatchLapsTableFilterComposer,
          $$StopwatchLapsTableOrderingComposer,
          $$StopwatchLapsTableAnnotationComposer,
          $$StopwatchLapsTableCreateCompanionBuilder,
          $$StopwatchLapsTableUpdateCompanionBuilder,
          (
            StopwatchLapRow,
            BaseReferences<_$AppDatabase, $StopwatchLapsTable, StopwatchLapRow>,
          ),
          StopwatchLapRow,
          PrefetchHooks Function()
        > {
  $$StopwatchLapsTableTableManager(_$AppDatabase db, $StopwatchLapsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$StopwatchLapsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$StopwatchLapsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$StopwatchLapsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> sessionId = const Value.absent(),
                Value<int> lapIndex = const Value.absent(),
                Value<int> lapMs = const Value.absent(),
                Value<int> totalMs = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => StopwatchLapsCompanion(
                id: id,
                sessionId: sessionId,
                lapIndex: lapIndex,
                lapMs: lapMs,
                totalMs: totalMs,
                createdAt: createdAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String sessionId,
                required int lapIndex,
                required int lapMs,
                required int totalMs,
                required DateTime createdAt,
                Value<int> rowid = const Value.absent(),
              }) => StopwatchLapsCompanion.insert(
                id: id,
                sessionId: sessionId,
                lapIndex: lapIndex,
                lapMs: lapMs,
                totalMs: totalMs,
                createdAt: createdAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$StopwatchLapsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $StopwatchLapsTable,
      StopwatchLapRow,
      $$StopwatchLapsTableFilterComposer,
      $$StopwatchLapsTableOrderingComposer,
      $$StopwatchLapsTableAnnotationComposer,
      $$StopwatchLapsTableCreateCompanionBuilder,
      $$StopwatchLapsTableUpdateCompanionBuilder,
      (
        StopwatchLapRow,
        BaseReferences<_$AppDatabase, $StopwatchLapsTable, StopwatchLapRow>,
      ),
      StopwatchLapRow,
      PrefetchHooks Function()
    >;
typedef $$KeystrokeCountsTableCreateCompanionBuilder =
    KeystrokeCountsCompanion Function({
      required String id,
      required String timeEntryId,
      required String keyLabel,
      Value<int> count,
      Value<int> rowid,
    });
typedef $$KeystrokeCountsTableUpdateCompanionBuilder =
    KeystrokeCountsCompanion Function({
      Value<String> id,
      Value<String> timeEntryId,
      Value<String> keyLabel,
      Value<int> count,
      Value<int> rowid,
    });

final class $$KeystrokeCountsTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $KeystrokeCountsTable,
          KeystrokeCountRow
        > {
  $$KeystrokeCountsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $TimeEntriesTable _timeEntryIdTable(_$AppDatabase db) =>
      db.timeEntries.createAlias(
        $_aliasNameGenerator(db.keystrokeCounts.timeEntryId, db.timeEntries.id),
      );

  $$TimeEntriesTableProcessedTableManager get timeEntryId {
    final $_column = $_itemColumn<String>('time_entry_id')!;

    final manager = $$TimeEntriesTableTableManager(
      $_db,
      $_db.timeEntries,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_timeEntryIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$KeystrokeCountsTableFilterComposer
    extends Composer<_$AppDatabase, $KeystrokeCountsTable> {
  $$KeystrokeCountsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get keyLabel => $composableBuilder(
    column: $table.keyLabel,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get count => $composableBuilder(
    column: $table.count,
    builder: (column) => ColumnFilters(column),
  );

  $$TimeEntriesTableFilterComposer get timeEntryId {
    final $$TimeEntriesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.timeEntryId,
      referencedTable: $db.timeEntries,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TimeEntriesTableFilterComposer(
            $db: $db,
            $table: $db.timeEntries,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$KeystrokeCountsTableOrderingComposer
    extends Composer<_$AppDatabase, $KeystrokeCountsTable> {
  $$KeystrokeCountsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get keyLabel => $composableBuilder(
    column: $table.keyLabel,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get count => $composableBuilder(
    column: $table.count,
    builder: (column) => ColumnOrderings(column),
  );

  $$TimeEntriesTableOrderingComposer get timeEntryId {
    final $$TimeEntriesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.timeEntryId,
      referencedTable: $db.timeEntries,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TimeEntriesTableOrderingComposer(
            $db: $db,
            $table: $db.timeEntries,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$KeystrokeCountsTableAnnotationComposer
    extends Composer<_$AppDatabase, $KeystrokeCountsTable> {
  $$KeystrokeCountsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get keyLabel =>
      $composableBuilder(column: $table.keyLabel, builder: (column) => column);

  GeneratedColumn<int> get count =>
      $composableBuilder(column: $table.count, builder: (column) => column);

  $$TimeEntriesTableAnnotationComposer get timeEntryId {
    final $$TimeEntriesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.timeEntryId,
      referencedTable: $db.timeEntries,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TimeEntriesTableAnnotationComposer(
            $db: $db,
            $table: $db.timeEntries,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$KeystrokeCountsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $KeystrokeCountsTable,
          KeystrokeCountRow,
          $$KeystrokeCountsTableFilterComposer,
          $$KeystrokeCountsTableOrderingComposer,
          $$KeystrokeCountsTableAnnotationComposer,
          $$KeystrokeCountsTableCreateCompanionBuilder,
          $$KeystrokeCountsTableUpdateCompanionBuilder,
          (KeystrokeCountRow, $$KeystrokeCountsTableReferences),
          KeystrokeCountRow,
          PrefetchHooks Function({bool timeEntryId})
        > {
  $$KeystrokeCountsTableTableManager(
    _$AppDatabase db,
    $KeystrokeCountsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$KeystrokeCountsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$KeystrokeCountsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$KeystrokeCountsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> timeEntryId = const Value.absent(),
                Value<String> keyLabel = const Value.absent(),
                Value<int> count = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => KeystrokeCountsCompanion(
                id: id,
                timeEntryId: timeEntryId,
                keyLabel: keyLabel,
                count: count,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String timeEntryId,
                required String keyLabel,
                Value<int> count = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => KeystrokeCountsCompanion.insert(
                id: id,
                timeEntryId: timeEntryId,
                keyLabel: keyLabel,
                count: count,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$KeystrokeCountsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({timeEntryId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (timeEntryId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.timeEntryId,
                                referencedTable:
                                    $$KeystrokeCountsTableReferences
                                        ._timeEntryIdTable(db),
                                referencedColumn:
                                    $$KeystrokeCountsTableReferences
                                        ._timeEntryIdTable(db)
                                        .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$KeystrokeCountsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $KeystrokeCountsTable,
      KeystrokeCountRow,
      $$KeystrokeCountsTableFilterComposer,
      $$KeystrokeCountsTableOrderingComposer,
      $$KeystrokeCountsTableAnnotationComposer,
      $$KeystrokeCountsTableCreateCompanionBuilder,
      $$KeystrokeCountsTableUpdateCompanionBuilder,
      (KeystrokeCountRow, $$KeystrokeCountsTableReferences),
      KeystrokeCountRow,
      PrefetchHooks Function({bool timeEntryId})
    >;
typedef $$NotebooksTableCreateCompanionBuilder =
    NotebooksCompanion Function({
      required String id,
      required String name,
      required int coverColor,
      Value<String?> coverImagePath,
      Value<int> sortOrder,
      required DateTime createdAt,
      required DateTime updatedAt,
      Value<int> rowid,
    });
typedef $$NotebooksTableUpdateCompanionBuilder =
    NotebooksCompanion Function({
      Value<String> id,
      Value<String> name,
      Value<int> coverColor,
      Value<String?> coverImagePath,
      Value<int> sortOrder,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });

final class $$NotebooksTableReferences
    extends BaseReferences<_$AppDatabase, $NotebooksTable, NotebookRow> {
  $$NotebooksTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$NotesTable, List<NoteRow>> _notesRefsTable(
    _$AppDatabase db,
  ) => MultiTypedResultKey.fromTable(
    db.notes,
    aliasName: $_aliasNameGenerator(db.notebooks.id, db.notes.notebookId),
  );

  $$NotesTableProcessedTableManager get notesRefs {
    final manager = $$NotesTableTableManager(
      $_db,
      $_db.notes,
    ).filter((f) => f.notebookId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_notesRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$NotebooksTableFilterComposer
    extends Composer<_$AppDatabase, $NotebooksTable> {
  $$NotebooksTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get coverColor => $composableBuilder(
    column: $table.coverColor,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get coverImagePath => $composableBuilder(
    column: $table.coverImagePath,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> notesRefs(
    Expression<bool> Function($$NotesTableFilterComposer f) f,
  ) {
    final $$NotesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.notes,
      getReferencedColumn: (t) => t.notebookId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$NotesTableFilterComposer(
            $db: $db,
            $table: $db.notes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$NotebooksTableOrderingComposer
    extends Composer<_$AppDatabase, $NotebooksTable> {
  $$NotebooksTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get coverColor => $composableBuilder(
    column: $table.coverColor,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get coverImagePath => $composableBuilder(
    column: $table.coverImagePath,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$NotebooksTableAnnotationComposer
    extends Composer<_$AppDatabase, $NotebooksTable> {
  $$NotebooksTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<int> get coverColor => $composableBuilder(
    column: $table.coverColor,
    builder: (column) => column,
  );

  GeneratedColumn<String> get coverImagePath => $composableBuilder(
    column: $table.coverImagePath,
    builder: (column) => column,
  );

  GeneratedColumn<int> get sortOrder =>
      $composableBuilder(column: $table.sortOrder, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  Expression<T> notesRefs<T extends Object>(
    Expression<T> Function($$NotesTableAnnotationComposer a) f,
  ) {
    final $$NotesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.notes,
      getReferencedColumn: (t) => t.notebookId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$NotesTableAnnotationComposer(
            $db: $db,
            $table: $db.notes,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$NotebooksTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $NotebooksTable,
          NotebookRow,
          $$NotebooksTableFilterComposer,
          $$NotebooksTableOrderingComposer,
          $$NotebooksTableAnnotationComposer,
          $$NotebooksTableCreateCompanionBuilder,
          $$NotebooksTableUpdateCompanionBuilder,
          (NotebookRow, $$NotebooksTableReferences),
          NotebookRow,
          PrefetchHooks Function({bool notesRefs})
        > {
  $$NotebooksTableTableManager(_$AppDatabase db, $NotebooksTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$NotebooksTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$NotebooksTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$NotebooksTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<int> coverColor = const Value.absent(),
                Value<String?> coverImagePath = const Value.absent(),
                Value<int> sortOrder = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => NotebooksCompanion(
                id: id,
                name: name,
                coverColor: coverColor,
                coverImagePath: coverImagePath,
                sortOrder: sortOrder,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String name,
                required int coverColor,
                Value<String?> coverImagePath = const Value.absent(),
                Value<int> sortOrder = const Value.absent(),
                required DateTime createdAt,
                required DateTime updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => NotebooksCompanion.insert(
                id: id,
                name: name,
                coverColor: coverColor,
                coverImagePath: coverImagePath,
                sortOrder: sortOrder,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$NotebooksTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({notesRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [if (notesRefs) db.notes],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (notesRefs)
                    await $_getPrefetchedData<
                      NotebookRow,
                      $NotebooksTable,
                      NoteRow
                    >(
                      currentTable: table,
                      referencedTable: $$NotebooksTableReferences
                          ._notesRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$NotebooksTableReferences(db, table, p0).notesRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.notebookId == item.id),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$NotebooksTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $NotebooksTable,
      NotebookRow,
      $$NotebooksTableFilterComposer,
      $$NotebooksTableOrderingComposer,
      $$NotebooksTableAnnotationComposer,
      $$NotebooksTableCreateCompanionBuilder,
      $$NotebooksTableUpdateCompanionBuilder,
      (NotebookRow, $$NotebooksTableReferences),
      NotebookRow,
      PrefetchHooks Function({bool notesRefs})
    >;
typedef $$NotesTableCreateCompanionBuilder =
    NotesCompanion Function({
      required String id,
      required String notebookId,
      Value<String> title,
      Value<String> body,
      Value<String> noteType,
      required int color,
      Value<bool> isPinned,
      Value<bool> isFavorite,
      Value<bool> isLocked,
      Value<String?> projectId,
      Value<String?> taskId,
      required DateTime createdAt,
      required DateTime updatedAt,
      Value<int> rowid,
    });
typedef $$NotesTableUpdateCompanionBuilder =
    NotesCompanion Function({
      Value<String> id,
      Value<String> notebookId,
      Value<String> title,
      Value<String> body,
      Value<String> noteType,
      Value<int> color,
      Value<bool> isPinned,
      Value<bool> isFavorite,
      Value<bool> isLocked,
      Value<String?> projectId,
      Value<String?> taskId,
      Value<DateTime> createdAt,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });

final class $$NotesTableReferences
    extends BaseReferences<_$AppDatabase, $NotesTable, NoteRow> {
  $$NotesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $NotebooksTable _notebookIdTable(_$AppDatabase db) => db.notebooks
      .createAlias($_aliasNameGenerator(db.notes.notebookId, db.notebooks.id));

  $$NotebooksTableProcessedTableManager get notebookId {
    final $_column = $_itemColumn<String>('notebook_id')!;

    final manager = $$NotebooksTableTableManager(
      $_db,
      $_db.notebooks,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_notebookIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $ProjectsTable _projectIdTable(_$AppDatabase db) => db.projects
      .createAlias($_aliasNameGenerator(db.notes.projectId, db.projects.id));

  $$ProjectsTableProcessedTableManager? get projectId {
    final $_column = $_itemColumn<String>('project_id');
    if ($_column == null) return null;
    final manager = $$ProjectsTableTableManager(
      $_db,
      $_db.projects,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_projectIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $TasksTable _taskIdTable(_$AppDatabase db) =>
      db.tasks.createAlias($_aliasNameGenerator(db.notes.taskId, db.tasks.id));

  $$TasksTableProcessedTableManager? get taskId {
    final $_column = $_itemColumn<String>('task_id');
    if ($_column == null) return null;
    final manager = $$TasksTableTableManager(
      $_db,
      $_db.tasks,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_taskIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$NotesTableFilterComposer extends Composer<_$AppDatabase, $NotesTable> {
  $$NotesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get body => $composableBuilder(
    column: $table.body,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get noteType => $composableBuilder(
    column: $table.noteType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get color => $composableBuilder(
    column: $table.color,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isPinned => $composableBuilder(
    column: $table.isPinned,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isFavorite => $composableBuilder(
    column: $table.isFavorite,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isLocked => $composableBuilder(
    column: $table.isLocked,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  $$NotebooksTableFilterComposer get notebookId {
    final $$NotebooksTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.notebookId,
      referencedTable: $db.notebooks,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$NotebooksTableFilterComposer(
            $db: $db,
            $table: $db.notebooks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ProjectsTableFilterComposer get projectId {
    final $$ProjectsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.projectId,
      referencedTable: $db.projects,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProjectsTableFilterComposer(
            $db: $db,
            $table: $db.projects,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$TasksTableFilterComposer get taskId {
    final $$TasksTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.taskId,
      referencedTable: $db.tasks,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TasksTableFilterComposer(
            $db: $db,
            $table: $db.tasks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$NotesTableOrderingComposer
    extends Composer<_$AppDatabase, $NotesTable> {
  $$NotesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get body => $composableBuilder(
    column: $table.body,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get noteType => $composableBuilder(
    column: $table.noteType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get color => $composableBuilder(
    column: $table.color,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isPinned => $composableBuilder(
    column: $table.isPinned,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isFavorite => $composableBuilder(
    column: $table.isFavorite,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isLocked => $composableBuilder(
    column: $table.isLocked,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$NotebooksTableOrderingComposer get notebookId {
    final $$NotebooksTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.notebookId,
      referencedTable: $db.notebooks,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$NotebooksTableOrderingComposer(
            $db: $db,
            $table: $db.notebooks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ProjectsTableOrderingComposer get projectId {
    final $$ProjectsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.projectId,
      referencedTable: $db.projects,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProjectsTableOrderingComposer(
            $db: $db,
            $table: $db.projects,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$TasksTableOrderingComposer get taskId {
    final $$TasksTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.taskId,
      referencedTable: $db.tasks,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TasksTableOrderingComposer(
            $db: $db,
            $table: $db.tasks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$NotesTableAnnotationComposer
    extends Composer<_$AppDatabase, $NotesTable> {
  $$NotesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get body =>
      $composableBuilder(column: $table.body, builder: (column) => column);

  GeneratedColumn<String> get noteType =>
      $composableBuilder(column: $table.noteType, builder: (column) => column);

  GeneratedColumn<int> get color =>
      $composableBuilder(column: $table.color, builder: (column) => column);

  GeneratedColumn<bool> get isPinned =>
      $composableBuilder(column: $table.isPinned, builder: (column) => column);

  GeneratedColumn<bool> get isFavorite => $composableBuilder(
    column: $table.isFavorite,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isLocked =>
      $composableBuilder(column: $table.isLocked, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  $$NotebooksTableAnnotationComposer get notebookId {
    final $$NotebooksTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.notebookId,
      referencedTable: $db.notebooks,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$NotebooksTableAnnotationComposer(
            $db: $db,
            $table: $db.notebooks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$ProjectsTableAnnotationComposer get projectId {
    final $$ProjectsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.projectId,
      referencedTable: $db.projects,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ProjectsTableAnnotationComposer(
            $db: $db,
            $table: $db.projects,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$TasksTableAnnotationComposer get taskId {
    final $$TasksTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.taskId,
      referencedTable: $db.tasks,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TasksTableAnnotationComposer(
            $db: $db,
            $table: $db.tasks,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$NotesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $NotesTable,
          NoteRow,
          $$NotesTableFilterComposer,
          $$NotesTableOrderingComposer,
          $$NotesTableAnnotationComposer,
          $$NotesTableCreateCompanionBuilder,
          $$NotesTableUpdateCompanionBuilder,
          (NoteRow, $$NotesTableReferences),
          NoteRow,
          PrefetchHooks Function({bool notebookId, bool projectId, bool taskId})
        > {
  $$NotesTableTableManager(_$AppDatabase db, $NotesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$NotesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$NotesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$NotesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> notebookId = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<String> body = const Value.absent(),
                Value<String> noteType = const Value.absent(),
                Value<int> color = const Value.absent(),
                Value<bool> isPinned = const Value.absent(),
                Value<bool> isFavorite = const Value.absent(),
                Value<bool> isLocked = const Value.absent(),
                Value<String?> projectId = const Value.absent(),
                Value<String?> taskId = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => NotesCompanion(
                id: id,
                notebookId: notebookId,
                title: title,
                body: body,
                noteType: noteType,
                color: color,
                isPinned: isPinned,
                isFavorite: isFavorite,
                isLocked: isLocked,
                projectId: projectId,
                taskId: taskId,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String notebookId,
                Value<String> title = const Value.absent(),
                Value<String> body = const Value.absent(),
                Value<String> noteType = const Value.absent(),
                required int color,
                Value<bool> isPinned = const Value.absent(),
                Value<bool> isFavorite = const Value.absent(),
                Value<bool> isLocked = const Value.absent(),
                Value<String?> projectId = const Value.absent(),
                Value<String?> taskId = const Value.absent(),
                required DateTime createdAt,
                required DateTime updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => NotesCompanion.insert(
                id: id,
                notebookId: notebookId,
                title: title,
                body: body,
                noteType: noteType,
                color: color,
                isPinned: isPinned,
                isFavorite: isFavorite,
                isLocked: isLocked,
                projectId: projectId,
                taskId: taskId,
                createdAt: createdAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) =>
                    (e.readTable(table), $$NotesTableReferences(db, table, e)),
              )
              .toList(),
          prefetchHooksCallback:
              ({notebookId = false, projectId = false, taskId = false}) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (notebookId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.notebookId,
                                    referencedTable: $$NotesTableReferences
                                        ._notebookIdTable(db),
                                    referencedColumn: $$NotesTableReferences
                                        ._notebookIdTable(db)
                                        .id,
                                  )
                                  as T;
                        }
                        if (projectId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.projectId,
                                    referencedTable: $$NotesTableReferences
                                        ._projectIdTable(db),
                                    referencedColumn: $$NotesTableReferences
                                        ._projectIdTable(db)
                                        .id,
                                  )
                                  as T;
                        }
                        if (taskId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.taskId,
                                    referencedTable: $$NotesTableReferences
                                        ._taskIdTable(db),
                                    referencedColumn: $$NotesTableReferences
                                        ._taskIdTable(db)
                                        .id,
                                  )
                                  as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [];
                  },
                );
              },
        ),
      );
}

typedef $$NotesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $NotesTable,
      NoteRow,
      $$NotesTableFilterComposer,
      $$NotesTableOrderingComposer,
      $$NotesTableAnnotationComposer,
      $$NotesTableCreateCompanionBuilder,
      $$NotesTableUpdateCompanionBuilder,
      (NoteRow, $$NotesTableReferences),
      NoteRow,
      PrefetchHooks Function({bool notebookId, bool projectId, bool taskId})
    >;
typedef $$CalendarAccountsTableCreateCompanionBuilder =
    CalendarAccountsCompanion Function({
      required String id,
      required String provider,
      required String email,
      required String calendarId,
      required DateTime connectedAt,
      Value<DateTime?> lastSyncAt,
      Value<int> rowid,
    });
typedef $$CalendarAccountsTableUpdateCompanionBuilder =
    CalendarAccountsCompanion Function({
      Value<String> id,
      Value<String> provider,
      Value<String> email,
      Value<String> calendarId,
      Value<DateTime> connectedAt,
      Value<DateTime?> lastSyncAt,
      Value<int> rowid,
    });

final class $$CalendarAccountsTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $CalendarAccountsTable,
          CalendarAccountRow
        > {
  $$CalendarAccountsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static MultiTypedResultKey<
    $CachedCalendarEventsTable,
    List<CachedCalendarEventRow>
  >
  _cachedCalendarEventsRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.cachedCalendarEvents,
        aliasName: $_aliasNameGenerator(
          db.calendarAccounts.id,
          db.cachedCalendarEvents.accountId,
        ),
      );

  $$CachedCalendarEventsTableProcessedTableManager
  get cachedCalendarEventsRefs {
    final manager = $$CachedCalendarEventsTableTableManager(
      $_db,
      $_db.cachedCalendarEvents,
    ).filter((f) => f.accountId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _cachedCalendarEventsRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$CalendarAccountsTableFilterComposer
    extends Composer<_$AppDatabase, $CalendarAccountsTable> {
  $$CalendarAccountsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get provider => $composableBuilder(
    column: $table.provider,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get email => $composableBuilder(
    column: $table.email,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get calendarId => $composableBuilder(
    column: $table.calendarId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get connectedAt => $composableBuilder(
    column: $table.connectedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get lastSyncAt => $composableBuilder(
    column: $table.lastSyncAt,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> cachedCalendarEventsRefs(
    Expression<bool> Function($$CachedCalendarEventsTableFilterComposer f) f,
  ) {
    final $$CachedCalendarEventsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.cachedCalendarEvents,
      getReferencedColumn: (t) => t.accountId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CachedCalendarEventsTableFilterComposer(
            $db: $db,
            $table: $db.cachedCalendarEvents,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$CalendarAccountsTableOrderingComposer
    extends Composer<_$AppDatabase, $CalendarAccountsTable> {
  $$CalendarAccountsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get provider => $composableBuilder(
    column: $table.provider,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get email => $composableBuilder(
    column: $table.email,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get calendarId => $composableBuilder(
    column: $table.calendarId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get connectedAt => $composableBuilder(
    column: $table.connectedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get lastSyncAt => $composableBuilder(
    column: $table.lastSyncAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$CalendarAccountsTableAnnotationComposer
    extends Composer<_$AppDatabase, $CalendarAccountsTable> {
  $$CalendarAccountsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get provider =>
      $composableBuilder(column: $table.provider, builder: (column) => column);

  GeneratedColumn<String> get email =>
      $composableBuilder(column: $table.email, builder: (column) => column);

  GeneratedColumn<String> get calendarId => $composableBuilder(
    column: $table.calendarId,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get connectedAt => $composableBuilder(
    column: $table.connectedAt,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get lastSyncAt => $composableBuilder(
    column: $table.lastSyncAt,
    builder: (column) => column,
  );

  Expression<T> cachedCalendarEventsRefs<T extends Object>(
    Expression<T> Function($$CachedCalendarEventsTableAnnotationComposer a) f,
  ) {
    final $$CachedCalendarEventsTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.cachedCalendarEvents,
          getReferencedColumn: (t) => t.accountId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$CachedCalendarEventsTableAnnotationComposer(
                $db: $db,
                $table: $db.cachedCalendarEvents,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }
}

class $$CalendarAccountsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CalendarAccountsTable,
          CalendarAccountRow,
          $$CalendarAccountsTableFilterComposer,
          $$CalendarAccountsTableOrderingComposer,
          $$CalendarAccountsTableAnnotationComposer,
          $$CalendarAccountsTableCreateCompanionBuilder,
          $$CalendarAccountsTableUpdateCompanionBuilder,
          (CalendarAccountRow, $$CalendarAccountsTableReferences),
          CalendarAccountRow,
          PrefetchHooks Function({bool cachedCalendarEventsRefs})
        > {
  $$CalendarAccountsTableTableManager(
    _$AppDatabase db,
    $CalendarAccountsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CalendarAccountsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CalendarAccountsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CalendarAccountsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> provider = const Value.absent(),
                Value<String> email = const Value.absent(),
                Value<String> calendarId = const Value.absent(),
                Value<DateTime> connectedAt = const Value.absent(),
                Value<DateTime?> lastSyncAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CalendarAccountsCompanion(
                id: id,
                provider: provider,
                email: email,
                calendarId: calendarId,
                connectedAt: connectedAt,
                lastSyncAt: lastSyncAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String provider,
                required String email,
                required String calendarId,
                required DateTime connectedAt,
                Value<DateTime?> lastSyncAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CalendarAccountsCompanion.insert(
                id: id,
                provider: provider,
                email: email,
                calendarId: calendarId,
                connectedAt: connectedAt,
                lastSyncAt: lastSyncAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$CalendarAccountsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({cachedCalendarEventsRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (cachedCalendarEventsRefs) db.cachedCalendarEvents,
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (cachedCalendarEventsRefs)
                    await $_getPrefetchedData<
                      CalendarAccountRow,
                      $CalendarAccountsTable,
                      CachedCalendarEventRow
                    >(
                      currentTable: table,
                      referencedTable: $$CalendarAccountsTableReferences
                          ._cachedCalendarEventsRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$CalendarAccountsTableReferences(
                            db,
                            table,
                            p0,
                          ).cachedCalendarEventsRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where((e) => e.accountId == item.id),
                      typedResults: items,
                    ),
                ];
              },
            );
          },
        ),
      );
}

typedef $$CalendarAccountsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CalendarAccountsTable,
      CalendarAccountRow,
      $$CalendarAccountsTableFilterComposer,
      $$CalendarAccountsTableOrderingComposer,
      $$CalendarAccountsTableAnnotationComposer,
      $$CalendarAccountsTableCreateCompanionBuilder,
      $$CalendarAccountsTableUpdateCompanionBuilder,
      (CalendarAccountRow, $$CalendarAccountsTableReferences),
      CalendarAccountRow,
      PrefetchHooks Function({bool cachedCalendarEventsRefs})
    >;
typedef $$CachedCalendarEventsTableCreateCompanionBuilder =
    CachedCalendarEventsCompanion Function({
      required String id,
      required String accountId,
      required String googleEventId,
      required String title,
      Value<String?> description,
      required DateTime startAt,
      required DateTime endAt,
      Value<bool> allDay,
      Value<String?> htmlLink,
      Value<String?> etag,
      required DateTime updatedAt,
      Value<int> rowid,
    });
typedef $$CachedCalendarEventsTableUpdateCompanionBuilder =
    CachedCalendarEventsCompanion Function({
      Value<String> id,
      Value<String> accountId,
      Value<String> googleEventId,
      Value<String> title,
      Value<String?> description,
      Value<DateTime> startAt,
      Value<DateTime> endAt,
      Value<bool> allDay,
      Value<String?> htmlLink,
      Value<String?> etag,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });

final class $$CachedCalendarEventsTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $CachedCalendarEventsTable,
          CachedCalendarEventRow
        > {
  $$CachedCalendarEventsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $CalendarAccountsTable _accountIdTable(_$AppDatabase db) =>
      db.calendarAccounts.createAlias(
        $_aliasNameGenerator(
          db.cachedCalendarEvents.accountId,
          db.calendarAccounts.id,
        ),
      );

  $$CalendarAccountsTableProcessedTableManager get accountId {
    final $_column = $_itemColumn<String>('account_id')!;

    final manager = $$CalendarAccountsTableTableManager(
      $_db,
      $_db.calendarAccounts,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_accountIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$CachedCalendarEventsTableFilterComposer
    extends Composer<_$AppDatabase, $CachedCalendarEventsTable> {
  $$CachedCalendarEventsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get googleEventId => $composableBuilder(
    column: $table.googleEventId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get startAt => $composableBuilder(
    column: $table.startAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get endAt => $composableBuilder(
    column: $table.endAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get allDay => $composableBuilder(
    column: $table.allDay,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get htmlLink => $composableBuilder(
    column: $table.htmlLink,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get etag => $composableBuilder(
    column: $table.etag,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  $$CalendarAccountsTableFilterComposer get accountId {
    final $$CalendarAccountsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.accountId,
      referencedTable: $db.calendarAccounts,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CalendarAccountsTableFilterComposer(
            $db: $db,
            $table: $db.calendarAccounts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$CachedCalendarEventsTableOrderingComposer
    extends Composer<_$AppDatabase, $CachedCalendarEventsTable> {
  $$CachedCalendarEventsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get googleEventId => $composableBuilder(
    column: $table.googleEventId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get startAt => $composableBuilder(
    column: $table.startAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get endAt => $composableBuilder(
    column: $table.endAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get allDay => $composableBuilder(
    column: $table.allDay,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get htmlLink => $composableBuilder(
    column: $table.htmlLink,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get etag => $composableBuilder(
    column: $table.etag,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$CalendarAccountsTableOrderingComposer get accountId {
    final $$CalendarAccountsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.accountId,
      referencedTable: $db.calendarAccounts,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CalendarAccountsTableOrderingComposer(
            $db: $db,
            $table: $db.calendarAccounts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$CachedCalendarEventsTableAnnotationComposer
    extends Composer<_$AppDatabase, $CachedCalendarEventsTable> {
  $$CachedCalendarEventsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get googleEventId => $composableBuilder(
    column: $table.googleEventId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get startAt =>
      $composableBuilder(column: $table.startAt, builder: (column) => column);

  GeneratedColumn<DateTime> get endAt =>
      $composableBuilder(column: $table.endAt, builder: (column) => column);

  GeneratedColumn<bool> get allDay =>
      $composableBuilder(column: $table.allDay, builder: (column) => column);

  GeneratedColumn<String> get htmlLink =>
      $composableBuilder(column: $table.htmlLink, builder: (column) => column);

  GeneratedColumn<String> get etag =>
      $composableBuilder(column: $table.etag, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  $$CalendarAccountsTableAnnotationComposer get accountId {
    final $$CalendarAccountsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.accountId,
      referencedTable: $db.calendarAccounts,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CalendarAccountsTableAnnotationComposer(
            $db: $db,
            $table: $db.calendarAccounts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$CachedCalendarEventsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CachedCalendarEventsTable,
          CachedCalendarEventRow,
          $$CachedCalendarEventsTableFilterComposer,
          $$CachedCalendarEventsTableOrderingComposer,
          $$CachedCalendarEventsTableAnnotationComposer,
          $$CachedCalendarEventsTableCreateCompanionBuilder,
          $$CachedCalendarEventsTableUpdateCompanionBuilder,
          (CachedCalendarEventRow, $$CachedCalendarEventsTableReferences),
          CachedCalendarEventRow,
          PrefetchHooks Function({bool accountId})
        > {
  $$CachedCalendarEventsTableTableManager(
    _$AppDatabase db,
    $CachedCalendarEventsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CachedCalendarEventsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CachedCalendarEventsTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$CachedCalendarEventsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> accountId = const Value.absent(),
                Value<String> googleEventId = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<String?> description = const Value.absent(),
                Value<DateTime> startAt = const Value.absent(),
                Value<DateTime> endAt = const Value.absent(),
                Value<bool> allDay = const Value.absent(),
                Value<String?> htmlLink = const Value.absent(),
                Value<String?> etag = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CachedCalendarEventsCompanion(
                id: id,
                accountId: accountId,
                googleEventId: googleEventId,
                title: title,
                description: description,
                startAt: startAt,
                endAt: endAt,
                allDay: allDay,
                htmlLink: htmlLink,
                etag: etag,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String accountId,
                required String googleEventId,
                required String title,
                Value<String?> description = const Value.absent(),
                required DateTime startAt,
                required DateTime endAt,
                Value<bool> allDay = const Value.absent(),
                Value<String?> htmlLink = const Value.absent(),
                Value<String?> etag = const Value.absent(),
                required DateTime updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => CachedCalendarEventsCompanion.insert(
                id: id,
                accountId: accountId,
                googleEventId: googleEventId,
                title: title,
                description: description,
                startAt: startAt,
                endAt: endAt,
                allDay: allDay,
                htmlLink: htmlLink,
                etag: etag,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$CachedCalendarEventsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({accountId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (accountId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.accountId,
                                referencedTable:
                                    $$CachedCalendarEventsTableReferences
                                        ._accountIdTable(db),
                                referencedColumn:
                                    $$CachedCalendarEventsTableReferences
                                        ._accountIdTable(db)
                                        .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$CachedCalendarEventsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CachedCalendarEventsTable,
      CachedCalendarEventRow,
      $$CachedCalendarEventsTableFilterComposer,
      $$CachedCalendarEventsTableOrderingComposer,
      $$CachedCalendarEventsTableAnnotationComposer,
      $$CachedCalendarEventsTableCreateCompanionBuilder,
      $$CachedCalendarEventsTableUpdateCompanionBuilder,
      (CachedCalendarEventRow, $$CachedCalendarEventsTableReferences),
      CachedCalendarEventRow,
      PrefetchHooks Function({bool accountId})
    >;
typedef $$TelegramAccountsTableCreateCompanionBuilder =
    TelegramAccountsCompanion Function({
      required String id,
      required String phoneNumber,
      Value<String?> telegramUserId,
      Value<String?> username,
      Value<String?> displayName,
      required DateTime connectedAt,
      Value<DateTime?> lastSyncAt,
      Value<int> rowid,
    });
typedef $$TelegramAccountsTableUpdateCompanionBuilder =
    TelegramAccountsCompanion Function({
      Value<String> id,
      Value<String> phoneNumber,
      Value<String?> telegramUserId,
      Value<String?> username,
      Value<String?> displayName,
      Value<DateTime> connectedAt,
      Value<DateTime?> lastSyncAt,
      Value<int> rowid,
    });

final class $$TelegramAccountsTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $TelegramAccountsTable,
          TelegramAccountRow
        > {
  $$TelegramAccountsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static MultiTypedResultKey<$TelegramChatsTable, List<TelegramChatRow>>
  _telegramChatsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.telegramChats,
    aliasName: $_aliasNameGenerator(
      db.telegramAccounts.id,
      db.telegramChats.accountId,
    ),
  );

  $$TelegramChatsTableProcessedTableManager get telegramChatsRefs {
    final manager = $$TelegramChatsTableTableManager(
      $_db,
      $_db.telegramChats,
    ).filter((f) => f.accountId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_telegramChatsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$TelegramMessagesTable, List<TelegramMessageRow>>
  _telegramMessagesRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.telegramMessages,
    aliasName: $_aliasNameGenerator(
      db.telegramAccounts.id,
      db.telegramMessages.accountId,
    ),
  );

  $$TelegramMessagesTableProcessedTableManager get telegramMessagesRefs {
    final manager = $$TelegramMessagesTableTableManager(
      $_db,
      $_db.telegramMessages,
    ).filter((f) => f.accountId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _telegramMessagesRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$TelegramAccountsTableFilterComposer
    extends Composer<_$AppDatabase, $TelegramAccountsTable> {
  $$TelegramAccountsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get phoneNumber => $composableBuilder(
    column: $table.phoneNumber,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get telegramUserId => $composableBuilder(
    column: $table.telegramUserId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get username => $composableBuilder(
    column: $table.username,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get displayName => $composableBuilder(
    column: $table.displayName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get connectedAt => $composableBuilder(
    column: $table.connectedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get lastSyncAt => $composableBuilder(
    column: $table.lastSyncAt,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> telegramChatsRefs(
    Expression<bool> Function($$TelegramChatsTableFilterComposer f) f,
  ) {
    final $$TelegramChatsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.telegramChats,
      getReferencedColumn: (t) => t.accountId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TelegramChatsTableFilterComposer(
            $db: $db,
            $table: $db.telegramChats,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> telegramMessagesRefs(
    Expression<bool> Function($$TelegramMessagesTableFilterComposer f) f,
  ) {
    final $$TelegramMessagesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.telegramMessages,
      getReferencedColumn: (t) => t.accountId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TelegramMessagesTableFilterComposer(
            $db: $db,
            $table: $db.telegramMessages,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$TelegramAccountsTableOrderingComposer
    extends Composer<_$AppDatabase, $TelegramAccountsTable> {
  $$TelegramAccountsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get phoneNumber => $composableBuilder(
    column: $table.phoneNumber,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get telegramUserId => $composableBuilder(
    column: $table.telegramUserId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get username => $composableBuilder(
    column: $table.username,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get displayName => $composableBuilder(
    column: $table.displayName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get connectedAt => $composableBuilder(
    column: $table.connectedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get lastSyncAt => $composableBuilder(
    column: $table.lastSyncAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$TelegramAccountsTableAnnotationComposer
    extends Composer<_$AppDatabase, $TelegramAccountsTable> {
  $$TelegramAccountsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get phoneNumber => $composableBuilder(
    column: $table.phoneNumber,
    builder: (column) => column,
  );

  GeneratedColumn<String> get telegramUserId => $composableBuilder(
    column: $table.telegramUserId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get username =>
      $composableBuilder(column: $table.username, builder: (column) => column);

  GeneratedColumn<String> get displayName => $composableBuilder(
    column: $table.displayName,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get connectedAt => $composableBuilder(
    column: $table.connectedAt,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get lastSyncAt => $composableBuilder(
    column: $table.lastSyncAt,
    builder: (column) => column,
  );

  Expression<T> telegramChatsRefs<T extends Object>(
    Expression<T> Function($$TelegramChatsTableAnnotationComposer a) f,
  ) {
    final $$TelegramChatsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.telegramChats,
      getReferencedColumn: (t) => t.accountId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TelegramChatsTableAnnotationComposer(
            $db: $db,
            $table: $db.telegramChats,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> telegramMessagesRefs<T extends Object>(
    Expression<T> Function($$TelegramMessagesTableAnnotationComposer a) f,
  ) {
    final $$TelegramMessagesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.telegramMessages,
      getReferencedColumn: (t) => t.accountId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TelegramMessagesTableAnnotationComposer(
            $db: $db,
            $table: $db.telegramMessages,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$TelegramAccountsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $TelegramAccountsTable,
          TelegramAccountRow,
          $$TelegramAccountsTableFilterComposer,
          $$TelegramAccountsTableOrderingComposer,
          $$TelegramAccountsTableAnnotationComposer,
          $$TelegramAccountsTableCreateCompanionBuilder,
          $$TelegramAccountsTableUpdateCompanionBuilder,
          (TelegramAccountRow, $$TelegramAccountsTableReferences),
          TelegramAccountRow,
          PrefetchHooks Function({
            bool telegramChatsRefs,
            bool telegramMessagesRefs,
          })
        > {
  $$TelegramAccountsTableTableManager(
    _$AppDatabase db,
    $TelegramAccountsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TelegramAccountsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TelegramAccountsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TelegramAccountsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> phoneNumber = const Value.absent(),
                Value<String?> telegramUserId = const Value.absent(),
                Value<String?> username = const Value.absent(),
                Value<String?> displayName = const Value.absent(),
                Value<DateTime> connectedAt = const Value.absent(),
                Value<DateTime?> lastSyncAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => TelegramAccountsCompanion(
                id: id,
                phoneNumber: phoneNumber,
                telegramUserId: telegramUserId,
                username: username,
                displayName: displayName,
                connectedAt: connectedAt,
                lastSyncAt: lastSyncAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String phoneNumber,
                Value<String?> telegramUserId = const Value.absent(),
                Value<String?> username = const Value.absent(),
                Value<String?> displayName = const Value.absent(),
                required DateTime connectedAt,
                Value<DateTime?> lastSyncAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => TelegramAccountsCompanion.insert(
                id: id,
                phoneNumber: phoneNumber,
                telegramUserId: telegramUserId,
                username: username,
                displayName: displayName,
                connectedAt: connectedAt,
                lastSyncAt: lastSyncAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$TelegramAccountsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({telegramChatsRefs = false, telegramMessagesRefs = false}) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (telegramChatsRefs) db.telegramChats,
                    if (telegramMessagesRefs) db.telegramMessages,
                  ],
                  addJoins: null,
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (telegramChatsRefs)
                        await $_getPrefetchedData<
                          TelegramAccountRow,
                          $TelegramAccountsTable,
                          TelegramChatRow
                        >(
                          currentTable: table,
                          referencedTable: $$TelegramAccountsTableReferences
                              ._telegramChatsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$TelegramAccountsTableReferences(
                                db,
                                table,
                                p0,
                              ).telegramChatsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.accountId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (telegramMessagesRefs)
                        await $_getPrefetchedData<
                          TelegramAccountRow,
                          $TelegramAccountsTable,
                          TelegramMessageRow
                        >(
                          currentTable: table,
                          referencedTable: $$TelegramAccountsTableReferences
                              ._telegramMessagesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$TelegramAccountsTableReferences(
                                db,
                                table,
                                p0,
                              ).telegramMessagesRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.accountId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$TelegramAccountsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $TelegramAccountsTable,
      TelegramAccountRow,
      $$TelegramAccountsTableFilterComposer,
      $$TelegramAccountsTableOrderingComposer,
      $$TelegramAccountsTableAnnotationComposer,
      $$TelegramAccountsTableCreateCompanionBuilder,
      $$TelegramAccountsTableUpdateCompanionBuilder,
      (TelegramAccountRow, $$TelegramAccountsTableReferences),
      TelegramAccountRow,
      PrefetchHooks Function({
        bool telegramChatsRefs,
        bool telegramMessagesRefs,
      })
    >;
typedef $$TelegramChatsTableCreateCompanionBuilder =
    TelegramChatsCompanion Function({
      required String id,
      required String accountId,
      required String telegramChatId,
      required String title,
      required String chatType,
      Value<String?> username,
      Value<bool> isAllowed,
      Value<DateTime?> lastMessageAt,
      Value<int> unreadCount,
      Value<String?> photoPath,
      required DateTime updatedAt,
      Value<int> rowid,
    });
typedef $$TelegramChatsTableUpdateCompanionBuilder =
    TelegramChatsCompanion Function({
      Value<String> id,
      Value<String> accountId,
      Value<String> telegramChatId,
      Value<String> title,
      Value<String> chatType,
      Value<String?> username,
      Value<bool> isAllowed,
      Value<DateTime?> lastMessageAt,
      Value<int> unreadCount,
      Value<String?> photoPath,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });

final class $$TelegramChatsTableReferences
    extends
        BaseReferences<_$AppDatabase, $TelegramChatsTable, TelegramChatRow> {
  $$TelegramChatsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $TelegramAccountsTable _accountIdTable(_$AppDatabase db) =>
      db.telegramAccounts.createAlias(
        $_aliasNameGenerator(
          db.telegramChats.accountId,
          db.telegramAccounts.id,
        ),
      );

  $$TelegramAccountsTableProcessedTableManager get accountId {
    final $_column = $_itemColumn<String>('account_id')!;

    final manager = $$TelegramAccountsTableTableManager(
      $_db,
      $_db.telegramAccounts,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_accountIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$TelegramChatsTableFilterComposer
    extends Composer<_$AppDatabase, $TelegramChatsTable> {
  $$TelegramChatsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get telegramChatId => $composableBuilder(
    column: $table.telegramChatId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get chatType => $composableBuilder(
    column: $table.chatType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get username => $composableBuilder(
    column: $table.username,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isAllowed => $composableBuilder(
    column: $table.isAllowed,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get lastMessageAt => $composableBuilder(
    column: $table.lastMessageAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get unreadCount => $composableBuilder(
    column: $table.unreadCount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get photoPath => $composableBuilder(
    column: $table.photoPath,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  $$TelegramAccountsTableFilterComposer get accountId {
    final $$TelegramAccountsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.accountId,
      referencedTable: $db.telegramAccounts,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TelegramAccountsTableFilterComposer(
            $db: $db,
            $table: $db.telegramAccounts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$TelegramChatsTableOrderingComposer
    extends Composer<_$AppDatabase, $TelegramChatsTable> {
  $$TelegramChatsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get telegramChatId => $composableBuilder(
    column: $table.telegramChatId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get chatType => $composableBuilder(
    column: $table.chatType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get username => $composableBuilder(
    column: $table.username,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isAllowed => $composableBuilder(
    column: $table.isAllowed,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get lastMessageAt => $composableBuilder(
    column: $table.lastMessageAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get unreadCount => $composableBuilder(
    column: $table.unreadCount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get photoPath => $composableBuilder(
    column: $table.photoPath,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$TelegramAccountsTableOrderingComposer get accountId {
    final $$TelegramAccountsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.accountId,
      referencedTable: $db.telegramAccounts,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TelegramAccountsTableOrderingComposer(
            $db: $db,
            $table: $db.telegramAccounts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$TelegramChatsTableAnnotationComposer
    extends Composer<_$AppDatabase, $TelegramChatsTable> {
  $$TelegramChatsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get telegramChatId => $composableBuilder(
    column: $table.telegramChatId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get chatType =>
      $composableBuilder(column: $table.chatType, builder: (column) => column);

  GeneratedColumn<String> get username =>
      $composableBuilder(column: $table.username, builder: (column) => column);

  GeneratedColumn<bool> get isAllowed =>
      $composableBuilder(column: $table.isAllowed, builder: (column) => column);

  GeneratedColumn<DateTime> get lastMessageAt => $composableBuilder(
    column: $table.lastMessageAt,
    builder: (column) => column,
  );

  GeneratedColumn<int> get unreadCount => $composableBuilder(
    column: $table.unreadCount,
    builder: (column) => column,
  );

  GeneratedColumn<String> get photoPath =>
      $composableBuilder(column: $table.photoPath, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  $$TelegramAccountsTableAnnotationComposer get accountId {
    final $$TelegramAccountsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.accountId,
      referencedTable: $db.telegramAccounts,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TelegramAccountsTableAnnotationComposer(
            $db: $db,
            $table: $db.telegramAccounts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$TelegramChatsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $TelegramChatsTable,
          TelegramChatRow,
          $$TelegramChatsTableFilterComposer,
          $$TelegramChatsTableOrderingComposer,
          $$TelegramChatsTableAnnotationComposer,
          $$TelegramChatsTableCreateCompanionBuilder,
          $$TelegramChatsTableUpdateCompanionBuilder,
          (TelegramChatRow, $$TelegramChatsTableReferences),
          TelegramChatRow,
          PrefetchHooks Function({bool accountId})
        > {
  $$TelegramChatsTableTableManager(_$AppDatabase db, $TelegramChatsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TelegramChatsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TelegramChatsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TelegramChatsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> accountId = const Value.absent(),
                Value<String> telegramChatId = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<String> chatType = const Value.absent(),
                Value<String?> username = const Value.absent(),
                Value<bool> isAllowed = const Value.absent(),
                Value<DateTime?> lastMessageAt = const Value.absent(),
                Value<int> unreadCount = const Value.absent(),
                Value<String?> photoPath = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => TelegramChatsCompanion(
                id: id,
                accountId: accountId,
                telegramChatId: telegramChatId,
                title: title,
                chatType: chatType,
                username: username,
                isAllowed: isAllowed,
                lastMessageAt: lastMessageAt,
                unreadCount: unreadCount,
                photoPath: photoPath,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String accountId,
                required String telegramChatId,
                required String title,
                required String chatType,
                Value<String?> username = const Value.absent(),
                Value<bool> isAllowed = const Value.absent(),
                Value<DateTime?> lastMessageAt = const Value.absent(),
                Value<int> unreadCount = const Value.absent(),
                Value<String?> photoPath = const Value.absent(),
                required DateTime updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => TelegramChatsCompanion.insert(
                id: id,
                accountId: accountId,
                telegramChatId: telegramChatId,
                title: title,
                chatType: chatType,
                username: username,
                isAllowed: isAllowed,
                lastMessageAt: lastMessageAt,
                unreadCount: unreadCount,
                photoPath: photoPath,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$TelegramChatsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({accountId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (accountId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.accountId,
                                referencedTable: $$TelegramChatsTableReferences
                                    ._accountIdTable(db),
                                referencedColumn: $$TelegramChatsTableReferences
                                    ._accountIdTable(db)
                                    .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$TelegramChatsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $TelegramChatsTable,
      TelegramChatRow,
      $$TelegramChatsTableFilterComposer,
      $$TelegramChatsTableOrderingComposer,
      $$TelegramChatsTableAnnotationComposer,
      $$TelegramChatsTableCreateCompanionBuilder,
      $$TelegramChatsTableUpdateCompanionBuilder,
      (TelegramChatRow, $$TelegramChatsTableReferences),
      TelegramChatRow,
      PrefetchHooks Function({bool accountId})
    >;
typedef $$TelegramMessagesTableCreateCompanionBuilder =
    TelegramMessagesCompanion Function({
      required String id,
      required String accountId,
      required String telegramChatId,
      required String telegramMessageId,
      Value<String?> senderName,
      required String body,
      Value<String> contentType,
      Value<String?> mediaPath,
      Value<int?> mediaFileId,
      Value<String?> replyToMessageId,
      Value<String?> replyPreview,
      required DateTime sentAt,
      Value<bool> isOutgoing,
      Value<bool> isEdited,
      required DateTime updatedAt,
      Value<int> rowid,
    });
typedef $$TelegramMessagesTableUpdateCompanionBuilder =
    TelegramMessagesCompanion Function({
      Value<String> id,
      Value<String> accountId,
      Value<String> telegramChatId,
      Value<String> telegramMessageId,
      Value<String?> senderName,
      Value<String> body,
      Value<String> contentType,
      Value<String?> mediaPath,
      Value<int?> mediaFileId,
      Value<String?> replyToMessageId,
      Value<String?> replyPreview,
      Value<DateTime> sentAt,
      Value<bool> isOutgoing,
      Value<bool> isEdited,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });

final class $$TelegramMessagesTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $TelegramMessagesTable,
          TelegramMessageRow
        > {
  $$TelegramMessagesTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $TelegramAccountsTable _accountIdTable(_$AppDatabase db) =>
      db.telegramAccounts.createAlias(
        $_aliasNameGenerator(
          db.telegramMessages.accountId,
          db.telegramAccounts.id,
        ),
      );

  $$TelegramAccountsTableProcessedTableManager get accountId {
    final $_column = $_itemColumn<String>('account_id')!;

    final manager = $$TelegramAccountsTableTableManager(
      $_db,
      $_db.telegramAccounts,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_accountIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$TelegramMessagesTableFilterComposer
    extends Composer<_$AppDatabase, $TelegramMessagesTable> {
  $$TelegramMessagesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get telegramChatId => $composableBuilder(
    column: $table.telegramChatId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get telegramMessageId => $composableBuilder(
    column: $table.telegramMessageId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get senderName => $composableBuilder(
    column: $table.senderName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get body => $composableBuilder(
    column: $table.body,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get contentType => $composableBuilder(
    column: $table.contentType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get mediaPath => $composableBuilder(
    column: $table.mediaPath,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get mediaFileId => $composableBuilder(
    column: $table.mediaFileId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get replyToMessageId => $composableBuilder(
    column: $table.replyToMessageId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get replyPreview => $composableBuilder(
    column: $table.replyPreview,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get sentAt => $composableBuilder(
    column: $table.sentAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isOutgoing => $composableBuilder(
    column: $table.isOutgoing,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isEdited => $composableBuilder(
    column: $table.isEdited,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  $$TelegramAccountsTableFilterComposer get accountId {
    final $$TelegramAccountsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.accountId,
      referencedTable: $db.telegramAccounts,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TelegramAccountsTableFilterComposer(
            $db: $db,
            $table: $db.telegramAccounts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$TelegramMessagesTableOrderingComposer
    extends Composer<_$AppDatabase, $TelegramMessagesTable> {
  $$TelegramMessagesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get telegramChatId => $composableBuilder(
    column: $table.telegramChatId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get telegramMessageId => $composableBuilder(
    column: $table.telegramMessageId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get senderName => $composableBuilder(
    column: $table.senderName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get body => $composableBuilder(
    column: $table.body,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get contentType => $composableBuilder(
    column: $table.contentType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get mediaPath => $composableBuilder(
    column: $table.mediaPath,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get mediaFileId => $composableBuilder(
    column: $table.mediaFileId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get replyToMessageId => $composableBuilder(
    column: $table.replyToMessageId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get replyPreview => $composableBuilder(
    column: $table.replyPreview,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get sentAt => $composableBuilder(
    column: $table.sentAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isOutgoing => $composableBuilder(
    column: $table.isOutgoing,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isEdited => $composableBuilder(
    column: $table.isEdited,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$TelegramAccountsTableOrderingComposer get accountId {
    final $$TelegramAccountsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.accountId,
      referencedTable: $db.telegramAccounts,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TelegramAccountsTableOrderingComposer(
            $db: $db,
            $table: $db.telegramAccounts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$TelegramMessagesTableAnnotationComposer
    extends Composer<_$AppDatabase, $TelegramMessagesTable> {
  $$TelegramMessagesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get telegramChatId => $composableBuilder(
    column: $table.telegramChatId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get telegramMessageId => $composableBuilder(
    column: $table.telegramMessageId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get senderName => $composableBuilder(
    column: $table.senderName,
    builder: (column) => column,
  );

  GeneratedColumn<String> get body =>
      $composableBuilder(column: $table.body, builder: (column) => column);

  GeneratedColumn<String> get contentType => $composableBuilder(
    column: $table.contentType,
    builder: (column) => column,
  );

  GeneratedColumn<String> get mediaPath =>
      $composableBuilder(column: $table.mediaPath, builder: (column) => column);

  GeneratedColumn<int> get mediaFileId => $composableBuilder(
    column: $table.mediaFileId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get replyToMessageId => $composableBuilder(
    column: $table.replyToMessageId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get replyPreview => $composableBuilder(
    column: $table.replyPreview,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get sentAt =>
      $composableBuilder(column: $table.sentAt, builder: (column) => column);

  GeneratedColumn<bool> get isOutgoing => $composableBuilder(
    column: $table.isOutgoing,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isEdited =>
      $composableBuilder(column: $table.isEdited, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  $$TelegramAccountsTableAnnotationComposer get accountId {
    final $$TelegramAccountsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.accountId,
      referencedTable: $db.telegramAccounts,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$TelegramAccountsTableAnnotationComposer(
            $db: $db,
            $table: $db.telegramAccounts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$TelegramMessagesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $TelegramMessagesTable,
          TelegramMessageRow,
          $$TelegramMessagesTableFilterComposer,
          $$TelegramMessagesTableOrderingComposer,
          $$TelegramMessagesTableAnnotationComposer,
          $$TelegramMessagesTableCreateCompanionBuilder,
          $$TelegramMessagesTableUpdateCompanionBuilder,
          (TelegramMessageRow, $$TelegramMessagesTableReferences),
          TelegramMessageRow,
          PrefetchHooks Function({bool accountId})
        > {
  $$TelegramMessagesTableTableManager(
    _$AppDatabase db,
    $TelegramMessagesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$TelegramMessagesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$TelegramMessagesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$TelegramMessagesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> accountId = const Value.absent(),
                Value<String> telegramChatId = const Value.absent(),
                Value<String> telegramMessageId = const Value.absent(),
                Value<String?> senderName = const Value.absent(),
                Value<String> body = const Value.absent(),
                Value<String> contentType = const Value.absent(),
                Value<String?> mediaPath = const Value.absent(),
                Value<int?> mediaFileId = const Value.absent(),
                Value<String?> replyToMessageId = const Value.absent(),
                Value<String?> replyPreview = const Value.absent(),
                Value<DateTime> sentAt = const Value.absent(),
                Value<bool> isOutgoing = const Value.absent(),
                Value<bool> isEdited = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => TelegramMessagesCompanion(
                id: id,
                accountId: accountId,
                telegramChatId: telegramChatId,
                telegramMessageId: telegramMessageId,
                senderName: senderName,
                body: body,
                contentType: contentType,
                mediaPath: mediaPath,
                mediaFileId: mediaFileId,
                replyToMessageId: replyToMessageId,
                replyPreview: replyPreview,
                sentAt: sentAt,
                isOutgoing: isOutgoing,
                isEdited: isEdited,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String accountId,
                required String telegramChatId,
                required String telegramMessageId,
                Value<String?> senderName = const Value.absent(),
                required String body,
                Value<String> contentType = const Value.absent(),
                Value<String?> mediaPath = const Value.absent(),
                Value<int?> mediaFileId = const Value.absent(),
                Value<String?> replyToMessageId = const Value.absent(),
                Value<String?> replyPreview = const Value.absent(),
                required DateTime sentAt,
                Value<bool> isOutgoing = const Value.absent(),
                Value<bool> isEdited = const Value.absent(),
                required DateTime updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => TelegramMessagesCompanion.insert(
                id: id,
                accountId: accountId,
                telegramChatId: telegramChatId,
                telegramMessageId: telegramMessageId,
                senderName: senderName,
                body: body,
                contentType: contentType,
                mediaPath: mediaPath,
                mediaFileId: mediaFileId,
                replyToMessageId: replyToMessageId,
                replyPreview: replyPreview,
                sentAt: sentAt,
                isOutgoing: isOutgoing,
                isEdited: isEdited,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$TelegramMessagesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({accountId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (accountId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.accountId,
                                referencedTable:
                                    $$TelegramMessagesTableReferences
                                        ._accountIdTable(db),
                                referencedColumn:
                                    $$TelegramMessagesTableReferences
                                        ._accountIdTable(db)
                                        .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$TelegramMessagesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $TelegramMessagesTable,
      TelegramMessageRow,
      $$TelegramMessagesTableFilterComposer,
      $$TelegramMessagesTableOrderingComposer,
      $$TelegramMessagesTableAnnotationComposer,
      $$TelegramMessagesTableCreateCompanionBuilder,
      $$TelegramMessagesTableUpdateCompanionBuilder,
      (TelegramMessageRow, $$TelegramMessagesTableReferences),
      TelegramMessageRow,
      PrefetchHooks Function({bool accountId})
    >;
typedef $$GmailAccountsTableCreateCompanionBuilder =
    GmailAccountsCompanion Function({
      required String id,
      required String email,
      required DateTime connectedAt,
      Value<DateTime?> lastSyncAt,
      Value<int> rowid,
    });
typedef $$GmailAccountsTableUpdateCompanionBuilder =
    GmailAccountsCompanion Function({
      Value<String> id,
      Value<String> email,
      Value<DateTime> connectedAt,
      Value<DateTime?> lastSyncAt,
      Value<int> rowid,
    });

final class $$GmailAccountsTableReferences
    extends
        BaseReferences<_$AppDatabase, $GmailAccountsTable, GmailAccountRow> {
  $$GmailAccountsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static MultiTypedResultKey<$GmailThreadsTable, List<GmailThreadRow>>
  _gmailThreadsRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.gmailThreads,
    aliasName: $_aliasNameGenerator(
      db.gmailAccounts.id,
      db.gmailThreads.accountId,
    ),
  );

  $$GmailThreadsTableProcessedTableManager get gmailThreadsRefs {
    final manager = $$GmailThreadsTableTableManager(
      $_db,
      $_db.gmailThreads,
    ).filter((f) => f.accountId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_gmailThreadsRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$GmailMessagesTable, List<GmailMessageRow>>
  _gmailMessagesRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.gmailMessages,
    aliasName: $_aliasNameGenerator(
      db.gmailAccounts.id,
      db.gmailMessages.accountId,
    ),
  );

  $$GmailMessagesTableProcessedTableManager get gmailMessagesRefs {
    final manager = $$GmailMessagesTableTableManager(
      $_db,
      $_db.gmailMessages,
    ).filter((f) => f.accountId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_gmailMessagesRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$GmailAccountsTableFilterComposer
    extends Composer<_$AppDatabase, $GmailAccountsTable> {
  $$GmailAccountsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get email => $composableBuilder(
    column: $table.email,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get connectedAt => $composableBuilder(
    column: $table.connectedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get lastSyncAt => $composableBuilder(
    column: $table.lastSyncAt,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> gmailThreadsRefs(
    Expression<bool> Function($$GmailThreadsTableFilterComposer f) f,
  ) {
    final $$GmailThreadsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.gmailThreads,
      getReferencedColumn: (t) => t.accountId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$GmailThreadsTableFilterComposer(
            $db: $db,
            $table: $db.gmailThreads,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> gmailMessagesRefs(
    Expression<bool> Function($$GmailMessagesTableFilterComposer f) f,
  ) {
    final $$GmailMessagesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.gmailMessages,
      getReferencedColumn: (t) => t.accountId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$GmailMessagesTableFilterComposer(
            $db: $db,
            $table: $db.gmailMessages,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$GmailAccountsTableOrderingComposer
    extends Composer<_$AppDatabase, $GmailAccountsTable> {
  $$GmailAccountsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get email => $composableBuilder(
    column: $table.email,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get connectedAt => $composableBuilder(
    column: $table.connectedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get lastSyncAt => $composableBuilder(
    column: $table.lastSyncAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$GmailAccountsTableAnnotationComposer
    extends Composer<_$AppDatabase, $GmailAccountsTable> {
  $$GmailAccountsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get email =>
      $composableBuilder(column: $table.email, builder: (column) => column);

  GeneratedColumn<DateTime> get connectedAt => $composableBuilder(
    column: $table.connectedAt,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get lastSyncAt => $composableBuilder(
    column: $table.lastSyncAt,
    builder: (column) => column,
  );

  Expression<T> gmailThreadsRefs<T extends Object>(
    Expression<T> Function($$GmailThreadsTableAnnotationComposer a) f,
  ) {
    final $$GmailThreadsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.gmailThreads,
      getReferencedColumn: (t) => t.accountId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$GmailThreadsTableAnnotationComposer(
            $db: $db,
            $table: $db.gmailThreads,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> gmailMessagesRefs<T extends Object>(
    Expression<T> Function($$GmailMessagesTableAnnotationComposer a) f,
  ) {
    final $$GmailMessagesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.gmailMessages,
      getReferencedColumn: (t) => t.accountId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$GmailMessagesTableAnnotationComposer(
            $db: $db,
            $table: $db.gmailMessages,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$GmailAccountsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $GmailAccountsTable,
          GmailAccountRow,
          $$GmailAccountsTableFilterComposer,
          $$GmailAccountsTableOrderingComposer,
          $$GmailAccountsTableAnnotationComposer,
          $$GmailAccountsTableCreateCompanionBuilder,
          $$GmailAccountsTableUpdateCompanionBuilder,
          (GmailAccountRow, $$GmailAccountsTableReferences),
          GmailAccountRow,
          PrefetchHooks Function({
            bool gmailThreadsRefs,
            bool gmailMessagesRefs,
          })
        > {
  $$GmailAccountsTableTableManager(_$AppDatabase db, $GmailAccountsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$GmailAccountsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$GmailAccountsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$GmailAccountsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> email = const Value.absent(),
                Value<DateTime> connectedAt = const Value.absent(),
                Value<DateTime?> lastSyncAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => GmailAccountsCompanion(
                id: id,
                email: email,
                connectedAt: connectedAt,
                lastSyncAt: lastSyncAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String email,
                required DateTime connectedAt,
                Value<DateTime?> lastSyncAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => GmailAccountsCompanion.insert(
                id: id,
                email: email,
                connectedAt: connectedAt,
                lastSyncAt: lastSyncAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$GmailAccountsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({gmailThreadsRefs = false, gmailMessagesRefs = false}) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (gmailThreadsRefs) db.gmailThreads,
                    if (gmailMessagesRefs) db.gmailMessages,
                  ],
                  addJoins: null,
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (gmailThreadsRefs)
                        await $_getPrefetchedData<
                          GmailAccountRow,
                          $GmailAccountsTable,
                          GmailThreadRow
                        >(
                          currentTable: table,
                          referencedTable: $$GmailAccountsTableReferences
                              ._gmailThreadsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$GmailAccountsTableReferences(
                                db,
                                table,
                                p0,
                              ).gmailThreadsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.accountId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (gmailMessagesRefs)
                        await $_getPrefetchedData<
                          GmailAccountRow,
                          $GmailAccountsTable,
                          GmailMessageRow
                        >(
                          currentTable: table,
                          referencedTable: $$GmailAccountsTableReferences
                              ._gmailMessagesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$GmailAccountsTableReferences(
                                db,
                                table,
                                p0,
                              ).gmailMessagesRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.accountId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$GmailAccountsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $GmailAccountsTable,
      GmailAccountRow,
      $$GmailAccountsTableFilterComposer,
      $$GmailAccountsTableOrderingComposer,
      $$GmailAccountsTableAnnotationComposer,
      $$GmailAccountsTableCreateCompanionBuilder,
      $$GmailAccountsTableUpdateCompanionBuilder,
      (GmailAccountRow, $$GmailAccountsTableReferences),
      GmailAccountRow,
      PrefetchHooks Function({bool gmailThreadsRefs, bool gmailMessagesRefs})
    >;
typedef $$GmailThreadsTableCreateCompanionBuilder =
    GmailThreadsCompanion Function({
      required String id,
      required String accountId,
      required String gmailThreadId,
      required String subject,
      required String snippet,
      Value<String?> fromName,
      Value<String?> fromEmail,
      required DateTime date,
      Value<bool> isUnread,
      required DateTime updatedAt,
      Value<int> rowid,
    });
typedef $$GmailThreadsTableUpdateCompanionBuilder =
    GmailThreadsCompanion Function({
      Value<String> id,
      Value<String> accountId,
      Value<String> gmailThreadId,
      Value<String> subject,
      Value<String> snippet,
      Value<String?> fromName,
      Value<String?> fromEmail,
      Value<DateTime> date,
      Value<bool> isUnread,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });

final class $$GmailThreadsTableReferences
    extends BaseReferences<_$AppDatabase, $GmailThreadsTable, GmailThreadRow> {
  $$GmailThreadsTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $GmailAccountsTable _accountIdTable(_$AppDatabase db) =>
      db.gmailAccounts.createAlias(
        $_aliasNameGenerator(db.gmailThreads.accountId, db.gmailAccounts.id),
      );

  $$GmailAccountsTableProcessedTableManager get accountId {
    final $_column = $_itemColumn<String>('account_id')!;

    final manager = $$GmailAccountsTableTableManager(
      $_db,
      $_db.gmailAccounts,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_accountIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$GmailThreadsTableFilterComposer
    extends Composer<_$AppDatabase, $GmailThreadsTable> {
  $$GmailThreadsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get gmailThreadId => $composableBuilder(
    column: $table.gmailThreadId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get subject => $composableBuilder(
    column: $table.subject,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get snippet => $composableBuilder(
    column: $table.snippet,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get fromName => $composableBuilder(
    column: $table.fromName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get fromEmail => $composableBuilder(
    column: $table.fromEmail,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isUnread => $composableBuilder(
    column: $table.isUnread,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  $$GmailAccountsTableFilterComposer get accountId {
    final $$GmailAccountsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.accountId,
      referencedTable: $db.gmailAccounts,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$GmailAccountsTableFilterComposer(
            $db: $db,
            $table: $db.gmailAccounts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$GmailThreadsTableOrderingComposer
    extends Composer<_$AppDatabase, $GmailThreadsTable> {
  $$GmailThreadsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get gmailThreadId => $composableBuilder(
    column: $table.gmailThreadId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get subject => $composableBuilder(
    column: $table.subject,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get snippet => $composableBuilder(
    column: $table.snippet,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get fromName => $composableBuilder(
    column: $table.fromName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get fromEmail => $composableBuilder(
    column: $table.fromEmail,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isUnread => $composableBuilder(
    column: $table.isUnread,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$GmailAccountsTableOrderingComposer get accountId {
    final $$GmailAccountsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.accountId,
      referencedTable: $db.gmailAccounts,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$GmailAccountsTableOrderingComposer(
            $db: $db,
            $table: $db.gmailAccounts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$GmailThreadsTableAnnotationComposer
    extends Composer<_$AppDatabase, $GmailThreadsTable> {
  $$GmailThreadsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get gmailThreadId => $composableBuilder(
    column: $table.gmailThreadId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get subject =>
      $composableBuilder(column: $table.subject, builder: (column) => column);

  GeneratedColumn<String> get snippet =>
      $composableBuilder(column: $table.snippet, builder: (column) => column);

  GeneratedColumn<String> get fromName =>
      $composableBuilder(column: $table.fromName, builder: (column) => column);

  GeneratedColumn<String> get fromEmail =>
      $composableBuilder(column: $table.fromEmail, builder: (column) => column);

  GeneratedColumn<DateTime> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);

  GeneratedColumn<bool> get isUnread =>
      $composableBuilder(column: $table.isUnread, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  $$GmailAccountsTableAnnotationComposer get accountId {
    final $$GmailAccountsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.accountId,
      referencedTable: $db.gmailAccounts,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$GmailAccountsTableAnnotationComposer(
            $db: $db,
            $table: $db.gmailAccounts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$GmailThreadsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $GmailThreadsTable,
          GmailThreadRow,
          $$GmailThreadsTableFilterComposer,
          $$GmailThreadsTableOrderingComposer,
          $$GmailThreadsTableAnnotationComposer,
          $$GmailThreadsTableCreateCompanionBuilder,
          $$GmailThreadsTableUpdateCompanionBuilder,
          (GmailThreadRow, $$GmailThreadsTableReferences),
          GmailThreadRow,
          PrefetchHooks Function({bool accountId})
        > {
  $$GmailThreadsTableTableManager(_$AppDatabase db, $GmailThreadsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$GmailThreadsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$GmailThreadsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$GmailThreadsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> accountId = const Value.absent(),
                Value<String> gmailThreadId = const Value.absent(),
                Value<String> subject = const Value.absent(),
                Value<String> snippet = const Value.absent(),
                Value<String?> fromName = const Value.absent(),
                Value<String?> fromEmail = const Value.absent(),
                Value<DateTime> date = const Value.absent(),
                Value<bool> isUnread = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => GmailThreadsCompanion(
                id: id,
                accountId: accountId,
                gmailThreadId: gmailThreadId,
                subject: subject,
                snippet: snippet,
                fromName: fromName,
                fromEmail: fromEmail,
                date: date,
                isUnread: isUnread,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String accountId,
                required String gmailThreadId,
                required String subject,
                required String snippet,
                Value<String?> fromName = const Value.absent(),
                Value<String?> fromEmail = const Value.absent(),
                required DateTime date,
                Value<bool> isUnread = const Value.absent(),
                required DateTime updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => GmailThreadsCompanion.insert(
                id: id,
                accountId: accountId,
                gmailThreadId: gmailThreadId,
                subject: subject,
                snippet: snippet,
                fromName: fromName,
                fromEmail: fromEmail,
                date: date,
                isUnread: isUnread,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$GmailThreadsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({accountId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (accountId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.accountId,
                                referencedTable: $$GmailThreadsTableReferences
                                    ._accountIdTable(db),
                                referencedColumn: $$GmailThreadsTableReferences
                                    ._accountIdTable(db)
                                    .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$GmailThreadsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $GmailThreadsTable,
      GmailThreadRow,
      $$GmailThreadsTableFilterComposer,
      $$GmailThreadsTableOrderingComposer,
      $$GmailThreadsTableAnnotationComposer,
      $$GmailThreadsTableCreateCompanionBuilder,
      $$GmailThreadsTableUpdateCompanionBuilder,
      (GmailThreadRow, $$GmailThreadsTableReferences),
      GmailThreadRow,
      PrefetchHooks Function({bool accountId})
    >;
typedef $$GmailMessagesTableCreateCompanionBuilder =
    GmailMessagesCompanion Function({
      required String id,
      required String accountId,
      required String gmailThreadId,
      required String gmailMessageId,
      Value<String?> fromName,
      Value<String?> fromEmail,
      Value<String> toEmails,
      required String subject,
      required String bodyText,
      Value<String?> bodyHtml,
      required DateTime date,
      Value<bool> isUnread,
      required DateTime updatedAt,
      Value<int> rowid,
    });
typedef $$GmailMessagesTableUpdateCompanionBuilder =
    GmailMessagesCompanion Function({
      Value<String> id,
      Value<String> accountId,
      Value<String> gmailThreadId,
      Value<String> gmailMessageId,
      Value<String?> fromName,
      Value<String?> fromEmail,
      Value<String> toEmails,
      Value<String> subject,
      Value<String> bodyText,
      Value<String?> bodyHtml,
      Value<DateTime> date,
      Value<bool> isUnread,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });

final class $$GmailMessagesTableReferences
    extends
        BaseReferences<_$AppDatabase, $GmailMessagesTable, GmailMessageRow> {
  $$GmailMessagesTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $GmailAccountsTable _accountIdTable(_$AppDatabase db) =>
      db.gmailAccounts.createAlias(
        $_aliasNameGenerator(db.gmailMessages.accountId, db.gmailAccounts.id),
      );

  $$GmailAccountsTableProcessedTableManager get accountId {
    final $_column = $_itemColumn<String>('account_id')!;

    final manager = $$GmailAccountsTableTableManager(
      $_db,
      $_db.gmailAccounts,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_accountIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$GmailMessagesTableFilterComposer
    extends Composer<_$AppDatabase, $GmailMessagesTable> {
  $$GmailMessagesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get gmailThreadId => $composableBuilder(
    column: $table.gmailThreadId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get gmailMessageId => $composableBuilder(
    column: $table.gmailMessageId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get fromName => $composableBuilder(
    column: $table.fromName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get fromEmail => $composableBuilder(
    column: $table.fromEmail,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get toEmails => $composableBuilder(
    column: $table.toEmails,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get subject => $composableBuilder(
    column: $table.subject,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get bodyText => $composableBuilder(
    column: $table.bodyText,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get bodyHtml => $composableBuilder(
    column: $table.bodyHtml,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isUnread => $composableBuilder(
    column: $table.isUnread,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  $$GmailAccountsTableFilterComposer get accountId {
    final $$GmailAccountsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.accountId,
      referencedTable: $db.gmailAccounts,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$GmailAccountsTableFilterComposer(
            $db: $db,
            $table: $db.gmailAccounts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$GmailMessagesTableOrderingComposer
    extends Composer<_$AppDatabase, $GmailMessagesTable> {
  $$GmailMessagesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get gmailThreadId => $composableBuilder(
    column: $table.gmailThreadId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get gmailMessageId => $composableBuilder(
    column: $table.gmailMessageId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get fromName => $composableBuilder(
    column: $table.fromName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get fromEmail => $composableBuilder(
    column: $table.fromEmail,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get toEmails => $composableBuilder(
    column: $table.toEmails,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get subject => $composableBuilder(
    column: $table.subject,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get bodyText => $composableBuilder(
    column: $table.bodyText,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get bodyHtml => $composableBuilder(
    column: $table.bodyHtml,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isUnread => $composableBuilder(
    column: $table.isUnread,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$GmailAccountsTableOrderingComposer get accountId {
    final $$GmailAccountsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.accountId,
      referencedTable: $db.gmailAccounts,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$GmailAccountsTableOrderingComposer(
            $db: $db,
            $table: $db.gmailAccounts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$GmailMessagesTableAnnotationComposer
    extends Composer<_$AppDatabase, $GmailMessagesTable> {
  $$GmailMessagesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get gmailThreadId => $composableBuilder(
    column: $table.gmailThreadId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get gmailMessageId => $composableBuilder(
    column: $table.gmailMessageId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get fromName =>
      $composableBuilder(column: $table.fromName, builder: (column) => column);

  GeneratedColumn<String> get fromEmail =>
      $composableBuilder(column: $table.fromEmail, builder: (column) => column);

  GeneratedColumn<String> get toEmails =>
      $composableBuilder(column: $table.toEmails, builder: (column) => column);

  GeneratedColumn<String> get subject =>
      $composableBuilder(column: $table.subject, builder: (column) => column);

  GeneratedColumn<String> get bodyText =>
      $composableBuilder(column: $table.bodyText, builder: (column) => column);

  GeneratedColumn<String> get bodyHtml =>
      $composableBuilder(column: $table.bodyHtml, builder: (column) => column);

  GeneratedColumn<DateTime> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);

  GeneratedColumn<bool> get isUnread =>
      $composableBuilder(column: $table.isUnread, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  $$GmailAccountsTableAnnotationComposer get accountId {
    final $$GmailAccountsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.accountId,
      referencedTable: $db.gmailAccounts,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$GmailAccountsTableAnnotationComposer(
            $db: $db,
            $table: $db.gmailAccounts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$GmailMessagesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $GmailMessagesTable,
          GmailMessageRow,
          $$GmailMessagesTableFilterComposer,
          $$GmailMessagesTableOrderingComposer,
          $$GmailMessagesTableAnnotationComposer,
          $$GmailMessagesTableCreateCompanionBuilder,
          $$GmailMessagesTableUpdateCompanionBuilder,
          (GmailMessageRow, $$GmailMessagesTableReferences),
          GmailMessageRow,
          PrefetchHooks Function({bool accountId})
        > {
  $$GmailMessagesTableTableManager(_$AppDatabase db, $GmailMessagesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$GmailMessagesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$GmailMessagesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$GmailMessagesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> accountId = const Value.absent(),
                Value<String> gmailThreadId = const Value.absent(),
                Value<String> gmailMessageId = const Value.absent(),
                Value<String?> fromName = const Value.absent(),
                Value<String?> fromEmail = const Value.absent(),
                Value<String> toEmails = const Value.absent(),
                Value<String> subject = const Value.absent(),
                Value<String> bodyText = const Value.absent(),
                Value<String?> bodyHtml = const Value.absent(),
                Value<DateTime> date = const Value.absent(),
                Value<bool> isUnread = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => GmailMessagesCompanion(
                id: id,
                accountId: accountId,
                gmailThreadId: gmailThreadId,
                gmailMessageId: gmailMessageId,
                fromName: fromName,
                fromEmail: fromEmail,
                toEmails: toEmails,
                subject: subject,
                bodyText: bodyText,
                bodyHtml: bodyHtml,
                date: date,
                isUnread: isUnread,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String accountId,
                required String gmailThreadId,
                required String gmailMessageId,
                Value<String?> fromName = const Value.absent(),
                Value<String?> fromEmail = const Value.absent(),
                Value<String> toEmails = const Value.absent(),
                required String subject,
                required String bodyText,
                Value<String?> bodyHtml = const Value.absent(),
                required DateTime date,
                Value<bool> isUnread = const Value.absent(),
                required DateTime updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => GmailMessagesCompanion.insert(
                id: id,
                accountId: accountId,
                gmailThreadId: gmailThreadId,
                gmailMessageId: gmailMessageId,
                fromName: fromName,
                fromEmail: fromEmail,
                toEmails: toEmails,
                subject: subject,
                bodyText: bodyText,
                bodyHtml: bodyHtml,
                date: date,
                isUnread: isUnread,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$GmailMessagesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({accountId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (accountId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.accountId,
                                referencedTable: $$GmailMessagesTableReferences
                                    ._accountIdTable(db),
                                referencedColumn: $$GmailMessagesTableReferences
                                    ._accountIdTable(db)
                                    .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$GmailMessagesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $GmailMessagesTable,
      GmailMessageRow,
      $$GmailMessagesTableFilterComposer,
      $$GmailMessagesTableOrderingComposer,
      $$GmailMessagesTableAnnotationComposer,
      $$GmailMessagesTableCreateCompanionBuilder,
      $$GmailMessagesTableUpdateCompanionBuilder,
      (GmailMessageRow, $$GmailMessagesTableReferences),
      GmailMessageRow,
      PrefetchHooks Function({bool accountId})
    >;
typedef $$SlackAccountsTableCreateCompanionBuilder =
    SlackAccountsCompanion Function({
      required String id,
      required String teamId,
      required String teamName,
      required String userId,
      Value<String?> displayName,
      required DateTime connectedAt,
      Value<DateTime?> lastSyncAt,
      Value<int> rowid,
    });
typedef $$SlackAccountsTableUpdateCompanionBuilder =
    SlackAccountsCompanion Function({
      Value<String> id,
      Value<String> teamId,
      Value<String> teamName,
      Value<String> userId,
      Value<String?> displayName,
      Value<DateTime> connectedAt,
      Value<DateTime?> lastSyncAt,
      Value<int> rowid,
    });

final class $$SlackAccountsTableReferences
    extends
        BaseReferences<_$AppDatabase, $SlackAccountsTable, SlackAccountRow> {
  $$SlackAccountsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static MultiTypedResultKey<
    $SlackConversationsTable,
    List<SlackConversationRow>
  >
  _slackConversationsRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.slackConversations,
        aliasName: $_aliasNameGenerator(
          db.slackAccounts.id,
          db.slackConversations.accountId,
        ),
      );

  $$SlackConversationsTableProcessedTableManager get slackConversationsRefs {
    final manager = $$SlackConversationsTableTableManager(
      $_db,
      $_db.slackConversations,
    ).filter((f) => f.accountId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _slackConversationsRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$SlackMessagesTable, List<SlackMessageRow>>
  _slackMessagesRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.slackMessages,
    aliasName: $_aliasNameGenerator(
      db.slackAccounts.id,
      db.slackMessages.accountId,
    ),
  );

  $$SlackMessagesTableProcessedTableManager get slackMessagesRefs {
    final manager = $$SlackMessagesTableTableManager(
      $_db,
      $_db.slackMessages,
    ).filter((f) => f.accountId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_slackMessagesRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$SlackAccountsTableFilterComposer
    extends Composer<_$AppDatabase, $SlackAccountsTable> {
  $$SlackAccountsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get teamId => $composableBuilder(
    column: $table.teamId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get teamName => $composableBuilder(
    column: $table.teamName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get displayName => $composableBuilder(
    column: $table.displayName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get connectedAt => $composableBuilder(
    column: $table.connectedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get lastSyncAt => $composableBuilder(
    column: $table.lastSyncAt,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> slackConversationsRefs(
    Expression<bool> Function($$SlackConversationsTableFilterComposer f) f,
  ) {
    final $$SlackConversationsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.slackConversations,
      getReferencedColumn: (t) => t.accountId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SlackConversationsTableFilterComposer(
            $db: $db,
            $table: $db.slackConversations,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> slackMessagesRefs(
    Expression<bool> Function($$SlackMessagesTableFilterComposer f) f,
  ) {
    final $$SlackMessagesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.slackMessages,
      getReferencedColumn: (t) => t.accountId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SlackMessagesTableFilterComposer(
            $db: $db,
            $table: $db.slackMessages,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$SlackAccountsTableOrderingComposer
    extends Composer<_$AppDatabase, $SlackAccountsTable> {
  $$SlackAccountsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get teamId => $composableBuilder(
    column: $table.teamId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get teamName => $composableBuilder(
    column: $table.teamName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get userId => $composableBuilder(
    column: $table.userId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get displayName => $composableBuilder(
    column: $table.displayName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get connectedAt => $composableBuilder(
    column: $table.connectedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get lastSyncAt => $composableBuilder(
    column: $table.lastSyncAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$SlackAccountsTableAnnotationComposer
    extends Composer<_$AppDatabase, $SlackAccountsTable> {
  $$SlackAccountsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get teamId =>
      $composableBuilder(column: $table.teamId, builder: (column) => column);

  GeneratedColumn<String> get teamName =>
      $composableBuilder(column: $table.teamName, builder: (column) => column);

  GeneratedColumn<String> get userId =>
      $composableBuilder(column: $table.userId, builder: (column) => column);

  GeneratedColumn<String> get displayName => $composableBuilder(
    column: $table.displayName,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get connectedAt => $composableBuilder(
    column: $table.connectedAt,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get lastSyncAt => $composableBuilder(
    column: $table.lastSyncAt,
    builder: (column) => column,
  );

  Expression<T> slackConversationsRefs<T extends Object>(
    Expression<T> Function($$SlackConversationsTableAnnotationComposer a) f,
  ) {
    final $$SlackConversationsTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.slackConversations,
          getReferencedColumn: (t) => t.accountId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$SlackConversationsTableAnnotationComposer(
                $db: $db,
                $table: $db.slackConversations,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }

  Expression<T> slackMessagesRefs<T extends Object>(
    Expression<T> Function($$SlackMessagesTableAnnotationComposer a) f,
  ) {
    final $$SlackMessagesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.slackMessages,
      getReferencedColumn: (t) => t.accountId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SlackMessagesTableAnnotationComposer(
            $db: $db,
            $table: $db.slackMessages,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$SlackAccountsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SlackAccountsTable,
          SlackAccountRow,
          $$SlackAccountsTableFilterComposer,
          $$SlackAccountsTableOrderingComposer,
          $$SlackAccountsTableAnnotationComposer,
          $$SlackAccountsTableCreateCompanionBuilder,
          $$SlackAccountsTableUpdateCompanionBuilder,
          (SlackAccountRow, $$SlackAccountsTableReferences),
          SlackAccountRow,
          PrefetchHooks Function({
            bool slackConversationsRefs,
            bool slackMessagesRefs,
          })
        > {
  $$SlackAccountsTableTableManager(_$AppDatabase db, $SlackAccountsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SlackAccountsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SlackAccountsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SlackAccountsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> teamId = const Value.absent(),
                Value<String> teamName = const Value.absent(),
                Value<String> userId = const Value.absent(),
                Value<String?> displayName = const Value.absent(),
                Value<DateTime> connectedAt = const Value.absent(),
                Value<DateTime?> lastSyncAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SlackAccountsCompanion(
                id: id,
                teamId: teamId,
                teamName: teamName,
                userId: userId,
                displayName: displayName,
                connectedAt: connectedAt,
                lastSyncAt: lastSyncAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String teamId,
                required String teamName,
                required String userId,
                Value<String?> displayName = const Value.absent(),
                required DateTime connectedAt,
                Value<DateTime?> lastSyncAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SlackAccountsCompanion.insert(
                id: id,
                teamId: teamId,
                teamName: teamName,
                userId: userId,
                displayName: displayName,
                connectedAt: connectedAt,
                lastSyncAt: lastSyncAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$SlackAccountsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({slackConversationsRefs = false, slackMessagesRefs = false}) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (slackConversationsRefs) db.slackConversations,
                    if (slackMessagesRefs) db.slackMessages,
                  ],
                  addJoins: null,
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (slackConversationsRefs)
                        await $_getPrefetchedData<
                          SlackAccountRow,
                          $SlackAccountsTable,
                          SlackConversationRow
                        >(
                          currentTable: table,
                          referencedTable: $$SlackAccountsTableReferences
                              ._slackConversationsRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$SlackAccountsTableReferences(
                                db,
                                table,
                                p0,
                              ).slackConversationsRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.accountId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (slackMessagesRefs)
                        await $_getPrefetchedData<
                          SlackAccountRow,
                          $SlackAccountsTable,
                          SlackMessageRow
                        >(
                          currentTable: table,
                          referencedTable: $$SlackAccountsTableReferences
                              ._slackMessagesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$SlackAccountsTableReferences(
                                db,
                                table,
                                p0,
                              ).slackMessagesRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.accountId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$SlackAccountsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SlackAccountsTable,
      SlackAccountRow,
      $$SlackAccountsTableFilterComposer,
      $$SlackAccountsTableOrderingComposer,
      $$SlackAccountsTableAnnotationComposer,
      $$SlackAccountsTableCreateCompanionBuilder,
      $$SlackAccountsTableUpdateCompanionBuilder,
      (SlackAccountRow, $$SlackAccountsTableReferences),
      SlackAccountRow,
      PrefetchHooks Function({
        bool slackConversationsRefs,
        bool slackMessagesRefs,
      })
    >;
typedef $$SlackConversationsTableCreateCompanionBuilder =
    SlackConversationsCompanion Function({
      required String id,
      required String accountId,
      required String conversationId,
      required String name,
      required String conversationType,
      Value<bool> isMuted,
      Value<bool> isAllowed,
      Value<int> unreadCount,
      Value<DateTime?> lastMessageAt,
      required DateTime updatedAt,
      Value<int> rowid,
    });
typedef $$SlackConversationsTableUpdateCompanionBuilder =
    SlackConversationsCompanion Function({
      Value<String> id,
      Value<String> accountId,
      Value<String> conversationId,
      Value<String> name,
      Value<String> conversationType,
      Value<bool> isMuted,
      Value<bool> isAllowed,
      Value<int> unreadCount,
      Value<DateTime?> lastMessageAt,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });

final class $$SlackConversationsTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $SlackConversationsTable,
          SlackConversationRow
        > {
  $$SlackConversationsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $SlackAccountsTable _accountIdTable(_$AppDatabase db) =>
      db.slackAccounts.createAlias(
        $_aliasNameGenerator(
          db.slackConversations.accountId,
          db.slackAccounts.id,
        ),
      );

  $$SlackAccountsTableProcessedTableManager get accountId {
    final $_column = $_itemColumn<String>('account_id')!;

    final manager = $$SlackAccountsTableTableManager(
      $_db,
      $_db.slackAccounts,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_accountIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$SlackConversationsTableFilterComposer
    extends Composer<_$AppDatabase, $SlackConversationsTable> {
  $$SlackConversationsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get conversationId => $composableBuilder(
    column: $table.conversationId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get conversationType => $composableBuilder(
    column: $table.conversationType,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isMuted => $composableBuilder(
    column: $table.isMuted,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isAllowed => $composableBuilder(
    column: $table.isAllowed,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get unreadCount => $composableBuilder(
    column: $table.unreadCount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get lastMessageAt => $composableBuilder(
    column: $table.lastMessageAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  $$SlackAccountsTableFilterComposer get accountId {
    final $$SlackAccountsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.accountId,
      referencedTable: $db.slackAccounts,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SlackAccountsTableFilterComposer(
            $db: $db,
            $table: $db.slackAccounts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$SlackConversationsTableOrderingComposer
    extends Composer<_$AppDatabase, $SlackConversationsTable> {
  $$SlackConversationsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get conversationId => $composableBuilder(
    column: $table.conversationId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get conversationType => $composableBuilder(
    column: $table.conversationType,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isMuted => $composableBuilder(
    column: $table.isMuted,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isAllowed => $composableBuilder(
    column: $table.isAllowed,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get unreadCount => $composableBuilder(
    column: $table.unreadCount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get lastMessageAt => $composableBuilder(
    column: $table.lastMessageAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$SlackAccountsTableOrderingComposer get accountId {
    final $$SlackAccountsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.accountId,
      referencedTable: $db.slackAccounts,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SlackAccountsTableOrderingComposer(
            $db: $db,
            $table: $db.slackAccounts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$SlackConversationsTableAnnotationComposer
    extends Composer<_$AppDatabase, $SlackConversationsTable> {
  $$SlackConversationsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get conversationId => $composableBuilder(
    column: $table.conversationId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get conversationType => $composableBuilder(
    column: $table.conversationType,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get isMuted =>
      $composableBuilder(column: $table.isMuted, builder: (column) => column);

  GeneratedColumn<bool> get isAllowed =>
      $composableBuilder(column: $table.isAllowed, builder: (column) => column);

  GeneratedColumn<int> get unreadCount => $composableBuilder(
    column: $table.unreadCount,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get lastMessageAt => $composableBuilder(
    column: $table.lastMessageAt,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  $$SlackAccountsTableAnnotationComposer get accountId {
    final $$SlackAccountsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.accountId,
      referencedTable: $db.slackAccounts,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SlackAccountsTableAnnotationComposer(
            $db: $db,
            $table: $db.slackAccounts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$SlackConversationsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SlackConversationsTable,
          SlackConversationRow,
          $$SlackConversationsTableFilterComposer,
          $$SlackConversationsTableOrderingComposer,
          $$SlackConversationsTableAnnotationComposer,
          $$SlackConversationsTableCreateCompanionBuilder,
          $$SlackConversationsTableUpdateCompanionBuilder,
          (SlackConversationRow, $$SlackConversationsTableReferences),
          SlackConversationRow,
          PrefetchHooks Function({bool accountId})
        > {
  $$SlackConversationsTableTableManager(
    _$AppDatabase db,
    $SlackConversationsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SlackConversationsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SlackConversationsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SlackConversationsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> accountId = const Value.absent(),
                Value<String> conversationId = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String> conversationType = const Value.absent(),
                Value<bool> isMuted = const Value.absent(),
                Value<bool> isAllowed = const Value.absent(),
                Value<int> unreadCount = const Value.absent(),
                Value<DateTime?> lastMessageAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SlackConversationsCompanion(
                id: id,
                accountId: accountId,
                conversationId: conversationId,
                name: name,
                conversationType: conversationType,
                isMuted: isMuted,
                isAllowed: isAllowed,
                unreadCount: unreadCount,
                lastMessageAt: lastMessageAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String accountId,
                required String conversationId,
                required String name,
                required String conversationType,
                Value<bool> isMuted = const Value.absent(),
                Value<bool> isAllowed = const Value.absent(),
                Value<int> unreadCount = const Value.absent(),
                Value<DateTime?> lastMessageAt = const Value.absent(),
                required DateTime updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => SlackConversationsCompanion.insert(
                id: id,
                accountId: accountId,
                conversationId: conversationId,
                name: name,
                conversationType: conversationType,
                isMuted: isMuted,
                isAllowed: isAllowed,
                unreadCount: unreadCount,
                lastMessageAt: lastMessageAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$SlackConversationsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({accountId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (accountId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.accountId,
                                referencedTable:
                                    $$SlackConversationsTableReferences
                                        ._accountIdTable(db),
                                referencedColumn:
                                    $$SlackConversationsTableReferences
                                        ._accountIdTable(db)
                                        .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$SlackConversationsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SlackConversationsTable,
      SlackConversationRow,
      $$SlackConversationsTableFilterComposer,
      $$SlackConversationsTableOrderingComposer,
      $$SlackConversationsTableAnnotationComposer,
      $$SlackConversationsTableCreateCompanionBuilder,
      $$SlackConversationsTableUpdateCompanionBuilder,
      (SlackConversationRow, $$SlackConversationsTableReferences),
      SlackConversationRow,
      PrefetchHooks Function({bool accountId})
    >;
typedef $$SlackMessagesTableCreateCompanionBuilder =
    SlackMessagesCompanion Function({
      required String id,
      required String accountId,
      required String conversationId,
      required String messageTs,
      Value<String?> threadTs,
      Value<String?> senderName,
      Value<String?> senderUserId,
      required String body,
      Value<bool> isOutgoing,
      Value<int> replyCount,
      Value<String> reactionsJson,
      Value<String> filesJson,
      Value<bool> isEdited,
      required DateTime sentAt,
      required DateTime updatedAt,
      Value<int> rowid,
    });
typedef $$SlackMessagesTableUpdateCompanionBuilder =
    SlackMessagesCompanion Function({
      Value<String> id,
      Value<String> accountId,
      Value<String> conversationId,
      Value<String> messageTs,
      Value<String?> threadTs,
      Value<String?> senderName,
      Value<String?> senderUserId,
      Value<String> body,
      Value<bool> isOutgoing,
      Value<int> replyCount,
      Value<String> reactionsJson,
      Value<String> filesJson,
      Value<bool> isEdited,
      Value<DateTime> sentAt,
      Value<DateTime> updatedAt,
      Value<int> rowid,
    });

final class $$SlackMessagesTableReferences
    extends
        BaseReferences<_$AppDatabase, $SlackMessagesTable, SlackMessageRow> {
  $$SlackMessagesTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $SlackAccountsTable _accountIdTable(_$AppDatabase db) =>
      db.slackAccounts.createAlias(
        $_aliasNameGenerator(db.slackMessages.accountId, db.slackAccounts.id),
      );

  $$SlackAccountsTableProcessedTableManager get accountId {
    final $_column = $_itemColumn<String>('account_id')!;

    final manager = $$SlackAccountsTableTableManager(
      $_db,
      $_db.slackAccounts,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_accountIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$SlackMessagesTableFilterComposer
    extends Composer<_$AppDatabase, $SlackMessagesTable> {
  $$SlackMessagesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get conversationId => $composableBuilder(
    column: $table.conversationId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get messageTs => $composableBuilder(
    column: $table.messageTs,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get threadTs => $composableBuilder(
    column: $table.threadTs,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get senderName => $composableBuilder(
    column: $table.senderName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get senderUserId => $composableBuilder(
    column: $table.senderUserId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get body => $composableBuilder(
    column: $table.body,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isOutgoing => $composableBuilder(
    column: $table.isOutgoing,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get replyCount => $composableBuilder(
    column: $table.replyCount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get reactionsJson => $composableBuilder(
    column: $table.reactionsJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get filesJson => $composableBuilder(
    column: $table.filesJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isEdited => $composableBuilder(
    column: $table.isEdited,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get sentAt => $composableBuilder(
    column: $table.sentAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  $$SlackAccountsTableFilterComposer get accountId {
    final $$SlackAccountsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.accountId,
      referencedTable: $db.slackAccounts,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SlackAccountsTableFilterComposer(
            $db: $db,
            $table: $db.slackAccounts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$SlackMessagesTableOrderingComposer
    extends Composer<_$AppDatabase, $SlackMessagesTable> {
  $$SlackMessagesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get conversationId => $composableBuilder(
    column: $table.conversationId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get messageTs => $composableBuilder(
    column: $table.messageTs,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get threadTs => $composableBuilder(
    column: $table.threadTs,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get senderName => $composableBuilder(
    column: $table.senderName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get senderUserId => $composableBuilder(
    column: $table.senderUserId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get body => $composableBuilder(
    column: $table.body,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isOutgoing => $composableBuilder(
    column: $table.isOutgoing,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get replyCount => $composableBuilder(
    column: $table.replyCount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get reactionsJson => $composableBuilder(
    column: $table.reactionsJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get filesJson => $composableBuilder(
    column: $table.filesJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isEdited => $composableBuilder(
    column: $table.isEdited,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get sentAt => $composableBuilder(
    column: $table.sentAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  $$SlackAccountsTableOrderingComposer get accountId {
    final $$SlackAccountsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.accountId,
      referencedTable: $db.slackAccounts,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SlackAccountsTableOrderingComposer(
            $db: $db,
            $table: $db.slackAccounts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$SlackMessagesTableAnnotationComposer
    extends Composer<_$AppDatabase, $SlackMessagesTable> {
  $$SlackMessagesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get conversationId => $composableBuilder(
    column: $table.conversationId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get messageTs =>
      $composableBuilder(column: $table.messageTs, builder: (column) => column);

  GeneratedColumn<String> get threadTs =>
      $composableBuilder(column: $table.threadTs, builder: (column) => column);

  GeneratedColumn<String> get senderName => $composableBuilder(
    column: $table.senderName,
    builder: (column) => column,
  );

  GeneratedColumn<String> get senderUserId => $composableBuilder(
    column: $table.senderUserId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get body =>
      $composableBuilder(column: $table.body, builder: (column) => column);

  GeneratedColumn<bool> get isOutgoing => $composableBuilder(
    column: $table.isOutgoing,
    builder: (column) => column,
  );

  GeneratedColumn<int> get replyCount => $composableBuilder(
    column: $table.replyCount,
    builder: (column) => column,
  );

  GeneratedColumn<String> get reactionsJson => $composableBuilder(
    column: $table.reactionsJson,
    builder: (column) => column,
  );

  GeneratedColumn<String> get filesJson =>
      $composableBuilder(column: $table.filesJson, builder: (column) => column);

  GeneratedColumn<bool> get isEdited =>
      $composableBuilder(column: $table.isEdited, builder: (column) => column);

  GeneratedColumn<DateTime> get sentAt =>
      $composableBuilder(column: $table.sentAt, builder: (column) => column);

  GeneratedColumn<DateTime> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  $$SlackAccountsTableAnnotationComposer get accountId {
    final $$SlackAccountsTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.accountId,
      referencedTable: $db.slackAccounts,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SlackAccountsTableAnnotationComposer(
            $db: $db,
            $table: $db.slackAccounts,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$SlackMessagesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SlackMessagesTable,
          SlackMessageRow,
          $$SlackMessagesTableFilterComposer,
          $$SlackMessagesTableOrderingComposer,
          $$SlackMessagesTableAnnotationComposer,
          $$SlackMessagesTableCreateCompanionBuilder,
          $$SlackMessagesTableUpdateCompanionBuilder,
          (SlackMessageRow, $$SlackMessagesTableReferences),
          SlackMessageRow,
          PrefetchHooks Function({bool accountId})
        > {
  $$SlackMessagesTableTableManager(_$AppDatabase db, $SlackMessagesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SlackMessagesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SlackMessagesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SlackMessagesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> accountId = const Value.absent(),
                Value<String> conversationId = const Value.absent(),
                Value<String> messageTs = const Value.absent(),
                Value<String?> threadTs = const Value.absent(),
                Value<String?> senderName = const Value.absent(),
                Value<String?> senderUserId = const Value.absent(),
                Value<String> body = const Value.absent(),
                Value<bool> isOutgoing = const Value.absent(),
                Value<int> replyCount = const Value.absent(),
                Value<String> reactionsJson = const Value.absent(),
                Value<String> filesJson = const Value.absent(),
                Value<bool> isEdited = const Value.absent(),
                Value<DateTime> sentAt = const Value.absent(),
                Value<DateTime> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SlackMessagesCompanion(
                id: id,
                accountId: accountId,
                conversationId: conversationId,
                messageTs: messageTs,
                threadTs: threadTs,
                senderName: senderName,
                senderUserId: senderUserId,
                body: body,
                isOutgoing: isOutgoing,
                replyCount: replyCount,
                reactionsJson: reactionsJson,
                filesJson: filesJson,
                isEdited: isEdited,
                sentAt: sentAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String accountId,
                required String conversationId,
                required String messageTs,
                Value<String?> threadTs = const Value.absent(),
                Value<String?> senderName = const Value.absent(),
                Value<String?> senderUserId = const Value.absent(),
                required String body,
                Value<bool> isOutgoing = const Value.absent(),
                Value<int> replyCount = const Value.absent(),
                Value<String> reactionsJson = const Value.absent(),
                Value<String> filesJson = const Value.absent(),
                Value<bool> isEdited = const Value.absent(),
                required DateTime sentAt,
                required DateTime updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => SlackMessagesCompanion.insert(
                id: id,
                accountId: accountId,
                conversationId: conversationId,
                messageTs: messageTs,
                threadTs: threadTs,
                senderName: senderName,
                senderUserId: senderUserId,
                body: body,
                isOutgoing: isOutgoing,
                replyCount: replyCount,
                reactionsJson: reactionsJson,
                filesJson: filesJson,
                isEdited: isEdited,
                sentAt: sentAt,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$SlackMessagesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({accountId = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [],
              addJoins:
                  <
                    T extends TableManagerState<
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic,
                      dynamic
                    >
                  >(state) {
                    if (accountId) {
                      state =
                          state.withJoin(
                                currentTable: table,
                                currentColumn: table.accountId,
                                referencedTable: $$SlackMessagesTableReferences
                                    ._accountIdTable(db),
                                referencedColumn: $$SlackMessagesTableReferences
                                    ._accountIdTable(db)
                                    .id,
                              )
                              as T;
                    }

                    return state;
                  },
              getPrefetchedDataCallback: (items) async {
                return [];
              },
            );
          },
        ),
      );
}

typedef $$SlackMessagesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SlackMessagesTable,
      SlackMessageRow,
      $$SlackMessagesTableFilterComposer,
      $$SlackMessagesTableOrderingComposer,
      $$SlackMessagesTableAnnotationComposer,
      $$SlackMessagesTableCreateCompanionBuilder,
      $$SlackMessagesTableUpdateCompanionBuilder,
      (SlackMessageRow, $$SlackMessagesTableReferences),
      SlackMessageRow,
      PrefetchHooks Function({bool accountId})
    >;
typedef $$BrowserBookmarksTableCreateCompanionBuilder =
    BrowserBookmarksCompanion Function({
      required String id,
      required String title,
      required String url,
      Value<String?> faviconUrl,
      Value<int> sortOrder,
      required DateTime createdAt,
      Value<int> rowid,
    });
typedef $$BrowserBookmarksTableUpdateCompanionBuilder =
    BrowserBookmarksCompanion Function({
      Value<String> id,
      Value<String> title,
      Value<String> url,
      Value<String?> faviconUrl,
      Value<int> sortOrder,
      Value<DateTime> createdAt,
      Value<int> rowid,
    });

class $$BrowserBookmarksTableFilterComposer
    extends Composer<_$AppDatabase, $BrowserBookmarksTable> {
  $$BrowserBookmarksTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get url => $composableBuilder(
    column: $table.url,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get faviconUrl => $composableBuilder(
    column: $table.faviconUrl,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$BrowserBookmarksTableOrderingComposer
    extends Composer<_$AppDatabase, $BrowserBookmarksTable> {
  $$BrowserBookmarksTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get title => $composableBuilder(
    column: $table.title,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get url => $composableBuilder(
    column: $table.url,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get faviconUrl => $composableBuilder(
    column: $table.faviconUrl,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get createdAt => $composableBuilder(
    column: $table.createdAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$BrowserBookmarksTableAnnotationComposer
    extends Composer<_$AppDatabase, $BrowserBookmarksTable> {
  $$BrowserBookmarksTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get title =>
      $composableBuilder(column: $table.title, builder: (column) => column);

  GeneratedColumn<String> get url =>
      $composableBuilder(column: $table.url, builder: (column) => column);

  GeneratedColumn<String> get faviconUrl => $composableBuilder(
    column: $table.faviconUrl,
    builder: (column) => column,
  );

  GeneratedColumn<int> get sortOrder =>
      $composableBuilder(column: $table.sortOrder, builder: (column) => column);

  GeneratedColumn<DateTime> get createdAt =>
      $composableBuilder(column: $table.createdAt, builder: (column) => column);
}

class $$BrowserBookmarksTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $BrowserBookmarksTable,
          BrowserBookmarkRow,
          $$BrowserBookmarksTableFilterComposer,
          $$BrowserBookmarksTableOrderingComposer,
          $$BrowserBookmarksTableAnnotationComposer,
          $$BrowserBookmarksTableCreateCompanionBuilder,
          $$BrowserBookmarksTableUpdateCompanionBuilder,
          (
            BrowserBookmarkRow,
            BaseReferences<
              _$AppDatabase,
              $BrowserBookmarksTable,
              BrowserBookmarkRow
            >,
          ),
          BrowserBookmarkRow,
          PrefetchHooks Function()
        > {
  $$BrowserBookmarksTableTableManager(
    _$AppDatabase db,
    $BrowserBookmarksTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$BrowserBookmarksTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$BrowserBookmarksTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$BrowserBookmarksTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> title = const Value.absent(),
                Value<String> url = const Value.absent(),
                Value<String?> faviconUrl = const Value.absent(),
                Value<int> sortOrder = const Value.absent(),
                Value<DateTime> createdAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => BrowserBookmarksCompanion(
                id: id,
                title: title,
                url: url,
                faviconUrl: faviconUrl,
                sortOrder: sortOrder,
                createdAt: createdAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String title,
                required String url,
                Value<String?> faviconUrl = const Value.absent(),
                Value<int> sortOrder = const Value.absent(),
                required DateTime createdAt,
                Value<int> rowid = const Value.absent(),
              }) => BrowserBookmarksCompanion.insert(
                id: id,
                title: title,
                url: url,
                faviconUrl: faviconUrl,
                sortOrder: sortOrder,
                createdAt: createdAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$BrowserBookmarksTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $BrowserBookmarksTable,
      BrowserBookmarkRow,
      $$BrowserBookmarksTableFilterComposer,
      $$BrowserBookmarksTableOrderingComposer,
      $$BrowserBookmarksTableAnnotationComposer,
      $$BrowserBookmarksTableCreateCompanionBuilder,
      $$BrowserBookmarksTableUpdateCompanionBuilder,
      (
        BrowserBookmarkRow,
        BaseReferences<
          _$AppDatabase,
          $BrowserBookmarksTable,
          BrowserBookmarkRow
        >,
      ),
      BrowserBookmarkRow,
      PrefetchHooks Function()
    >;
typedef $$SystemMetricSamplesTableCreateCompanionBuilder =
    SystemMetricSamplesCompanion Function({
      required String id,
      required DateTime capturedAt,
      required int ramUsedMb,
      required int ramTotalMb,
      required double cpuPercent,
      required int diskUsedMb,
      required int diskTotalMb,
      Value<double?> loadAvg1,
      Value<String?> hostname,
      Value<String?> platformLabel,
      Value<int> rowid,
    });
typedef $$SystemMetricSamplesTableUpdateCompanionBuilder =
    SystemMetricSamplesCompanion Function({
      Value<String> id,
      Value<DateTime> capturedAt,
      Value<int> ramUsedMb,
      Value<int> ramTotalMb,
      Value<double> cpuPercent,
      Value<int> diskUsedMb,
      Value<int> diskTotalMb,
      Value<double?> loadAvg1,
      Value<String?> hostname,
      Value<String?> platformLabel,
      Value<int> rowid,
    });

class $$SystemMetricSamplesTableFilterComposer
    extends Composer<_$AppDatabase, $SystemMetricSamplesTable> {
  $$SystemMetricSamplesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get capturedAt => $composableBuilder(
    column: $table.capturedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get ramUsedMb => $composableBuilder(
    column: $table.ramUsedMb,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get ramTotalMb => $composableBuilder(
    column: $table.ramTotalMb,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get cpuPercent => $composableBuilder(
    column: $table.cpuPercent,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get diskUsedMb => $composableBuilder(
    column: $table.diskUsedMb,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get diskTotalMb => $composableBuilder(
    column: $table.diskTotalMb,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get loadAvg1 => $composableBuilder(
    column: $table.loadAvg1,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get hostname => $composableBuilder(
    column: $table.hostname,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get platformLabel => $composableBuilder(
    column: $table.platformLabel,
    builder: (column) => ColumnFilters(column),
  );
}

class $$SystemMetricSamplesTableOrderingComposer
    extends Composer<_$AppDatabase, $SystemMetricSamplesTable> {
  $$SystemMetricSamplesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get capturedAt => $composableBuilder(
    column: $table.capturedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get ramUsedMb => $composableBuilder(
    column: $table.ramUsedMb,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get ramTotalMb => $composableBuilder(
    column: $table.ramTotalMb,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get cpuPercent => $composableBuilder(
    column: $table.cpuPercent,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get diskUsedMb => $composableBuilder(
    column: $table.diskUsedMb,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get diskTotalMb => $composableBuilder(
    column: $table.diskTotalMb,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get loadAvg1 => $composableBuilder(
    column: $table.loadAvg1,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get hostname => $composableBuilder(
    column: $table.hostname,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get platformLabel => $composableBuilder(
    column: $table.platformLabel,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$SystemMetricSamplesTableAnnotationComposer
    extends Composer<_$AppDatabase, $SystemMetricSamplesTable> {
  $$SystemMetricSamplesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<DateTime> get capturedAt => $composableBuilder(
    column: $table.capturedAt,
    builder: (column) => column,
  );

  GeneratedColumn<int> get ramUsedMb =>
      $composableBuilder(column: $table.ramUsedMb, builder: (column) => column);

  GeneratedColumn<int> get ramTotalMb => $composableBuilder(
    column: $table.ramTotalMb,
    builder: (column) => column,
  );

  GeneratedColumn<double> get cpuPercent => $composableBuilder(
    column: $table.cpuPercent,
    builder: (column) => column,
  );

  GeneratedColumn<int> get diskUsedMb => $composableBuilder(
    column: $table.diskUsedMb,
    builder: (column) => column,
  );

  GeneratedColumn<int> get diskTotalMb => $composableBuilder(
    column: $table.diskTotalMb,
    builder: (column) => column,
  );

  GeneratedColumn<double> get loadAvg1 =>
      $composableBuilder(column: $table.loadAvg1, builder: (column) => column);

  GeneratedColumn<String> get hostname =>
      $composableBuilder(column: $table.hostname, builder: (column) => column);

  GeneratedColumn<String> get platformLabel => $composableBuilder(
    column: $table.platformLabel,
    builder: (column) => column,
  );
}

class $$SystemMetricSamplesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SystemMetricSamplesTable,
          SystemMetricSampleRow,
          $$SystemMetricSamplesTableFilterComposer,
          $$SystemMetricSamplesTableOrderingComposer,
          $$SystemMetricSamplesTableAnnotationComposer,
          $$SystemMetricSamplesTableCreateCompanionBuilder,
          $$SystemMetricSamplesTableUpdateCompanionBuilder,
          (
            SystemMetricSampleRow,
            BaseReferences<
              _$AppDatabase,
              $SystemMetricSamplesTable,
              SystemMetricSampleRow
            >,
          ),
          SystemMetricSampleRow,
          PrefetchHooks Function()
        > {
  $$SystemMetricSamplesTableTableManager(
    _$AppDatabase db,
    $SystemMetricSamplesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SystemMetricSamplesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SystemMetricSamplesTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$SystemMetricSamplesTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<DateTime> capturedAt = const Value.absent(),
                Value<int> ramUsedMb = const Value.absent(),
                Value<int> ramTotalMb = const Value.absent(),
                Value<double> cpuPercent = const Value.absent(),
                Value<int> diskUsedMb = const Value.absent(),
                Value<int> diskTotalMb = const Value.absent(),
                Value<double?> loadAvg1 = const Value.absent(),
                Value<String?> hostname = const Value.absent(),
                Value<String?> platformLabel = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SystemMetricSamplesCompanion(
                id: id,
                capturedAt: capturedAt,
                ramUsedMb: ramUsedMb,
                ramTotalMb: ramTotalMb,
                cpuPercent: cpuPercent,
                diskUsedMb: diskUsedMb,
                diskTotalMb: diskTotalMb,
                loadAvg1: loadAvg1,
                hostname: hostname,
                platformLabel: platformLabel,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required DateTime capturedAt,
                required int ramUsedMb,
                required int ramTotalMb,
                required double cpuPercent,
                required int diskUsedMb,
                required int diskTotalMb,
                Value<double?> loadAvg1 = const Value.absent(),
                Value<String?> hostname = const Value.absent(),
                Value<String?> platformLabel = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SystemMetricSamplesCompanion.insert(
                id: id,
                capturedAt: capturedAt,
                ramUsedMb: ramUsedMb,
                ramTotalMb: ramTotalMb,
                cpuPercent: cpuPercent,
                diskUsedMb: diskUsedMb,
                diskTotalMb: diskTotalMb,
                loadAvg1: loadAvg1,
                hostname: hostname,
                platformLabel: platformLabel,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$SystemMetricSamplesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SystemMetricSamplesTable,
      SystemMetricSampleRow,
      $$SystemMetricSamplesTableFilterComposer,
      $$SystemMetricSamplesTableOrderingComposer,
      $$SystemMetricSamplesTableAnnotationComposer,
      $$SystemMetricSamplesTableCreateCompanionBuilder,
      $$SystemMetricSamplesTableUpdateCompanionBuilder,
      (
        SystemMetricSampleRow,
        BaseReferences<
          _$AppDatabase,
          $SystemMetricSamplesTable,
          SystemMetricSampleRow
        >,
      ),
      SystemMetricSampleRow,
      PrefetchHooks Function()
    >;
typedef $$FeatureUsageSessionsTableCreateCompanionBuilder =
    FeatureUsageSessionsCompanion Function({
      required String id,
      required String featureKey,
      required String featureLabel,
      required DateTime startedAt,
      required DateTime endedAt,
      required int durationMs,
      Value<double?> avgRamPercent,
      Value<double?> avgCpuPercent,
      Value<int> rowid,
    });
typedef $$FeatureUsageSessionsTableUpdateCompanionBuilder =
    FeatureUsageSessionsCompanion Function({
      Value<String> id,
      Value<String> featureKey,
      Value<String> featureLabel,
      Value<DateTime> startedAt,
      Value<DateTime> endedAt,
      Value<int> durationMs,
      Value<double?> avgRamPercent,
      Value<double?> avgCpuPercent,
      Value<int> rowid,
    });

class $$FeatureUsageSessionsTableFilterComposer
    extends Composer<_$AppDatabase, $FeatureUsageSessionsTable> {
  $$FeatureUsageSessionsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get featureKey => $composableBuilder(
    column: $table.featureKey,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get featureLabel => $composableBuilder(
    column: $table.featureLabel,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get startedAt => $composableBuilder(
    column: $table.startedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<DateTime> get endedAt => $composableBuilder(
    column: $table.endedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get durationMs => $composableBuilder(
    column: $table.durationMs,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get avgRamPercent => $composableBuilder(
    column: $table.avgRamPercent,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get avgCpuPercent => $composableBuilder(
    column: $table.avgCpuPercent,
    builder: (column) => ColumnFilters(column),
  );
}

class $$FeatureUsageSessionsTableOrderingComposer
    extends Composer<_$AppDatabase, $FeatureUsageSessionsTable> {
  $$FeatureUsageSessionsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get featureKey => $composableBuilder(
    column: $table.featureKey,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get featureLabel => $composableBuilder(
    column: $table.featureLabel,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get startedAt => $composableBuilder(
    column: $table.startedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<DateTime> get endedAt => $composableBuilder(
    column: $table.endedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get durationMs => $composableBuilder(
    column: $table.durationMs,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get avgRamPercent => $composableBuilder(
    column: $table.avgRamPercent,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get avgCpuPercent => $composableBuilder(
    column: $table.avgCpuPercent,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$FeatureUsageSessionsTableAnnotationComposer
    extends Composer<_$AppDatabase, $FeatureUsageSessionsTable> {
  $$FeatureUsageSessionsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get featureKey => $composableBuilder(
    column: $table.featureKey,
    builder: (column) => column,
  );

  GeneratedColumn<String> get featureLabel => $composableBuilder(
    column: $table.featureLabel,
    builder: (column) => column,
  );

  GeneratedColumn<DateTime> get startedAt =>
      $composableBuilder(column: $table.startedAt, builder: (column) => column);

  GeneratedColumn<DateTime> get endedAt =>
      $composableBuilder(column: $table.endedAt, builder: (column) => column);

  GeneratedColumn<int> get durationMs => $composableBuilder(
    column: $table.durationMs,
    builder: (column) => column,
  );

  GeneratedColumn<double> get avgRamPercent => $composableBuilder(
    column: $table.avgRamPercent,
    builder: (column) => column,
  );

  GeneratedColumn<double> get avgCpuPercent => $composableBuilder(
    column: $table.avgCpuPercent,
    builder: (column) => column,
  );
}

class $$FeatureUsageSessionsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $FeatureUsageSessionsTable,
          FeatureUsageSessionRow,
          $$FeatureUsageSessionsTableFilterComposer,
          $$FeatureUsageSessionsTableOrderingComposer,
          $$FeatureUsageSessionsTableAnnotationComposer,
          $$FeatureUsageSessionsTableCreateCompanionBuilder,
          $$FeatureUsageSessionsTableUpdateCompanionBuilder,
          (
            FeatureUsageSessionRow,
            BaseReferences<
              _$AppDatabase,
              $FeatureUsageSessionsTable,
              FeatureUsageSessionRow
            >,
          ),
          FeatureUsageSessionRow,
          PrefetchHooks Function()
        > {
  $$FeatureUsageSessionsTableTableManager(
    _$AppDatabase db,
    $FeatureUsageSessionsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$FeatureUsageSessionsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$FeatureUsageSessionsTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$FeatureUsageSessionsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> featureKey = const Value.absent(),
                Value<String> featureLabel = const Value.absent(),
                Value<DateTime> startedAt = const Value.absent(),
                Value<DateTime> endedAt = const Value.absent(),
                Value<int> durationMs = const Value.absent(),
                Value<double?> avgRamPercent = const Value.absent(),
                Value<double?> avgCpuPercent = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => FeatureUsageSessionsCompanion(
                id: id,
                featureKey: featureKey,
                featureLabel: featureLabel,
                startedAt: startedAt,
                endedAt: endedAt,
                durationMs: durationMs,
                avgRamPercent: avgRamPercent,
                avgCpuPercent: avgCpuPercent,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String featureKey,
                required String featureLabel,
                required DateTime startedAt,
                required DateTime endedAt,
                required int durationMs,
                Value<double?> avgRamPercent = const Value.absent(),
                Value<double?> avgCpuPercent = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => FeatureUsageSessionsCompanion.insert(
                id: id,
                featureKey: featureKey,
                featureLabel: featureLabel,
                startedAt: startedAt,
                endedAt: endedAt,
                durationMs: durationMs,
                avgRamPercent: avgRamPercent,
                avgCpuPercent: avgCpuPercent,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$FeatureUsageSessionsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $FeatureUsageSessionsTable,
      FeatureUsageSessionRow,
      $$FeatureUsageSessionsTableFilterComposer,
      $$FeatureUsageSessionsTableOrderingComposer,
      $$FeatureUsageSessionsTableAnnotationComposer,
      $$FeatureUsageSessionsTableCreateCompanionBuilder,
      $$FeatureUsageSessionsTableUpdateCompanionBuilder,
      (
        FeatureUsageSessionRow,
        BaseReferences<
          _$AppDatabase,
          $FeatureUsageSessionsTable,
          FeatureUsageSessionRow
        >,
      ),
      FeatureUsageSessionRow,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$ProjectsTableTableManager get projects =>
      $$ProjectsTableTableManager(_db, _db.projects);
  $$BoardColumnsTableTableManager get boardColumns =>
      $$BoardColumnsTableTableManager(_db, _db.boardColumns);
  $$TasksTableTableManager get tasks =>
      $$TasksTableTableManager(_db, _db.tasks);
  $$ProjectLabelsTableTableManager get projectLabels =>
      $$ProjectLabelsTableTableManager(_db, _db.projectLabels);
  $$TaskLabelLinksTableTableManager get taskLabelLinks =>
      $$TaskLabelLinksTableTableManager(_db, _db.taskLabelLinks);
  $$TaskChecklistsTableTableManager get taskChecklists =>
      $$TaskChecklistsTableTableManager(_db, _db.taskChecklists);
  $$TaskChecklistItemsTableTableManager get taskChecklistItems =>
      $$TaskChecklistItemsTableTableManager(_db, _db.taskChecklistItems);
  $$TaskCommentsTableTableManager get taskComments =>
      $$TaskCommentsTableTableManager(_db, _db.taskComments);
  $$TaskAttachmentsTableTableManager get taskAttachments =>
      $$TaskAttachmentsTableTableManager(_db, _db.taskAttachments);
  $$TaskActivityTableTableManager get taskActivity =>
      $$TaskActivityTableTableManager(_db, _db.taskActivity);
  $$TimeEntriesTableTableManager get timeEntries =>
      $$TimeEntriesTableTableManager(_db, _db.timeEntries);
  $$ScreenshotsTableTableManager get screenshots =>
      $$ScreenshotsTableTableManager(_db, _db.screenshots);
  $$AppSettingsTableTableManager get appSettings =>
      $$AppSettingsTableTableManager(_db, _db.appSettings);
  $$AlarmsTableTableManager get alarms =>
      $$AlarmsTableTableManager(_db, _db.alarms);
  $$StopwatchLapsTableTableManager get stopwatchLaps =>
      $$StopwatchLapsTableTableManager(_db, _db.stopwatchLaps);
  $$KeystrokeCountsTableTableManager get keystrokeCounts =>
      $$KeystrokeCountsTableTableManager(_db, _db.keystrokeCounts);
  $$NotebooksTableTableManager get notebooks =>
      $$NotebooksTableTableManager(_db, _db.notebooks);
  $$NotesTableTableManager get notes =>
      $$NotesTableTableManager(_db, _db.notes);
  $$CalendarAccountsTableTableManager get calendarAccounts =>
      $$CalendarAccountsTableTableManager(_db, _db.calendarAccounts);
  $$CachedCalendarEventsTableTableManager get cachedCalendarEvents =>
      $$CachedCalendarEventsTableTableManager(_db, _db.cachedCalendarEvents);
  $$TelegramAccountsTableTableManager get telegramAccounts =>
      $$TelegramAccountsTableTableManager(_db, _db.telegramAccounts);
  $$TelegramChatsTableTableManager get telegramChats =>
      $$TelegramChatsTableTableManager(_db, _db.telegramChats);
  $$TelegramMessagesTableTableManager get telegramMessages =>
      $$TelegramMessagesTableTableManager(_db, _db.telegramMessages);
  $$GmailAccountsTableTableManager get gmailAccounts =>
      $$GmailAccountsTableTableManager(_db, _db.gmailAccounts);
  $$GmailThreadsTableTableManager get gmailThreads =>
      $$GmailThreadsTableTableManager(_db, _db.gmailThreads);
  $$GmailMessagesTableTableManager get gmailMessages =>
      $$GmailMessagesTableTableManager(_db, _db.gmailMessages);
  $$SlackAccountsTableTableManager get slackAccounts =>
      $$SlackAccountsTableTableManager(_db, _db.slackAccounts);
  $$SlackConversationsTableTableManager get slackConversations =>
      $$SlackConversationsTableTableManager(_db, _db.slackConversations);
  $$SlackMessagesTableTableManager get slackMessages =>
      $$SlackMessagesTableTableManager(_db, _db.slackMessages);
  $$BrowserBookmarksTableTableManager get browserBookmarks =>
      $$BrowserBookmarksTableTableManager(_db, _db.browserBookmarks);
  $$SystemMetricSamplesTableTableManager get systemMetricSamples =>
      $$SystemMetricSamplesTableTableManager(_db, _db.systemMetricSamples);
  $$FeatureUsageSessionsTableTableManager get featureUsageSessions =>
      $$FeatureUsageSessionsTableTableManager(_db, _db.featureUsageSessions);
}
