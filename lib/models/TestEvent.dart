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


/** This is an auto generated class representing the TestEvent type in your schema. */
@immutable
class TestEvent {
  final String? _test_event_id;
  final String? _patient_id;
  final String? _test_type;
  final bool? _if_completed;
  final int? _balance_score;
  final int? _doctor_score;
  final String? _notes;
  final TemporalDateTime? _start_time;
  final TemporalDateTime? _end_time;

  String get test_event_id {
    try {
      return _test_event_id!;
    } catch(e) {
      throw new AmplifyCodeGenModelException(
          AmplifyExceptionMessages.codeGenRequiredFieldForceCastExceptionMessage,
          recoverySuggestion:
            AmplifyExceptionMessages.codeGenRequiredFieldForceCastRecoverySuggestion,
          underlyingException: e.toString()
          );
    }
  }
  
  String get patient_id {
    try {
      return _patient_id!;
    } catch(e) {
      throw new AmplifyCodeGenModelException(
          AmplifyExceptionMessages.codeGenRequiredFieldForceCastExceptionMessage,
          recoverySuggestion:
            AmplifyExceptionMessages.codeGenRequiredFieldForceCastRecoverySuggestion,
          underlyingException: e.toString()
          );
    }
  }
  
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
  
  bool get if_completed {
    try {
      return _if_completed!;
    } catch(e) {
      throw new AmplifyCodeGenModelException(
          AmplifyExceptionMessages.codeGenRequiredFieldForceCastExceptionMessage,
          recoverySuggestion:
            AmplifyExceptionMessages.codeGenRequiredFieldForceCastRecoverySuggestion,
          underlyingException: e.toString()
          );
    }
  }
  
  int? get balance_score {
    return _balance_score;
  }
  
  int? get doctor_score {
    return _doctor_score;
  }
  
  String? get notes {
    return _notes;
  }
  
  TemporalDateTime? get start_time {
    return _start_time;
  }
  
  TemporalDateTime? get end_time {
    return _end_time;
  }
  
  const TestEvent._internal({required test_event_id, required patient_id, required test_type, required if_completed, balance_score, doctor_score, notes, start_time, end_time}): _test_event_id = test_event_id, _patient_id = patient_id, _test_type = test_type, _if_completed = if_completed, _balance_score = balance_score, _doctor_score = doctor_score, _notes = notes, _start_time = start_time, _end_time = end_time;
  
  factory TestEvent({required String test_event_id, required String patient_id, required String test_type, required bool if_completed, int? balance_score, int? doctor_score, String? notes, TemporalDateTime? start_time, TemporalDateTime? end_time}) {
    return TestEvent._internal(
      test_event_id: test_event_id,
      patient_id: patient_id,
      test_type: test_type,
      if_completed: if_completed,
      balance_score: balance_score,
      doctor_score: doctor_score,
      notes: notes,
      start_time: start_time,
      end_time: end_time);
  }
  
