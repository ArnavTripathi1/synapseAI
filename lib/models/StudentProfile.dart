/*
* Copyright 2021 Amazon.com, Inc. or its affiliates. All Rights Reserved.
*
* Licensed under the Apache License, Version 2.0 (the "License").
* You may not use this file except in compliance with the License.
* A copy of the License is located at
*
*  http://aws.amazon.com/apache2.0
*
* or in the "license" file accompanying this file. This file is distributed
* on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either
* express or implied. See the License for the specific language governing
* permissions and limitations under the License.
*/

// NOTE: This file is generated and may not follow lint rules defined in your app
// Generated files can be excluded from analysis in analysis_options.yaml
// For more info, see: https://dart.dev/guides/language/analysis-options#excluding-code-from-analysis

// ignore_for_file: public_member_api_docs, annotate_overrides, dead_code, dead_codepublic_member_api_docs, depend_on_referenced_packages, file_names, library_private_types_in_public_api, no_leading_underscores_for_library_prefixes, no_leading_underscores_for_local_identifiers, non_constant_identifier_names, null_check_on_nullable_type_parameter, override_on_non_overriding_member, prefer_adjacent_string_concatenation, prefer_const_constructors, prefer_if_null_operators, prefer_interpolation_to_compose_strings, slash_for_doc_comments, sort_child_properties_last, unnecessary_const, unnecessary_constructor_name, unnecessary_late, unnecessary_new, unnecessary_null_aware_assignments, unnecessary_nullable_for_final_variable_declarations, unnecessary_string_interpolations, use_build_context_synchronously

import 'ModelProvider.dart';
import 'package:amplify_core/amplify_core.dart' as amplify_core;
import 'package:collection/collection.dart';


/** This is an auto generated class representing the StudentProfile type in your schema. */
class StudentProfile extends amplify_core.Model {
  static const classType = const _StudentProfileModelType();
  final String id;
  final String? _userProfileID;
  final String? _branch;
  final String? _year;
  final int? _wellnessScore;
  final String? _currentMood;
  final List<MoodLog>? _moodLogs;
  final List<Appointment>? _appointments;
  final amplify_core.TemporalDateTime? _createdAt;
  final amplify_core.TemporalDateTime? _updatedAt;

  @override
  getInstanceType() => classType;
  
  @Deprecated('[getId] is being deprecated in favor of custom primary key feature. Use getter [modelIdentifier] to get model identifier.')
  @override
  String getId() => id;
  
  StudentProfileModelIdentifier get modelIdentifier {
      return StudentProfileModelIdentifier(
        id: id
      );
  }
  
  String get userProfileID {
    try {
      return _userProfileID!;
    } catch(e) {
      throw amplify_core.AmplifyCodeGenModelException(
          amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastExceptionMessage,
          recoverySuggestion:
            amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastRecoverySuggestion,
          underlyingException: e.toString()
          );
    }
  }
  
  String? get branch {
    return _branch;
  }
  
  String? get year {
    return _year;
  }
  
  int? get wellnessScore {
    return _wellnessScore;
  }
  
  String? get currentMood {
    return _currentMood;
  }
  
  List<MoodLog>? get moodLogs {
    return _moodLogs;
  }
  
  List<Appointment>? get appointments {
    return _appointments;
  }
  
  amplify_core.TemporalDateTime? get createdAt {
    return _createdAt;
  }
  
  amplify_core.TemporalDateTime? get updatedAt {
    return _updatedAt;
  }
  
  const StudentProfile._internal({required this.id, required userProfileID, branch, year, wellnessScore, currentMood, moodLogs, appointments, createdAt, updatedAt}): _userProfileID = userProfileID, _branch = branch, _year = year, _wellnessScore = wellnessScore, _currentMood = currentMood, _moodLogs = moodLogs, _appointments = appointments, _createdAt = createdAt, _updatedAt = updatedAt;
  
  factory StudentProfile({String? id, required String userProfileID, String? branch, String? year, int? wellnessScore, String? currentMood, List<MoodLog>? moodLogs, List<Appointment>? appointments}) {
    return StudentProfile._internal(
      id: id == null ? amplify_core.UUID.getUUID() : id,
      userProfileID: userProfileID,
      branch: branch,
      year: year,
      wellnessScore: wellnessScore,
      currentMood: currentMood,
      moodLogs: moodLogs != null ? List<MoodLog>.unmodifiable(moodLogs) : moodLogs,
      appointments: appointments != null ? List<Appointment>.unmodifiable(appointments) : appointments);
  }
  
