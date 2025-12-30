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


/** This is an auto generated class representing the Resource type in your schema. */
class Resource extends amplify_core.Model {
  static const classType = const _ResourceModelType();
  final String id;
  final String? _title;
  final ResourceType? _type;
  final String? _category;
  final String? _duration;
  final String? _description;
  final String? _contentBody;
  final String? _url;
  final String? _thumbnailUrl;
  final bool? _isFeatured;
  final amplify_core.TemporalDateTime? _createdAt;
  final amplify_core.TemporalDateTime? _updatedAt;

  @override
  getInstanceType() => classType;
  
  @Deprecated('[getId] is being deprecated in favor of custom primary key feature. Use getter [modelIdentifier] to get model identifier.')
  @override
  String getId() => id;
  
  ResourceModelIdentifier get modelIdentifier {
      return ResourceModelIdentifier(
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
  
  ResourceType get type {
    try {
      return _type!;
    } catch(e) {
      throw amplify_core.AmplifyCodeGenModelException(
          amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastExceptionMessage,
          recoverySuggestion:
            amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastRecoverySuggestion,
          underlyingException: e.toString()
          );
    }
  }
  
  String get category {
    try {
      return _category!;
    } catch(e) {
      throw amplify_core.AmplifyCodeGenModelException(
          amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastExceptionMessage,
          recoverySuggestion:
            amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastRecoverySuggestion,
          underlyingException: e.toString()
          );
    }
  }
  
  String? get duration {
    return _duration;
  }
  
  String? get description {
    return _description;
  }
  
  String? get contentBody {
    return _contentBody;
  }
  
  String? get url {
    return _url;
  }
  
  String? get thumbnailUrl {
    return _thumbnailUrl;
  }
  
  bool? get isFeatured {
    return _isFeatured;
  }
  
  amplify_core.TemporalDateTime? get createdAt {
    return _createdAt;
  }
  
  amplify_core.TemporalDateTime? get updatedAt {
    return _updatedAt;
  }
  
  const Resource._internal({required this.id, required title, required type, required category, duration, description, contentBody, url, thumbnailUrl, isFeatured, createdAt, updatedAt}): _title = title, _type = type, _category = category, _duration = duration, _description = description, _contentBody = contentBody, _url = url, _thumbnailUrl = thumbnailUrl, _isFeatured = isFeatured, _createdAt = createdAt, _updatedAt = updatedAt;
  
  factory Resource({String? id, required String title, required ResourceType type, required String category, String? duration, String? description, String? contentBody, String? url, String? thumbnailUrl, bool? isFeatured}) {
    return Resource._internal(
      id: id == null ? amplify_core.UUID.getUUID() : id,
      title: title,
      type: type,
      category: category,
      duration: duration,
      description: description,
      contentBody: contentBody,
      url: url,
      thumbnailUrl: thumbnailUrl,
      isFeatured: isFeatured);
  }
  
  bool equals(Object other) {
    return this == other;
  }
  
  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is Resource &&
      id == other.id &&
      _title == other._title &&
      _type == other._type &&
      _category == other._category &&
      _duration == other._duration &&
      _description == other._description &&
      _contentBody == other._contentBody &&
      _url == other._url &&
      _thumbnailUrl == other._thumbnailUrl &&
      _isFeatured == other._isFeatured;
  }
  
  @override
  int get hashCode => toString().hashCode;
  
  @override
  String toString() {
    var buffer = new StringBuffer();
    
    buffer.write("Resource {");
    buffer.write("id=" + "$id" + ", ");
    buffer.write("title=" + "$_title" + ", ");
    buffer.write("type=" + (_type != null ? amplify_core.enumToString(_type)! : "null") + ", ");
    buffer.write("category=" + "$_category" + ", ");
    buffer.write("duration=" + "$_duration" + ", ");
    buffer.write("description=" + "$_description" + ", ");
    buffer.write("contentBody=" + "$_contentBody" + ", ");
    buffer.write("url=" + "$_url" + ", ");
    buffer.write("thumbnailUrl=" + "$_thumbnailUrl" + ", ");
    buffer.write("isFeatured=" + (_isFeatured != null ? _isFeatured!.toString() : "null") + ", ");
    buffer.write("createdAt=" + (_createdAt != null ? _createdAt!.format() : "null") + ", ");
    buffer.write("updatedAt=" + (_updatedAt != null ? _updatedAt!.format() : "null"));
    buffer.write("}");
    
    return buffer.toString();
  }
  
  Resource copyWith({String? title, ResourceType? type, String? category, String? duration, String? description, String? contentBody, String? url, String? thumbnailUrl, bool? isFeatured}) {
    return Resource._internal(
      id: id,
      title: title ?? this.title,
      type: type ?? this.type,
      category: category ?? this.category,
      duration: duration ?? this.duration,
      description: description ?? this.description,
      contentBody: contentBody ?? this.contentBody,
      url: url ?? this.url,
      thumbnailUrl: thumbnailUrl ?? this.thumbnailUrl,
      isFeatured: isFeatured ?? this.isFeatured);
  }
  
  Resource copyWithModelFieldValues({
    ModelFieldValue<String>? title,
    ModelFieldValue<ResourceType>? type,
    ModelFieldValue<String>? category,
    ModelFieldValue<String?>? duration,
    ModelFieldValue<String?>? description,
    ModelFieldValue<String?>? contentBody,
    ModelFieldValue<String?>? url,
    ModelFieldValue<String?>? thumbnailUrl,
    ModelFieldValue<bool?>? isFeatured
  }) {
    return Resource._internal(
      id: id,
      title: title == null ? this.title : title.value,
      type: type == null ? this.type : type.value,
      category: category == null ? this.category : category.value,
      duration: duration == null ? this.duration : duration.value,
      description: description == null ? this.description : description.value,
      contentBody: contentBody == null ? this.contentBody : contentBody.value,
      url: url == null ? this.url : url.value,
      thumbnailUrl: thumbnailUrl == null ? this.thumbnailUrl : thumbnailUrl.value,
      isFeatured: isFeatured == null ? this.isFeatured : isFeatured.value
    );
  }
  
  Resource.fromJson(Map<String, dynamic> json)  
    : id = json['id'],
      _title = json['title'],
      _type = amplify_core.enumFromString<ResourceType>(json['type'], ResourceType.values),
      _category = json['category'],
      _duration = json['duration'],
      _description = json['description'],
      _contentBody = json['contentBody'],
      _url = json['url'],
      _thumbnailUrl = json['thumbnailUrl'],
      _isFeatured = json['isFeatured'],
      _createdAt = json['createdAt'] != null ? amplify_core.TemporalDateTime.fromString(json['createdAt']) : null,
      _updatedAt = json['updatedAt'] != null ? amplify_core.TemporalDateTime.fromString(json['updatedAt']) : null;
  
  Map<String, dynamic> toJson() => {
    'id': id, 'title': _title, 'type': amplify_core.enumToString(_type), 'category': _category, 'duration': _duration, 'description': _description, 'contentBody': _contentBody, 'url': _url, 'thumbnailUrl': _thumbnailUrl, 'isFeatured': _isFeatured, 'createdAt': _createdAt?.format(), 'updatedAt': _updatedAt?.format()
  };
  
  Map<String, Object?> toMap() => {
    'id': id,
    'title': _title,
    'type': _type,
    'category': _category,
    'duration': _duration,
    'description': _description,
    'contentBody': _contentBody,
    'url': _url,
    'thumbnailUrl': _thumbnailUrl,
    'isFeatured': _isFeatured,
    'createdAt': _createdAt,
    'updatedAt': _updatedAt
  };

  static final amplify_core.QueryModelIdentifier<ResourceModelIdentifier> MODEL_IDENTIFIER = amplify_core.QueryModelIdentifier<ResourceModelIdentifier>();
  static final ID = amplify_core.QueryField(fieldName: "id");
  static final TITLE = amplify_core.QueryField(fieldName: "title");
  static final TYPE = amplify_core.QueryField(fieldName: "type");
  static final CATEGORY = amplify_core.QueryField(fieldName: "category");
  static final DURATION = amplify_core.QueryField(fieldName: "duration");
  static final DESCRIPTION = amplify_core.QueryField(fieldName: "description");
  static final CONTENTBODY = amplify_core.QueryField(fieldName: "contentBody");
  static final URL = amplify_core.QueryField(fieldName: "url");
  static final THUMBNAILURL = amplify_core.QueryField(fieldName: "thumbnailUrl");
  static final ISFEATURED = amplify_core.QueryField(fieldName: "isFeatured");
  static var schema = amplify_core.Model.defineSchema(define: (amplify_core.ModelSchemaDefinition modelSchemaDefinition) {
    modelSchemaDefinition.name = "Resource";
    modelSchemaDefinition.pluralName = "Resources";
    
    modelSchemaDefinition.authRules = [
      amplify_core.AuthRule(
        authStrategy: amplify_core.AuthStrategy.PRIVATE,
        operations: const [
          amplify_core.ModelOperation.READ
        ]),
      amplify_core.AuthRule(
        authStrategy: amplify_core.AuthStrategy.GROUPS,
        groupClaim: "cognito:groups",
        groups: [ "Admin" ],
        provider: amplify_core.AuthRuleProvider.USERPOOLS,
        operations: const [
          amplify_core.ModelOperation.CREATE,
          amplify_core.ModelOperation.UPDATE,
          amplify_core.ModelOperation.DELETE
        ])
    ];
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.id());
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: Resource.TITLE,
      isRequired: true,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: Resource.TYPE,
      isRequired: true,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.enumeration)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: Resource.CATEGORY,
      isRequired: true,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: Resource.DURATION,
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: Resource.DESCRIPTION,
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: Resource.CONTENTBODY,
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: Resource.URL,
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: Resource.THUMBNAILURL,
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: Resource.ISFEATURED,
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.bool)
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

class _ResourceModelType extends amplify_core.ModelType<Resource> {
  const _ResourceModelType();
  
  @override
  Resource fromJson(Map<String, dynamic> jsonData) {
    return Resource.fromJson(jsonData);
  }
  
  @override
  String modelName() {
    return 'Resource';
  }
}

/**
 * This is an auto generated class representing the model identifier
 * of [Resource] in your schema.
 */
class ResourceModelIdentifier implements amplify_core.ModelIdentifier<Resource> {
  final String id;

  /** Create an instance of ResourceModelIdentifier using [id] the primary key. */
  const ResourceModelIdentifier({
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
  String toString() => 'ResourceModelIdentifier(id: $id)';
  
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    
    return other is ResourceModelIdentifier &&
      id == other.id;
  }
  
  @override
  int get hashCode =>
    id.hashCode;
}