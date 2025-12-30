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


/** This is an auto generated class representing the ChatRoomUser type in your schema. */
class ChatRoomUser extends amplify_core.Model {
  static const classType = const _ChatRoomUserModelType();
  final String id;
  final UserProfile? _user;
  final ChatRoom? _chatRoom;
  final int? _unreadCount;
  final amplify_core.TemporalDateTime? _createdAt;
  final amplify_core.TemporalDateTime? _updatedAt;

  @override
  getInstanceType() => classType;
  
  @Deprecated('[getId] is being deprecated in favor of custom primary key feature. Use getter [modelIdentifier] to get model identifier.')
  @override
  String getId() => id;
  
  ChatRoomUserModelIdentifier get modelIdentifier {
      return ChatRoomUserModelIdentifier(
        id: id
      );
  }
  
  UserProfile? get user {
    return _user;
  }
  
  ChatRoom? get chatRoom {
    return _chatRoom;
  }
  
  int? get unreadCount {
    return _unreadCount;
  }
  
  amplify_core.TemporalDateTime? get createdAt {
    return _createdAt;
  }
  
  amplify_core.TemporalDateTime? get updatedAt {
    return _updatedAt;
  }
  
  const ChatRoomUser._internal({required this.id, user, chatRoom, unreadCount, createdAt, updatedAt}): _user = user, _chatRoom = chatRoom, _unreadCount = unreadCount, _createdAt = createdAt, _updatedAt = updatedAt;
  
  factory ChatRoomUser({String? id, UserProfile? user, ChatRoom? chatRoom, int? unreadCount}) {
    return ChatRoomUser._internal(
      id: id == null ? amplify_core.UUID.getUUID() : id,
      user: user,
      chatRoom: chatRoom,
      unreadCount: unreadCount);
  }
  