  bool equals(Object other) {
    return this == other;
  }
  
  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is TestEvent &&
      _test_event_id == other._test_event_id &&
      _patient_id == other._patient_id &&
      _test_type == other._test_type &&
      _if_completed == other._if_completed &&
      _balance_score == other._balance_score &&
      _doctor_score == other._doctor_score &&
      _notes == other._notes &&
      _start_time == other._start_time &&
      _end_time == other._end_time;
  }
  
  @override
  int get hashCode => toString().hashCode;
  
  @override
  String toString() {
    var buffer = new StringBuffer();
    
    buffer.write("TestEvent {");
    buffer.write("test_event_id=" + "$_test_event_id" + ", ");
    buffer.write("patient_id=" + "$_patient_id" + ", ");
    buffer.write("test_type=" + "$_test_type" + ", ");
    buffer.write("if_completed=" + (_if_completed != null ? _if_completed!.toString() : "null") + ", ");
    buffer.write("balance_score=" + (_balance_score != null ? _balance_score!.toString() : "null") + ", ");
    buffer.write("doctor_score=" + (_doctor_score != null ? _doctor_score!.toString() : "null") + ", ");
    buffer.write("notes=" + "$_notes" + ", ");
    buffer.write("start_time=" + (_start_time != null ? _start_time!.format() : "null") + ", ");
    buffer.write("end_time=" + (_end_time != null ? _end_time!.format() : "null"));
    buffer.write("}");
    
    return buffer.toString();
  }
  
  TestEvent copyWith({String? test_event_id, String? patient_id, String? test_type, bool? if_completed, int? balance_score, int? doctor_score, String? notes, TemporalDateTime? start_time, TemporalDateTime? end_time}) {
    return TestEvent._internal(
      test_event_id: test_event_id ?? this.test_event_id,
      patient_id: patient_id ?? this.patient_id,
      test_type: test_type ?? this.test_type,
      if_completed: if_completed ?? this.if_completed,
      balance_score: balance_score ?? this.balance_score,
      doctor_score: doctor_score ?? this.doctor_score,
      notes: notes ?? this.notes,
      start_time: start_time ?? this.start_time,
      end_time: end_time ?? this.end_time);
  }
  
  TestEvent.fromJson(Map<String, dynamic> json)  
    : _test_event_id = json['test_event_id'],
      _patient_id = json['patient_id'],
      _test_type = json['test_type'],
      _if_completed = json['if_completed'],
      _balance_score = (json['balance_score'] as num?)?.toInt(),
      _doctor_score = (json['doctor_score'] as num?)?.toInt(),
      _notes = json['notes'],
      _start_time = json['start_time'] != null ? TemporalDateTime.fromString(json['start_time']) : null,
      _end_time = json['end_time'] != null ? TemporalDateTime.fromString(json['end_time']) : null;
  
  Map<String, dynamic> toJson() => {
    'test_event_id': _test_event_id, 'patient_id': _patient_id, 'test_type': _test_type, 'if_completed': _if_completed, 'balance_score': _balance_score, 'doctor_score': _doctor_score, 'notes': _notes, 'start_time': _start_time?.format(), 'end_time': _end_time?.format()
  };
  
  Map<String, Object?> toMap() => {
    'test_event_id': _test_event_id, 'patient_id': _patient_id, 'test_type': _test_type, 'if_completed': _if_completed, 'balance_score': _balance_score, 'doctor_score': _doctor_score, 'notes': _notes, 'start_time': _start_time, 'end_time': _end_time
  };

  static var schema = Model.defineSchema(define: (ModelSchemaDefinition modelSchemaDefinition) {
    modelSchemaDefinition.name = "TestEvent";
    modelSchemaDefinition.pluralName = "TestEvents";
    
    modelSchemaDefinition.addField(ModelFieldDefinition.customTypeField(
      fieldName: 'test_event_id',
      isRequired: true,
      ofType: ModelFieldType(ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(ModelFieldDefinition.customTypeField(
      fieldName: 'patient_id',
      isRequired: true,
      ofType: ModelFieldType(ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(ModelFieldDefinition.customTypeField(
      fieldName: 'test_type',
      isRequired: true,
      ofType: ModelFieldType(ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(ModelFieldDefinition.customTypeField(
      fieldName: 'if_completed',
      isRequired: true,
      ofType: ModelFieldType(ModelFieldTypeEnum.bool)
    ));
    
    modelSchemaDefinition.addField(ModelFieldDefinition.customTypeField(
      fieldName: 'balance_score',
      isRequired: false,
      ofType: ModelFieldType(ModelFieldTypeEnum.int)
    ));
    
    modelSchemaDefinition.addField(ModelFieldDefinition.customTypeField(
      fieldName: 'doctor_score',
      isRequired: false,
      ofType: ModelFieldType(ModelFieldTypeEnum.int)
    ));
    
    modelSchemaDefinition.addField(ModelFieldDefinition.customTypeField(
      fieldName: 'notes',
      isRequired: false,
      ofType: ModelFieldType(ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(ModelFieldDefinition.customTypeField(
      fieldName: 'start_time',
      isRequired: false,
      ofType: ModelFieldType(ModelFieldTypeEnum.dateTime)
    ));
    
    modelSchemaDefinition.addField(ModelFieldDefinition.customTypeField(
      fieldName: 'end_time',
      isRequired: false,
      ofType: ModelFieldType(ModelFieldTypeEnum.dateTime)
    ));
  });
}