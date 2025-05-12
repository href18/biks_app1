import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ForkliftInspectionForm extends StatefulWidget {
  const ForkliftInspectionForm({super.key});

  @override
  _ForkliftInspectionFormState createState() => _ForkliftInspectionFormState();
}

class _ForkliftInspectionFormState extends State<ForkliftInspectionForm> {
  final Color navyBlue = const Color(0xFF001F3F);
  final Color accentColor = const Color(0xFF00B4D8);

  String truckType = '';
  String truckNumber = '';
  String weekNumber = '';
  DateTime selectedDate = DateTime.now();
  bool showPreview = false;

  late Map<String, Map<String, Map<String, bool>>> checks;
  String damageDescription = '';
  String repairDescription = '';
  String signature = '';

  @override
  void initState() {
    super.initState();
    checks = _createEmptyChecksMap();
    _loadSavedData();
  }

  Map<String, Map<String, Map<String, bool>>> _createEmptyChecksMap() {
    return {
      'Motor og chassis': {
        'Sjekk dieselnivå': _initDayMap(),
        'Sjekk kjoleveskenivå': _initDayMap(),
        'Sjekk oljenivå i motor': _initDayMap(),
        'Sjekk oljenivå i girkasse (hvis pellepinne)': _initDayMap(),
        'Sjekk olje i hydraulikktank': _initDayMap(),
        'Sjekk / etterfyll spylevæske': _initDayMap(),
        'Sjekk startbatteri': _initDayMap(),
      },
      'Elektrisk truck': {
        'Sjekk batteri (fyll veske etter ladning)': _initDayMap(),
      },
      'Hjul': {
        'Inspiser dekk, felger og hjulbolter': _initDayMap(),
      },
      'Sikkerhetsutstyr': {
        'Sjekk lys, lydutstyr og speil': _initDayMap(),
        'Funksjonstest drifts- og parkeringsbrems': _initDayMap(),
        'Funksjonstest styring og lofteinmetninger': _initDayMap(),
        'Sjekk truck for lekkasje, skader og mangler': _initDayMap(),
        'Sjekk brannslokker og førstehjelpsutstyr': _initDayMap(),
      },
      'Tilleggsutstyr': {
        'Kontrolleres iht. instruksjonsbok': _initDayMap(),
      },
      'Annet': {
        'Sjekk loftekjede og gaffler': _initDayMap(),
      },
      'Rengjøring': {
        'Er trucken ren og presentabel': _initDayMap(),
      },
    };
  }

  Map<String, bool> _initDayMap() {
    return {
      'Mon': false,
      'Tue': false,
      'Wed': false,
      'Thu': false,
      'Fri': false,
      'Sat': false,
      'Sun': false,
    };
  }

  List<String> _getLocalizedDaysOfWeek(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return l10n != null
        ? [
            l10n.monday,
            l10n.tuesday,
            l10n.wednesday,
            l10n.thursday,
            l10n.friday,
            l10n.saturday,
            l10n.sunday
          ]
        : ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
  }

  Future<void> _loadSavedData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      truckType = prefs.getString('truckType') ?? '';
      truckNumber = prefs.getString('truckNumber') ?? '';
      weekNumber = prefs.getString('weekNumber') ?? '';

      final savedDate = prefs.getString('selectedDate');
      if (savedDate != null) {
        selectedDate = DateTime.parse(savedDate);
      }

      // Initialize checks with default false values if null
      for (var category in checks.keys) {
        for (var task in checks[category]!.keys) {
          for (var day in checks[category]![task]!.keys) {
            final key = '$category-$task-$day';
            bool? savedValue = prefs.getBool(key);
            checks[category]![task]![day] = savedValue ?? false;
          }
        }
      }

