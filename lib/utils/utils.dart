import 'package:flutter/material.dart';
import 'package:mentra_app/core/enums/filter_type.dart';

import '../features/todos/data/todo_status.dart';

 class Utils {
  static Color getColorFromStatus(TodoStatus status) {
    switch (status) {
      case TodoStatus.notStarted:
        return Colors.red;
      case TodoStatus.inProgress:
        return Colors.amber;
      case TodoStatus.onCompleted:
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  static Color getColorFromFilterType(FilterType filter) {
    switch (filter) {
      case FilterType.notStarted:
        return Colors.red;
      case FilterType.inProgress:
        return Colors.amber;
      case FilterType.onCompleted:
        return Colors.green;
      default:
        return Colors.black;
    }
  }
}