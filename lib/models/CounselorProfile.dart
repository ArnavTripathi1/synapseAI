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


/** This is an auto generated class representing the CounselorProfile type in your schema. */
class CounselorProfile extends amplify_core.Model {
  static const classType = const _CounselorProfileModelType();
  final String id;
  final String? _userProfileID;
  final String? _specialization;
  final int? _experienceYears;
  final double? _rating;
  final String? _aboutMe;
  final List<String>? _languages;
  final String? _licenseNumber;
  final double? _fee;
  final bool? _isVerified;
  final bool? _isOnline;
  final List<Appointment>? _appointments;
  final amplify_core.TemporalDateTime? _createdAt;
  final amplify_core.TemporalDateTime? _updatedAt;

  @override
  getInstanceType() => classType;
  
  @Deprecated('[getId] is being deprecated in favor of custom primary key feature. Use getter [modelIdentifier] to get model identifier.')
  @override
  String getId() => id;
  
  CounselorProfileModelIdentifier get modelIdentifier {
      return CounselorProfileModelIdentifier(
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
  
  String get specialization {
    try {
      return _specialization!;
    } catch(e) {
      throw amplify_core.AmplifyCodeGenModelException(
          amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastExceptionMessage,
          recoverySuggestion:
            amplify_core.AmplifyExceptionMessages.codeGenRequiredFieldForceCastRecoverySuggestion,
          underlyingException: e.toString()
          );
    }
  }
  
  int? get experienceYears {
    return _experienceYears;
  }
  
  double? get rating {
    return _rating;
  }
  
  String? get aboutMe {
    return _aboutMe;
  }
  
  List<String>? get languages {
    return _languages;
  }
  
  String? get licenseNumber {
    return _licenseNumber;
  }
  
  double? get fee {
    return _fee;
  }
  
  bool? get isVerified {
    return _isVerified;
  }
  
  bool? get isOnline {
    return _isOnline;
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
  
  const CounselorProfile._internal({required this.id, required userProfileID, required specialization, experienceYears, rating, aboutMe, languages, licenseNumber, fee, isVerified, isOnline, appointments, createdAt, updatedAt}): _userProfileID = userProfileID, _specialization = specialization, _experienceYears = experienceYears, _rating = rating, _aboutMe = aboutMe, _languages = languages, _licenseNumber = licenseNumber, _fee = fee, _isVerified = isVerified, _isOnline = isOnline, _appointments = appointments, _createdAt = createdAt, _updatedAt = updatedAt;
  
  factory CounselorProfile({String? id, required String userProfileID, required String specialization, int? experienceYears, double? rating, String? aboutMe, List<String>? languages, String? licenseNumber, double? fee, bool? isVerified, bool? isOnline, List<Appointment>? appointments}) {
    return CounselorProfile._internal(
      id: id == null ? amplify_core.UUID.getUUID() : id,
      userProfileID: userProfileID,
      specialization: specialization,
      experienceYears: experienceYears,
      rating: rating,
      aboutMe: aboutMe,
      languages: languages != null ? List<String>.unmodifiable(languages) : languages,
      licenseNumber: licenseNumber,
      fee: fee,
      isVerified: isVerified,
      isOnline: isOnline,
      appointments: appointments != null ? List<Appointment>.unmodifiable(appointments) : appointments);
  }
  
  bool equals(Object other) {
    return this == other;
  }
  
  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is CounselorProfile &&
      id == other.id &&
      _userProfileID == other._userProfileID &&
      _specialization == other._specialization &&
      _experienceYears == other._experienceYears &&
      _rating == other._rating &&
      _aboutMe == other._aboutMe &&
      DeepCollectionEquality().equals(_languages, other._languages) &&
      _licenseNumber == other._licenseNumber &&
      _fee == other._fee &&
      _isVerified == other._isVerified &&
      _isOnline == other._isOnline &&
      DeepCollectionEquality().equals(_appointments, other._appointments);
  }
  
  @override
  int get hashCode => toString().hashCode;
  
  @override
  String toString() {
    var buffer = new StringBuffer();
    
    buffer.write("CounselorProfile {");
    buffer.write("id=" + "$id" + ", ");
    buffer.write("userProfileID=" + "$_userProfileID" + ", ");
    buffer.write("specialization=" + "$_specialization" + ", ");
    buffer.write("experienceYears=" + (_experienceYears != null ? _experienceYears!.toString() : "null") + ", ");
    buffer.write("rating=" + (_rating != null ? _rating!.toString() : "null") + ", ");
    buffer.write("aboutMe=" + "$_aboutMe" + ", ");
    buffer.write("languages=" + (_languages != null ? _languages!.toString() : "null") + ", ");
    buffer.write("licenseNumber=" + "$_licenseNumber" + ", ");
    buffer.write("fee=" + (_fee != null ? _fee!.toString() : "null") + ", ");
    buffer.write("isVerified=" + (_isVerified != null ? _isVerified!.toString() : "null") + ", ");
    buffer.write("isOnline=" + (_isOnline != null ? _isOnline!.toString() : "null") + ", ");
    buffer.write("createdAt=" + (_createdAt != null ? _createdAt!.format() : "null") + ", ");
    buffer.write("updatedAt=" + (_updatedAt != null ? _updatedAt!.format() : "null"));
    buffer.write("}");
    
    return buffer.toString();
  }
  
  CounselorProfile copyWith({String? userProfileID, String? specialization, int? experienceYears, double? rating, String? aboutMe, List<String>? languages, String? licenseNumber, double? fee, bool? isVerified, bool? isOnline, List<Appointment>? appointments}) {
    return CounselorProfile._internal(
      id: id,
      userProfileID: userProfileID ?? this.userProfileID,
      specialization: specialization ?? this.specialization,
      experienceYears: experienceYears ?? this.experienceYears,
      rating: rating ?? this.rating,
      aboutMe: aboutMe ?? this.aboutMe,
      languages: languages ?? this.languages,
      licenseNumber: licenseNumber ?? this.licenseNumber,
      fee: fee ?? this.fee,
      isVerified: isVerified ?? this.isVerified,
      isOnline: isOnline ?? this.isOnline,
      appointments: appointments ?? this.appointments);
  }
  
  CounselorProfile copyWithModelFieldValues({
    ModelFieldValue<String>? userProfileID,
    ModelFieldValue<String>? specialization,
    ModelFieldValue<int?>? experienceYears,
    ModelFieldValue<double?>? rating,
    ModelFieldValue<String?>? aboutMe,
    ModelFieldValue<List<String>?>? languages,
    ModelFieldValue<String?>? licenseNumber,
    ModelFieldValue<double?>? fee,
    ModelFieldValue<bool?>? isVerified,
    ModelFieldValue<bool?>? isOnline,
    ModelFieldValue<List<Appointment>?>? appointments
  }) {
    return CounselorProfile._internal(
      id: id,
      userProfileID: userProfileID == null ? this.userProfileID : userProfileID.value,
      specialization: specialization == null ? this.specialization : specialization.value,
      experienceYears: experienceYears == null ? this.experienceYears : experienceYears.value,
      rating: rating == null ? this.rating : rating.value,
      aboutMe: aboutMe == null ? this.aboutMe : aboutMe.value,
      languages: languages == null ? this.languages : languages.value,
      licenseNumber: licenseNumber == null ? this.licenseNumber : licenseNumber.value,
      fee: fee == null ? this.fee : fee.value,
      isVerified: isVerified == null ? this.isVerified : isVerified.value,
      isOnline: isOnline == null ? this.isOnline : isOnline.value,
      appointments: appointments == null ? this.appointments : appointments.value
    );
  }
  
  CounselorProfile.fromJson(Map<String, dynamic> json)  
    : id = json['id'],
      _userProfileID = json['userProfileID'],
      _specialization = json['specialization'],
      _experienceYears = (json['experienceYears'] as num?)?.toInt(),
      _rating = (json['rating'] as num?)?.toDouble(),
      _aboutMe = json['aboutMe'],
      _languages = json['languages']?.cast<String>(),
      _licenseNumber = json['licenseNumber'],
      _fee = (json['fee'] as num?)?.toDouble(),
      _isVerified = json['isVerified'],
      _isOnline = json['isOnline'],
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
    'id': id, 'userProfileID': _userProfileID, 'specialization': _specialization, 'experienceYears': _experienceYears, 'rating': _rating, 'aboutMe': _aboutMe, 'languages': _languages, 'licenseNumber': _licenseNumber, 'fee': _fee, 'isVerified': _isVerified, 'isOnline': _isOnline, 'appointments': _appointments?.map((Appointment? e) => e?.toJson()).toList(), 'createdAt': _createdAt?.format(), 'updatedAt': _updatedAt?.format()
  };
  
  Map<String, Object?> toMap() => {
    'id': id,
    'userProfileID': _userProfileID,
    'specialization': _specialization,
    'experienceYears': _experienceYears,
    'rating': _rating,
    'aboutMe': _aboutMe,
    'languages': _languages,
    'licenseNumber': _licenseNumber,
    'fee': _fee,
    'isVerified': _isVerified,
    'isOnline': _isOnline,
    'appointments': _appointments,
    'createdAt': _createdAt,
    'updatedAt': _updatedAt
  };

  static final amplify_core.QueryModelIdentifier<CounselorProfileModelIdentifier> MODEL_IDENTIFIER = amplify_core.QueryModelIdentifier<CounselorProfileModelIdentifier>();
  static final ID = amplify_core.QueryField(fieldName: "id");
  static final USERPROFILEID = amplify_core.QueryField(fieldName: "userProfileID");
  static final SPECIALIZATION = amplify_core.QueryField(fieldName: "specialization");
  static final EXPERIENCEYEARS = amplify_core.QueryField(fieldName: "experienceYears");
  static final RATING = amplify_core.QueryField(fieldName: "rating");
  static final ABOUTME = amplify_core.QueryField(fieldName: "aboutMe");
  static final LANGUAGES = amplify_core.QueryField(fieldName: "languages");
  static final LICENSENUMBER = amplify_core.QueryField(fieldName: "licenseNumber");
  static final FEE = amplify_core.QueryField(fieldName: "fee");
  static final ISVERIFIED = amplify_core.QueryField(fieldName: "isVerified");
  static final ISONLINE = amplify_core.QueryField(fieldName: "isOnline");
  static final APPOINTMENTS = amplify_core.QueryField(
    fieldName: "appointments",
    fieldType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.model, ofModelName: 'Appointment'));
  static var schema = amplify_core.Model.defineSchema(define: (amplify_core.ModelSchemaDefinition modelSchemaDefinition) {
    modelSchemaDefinition.name = "CounselorProfile";
    modelSchemaDefinition.pluralName = "CounselorProfiles";
    
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
      key: CounselorProfile.USERPROFILEID,
      isRequired: true,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: CounselorProfile.SPECIALIZATION,
      isRequired: true,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: CounselorProfile.EXPERIENCEYEARS,
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.int)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: CounselorProfile.RATING,
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.double)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: CounselorProfile.ABOUTME,
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: CounselorProfile.LANGUAGES,
      isRequired: false,
      isArray: true,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.collection, ofModelName: amplify_core.ModelFieldTypeEnum.string.name)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: CounselorProfile.LICENSENUMBER,
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: CounselorProfile.FEE,
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.double)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: CounselorProfile.ISVERIFIED,
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.bool)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.field(
      key: CounselorProfile.ISONLINE,
      isRequired: false,
      ofType: amplify_core.ModelFieldType(amplify_core.ModelFieldTypeEnum.bool)
    ));
    
    modelSchemaDefinition.addField(amplify_core.ModelFieldDefinition.hasMany(
      key: CounselorProfile.APPOINTMENTS,
      isRequired: false,
      ofModelName: 'Appointment',
      associatedKey: Appointment.COUNSELORID
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

class _CounselorProfileModelType extends amplify_core.ModelType<CounselorProfile> {
  const _CounselorProfileModelType();
  
  @override
  CounselorProfile fromJson(Map<String, dynamic> jsonData) {
    return CounselorProfile.fromJson(jsonData);
  }
  
  @override
  String modelName() {
    return 'CounselorProfile';
  }
}

/**
 * This is an auto generated class representing the model identifier
 * of [CounselorProfile] in your schema.
 */
class CounselorProfileModelIdentifier implements amplify_core.ModelIdentifier<CounselorProfile> {
  final String id;

  /** Create an instance of CounselorProfileModelIdentifier using [id] the primary key. */
  const CounselorProfileModelIdentifier({
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
  String toString() => 'CounselorProfileModelIdentifier(id: $id)';
  
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) {
      return true;
    }
    
    return other is CounselorProfileModelIdentifier &&
      id == other.id;
  }
  
  @override
  int get hashCode =>
    id.hashCode;
}