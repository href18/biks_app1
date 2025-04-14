import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ForkliftInspectionForm extends StatefulWidget {
  const ForkliftInspectionForm({Key? key}) : super(key: key);

  @override
  _ForkliftInspectionFormState createState() => _ForkliftInspectionFormState();
}

class _ForkliftInspectionFormState extends State<ForkliftInspectionForm> {
  String truckType = '';
  String truckNumber = '';
  String weekNumber = '';
  DateTime selectedDate = DateTime.now();
  bool showPreview = false;

  final Map<String, Map<String, Map<String, bool>>> checks = {
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
      'Sjekk bramslokker og førstehjelpsutstyr': _initDayMap(),
    },
    'Tilleggsutstyr': {
      'Kontrolleres iht. instruksjonsbok': _initDayMap(),
    },
    'Annet': {
      'Sjekk loftekjede og gaffler': _initDayMap(),
    },
    'Rengjoring': {
      'Er trucken ren og presentabel': _initDayMap(),
    },
  };

  String damageDescription = '';
  String repairDescription = '';
  String signature = '';

  static Map<String, bool> _initDayMap() {
    return {
      'Ma': false,
      'Ti': false,
      'On': false,
      'To': false,
      'Fr': false,
      'Lø': false,
      'Sø': false,
    };
  }

  @override
  void initState() {
    super.initState();
    _loadSavedData();
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

      for (var category in checks.keys) {
        for (var task in checks[category]!.keys) {
          for (var day in checks[category]![task]!.keys) {
            final key = '$category-$task-$day';
            checks[category]![task]![day] = prefs.getBool(key) ?? false;
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

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Colors.orange,
              onPrimary: Colors.white,
              onSurface: Colors.black,
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                foregroundColor: Colors.orange,
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

  Widget _buildInputForm() {
    final days = ['Ma', 'Ti', 'On', 'To', 'Fr', 'Lø', 'Sø'];

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.orange.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.orange.withOpacity(0.3)),
            ),
            child: Column(
              children: [
                const Text(
                  'Utføres av truckforer for oppstart',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.orange,
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        decoration: InputDecoration(
                          labelText: 'Truck type',
                          labelStyle: const TextStyle(color: Colors.orange),
                          border: const OutlineInputBorder(),
                          focusedBorder: const OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.orange),
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
                          labelText: 'Truck nr',
                          labelStyle: const TextStyle(color: Colors.orange),
                          border: const OutlineInputBorder(),
                          focusedBorder: const OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.orange),
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
                          labelText: 'Uke nr',
                          labelStyle: const TextStyle(color: Colors.orange),
                          border: const OutlineInputBorder(),
                          focusedBorder: const OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.orange),
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
                            labelText: 'Dato',
                            labelStyle: const TextStyle(color: Colors.orange),
                            border: const OutlineInputBorder(),
                            focusedBorder: const OutlineInputBorder(
                              borderSide: BorderSide(color: Colors.orange),
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(DateFormat('dd/MM/yyyy')
                                  .format(selectedDate)),
                              const Icon(Icons.calendar_today,
                                  color: Colors.orange),
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
              color: Colors.orange.withOpacity(0.05),
              border: Border.all(color: Colors.orange.withOpacity(0.2)),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    const SizedBox(
                        width: 150,
                        child: Text('Kategori/Arbeid',
                            style: TextStyle(color: Colors.orange))),
                    ...days.map((day) => Expanded(
                          child: Center(
                            child: Text(day,
                                style: TextStyle(color: Colors.orange[700])),
                          ),
                        )),
                  ],
                ),
                const Divider(color: Colors.orange),
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
                                return Expanded(
                                  child: Center(
                                    child: Theme(
                                      data: Theme.of(context).copyWith(
                                        unselectedWidgetColor: Colors.grey,
                                      ),
                                      child: Checkbox(
                                        value: checks[category.key]![task.key]![
                                            day],
                                        onChanged: (value) {
                                          setState(() {
                                            checks[category.key]![task.key]![
                                                day] = value ?? false;
                                          });
                                          _saveData();
                                        },
                                        activeColor: Colors.orange,
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
                      const Divider(color: Colors.orange),
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
              color: Colors.orange.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.orange.withOpacity(0.3)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'UNORMALE FORHOLD MELDES OVERORDNET FOR VURDERING/UTBEDRING',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Colors.orange,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Skadet/mangler beskrivelse:',
                  style: TextStyle(color: Colors.orange),
                ),
                TextField(
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    focusedBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.orange),
                    ),
                    hintText: 'Beskriv eventuelle skader eller mangler',
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
                const Text(
                  'Reparett:',
                  style: TextStyle(color: Colors.orange),
                ),
                TextField(
                  decoration: InputDecoration(
                    border: const OutlineInputBorder(),
                    focusedBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.orange),
                    ),
                    hintText: 'Beskriv eventuelle reparasjoner',
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
              labelText: 'Signatur',
              labelStyle: const TextStyle(color: Colors.orange),
              border: const OutlineInputBorder(),
              focusedBorder: const OutlineInputBorder(
                borderSide: BorderSide(color: Colors.orange),
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
                    backgroundColor: Colors.orange.withOpacity(0.8),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: const Text(
                    'Forhåndsvisning',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: ElevatedButton(
                  onPressed: _sendEmail,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.orange,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: const Text(
                    'Send inspeksjon',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSheetPreview() {
    final days = ['Ma', 'Ti', 'On', 'To', 'Fr', 'Lø', 'Sø'];
    final now = DateTime.now();
    final formattedDate = DateFormat('dd/MM-yyyy').format(now);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            '# Daglig kontroll av gaffeltruck',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.orange[800],
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            '**Utføres av truckforer for oppstart**',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          Text(
            '## Truck type: $truckType Truck nr: $truckNumber Uke nr: $weekNumber',
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
                  decoration:
                      BoxDecoration(color: Colors.orange.withOpacity(0.2)),
                  children: [
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text('Kategori',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: Text('Arbeid',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                    ),
                    ...List.generate(
                        7,
                        (index) => Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Center(
                                  child: Text([
                                'Ma',
                                'Ti',
                                'On',
                                'To',
                                'Fr',
                                'Lø',
                                'Sø'
                              ][index])),
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
                            child: checks[category.key]![task.key]![day]!
                                ? Icon(Icons.check, color: Colors.orange)
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
          const Text(
            '**UNORMALE FORHOLD MELDES OVERORDNET FOR VURDERING/UTBEDRING**',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          const Text('**Skadet/mangler beskrivelse:**'),
          Text(damageDescription.isEmpty
              ? '________________________'
              : damageDescription),
          const SizedBox(height: 16),
          const Text('Reparett:'),
          Text(repairDescription.isEmpty
              ? '________________________'
              : repairDescription),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Dato: $formattedDate'),
              Text('Sign: $signature'),
            ],
          ),
          const SizedBox(height: 24),
          const Text(
            'Ved ukens slutt skal utfylt ark arkiveres',
            style: TextStyle(fontStyle: FontStyle.italic),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () {
              setState(() {
                showPreview = false;
              });
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.orange,
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
            child: const Text(
              'Tilbake til skjema',
              style: TextStyle(fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _sendEmail() async {
    // Email sending implementation would go here
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Rapport klar for sending!'),
        backgroundColor: Colors.orange[800],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(showPreview ? 'Forhåndsvisning' : 'Daglig kontroll'),
        backgroundColor: Colors.orange[800],
        actions: [
          if (!showPreview)
            IconButton(
              icon: const Icon(Icons.send),
              onPressed: _sendEmail,
              color: Colors.white,
            ),
        ],
      ),
      body: showPreview ? _buildSheetPreview() : _buildInputForm(),
    );
  }
}
