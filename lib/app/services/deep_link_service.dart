import 'dart:async';
import 'dart:developer';

import 'package:app_links/app_links.dart';

class DeepLinkService {
  DeepLinkService() : _appLinks = AppLinks();

  final AppLinks _appLinks;
  StreamSubscription<Uri>? _linkSubscription;

  Future<void> initialize({required void Function(Uri) onLink}) async {
    try {
      final initialLink = await _appLinks.getInitialLink();
      if (initialLink != null) {
        log('Initial deep link: $initialLink', name: 'DeepLinkService');
        onLink(initialLink);
      }
    } catch (e) {
      log('Failed to get initial link: $e', name: 'DeepLinkService');
    }

    _linkSubscription = _appLinks.uriLinkStream.listen(
      (uri) {
        log('Received deep link: $uri', name: 'DeepLinkService');
        onLink(uri);
      },
      onError: (Object err) {
        log('Deep link error: $err', name: 'DeepLinkService');
      },
    );
  }

  void dispose() {
    _linkSubscription?.cancel();
  }
}
