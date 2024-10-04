import 'package:flutter/foundation.dart';
import 'package:zone2/app/services/shared_preferences_service.dart';
import 'package:zone2/app/style/palette.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../controllers/profile_controller.dart';

class ProfileViewPortraitSmall extends GetWidget<ProfileController> {
  const ProfileViewPortraitSmall({super.key});

  @override
  Widget build(BuildContext context) {
    final Palette palette = Palette();
    final settings = SharedPreferencesService.to;

    return PopScope(
      onPopInvokedWithResult: (bool value, Object? result) {
        return; // Updated to use onPopInvokedWithResult
      },
      child: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          return GetBuilder<ProfileController>(
            builder: (controller) => Theme(
              data: palette.primaryTheme,
              child: PopScope(
                canPop: false,
                child: Scaffold(
                  appBar: AppBar(
                    title: const Text('Zone 2 Profile'),
                    centerTitle: true,
                  ),
                  body: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          'Settings',
                          style: TextStyle(
                            color: context.theme.colorScheme.inverseSurface,
                            fontWeight: FontWeight.normal,
                            fontSize: context.theme.textTheme.headlineSmall?.fontSize,
                          ),
                        ),
                        const SizedBox(height: 8.0),
                        SettingsToggle(
                          settings.isDarkMode ? 'Dark Mode' : 'Light Mode',
                          Icon(settings.isDarkMode
                              ? Icons.dark_mode_outlined
                              : Icons.light_mode_outlined),
                          onSelected: () => settings.toggleDarkMode(),
                        ),
                        const SizedBox(height: 8.0),
                        Expanded(child: Container()),
                        if (kDebugMode)
                          OutlinedButton.icon(
                            icon: const Icon(Icons.delete_forever_outlined),
                            onPressed: () async {
                              settings.resetPersistedSettings();
                              Get.defaultDialog(
                                title: 'Settings Reset',
                                middleText: 'All settings have been reset to default',
                                actions: [
                                  TextButton(
                                    onPressed: () {
                                      Get.back();
                                    },
                                    child: const Text('OK'),
                                  ),
                                ],
                              );
                            },
                            label: const Text('Reset Persisted Settings'),
                          ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class SettingsToggle extends StatelessWidget {
  final String title;

  final Widget icon;

  final VoidCallback? onSelected;

  const SettingsToggle(this.title, this.icon, {super.key, this.onSelected});

  @override
  Widget build(BuildContext context) {
    return InkResponse(
      highlightShape: BoxShape.rectangle,
      onTap: onSelected,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Expanded(
              child: Text(
                title,
                maxLines: 1,
                style: const TextStyle(
                  fontSize: 14,
                ),
              ),
            ),
            icon,
          ],
        ),
      ),
    );
  }
}
