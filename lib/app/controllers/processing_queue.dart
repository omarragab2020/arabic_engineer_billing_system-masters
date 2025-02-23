import 'dart:async';

import 'package:neuss_utils/utils/helpers.dart';

enum MyProcessState {
  pending,
  running,
  finished,
  error,
}

class MyProcess<T> {
  dynamic id;
  MyProcessState state = MyProcessState.pending;
  T object;

  void pend() => state = MyProcessState.pending;

  void run() => state = MyProcessState.running;

  void finish() => state = MyProcessState.finished;

  void error() => state = MyProcessState.error;

  bool get isPending => state == MyProcessState.pending;

  bool get isRunning => state == MyProcessState.running;

  bool get isFinished => state == MyProcessState.finished;

  bool get isError => state == MyProcessState.error;

  MyProcess({
    this.id,
    this.state = MyProcessState.pending,
    required this.object,
  });
}

class ProcessingQueue<T> {
  final _queue = <dynamic, MyProcess<T>>{};
  final _controller = StreamController<T>();
  bool _processing = false;
  final FutureOr<void> Function(T) processItem;
  dynamic curProcessingKey;
  final dynamic Function(T) getKey;
  final bool Function(T, T)? notEqualFunction;

  ProcessingQueue({
    required this.processItem,
    required this.getKey,
    bool Function(T, T)? notEqualFunction,
  }) : notEqualFunction = notEqualFunction ?? ((s1, s2) => (s1 != s2)) {
    // processedItems.listen((onData) {
    //   if (_queue.isNotEmpty) processQueue();
    // });
  }

  Future<void> enqueue(T item) async {
    final key = getKey(item);
    mPrint2('enqueuing ($key)');
    final oldItem = _queue[key];

    mPrint2('enqueuing 2 ($key)');
    bool notEq = false;
    if (oldItem != null) {
      mPrint2('enqueuing 3 ($key)');
      notEq = notEqualFunction!(oldItem.object, item);
      mPrint2('enqueuing 4 ($key)');
      // mPrint2('notEqualFunction ($b)');
      oldItem.object = item;
      _queue[key] = oldItem;
      if (notEq) {
        mPrint2('enqueuing 5 ($key)');
        oldItem.pend();
      }
    } else {
      mPrint2('enqueuing 6 ($key)');
      _queue[key] = MyProcess<T>(id: key, object: item);
    }
    mPrint2('enqueuing 7 ($key => State: ${_queue[key]?.state.name})');
    await processQueue();
  }

  void enqueueAll(List<T> items) {
    mPrint2('enqueueAll (${items.length}) items');
    for (var item in items) {
      enqueue(item);
    }
  }

  void dequeue(dynamic key) {
    _queue.remove(key);
    processQueue();
  }

  Future<void> processQueue() async {
    if (_processing) return;
    final notProcessedKeys = _queue.entries.where((entry) => entry.value.isPending).map((entry) => entry.key).toList();
    if (notProcessedKeys.isEmpty) return;
    _processing = true;
    mPrint2('processQueue (items: $notProcessedKeys)');
    final id = notProcessedKeys.first;
    final item = _queue[id] as MyProcess<T>;
    try {
      curProcessingKey = id;
      mPrint2('Processing item ($id)');
      try {
        item.run();
        await processItem(item.object);
      } on Exception catch (e) {
        mPrintException(e);
      }
      item.finish();
      _controller.add(item.object);
      curProcessingKey = null;
    } catch (e) {
      _controller.addError(e);
    }

    _processing = false;
    processQueue();
  }

  Stream<T> get processedItems => _controller.stream;

  void dispose() {
    _controller.close();
  }
}
