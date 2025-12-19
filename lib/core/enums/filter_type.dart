import 'package:flutter/cupertino.dart';

import '../../utils/custom_extension.dart';

enum FilterType{
    all()
  ,notStarted 
  ,inProgress
  ,completed
}

extension FilterTypeExtension on FilterType {
  String getTitle(BuildContext context){
    switch (this) {
      case FilterType.all:
        return context.loc!.all;
      case FilterType.notStarted:
        return context.loc!.notStarted;
      case FilterType.inProgress:
        return context.loc!.inProgress;
      case FilterType.completed:
        return context.loc!.completed;
    }
  }

}