      damageDescription = prefs.getString('damageDescription') ?? '';
      repairDescription = prefs.getString('repairDescription') ?? '';
      signature = prefs.getString('signature') ?? '';
    });
  }

  Future<void> _saveData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('truckType', truckType);
    await prefs.setString('truckNumber', truckNumber);
    await prefs.setString('weekNumber', weekNumber);
    await prefs.setString('selectedDate', selectedDate.toIso8601String());

    for (var category in checks.keys) {
      for (var task in checks[category]!.keys) {
        for (var day in checks[category]![task]!.keys) {
          final key = '$category-$task-$day';
          await prefs.setBool(key, checks[category]![task]![day]!);
        }
      }
    }

    await prefs.setString('damageDescription', damageDescription);
    await prefs.setString('repairDescription', repairDescription);
    await prefs.setString('signature', signature);
  }

  Widget _buildInputForm(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final days = _getLocalizedDaysOfWeek(context);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: navyBlue.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: navyBlue),
            ),
            child: Column(
              children: [
                Text(
                  l10n?.performedBy ?? 'Utføres av truckfører for oppstart',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: navyBlue,
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        decoration: InputDecoration(
                          labelText: l10n?.truckType ?? 'Truck type',
                          labelStyle: TextStyle(color: navyBlue),
                          border: const OutlineInputBorder(),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: navyBlue),
                          ),
                        ),
                        onChanged: (value) {
                          setState(() {
                            truckType = value;
                          });
                          _saveData();
                        },
                        controller: TextEditingController(text: truckType),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: TextField(
                        decoration: InputDecoration(
                          labelText: l10n?.truckNumber ?? 'Truck nr',
                          labelStyle: TextStyle(color: navyBlue),
                          border: const OutlineInputBorder(),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: navyBlue),
                          ),
                        ),
                        onChanged: (value) {
                          setState(() {
                            truckNumber = value;
                          });
                          _saveData();
                        },
                        controller: TextEditingController(text: truckNumber),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        decoration: InputDecoration(
                          labelText: l10n?.weekNumber ?? 'Uke nr',
                          labelStyle: TextStyle(color: navyBlue),
                          border: const OutlineInputBorder(),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: navyBlue),
                          ),
                        ),
                        keyboardType: TextInputType.number,
                        onChanged: (value) {
                          setState(() {
                            weekNumber = value;
                          });
                          _saveData();
                        },
                        controller: TextEditingController(text: weekNumber),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: InkWell(
                        onTap: () => _selectDate(context),
                        child: InputDecorator(
                          decoration: InputDecoration(
                            labelText: l10n?.date ?? 'Dato',
                            labelStyle: TextStyle(color: navyBlue),
                            border: const OutlineInputBorder(),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: navyBlue),
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(DateFormat('dd/MM/yyyy')
                                  .format(selectedDate)),
                              Icon(Icons.calendar_today, color: navyBlue),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: navyBlue.withOpacity(0.1),
              border: Border.all(color: navyBlue),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    SizedBox(
                        width: 150,
                        child: Text(l10n?.category ?? 'Kategori',
                            style: TextStyle(color: navyBlue))),
                    ...days.map((day) => Expanded(
                          child: Center(
                            child: Text(day, style: TextStyle(color: navyBlue)),
                          ),
                        )),
                  ],
                ),
                Divider(color: navyBlue),
                ...checks.entries.map((category) {
                  return Column(
                    children: [
                      ...category.value.entries.map((task) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(vertical: 4),
                          child: Row(
                            children: [
                              SizedBox(
                                width: 150,
                                child: Text(
                                  task.key,
                                  style: const TextStyle(fontSize: 12),
                                ),
                              ),
                              ...days.map((day) {
                                final currentValue = checks[category.key]
                                        ?[task.key]?[day] ??
                                    false;
                                return Expanded(
                                  child: Center(
                                    child: Theme(
                                      data: Theme.of(context).copyWith(
                                        unselectedWidgetColor: Colors.grey,
                                      ),
                                      child: Checkbox(
                                        value: currentValue,
                                        onChanged: (value) {
                                          setState(() {
                                            checks[category.key]![task.key]![
                                                day] = value ?? false;
                                          });
                                          _saveData();
                                        },
                                        activeColor: navyBlue,
                                        checkColor: Colors.white,
                                      ),
                                    ),
                                  ),
                                );
                              }),
                            ],
                          ),
                        );
                      }),
                      Divider(color: navyBlue),
                    ],
                  );
                }),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: navyBlue.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: navyBlue),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  l10n?.abnormalConditions ??
                      'UNORMALE FORHOLD MELDES OVERORDNET FOR VURDERING/UTBEDRING',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: navyBlue,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  l10n?.damageDescription ?? 'Skadet/mangler beskrivelse:',
                  style: TextStyle(color: navyBlue),
                ),
                TextField(
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: navyBlue),
                    ),
                    hintText: l10n?.describeDamage ??
                        'Beskriv eventuelle skader eller mangler',
                  ),
                  maxLines: 3,
                  onChanged: (value) {
                    setState(() {
                      damageDescription = value;
                    });
                    _saveData();
                  },
                  controller: TextEditingController(text: damageDescription),
                ),
                const SizedBox(height: 16),
                Text(
                  l10n?.repairDescription ?? 'Reparett:',
                  style: TextStyle(color: navyBlue),
                ),
                TextField(
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: navyBlue),
                    ),
                    hintText: l10n?.describeRepairs ??
                        'Beskriv eventuelle reparasjoner',
                  ),
                  maxLines: 2,
                  onChanged: (value) {
                    setState(() {
                      repairDescription = value;
                    });
                    _saveData();
                  },
                  controller: TextEditingController(text: repairDescription),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            decoration: InputDecoration(
              labelText: l10n?.signature ?? 'Signatur',
              labelStyle: TextStyle(color: navyBlue),
              border: const OutlineInputBorder(),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: navyBlue),
              ),
            ),
            onChanged: (value) {
              setState(() {
                signature = value;
              });
              _saveData();
            },
            controller: TextEditingController(text: signature),
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: ElevatedButton(
                  onPressed: () {
                    setState(() {
                      showPreview = true;
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: navyBlue.withOpacity(0.1),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: Text(
                    l10n?.preview ?? 'Forhåndsvisning',
                    style: const TextStyle(fontSize: 16, color: Colors.black),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: ElevatedButton(
                  onPressed: _sendEmail,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: navyBlue,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: Text(
                    l10n?.sendInspection ?? 'Send inspeksjon',
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSheetPreview(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final days = _getLocalizedDaysOfWeek(context);
    final now = DateTime.now();
    final formattedDate = DateFormat('dd/MM-yyyy').format(now);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            '# ${l10n?.dailyInspection ?? 'Daglig kontroll'} ${l10n?.truckType?.toLowerCase() ?? 'gaffeltruck'}',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: navyBlue,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            '**${l10n?.performedBy ?? 'Utføres av truckfører for oppstart'}**',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          Text(
            '## ${l10n?.truckType ?? 'Truck type'}: $truckType ${l10n?.truckNumber ?? 'Truck nr'}: $truckNumber ${l10n?.weekNumber ?? 'Uke nr'}: $weekNumber',
            style: const TextStyle(fontSize: 16),
          ),
          const SizedBox(height: 16),
          Container(
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey),
            ),
            child: Table(
              border: TableBorder.all(color: Colors.grey),
              columnWidths: const {
                0: FlexColumnWidth(2),
                1: FlexColumnWidth(3),
              },
              children: [
                TableRow(
                  decoration: BoxDecoration(color: navyBlue.withOpacity(0.1)),
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(l10n?.category ?? 'Kategori',
                          style: const TextStyle(fontWeight: FontWeight.bold)),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(l10n?.work ?? 'Arbeid',
                          style: const TextStyle(fontWeight: FontWeight.bold)),
                    ),
                    ...List.generate(
                        7,
                        (index) => Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Center(child: Text(days[index])),
                            )),
                  ],
                ),
                ...checks.entries.expand((category) {
                  return category.value.entries.map((task) {
                    return TableRow(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(category.key),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(task.key),
                        ),
                        ...days.map((day) {
                          return Center(
                            child:
                                (checks[category.key]?[task.key]?[day] ?? false)
                                    ? Icon(Icons.check, color: navyBlue)
                                    : const Text(''),
                          );
                        }),
                      ],
                    );
                  });
                }),
              ],
            ),
          ),
          const SizedBox(height: 24),
          Text(
            '**${l10n?.abnormalConditions ?? 'UNORMALE FORHOLD MELDES OVERORDNET FOR VURDERING/UTBEDRING'}**',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(
              '**${l10n?.damageDescription ?? 'Skadet/mangler beskrivelse:'}**'),
          Text(damageDescription.isEmpty
              ? '________________________'
              : damageDescription),
          const SizedBox(height: 16),
          Text('${l10n?.repairDescription ?? 'Reparett:'}'),
          Text(repairDescription.isEmpty
              ? '________________________'
              : repairDescription),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('${l10n?.date ?? 'Dato'}: $formattedDate'),
              Text('${l10n?.signature ?? 'Sign'}: $signature'),
            ],
          ),
          const SizedBox(height: 24),
          Text(
            l10n?.archiveNote ?? 'Ved ukens slutt skal utfylt ark arkiveres',
            style: const TextStyle(fontStyle: FontStyle.italic),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () {
              setState(() {
                showPreview = false;
              });
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: navyBlue,
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
            child: Text(
              l10n?.backToForm ?? 'Tilbake til skjema',
              style: const TextStyle(fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: navyBlue,
              onPrimary: Colors.white,
              onSurface: Colors.black,
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: navyBlue,
              ),
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
        _saveData();
      });
    }
  }

  Future<void> _sendEmail() async {
    final l10n = AppLocalizations.of(context);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(l10n?.reportReady ?? 'Rapport klar for sending!'),
        backgroundColor: navyBlue,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(showPreview
            ? l10n?.preview ?? 'Forhåndsvisning'
            : l10n?.dailyInspection ?? 'Daglig kontroll'),
        backgroundColor: navyBlue,
        actions: [
          if (!showPreview)
            IconButton(
              icon: const Icon(Icons.send),
              onPressed: _sendEmail,
              color: Colors.white,
            ),
        ],
      ),
      body:
          showPreview ? _buildSheetPreview(context) : _buildInputForm(context),
    );
  }
}
