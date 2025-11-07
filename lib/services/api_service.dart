import 'package:dio/dio.dart';
import 'package:hotspots_hostes/models/experience.dart';

class ApiService {
  static const String baseUrl = 'https://staging.chamberofsecrets.8club.co/v1';
  final Dio _dio = Dio();

  Future<List<Experience>> getExperiences() async {
    try {
      final response = await _dio.get('$baseUrl/experiences?active=true');

      if (response.statusCode == 200) {
        if (response.data != null &&
            response.data['data'] != null &&
            response.data['data']['experiences'] != null) {
          final data = response.data['data']['experiences'] as List;
          return data.map((item) => Experience.fromJson(item)).toList();
        } else {
          return [];
        }
      } else {
        return [];
      }
    } on DioException catch (e) {
      print('Dio error: ${e.message}');
      return [];
    } catch (e) {
      print('Error fetching experiences: $e');
      return [];
    }
  }
}
