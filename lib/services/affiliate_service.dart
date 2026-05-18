import 'package:url_launcher/url_launcher.dart';

import '../utils/constants.dart';

/// Builds Amazon / Audible affiliate URLs and opens them externally.
/// Tracking ID is a placeholder until Associates is configured.
class AffiliateService {
  AffiliateService._();
  static final AffiliateService instance = AffiliateService._();

  static const List<Map<String, String>> bibleBooks = [
    {
      'asin': 'B07BDCNF2J',
      'title': 'NIV Study Bible',
      'price': r'$34.99',
    },
    {
      'asin': 'B0BZWXZQJT',
      'title': 'Jesus Calling',
      'price': r'$12.99',
    },
    {
      'asin': 'B00AYD0OYQ',
      'title': 'Purpose Driven Life',
      'price': r'$10.99',
    },
    {
      'asin': 'B004X7YVMC',
      'title': 'The Case for Christ',
      'price': r'$8.99',
    },
  ];

  String amazonUrl(String asin) => AppConstants.amazonProductUrl(asin);

  Future<bool> openAmazonProduct(String asin) =>
      _launch(amazonUrl(asin), source: 'amazon_$asin');

  Future<bool> openAudibleTrial() =>
      _launch(AppConstants.audibleTrialUrl, source: 'audible_trial');

  Future<bool> _launch(String url, {required String source}) async {
    // TODO: log affiliate_click via analytics when Firebase is added.
    final uri = Uri.parse(url);
    if (!await canLaunchUrl(uri)) return false;
    return launchUrl(uri, mode: LaunchMode.externalApplication);
  }
}
