import 'dart:html' as html;
import 'dart:js' as js;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class VisitorService {
  static DateTime? _visitStart;

  static Future<void> logVisitor() async {
    _visitStart = DateTime.now();

    try {
      final deviceInfo = _getDeviceInfo();
      final sessionInfo = _getSessionInfo();
      final networkInfo = _getNetworkInfo();
      final utmParams = _getUTMParams();
      final locationInfo = await _getLocationFromIP();

      await FirebaseFirestore.instance.collection('visitors').add({
        // Timestamp
        'timestamp': FieldValue.serverTimestamp(),
        'localTime': DateTime.now().toIso8601String(),

        // Location (IP-based)
        'ip': locationInfo['ip'],
        'country': locationInfo['country'],
        'countryCode': locationInfo['countryCode'],
        'region': locationInfo['region'],
        'city': locationInfo['city'],
        'zip': locationInfo['zip'],
        'latitude': locationInfo['latitude'],
        'longitude': locationInfo['longitude'],
        'timezone': locationInfo['timezone'],
        'isp': locationInfo['isp'],
        'org': locationInfo['org'],

        // Device & Browser
        'userAgent': deviceInfo['userAgent'],
        'platform': deviceInfo['platform'],
        'appName': deviceInfo['appName'],
        'language': deviceInfo['language'],
        'languages': deviceInfo['languages'],
        'cookieEnabled': deviceInfo['cookieEnabled'],
        'isOnline': deviceInfo['isOnline'],
        'cpuCores': deviceInfo['cpuCores'],
        'devicePixelRatio': deviceInfo['devicePixelRatio'],

        // Screen
        'screenWidth': deviceInfo['screenWidth'],
        'screenHeight': deviceInfo['screenHeight'],
        'windowWidth': deviceInfo['windowWidth'],
        'windowHeight': deviceInfo['windowHeight'],
        'colorDepth': deviceInfo['colorDepth'],
        'pixelDepth': deviceInfo['pixelDepth'],

        // Session
        'referrer': sessionInfo['referrer'],
        'currentURL': sessionInfo['currentURL'],
        'currentPath': sessionInfo['currentPath'],
        'queryString': sessionInfo['queryString'],
        'pageTitle': sessionInfo['pageTitle'],

        // Network
        'connectionType': networkInfo['connectionType'],
        'downloadSpeed': networkInfo['downloadSpeed'],
        'rtt': networkInfo['rtt'],

        // UTM / Marketing
        'utm_source': utmParams['utm_source'],
        'utm_medium': utmParams['utm_medium'],
        'utm_campaign': utmParams['utm_campaign'],
        'utm_term': utmParams['utm_term'],
        'utm_content': utmParams['utm_content'],
      });

      print('✅ Visitor logged successfully');
    } catch (e) {
      print('❌ Failed to log visitor: $e');
    }

    // Log session duration when user leaves
    _setupExitLogger();
  }

  // ─── Device & Browser ───────────────────────────────────────────────────────

  static Map<String, dynamic> _getDeviceInfo() {
    final nav = html.window.navigator;
    final screen = html.window.screen;

    return {
      'userAgent': nav.userAgent,
      'platform': nav.platform,
      'appName': nav.appName,
      'language': nav.language,
      'languages': nav.languages?.join(', '),
      'cookieEnabled': nav.cookieEnabled,
      'isOnline': nav.onLine,
      'cpuCores': nav.hardwareConcurrency,
      'devicePixelRatio': html.window.devicePixelRatio,
      'screenWidth': screen?.width,
      'screenHeight': screen?.height,
      'windowWidth': html.window.innerWidth,
      'windowHeight': html.window.innerHeight,
      'colorDepth': screen?.colorDepth,
      'pixelDepth': screen?.pixelDepth,
    };
  }

  // ─── Session Info ────────────────────────────────────────────────────────────

  static Map<String, dynamic> _getSessionInfo() {
    final location = html.window.location;
    return {
      'referrer': html.document.referrer.isEmpty
          ? 'direct'
          : html.document.referrer,
      'currentURL': location.href,
      'currentPath': location.pathname,
      'queryString': location.search,
      'pageTitle': html.document.title,
    };
  }

  // ─── Network Info ────────────────────────────────────────────────────────────

  static Map<String, dynamic> _getNetworkInfo() {
    try {
      // connection API isn't fully exposed in dart:html, so we use js interop
      final connection =
          js.context['navigator']['connection'] ??
          js.context['navigator']['mozConnection'] ??
          js.context['navigator']['webkitConnection'];

      if (connection != null) {
        return {
          'connectionType': connection['effectiveType']?.toString(),
          'downloadSpeed': connection['downlink']?.toString(),
          'rtt': connection['rtt']?.toString(),
        };
      }
    } catch (_) {}

    return {
      'connectionType': 'unknown',
      'downloadSpeed': 'unknown',
      'rtt': 'unknown',
    };
  }

  // ─── UTM Params ──────────────────────────────────────────────────────────────

  static Map<String, dynamic> _getUTMParams() {
    final uri = Uri.parse(html.window.location.href);
    return {
      'utm_source': uri.queryParameters['utm_source'] ?? 'none',
      'utm_medium': uri.queryParameters['utm_medium'] ?? 'none',
      'utm_campaign': uri.queryParameters['utm_campaign'] ?? 'none',
      'utm_term': uri.queryParameters['utm_term'] ?? 'none',
      'utm_content': uri.queryParameters['utm_content'] ?? 'none',
    };
  }

  // ─── IP Location ─────────────────────────────────────────────────────────────

  static Future<Map<String, dynamic>> _getLocationFromIP() async {
    try {
      final response = await http.get(
        Uri.parse(
          'http://ip-api.com/json?fields=status,country,countryCode,regionName,city,zip,lat,lon,timezone,isp,org,query',
        ),
      );
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['status'] == 'success') {
          return {
            'ip': data['query'],
            'country': data['country'],
            'countryCode': data['countryCode'],
            'region': data['regionName'],
            'city': data['city'],
            'zip': data['zip'],
            'latitude': data['lat'],
            'longitude': data['lon'],
            'timezone': data['timezone'],
            'isp': data['isp'],
            'org': data['org'],
          };
        }
      }
    } catch (e) {
      print('Location fetch failed: $e');
    }

    return {
      'ip': 'unknown',
      'country': 'unknown',
      'countryCode': 'unknown',
      'region': 'unknown',
      'city': 'unknown',
      'zip': 'unknown',
      'latitude': null,
      'longitude': null,
      'timezone': 'unknown',
      'isp': 'unknown',
      'org': 'unknown',
    };
  }

  // ─── Session Duration on Exit ─────────────────────────────────────────────

  static void _setupExitLogger() {
    html.window.onBeforeUnload.listen((_) async {
      if (_visitStart == null) return;
      final duration = DateTime.now().difference(_visitStart!).inSeconds;

      // Use sendBeacon for reliability on page exit
      final payload = jsonEncode({'sessionDuration_seconds': duration});
      js.context.callMethod('navigator.sendBeacon', [
        'https://your-firebase-function-url/logDuration', // optional: set up a Firebase Function
        payload,
      ]);

      // Or simply update the last visitor document — requires storing the doc ID
      print('Session lasted $duration seconds');
    });
  }
}
