// ignore_for_file: public_member_api_docs, sort_constructors_first
class TodoState {
  String title;
  String description;
  bool isCompleted;
  DateTime createDate;
  DateTime? completedDate;
  TodoState({
    required this.title,
    required this.description,
    required this.isCompleted,
    required this.createDate,
    this.completedDate,
  });

  TodoState copyWith({
    String? title,
    String? description,
    bool? isCompleted,
    DateTime? createDate,
    DateTime? completedDate,
  }) {
    return TodoState(
      title: title ?? this.title,
      description: description ?? this.description,
      isCompleted: isCompleted ?? this.isCompleted,
      createDate: createDate ?? this.createDate,
      completedDate: completedDate ?? this.completedDate,
    );
  }
}
