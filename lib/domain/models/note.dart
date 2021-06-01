import 'package:equatable/equatable.dart';

class Note extends Equatable {
  Note({
    required this.id,
    required this.title,
    required this.content,
  });

  final String id, title, content;

  @override
  List<Object?> get props => [id, title, content];
}
