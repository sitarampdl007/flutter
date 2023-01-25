// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'client_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ClientModel _$ClientModelFromJson(Map<String, dynamic> json) {
  return ClientModel(
    json['id'] as String,
    json['name'] as String,
    json['mobileNumber'] as String,
    json['bio'] as String,
    json['gender'] as String,
    json['email'] as String,
    json['profilePicture'] as String,
  );
}

Map<String, dynamic> _$ClientModelToJson(ClientModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'mobileNumber': instance.mobileNumber,
      'bio': instance.bio,
      'gender': instance.gender,
      'email': instance.email,
      'profilePicture': instance.profilePicture,
    };

ClientLocation _$ClientLocationFromJson(Map<String, dynamic> json) {
  return ClientLocation(
    json['addressTitle'] as String,
    json['addressDetail'] as String,
    json['geolocation'] == null
        ? null
        : DoubleLocation.fromJson(json['geolocation'] as Map<String, dynamic>),
  );
}

Map<String, dynamic> _$ClientLocationToJson(ClientLocation instance) =>
    <String, dynamic>{
      'addressTitle': instance.addressTitle,
      'addressDetail': instance.addressDetail,
      'geolocation': instance.geolocation,
    };

DoubleLocation _$DoubleLocationFromJson(Map<String, dynamic> json) {
  return DoubleLocation(
    (json['latitude'] as num)?.toDouble(),
    (json['longitude'] as num)?.toDouble(),
  );
}

Map<String, dynamic> _$DoubleLocationToJson(DoubleLocation instance) =>
    <String, dynamic>{
      'latitude': instance.latitude,
      'longitude': instance.longitude,
    };
