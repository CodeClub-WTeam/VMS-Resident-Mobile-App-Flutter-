import 'package:vms_resident_app/src/core/api_client.dart';
import 'package:dio/dio.dart';

class VisitorCodeRepository {
  final ApiClient _apiClient;

  VisitorCodeRepository(this._apiClient);

  // ===================================
  // 1. VISIT HISTORY METHOD (Used by HistoryProvider)
  // ===================================

  /// Get the resident's visit history
  Future<List<dynamic>> getVisitHistory({
    String? fromDate,
    String? toDate,
    int? limit, 
    int? offset,
  }) async {
    try {
      final response = await _apiClient.dio.get(
        '/codes/my-history',
        queryParameters: {
          'from_date': fromDate,
          'to_date': toDate,
          'limit': limit,
          'offset': offset,
        },
      );

      if (response.statusCode == 200 && response.data != null) {
        return response.data is List
            ? response.data
            : (response.data['data'] as List? ?? []);
      } else {
        throw Exception('Failed to fetch visit history');
      }
    } on DioException catch (e) {
      throw Exception(
        'Error fetching history: ${e.response?.data ?? e.message}',
      );
    }
  }

  // ===================================
  // 2. CODE MANAGEMENT METHODS (Used by CodeProvider)
  // ===================================
  
  /// ✅ Generate a new visitor access code
  Future<Map<String, dynamic>> generateCode(
    String visitDate,
    String startTime,
    String endTime,
    String visitorName,
  ) async {
    try {
      // API expects HH:MM format, so we truncate the seconds part if present.
      final formattedStartTime =
          startTime.length > 5 ? startTime.substring(0, 5) : startTime;
      final formattedEndTime =
          endTime.length > 5 ? endTime.substring(0, 5) : endTime;

      final response = await _apiClient.dio.post(
        '/codes/generate',
        data: {
          'visit_date': visitDate,
          'start_time': formattedStartTime,
          'end_time': formattedEndTime,
          'visitor_name': visitorName,
        },
      );

      if (response.statusCode == 201 && response.data != null) {
        return response.data;
      } else {
        throw Exception('Failed to generate visitor code');
      }
    } on DioException catch (e) {
      throw Exception(
        'Error generating code: ${e.response?.data ?? e.message}',
      );
    }
  }

  /// ✅ Cancel a visitor access code (DELETE /codes/{id})
  Future<void> cancelVisitorCode(String codeId) async {
    try {
      final response = await _apiClient.dio.delete('/codes/$codeId');

      if (response.statusCode != 200 && response.statusCode != 204) {
        throw Exception('Failed to cancel visitor code');
      }
    } on DioException catch (e) {
      throw Exception(
        'Error cancelling code: ${e.response?.data ?? e.message}',
      );
    }
  }
}