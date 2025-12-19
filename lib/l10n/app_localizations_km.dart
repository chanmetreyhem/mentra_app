// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Khmer Central Khmer (`km`).
class AppLocalizationsKm extends AppLocalizations {
  AppLocalizationsKm([String locale = 'km']) : super(locale);

  @override
  String get chooseLanguageTitle => 'ជ្រើសរើសភាសារ';

  @override
  String get setting => 'ការកំណត់';

  @override
  String get add => 'បង្កើត';

  @override
  String get home => 'ផ្ទះ';

  @override
  String get total => 'សរុប';

  @override
  String get search => 'ស្វែងរក';

  @override
  String get noData => 'គ្មានទិន្ទន័យ';

  @override
  String get notStarted => 'មិនទាន់ចាប់ផ្តើម';

  @override
  String get inProgress => 'កំពង់ដំណើការ';

  @override
  String get completed => 'បញ្ចប់';

  @override
  String get description => 'ការពិពណ៌នា';

  @override
  String get title => 'ចំណងជើង';

  @override
  String get all => 'ទាំងអស់';

  @override
  String get endDate => 'កាលបរិច្ឆេតបញ្ចប់';

  @override
  String get startDate => 'កាលបរិច្ឆេតចាប់ផ្តើម';

  @override
  String get status => 'ស្ធានភាព';

  @override
  String get priority => 'Priority';

  @override
  String get none => 'មិនមាន';

  @override
  String get ok => 'យល់ព្រម';

  @override
  String get cancel => 'បោះបង់';

  @override
  String get message => 'សារ';

  @override
  String get deleteMessage => 'តើអ្នកពិតជាចង់លុបកិច្ចការនេះមែនទេ?';

  @override
  String get task => 'កិច្ចការ';

  @override
  String pleaseSelect(Object title) {
    return 'សូមជ្រើសរើស $title';
  }

  @override
  String pleaseEnter(Object title) {
    return 'សូមបញ្ចូល $title';
  }
}
