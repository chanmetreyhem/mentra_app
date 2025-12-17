
import 'package:mentra_app/features/todos/data/todo_status.dart';

class TodoState {
  String title;
  String description;
  bool isCompleted;
  DateTime createDate;
  DateTime? completedDate;
  TodoStatus? status;
  TodoState({
    required this.title,
    required this.description,
    required this.isCompleted,
    required this.createDate,
    this.completedDate ,
    this.status = TodoStatus.notStarted
  });

  TodoState copyWith({
    String? title,
    String? description,
    bool? isCompleted,
    DateTime? createDate,
    DateTime? completedDate,
    TodoStatus? status
  }) {
    return TodoState(
      title: title ?? this.title,
      description: description ?? this.description,
      isCompleted: isCompleted ?? this.isCompleted,
      createDate: createDate ?? this.createDate,
      completedDate: completedDate ?? this.completedDate,
      status: status ?? this.status,
    );
  }
}

extension TodoStatusExtension on TodoState{
  void changeStatus(TodoStatus status){
    this.status = status;
  }
}
