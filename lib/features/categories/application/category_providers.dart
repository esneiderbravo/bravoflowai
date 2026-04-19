import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/error/app_exception.dart';
import '../../../core/error/failure.dart';
import '../../../core/services/app_providers.dart';
import '../../../domain/entities/category.dart';
import '../data/repositories/category_repository_impl.dart';
import '../domain/repositories/category_repository.dart';

final categoryRepositoryProvider = Provider<CategoryRepository>(
  (ref) => CategoryRepositoryImpl(client: ref.read(supabaseClientProvider)),
);

class CategoryNotifier extends AsyncNotifier<List<Category>> {
  @override
  Future<List<Category>> build() async {
    final result = await ref.read(categoryRepositoryProvider).fetchAll();
    return result.getOrElse((f) => throw AppException(f));
  }

  /// Returns `null` on success, or an error message string on failure.
  Future<String?> add(Category category) async {
    final result = await ref.read(categoryRepositoryProvider).add(category);
    return result.match(
      (failure) {
        // Restore list state so screen still shows categories
        state = AsyncData(state.valueOrNull ?? []);
        return failure.userMessage;
      },
      (saved) {
        state = AsyncData([...state.valueOrNull ?? [], saved]);
        return null;
      },
    );
  }

  /// Returns `null` on success, or an error message string on failure.
  Future<String?> edit(Category category) async {
    final result = await ref.read(categoryRepositoryProvider).update(category);
    return result.match(
      (failure) {
        state = AsyncData(state.valueOrNull ?? []);
        return failure.userMessage;
      },
      (updated) {
        state = AsyncData(
          (state.valueOrNull ?? []).map((c) => c.id == updated.id ? updated : c).toList(),
        );
        return null;
      },
    );
  }

  Future<String?> remove(String id) async {
    final result = await ref.read(categoryRepositoryProvider).delete(id);
    return result.match(
      (failure) {
        state = AsyncData(state.valueOrNull ?? []);
        return failure.userMessage;
      },
      (_) {
        state = AsyncData((state.valueOrNull ?? []).where((c) => c.id != id).toList());
        return null;
      },
    );
  }
}

final categoryNotifierProvider = AsyncNotifierProvider<CategoryNotifier, List<Category>>(
  CategoryNotifier.new,
);
