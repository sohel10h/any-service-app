import 'package:get/get.dart';

class NotificationQueue<T> {
  static final List<_QueueItem> _globalQueue = [];
  static bool _isShowing = false;

  String? allowedRoute;

  late void Function(T item, void Function() onClosed) bottomSheetBuilder;

  NotificationQueue._();

  static final Map<Type, NotificationQueue> _instances = {};

  static NotificationQueue<T> of<T>() {
    if (!_instances.containsKey(T)) {
      _instances[T] = NotificationQueue<T>._();
    }
    return _instances[T] as NotificationQueue<T>;
  }

  void configure({
    required void Function(T item, void Function() onClosed) builder,
  }) {
    bottomSheetBuilder = builder;
  }

  void add(T item) {
    _globalQueue.add(_QueueItem<T>(item, bottomSheetBuilder));
    _tryShowNext();
  }

  void resume() {
    _isShowing = false;
    _tryShowNext();
  }

  void _tryShowNext() {
    if (_isShowing || _globalQueue.isEmpty) return;

    final currentRoute = Get.currentRoute;
    if (allowedRoute != null && allowedRoute != currentRoute) return;

    final next = _globalQueue.removeAt(0);
    _isShowing = true;

    if (Get.context != null) {
      next.callBuilder(() {
        _isShowing = false;
        _tryShowNext();
      });
    } else {
      _isShowing = false;
      _tryShowNext();
    }
  }
}

class _QueueItem<T> {
  final T item;
  final void Function(T, void Function()) builder;

  _QueueItem(this.item, this.builder);

  void callBuilder(void Function() onClosed) {
    builder(item, onClosed);
  }
}