  bool equals(Object other) {
    return this == other;
  }
  
  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is ChatRoomUser &&
      id == other.id &&
      _user == other._user &&
      _chatRoom == other._chatRoom &&
      _unreadCount == other._unreadCount;
  }
  
  @override
  int get hashCode => toString().hashCode;
  
  @override
  String toString() {
    var buffer = new StringBuffer();
    
    buffer.write("ChatRoomUser {");
    buffer.write("id=" + "$id" + ", ");
    buffer.write("user=" + (_user != null ? _user!.toString() : "null") + ", ");
    buffer.write("chatRoom=" + (_chatRoom != null ? _chatRoom!.toString() : "null") + ", ");
    buffer.write("unreadCount=" + (_unreadCount != null ? _unreadCount!.toString() : "null") + ", ");
    buffer.write("createdAt=" + (_createdAt != null ? _createdAt!.format() : "null") + ", ");
    buffer.write("updatedAt=" + (_updatedAt != null ? _updatedAt!.format() : "null"));
    buffer.write("}");
    
    return buffer.toString();
  }
  
  ChatRoomUser copyWith({UserProfile? user, ChatRoom? chatRoom, int? unreadCount}) {
    return ChatRoomUser._internal(
      id: id,
      user: user ?? this.user,
      chatRoom: chatRoom ?? this.chatRoom,
      unreadCount: unreadCount ?? this.unreadCount);
  }
  
  ChatRoomUser copyWithModelFieldValues({
    ModelFieldValue<UserProfile?>? user,
    ModelFieldValue<ChatRoom?>? chatRoom,
    ModelFieldValue<int?>? unreadCount
  }) {
    return ChatRoomUser._internal(
      id: id,
      user: user == null ? this.user : user.value,
      chatRoom: chatRoom == null ? this.chatRoom : chatRoom.value,
      unreadCount: unreadCount == null ? this.unreadCount : unreadCount.value
    );
  }
  
  ChatRoomUser.fromJson(Map<String, dynamic> json)  
    : id = json['id'],
      _user = json['user'] != null
        ? json['user']['serializedData'] != null
          ? UserProfile.fromJson(new Map<String, dynamic>.from(json['user']['serializedData']))
          : UserProfile.fromJson(new Map<String, dynamic>.from(json['user']))
        : null,
      _chatRoom = json['chatRoom'] != null
        ? json['chatRoom']['serializedData'] != null
          ? ChatRoom.fromJson(new Map<String, dynamic>.from(json['chatRoom']['serializedData']))
          : ChatRoom.fromJson(new Map<String, dynamic>.from(json['chatRoom']))
        : null,
      _unreadCount = (json['unreadCount'] as num?)?.toInt(),
      _createdAt = json['createdAt'] != null ? amplify_core.TemporalDateTime.fromString(json['createdAt']) : null,
      _updatedAt = json['updatedAt'] != null ? amplify_core.TemporalDateTime.fromString(json['updatedAt']) : null;
  
  Map<String, dynamic> toJson() => {
    'id': id, 'user': _user?.toJson(), 'chatRoom': _chatRoom?.toJson(), 'unreadCount': _unreadCount, 'createdAt': _createdAt?.format(), 'updatedAt': _updatedAt?.format()
  };
  
  Map<String, Object?> toMap() => {
    'id': id,
    'user': _user,
    'chatRoom': _chatRoom,
    'unreadCount': _unreadCount,
    'createdAt': _createdAt,
    'updatedAt': _updatedAt
  };

  static final amplify_core.QueryModelIdentifier<ChatRoomUserModelIdentifier> MODEL_IDENTIFIER = amplify_core.QueryModelIdentifier<ChatRoomUserModelIdentifier>();
  static final ID = amplify_core.QueryField(fieldName: "id");
  static final USER = amplify_core.QueryField(
    fieldName: "user",
    fieldType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.model, ofModelName: 'UserProfile'));
  static final CHATROOM = amplify_core.QueryField(
    fieldName: "chatRoom",
    fieldType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.model, ofModelName: 'ChatRoom'));
  static final UNREADCOUNT = amplify_core.QueryField(fieldName: "unreadCount");
  static var schema = amplify_core.Model.defineSchema(define: (amplify_core.ModelSchemaDefinition modelSchemaDefinition) {
    modelSchemaDefinition.name = "ChatRoomUser";
    modelSchemaDefinition.pluralName = "ChatRoomUsers";
    
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
    
    modelSchemaDefinition.indexes = [
      amplify_core.ModelIndex(fields: const ["userID"], name: "byUser"),
      amplify_core.ModelIndex(fields: const ["chatRoomID"], name: "byChatRoom")
    ];
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.id());
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.belongsTo(
      key: ChatRoomUser.USER,
      isRequired: false,
      targetNames: ['userID'],
      ofModelName: 'UserProfile'
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.belongsTo(
      key: ChatRoomUser.CHATROOM,
      isRequired: false,
      targetNames: ['chatRoomID'],
      ofModelName: 'ChatRoom'
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: ChatRoomUser.UNREADCOUNT,
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.int)
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

class _ChatRoomUserModelType extends amplify_core.ModelType<ChatRoomUser> {
  const _ChatRoomUserModelType();
  
  @override
  ChatRoomUser fromJson(Map<String, dynamic> jsonData) {
    return ChatRoomUser.fromJson(jsonData);
  }
  
  @override
  String modelName() {
    return 'ChatRoomUser';
  }
}

/**
 * This is an auto generated class representing the model identifier
 * of [ChatRoomUser] in your schema.
 */
class ChatRoomUserModelIdentifier implements amplify_core.ModelIdentifier<ChatRoomUser> {
  final String id;

  /** Create an instance of ChatRoomUserModelIdentifier using [id] the primary key. */
  const ChatRoomUserModelIdentifier({
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
  String toString() => 'ChatRoomUserModelIdentifier(id: $id)';
  
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    
    return other is ChatRoomUserModelIdentifier &&
      id == other.id;
  }
  
  @override
  int get hashCode =>
    id.hashCode;
}