import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:vms_resident_app/src/core/api_client.dart';
import 'package:vms_resident_app/src/core/error_handler.dart';
import 'package:vms_resident_app/src/features/auth/models/resident_model.dart';

class AuthRepository {
  final ApiClient _apiClient;
  final FlutterSecureStorage _secureStorage = const FlutterSecureStorage();

  AuthRepository(this._apiClient);

  Future<Resident> login(String email, String password) async {
    // ✅ Endpoint: POST /auth/login is CONFIRMED in docs. No change needed here.
    try {
      final response = await _apiClient.dio.post(
        '/auth/login',
        data: {'email': email, 'password': password},
      );

      final responseData = response.data['data'];
      final token = responseData['token'];
      await _secureStorage.write(key: 'jwt_token', value: token);

      return Resident.fromJson(responseData['user']);
    } on DioException catch (e) {
      throw ErrorHandler.handle(e);
    }
  }

  Future<void> logout() async {
    // ⚠️ FIX: The swagger docs DO NOT show a POST /auth/logout endpoint.
    // We must only clear local data for now to prevent a 404 on logout.

    // 1. Invalidate session token on the backend (SKIP API CALL)
    /* try {
      // API call removed: await _apiClient.dio.post('/auth/logout');
    } on DioException catch (e) {
      debugPrint('Warning: Logout API call failed or is unsupported: ${e.message}');
    } */

    // 2. Clear the JWT token from local secure storage
    await _secureStorage.delete(key: 'jwt_token');
  }

  Future<void> forgotPassword(String email) async {
    // ⚠️ CRITICAL FIX: The swagger docs DO NOT show a /auth/forgot-password endpoint.
    // We throw a handled exception to show an informative message to the user.
    throw Exception("Password reset service is currently unavailable. Contact support.");
    
    /* // Original code that would cause a 404:
    try {
      await _apiClient.dio.post(
        '/auth/forgot-password',
        data: {'email': email},
      );
    } on DioException catch (e) {
      throw ErrorHandler.handle(e);
    } */
  }
}