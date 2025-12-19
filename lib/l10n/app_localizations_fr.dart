// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get chooseLanguageTitle => 'Choisissez votre langue';

  @override
  String get setting => 'Setting';

  @override
  String get add => 'Add';

  @override
  String get home => 'Home';

  @override
  String get total => 'Total';

  @override
  String get search => 'Search';

  @override
  String get noData => 'No Data';

  @override
  String get notStarted => 'Not Started';

  @override
  String get inProgress => 'In Progress';

  @override
  String get completed => 'Completed';

  @override
  String get description => 'Description';

  @override
  String get title => 'Title';

  @override
  String get all => 'All';

  @override
  String get endDate => 'End Date';

  @override
  String get startDate => 'Start Date';

  @override
  String get status => 'Status';

  @override
  String get priority => 'Priority';

  @override
  String get none => 'None';

  @override
  String get ok => 'Ok';

  @override
  String get cancel => 'Cancel';

  @override
  String get message => 'Message';

  @override
  String get deleteMessage => 'Are you sure you want to delete this task?';

  @override
  String get task => 'Task';

  @override
  String pleaseSelect(Object title) {
    return 'Please select $title';
  }

  @override
  String pleaseEnter(Object title) {
    return 'Please enter $title';
  }
}
