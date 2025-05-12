import 'package:biks/models/equipment_config.dart';
import 'package:biks/models/equipment_type.dart';
import 'package:biks/models/lift.dart';
import 'package:biks/providers/database_provider.dart'
    show equipmentConfigFetcherProvider;
import 'package:biks/providers/equipment_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class LiftDataView extends ConsumerWidget {
  const LiftDataView({super.key});

  void showLiftDataDialog(BuildContext context, WidgetRef ref) async {
    final l10n = AppLocalizations.of(context);
    if (l10n == null || !context.mounted) return;

    final Widget widget;
    final bool success =
        await ref.read(equipmentProvider.notifier).findBestLiftData();

    if (!success) {
      widget = Text(l10n.weightTh);
    } else {
      ref.read(equipmentProvider.notifier).datetime = DateTime.now();
      ref.read(equipmentConfigFetcherProvider.notifier).insert(ref);
      final equipmentConfig = ref.read(equipmentProvider);

      widget = SizedBox(
        height: 150,
        width: 50,
        child: Column(
          children: [
            Image.asset(
              equipmentConfig.lift.image,
              width: 100,
              height: 100,
              errorBuilder: (context, error, stackTrace) =>
                  const Icon(Icons.error_outline),
            ),
            Text(
              [
                equipmentConfig.bestLiftData?.lift.parts,
                l10n.del,
                equipmentConfig.equipmentType.localeName,
                l10n.medWLL,
                equipmentConfig.bestLiftData?.wll?.toString(),
                l10n.togd,
                equipmentConfig.bestLiftData?.diameter?.toString(),
                l10n.mm
              ].where((s) => s != null).join(' '),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    if (context.mounted) {
      final equipment = ref.read(equipmentProvider);
      showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: Text(
            l10n.folgendeU(
              equipment.isUnsymetric.toString(),
              equipment.lift.localeName ?? '',
            ),
          ),
          content: widget,
        ),
        barrierDismissible: true,
      );
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    if (l10n == null) return const CircularProgressIndicator();

    final equipmentConfig = ref.watch(equipmentProvider);
    final padding = MediaQuery.paddingOf(context);

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        FocusScopeNode currentFocus = FocusScope.of(context);
        if (!currentFocus.hasPrimaryFocus &&
            currentFocus.focusedChild != null) {
          FocusManager.instance.primaryFocus?.unfocus();
        }
      },
      child: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 15),
                child: DropdownMenu<EquipmentType>(
                  width: 300,
                  initialSelection: equipmentConfig.equipmentType,
                  onSelected: (value) {
                    if (value != null) {
                      ref.read(equipmentProvider.notifier).equipmentType =
                          value;
                    }
                  },
                  dropdownMenuEntries: EquipmentTypes.allEquipmentTypes
                      .map((type) => DropdownMenuEntry(
                            value: type,
                            label: type.localeName ?? l10n.errorLaunching,
                          ))
                      .toList(),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 15),
                child: DropdownMenu<Lift>(
                  menuHeight: 500 - padding.top - padding.bottom,
                  width: 300,
                  initialSelection: equipmentConfig.lift,
                  onSelected: (value) {
                    if (value != null) {
                      ref.read(equipmentProvider.notifier).lift = value;
                    }
                  },
                  dropdownMenuEntries: Lifts.allLifts
                      .map(
                        (lift) => DropdownMenuEntry(
                          value: lift,
                          label: '${lift.localeName} (${lift.parts})',
                          leadingIcon: Image.asset(
                            lift.image,
                            height: 50,
                            width: 50,
                            errorBuilder: (context, error, stackTrace) =>
                                const Icon(Icons.error_outline),
                          ),
                        ),
                      )
                      .toList(),
                ),
              ),
              const Padding(padding: EdgeInsets.only(top: 15)),
              SizedBox(
                width: 300,
                child: TextField(
                  decoration: InputDecoration(
                    labelText: l10n.tons,
                    labelStyle: const TextStyle(color: Colors.black),
                    helperText: l10n.typeWeight,
                    border: const OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black),
                    ),
                    focusedBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black),
                    ),
                  ),
                  maxLength: 4,
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                    signed: false,
                  ),
                  inputFormatters: <TextInputFormatter>[
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
                  onSubmitted: (value) {
                    showLiftDataDialog(context, ref);
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8, left: 40),
                child: Center(
                  child: Row(
                    children: [
                      Text(l10n.unsymmetricLift),
                      Checkbox(
                        checkColor: Colors.white,
                        activeColor: Colors.orange[400],
                        value: equipmentConfig.isUnsymetric,
                        onChanged: (value) {
                          if (value != null) {
                            ref.read(equipmentProvider.notifier).isUnsymetric =
                                value;
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  foregroundColor: Colors.white,
                ),
                onPressed: () {
                  showLiftDataDialog(context, ref);
                },
                child: Text(l10n.pressResult),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
