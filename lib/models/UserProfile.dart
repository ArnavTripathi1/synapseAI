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


/** This is an auto generated class representing the UserProfile type in your schema. */
class UserProfile extends amplify_core.Model {
  static const classType = const _UserProfileModelType();
  final String id;
  final String? _name;
  final UserRole? _role;
  final String? _imageUrl;
  final String? _phoneNumber;
  final StudentProfile? _studentProfile;
  final CounselorProfile? _counselorProfile;
  final List<ChatRoomUser>? _chatRooms;
  final amplify_core.TemporalDateTime? _createdAt;
  final amplify_core.TemporalDateTime? _updatedAt;
  final String? _userProfileStudentProfileId;
  final String? _userProfileCounselorProfileId;

  @override
  getInstanceType() => classType;
  
  @Deprecated('[getId] is being deprecated in favor of custom primary key feature. Use getter [modelIdentifier] to get model identifier.')
  @override
  String getId() => id;
  
  UserProfileModelIdentifier get modelIdentifier {
      return UserProfileModelIdentifier(
        id: id
      );
  }
  
  String get name {
    try {
      return _name!;
    } catch(e) {
      throw amplify_core.AmplifyCodeGenModelException(
          amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastExceptionMessage,
          recoverySuggestion:
            amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastRecoverySuggestion,
          underlyingException: e.toString()
          );
    }
  }
  
  UserRole get role {
    try {
      return _role!;
    } catch(e) {
      throw amplify_core.AmplifyCodeGenModelException(
          amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastExceptionMessage,
          recoverySuggestion:
            amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastRecoverySuggestion,
          underlyingException: e.toString()
          );
    }
  }
  
  String? get imageUrl {
    return _imageUrl;
  }
  
  String? get phoneNumber {
    return _phoneNumber;
  }
  
  StudentProfile? get studentProfile {
    return _studentProfile;
  }
  
  CounselorProfile? get counselorProfile {
    return _counselorProfile;
  }
  
  List<ChatRoomUser>? get chatRooms {
    return _chatRooms;
  }
  
  amplify_core.TemporalDateTime? get createdAt {
    return _createdAt;
  }
  
  amplify_core.TemporalDateTime? get updatedAt {
    return _updatedAt;
  }
  
  String? get userProfileStudentProfileId {
    return _userProfileStudentProfileId;
  }
  
  String? get userProfileCounselorProfileId {
    return _userProfileCounselorProfileId;
  }
  
  const UserProfile._internal({required this.id, required name, required role, imageUrl, phoneNumber, studentProfile, counselorProfile, chatRooms, createdAt, updatedAt, userProfileStudentProfileId, userProfileCounselorProfileId}): _name = name, _role = role, _imageUrl = imageUrl, _phoneNumber = phoneNumber, _studentProfile = studentProfile, _counselorProfile = counselorProfile, _chatRooms = chatRooms, _createdAt = createdAt, _updatedAt = updatedAt, _userProfileStudentProfileId = userProfileStudentProfileId, _userProfileCounselorProfileId = userProfileCounselorProfileId;
  
  factory UserProfile({String? id, required String name, required UserRole role, String? imageUrl, String? phoneNumber, StudentProfile? studentProfile, CounselorProfile? counselorProfile, List<ChatRoomUser>? chatRooms, String? userProfileStudentProfileId, String? userProfileCounselorProfileId}) {
    return UserProfile._internal(
      id: id == null ? amplify_core.UUID.getUUID() : id,
      name: name,
      role: role,
      imageUrl: imageUrl,
      phoneNumber: phoneNumber,
      studentProfile: studentProfile,
      counselorProfile: counselorProfile,
      chatRooms: chatRooms != null ? List<ChatRoomUser>.unmodifiable(chatRooms) : chatRooms,
      userProfileStudentProfileId: userProfileStudentProfileId,
      userProfileCounselorProfileId: userProfileCounselorProfileId);
  }
  
