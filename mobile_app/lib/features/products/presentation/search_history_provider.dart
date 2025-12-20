import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../core/storage/shared_prefs_provider.dart';

part 'search_history_provider.g.dart';

@riverpod
class SearchHistory extends _$SearchHistory {
  static const _key = 'recent_searches';

  @override
  List<String> build() {
    final prefs = ref.watch(sharedPrefsProvider);
    return prefs.getStringList(_key) ?? [];
  }

  void addSearch(String query) {
    if (query.trim().isEmpty) return;
    
    final current = List<String>.from(state);
    current.remove(query); // Remove if exists to move to top
    current.insert(0, query);
    
    if (current.length > 5) {
      current.removeLast();
    }
    
    state = current;
    ref.read(sharedPrefsProvider).setStringList(_key, current);
  }

  void removeSearch(String query) {
    final current = List<String>.from(state);
    current.remove(query);
    state = current;
    ref.read(sharedPrefsProvider).setStringList(_key, current);
  }

  void clearHistory() {
    state = [];
    ref.read(sharedPrefsProvider).remove(_key);
  }
}
