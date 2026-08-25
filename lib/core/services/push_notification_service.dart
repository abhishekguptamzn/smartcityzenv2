import 'dart:async';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:logger/logger.dart';

import '../../data/api/notifications_api.dart';

final Logger _logger = Logger();

/// High-importance Android notification channel for heads-up push notifications.
const AndroidNotificationChannel _highImportanceChannel =
    AndroidNotificationChannel(
  'high_importance_channel',
  'High Importance Notifications',
  description: 'This channel is used for important push notifications and alerts.',
  importance: Importance.max,
  playSound: true,
  enableVibration: true,
);

/// Web Firebase configuration options
const FirebaseOptions _webFirebaseOptions = FirebaseOptions(
  apiKey: 'AIzaSyCV4jlR01qud6RDC82hnDX2n4q8QBCqWP4',
  appId: '1:529235789171:android:accc5241f134a0dc5fb106',
  messagingSenderId: '529235789171',
  projectId: 'smartct-b6e17',
  storageBucket: 'smartct-b6e17.firebasestorage.app',
);

/// Top-level background message handler for FCM.
///
/// MUST be annotated with `@pragma('vm:entry-point')` so the Dart VM
/// can invoke it as an isolate entry point when the app is in the background or killed.
@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  try {
    if (kIsWeb) {
      await Firebase.initializeApp(options: _webFirebaseOptions);
    } else {
      await Firebase.initializeApp();
    }
  } catch (_) {
    // Firebase already initialized or platform specific initialization
  }

  if (kDebugMode) {
    _logger.i(
      'FCM Background Message Received: ID=${message.messageId}, '
      'Title=${message.notification?.title ?? message.data['title']}, '
      'Data=${message.data}',
    );
  }
}

class PushNotificationService {
  PushNotificationService._();
  static final PushNotificationService instance = PushNotificationService._();

  final _tokenController = StreamController<String>.broadcast();
  final _messageClickController = StreamController<RemoteMessage>.broadcast();

  Stream<String> get onTokenRefresh =>
      _isInitialized ? FirebaseMessaging.instance.onTokenRefresh : const Stream.empty();
  Stream<RemoteMessage> get onMessageClick => _messageClickController.stream;

  bool _isInitialized = false;

  /// Initializes Firebase and Push Notification configurations.
  static Future<void> initialize() async {
    if (instance._isInitialized) return;

    try {
      // 1. Initialize Firebase Core safely with Web & Native Options
      if (kIsWeb) {
        await Firebase.initializeApp(options: _webFirebaseOptions);
      } else {
        await Firebase.initializeApp();
      }

      final fcm = FirebaseMessaging.instance;

      // 2. Register Background FCM Handler (Native Mobile Only)
      if (!kIsWeb) {
        FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
      }

      // 3. Initialize Local Notifications Plugin & Android Channel
      await instance._initLocalNotifications();

      // 4. Request Permissions (especially for Android 13+ / iOS / Web)
      await instance.requestPermission();

      // 5. Configure Foreground Presentation Options (Native Mobile)
      if (!kIsWeb) {
        await fcm.setForegroundNotificationPresentationOptions(
          alert: true,
          badge: true,
          sound: true,
        );
      }

      // 6. Setup Listeners
      instance._setupMessageListeners(fcm);

      instance._isInitialized = true;
      if (kDebugMode) {
        _logger.i('PushNotificationService initialized successfully.');
      }
    } catch (e, stack) {
      if (kDebugMode) {
        _logger.w('PushNotificationService initialization skipped/error: $e',
            error: e, stackTrace: stack);
      }
    }
  }

  /// Request Notification Permissions from the user
  Future<NotificationSettings?> requestPermission() async {
    try {
      final settings = await FirebaseMessaging.instance.requestPermission(
        alert: true,
        announcement: false,
        badge: true,
        carPlay: false,
        criticalAlert: false,
        provisional: false,
        sound: true,
      );

      if (kDebugMode) {
        _logger.i(
            'Push Notification Permission Status: ${settings.authorizationStatus}');
      }

      return settings;
    } catch (e) {
      if (kDebugMode) {
        _logger.w('Unable to request notification permission: $e');
      }
      return null;
    }
  }

