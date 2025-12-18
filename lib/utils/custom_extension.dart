import 'package:flutter/material.dart';
import 'package:mentra_app/l10n/app_localizations.dart';

extension ContextExtension on BuildContext {
  ThemeData get theme {
    return Theme.of(this);
  }
  AppLocalizations? get loc{
  return AppLocalizations.of(this);

  }
}