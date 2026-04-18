import 'dart:html' as html;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:device_info_plus/device_info_plus.dart';

class VisitorService {
  static final DeviceInfoPlugin _deviceInfoPlugin = DeviceInfoPlugin();

  static Future<void> logVisitor() async {
    try {
      final WebBrowserInfo data = await _deviceInfoPlugin.webBrowserInfo;
      final screen = html.window.screen;
      final location = html.window.location;
      final uri = Uri.parse(location.href);

      await FirebaseFirestore.instance.collection('visitors').add({
        // Time
        'timestamp': FieldValue.serverTimestamp(),
        'localTime': DateTime.now().toIso8601String(),

        // Browser (device_info_plus)
        'browserName': data.browserName.name,
        'appCodeName': data.appCodeName,
        'appName': data.appName,
        'appVersion': data.appVersion,
        'language': data.language,
        'languages': data.languages?.join(', '),
        'platform': data.platform,
        'product': data.product,
        'userAgent': data.userAgent,
        'vendor': data.vendor,

        // Device (dart:html)
        'deviceType': _getDeviceType(data.userAgent ?? ''),
        'os': _getOS(data.userAgent ?? ''),
        'devicePixelRatio': html.window.devicePixelRatio,
        'screenWidth': screen?.width,
        'screenHeight': screen?.height,
        'windowWidth': html.window.innerWidth,
        'windowHeight': html.window.innerHeight,

        // Session
        'referrer': html.document.referrer.isEmpty
            ? 'direct'
            : html.document.referrer,
        'currentURL': location.href,
        'currentPath': location.pathname,
        'pageTitle': html.document.title,

        // UTM
        'utm_source': uri.queryParameters['utm_source'] ?? 'none',
        'utm_medium': uri.queryParameters['utm_medium'] ?? 'none',
        'utm_campaign': uri.queryParameters['utm_campaign'] ?? 'none',
      });

      print('✅ Visitor logged successfully');
    } catch (e) {
      print('❌ Failed to log visitor: $e');
    }
  }

  static String _getDeviceType(String userAgent) {
    final ua = userAgent.toLowerCase();
    if (ua.contains('ipad') ||
        (ua.contains('android') && !ua.contains('mobile'))) {
      return 'Tablet';
    }
    if (ua.contains('iphone') || ua.contains('android')) return 'Mobile';
    return 'Desktop';
  }

  static String _getOS(String userAgent) {
    final ua = userAgent.toLowerCase();
    if (ua.contains('iphone') || ua.contains('ipad')) return 'iOS';
    if (ua.contains('android')) return 'Android';
    if (ua.contains('windows')) return 'Windows';
    if (ua.contains('mac os')) return 'macOS';
    if (ua.contains('linux')) return 'Linux';
    return 'Unknown';
  }
}
