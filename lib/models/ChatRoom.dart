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


/** This is an auto generated class representing the ChatRoom type in your schema. */
class ChatRoom extends amplify_core.Model {
  static const classType = const _ChatRoomModelType();
  final String id;
  final List<ChatRoomUser>? _users;
  final List<Message>? _messages;
  final String? _lastMessageContent;
  final amplify_core.TemporalDateTime? _lastMessageTime;
  final amplify_core.TemporalDateTime? _createdAt;
  final amplify_core.TemporalDateTime? _updatedAt;

  @override
  getInstanceType() => classType;
  
  @Deprecated('[getId] is being deprecated in favor of custom primary key feature. Use getter [modelIdentifier] to get model identifier.')
  @override
  String getId() => id;
  
  ChatRoomModelIdentifier get modelIdentifier {
      return ChatRoomModelIdentifier(
        id: id
      );
  }
  
  List<ChatRoomUser>? get users {
    return _users;
  }
  
  List<Message>? get messages {
    return _messages;
  }
  
  String? get lastMessageContent {
    return _lastMessageContent;
  }
  
  amplify_core.TemporalDateTime? get lastMessageTime {
    return _lastMessageTime;
  }
  
  amplify_core.TemporalDateTime? get createdAt {
    return _createdAt;
  }
  
  amplify_core.TemporalDateTime? get updatedAt {
    return _updatedAt;
  }
  
  const ChatRoom._internal({required this.id, users, messages, lastMessageContent, lastMessageTime, createdAt, updatedAt}): _users = users, _messages = messages, _lastMessageContent = lastMessageContent, _lastMessageTime = lastMessageTime, _createdAt = createdAt, _updatedAt = updatedAt;
  
  factory ChatRoom({String? id, List<ChatRoomUser>? users, List<Message>? messages, String? lastMessageContent, amplify_core.TemporalDateTime? lastMessageTime}) {
    return ChatRoom._internal(
      id: id == null ? amplify_core.UUID.getUUID() : id,
      users: users != null ? List<ChatRoomUser>.unmodifiable(users) : users,
      messages: messages != null ? List<Message>.unmodifiable(messages) : messages,
      lastMessageContent: lastMessageContent,
      lastMessageTime: lastMessageTime);
  }
  