  bool equals(Object other) {
    return this == other;
  }
  
  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is UserProfile &&
      id == other.id &&
      _name == other._name &&
      _role == other._role &&
      _imageUrl == other._imageUrl &&
      _phoneNumber == other._phoneNumber &&
      _studentProfile == other._studentProfile &&
      _counselorProfile == other._counselorProfile &&
      DeepCollectionEquality().equals(_chatRooms, other._chatRooms) &&
      _userProfileStudentProfileId == other._userProfileStudentProfileId &&
      _userProfileCounselorProfileId == other._userProfileCounselorProfileId;
  }
  
  @override
  int get hashCode => toString().hashCode;
  
  @override
  String toString() {
    var buffer = new StringBuffer();
    
    buffer.write("UserProfile {");
    buffer.write("id=" + "$id" + ", ");
    buffer.write("name=" + "$_name" + ", ");
    buffer.write("role=" + (_role != null ? amplify_core.enumToString(_role)! : "null") + ", ");
    buffer.write("imageUrl=" + "$_imageUrl" + ", ");
    buffer.write("phoneNumber=" + "$_phoneNumber" + ", ");
    buffer.write("createdAt=" + (_createdAt != null ? _createdAt!.format() : "null") + ", ");
    buffer.write("updatedAt=" + (_updatedAt != null ? _updatedAt!.format() : "null") + ", ");
    buffer.write("userProfileStudentProfileId=" + "$_userProfileStudentProfileId" + ", ");
    buffer.write("userProfileCounselorProfileId=" + "$_userProfileCounselorProfileId");
    buffer.write("}");
    
    return buffer.toString();
  }
  
  UserProfile copyWith({String? name, UserRole? role, String? imageUrl, String? phoneNumber, StudentProfile? studentProfile, CounselorProfile? counselorProfile, List<ChatRoomUser>? chatRooms, String? userProfileStudentProfileId, String? userProfileCounselorProfileId}) {
    return UserProfile._internal(
      id: id,
      name: name ?? this.name,
      role: role ?? this.role,
      imageUrl: imageUrl ?? this.imageUrl,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      studentProfile: studentProfile ?? this.studentProfile,
      counselorProfile: counselorProfile ?? this.counselorProfile,
      chatRooms: chatRooms ?? this.chatRooms,
      userProfileStudentProfileId: userProfileStudentProfileId ?? this.userProfileStudentProfileId,
      userProfileCounselorProfileId: userProfileCounselorProfileId ?? this.userProfileCounselorProfileId);
  }
  
  UserProfile copyWithModelFieldValues({
    ModelFieldValue<String>? name,
    ModelFieldValue<UserRole>? role,
    ModelFieldValue<String?>? imageUrl,
    ModelFieldValue<String?>? phoneNumber,
    ModelFieldValue<StudentProfile?>? studentProfile,
    ModelFieldValue<CounselorProfile?>? counselorProfile,
    ModelFieldValue<List<ChatRoomUser>?>? chatRooms,
    ModelFieldValue<String?>? userProfileStudentProfileId,
    ModelFieldValue<String?>? userProfileCounselorProfileId
  }) {
    return UserProfile._internal(
      id: id,
      name: name == null ? this.name : name.value,
      role: role == null ? this.role : role.value,
      imageUrl: imageUrl == null ? this.imageUrl : imageUrl.value,
      phoneNumber: phoneNumber == null ? this.phoneNumber : phoneNumber.value,
      studentProfile: studentProfile == null ? this.studentProfile : studentProfile.value,
      counselorProfile: counselorProfile == null ? this.counselorProfile : counselorProfile.value,
      chatRooms: chatRooms == null ? this.chatRooms : chatRooms.value,
      userProfileStudentProfileId: userProfileStudentProfileId == null ? this.userProfileStudentProfileId : userProfileStudentProfileId.value,
      userProfileCounselorProfileId: userProfileCounselorProfileId == null ? this.userProfileCounselorProfileId : userProfileCounselorProfileId.value
    );
  }
  
  UserProfile.fromJson(Map<String, dynamic> json)  
    : id = json['id'],
      _name = json['name'],
      _role = amplify_core.enumFromString<UserRole>(json['role'], UserRole.values),
      _imageUrl = json['imageUrl'],
      _phoneNumber = json['phoneNumber'],
      _studentProfile = json['studentProfile'] != null
        ? json['studentProfile']['serializedData'] != null
          ? StudentProfile.fromJson(new Map<String, dynamic>.from(json['studentProfile']['serializedData']))
          : StudentProfile.fromJson(new Map<String, dynamic>.from(json['studentProfile']))
        : null,
      _counselorProfile = json['counselorProfile'] != null
        ? json['counselorProfile']['serializedData'] != null
          ? CounselorProfile.fromJson(new Map<String, dynamic>.from(json['counselorProfile']['serializedData']))
          : CounselorProfile.fromJson(new Map<String, dynamic>.from(json['counselorProfile']))
        : null,
      _chatRooms = json['chatRooms']  is Map
        ? (json['chatRooms']['items'] is List
          ? (json['chatRooms']['items'] as List)
              .where((e) => e != null)
              .map((e) => ChatRoomUser.fromJson(new Map<String, dynamic>.from(e)))
              .toList()
          : null)
        : (json['chatRooms'] is List
          ? (json['chatRooms'] as List)
              .where((e) => e?['serializedData'] != null)
              .map((e) => ChatRoomUser.fromJson(new Map<String, dynamic>.from(e?['serializedData'])))
              .toList()
          : null),
      _createdAt = json['createdAt'] != null ? amplify_core.TemporalDateTime.fromString(json['createdAt']) : null,
      _updatedAt = json['updatedAt'] != null ? amplify_core.TemporalDateTime.fromString(json['updatedAt']) : null,
      _userProfileStudentProfileId = json['userProfileStudentProfileId'],
      _userProfileCounselorProfileId = json['userProfileCounselorProfileId'];
  
  Map<String, dynamic> toJson() => {
    'id': id, 'name': _name, 'role': amplify_core.enumToString(_role), 'imageUrl': _imageUrl, 'phoneNumber': _phoneNumber, 'studentProfile': _studentProfile?.toJson(), 'counselorProfile': _counselorProfile?.toJson(), 'chatRooms': _chatRooms?.map((ChatRoomUser? e) => e?.toJson()).toList(), 'createdAt': _createdAt?.format(), 'updatedAt': _updatedAt?.format(), 'userProfileStudentProfileId': _userProfileStudentProfileId, 'userProfileCounselorProfileId': _userProfileCounselorProfileId
  };
  
  Map<String, Object?> toMap() => {
    'id': id,
    'name': _name,
    'role': _role,
    'imageUrl': _imageUrl,
    'phoneNumber': _phoneNumber,
    'studentProfile': _studentProfile,
    'counselorProfile': _counselorProfile,
    'chatRooms': _chatRooms,
    'createdAt': _createdAt,
    'updatedAt': _updatedAt,
    'userProfileStudentProfileId': _userProfileStudentProfileId,
    'userProfileCounselorProfileId': _userProfileCounselorProfileId
  };

  static final amplify_core.QueryModelIdentifier<UserProfileModelIdentifier> MODEL_IDENTIFIER = amplify_core.QueryModelIdentifier<UserProfileModelIdentifier>();
  static final ID = amplify_core.QueryField(fieldName: "id");
  static final NAME = amplify_core.QueryField(fieldName: "name");
  static final ROLE = amplify_core.QueryField(fieldName: "role");
  static final IMAGEURL = amplify_core.QueryField(fieldName: "imageUrl");
  static final PHONENUMBER = amplify_core.QueryField(fieldName: "phoneNumber");
  static final STUDENTPROFILE = amplify_core.QueryField(
    fieldName: "studentProfile",
    fieldType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.model, ofModelName: 'StudentProfile'));
  static final COUNSELORPROFILE = amplify_core.QueryField(
    fieldName: "counselorProfile",
    fieldType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.model, ofModelName: 'CounselorProfile'));
  static final CHATROOMS = amplify_core.QueryField(
    fieldName: "chatRooms",
    fieldType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.model, ofModelName: 'ChatRoomUser'));
  static final USERPROFILESTUDENTPROFILEID = amplify_core.QueryField(fieldName: "userProfileStudentProfileId");
  static final USERPROFILECOUNSELORPROFILEID = amplify_core.QueryField(fieldName: "userProfileCounselorProfileId");
  static var schema = amplify_core.Model.defineSchema(define: (amplify_core.ModelSchemaDefinition modelSchemaDefinition) {
    modelSchemaDefinition.name = "UserProfile";
    modelSchemaDefinition.pluralName = "UserProfiles";
    
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
      key: UserProfile.NAME,
      isRequired: true,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: UserProfile.ROLE,
      isRequired: true,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.enumeration)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: UserProfile.IMAGEURL,
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: UserProfile.PHONENUMBER,
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.hasOne(
      key: UserProfile.STUDENTPROFILE,
      isRequired: false,
      ofModelName: 'StudentProfile',
      associatedKey: StudentProfile.ID
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.hasOne(
      key: UserProfile.COUNSELORPROFILE,
      isRequired: false,
      ofModelName: 'CounselorProfile',
      associatedKey: CounselorProfile.ID
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.hasMany(
      key: UserProfile.CHATROOMS,
      isRequired: false,
      ofModelName: 'ChatRoomUser',
      associatedKey: ChatRoomUser.USER
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
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: UserProfile.USERPROFILESTUDENTPROFILEID,
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: UserProfile.USERPROFILECOUNSELORPROFILEID,
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
  });
}

class _UserProfileModelType extends amplify_core.ModelType<UserProfile> {
  const _UserProfileModelType();
  
  @override
  UserProfile fromJson(Map<String, dynamic> jsonData) {
    return UserProfile.fromJson(jsonData);
  }
  
  @override
  String modelName() {
    return 'UserProfile';
  }
}

/**
 * This is an auto generated class representing the model identifier
 * of [UserProfile] in your schema.
 */
class UserProfileModelIdentifier implements amplify_core.ModelIdentifier<UserProfile> {
  final String id;

  /** Create an instance of UserProfileModelIdentifier using [id] the primary key. */
  const UserProfileModelIdentifier({
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
  String toString() => 'UserProfileModelIdentifier(id: $id)';
  
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    
    return other is UserProfileModelIdentifier &&
      id == other.id;
  }
  
  @override
  int get hashCode =>
    id.hashCode;
}