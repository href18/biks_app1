import 'package:biks/l10n/app_localizations.dart';
import 'package:biks/providers/database_provider.dart';
import 'package:biks/models/equipment_config.dart'; // Assuming EquipmentConfig model path
import 'package:biks/widgets/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:io'; // Required for File on mobile/desktop
import 'package:flutter/foundation.dart';
import 'dart:developer' as developer; // For logging

class Saver extends ConsumerWidget {
  // Renamed class for clarity if needed, or keep as Saver
  const Saver({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final configs = ref.watch(equipmentConfigFetcherProvider);

    return Scaffold(
        backgroundColor: Colors.grey[50],
        appBar: AppBar(
          title: Text(
            AppLocalizations.of(context)!.myLifts,
          ),
        ),
        body: Column(
          children: [
            if (kIsWeb)
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
                child: AppInfoBanner(text: l10n.webLiftsWarning),
              ),
            Expanded(
              child: switch (configs) {
                AsyncLoading() =>
                  const Center(child: CircularProgressIndicator()),
                AsyncError(:final error, :final stackTrace) => _WebAwareError(
                    error: error,
                    stackTrace: stackTrace,
                    l10n: l10n,
                  ),
                AsyncData(:final value) => value.isEmpty
                    ? AppEmptyState(
                        message: l10n.noLiftsSavedYet,
                        icon: Icons.history_toggle_off,
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.all(16),
                        scrollDirection: Axis.vertical,
                        itemCount: value.length,
                        itemBuilder: (context, index) {
                          final config = value[index];
                          return AppListTileCard(
                            leading: SizedBox(
                              width: 56,
                              height: 56,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: _LiftImageThumb(config: config),
                              ),
                            ),
                            onTap: () {
                              _showLiftDetailsDialog(context, config, l10n);
                            },
                            subtitle: Text(
                              "${config.datetime.day.toString().padLeft(2, '0')}/${config.datetime.month.toString().padLeft(2, '0')}/${config.datetime.year} ${config.datetime.hour.toString().padLeft(2, '0')}:${config.datetime.minute.toString().padLeft(2, '0')}",
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall
                                  ?.copyWith(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .onSurfaceVariant),
                            ),
                            title: RichText(
                              text: TextSpan(
                                style: DefaultTextStyle.of(context).style,
                                children: <TextSpan>[
                                  TextSpan(
                                      text: config.lift.displayName,
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold)),
                                  TextSpan(text: " ${l10n.withWeight} "),
                                  TextSpan(
                                      text: "${config.weight} ${l10n.ton}",
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold)),
                                  TextSpan(text: " ${l10n.med} "),
                                  TextSpan(
                                    text: config.equipmentType.displayName,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold),
                                  ),
                                ],
                              ),
                            ),
                            trailing: IconButton(
                                onPressed: () => _showDeleteConfirmationDialog(
                                    context, ref, config, l10n),
                                icon: const Icon(Icons.delete_outline,
                                    color: Colors.redAccent)),
                          );
                        },
                      ),
                _ => Center(child: Text(l10n.unexpectedState))
              },
            ),
          ],
        ));
  }

  void _showLiftDetailsDialog(
      BuildContext context, EquipmentConfig config, AppLocalizations l10n) {
    final textTheme = Theme.of(context).textTheme;
    final String formattedDateTime =
        "${config.datetime.day.toString().padLeft(2, '0')}/"
        "${config.datetime.month.toString().padLeft(2, '0')}/"
        "${config.datetime.year} "
        "${config.datetime.hour.toString().padLeft(2, '0')}:"
        "${config.datetime.minute.toString().padLeft(2, '0')}";

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(config.lift.displayName, style: textTheme.titleLarge),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: _LiftImageLarge(config: config),
              ),
              const SizedBox(height: 20),
              Text("${l10n.weightLabel}${config.weight} ${l10n.ton}",
                  style: textTheme.bodyLarge),
              const SizedBox(height: 10),
              Text(
                  "${l10n.equipmentTypeLabel}${config.equipmentType.displayName}",
                  style: textTheme.bodyLarge),
              const SizedBox(height: 10),
              Text("${l10n.dateTimeLabel}$formattedDateTime",
                  style: textTheme.bodyLarge),
              const SizedBox(height: 10),
              Text(
                  "${l10n.symmetryLabel}${config.isUnsymetric ? l10n.unsymmetricStatus : l10n.symmetricStatus}",
                  style: textTheme.bodyLarge),
              if (config.bestLiftData != null) ...[
                const SizedBox(height: 16),
                Divider(thickness: 1, color: Colors.grey[300]),
                const SizedBox(height: 16),
                Text(l10n.calculatedDetailsTitle,
                    style: textTheme.titleMedium
                        ?.copyWith(fontWeight: FontWeight.bold)),
                const SizedBox(height: 12),
                Text("${config.bestLiftData!.lift.parts} ${l10n.del}",
                    style: textTheme.bodyLarge), // e.g., "2 parts"
                const SizedBox(height: 10),
                Text("${l10n.medWLL} ${config.bestLiftData!.wll} ${l10n.ton}",
                    style: textTheme.bodyLarge), // e.g., "with WLL 5 ton"
                const SizedBox(height: 10),
                Text("${l10n.togd} ${config.bestLiftData!.diameter} ${l10n.mm}",
                    style: textTheme.bodyLarge), // e.g., "to Ø 10 mm"
              ],
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(MaterialLocalizations.of(context).okButtonLabel),
          ),
        ],
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
    );
  }

  void _showDeleteConfirmationDialog(BuildContext context, WidgetRef ref,
      EquipmentConfig config, AppLocalizations l10n) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(l10n
            .deleteLiftConfirmationTitle), // Add 'deleteLiftConfirmationTitle' to l10n
        content: Text(l10n.deleteLiftConfirmationContent(config.lift
            .displayName)), // Add 'deleteLiftConfirmationContent' to l10n (e.g., "Are you sure you want to delete the lift '{liftName}'?")
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l10n.no),
          ),
          TextButton(
            onPressed: () async {
              await ref
                  .read(equipmentConfigFetcherProvider.notifier)
                  .delete(config);
              if (context.mounted) {
                Navigator.of(context).pop();
              }
            },
            style: TextButton.styleFrom(foregroundColor: Colors.redAccent),
            child: Text(l10n.yes),
          ),
        ],
      ),
    );
  }
}