  bool equals(Object other) {
    return this == other;
  }
  
  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ChatRoom &&
      id == other.id &&
      DeepCollectionEquality().equals(_users, other._users) &&
      DeepCollectionEquality().equals(_messages, other._messages) &&
      _lastMessageContent == other._lastMessageContent &&
      _lastMessageTime == other._lastMessageTime;
  }
  
  @override
  int get hashCode => toString().hashCode;
  
  @override
  String toString() {
    var buffer = new StringBuffer();
    
    buffer.write("ChatRoom {");
    buffer.write("id=" + "$id" + ", ");
    buffer.write("lastMessageContent=" + "$_lastMessageContent" + ", ");
    buffer.write("lastMessageTime=" + (_lastMessageTime != null ? _lastMessageTime!.format() : "null") + ", ");
    buffer.write("createdAt=" + (_createdAt != null ? _createdAt!.format() : "null") + ", ");
    buffer.write("updatedAt=" + (_updatedAt != null ? _updatedAt!.format() : "null"));
    buffer.write("}");
    
    return buffer.toString();
  }
  
  ChatRoom copyWith({List<ChatRoomUser>? users, List<Message>? messages, String? lastMessageContent, amplify_core.TemporalDateTime? lastMessageTime}) {
    return ChatRoom._internal(
      id: id,
      users: users ?? this.users,
      messages: messages ?? this.messages,
      lastMessageContent: lastMessageContent ?? this.lastMessageContent,
      lastMessageTime: lastMessageTime ?? this.lastMessageTime);
  }
  
  ChatRoom copyWithModelFieldValues({
    ModelFieldValue<List<ChatRoomUser>?>? users,
    ModelFieldValue<List<Message>?>? messages,
    ModelFieldValue<String?>? lastMessageContent,
    ModelFieldValue<amplify_core.TemporalDateTime?>? lastMessageTime
  }) {
    return ChatRoom._internal(
      id: id,
      users: users == null ? this.users : users.value,
      messages: messages == null ? this.messages : messages.value,
      lastMessageContent: lastMessageContent == null ? this.lastMessageContent : lastMessageContent.value,
      lastMessageTime: lastMessageTime == null ? this.lastMessageTime : lastMessageTime.value
    );
  }
  
  ChatRoom.fromJson(Map<String, dynamic> json)  
    : id = json['id'],
      _users = json['users']  is Map
        ? (json['users']['items'] is List
          ? (json['users']['items'] as List)
              .where((e) => e != null)
              .map((e) => ChatRoomUser.fromJson(new Map<String, dynamic>.from(e)))
              .toList()
          : null)
        : (json['users'] is List
          ? (json['users'] as List)
              .where((e) => e?['serializedData'] != null)
              .map((e) => ChatRoomUser.fromJson(new Map<String, dynamic>.from(e?['serializedData'])))
              .toList()
          : null),
      _messages = json['messages']  is Map
        ? (json['messages']['items'] is List
          ? (json['messages']['items'] as List)
              .where((e) => e != null)
              .map((e) => Message.fromJson(new Map<String, dynamic>.from(e)))
              .toList()
          : null)
        : (json['messages'] is List
          ? (json['messages'] as List)
              .where((e) => e?['serializedData'] != null)
              .map((e) => Message.fromJson(new Map<String, dynamic>.from(e?['serializedData'])))
              .toList()
          : null),
      _lastMessageContent = json['lastMessageContent'],
      _lastMessageTime = json['lastMessageTime'] != null ? amplify_core.TemporalDateTime.fromString(json['lastMessageTime']) : null,
      _createdAt = json['createdAt'] != null ? amplify_core.TemporalDateTime.fromString(json['createdAt']) : null,
      _updatedAt = json['updatedAt'] != null ? amplify_core.TemporalDateTime.fromString(json['updatedAt']) : null;
  
  Map<String, dynamic> toJson() => {
    'id': id, 'users': _users?.map((ChatRoomUser? e) => e?.toJson()).toList(), 'messages': _messages?.map((Message? e) => e?.toJson()).toList(), 'lastMessageContent': _lastMessageContent, 'lastMessageTime': _lastMessageTime?.format(), 'createdAt': _createdAt?.format(), 'updatedAt': _updatedAt?.format()
  };
  
  Map<String, Object?> toMap() => {
    'id': id,
    'users': _users,
    'messages': _messages,
    'lastMessageContent': _lastMessageContent,
    'lastMessageTime': _lastMessageTime,
    'createdAt': _createdAt,
    'updatedAt': _updatedAt
  };

  static final amplify_core.QueryModelIdentifier<ChatRoomModelIdentifier> MODEL_IDENTIFIER = amplify_core.QueryModelIdentifier<ChatRoomModelIdentifier>();
  static final ID = amplify_core.QueryField(fieldName: "id");
  static final USERS = amplify_core.QueryField(
    fieldName: "users",
    fieldType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.model, ofModelName: 'ChatRoomUser'));
  static final MESSAGES = amplify_core.QueryField(
    fieldName: "messages",
    fieldType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.model, ofModelName: 'Message'));
  static final LASTMESSAGECONTENT = amplify_core.QueryField(fieldName: "lastMessageContent");
  static final LASTMESSAGETIME = amplify_core.QueryField(fieldName: "lastMessageTime");
  static var schema = amplify_core.Model.defineSchema(define: (amplify_core.ModelSchemaDefinition modelSchemaDefinition) {
    modelSchemaDefinition.name = "ChatRoom";
    modelSchemaDefinition.pluralName = "ChatRooms";
    
    modelSchemaDefinition.authRules = [
      amplify_core.AuthRule(
        authStrategy: amplify_core.AuthStrategy.PRIVATE,
        operations: const [
          amplify_core.ModelOperation.CREATE,
          amplify_core.ModelOperation.UPDATE,
          amplify_core.ModelOperation.DELETE,
          amplify_core.ModelOperation.READ
        ])
    ];
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.id());
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.hasMany(
      key: ChatRoom.USERS,
      isRequired: false,
      ofModelName: 'ChatRoomUser',
      associatedKey: ChatRoomUser.CHATROOM
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.hasMany(
      key: ChatRoom.MESSAGES,
      isRequired: false,
      ofModelName: 'Message',
      associatedKey: Message.CHATROOMID
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: ChatRoom.LASTMESSAGECONTENT,
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: ChatRoom.LASTMESSAGETIME,
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.dateTime)
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

class _ChatRoomModelType extends amplify_core.ModelType<ChatRoom> {
  const _ChatRoomModelType();
  
  @override
  ChatRoom fromJson(Map<String, dynamic> jsonData) {
    return ChatRoom.fromJson(jsonData);
  }
  
  @override
  String modelName() {
    return 'ChatRoom';
  }
}

/**
 * This is an auto generated class representing the model identifier
 * of [ChatRoom] in your schema.
 */
class ChatRoomModelIdentifier implements amplify_core.ModelIdentifier<ChatRoom> {
  final String id;

  /** Create an instance of ChatRoomModelIdentifier using [id] the primary key. */
  const ChatRoomModelIdentifier({
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
  String toString() => 'ChatRoomModelIdentifier(id: $id)';
  
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    
    return other is ChatRoomModelIdentifier &&
      id == other.id;
  }
  
  @override
  int get hashCode =>
    id.hashCode;
}