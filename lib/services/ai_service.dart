/// Placeholder for AI Prayer Partner (Phase 03+).
///
/// The Flutter app must **not** call OpenAI (or any LLM provider) directly and
/// must **not** embed provider secrets. When ready, call a server you control,
/// for example:
/// - Firebase Cloud Function
/// - Your own HTTPS backend
/// - Cloudflare Worker
///
/// The server holds provider credentials and enforces auth, rate limits, and
/// content policy.
class AiService {
  AiService._();
  static final AiService instance = AiService._();

  /// Remote AI is not wired in the client yet.
  bool get isConfigured => false;

  Future<String> suggestPrayerPrompt({required String userTopic}) async {
    await Future<void>.delayed(const Duration(milliseconds: 400));
    return 'AI Prayer Partner is coming soon. '
        'Responses will be generated through a secure backend—not from this app. '
        'Topic you shared: $userTopic';
  }
}
