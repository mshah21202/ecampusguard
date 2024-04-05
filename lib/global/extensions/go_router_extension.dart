import 'dart:async';

import 'package:flutter/foundation.dart';

class GoRouterRefreshStream<T> extends ChangeNotifier {
  GoRouterRefreshStream(Stream<T> stream, bool Function(T) notifyCondition) {
    notifyListeners();
    _subscription = stream.asBroadcastStream().listen(
          (T value) => notifyCondition.call(value) ? notifyListeners() : null,
        );
  }

  late final StreamSubscription<dynamic> _subscription;

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}