  /// Retrieve the unique FCM Device Registration Token.
  Future<String?> getToken() async {
    try {
      final token = await FirebaseMessaging.instance.getToken();
      if (kDebugMode) {
        _logger.i('FCM Registration Token: $token');
      }
      return token;
    } catch (e) {
      if (kDebugMode) {
        _logger.w('Unable to fetch FCM token: $e');
      }
      return null;
    }
  }

  /// Syncs the current FCM token with Laravel backend
  Future<void> syncDeviceToken(NotificationsApi api) async {
    try {
      final token = await getToken();
      if (token != null && token.isNotEmpty) {
        final platform = kIsWeb
            ? 'web'
            : (defaultTargetPlatform == TargetPlatform.iOS ? 'ios' : 'android');
        await api.registerDeviceToken(
          token: token,
          platform: platform,
        );
        if (kDebugMode) {
          _logger.i('Device token synced with backend successfully.');
        }
      }
    } catch (e) {
      if (kDebugMode) {
        _logger.w('Failed to sync device token with backend: $e');
      }
    }
  }

  /// Initialize Flutter Local Notifications & setup the Android channel
  Future<void> _initLocalNotifications() async {
    if (kIsWeb) return;

    final localNotifications = FlutterLocalNotificationsPlugin();

    const androidSettings =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const darwinSettings = DarwinInitializationSettings(
      requestAlertPermission: false,
      requestBadgePermission: false,
      requestSoundPermission: false,
    );

    const initSettings = InitializationSettings(
      android: androidSettings,
      iOS: darwinSettings,
      macOS: darwinSettings,
    );

    await localNotifications.initialize(
      initSettings,
      onDidReceiveNotificationResponse: (NotificationResponse response) {
        if (kDebugMode) {
          _logger.i('Local Notification Clicked: payload=${response.payload}');
        }
      },
    );

    // Create the High Importance Channel on Android
    final androidImplementation =
        localNotifications.resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>();

    if (androidImplementation != null) {
      await androidImplementation
          .createNotificationChannel(_highImportanceChannel);
    }
  }

  /// Setup foreground, background open, and terminated open listeners
  void _setupMessageListeners(FirebaseMessaging fcm) {
    // 1. Foreground message handler
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      if (kDebugMode) {
        _logger.i(
          'FCM Foreground Message: Title=${message.notification?.title ?? message.data['title']}, '
          'Body=${message.notification?.body ?? message.data['body']}',
        );
      }

      _showForegroundNotification(message);
    });

    // 2. Background tap handler (when app is opened from notification tray while in background)
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      if (kDebugMode) {
        _logger.i('FCM Notification tapped from background: ${message.data}');
      }
      _messageClickController.add(message);
    });

    // 3. Terminated state tap handler (when app is launched from notification tray while terminated)
    fcm.getInitialMessage().then((RemoteMessage? message) {
      if (message != null) {
        if (kDebugMode) {
          _logger.i('FCM App launched from terminated state: ${message.data}');
        }
        _messageClickController.add(message);
      }
    }).catchError((_) {});
  }

  /// Displays a local heads-up notification when a message arrives while app is in foreground
  void _showForegroundNotification(RemoteMessage message) {
    if (kIsWeb) return;

    final notification = message.notification;
    final title = notification?.title ?? message.data['title'] as String?;
    final body = notification?.body ?? message.data['body'] as String?;

    if (title != null || body != null) {
      FlutterLocalNotificationsPlugin().show(
        message.hashCode,
        title ?? 'Smart Cityzen Alert',
        body ?? '',
        NotificationDetails(
          android: AndroidNotificationDetails(
            _highImportanceChannel.id,
            _highImportanceChannel.name,
            channelDescription: _highImportanceChannel.description,
            importance: _highImportanceChannel.importance,
            priority: Priority.high,
            icon: '@mipmap/ic_launcher',
            playSound: true,
            enableVibration: true,
          ),
          iOS: const DarwinNotificationDetails(
            presentAlert: true,
            presentBadge: true,
            presentSound: true,
          ),
        ),
        payload: message.data.isNotEmpty ? message.data.toString() : null,
      );
    }
  }

  void dispose() {
    _tokenController.close();
    _messageClickController.close();
  }
}
