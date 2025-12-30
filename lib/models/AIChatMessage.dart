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


/** This is an auto generated class representing the AIChatMessage type in your schema. */
class AIChatMessage extends amplify_core.Model {
  static const classType = const _AIChatMessageModelType();
  final String id;
  final String? _sessionID;
  final String? _content;
  final bool? _isUser;
  final amplify_core.TemporalDateTime? _createdAt;
  final amplify_core.TemporalDateTime? _updatedAt;

  @override
  getInstanceType() => classType;
  
  @Deprecated('[getId] is being deprecated in favor of custom primary key feature. Use getter [modelIdentifier] to get model identifier.')
  @override
  String getId() => id;
  
  AIChatMessageModelIdentifier get modelIdentifier {
      return AIChatMessageModelIdentifier(
        id: id
      );
  }
  
  String get sessionID {
    try {
      return _sessionID!;
    } catch(e) {
      throw amplify_core.AmplifyCodeGenModelException(
          amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastExceptionMessage,
          recoverySuggestion:
            amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastRecoverySuggestion,
          underlyingException: e.toString()
          );
    }
  }
  
  String get content {
    try {
      return _content!;
    } catch(e) {
      throw amplify_core.AmplifyCodeGenModelException(
          amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastExceptionMessage,
          recoverySuggestion:
            amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastRecoverySuggestion,
          underlyingException: e.toString()
          );
    }
  }
  
  bool get isUser {
    try {
      return _isUser!;
    } catch(e) {
      throw amplify_core.AmplifyCodeGenModelException(
          amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastExceptionMessage,
          recoverySuggestion:
            amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastRecoverySuggestion,
          underlyingException: e.toString()
          );
    }
  }
  
  amplify_core.TemporalDateTime get createdAt {
    try {
      return _createdAt!;
    } catch(e) {
      throw amplify_core.AmplifyCodeGenModelException(
          amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastExceptionMessage,
          recoverySuggestion:
            amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastRecoverySuggestion,
          underlyingException: e.toString()
          );
    }
  }
  
  amplify_core.TemporalDateTime? get updatedAt {
    return _updatedAt;
  }
  
  const AIChatMessage._internal({required this.id, required sessionID, required content, required isUser, required createdAt, updatedAt}): _sessionID = sessionID, _content = content, _isUser = isUser, _createdAt = createdAt, _updatedAt = updatedAt;
  
  factory AIChatMessage({String? id, required String sessionID, required String content, required bool isUser, required amplify_core.TemporalDateTime createdAt}) {
    return AIChatMessage._internal(
      id: id == null ? amplify_core.UUID.getUUID() : id,
      sessionID: sessionID,
      content: content,
      isUser: isUser,
      createdAt: createdAt);
  }
  
