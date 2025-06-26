import 'package:biks/l10n/app_localizations.dart';
import 'package:biks/models/equipment_type.dart';
import 'package:biks/models/lift.dart';
import 'package:biks/providers/database_provider.dart';
import 'package:biks/providers/equipment_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'dart:developer' as developer; // For logging
import 'package:biks/models/equipment_config.dart'; // For EquipmentConfig type
import 'package:intl/intl.dart'; // For date formatting

class LiftDataView extends ConsumerStatefulWidget {
  const LiftDataView({super.key});

  @override
  ConsumerState<LiftDataView> createState() => _LiftDataViewState();
}

class _LiftDataViewState extends ConsumerState<LiftDataView> {
  final _weightController = TextEditingController();
  final _focusNode = FocusNode();
  bool _keyboardVisible = false;
  String? _selectedImagePath; // To store the path of the picked image

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(_handleFocusChange);
  }

  @override
  void dispose() {
    _focusNode.removeListener(_handleFocusChange);
    _focusNode.dispose();
    _weightController.dispose();
    super.dispose();
  }

  void _handleFocusChange() {
    setState(() {
      _keyboardVisible = _focusNode.hasFocus;
    });
  }

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    XFile? image;
    final l10n = AppLocalizations.of(context)!;

    // Show a dialog to choose the source
    final ImageSource? source = await showDialog<ImageSource>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: Text(l10n.selectImageSourceTitle), // New l10n string
        actions: <Widget>[
          TextButton(
            child: Text(l10n.cameraButtonLabel), // New l10n string
            onPressed: () => Navigator.pop(context, ImageSource.camera),
          ),
          TextButton(
            child: Text(l10n.galleryButtonLabel), // New l10n string
            onPressed: () => Navigator.pop(context, ImageSource.gallery),
          ),
        ],
      ),
    );

    if (source == null) {
      developer.log('Image source selection cancelled.',
          name: 'LiftDataView._pickImage');
      return; // User dismissed the dialog or no source selected
    }

    developer.log('Attempting to pick image with source: $source',
        name: 'LiftDataView._pickImage');
    try {
      image = await picker.pickImage(source: source);
      if (image != null) {
        developer.log(
            'Image picked: path=${image.path}, name=${image.name}, mimeType=${image.mimeType}',
            name: 'LiftDataView._pickImage');
      } else {
        developer.log(
            'Image picker returned null for source: $source (User might have cancelled)',
            name: 'LiftDataView._pickImage');
      }
    } catch (e, s) {
      developer.log('Error picking image with source: $source',
          error: e, stackTrace: s, name: 'LiftDataView._pickImage');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content:
                  Text(l10n.imagePickerError)), // New l10n string for error
        );
      }
      image = null; // Ensure image is null if an error occurred
    }

    if (image != null) {
      // Ensure the path is not empty, though XFile.path should generally be reliable.
      if (image.path.isNotEmpty) {
        setState(() {
          _selectedImagePath = image!.path; // image is confirmed not null here
        });
        ref.read(equipmentProvider.notifier).userImagePath = image.path;
        developer.log('SetState with image path: ${image.path}',
            name: 'LiftDataView._pickImage.Success');
      } else {
        developer.log('Picked image has an empty path.',
            name: 'LiftDataView._pickImage.Warning');
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content: Text(l10n
                    .imagePickerPathError)), // You'll need to add this l10n string
          );
        }
      }
    }
  }

  void showLiftDataDialog(BuildContext context) async {
    final l10n = AppLocalizations.of(context);
    // Added a null check for l10n for robustness, though it should always be available.
    if (l10n == null || !mounted) return;

    final success =
        await ref.read(equipmentProvider.notifier).findBestLiftData();

    if (!success) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.weightTh)),
      );
      return;
    }

    ref.read(equipmentProvider.notifier).datetime = DateTime.now();
    final equipmentConfig = ref.read(equipmentProvider);

    if (!mounted) return;
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        titlePadding: const EdgeInsets.only(
          left: 24,
          right: 24,
          top: 24,
          bottom: 16,
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 24,
          vertical: 8,
        ),
        actionsPadding: const EdgeInsets.only(
          right: 16,
          bottom: 16,
        ),
        title: Stack(
          children: [
            Padding(
              padding:
                  const EdgeInsets.only(right: 24), // Space for close button
              child: Text(
                l10n.folgendeU(
                  equipmentConfig.isUnsymetric
                      ? l10n.unsymmetricStatus
                      : l10n.symmetricStatus,
                  equipmentConfig.lift.displayName,
                ),
              ),
            ),
            Positioned(
              right: 0,
              top: 0,
              child: IconButton(
                icon: const Icon(Icons.close),
                onPressed: () => Navigator.pop(context),
                splashRadius: 20,
                padding: EdgeInsets.zero,
                constraints:
                    const BoxConstraints(), // To make the tap area smaller
                tooltip: l10n.cancel, // Assuming l10n.cancel is defined
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Display user-selected image if available, otherwise default lift image
            (equipmentConfig.userImagePath != null &&
                    equipmentConfig.userImagePath!.isNotEmpty)
                ? Image.file(
                    File(equipmentConfig.userImagePath!),
                    width: 100,
                    height: 100,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Image.asset(
                      equipmentConfig.lift.image,
                      width: 100,
                      height: 100,
                      fit: BoxFit.contain,
                      errorBuilder: (_, __, ___) =>
                          const Icon(Icons.error_outline, size: 50),
                    ),
                  )
                : Image.asset(
                    equipmentConfig.lift.image,
                    width: 100,
                    height: 100,
                    fit: BoxFit.contain,
                    errorBuilder: (_, __, ___) =>
                        const Icon(Icons.error_outline, size: 50),
                  ),
            const SizedBox(height: 16),
            Text(
              [
                equipmentConfig.bestLiftData?.lift.parts,
                l10n.del,
                equipmentConfig.equipmentType.displayName,
                l10n.medWLL,
                equipmentConfig.bestLiftData?.wll.toString(),
                l10n.togd,
                equipmentConfig.bestLiftData?.diameter.toString(),
                l10n.mm
              ].where((s) => s != null).join(' '),
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ],
        ),
        actions: [
          FilledButton(
            onPressed: () async {
              developer.log(
                  'Save button in showLiftDataDialog pressed. Attempting to insert.',
                  name: 'LiftDataView.showLiftDataDialog');
              try {
                developer.log(
                    'Calling equipmentConfigFetcherProvider.notifier.insert()',
                    name: 'LiftDataView.showLiftDataDialog');
                await ref
                    .read(equipmentConfigFetcherProvider.notifier)
                    .insert();
                developer.log(
                    'equipmentConfigFetcherProvider.notifier.insert() call completed.',
                    name: 'LiftDataView.showLiftDataDialog');

                if (mounted) {
                  setState(() {
                    _selectedImagePath = null;
                    _weightController.clear();
                  });
                }
                ref.read(equipmentProvider.notifier).weight = 0;
                ref.read(equipmentProvider.notifier).userImagePath = null;
                if (mounted) Navigator.pop(context);
              } catch (e, s) {
                developer.log(
                    'Error calling or awaiting insert() from LiftDataView',
                    error: e,
                    stackTrace: s,
                    name: 'LiftDataView.showLiftDataDialog.Error');
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Error saving lift: $e')),
                  );
                }
              }
            },
            child: Text(l10n.saveLiftButtonLabel),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    if (l10n == null) return const Center(child: CircularProgressIndicator());

    final theme = Theme.of(context);
    final equipmentConfig = ref.watch(equipmentProvider);
    final mediaQuery = MediaQuery.of(context);
    final bottomPadding = mediaQuery.viewInsets.bottom;

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        body: SingleChildScrollView(
          padding: EdgeInsets.only(
            left: 16,
            right: 16,
            top: 16,
            bottom: _keyboardVisible ? bottomPadding + 16 : 16,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Equipment Type Dropdown
              Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<EquipmentType>(
                      isExpanded: true,
                      value: equipmentConfig.equipmentType,
                      icon: const Icon(Icons.arrow_drop_down),
                      borderRadius: BorderRadius.circular(12),
                      style: theme.textTheme.titleMedium,
                      onChanged: (value) {
                        if (value != null) {
                          ref.read(equipmentProvider.notifier).equipmentType =
                              value;
                        }
                      },
                      items: EquipmentTypes.allEquipmentTypes
                          .map((type) => DropdownMenuItem(
                                value: type,
                                child: Text(
                                  type.displayName, // Use displayName
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ))
                          .toList(),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Lift Type Dropdown
              Card(
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: DropdownButtonHideUnderline(
                    child: DropdownButton<Lift>(
                      isExpanded: true,
                      value: equipmentConfig.lift,
                      icon: const Icon(Icons.arrow_drop_down),
                      borderRadius: BorderRadius.circular(12),
                      style: theme.textTheme.titleMedium,
                      onChanged: (value) {
                        if (value != null) {
                          ref.read(equipmentProvider.notifier).lift = value;
                        }
                      },
                      items: Lifts.allLifts
                          .map((lift) => DropdownMenuItem(
                                value: lift,
                                child: Row(
                                  children: [
                                    Image.asset(
                                      lift.image,
                                      width: 40,
                                      height: 40,
                                      errorBuilder: (_, __, ___) => const Icon(
                                          Icons.error_outline,
                                          size: 20),
                                    ),
                                    const SizedBox(width: 12),
                                    Flexible(
                                      child: Text(
                                        '${lift.displayName} (${lift.parts})', // Use displayName
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                              ))
                          .toList(),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Weight Input
              TextField(
                controller: _weightController,
                focusNode: _focusNode,
                decoration: InputDecoration(
                  labelText: l10n.tons,
                  hintText: l10n.typeWeight,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: theme.dividerColor),
                  ),
                  filled: true,
                  fillColor: theme.colorScheme.surfaceContainerHighest
                      .withOpacity(0.5),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 14,
                  ),
                ),
                style: theme.textTheme.titleMedium,
                maxLength: 4,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                  signed: false,
                ),
                inputFormatters: [
                  FilteringTextInputFormatter.allow(RegExp(r"^[0-9,.]*$")),
                ],
                onChanged: (value) {
                  if (value.isNotEmpty) {
                    final newWeight =
                        double.tryParse(value.replaceAll(RegExp(r','), '.'));
                    if (newWeight != null) {
                      ref.read(equipmentProvider.notifier).weight = newWeight;
                    }
                  }
                },
                onSubmitted: (_) => showLiftDataDialog(context),
              ),
              const SizedBox(height: 16),

              // Optional Image Picker
              if (_selectedImagePath != null)
                Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Column(
                    children: [
                      Text(l10n?.customImageLabel ?? "Selected Image:",
                          style: theme.textTheme
                              .titleSmall), // Add "customImageLabel" to l10n
                      const SizedBox(height: 8),
                      Image.file(
                        File(_selectedImagePath!),
                        height: 100,
                        width: 100,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          developer.log(
                              "Error loading preview image from path: $_selectedImagePath",
                              error: error,
                              stackTrace: stackTrace,
                              name: "LiftDataView.PreviewImageError");
                          return Icon(Icons.broken_image,
                              size: 50, color: Colors.grey[400]);
                        },
                      ),
                      const SizedBox(height: 8),
                    ],
                  ),
                ),
              OutlinedButton.icon(
                icon: const Icon(Icons.image_search),
                label: Text(_selectedImagePath == null
                    ? (l10n?.addImageOptional ??
                        "Add Optional Image") // Add "addImageOptional" to l10n
                    : (l10n?.changeImageOptional ??
                        "Change Optional Image")), // Add "changeImageOptional" to l10n
                onPressed: _pickImage,
                style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 12)),
              ),
              const SizedBox(height: 16),

              // Unsymmetric Lift Toggle
              Row(
                children: [
                  Expanded(
                    child: Text(
                      l10n.unsymmetricLift,
                      style: theme.textTheme.bodyLarge,
                    ),
                  ),
                  Switch(
                    value: equipmentConfig.isUnsymetric,
                    activeColor: theme.colorScheme.primary,
                    onChanged: (value) {
                      ref.read(equipmentProvider.notifier).isUnsymetric = value;
                    },
                  ),
                ],
              ),
              const SizedBox(height: 32),

              // Calculate Button
              FilledButton(
                style: FilledButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () => showLiftDataDialog(context),
                child: Text(
                  l10n.pressResult,
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: theme.colorScheme.onPrimary,
                  ),
                ),
              ),
              const SizedBox(height: 32), // Spacer

              // Section for Previous Lifts
              Text(
                l10n.previousLiftsTitle, // Example: "Previous Lifts"
                style: theme.textTheme.headlineSmall,
              ),
              const SizedBox(height: 16),
              _buildSavedLiftsList(context, l10n, theme),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSavedLiftsList(
      BuildContext context, AppLocalizations l10n, ThemeData theme) {
    final savedLiftsAsyncValue = ref.watch(equipmentConfigFetcherProvider);

    return savedLiftsAsyncValue.when(
      data: (lifts) {
        if (lifts.isEmpty) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 20.0),
              child: Text(l10n.noSavedLifts), // Example: "No saved lifts yet."
            ),
          );
        }
        return ListView.builder(
          shrinkWrap:
              true, // Important when ListView is inside SingleChildScrollView
          physics:
              const NeverScrollableScrollPhysics(), // To prevent nested scrolling issues
          itemCount: lifts.length,
          itemBuilder: (context, index) {
            final liftEntry = lifts[index];
            Widget imageWidget;
            if (liftEntry.userImagePath != null &&
                liftEntry.userImagePath!.isNotEmpty) {
              imageWidget = Image.file(
                File(liftEntry.userImagePath!),
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Image.asset(
                  liftEntry.lift.image, // Fallback to original from Lift object
                  fit: BoxFit.contain,
                  errorBuilder: (_, __, ___) =>
                      const Icon(Icons.broken_image, size: 40),
                ),
              );
            } else {
              imageWidget = Image.asset(
                liftEntry.lift.image, // Original from Lift object
                fit: BoxFit.contain,
                errorBuilder: (_, __, ___) =>
                    const Icon(Icons.broken_image, size: 40),
              );
            }

            return InkWell(
              onTap: () =>
                  _showDeletePreviousLiftDialog(context, ref, liftEntry, l10n),
              child: Card(
                margin: const EdgeInsets.symmetric(vertical: 8),
                elevation: 2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: 80,
                        height: 80,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8.0),
                          child: imageWidget,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              liftEntry.lift
                                  .displayName, // Use displayName from Lift object
                              style: theme.textTheme.titleMedium,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 4),
                            Text(
                                "${l10n.weightLabel}: ${liftEntry.weight.toStringAsFixed(2)} ${l10n.tons}", // Added toStringAsFixed for consistent display
                                style: theme.textTheme.bodyMedium),
                            // Assuming lift.parts is always relevant if present
                            Text(
                                "${l10n.partsLabel}: ${liftEntry.lift.parts}", // Use parts from Lift object
                                style: theme.textTheme.bodyMedium),
                            if ((liftEntry.bestLiftData?.wll ?? 0.0) >
                                0) // Safely check WLL
                              Text(
                                  "${l10n.wllLabel}: ${liftEntry.bestLiftData!.wll.toStringAsFixed(2)} ${l10n.tons}", // Safe access due to condition
                                  style: theme.textTheme.bodyMedium),
                            if ((liftEntry.bestLiftData?.diameter ?? 0.0) >
                                0) // Safely check diameter
                              Text(
                                  "${l10n.diameterLabel}: ${liftEntry.bestLiftData!.diameter.toStringAsFixed(1)} mm", // Safe access due to condition
                                  style: theme.textTheme.bodyMedium),
                            const SizedBox(height: 4),
                            Text(
                                "${l10n.dateLabel}: ${DateFormat.yMMMd(l10n.localeName).add_jm().format(liftEntry.datetime)}", // Use datetime
                                style: theme.textTheme.bodySmall),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stackTrace) {
        developer.log("Error loading saved lifts",
            error: error,
            stackTrace: stackTrace,
            name: "LiftDataView.SavedLiftsError");
        return Center(
            child: Text(
                l10n.errorLoadingLifts)); // Example: "Error loading lifts."
      },
    );
  }

  void _showDeletePreviousLiftDialog(BuildContext context, WidgetRef ref,
      EquipmentConfig config, AppLocalizations l10n) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(l10n.deleteLiftConfirmationTitle),
        content:
            Text(l10n.deleteLiftConfirmationContent(config.lift.displayName)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l10n.no),
          ),
          TextButton(
            onPressed: () async {
              try {
                await ref
                    .read(equipmentConfigFetcherProvider.notifier)
                    .delete(config);
                if (context.mounted) {
                  Navigator.of(context).pop(); // Close the dialog
                }
              } catch (e) {
                developer.log("Error deleting lift from LiftDataView",
                    error: e, name: "LiftDataView.DeleteError");
                // Optionally show a snackbar for the error
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
