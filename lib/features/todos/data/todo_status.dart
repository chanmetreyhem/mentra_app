import 'package:flutter/cupertino.dart';

import '../../../utils/custom_extension.dart';

enum TodoStatus{
  none,notStarted,inProgress,onCompleted
}

extension TodoStatusExtension on TodoStatus {

  String getTitle (BuildContext context){
    final loc = context.loc!;
    switch (this) {
      case TodoStatus.notStarted:
        return loc.notStarted;
      case TodoStatus.inProgress:
        return loc.inProgress;
      case TodoStatus.onCompleted:
        return loc.completed;
      default:
        return loc.none;
    }

  }

}