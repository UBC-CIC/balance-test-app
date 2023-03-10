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


/** This is an auto generated class representing the Datapoint type in your schema. */
@immutable
class Datapoint {
  final String? _ts;
  final double? _ax;
  final double? _ay;
  final double? _az;
  final double? _gx;
  final double? _gy;
  final double? _gz;
  final double? _mx;
  final double? _my;
  final double? _mz;

  String get ts {
    try {
      return _ts!;
    } catch(e) {
      throw new AmplifyCodeGenModelException(
          AmplifyExceptionMessages.codeGenRequiredFieldForceCastExceptionMessage,
          recoverySuggestion:
            AmplifyExceptionMessages.codeGenRequiredFieldForceCastRecoverySuggestion,
          underlyingException: e.toString()
          );
    }
  }
  
  double? get ax {
    return _ax;
  }
  
  double? get ay {
    return _ay;
  }
  
  double? get az {
    return _az;
  }
  
  double? get gx {
    return _gx;
  }
  
  double? get gy {
    return _gy;
  }
  
  double? get gz {
    return _gz;
  }
  
  double? get mx {
    return _mx;
  }
  
  double? get my {
    return _my;
  }
  
  double? get mz {
    return _mz;
  }
  
  const Datapoint._internal({required ts, ax, ay, az, gx, gy, gz, mx, my, mz}): _ts = ts, _ax = ax, _ay = ay, _az = az, _gx = gx, _gy = gy, _gz = gz, _mx = mx, _my = my, _mz = mz;
  
  factory Datapoint({required String ts, double? ax, double? ay, double? az, double? gx, double? gy, double? gz, double? mx, double? my, double? mz}) {
    return Datapoint._internal(
      ts: ts,
      ax: ax,
      ay: ay,
      az: az,
      gx: gx,
      gy: gy,
      gz: gz,
      mx: mx,
      my: my,
      mz: mz);
  }
  
  bool equals(Object other) {
    return this == other;
  }
  
  @override
  bool operator ==(Object other) {
    if (identical(other, this)) return true;
    return other is Datapoint &&
      _ts == other._ts &&
      _ax == other._ax &&
      _ay == other._ay &&
      _az == other._az &&
      _gx == other._gx &&
      _gy == other._gy &&
      _gz == other._gz &&
      _mx == other._mx &&
      _my == other._my &&
      _mz == other._mz;
  }
  
  @override
  int get hashCode => toString().hashCode;
  
  @override
  String toString() {
    var buffer = new StringBuffer();
    
    buffer.write("Datapoint {");
    buffer.write("ts=" + "$_ts" + ", ");
    buffer.write("ax=" + (_ax != null ? _ax!.toString() : "null") + ", ");
    buffer.write("ay=" + (_ay != null ? _ay!.toString() : "null") + ", ");
    buffer.write("az=" + (_az != null ? _az!.toString() : "null") + ", ");
    buffer.write("gx=" + (_gx != null ? _gx!.toString() : "null") + ", ");
    buffer.write("gy=" + (_gy != null ? _gy!.toString() : "null") + ", ");
    buffer.write("gz=" + (_gz != null ? _gz!.toString() : "null") + ", ");
    buffer.write("mx=" + (_mx != null ? _mx!.toString() : "null") + ", ");
    buffer.write("my=" + (_my != null ? _my!.toString() : "null") + ", ");
    buffer.write("mz=" + (_mz != null ? _mz!.toString() : "null"));
    buffer.write("}");
    
    return buffer.toString();
  }
  
  Datapoint copyWith({String? ts, double? ax, double? ay, double? az, double? gx, double? gy, double? gz, double? mx, double? my, double? mz}) {
    return Datapoint._internal(
      ts: ts ?? this.ts,
      ax: ax ?? this.ax,
      ay: ay ?? this.ay,
      az: az ?? this.az,
      gx: gx ?? this.gx,
      gy: gy ?? this.gy,
      gz: gz ?? this.gz,
      mx: mx ?? this.mx,
      my: my ?? this.my,
      mz: mz ?? this.mz);
  }
  