  bool equals(Object other) {
    return this == other;
  }
  
  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is AIChatMessage &&
      id == other.id &&
      _sessionID == other._sessionID &&
      _content == other._content &&
      _isUser == other._isUser &&
      _createdAt == other._createdAt;
  }
  
  @override
  int get hashCode => toString().hashCode;
  
  @override
  String toString() {
    var buffer = new StringBuffer();
    
    buffer.write("AIChatMessage {");
    buffer.write("id=" + "$id" + ", ");
    buffer.write("sessionID=" + "$_sessionID" + ", ");
    buffer.write("content=" + "$_content" + ", ");
    buffer.write("isUser=" + (_isUser != null ? _isUser!.toString() : "null") + ", ");
    buffer.write("createdAt=" + (_createdAt != null ? _createdAt!.format() : "null") + ", ");
    buffer.write("updatedAt=" + (_updatedAt != null ? _updatedAt!.format() : "null"));
    buffer.write("}");
    
    return buffer.toString();
  }
  
  AIChatMessage copyWith({String? sessionID, String? content, bool? isUser, amplify_core.TemporalDateTime? createdAt}) {
    return AIChatMessage._internal(
      id: id,
      sessionID: sessionID ?? this.sessionID,
      content: content ?? this.content,
      isUser: isUser ?? this.isUser,
      createdAt: createdAt ?? this.createdAt);
  }
  
  AIChatMessage copyWithModelFieldValues({
    ModelFieldValue<String>? sessionID,
    ModelFieldValue<String>? content,
    ModelFieldValue<bool>? isUser,
    ModelFieldValue<amplify_core.TemporalDateTime>? createdAt
  }) {
    return AIChatMessage._internal(
      id: id,
      sessionID: sessionID == null ? this.sessionID : sessionID.value,
      content: content == null ? this.content : content.value,
      isUser: isUser == null ? this.isUser : isUser.value,
      createdAt: createdAt == null ? this.createdAt : createdAt.value
    );
  }
  
  AIChatMessage.fromJson(Map<String, dynamic> json)  
    : id = json['id'],
      _sessionID = json['sessionID'],
      _content = json['content'],
      _isUser = json['isUser'],
      _createdAt = json['createdAt'] != null ? amplify_core.TemporalDateTime.fromString(json['createdAt']) : null,
      _updatedAt = json['updatedAt'] != null ? amplify_core.TemporalDateTime.fromString(json['updatedAt']) : null;
  
  Map<String, dynamic> toJson() => {
    'id': id, 'sessionID': _sessionID, 'content': _content, 'isUser': _isUser, 'createdAt': _createdAt?.format(), 'updatedAt': _updatedAt?.format()
  };
  
  Map<String, Object?> toMap() => {
    'id': id,
    'sessionID': _sessionID,
    'content': _content,
    'isUser': _isUser,
    'createdAt': _createdAt,
    'updatedAt': _updatedAt
  };

  static final amplify_core.QueryModelIdentifier<AIChatMessageModelIdentifier> MODEL_IDENTIFIER = amplify_core.QueryModelIdentifier<AIChatMessageModelIdentifier>();
  static final ID = amplify_core.QueryField(fieldName: "id");
  static final SESSIONID = amplify_core.QueryField(fieldName: "sessionID");
  static final CONTENT = amplify_core.QueryField(fieldName: "content");
  static final ISUSER = amplify_core.QueryField(fieldName: "isUser");
  static final CREATEDAT = amplify_core.QueryField(fieldName: "createdAt");
  static var schema = amplify_core.Model.defineSchema(define: (amplify_core.ModelSchemaDefinition modelSchemaDefinition) {
    modelSchemaDefinition.name = "AIChatMessage";
    modelSchemaDefinition.pluralName = "AIChatMessages";
    
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
      amplify_core.ModelIndex(fields: const ["sessionID", "createdAt"], name: "bySession")
    ];
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.id());
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: AIChatMessage.SESSIONID,
      isRequired: true,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: AIChatMessage.CONTENT,
      isRequired: true,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: AIChatMessage.ISUSER,
      isRequired: true,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.bool)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: AIChatMessage.CREATEDAT,
      isRequired: true,
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

class _AIChatMessageModelType extends amplify_core.ModelType<AIChatMessage> {
  const _AIChatMessageModelType();
  
  @override
  AIChatMessage fromJson(Map<String, dynamic> jsonData) {
    return AIChatMessage.fromJson(jsonData);
  }
  
  @override
  String modelName() {
    return 'AIChatMessage';
  }
}

/**
 * This is an auto generated class representing the model identifier
 * of [AIChatMessage] in your schema.
 */
class AIChatMessageModelIdentifier implements amplify_core.ModelIdentifier<AIChatMessage> {
  final String id;

  /** Create an instance of AIChatMessageModelIdentifier using [id] the primary key. */
  const AIChatMessageModelIdentifier({
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
  String toString() => 'AIChatMessageModelIdentifier(id: $id)';
  
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    
    return other is AIChatMessageModelIdentifier &&
      id == other.id;
  }
  
  @override
  int get hashCode =>
    id.hashCode;
}