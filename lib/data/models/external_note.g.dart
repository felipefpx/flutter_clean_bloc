// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'external_note.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ExternalNote _$ExternalNoteFromJson(Map<String, dynamic> json) {
  return ExternalNote(
    id: json['id'] as String,
    title: json['title'] as String,
    content: json['content'] as String,
  );
}

Map<String, dynamic> _$ExternalNoteToJson(ExternalNote instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'content': instance.content,
    };
