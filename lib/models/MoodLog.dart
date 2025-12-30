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


/** This is an auto generated class representing the MoodLog type in your schema. */
class MoodLog extends amplify_core.Model {
  static const classType = const _MoodLogModelType();
  final String id;
  final String? _studentID;
  final amplify_core.TemporalDate? _date;
  final int? _score;
  final String? _moodLabel;
  final double? _sleepHours;
  final double? _focusHours;
  final amplify_core.TemporalDateTime? _createdAt;
  final amplify_core.TemporalDateTime? _updatedAt;

  @override
  getInstanceType() => classType;
  
  @Deprecated('[getId] is being deprecated in favor of custom primary key feature. Use getter [modelIdentifier] to get model identifier.')
  @override
  String getId() => id;
  
  MoodLogModelIdentifier get modelIdentifier {
      return MoodLogModelIdentifier(
        id: id
      );
  }
  
  String get studentID {
    try {
      return _studentID!;
    } catch(e) {
      throw amplify_core.AmplifyCodeGenModelException(
          amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastExceptionMessage,
          recoverySuggestion:
            amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastRecoverySuggestion,
          underlyingException: e.toString()
          );
    }
  }
  
  amplify_core.TemporalDate get date {
    try {
      return _date!;
    } catch(e) {
      throw amplify_core.AmplifyCodeGenModelException(
          amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastExceptionMessage,
          recoverySuggestion:
            amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastRecoverySuggestion,
          underlyingException: e.toString()
          );
    }
  }
  
  int get score {
    try {
      return _score!;
    } catch(e) {
      throw amplify_core.AmplifyCodeGenModelException(
          amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastExceptionMessage,
          recoverySuggestion:
            amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastRecoverySuggestion,
          underlyingException: e.toString()
          );
    }
  }
  
  String? get moodLabel {
    return _moodLabel;
  }
  
  double? get sleepHours {
    return _sleepHours;
  }
  
  double? get focusHours {
    return _focusHours;
  }
  
  amplify_core.TemporalDateTime? get createdAt {
    return _createdAt;
  }
  
  amplify_core.TemporalDateTime? get updatedAt {
    return _updatedAt;
  }
  
  const MoodLog._internal({required this.id, required studentID, required date, required score, moodLabel, sleepHours, focusHours, createdAt, updatedAt}): _studentID = studentID, _date = date, _score = score, _moodLabel = moodLabel, _sleepHours = sleepHours, _focusHours = focusHours, _createdAt = createdAt, _updatedAt = updatedAt;
  
  factory MoodLog({String? id, required String studentID, required amplify_core.TemporalDate date, required int score, String? moodLabel, double? sleepHours, double? focusHours}) {
    return MoodLog._internal(
      id: id == null ? amplify_core.UUID.getUUID() : id,
      studentID: studentID,
      date: date,
      score: score,
      moodLabel: moodLabel,
      sleepHours: sleepHours,
      focusHours: focusHours);
  }
  