  bool equals(Object other) {
    return this == other;
  }
  
  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is StudentProfile &&
      id == other.id &&
      _userProfileID == other._userProfileID &&
      _branch == other._branch &&
      _year == other._year &&
      _wellnessScore == other._wellnessScore &&
      _currentMood == other._currentMood &&
      DeepCollectionEquality().equals(_moodLogs, other._moodLogs) &&
      DeepCollectionEquality().equals(_appointments, other._appointments);
  }
  
  @override
  int get hashCode => toString().hashCode;
  
  @override
  String toString() {
    var buffer = new StringBuffer();
    
    buffer.write("StudentProfile {");
    buffer.write("id=" + "$id" + ", ");
    buffer.write("userProfileID=" + "$_userProfileID" + ", ");
    buffer.write("branch=" + "$_branch" + ", ");
    buffer.write("year=" + "$_year" + ", ");
    buffer.write("wellnessScore=" + (_wellnessScore != null ? _wellnessScore!.toString() : "null") + ", ");
    buffer.write("currentMood=" + "$_currentMood" + ", ");
    buffer.write("createdAt=" + (_createdAt != null ? _createdAt!.format() : "null") + ", ");
    buffer.write("updatedAt=" + (_updatedAt != null ? _updatedAt!.format() : "null"));
    buffer.write("}");
    
    return buffer.toString();
  }
  
  StudentProfile copyWith({String? userProfileID, String? branch, String? year, int? wellnessScore, String? currentMood, List<MoodLog>? moodLogs, List<Appointment>? appointments}) {
    return StudentProfile._internal(
      id: id,
      userProfileID: userProfileID ?? this.userProfileID,
      branch: branch ?? this.branch,
      year: year ?? this.year,
      wellnessScore: wellnessScore ?? this.wellnessScore,
      currentMood: currentMood ?? this.currentMood,
      moodLogs: moodLogs ?? this.moodLogs,
      appointments: appointments ?? this.appointments);
  }
  
  StudentProfile copyWithModelFieldValues({
    ModelFieldValue<String>? userProfileID,
    ModelFieldValue<String?>? branch,
    ModelFieldValue<String?>? year,
    ModelFieldValue<int?>? wellnessScore,
    ModelFieldValue<String?>? currentMood,
    ModelFieldValue<List<MoodLog>?>? moodLogs,
    ModelFieldValue<List<Appointment>?>? appointments
  }) {
    return StudentProfile._internal(
      id: id,
      userProfileID: userProfileID == null ? this.userProfileID : userProfileID.value,
      branch: branch == null ? this.branch : branch.value,
      year: year == null ? this.year : year.value,
      wellnessScore: wellnessScore == null ? this.wellnessScore : wellnessScore.value,
      currentMood: currentMood == null ? this.currentMood : currentMood.value,
      moodLogs: moodLogs == null ? this.moodLogs : moodLogs.value,
      appointments: appointments == null ? this.appointments : appointments.value
    );
  }
  
  StudentProfile.fromJson(Map<String, dynamic> json)  
    : id = json['id'],
      _userProfileID = json['userProfileID'],
      _branch = json['branch'],
      _year = json['year'],
      _wellnessScore = (json['wellnessScore'] as num?)?.toInt(),
      _currentMood = json['currentMood'],
      _moodLogs = json['moodLogs']  is Map
        ? (json['moodLogs']['items'] is List
          ? (json['moodLogs']['items'] as List)
              .where((e) => e != null)
              .map((e) => MoodLog.fromJson(new Map<String, dynamic>.from(e)))
              .toList()
          : null)
        : (json['moodLogs'] is List
          ? (json['moodLogs'] as List)
              .where((e) => e?['serializedData'] != null)
              .map((e) => MoodLog.fromJson(new Map<String, dynamic>.from(e?['serializedData'])))
              .toList()
          : null),
      _appointments = json['appointments']  is Map
        ? (json['appointments']['items'] is List
          ? (json['appointments']['items'] as List)
              .where((e) => e != null)
              .map((e) => Appointment.fromJson(new Map<String, dynamic>.from(e)))
              .toList()
          : null)
        : (json['appointments'] is List
          ? (json['appointments'] as List)
              .where((e) => e?['serializedData'] != null)
              .map((e) => Appointment.fromJson(new Map<String, dynamic>.from(e?['serializedData'])))
              .toList()
          : null),
      _createdAt = json['createdAt'] != null ? amplify_core.TemporalDateTime.fromString(json['createdAt']) : null,
      _updatedAt = json['updatedAt'] != null ? amplify_core.TemporalDateTime.fromString(json['updatedAt']) : null;
  
  Map<String, dynamic> toJson() => {
    'id': id, 'userProfileID': _userProfileID, 'branch': _branch, 'year': _year, 'wellnessScore': _wellnessScore, 'currentMood': _currentMood, 'moodLogs': _moodLogs?.map((MoodLog? e) => e?.toJson()).toList(), 'appointments': _appointments?.map((Appointment? e) => e?.toJson()).toList(), 'createdAt': _createdAt?.format(), 'updatedAt': _updatedAt?.format()
  };
  
  Map<String, Object?> toMap() => {
    'id': id,
    'userProfileID': _userProfileID,
    'branch': _branch,
    'year': _year,
    'wellnessScore': _wellnessScore,
    'currentMood': _currentMood,
    'moodLogs': _moodLogs,
    'appointments': _appointments,
    'createdAt': _createdAt,
    'updatedAt': _updatedAt
  };

  static final amplify_core.QueryModelIdentifier<StudentProfileModelIdentifier> MODEL_IDENTIFIER = amplify_core.QueryModelIdentifier<StudentProfileModelIdentifier>();
  static final ID = amplify_core.QueryField(fieldName: "id");
  static final USERPROFILEID = amplify_core.QueryField(fieldName: "userProfileID");
  static final BRANCH = amplify_core.QueryField(fieldName: "branch");
  static final YEAR = amplify_core.QueryField(fieldName: "year");
  static final WELLNESSSCORE = amplify_core.QueryField(fieldName: "wellnessScore");
  static final CURRENTMOOD = amplify_core.QueryField(fieldName: "currentMood");
  static final MOODLOGS = amplify_core.QueryField(
    fieldName: "moodLogs",
    fieldType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.model, ofModelName: 'MoodLog'));
  static final APPOINTMENTS = amplify_core.QueryField(
    fieldName: "appointments",
    fieldType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.model, ofModelName: 'Appointment'));
  static var schema = amplify_core.Model.defineSchema(define: (amplify_core.ModelSchemaDefinition modelSchemaDefinition) {
    modelSchemaDefinition.name = "StudentProfile";
    modelSchemaDefinition.pluralName = "StudentProfiles";
    
    modelSchemaDefinition.authRules = [
      amplify_core.AuthRule(
        authStrategy: amplify_core.AuthStrategy.OWNER,
        ownerField: "owner",
        identityClaim: "cognito:username",
        provider: amplify_core.AuthRuleProvider.USERPOOLS,
        operations: const [
          amplify_core.ModelOperation.CREATE,
          amplify_core.ModelOperation.UPDATE,
          amplify_core.ModelOperation.DELETE,
          amplify_core.ModelOperation.READ
        ]),
      amplify_core.AuthRule(
        authStrategy: amplify_core.AuthStrategy.PRIVATE,
        operations: const [
          amplify_core.ModelOperation.READ
        ])
    ];
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.id());
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: StudentProfile.USERPROFILEID,
      isRequired: true,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: StudentProfile.BRANCH,
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: StudentProfile.YEAR,
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: StudentProfile.WELLNESSSCORE,
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.int)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: StudentProfile.CURRENTMOOD,
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.hasMany(
      key: StudentProfile.MOODLOGS,
      isRequired: false,
      ofModelName: 'MoodLog',
      associatedKey: MoodLog.STUDENTID
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.hasMany(
      key: StudentProfile.APPOINTMENTS,
      isRequired: false,
      ofModelName: 'Appointment',
      associatedKey: Appointment.STUDENTID
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.nonQueryField(
      fieldName: 'createdAt',
      isRequired: false,
      isReadOnly: true,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.dateTime)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.nonQueryField(
      fieldName: 'updatedAt',
      isRequired: false,
      isReadOnly: true,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.dateTime)
    ));
  });
}

