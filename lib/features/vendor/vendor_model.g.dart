// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vendor_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

VendorModel _$VendorModelFromJson(Map<String, dynamic> json) {
  return VendorModel(
    json['id'] as String,
    json['name'] as String,
    json['tagline'] as String,
    json['email'] as String,
    json['mobileNumber'] as String,
    json['landlineNumber'] as String,
    json['permanentAddress'] == null
        ? null
        : PermanentAddress.fromJson(
            json['permanentAddress'] as Map<String, dynamic>),
    json['geolocation'] == null
        ? null
        : Location.fromJson(json['geolocation'] as Map<String, dynamic>),
    json['profilePicture'] as String,
  );
}

Map<String, dynamic> _$VendorModelToJson(VendorModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'tagline': instance.tagline,
      'email': instance.email,
      'mobileNumber': instance.mobileNumber,
      'landlineNumber': instance.landlineNumber,
      'permanentAddress': instance.permanentAddress,
      'geolocation': instance.geolocation,
      'profilePicture': instance.profilePicture,
    };

PermanentAddress _$PermanentAddressFromJson(Map<String, dynamic> json) {
  return PermanentAddress(
    json['zone'] as String,
    json['district'] as String,
    json['vdc'] as String,
    json['ward'] as String,
    json['tole'] as String,
  );
}

Map<String, dynamic> _$PermanentAddressToJson(PermanentAddress instance) =>
    <String, dynamic>{
      'zone': instance.zone,
      'district': instance.district,
      'vdc': instance.vdc,
      'ward': instance.ward,
      'tole': instance.tole,
    };
