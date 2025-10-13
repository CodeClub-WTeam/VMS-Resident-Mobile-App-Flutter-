import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:vms_resident_app/src/features/visitor_codes/repositories/visitor_code_repository.dart';

class HistoryProvider extends ChangeNotifier {
  final VisitorCodeRepository _repository;

  HistoryProvider(this._repository);

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  List<dynamic> _historyList = [];
  List<dynamic> get historyList => _historyList;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  final _limit = 20;
  final _offset = 0;

  /// Fetch the visit history for the resident
  Future<void> fetchVisitHistory({String? fromDate, String? toDate}) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    debugPrint("Fetching visit history: from=$fromDate, to=$toDate");

    try {
      final history = await _repository.getVisitHistory(
        fromDate: fromDate,
        toDate: toDate,
        limit: _limit,
        offset: _offset,
      );
      _historyList = history;
    } catch (e) {
      debugPrint('Error fetching visit history: $e');
      _errorMessage = 'Could not load visit history.';
      _historyList = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Set quick filters
  void setFilter(String filter) {
    String? fromDate;
    final now = DateTime.now();
    final formatter = DateFormat('yyyy-MM-dd');

    if (filter == 'This Week') {
      fromDate = formatter.format(now.subtract(Duration(days: now.weekday - 1)));
    } else if (filter == 'This Month') {
      fromDate = formatter.format(DateTime(now.year, now.month, 1));
    } else if (filter == 'Last 3 Months') {
      int targetMonth = now.month - 3;
      int targetYear = now.year;
      if (targetMonth <= 0) {
        targetMonth += 12;
        targetYear -= 1;
      }
      final threeMonthsAgo = DateTime(targetYear, targetMonth, 1);
      fromDate = formatter.format(threeMonthsAgo);
    }

    final toDate = formatter.format(now);

    debugPrint("Applying filter: $filter → from=$fromDate to=$toDate");
    fetchVisitHistory(fromDate: fromDate, toDate: toDate);
  }
}
