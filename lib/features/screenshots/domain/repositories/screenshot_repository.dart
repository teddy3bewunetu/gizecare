import 'package:gizecare/core/errors/result.dart';
import 'package:gizecare/features/projects/domain/repositories/project_repository.dart';
import 'package:gizecare/features/screenshots/domain/entities/screenshot_item.dart';

/// Contract for screenshot metadata persistence.
abstract class ScreenshotRepository {
  Stream<List<ScreenshotItem>> watchAll();

  Stream<List<ScreenshotItem>> watchForTask(String taskId);

  Future<Result<List<ScreenshotItem>>> getAll();

  Future<Result<ScreenshotItem>> create(ScreenshotItem item);

  Future<Result<Unit>> delete(String id);
}