  bool equals(Object other) {
    return this == other;
  }
  
  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is MoodLog &&
      id == other.id &&
      _studentID == other._studentID &&
      _date == other._date &&
      _score == other._score &&
      _moodLabel == other._moodLabel &&
      _sleepHours == other._sleepHours &&
      _focusHours == other._focusHours;
  }
  
  @override
  int get hashCode => toString().hashCode;
  
  @override
  String toString() {
    var buffer = new StringBuffer();
    
    buffer.write("MoodLog {");
    buffer.write("id=" + "$id" + ", ");
    buffer.write("studentID=" + "$_studentID" + ", ");
    buffer.write("date=" + (_date != null ? _date!.format() : "null") + ", ");
    buffer.write("score=" + (_score != null ? _score!.toString() : "null") + ", ");
    buffer.write("moodLabel=" + "$_moodLabel" + ", ");
    buffer.write("sleepHours=" + (_sleepHours != null ? _sleepHours!.toString() : "null") + ", ");
    buffer.write("focusHours=" + (_focusHours != null ? _focusHours!.toString() : "null") + ", ");
    buffer.write("createdAt=" + (_createdAt != null ? _createdAt!.format() : "null") + ", ");
    buffer.write("updatedAt=" + (_updatedAt != null ? _updatedAt!.format() : "null"));
    buffer.write("}");
    
    return buffer.toString();
  }
  
  MoodLog copyWith({String? studentID, amplify_core.TemporalDate? date, int? score, String? moodLabel, double? sleepHours, double? focusHours}) {
    return MoodLog._internal(
      id: id,
      studentID: studentID ?? this.studentID,
      date: date ?? this.date,
      score: score ?? this.score,
      moodLabel: moodLabel ?? this.moodLabel,
      sleepHours: sleepHours ?? this.sleepHours,
      focusHours: focusHours ?? this.focusHours);
  }
  
  MoodLog copyWithModelFieldValues({
    ModelFieldValue<String>? studentID,
    ModelFieldValue<amplify_core.TemporalDate>? date,
    ModelFieldValue<int>? score,
    ModelFieldValue<String?>? moodLabel,
    ModelFieldValue<double?>? sleepHours,
    ModelFieldValue<double?>? focusHours
  }) {
    return MoodLog._internal(
      id: id,
      studentID: studentID == null ? this.studentID : studentID.value,
      date: date == null ? this.date : date.value,
      score: score == null ? this.score : score.value,
      moodLabel: moodLabel == null ? this.moodLabel : moodLabel.value,
      sleepHours: sleepHours == null ? this.sleepHours : sleepHours.value,
      focusHours: focusHours == null ? this.focusHours : focusHours.value
    );
  }
  
  MoodLog.fromJson(Map<String, dynamic> json)  
    : id = json['id'],
      _studentID = json['studentID'],
      _date = json['date'] != null ? amplify_core.TemporalDate.fromString(json['date']) : null,
      _score = (json['score'] as num?)?.toInt(),
      _moodLabel = json['moodLabel'],
      _sleepHours = (json['sleepHours'] as num?)?.toDouble(),
      _focusHours = (json['focusHours'] as num?)?.toDouble(),
      _createdAt = json['createdAt'] != null ? amplify_core.TemporalDateTime.fromString(json['createdAt']) : null,
      _updatedAt = json['updatedAt'] != null ? amplify_core.TemporalDateTime.fromString(json['updatedAt']) : null;
  
  Map<String, dynamic> toJson() => {
    'id': id, 'studentID': _studentID, 'date': _date?.format(), 'score': _score, 'moodLabel': _moodLabel, 'sleepHours': _sleepHours, 'focusHours': _focusHours, 'createdAt': _createdAt?.format(), 'updatedAt': _updatedAt?.format()
  };
  
  Map<String, Object?> toMap() => {
    'id': id,
    'studentID': _studentID,
    'date': _date,
    'score': _score,
    'moodLabel': _moodLabel,
    'sleepHours': _sleepHours,
    'focusHours': _focusHours,
    'createdAt': _createdAt,
    'updatedAt': _updatedAt
  };

  static final amplify_core.QueryModelIdentifier<MoodLogModelIdentifier> MODEL_IDENTIFIER = amplify_core.QueryModelIdentifier<MoodLogModelIdentifier>();
  static final ID = amplify_core.QueryField(fieldName: "id");
  static final STUDENTID = amplify_core.QueryField(fieldName: "studentID");
  static final DATE = amplify_core.QueryField(fieldName: "date");
  static final SCORE = amplify_core.QueryField(fieldName: "score");
  static final MOODLABEL = amplify_core.QueryField(fieldName: "moodLabel");
  static final SLEEPHOURS = amplify_core.QueryField(fieldName: "sleepHours");
  static final FOCUSHOURS = amplify_core.QueryField(fieldName: "focusHours");
  static var schema = amplify_core.Model.defineSchema(define: (amplify_core.ModelSchemaDefinition modelSchemaDefinition) {
    modelSchemaDefinition.name = "MoodLog";
    modelSchemaDefinition.pluralName = "MoodLogs";
    
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
        ])
    ];
    
    modelSchemaDefinition.indexes = [
      amplify_core.ModelIndex(fields: const ["studentID", "date"], name: "byStudent")
    ];
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.id());
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: MoodLog.STUDENTID,
      isRequired: true,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: MoodLog.DATE,
      isRequired: true,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.date)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: MoodLog.SCORE,
      isRequired: true,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.int)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: MoodLog.MOODLABEL,
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: MoodLog.SLEEPHOURS,
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.double)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: MoodLog.FOCUSHOURS,
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.double)
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

class _MoodLogModelType extends amplify_core.ModelType<MoodLog> {
  const _MoodLogModelType();
  
  @override
  MoodLog fromJson(Map<String, dynamic> jsonData) {
    return MoodLog.fromJson(jsonData);
  }
  
  @override
  String modelName() {
    return 'MoodLog';
  }
}

/**
 * This is an auto generated class representing the model identifier
 * of [MoodLog] in your schema.
 */
class MoodLogModelIdentifier implements amplify_core.ModelIdentifier<MoodLog> {
  final String id;

  /** Create an instance of MoodLogModelIdentifier using [id] the primary key. */
  const MoodLogModelIdentifier({
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
  String toString() => 'MoodLogModelIdentifier(id: $id)';
  
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    
    return other is MoodLogModelIdentifier &&
      id == other.id;
  }
  
  @override
  int get hashCode =>
    id.hashCode;
}