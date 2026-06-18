import 'package:url_launcher/url_launcher.dart';

Future<bool> openExternalLink(Uri url) {
  return launchUrl(url, mode: LaunchMode.externalApplication);
}
