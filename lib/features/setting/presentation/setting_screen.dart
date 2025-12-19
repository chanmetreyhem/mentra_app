import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mentra_app/utils/custom_extension.dart';

import '../../../l10n/app_localizations.dart';
import '../../../main.dart';
import '../../../utils/app_language_provider.dart';

class SettingScreen extends HookConsumerWidget {
  const SettingScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeModeNotifier = ref.read(themeProvider.notifier);
    void _changeLanguage(Locale locale) {
      final notifier = ref.read(appLanguageProvider.notifier);
      notifier.changeLanguage(locale);
    }
    return Scaffold(
      appBar: AppBar(title: Text(context.loc!.setting,)),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            context.loc!.chooseLanguageTitle,
            //style: context.theme.,
          ),
          const SizedBox(height: 20),
          FilledButton(
            onPressed: () => _changeLanguage(const Locale('en', '')),
            style: FilledButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5.0),
              ),
              minimumSize: const Size(double.infinity, 50),
            ),
            child: Text(
              'English',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 10),
          FilledButton(
            onPressed: () => _changeLanguage(const Locale('fr', '')),
            style: FilledButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5.0),
              ),
              minimumSize: const Size(double.infinity, 50),
            ),
            child: Text(
              'French',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 10),
          FilledButton(
            onPressed: () => _changeLanguage(const Locale('km', '')),
            style: FilledButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(5.0),
              ),
              minimumSize: const Size(double.infinity, 50),
            ),
            child: Text(
              'ខ្មែរ',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          Switch(value: ref.watch(themeProvider), onChanged: (value) => themeModeNotifier.state = value)
        ],
      ),
      //body: Center(child: ),
    );
  }
}
