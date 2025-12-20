import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../data/analytics_repository.dart';

part 'analytics_provider.g.dart';

@riverpod
Future<Map<String, dynamic>> analyticsStats(Ref ref) {
  return ref.watch(analyticsRepositoryProvider).getStats();
}
