import 'package:flutter/widgets.dart';

extension ShareOriginContext on BuildContext {
  Rect get sharePositionOrigin {
    final renderBox = findRenderObject() as RenderBox?;
    final overlayBox =
        Overlay.maybeOf(this)?.context.findRenderObject() as RenderBox?;

    if (renderBox == null ||
        overlayBox == null ||
        !renderBox.hasSize ||
        !overlayBox.hasSize) {
      return const Rect.fromLTWH(0, 0, 1, 1);
    }

    final origin = renderBox.localToGlobal(Offset.zero, ancestor: overlayBox);
    final size = renderBox.size;
    final overlayRect =
        Offset.zero & overlayBox.size; // {0,0} -> overlay size (screen)

    // Clamp the origin to stay within the overlay bounds to avoid platform errors.
    final safeLeft = origin.dx.clamp(0.0, overlayRect.width);
    final safeTop = origin.dy.clamp(0.0, overlayRect.height);
    final width = size.width == 0 ? 1.0 : size.width;
    final height = size.height == 0 ? 1.0 : size.height;

    final candidate =
        Rect.fromLTWH(safeLeft, safeTop, width, height).intersect(overlayRect);

    return candidate.isEmpty ? const Rect.fromLTWH(0, 0, 1, 1) : candidate;
  }
}
