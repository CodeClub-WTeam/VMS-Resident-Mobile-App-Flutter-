import 'package:flutter/foundation.dart';
import 'package:vms_resident_app/src/features/visitor_codes/repositories/visitor_code_repository.dart';

class HistoryProvider extends ChangeNotifier {
  final VisitorCodeRepository _repository;

  HistoryProvider(this._repository);

  List<dynamic> _historyList = [];
  List<dynamic> get historyList => _historyList;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? errorMessage;

  Future<void> setFilter(String filter) async {
    _isLoading = true;
    notifyListeners();

    try {
      final now = DateTime.now();
      DateTime from;
      DateTime to = now;

      if (filter == 'This Week') {
        from = now.subtract(Duration(days: now.weekday - 1));
      } else if (filter == 'This Month') {
        from = DateTime(now.year, now.month, 1);
      } else {
        from = DateTime(now.year, now.month - 3, 1);
      }

      final history = await _repository.getVisitHistory(
        fromDate: from.toIso8601String().split('T').first,
        toDate: to.toIso8601String().split('T').first,
        limit: 20,
        offset: 0,
      );

      _historyList = history;
      errorMessage = null;
    } catch (e) {
      errorMessage = 'Failed to load history: $e';
      debugPrint(errorMessage);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// ✅ Add pending code immediately after generation
  void addTemporaryPendingCode(Map<String, dynamic> codeData) {
    // Avoid duplicates
    if (!_historyList.any((e) => e['id'] == codeData['id'])) {
      _historyList.insert(0, codeData);
      notifyListeners();
    }
  }
}
