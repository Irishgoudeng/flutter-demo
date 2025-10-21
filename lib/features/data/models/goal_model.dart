import 'package:flutter/foundation.dart' show immutable;

@immutable
class Goal {
  final String id;
  final String title;
  final String description;
  final bool isCompleted;

  const Goal({
    required this.id,
    required this.title,
    required this.description,
    this.isCompleted = false,
  });
}