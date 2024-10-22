import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:Biks/models/equipment_config.dart';
import 'package:Biks/models/equipment_type.dart';
import 'package:Biks/models/lift.dart';
import 'package:Biks/providers/database_provider.dart';
import 'package:Biks/providers/equipment_provider.dart';

class LiftDataView extends ConsumerWidget {
  const LiftDataView({super.key});


  void showLiftDataDialog(BuildContext context, WidgetRef ref) async {
    final Widget widget;
    final bool success =
        await ref.read(equipmentProvider.notifier).findBestLiftData();
    if (!success) {
      widget = Text('Vekten er for høy.');
    } else {
      ref.read(equipmentProvider.notifier).datetime = DateTime.now();
      ref.read(equipmentConfigFetcherProvider.notifier).insert(ref);
      final EquipmentConfig equipmentConfig = ref.read(equipmentProvider);
      widget = SizedBox(
        height: 150,
        width: 50,
        child: Column(children: [
          Image.asset(
            ref.read(equipmentProvider).lift.image,
            width: 100,
            height: 100,
          ),
          Text(
              '${equipmentConfig.bestLiftData?.lift.parts} del ${equipmentConfig.equipmentType} med WLL = ${equipmentConfig.bestLiftData?.wll} tonn og diameter = ${equipmentConfig.bestLiftData?.diameter} mm'),
        ]),
      );
    }
    if (context.mounted) {
      showDialog(
          context: context,
          builder: (_) => AlertDialog(
              title: Text(
                  "Du trenger følgende utstyr for ${ref.read(equipmentProvider).lift.name}"),
              content: widget),
          barrierDismissible: true);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final EquipmentConfig equipmentConfig = ref.watch(equipmentProvider);
    final padding = MediaQuery.paddingOf(context);

    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () 
      {
        FocusScopeNode currentFocus = FocusScope.of(context);
        if (!currentFocus.hasPrimaryFocus && currentFocus.focusedChild != null)
        {
          FocusManager.instance.primaryFocus?.unfocus();
        }
      },
      child: Center(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 20),
              child: DropdownMenu<String>(
                  width: 300,
                  initialSelection: equipmentConfig.equipmentType,
                  onSelected: (value) {
                    ref.read(equipmentProvider.notifier).equipmentType = value!;
                  },
                  dropdownMenuEntries: EquipmentTypes.allEquipmentTypes
                      .map((type) => DropdownMenuEntry(
                            value: type,
                            label: type,
                          ))
                      .toList()),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 20),
              child: DropdownMenu<Lift>(
                  menuHeight: 500 - padding.top - padding.bottom, 
                  width: 300,
                  initialSelection: equipmentConfig.lift,
                  onSelected: (value) {
                    ref.read(equipmentProvider.notifier).lift = value!;
                  },
                  dropdownMenuEntries: Lifts.allLifts
                      .map(
                        (lift) => DropdownMenuEntry(
                            value: lift,
                            label: '${lift.name} (${lift.parts})',
                            leadingIcon: Image.asset(
                              lift.image,
                              height: 50,
                              width: 50,
                            )),
                      )
                      .toList()),
            ),
            const Padding(padding: EdgeInsets.only(top: 20)),
            SizedBox(
              width: 300,
              child: TextField(
                  decoration: InputDecoration(
                      labelText: "(Tonn)",
                      labelStyle: TextStyle(color: Colors.black),
                      helperText: ("Skriv inn vekt"),
                      border: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.black)),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.black),
                      )),
                  maxLength: 4,
                  keyboardType:
                      TextInputType.numberWithOptions(decimal: true, signed: false),
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.allow(RegExp(r"^[0-9,.]*$"))
                  ],
                  onChanged: (value) {
                    if (value.isNotEmpty) {
                      final double? newWeight =
                          double.tryParse(value.replaceAll(RegExp(r','), '.'));
                      if (newWeight != null) {
                        ref.read(equipmentProvider.notifier).weight = newWeight;
                      }
                    }
                  },
                  onSubmitted: (value) {
                    showLiftDataDialog(context, ref);
                  }),
            ),
            ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black, foregroundColor: Colors.white),
                onPressed: () {
                  showLiftDataDialog(context, ref);
                },
                child: const Text("Trykk her for resultat")),
          ],
        ))
      );
  }
}
