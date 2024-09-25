import 'dart:async';
import 'dart:collection';
import 'package:app/app/style/palette.dart';
import 'package:elegant_notification/elegant_notification.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

// Assuming ElegantNotification is a valid widget and already imported
class NotificationService {
  static NotificationService get to => Get.find();
  final palette = Get.find<Palette>();
  final Queue<_NotificationRequest> _notificationQueue = Queue();
  bool _isShowingNotification = false;

  void showMessage(String title, String message, String iconAsset) {
    _notificationQueue.add(_NotificationRequest(
        title: title,
        message: message,
        iconAsset: iconAsset,
        notificationType: NotificationType.achievement));
    if (!_isShowingNotification) {
      _showNextNotification();
    }
  }

  void showError(String title, String message) {
    _notificationQueue.add(_NotificationRequest(
        title: title, message: message, notificationType: NotificationType.error));
    if (!_isShowingNotification) {
      _showNextNotification();
    }
  }

  void showSuccess(String title, String message) {
    _notificationQueue.add(_NotificationRequest(
        title: title, message: message, notificationType: NotificationType.success));
    if (!_isShowingNotification) {
      _showNextNotification();
    }
  }

  void _showNextNotification() {
    if (_notificationQueue.isEmpty) {
      _isShowingNotification = false;
      return;
    }
    _isShowingNotification = true;
    _NotificationRequest request = _notificationQueue.removeFirst();

    request.notificationType == NotificationType.error
        ?
        // Show the notification
        ElegantNotification.error(
            notificationMargin: 50,
            title: Text(request.title,
                style: TextStyle(
                    color: palette.darkBackGround, fontSize: 12, fontWeight: FontWeight.bold)),
            description: Text(request.message,
                style: TextStyle(color: palette.darkBackGround, fontSize: 12)),
            toastDuration: const Duration(milliseconds: 6000),
            showProgressIndicator: false,
          ).show(Get.overlayContext!)
        : request.notificationType == NotificationType.success
            ? ElegantNotification.success(
                notificationMargin: 50,
                title: Text(request.title,
                    style: TextStyle(
                        color: palette.darkBackGround, fontSize: 12, fontWeight: FontWeight.bold)),
                description: Text(request.message,
                    style: TextStyle(color: palette.darkBackGround, fontSize: 12)),
                toastDuration: const Duration(milliseconds: 6000),
                showProgressIndicator: false,
              ).show(Get.overlayContext!)
            :
            // Show the notification
            ElegantNotification(
                notificationMargin: 50,
                title: Text(request.title,
                    style: TextStyle(
                        color: palette.darkBackGround, fontSize: 12, fontWeight: FontWeight.bold)),
                description: Text(request.message,
                    style: TextStyle(color: palette.darkBackGround, fontSize: 12)),
                icon: request.iconAsset != null
                    ? Image.asset(request.iconAsset!, height: 100, width: 100, fit: BoxFit.fill)
                    : null,
                toastDuration: const Duration(milliseconds: 6000),
                showProgressIndicator: false,
              ).show(Get.overlayContext!);

    Future.delayed(const Duration(milliseconds: 6000), () {
      _isShowingNotification = false;
      _showNextNotification();
    });
  }
}

class _NotificationRequest {
  final String title;
  final String message;
  final NotificationType notificationType;
  final String? iconAsset;

  _NotificationRequest(
      {required this.title, required this.message, required this.notificationType, this.iconAsset});
}

enum NotificationType { achievement, error, success }