class _LiftImageThumb extends StatelessWidget {
  const _LiftImageThumb({required this.config});
  final EquipmentConfig config;

  @override
  Widget build(BuildContext context) {
    if (!kIsWeb &&
        config.userImagePath != null &&
        config.userImagePath!.isNotEmpty) {
      return Image.file(
        File(config.userImagePath!),
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          developer.log(
              "Error loading user image in list: ${config.userImagePath}",
              error: error,
              stackTrace: stackTrace,
              name: "MyLifts.ListTileImageError");
          return Image.asset(
            config.lift.image,
            fit: BoxFit.contain,
            errorBuilder: (_, __, ___) =>
                const Icon(Icons.broken_image, size: 40),
          );
        },
      );
    }

    return Image.asset(
      config.lift.image,
      fit: BoxFit.contain,
      errorBuilder: (_, __, ___) => const Icon(Icons.broken_image, size: 40),
    );
  }
}

class _LiftImageLarge extends StatelessWidget {
  const _LiftImageLarge({required this.config});
  final EquipmentConfig config;

  @override
  Widget build(BuildContext context) {
    if (!kIsWeb &&
        config.userImagePath != null &&
        config.userImagePath!.isNotEmpty) {
      return Image.file(
        File(config.userImagePath!),
        width: 150,
        height: 150,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          developer.log(
              "Error loading user image from path: ${config.userImagePath}",
              error: error,
              stackTrace: stackTrace,
              name: "MyLifts.ImageError");
          return Image.asset(
            config.lift.image,
            width: 120,
            height: 120,
            fit: BoxFit.contain,
            errorBuilder: (_, __, ___) =>
                Icon(Icons.broken_image, size: 100, color: Colors.grey[400]),
          );
        },
      );
    }

    return Image.asset(
      config.lift.image,
      width: 120,
      height: 120,
      fit: BoxFit.contain,
      errorBuilder: (_, __, ___) =>
          Icon(Icons.broken_image, size: 100, color: Colors.grey[400]),
    );
  }
}

class _WebAwareError extends StatelessWidget {
  const _WebAwareError(
      {required this.error, required this.stackTrace, required this.l10n});
  final Object error;
  final StackTrace stackTrace;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    final isMissingPathProvider =
        error.toString().contains('getApplicationDocumentsDirectory');
    final message = kIsWeb && isMissingPathProvider
        ? l10n.webLiftsWarning
        : '${l10n.errorFetchingLifts}:\n$error';
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Text(
          '$message\n\n${l10n.stackTraceLabel}:\n$stackTrace',
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
