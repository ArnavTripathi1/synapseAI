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


/** This is an auto generated class representing the AIChatSession type in your schema. */
class AIChatSession extends amplify_core.Model {
  static const classType = const _AIChatSessionModelType();
  final String id;
  final String? _title;
  final List<AIChatMessage>? _messages;
  final amplify_core.TemporalDateTime? _updatedAt;
  final amplify_core.TemporalDateTime? _createdAt;

  @override
  getInstanceType() => classType;
  
  @Deprecated('[getId] is being deprecated in favor of custom primary key feature. Use getter [modelIdentifier] to get model identifier.')
  @override
  String getId() => id;
  
  AIChatSessionModelIdentifier get modelIdentifier {
      return AIChatSessionModelIdentifier(
        id: id
      );
  }
  
  String get title {
    try {
      return _title!;
    } catch(e) {
      throw amplify_core.AmplifyCodeGenModelException(
          amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastExceptionMessage,
          recoverySuggestion:
            amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastRecoverySuggestion,
          underlyingException: e.toString()
          );
    }
  }
  
  List<AIChatMessage>? get messages {
    return _messages;
  }
  
  amplify_core.TemporalDateTime? get updatedAt {
    return _updatedAt;
  }
  
  amplify_core.TemporalDateTime? get createdAt {
    return _createdAt;
  }
  
  const AIChatSession._internal({required this.id, required title, messages, updatedAt, createdAt}): _title = title, _messages = messages, _updatedAt = updatedAt, _createdAt = createdAt;
  
  factory AIChatSession({String? id, required String title, List<AIChatMessage>? messages, amplify_core.TemporalDateTime? updatedAt, amplify_core.TemporalDateTime? createdAt}) {
    return AIChatSession._internal(
      id: id == null ? amplify_core.UUID.getUUID() : id,
      title: title,
      messages: messages != null ? List<AIChatMessage>.unmodifiable(messages) : messages,
      updatedAt: updatedAt,
      createdAt: createdAt);
  }
  
  bool equals(Object other) {
    return this == other;
  }
  
  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AIChatSession &&
      id == other.id &&
      _title == other._title &&
      DeepCollectionEquality().equals(_messages, other._messages) &&
      _updatedAt == other._updatedAt &&
      _createdAt == other._createdAt;
  }
  
  @override
  int get hashCode => toString().hashCode;
  
  @override
  String toString() {
    var buffer = new StringBuffer();
    
    buffer.write("AIChatSession {");
    buffer.write("id=" + "$id" + ", ");
    buffer.write("title=" + "$_title" + ", ");
    buffer.write("updatedAt=" + (_updatedAt != null ? _updatedAt!.format() : "null") + ", ");
    buffer.write("createdAt=" + (_createdAt != null ? _createdAt!.format() : "null"));
    buffer.write("}");
    
    return buffer.toString();
  }
  
  AIChatSession copyWith({String? title, List<AIChatMessage>? messages, amplify_core.TemporalDateTime? updatedAt, amplify_core.TemporalDateTime? createdAt}) {
    return AIChatSession._internal(
      id: id,
      title: title ?? this.title,
      messages: messages ?? this.messages,
      updatedAt: updatedAt ?? this.updatedAt,
      createdAt: createdAt ?? this.createdAt);
  }
  
  AIChatSession copyWithModelFieldValues({
    ModelFieldValue<String>? title,
    ModelFieldValue<List<AIChatMessage>?>? messages,
    ModelFieldValue<amplify_core.TemporalDateTime?>? updatedAt,
    ModelFieldValue<amplify_core.TemporalDateTime?>? createdAt
  }) {
    return AIChatSession._internal(
      id: id,
      title: title == null ? this.title : title.value,
      messages: messages == null ? this.messages : messages.value,
      updatedAt: updatedAt == null ? this.updatedAt : updatedAt.value,
      createdAt: createdAt == null ? this.createdAt : createdAt.value
    );
  }
  
  AIChatSession.fromJson(Map<String, dynamic> json)  
    : id = json['id'],
      _title = json['title'],
      _messages = json['messages']  is Map
        ? (json['messages']['items'] is List
          ? (json['messages']['items'] as List)
              .where((e) => e != null)
              .map((e) => AIChatMessage.fromJson(new Map<String, dynamic>.from(e)))
              .toList()
          : null)
        : (json['messages'] is List
          ? (json['messages'] as List)
              .where((e) => e?['serializedData'] != null)
              .map((e) => AIChatMessage.fromJson(new Map<String, dynamic>.from(e?['serializedData'])))
              .toList()
          : null),
      _updatedAt = json['updatedAt'] != null ? amplify_core.TemporalDateTime.fromString(json['updatedAt']) : null,
      _createdAt = json['createdAt'] != null ? amplify_core.TemporalDateTime.fromString(json['createdAt']) : null;
  
  Map<String, dynamic> toJson() => {
    'id': id, 'title': _title, 'messages': _messages?.map((AIChatMessage? e) => e?.toJson()).toList(), 'updatedAt': _updatedAt?.format(), 'createdAt': _createdAt?.format()
  };
  
  Map<String, Object?> toMap() => {
    'id': id,
    'title': _title,
    'messages': _messages,
    'updatedAt': _updatedAt,
    'createdAt': _createdAt
  };

  static final amplify_core.QueryModelIdentifier<AIChatSessionModelIdentifier> MODEL_IDENTIFIER = amplify_core.QueryModelIdentifier<AIChatSessionModelIdentifier>();
  static final ID = amplify_core.QueryField(fieldName: "id");
  static final TITLE = amplify_core.QueryField(fieldName: "title");
  static final MESSAGES = amplify_core.QueryField(
    fieldName: "messages",
    fieldType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.model, ofModelName: 'AIChatMessage'));
  static final UPDATEDAT = amplify_core.QueryField(fieldName: "updatedAt");
  static final CREATEDAT = amplify_core.QueryField(fieldName: "createdAt");
  static var schema = amplify_core.Model.defineSchema(define: (amplify_core.ModelSchemaDefinition modelSchemaDefinition) {
    modelSchemaDefinition.name = "AIChatSession";
    modelSchemaDefinition.pluralName = "AIChatSessions";
    
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
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.id());
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: AIChatSession.TITLE,
      isRequired: true,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.hasMany(
      key: AIChatSession.MESSAGES,
      isRequired: false,
      ofModelName: 'AIChatMessage',
      associatedKey: AIChatMessage.SESSIONID
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: AIChatSession.UPDATEDAT,
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.dateTime)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: AIChatSession.CREATEDAT,
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.dateTime)
    ));
  });
}

class _AIChatSessionModelType extends amplify_core.ModelType<AIChatSession> {
  const _AIChatSessionModelType();
  
  @override
  AIChatSession fromJson(Map<String, dynamic> jsonData) {
    return AIChatSession.fromJson(jsonData);
  }
  
  @override
  String modelName() {
    return 'AIChatSession';
  }
}

/**
 * This is an auto generated class representing the model identifier
 * of [AIChatSession] in your schema.
 */
class AIChatSessionModelIdentifier implements amplify_core.ModelIdentifier<AIChatSession> {
  final String id;

  /** Create an instance of AIChatSessionModelIdentifier using [id] the primary key. */
  const AIChatSessionModelIdentifier({
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
  String toString() => 'AIChatSessionModelIdentifier(id: $id)';
  
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    
    return other is AIChatSessionModelIdentifier &&
      id == other.id;
  }
  
  @override
  int get hashCode =>
    id.hashCode;
}