/// Placeholder for OpenAI / on-device prayer assistant.
/// Wire with `--dart-define=OPENAI_KEY=...` or a secure backend later.
class AiService {
  AiService._();
  static final AiService instance = AiService._();

  static const String _keyFromEnv =
      String.fromEnvironment('OPENAI_KEY', defaultValue: '');

  bool get isConfigured => _keyFromEnv.isNotEmpty;

  Future<String> suggestPrayerPrompt({required String userTopic}) async {
    await Future<void>.delayed(const Duration(milliseconds: 400));
    if (!isConfigured) {
      return 'AI Prayer Partner is not configured yet. '
          'Add OPENAI_KEY via dart-define when you integrate the backend.';
    }
    // TODO: call OpenAI API through a secure proxy — never ship raw keys in APK.
    return 'Lord, guide me as I reflect on: $userTopic. Amen.';
  }
}
