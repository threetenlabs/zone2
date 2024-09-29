import 'package:zone2/app/modules/update/controllers/update_controller.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:url_launcher/url_launcher.dart';

class UpdateSmall extends GetWidget<UpdateController> {
  const UpdateSmall({super.key});

  //TODO get valid app store URLs
  final String androidUri = 'https://play.google.com/store/apps/details';
  final String iosUri = 'https://apps.apple.com/us/app/';

  Future<void> _launchURL(Uri url) async {
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    //Simple screen indicating that the current version is below the minimum supported version and they need to update it in the appstore
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Update Required',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Please update to the latest version to continue. \nApologies for the inconvenience.',
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            FractionallySizedBox(
              widthFactor: 0.40, // Make the image 1/3 of its current width
              child: InkWell(
                onTap: () {
                  // Replace with your app store link
                  _launchURL(Uri.parse(GetPlatform.isAndroid ? androidUri : iosUri));
                },
                child: GetPlatform.isAndroid
                    ? Image.asset('assets/images/google-play-badge.png')
                    : Image.asset('assets/images/ios-app-store-badge.png'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
