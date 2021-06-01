import 'package:json_annotation/json_annotation.dart';

import '../../domain/models/note.dart';

part 'external_note.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class ExternalNote {
  ExternalNote({
    required this.id,
    required this.title,
    required this.content,
  });

  factory ExternalNote.fromJson(Map<String, dynamic> json) =>
      _$ExternalNoteFromJson(json);

  Map<String, dynamic> toJson() => _$ExternalNoteToJson(this);

  @JsonKey()
  final String id, title, content;
}

extension ExternalNoteMapper on ExternalNote {
  Note toNote() => Note(
        id: id,
        title: title,
        content: content,
      );
}

extension ExternalNoteListMapper on List<ExternalNote> {
  List<Note> toNotes() => map((externalNote) => externalNote.toNote()).toList();
}
