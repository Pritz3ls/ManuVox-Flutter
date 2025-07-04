import 'package:shared_preferences/shared_preferences.dart';
import '../objects/gestures.dart';
import '../objects/category.dart';
import '../objects/local_database.dart';
import '../objects/remote_database.dart';
import 'package:connectivity_plus/connectivity_plus.dart'; // For connectivity checks

class SyncService {
  static final SyncService instance = SyncService._instance();
  final LocalDatabase _localDb = LocalDatabase.instance;
  final RemoteDatabase _remoteDb = RemoteDatabase();

  static const String _lastCategorySyncTimeKey = 'lastCategorySyncTime';
  static const String _lastGestureSyncTimeKey = 'lastGestureSyncTime';

  SyncService._instance();

  Future<bool> isConnected() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    return connectivityResult != ConnectivityResult.none;
  }

    // Check if theres an update available, return true if there was
  Future<bool> hasPendingUpdates() async {
    if (!(await isConnected())) {
      print('No internet connection. Cannot check for updates.');
      return false; // Cannot check if offline
    }

    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();

      // Check for Category updates
      DateTime? lastCategorySyncTime = _getLastSyncTime(prefs, _lastCategorySyncTimeKey);
      List<Category> remoteCategories = await _remoteDb.fetchCategories(since: lastCategorySyncTime);
      if (remoteCategories.isNotEmpty) {
        print('${remoteCategories.length} new/updated categories found during check.');
        return true; // Updates available for categories
      }

      // Check for Gesture updates
      DateTime? lastGestureSyncTime = _getLastSyncTime(prefs, _lastGestureSyncTimeKey);
      List<Gestures> remoteGestures = await _remoteDb.fetchGestures(since: lastGestureSyncTime);
      if (remoteGestures.isNotEmpty) {
        print('${remoteGestures.length} new/updated gestures found during check.');
        return true; // Updates available for gestures
      }

      print('No new updates found from remote server during check.');
      return false; // No updates found for either
    } catch (e) {
      print('Error during update check: $e');
      // In case of an error during the check, we might assume no updates
      // or that the check failed. For safety, return false if error.
      return false;
    }
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