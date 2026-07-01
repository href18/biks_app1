import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:path_provider/path_provider.dart';

enum AssetPdfFitPolicy { width, height, both }

class AssetPdfViewer extends StatefulWidget {
  const AssetPdfViewer({
    super.key,
    required this.title,
    required this.assetPath,
    this.fitPolicy = AssetPdfFitPolicy.width,
  });

  final String title;
  final String assetPath;
  final AssetPdfFitPolicy fitPolicy;

  @override
  State<AssetPdfViewer> createState() => _AssetPdfViewerState();
}

class _AssetPdfViewerState extends State<AssetPdfViewer> {
  static const MethodChannel _orientationChannel =
      MethodChannel('biks/table_orientation');

  late Future<String> _localPdfPath;
  String? _viewerError;

  @override
  void initState() {
    super.initState();
    _allowTableRotation();
    _localPdfPath = _copyAssetPdfToTempFile(widget.assetPath);
  }

  @override
  void dispose() {
    _restorePortraitOrientation();
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant AssetPdfViewer oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.assetPath != widget.assetPath) {
      _viewerError = null;
      _localPdfPath = _copyAssetPdfToTempFile(widget.assetPath);
    }
  }

  Future<String> _copyAssetPdfToTempFile(String assetPath) async {
    final bytes = await rootBundle.load(assetPath);
    final tempDir = await getTemporaryDirectory();
    final filename = assetPath.split('/').last;
    final file = File('${tempDir.path}/$filename');
    final sizeFile = File('${file.path}.size');
    final expectedSize = bytes.lengthInBytes;

    if (await file.exists() && await sizeFile.exists()) {
      final cachedSize = int.tryParse(await sizeFile.readAsString());
      if (cachedSize == expectedSize && await file.length() == expectedSize) {
        return file.path;
      }
    }

    await file.writeAsBytes(
      bytes.buffer.asUint8List(bytes.offsetInBytes, bytes.lengthInBytes),
    );
    await sizeFile.writeAsString(expectedSize.toString());
    return file.path;
  }

  FitPolicy _nativeFitPolicy() {
    return switch (widget.fitPolicy) {
      AssetPdfFitPolicy.width => FitPolicy.WIDTH,
      AssetPdfFitPolicy.height => FitPolicy.HEIGHT,
      AssetPdfFitPolicy.both => FitPolicy.BOTH,
    };
  }

  Future<void> _allowTableRotation() async {
    await SystemChrome.setPreferredOrientations(const [
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);
    try {
      await _orientationChannel.invokeMethod<void>('allowTableRotation');
    } on MissingPluginException {
      // iOS and other platforms rely on SystemChrome and Info.plist.
    }
  }

  Future<void> _restorePortraitOrientation() async {
    await SystemChrome.setPreferredOrientations(const [
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    try {
      await _orientationChannel.invokeMethod<void>('restorePortrait');
    } on MissingPluginException {
      // iOS and other platforms rely on SystemChrome and Info.plist.
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!Platform.isAndroid && !Platform.isIOS) {
      return _PdfMessageView(
        title: widget.title,
        assetPath: widget.assetPath,
        message: 'PDF-visning er ikke tilgjengelig på denne plattformen.',
      );
    }

    return FutureBuilder<String>(
      future: _localPdfPath,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError || !snapshot.hasData) {
          return _PdfMessageView(
            title: widget.title,
            assetPath: widget.assetPath,
            message: 'Kunne ikke åpne PDF-en.',
          );
        }

        if (_viewerError != null) {
          return _PdfMessageView(
            title: widget.title,
            assetPath: widget.assetPath,
            message: _viewerError!,
          );
        }

        return PDFView(
          filePath: snapshot.data!,
          enableSwipe: true,
          swipeHorizontal: false,
          autoSpacing: true,
          pageFling: true,
          fitPolicy: _nativeFitPolicy(),
          onError: (error) {
            if (!mounted) return;
            setState(() {
              _viewerError = 'Kunne ikke vise PDF-en.';
            });
          },
          onPageError: (page, error) {
            if (!mounted) return;
            setState(() {
              _viewerError = 'Kunne ikke vise side ${page ?? ''}.';
            });
          },
        );
      },
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
