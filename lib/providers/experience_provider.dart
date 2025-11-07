import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hotspots_hostes/models/experience.dart';
import 'package:hotspots_hostes/services/api_service.dart';

final apiServiceProvider = Provider((ref) => ApiService());

final experiencesProvider = FutureProvider<List<Experience>>((ref) async {
  final apiService = ref.read(apiServiceProvider);
  final result = await apiService.getExperiences();
  return result;
});

final selectedExperiencesProvider = StateProvider<Set<int>>((ref) => {});

final experienceDescriptionProvider = StateProvider<String>((ref) => '');
