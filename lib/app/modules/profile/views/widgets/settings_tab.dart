import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zone2/app/modules/profile/controllers/profile_controller.dart';
import 'package:zone2/app/services/auth_service.dart';
import 'package:zone2/app/services/shared_preferences_service.dart';
import 'package:zone2/app/services/theme_service.dart';

class SettingsTab extends GetView<ProfileController> {
  const SettingsTab({super.key});

  @override
  Widget build(BuildContext context) {
    final themeService = ThemeService.to;
    final settings = SharedPreferencesService.to;

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Center(
            child: Text(
              'Profile & Settings',
              style: TextStyle(
                color: Theme.of(context).colorScheme.inverseSurface,
                fontWeight: FontWeight.normal,
                fontSize: Theme.of(context).textTheme.headlineSmall?.fontSize,
              ),
            ),
          ),
          const SizedBox(height: 8.0),
          SettingsToggle(
            themeService.isDarkMode.value ? 'Dark Mode' : 'Light Mode',
            Icon(themeService.isDarkMode.value
                ? Icons.dark_mode_outlined
                : Icons.light_mode_outlined),
            onSelected: () => themeService.toggleTheme(),
          ),
          const SizedBox(height: 8.0),
          Obx(() => TextField(
                controller: controller.openApiKeyController,
                obscureText: !controller.openApiKeyVisible.value,
                decoration: InputDecoration(
                  border: UnderlineInputBorder(),
                  hintText: "API Key",
                  labelText: "API Key",
                  suffixIcon: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(controller.openApiKeyVisible.value
                            ? Icons.visibility_off_outlined
                            : Icons.visibility_outlined),
                        onPressed: () {
                          controller.openApiKeyVisible.value = !controller.openApiKeyVisible.value;
                          // Call setState if this is a StatefulWidget
                        },
                      ),
                      IconButton(
                        icon: Icon(Icons.save),
                        onPressed: () {
                          controller.saveOpenAIKey();
                          // Provide feedback to the user if necessary
                        },
                      ),
                    ],
                  ),
                  filled: true,
                ),
                keyboardType: TextInputType.visiblePassword,
                textInputAction: TextInputAction.done,
              )),
          Expanded(child: Container()),
          TextButton(
            onPressed: () {
              AuthService.to.signOut();
            },
            clipBehavior: Clip.antiAlias,
            child: const Column(children: [
              Icon(Icons.logout_outlined),
              Text('Sign Out'),
            ]),
          ),
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
