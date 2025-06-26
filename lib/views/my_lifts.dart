import 'package:biks/l10n/app_localizations.dart';
import 'package:biks/providers/database_provider.dart';
import 'package:biks/models/equipment_config.dart'; // Assuming EquipmentConfig model path
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:io'; // Required for File
import 'dart:developer' as developer; // For logging

class Saver extends ConsumerWidget {
  // Renamed class for clarity if needed, or keep as Saver
  const Saver({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final configs = ref.watch(equipmentConfigFetcherProvider);

    return Scaffold(
        backgroundColor:
            Colors.grey[200], // Keeping the scaffold background as is
        appBar: AppBar(
          // The AppBar will now inherit its style from the global AppBarTheme.
          // This includes the navyBlue background (0xFF040D3C), white title text, and white icons.
          title: Text(
            AppLocalizations.of(context)!.myLifts,
          ),
        ),
        body: switch (configs) {
          AsyncLoading() => const Center(child: CircularProgressIndicator()),
          AsyncError(:final error, :final stackTrace) => Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(
                  '${l10n.errorFetchingLifts}:\n$error\n\n${l10n.stackTraceLabel}:\n$stackTrace', // You'll need to add 'errorFetchingLifts' and 'stackTraceLabel' to your l10n files
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          AsyncData(:final value) => value.isEmpty
              ? Center(
                  child: Text(
                    l10n.noLiftsSavedYet, // You'll need to add 'noLiftsSavedYet' to your l10n files
                    style: Theme.of(context).textTheme.headlineSmall,
                    textAlign: TextAlign.center,
                  ),
                )
              : ListView.builder(
                  scrollDirection: Axis.vertical,
                  itemCount: value.length,
                  itemBuilder: (context, index) {
                    final config = value[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      child: ListTile(
                        leading: SizedBox(
                          width: 56, // Standard leading width
                          height: 56, // Standard leading height
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(
                                8.0), // Optional: for rounded corners
                            child: (config.userImagePath != null &&
                                    config.userImagePath!.isNotEmpty)
                                ? Image.file(
                                    File(config.userImagePath!),
                                    fit: BoxFit.cover,
                                    errorBuilder: (context, error, stackTrace) {
                                      developer.log(
                                          "Error loading user image in list: ${config.userImagePath}",
                                          error: error,
                                          stackTrace: stackTrace,
                                          name: "MyLifts.ListTileImageError");
                                      return Image.asset(
                                        // Fallback to default lift image
                                        config.lift.image,
                                        fit: BoxFit.contain,
                                        errorBuilder: (_, __, ___) =>
                                            const Icon(Icons.broken_image,
                                                size: 40),
                                      );
                                    },
                                  )
                                : Image.asset(
                                    // Default lift image
                                    config.lift.image,
                                    fit: BoxFit.contain,
                                    errorBuilder: (_, __, ___) => const Icon(
                                        Icons.broken_image,
                                        size: 40),
                                  ),
                          ),
                        ),
                        onTap: () {
                          _showLiftDetailsDialog(context, config, l10n);
                        },
                        subtitle: Text(
                          "${config.datetime.day.toString().padLeft(2, '0')}/${config.datetime.month.toString().padLeft(2, '0')}/${config.datetime.year} ${config.datetime.hour.toString().padLeft(2, '0')}:${config.datetime.minute.toString().padLeft(2, '0')}",
                          style: TextStyle(color: Colors.grey[600]),
                        ),
                        title: RichText(
                          text: TextSpan(
                            style: DefaultTextStyle.of(context).style,
                            children: <TextSpan>[
                              TextSpan(
                                  text: config.lift.displayName,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold)),
                              TextSpan(
                                  text: " ${l10n.withWeight} ",
                                  style: const TextStyle(color: Colors.black)),
                              TextSpan(
                                  text: "${config.weight} ${l10n.ton}",
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold)),
                              TextSpan(
                                  text: " ${l10n.med} ",
                                  style: const TextStyle(color: Colors.black)),
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
                            icon: const Icon(Icons.delete,
                                color: Colors.redAccent)),
                      ),
                    );
                  },
                ),
          _ => Center(
              child: Text(l10n
                  .unexpectedState)) // You'll need to add 'unexpectedState' to your l10n files
        });
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
        title: Text(config.lift.displayName ?? '', style: textTheme.titleLarge),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: (config.userImagePath != null &&
                        config.userImagePath!.isNotEmpty)
                    ? Image.file(
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
                            // Fallback to default lift image on error
                            config.lift.image,
                            width: 120,
                            height: 120,
                            fit: BoxFit.contain,
                            errorBuilder: (_, __, ___) => Icon(
                                Icons.broken_image,
                                size: 100,
                                color: Colors.grey[400]),
                          );
                        },
                      )
                    : Image.asset(
                        // Default lift image if no user image path is set
                        config.lift.image,
                        width: 120,
                        height: 120,
                        fit: BoxFit.contain,
                        errorBuilder: (_, __, ___) => Icon(Icons.broken_image,
                            size: 100, color: Colors.grey[400]),
                      ),
              ),
              const SizedBox(height: 20),
              Text("${l10n.weightLabel}${config.weight} ${l10n.ton}",
                  style: textTheme.bodyLarge),
              const SizedBox(height: 10),
              Text(
                  "${l10n.equipmentTypeLabel}${config.equipmentType.displayName ?? ''}",
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

// Make sure you have a way to import EquipmentConfig. 
// If it's not in a separate file, you might need to define it or ensure it's accessible.
// For example, if it's defined in your providers/database_provider.dart or a models directory:
// import 'package:biks/models/equipment_config.dart'; 
// The diff includes a placeholder import for this.
