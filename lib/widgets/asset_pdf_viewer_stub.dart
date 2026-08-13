import 'package:flutter/material.dart';

enum AssetPdfFitPolicy { width, height, both }

class AssetPdfViewer extends StatelessWidget {
  const AssetPdfViewer({
    super.key,
    required this.title,
    required this.assetPath,
    this.fitPolicy = AssetPdfFitPolicy.width,
    this.startInLandscape = false,
  });

  final String title;
  final String assetPath;
  final AssetPdfFitPolicy fitPolicy;
  final bool startInLandscape;

  @override
  Widget build(BuildContext context) {
    return _PdfMessageView(
      title: title,
      assetPath: assetPath,
      message: 'PDF-visning er ikke tilgjengelig på denne plattformen.',
    );
  }
}

class _PdfMessageView extends StatelessWidget {
  const _PdfMessageView({
    required this.title,
    required this.assetPath,
    required this.message,
  });

  final String title;
  final String assetPath;
  final String message;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.picture_as_pdf_outlined,
                  size: 48,
                  color: theme.colorScheme.primary,
                ),
                const SizedBox(height: 12),
                Text(
                  title,
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  message,
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodyMedium,
                ),
                const SizedBox(height: 8),
                Text(
                  assetPath,
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
