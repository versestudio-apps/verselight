/// Placeholder for Hive / SharedPreferences persistence.
class LocalStorageService {
  LocalStorageService._();
  static final LocalStorageService instance = LocalStorageService._();

  final Map<String, String> _memory = {};

  Future<void> initialize() async {
    // TODO: Hive.initFlutter() + open boxes, or shared_preferences.
  }

  Future<void> writeString(String key, String value) async {
    _memory[key] = value;
  }

  Future<String?> readString(String key) async => _memory[key];

  Future<void> clear() async => _memory.clear();
}