class _StudentProfileModelType extends amplify_core.ModelType<StudentProfile> {
  const _StudentProfileModelType();
  
  @override
  StudentProfile fromJson(Map<String, dynamic> jsonData) {
    return StudentProfile.fromJson(jsonData);
  }
  
  @override
  String modelName() {
    return 'StudentProfile';
  }
}

/**
 * This is an auto generated class representing the model identifier
 * of [StudentProfile] in your schema.
 */
class StudentProfileModelIdentifier implements amplify_core.ModelIdentifier<StudentProfile> {
  final String id;

  /** Create an instance of StudentProfileModelIdentifier using [id] the primary key. */
  const StudentProfileModelIdentifier({
    required this.id});
  
  @override
  Map<String, dynamic> serializeAsMap() => (<String, dynamic>{
    'id': id
  });
  
  @override
  List<Map<String, dynamic>> serializeAsList() => serializeAsMap()
    .entries
    .map((entry) => (<String, dynamic>{ entry.key: entry.value }))
    .toList();
  
  @override
  String serializeAsString() => serializeAsMap().values.join('#');
  
  @override
  String toString() => 'StudentProfileModelIdentifier(id: $id)';
  
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    
    return other is StudentProfileModelIdentifier &&
      id == other.id;
  }
  
  @override
  int get hashCode =>
    id.hashCode;
}