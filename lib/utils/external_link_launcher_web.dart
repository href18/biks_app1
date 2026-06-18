import 'package:web/web.dart' as web;

Future<bool> openExternalLink(Uri url) async {
  final urlString = url.toString();
  final openedWindow = web.window.open(urlString, '_blank');
  if (openedWindow == null) {
    web.window.location.href = urlString;
  }
  return true;
}
