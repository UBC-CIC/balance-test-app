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

// ignore_for_file: public_member_api_docs, annotate_overrides, dead_code, dead_codepublic_member_api_docs, depend_on_referenced_packages, file_names, library_private_types_in_public_api, no_leading_underscores_for_library_prefixes, no_leading_underscores_for_local_identifiers, non_constant_identifier_names, null_check_on_nullable_type_parameter, prefer_adjacent_string_concatenation, prefer_const_constructors, prefer_if_null_operators, prefer_interpolation_to_compose_strings, slash_for_doc_comments, sort_child_properties_last, unnecessary_const, unnecessary_constructor_name, unnecessary_late, unnecessary_new, unnecessary_null_aware_assignments, unnecessary_nullable_for_final_variable_declarations, unnecessary_string_interpolations, use_build_context_synchronously

import 'package:amplify_core/amplify_core.dart';
import 'package:flutter/foundation.dart';


/** This is an auto generated class representing the Test type in your schema. */
@immutable
class Test {
  final String? _test_type;
  final String? _instructions;
  final int? _duration_in_seconds;

  String get test_type {
    try {
      return _test_type!;
    } catch(e) {
      throw new AmplifyCodeGenModelException(
          AmplifyExceptionMessages.codeGenRequiredFieldForceCastExceptionMessage,
          recoverySuggestion:
            AmplifyExceptionMessages.codeGenRequiredFieldForceCastRecoverySuggestion,
          underlyingException: e.toString()
          );
    }
  }
  
  String? get instructions {
    return _instructions;
  }
  
  int? get duration_in_seconds {
    return _duration_in_seconds;
  }
  
  const Test._internal({required test_type, instructions, duration_in_seconds}): _test_type = test_type, _instructions = instructions, _duration_in_seconds = duration_in_seconds;
  
  factory Test({required String test_type, String? instructions, int? duration_in_seconds}) {
    return Test._internal(
      test_type: test_type,
      instructions: instructions,
      duration_in_seconds: duration_in_seconds);
  }
  
  bool equals(Object other) {
    return this == other;
  }
  
  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is Test &&
      _test_type == other._test_type &&
      _instructions == other._instructions &&
      _duration_in_seconds == other._duration_in_seconds;
  }
  
  @override
  int get hashCode => toString().hashCode;
  
  @override
  String toString() {
    var buffer = new StringBuffer();
    
    buffer.write("Test {");
    buffer.write("test_type=" + "$_test_type" + ", ");
    buffer.write("instructions=" + "$_instructions" + ", ");
    buffer.write("duration_in_seconds=" + (_duration_in_seconds != null ? _duration_in_seconds!.toString() : "null"));
    buffer.write("}");
    
    return buffer.toString();
  }
  
  Test copyWith({String? test_type, String? instructions, int? duration_in_seconds}) {
    return Test._internal(
      test_type: test_type ?? this.test_type,
      instructions: instructions ?? this.instructions,
      duration_in_seconds: duration_in_seconds ?? this.duration_in_seconds);
  }
  
  Test.fromJson(Map<String, dynamic> json)  
    : _test_type = json['test_type'],
      _instructions = json['instructions'],
      _duration_in_seconds = (json['duration_in_seconds'] as num?)?.toInt();
  
  Map<String, dynamic> toJson() => {
    'test_type': _test_type, 'instructions': _instructions, 'duration_in_seconds': _duration_in_seconds
  };
  
  Map<String, Object?> toMap() => {
    'test_type': _test_type, 'instructions': _instructions, 'duration_in_seconds': _duration_in_seconds
  };

  static var schema = Model.defineSchema(define: (ModelSchemaDefinition modelSchemaDefinition) {
    modelSchemaDefinition.name = "Test";
    modelSchemaDefinition.pluralName = "Tests";
    
    modelSchemaDefinition.addField(ModelFieldDefinition.customTypeField(
      fieldName: 'test_type',
      isRequired: true,
      ofType: ModelFieldType(ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(ModelFieldDefinition.customTypeField(
      fieldName: 'instructions',
      isRequired: false,
      ofType: ModelFieldType(ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(ModelFieldDefinition.customTypeField(
      fieldName: 'duration_in_seconds',
      isRequired: false,
      ofType: ModelFieldType(ModelFieldTypeEnum.int)
    ));
  });
}