  Datapoint.fromJson(Map<String, dynamic> json)  
    : _ts = json['ts'],
      _ax = (json['ax'] as num?)?.toDouble(),
      _ay = (json['ay'] as num?)?.toDouble(),
      _az = (json['az'] as num?)?.toDouble(),
      _gx = (json['gx'] as num?)?.toDouble(),
      _gy = (json['gy'] as num?)?.toDouble(),
      _gz = (json['gz'] as num?)?.toDouble(),
      _mx = (json['mx'] as num?)?.toDouble(),
      _my = (json['my'] as num?)?.toDouble(),
      _mz = (json['mz'] as num?)?.toDouble();
  
  Map<String, dynamic> toJson() => {
    'ts': _ts, 'ax': _ax, 'ay': _ay, 'az': _az, 'gx': _gx, 'gy': _gy, 'gz': _gz, 'mx': _mx, 'my': _my, 'mz': _mz
  };
  
  Map<String, Object?> toMap() => {
    'ts': _ts, 'ax': _ax, 'ay': _ay, 'az': _az, 'gx': _gx, 'gy': _gy, 'gz': _gz, 'mx': _mx, 'my': _my, 'mz': _mz
  };

  static var schema = Model.defineSchema(define: (ModelSchemaDefinition modelSchemaDefinition) {
    modelSchemaDefinition.name = "Datapoint";
    modelSchemaDefinition.pluralName = "Datapoints";
    
    modelSchemaDefinition.addField(ModelFieldDefinition.customTypeField(
      fieldName: 'ts',
      isRequired: true,
      ofType: ModelFieldType(ModelFieldTypeEnum.string)
    ));
    
    modelSchemaDefinition.addField(ModelFieldDefinition.customTypeField(
      fieldName: 'ax',
      isRequired: false,
      ofType: ModelFieldType(ModelFieldTypeEnum.double)
    ));
    
    modelSchemaDefinition.addField(ModelFieldDefinition.customTypeField(
      fieldName: 'ay',
      isRequired: false,
      ofType: ModelFieldType(ModelFieldTypeEnum.double)
    ));
    
    modelSchemaDefinition.addField(ModelFieldDefinition.customTypeField(
      fieldName: 'az',
      isRequired: false,
      ofType: ModelFieldType(ModelFieldTypeEnum.double)
    ));
    
    modelSchemaDefinition.addField(ModelFieldDefinition.customTypeField(
      fieldName: 'gx',
      isRequired: false,
      ofType: ModelFieldType(ModelFieldTypeEnum.double)
    ));
    
    modelSchemaDefinition.addField(ModelFieldDefinition.customTypeField(
      fieldName: 'gy',
      isRequired: false,
      ofType: ModelFieldType(ModelFieldTypeEnum.double)
    ));
    
    modelSchemaDefinition.addField(ModelFieldDefinition.customTypeField(
      fieldName: 'gz',
      isRequired: false,
      ofType: ModelFieldType(ModelFieldTypeEnum.double)
    ));
    
    modelSchemaDefinition.addField(ModelFieldDefinition.customTypeField(
      fieldName: 'mx',
      isRequired: false,
      ofType: ModelFieldType(ModelFieldTypeEnum.double)
    ));
    
    modelSchemaDefinition.addField(ModelFieldDefinition.customTypeField(
      fieldName: 'my',
      isRequired: false,
      ofType: ModelFieldType(ModelFieldTypeEnum.double)
    ));
    
    modelSchemaDefinition.addField(ModelFieldDefinition.customTypeField(
      fieldName: 'mz',
      isRequired: false,
      ofType: ModelFieldType(ModelFieldTypeEnum.double)
    ));
  });
}