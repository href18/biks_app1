import 'package:biks/l10n/app_localizations.dart';
import 'package:biks/models/equipment_type.dart';
import 'package:biks/models/lift.dart';
import 'package:biks/models/lift_data.dart';
import 'package:biks/providers/database_provider.dart';
import 'package:biks/providers/equipment_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'dart:math' as math;
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
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.weightTh)),
      );
      return;
    }

    ref.read(equipmentProvider.notifier).datetime = DateTime.now();
    final equipmentConfig = ref.read(equipmentProvider);

    final bestLiftData = equipmentConfig.bestLiftData;
    final bool isUnsymmetric = equipmentConfig.isUnsymetric;
    final numberFormat = NumberFormat("0.0#");
    final factorFormat = NumberFormat("0.00");
    final double? workingLoadFactor =
        EquipmentConfig.workingLoadFactorForLift(equipmentConfig.lift);
    final double? tensionPerSling = (workingLoadFactor != null &&
            workingLoadFactor > 0 &&
            equipmentConfig.weight > 0)
        ? equipmentConfig.weight / workingLoadFactor
        : null;

    double? symmetricLimit =
        equipmentConfig.symmetricWeightLimit ?? bestLiftData?.weightLimit;
    double? unsymmetricLimit;

    if (bestLiftData is StrapLiftData) {
      unsymmetricLimit = bestLiftData.unsymetricWeightLimit;
    } else if (bestLiftData is ChainLiftData) {
      unsymmetricLimit = bestLiftData.unsymetricWeightLimit;
    }

    double? appliedLimit = equipmentConfig.appliedWeightLimit;
    double? referenceLimit = equipmentConfig.unsymmetricReferenceLimit;
    if (appliedLimit == null) {
      if (isUnsymmetric && symmetricLimit != null && unsymmetricLimit != null) {
        appliedLimit = math.min(symmetricLimit, unsymmetricLimit);
      } else {
        appliedLimit = symmetricLimit;
      }
    }

    referenceLimit ??= symmetricLimit;

    if (symmetricLimit == null && bestLiftData != null) {
      symmetricLimit = bestLiftData.weightLimit;
    }

    final double? reductionFactor = (isUnsymmetric &&
            referenceLimit != null &&
            referenceLimit > 0 &&
            appliedLimit != null)
        ? appliedLimit / referenceLimit
        : null;

    final String? strapGuidance = (isUnsymmetric &&
            bestLiftData != null &&
            bestLiftData.wll > 0 &&
            bestLiftData.lift.parts > 0)
        ? '${bestLiftData.lift.parts}x ${equipmentConfig.equipmentType.displayName} ${l10n.medWLL} ${numberFormat.format(bestLiftData.wll)} ${l10n.ton}'
        : null;

    if (!context.mounted) return;
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
        content: SingleChildScrollView(
          child: Column(
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
              _buildRecommendedEquipmentSummary(
                context: context,
                l10n: l10n,
                equipmentType: equipmentConfig.equipmentType.displayName,
                parts: bestLiftData?.lift.parts,
                wll: bestLiftData?.wll,
                diameter: bestLiftData?.diameter,
                numberFormat: numberFormat,
              ),
              const SizedBox(height: 16),
              _buildCapacitySummary(
                context: context,
                l10n: l10n,
                capacityFormat: numberFormat,
                factorFormat: factorFormat,
                symmetricLimit: symmetricLimit,
                appliedLimit: appliedLimit,
                reductionFactor: reductionFactor,
                referenceLimit: referenceLimit,
                isUnsymmetric: isUnsymmetric,
                unsymmetricGuidance: strapGuidance,
                workingLoadFactor: workingLoadFactor,
                tensionPerSling: tensionPerSling,
                enteredWeight: equipmentConfig.weight,
              ),
            ],
          ),
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
                if (context.mounted) Navigator.pop(context);
              } catch (e, s) {
                developer.log(
                    'Error calling or awaiting insert() from LiftDataView',
                    error: e,
                    stackTrace: s,
                    name: 'LiftDataView.showLiftDataDialog.Error');
                if (context.mounted) {
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

  Widget _buildRecommendedEquipmentSummary({
    required BuildContext context,
    required AppLocalizations l10n,
    required String equipmentType,
    required int? parts,
    required double? wll,
    required double? diameter,
    required NumberFormat numberFormat,
  }) {
    final theme = Theme.of(context);
    final isNorwegian = l10n.localeName.startsWith('no');

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: theme.colorScheme.outlineVariant,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            isNorwegian
                ? 'Anbefalt løfteutstyr'
                : 'Recommended lifting equipment',
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w700,
              color: theme.colorScheme.primary,
            ),
          ),
          const SizedBox(height: 14),
          _buildEquipmentDetailRow(
            context,
            label: isNorwegian ? 'Utstyrstype' : 'Equipment type',
            value: equipmentType,
          ),
          const Divider(height: 20),
          _buildEquipmentDetailRow(
            context,
            label: l10n.partsLabel,
            value: parts?.toString() ?? '–',
          ),
          const Divider(height: 20),
          _buildEquipmentDetailRow(
            context,
            label: l10n.wllLabel,
            value:
                wll == null ? '–' : '${numberFormat.format(wll)} ${l10n.ton}',
          ),
          const Divider(height: 20),
          _buildEquipmentDetailRow(
            context,
            label: l10n.diameterLabel,
            value: diameter == null
                ? '–'
                : 'Ø ${numberFormat.format(diameter)} ${l10n.mm}',
          ),
        ],
      ),
    );
  }

  Widget _buildEquipmentDetailRow(
    BuildContext context, {
    required String label,
    required String value,
  }) {
    final textTheme = Theme.of(context).textTheme;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Text(
            label,
            style: textTheme.bodyMedium,
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Text(
            value,
            textAlign: TextAlign.end,
            style: textTheme.bodyLarge?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCapacitySummary({
    required BuildContext context,
    required AppLocalizations l10n,
    required NumberFormat capacityFormat,
    required NumberFormat factorFormat,
    required double? symmetricLimit,
    required double? appliedLimit,
    required double? referenceLimit,
    required double? reductionFactor,
    required bool isUnsymmetric,
    required double? workingLoadFactor,
    required double? tensionPerSling,
    required double enteredWeight,
    String? unsymmetricGuidance,
  }) {
    String formatCapacity(double? value) {
      if (value == null) return '–';
      return '${capacityFormat.format(value)} ${l10n.ton}';
    }

    final bool showUnsymmetric = isUnsymmetric && appliedLimit != null;
    final bool showReduction = showUnsymmetric && reductionFactor != null;
    final theme = Theme.of(context);
    final unsymmetricLabel = _unsymmetricCapacityLabel(
      l10n,
      showUnsymmetric,
      reductionFactor,
    );

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.primary.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle(
            context,
            l10n.localeName.startsWith('no') ? 'Kapasitet' : 'Capacity',
          ),
          _buildCapacityRow(
            context,
            label: l10n.capacitySymmetricLabel,
            value: formatCapacity(symmetricLimit),
            emphasis: !showUnsymmetric,
          ),
          if (showUnsymmetric && referenceLimit != null) ...[
            const SizedBox(height: 8),
            _buildCapacityRow(
              context,
              label: l10n.capacityReferenceLabel,
              value: formatCapacity(referenceLimit),
            ),
          ],
          if (showUnsymmetric) ...[
            const SizedBox(height: 8),
            _buildCapacityRow(
              context,
              label: unsymmetricLabel,
              value: formatCapacity(appliedLimit),
              emphasis: true,
            ),
          ],
          if (showReduction) ...[
            const SizedBox(height: 8),
            _buildCapacityRow(
              context,
              label: l10n.capacityReductionFactorLabel,
              value: factorFormat.format(reductionFactor),
            ),
          ],
          if (workingLoadFactor != null && tensionPerSling != null) ...[
            const SizedBox(height: 16),
            _buildSectionTitle(
              context,
              l10n.localeName.startsWith('no')
                  ? 'Strekkbelastning'
                  : 'Tension load',
            ),
            _buildHighlightedMetric(
              context,
              label: _tensionPerSlingLabel(l10n),
              value: formatCapacity(tensionPerSling),
            ),
            const SizedBox(height: 12),
            _buildMiniMetricsRow(
              context,
              items: [
                (
                  _workingLoadFactorLabel(l10n),
                  factorFormat.format(workingLoadFactor)
                ),
                (
                  l10n.localeName.startsWith('no') ? 'Last' : 'Load',
                  '${capacityFormat.format(enteredWeight)} ${l10n.ton}'
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(
              '${capacityFormat.format(enteredWeight)} ${l10n.ton} / ${factorFormat.format(workingLoadFactor)} = ${capacityFormat.format(tensionPerSling)} ${l10n.ton}',
              style: theme.textTheme.bodySmall,
            ),
            const SizedBox(height: 12),
            _TensionTriangle(
              loadLabel: l10n.localeName.startsWith('no') ? 'Last' : 'Load',
              loadValue: '${capacityFormat.format(enteredWeight)} ${l10n.ton}',
              factorLabel: _workingLoadFactorLabel(l10n),
              factorValue: factorFormat.format(workingLoadFactor),
              tensionLabel: _tensionPerSlingLabel(l10n),
              tensionValue:
                  '${capacityFormat.format(tensionPerSling)} ${l10n.ton}',
            ),
          ],
          if (unsymmetricGuidance != null) ...[
            const SizedBox(height: 12),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: theme.colorScheme.surface,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: theme.colorScheme.primary.withValues(alpha: 0.12),
                ),
              ),
              child: Text(
                unsymmetricGuidance,
                style: theme.textTheme.bodyMedium,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildCapacityRow(
    BuildContext context, {
    required String label,
    required String value,
    bool emphasis = false,
  }) {
    final textTheme = Theme.of(context).textTheme;
    final TextStyle? labelStyle = emphasis
        ? textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold)
        : textTheme.bodyMedium;
    final TextStyle? valueStyle = emphasis
        ? textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.bold)
        : textTheme.bodyMedium;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(child: Text(label, style: labelStyle)),
        const SizedBox(width: 12),
        Text(value, style: valueStyle),
      ],
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        title,
        style: Theme.of(
          context,
        ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
      ),
    );
  }

  Widget _buildHighlightedMetric(
    BuildContext context, {
    required String label,
    required String value,
  }) {
    final theme = Theme.of(context);
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: theme.colorScheme.primary.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: theme.colorScheme.primary.withValues(alpha: 0.18),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: theme.textTheme.bodyMedium),
          const SizedBox(height: 4),
          Text(
            value,
            style: theme.textTheme.headlineSmall?.copyWith(
              color: theme.colorScheme.primary,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMiniMetricsRow(
    BuildContext context, {
    required List<(String, String)> items,
  }) {
    final theme = Theme.of(context);
    return Row(
      children: items
          .map(
            (item) => Expanded(
              child: Container(
                margin: EdgeInsets.only(
                  right: item == items.last ? 0 : 8,
                ),
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surface,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(item.$1, style: theme.textTheme.bodySmall),
                    const SizedBox(height: 2),
                    Text(
                      item.$2,
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          )
          .toList(),
    );
  }

  String _unsymmetricCapacityLabel(
    AppLocalizations l10n,
    bool showUnsymmetric,
    double? reductionFactor,
  ) {
    if (!showUnsymmetric) return l10n.capacityUnsymmetricLabel;

    if (reductionFactor != null && reductionFactor >= 1) {
      final baseLabel = l10n.capacityUnsymmetricLabel;
      final spaceIndex = baseLabel.indexOf(' ');

      if (spaceIndex != -1 && spaceIndex < baseLabel.length - 1) {
        final remainder = baseLabel.substring(spaceIndex + 1).trimLeft();
        if (remainder.isNotEmpty) {
          return _capitalizeFirstLetter(remainder);
        }
      }
    }

    return l10n.capacityUnsymmetricLabel;
  }

  String _capitalizeFirstLetter(String value) {
    for (int i = 0; i < value.length; i++) {
      final char = value[i];
      if (char.toUpperCase() != char.toLowerCase()) {
        final upper = char.toUpperCase();
        return '${value.substring(0, i)}$upper${value.substring(i + 1)}';
      }
    }
    return value;
  }

  String _workingLoadFactorLabel(AppLocalizations l10n) {
    return l10n.localeName.startsWith('no') ? 'Faktor' : 'Factor';
  }

  String _tensionPerSlingLabel(AppLocalizations l10n) {
    return l10n.localeName.startsWith('no')
        ? 'Strekkbelastning per stropp'
        : 'Tension per sling';
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
                                  type.displayName,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ))
                          .toList(),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
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
                                        '${lift.displayName} (${lift.parts})',
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
                      .withValues(alpha: 0.5),
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
              if (_selectedImagePath != null)
                Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Column(
                    children: [
                      Text(l10n.customImageLabel,
                          style: theme.textTheme.titleSmall),
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
                    ? l10n.addImageOptional
                    : l10n.changeImageOptional),
                onPressed: _pickImage,
                style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 12)),
              ),
              const SizedBox(height: 16),
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
                    activeThumbColor: theme.colorScheme.primary,
                    onChanged: (value) {
                      ref.read(equipmentProvider.notifier).isUnsymetric = value;
                    },
                  ),
                ],
              ),
              const SizedBox(height: 32),
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
              const SizedBox(height: 32),
              Text(
                l10n.previousLiftsTitle,
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
    final capacityFormat = NumberFormat('0.0#');
    final factorFormat = NumberFormat('0.00');

    return savedLiftsAsyncValue.when(
      data: (lifts) {
        if (lifts.isEmpty) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 20.0),
              child: Text(l10n.noSavedLifts),
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
            final workingLoadFactor =
                EquipmentConfig.workingLoadFactorForLift(liftEntry.lift);
            final tensionPerSling = (workingLoadFactor != null &&
                    workingLoadFactor > 0 &&
                    liftEntry.weight > 0)
                ? liftEntry.weight / workingLoadFactor
                : null;
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
                              liftEntry.lift.displayName,
                              style: theme.textTheme.titleMedium,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            const SizedBox(height: 4),
                            Text(
                                "${l10n.weightLabel}: ${liftEntry.weight.toStringAsFixed(2)} ${l10n.tons}",
                                style: theme.textTheme.bodyMedium),
                            Text("${l10n.partsLabel}: ${liftEntry.lift.parts}",
                                style: theme.textTheme.bodyMedium),
                            if ((liftEntry.bestLiftData?.wll ?? 0.0) > 0)
                              Text(
                                  "${l10n.wllLabel}: ${liftEntry.bestLiftData!.wll.toStringAsFixed(2)} ${l10n.tons}",
                                  style: theme.textTheme.bodyMedium),
                            if ((liftEntry.bestLiftData?.diameter ?? 0.0) > 0)
                              Text(
                                  "${l10n.diameterLabel}: ${liftEntry.bestLiftData!.diameter.toStringAsFixed(1)} mm",
                                  style: theme.textTheme.bodyMedium),
                            if (tensionPerSling != null)
                              Text(
                                "${_tensionPerSlingLabel(l10n)}: ${capacityFormat.format(tensionPerSling)} ${l10n.ton} (${_workingLoadFactorLabel(l10n)} ${factorFormat.format(workingLoadFactor)})",
                                style: theme.textTheme.bodyMedium,
                              ),
                            const SizedBox(height: 4),
                            Text(
                                "${l10n.dateLabel}: ${DateFormat.yMMMd(l10n.localeName).add_jm().format(liftEntry.datetime)}",
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

class _TensionTriangle extends StatelessWidget {
  final String loadLabel;
  final String loadValue;
  final String factorLabel;
  final String factorValue;
  final String tensionLabel;
  final String tensionValue;

  const _TensionTriangle({
    required this.loadLabel,
    required this.loadValue,
    required this.factorLabel,
    required this.factorValue,
    required this.tensionLabel,
    required this.tensionValue,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          loadLabel == 'Last'
              ? 'Trekant for strekkbelastning'
              : 'Tension triangle',
          style: theme.textTheme.titleSmall?.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 8),
        SizedBox(
          height: 190,
          width: double.infinity,
          child: Stack(
            children: [
              Positioned.fill(
                child: CustomPaint(
                  painter: _TrianglePainter(
                    color: theme.colorScheme.primary.withValues(alpha: 0.2),
                    strokeColor: theme.colorScheme.primary,
                  ),
                ),
              ),
              Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: Center(
                  child: _TriangleNode(
                    label: loadLabel,
                    value: loadValue,
                  ),
                ),
              ),
              Positioned(
                left: 0,
                bottom: 0,
                child: _TriangleNode(
                  label: factorLabel,
                  value: factorValue,
                  alignStart: true,
                ),
              ),
              Positioned(
                right: 0,
                bottom: 0,
                child: _TriangleNode(
                  label: tensionLabel,
                  value: tensionValue,
                  alignEnd: true,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _TriangleNode extends StatelessWidget {
  final String label;
  final String value;
  final bool alignStart;
  final bool alignEnd;

  const _TriangleNode({
    required this.label,
    required this.value,
    this.alignStart = false,
    this.alignEnd = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final textAlign = alignStart
        ? TextAlign.left
        : alignEnd
            ? TextAlign.right
            : TextAlign.center;

    return Container(
      constraints: const BoxConstraints(maxWidth: 140),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: theme.colorScheme.primary.withValues(alpha: 0.25),
        ),
      ),
      child: Column(
        crossAxisAlignment: alignStart
            ? CrossAxisAlignment.start
            : alignEnd
                ? CrossAxisAlignment.end
                : CrossAxisAlignment.center,
        children: [
          Text(
            label,
            textAlign: textAlign,
            style: theme.textTheme.bodySmall,
          ),
          const SizedBox(height: 2),
          Text(
            value,
            textAlign: textAlign,
            style: theme.textTheme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class _TrianglePainter extends CustomPainter {
  final Color color;
  final Color strokeColor;

  const _TrianglePainter({
    required this.color,
    required this.strokeColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final path = Path()
      ..moveTo(size.width / 2, 24)
      ..lineTo(40, size.height - 36)
      ..lineTo(size.width - 40, size.height - 36)
      ..close();

    final fillPaint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;
    final strokePaint = Paint()
      ..color = strokeColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    canvas.drawPath(path, fillPaint);
    canvas.drawPath(path, strokePaint);
  }

  @override
  bool shouldRepaint(covariant _TrianglePainter oldDelegate) {
    return oldDelegate.color != color || oldDelegate.strokeColor != strokeColor;
  }
}
