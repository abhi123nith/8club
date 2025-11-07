import 'package:dio/dio.dart';
import 'package:hotspots_hostes/models/experience.dart';

class ApiService {
  static const String baseUrl = 'https://staging.chamberofsecrets.8club.co/v1';
  final Dio _dio = Dio();

  Future<List<Experience>> getExperiences() async {
    try {
      final response = await _dio.get('$baseUrl/experiences?active=true');

      if (response.statusCode == 200) {
        // Check if response data is valid
        if (response.data != null &&
            response.data['data'] != null &&
            response.data['data']['experiences'] != null) {
          final data = response.data['data']['experiences'] as List;
          return data.map((item) => Experience.fromJson(item)).toList();
        } else {
          // Return empty list if data structure is not as expected
          return [];
        }
      } else {
        // Return empty list if status code is not 200
        return [];
      }
    } on DioException catch (e) {
      // Return empty list if there's a Dio exception
      print('Dio error: ${e.message}');
      return [];
    } catch (e) {
      // Return empty list for any other exception
      print('Error fetching experiences: $e');
      return [];
    }
  }
}
