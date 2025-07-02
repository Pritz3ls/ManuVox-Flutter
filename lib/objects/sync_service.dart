import 'package:shared_preferences/shared_preferences.dart';
import '../objects/gestures.dart';
import '../objects/category.dart';
import '../objects/local_database.dart';
import '../objects/remote_database.dart';
import 'package:connectivity_plus/connectivity_plus.dart'; // For connectivity checks

class SyncService {
  final LocalDatabase _localDb = LocalDatabase.instance;
  final RemoteDatabase _remoteDb = RemoteDatabase();

  static const String _lastCategorySyncTimeKey = 'lastCategorySyncTime';
  static const String _lastGestureSyncTimeKey = 'lastGestureSyncTime';

  Future<bool> isConnected() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    return connectivityResult != ConnectivityResult.none;
  }

  Future<void> performFullPullSync() async {
    if (!(await isConnected())) {
      print('Offline. Skipping full pull sync.');
      return;
    }

    print('Starting full pull synchronization...');
    SharedPreferences prefs = await SharedPreferences.getInstance();

    try {
      // --- Sync Categories ---
      DateTime? lastCategorySyncTime = _getLastSyncTime(prefs, _lastCategorySyncTimeKey);
      List<Category> remoteCategories = await _remoteDb.fetchCategories(since: lastCategorySyncTime);

      print('Fetched ${remoteCategories.length} new/updated categories.');
      for (Category category in remoteCategories) {
        await _localDb.saveCategoryFromRemote(category);
      }
      // Update last sync time for categories
      await prefs.setString(_lastCategorySyncTimeKey, DateTime.now().toIso8601String());

      // --- Sync Gestures ---
      DateTime? lastGestureSyncTime = _getLastSyncTime(prefs, _lastGestureSyncTimeKey);
      List<Gestures> remoteGestures = await _remoteDb.fetchGestures(since: lastGestureSyncTime);

      print('Fetched ${remoteGestures.length} new/updated gestures.');
      for (Gestures gesture in remoteGestures) {
        await _localDb.saveGestureFromRemote(gesture);
      }
      // Update last sync time for gestures
      await prefs.setString(_lastGestureSyncTimeKey, DateTime.now().toIso8601String());


      print('Full pull synchronization complete.');

    } catch (e) {
      print('Full pull synchronization failed: $e');
      // Implement robust error handling (e.g., show a user message, log to analytics)
    }
  }

  DateTime? _getLastSyncTime(SharedPreferences prefs, String key) {
    String? timestampString = prefs.getString(key);
    return timestampString != null ? DateTime.parse(timestampString) : null;
  }
}