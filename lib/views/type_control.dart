import 'package:flutter/material.dart';
import 'package:pdfx/pdfx.dart';

class TruckInspectionForm extends StatefulWidget {
  const TruckInspectionForm({super.key});

  @override
  _TruckInspectionFormState createState() => _TruckInspectionFormState();
}

class _TruckInspectionFormState extends State<TruckInspectionForm> {
  final _formKey = GlobalKey<FormState>();

  // Form fields
  String _driverName = '';
  String _truckNumber = '';
  DateTime _inspectionDate = DateTime.now();
  String _odometerReading = '';

  // Inspection items
  Map<String, bool?> _inspectionItems = {
    'Lights (head, tail, brake, turn signals)': null,
    'Tires (pressure, tread, damage)': null,
    'Brakes (parking and service)': null,
    'Fluid levels (oil, coolant, brake, power steering)': null,
    'Horn': null,
    'Windshield and wipers': null,
    'Mirrors': null,
    'Seat belts': null,
    'Emergency equipment (fire extinguisher, triangles)': null,
    'No leaks (oil, fuel, coolant)': null,
    'Steering system': null,
    'Suspension system': null,
    'Exhaust system': null,
    'Coupling devices': null,
    'Cargo securement': null,
  };

  String _notes = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Truck Inspection Form'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Information
              const Text(
                'DAILY TRUCK INSPECTION',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),

              // Driver and Truck Info
              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Driver Name',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter driver name';
                  }
                  return null;
                },
                onSaved: (value) => _driverName = value!,
              ),
              const SizedBox(height: 10),

              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Truck Number',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter truck number';
                  }
                  return null;
                },
                onSaved: (value) => _truckNumber = value!,
              ),
              const SizedBox(height: 10),

              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      decoration: const InputDecoration(
                        labelText: 'Date',
                        border: OutlineInputBorder(),
                      ),
                      initialValue:
                          '${_inspectionDate.toLocal()}'.split(' ')[0],
                      readOnly: true,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.calendar_today),
                    onPressed: () async {
                      final DateTime? picked = await showDatePicker(
                        context: context,
                        initialDate: _inspectionDate,
                        firstDate: DateTime(2000),
                        lastDate: DateTime(2101),
                      );
                      if (picked != null && picked != _inspectionDate) {
                        setState(() {
                          _inspectionDate = picked;
                        });
                      }
                    },
                  ),
                ],
              ),
              const SizedBox(height: 10),

              TextFormField(
                decoration: const InputDecoration(
                  labelText: 'Odometer Reading',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter odometer reading';
                  }
                  return null;
                },
                onSaved: (value) => _odometerReading = value!,
              ),
              const SizedBox(height: 20),

              // Inspection Items
              const Text(
                'Inspection Items (Check if OK)',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),

              ..._inspectionItems.keys.map((item) {
                return Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(item),
                        ),
                        Checkbox(
                          value: _inspectionItems[item],
                          onChanged: (bool? value) {
                            setState(() {
                              _inspectionItems[item] = value;
                            });
                          },
                          tristate: true,
                        ),
                      ],
                    ),
                    const Divider(),
                  ],
                );
              }).toList(),

              // Notes Section
              const SizedBox(height: 20),
              const Text(
                'Notes',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              TextFormField(
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Enter any additional notes or defects found...',
                ),
                maxLines: 4,
                onChanged: (value) => _notes = value,
              ),

              // Submit Button
              const SizedBox(height: 20),
              Center(
                child: ElevatedButton(
                  onPressed: _submitForm,
                  child: const Text('Submit Inspection'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      // Check if all inspection items are checked
      bool allChecked = true;
      _inspectionItems.forEach((key, value) {
        if (value == null || value == false) {
          allChecked = false;
        }
      });

      if (!allChecked) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Incomplete Inspection'),
            content: const Text(
                'Please verify all inspection items before submitting.'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('OK'),
              ),
            ],
          ),
        );
        return;
      }

      // Form is valid and all items checked - process the data
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Inspection Submitted'),
          content: const Text('Thank you for completing the inspection.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('OK'),
            ),
          ],
        ),
      );

      // Here you would typically send the data to your backend
      print({
        'driverName': _driverName,
        'truckNumber': _truckNumber,
        'inspectionDate': _inspectionDate,
        'odometerReading': _odometerReading,
        'inspectionItems': _inspectionItems,
        'notes': _notes,
      });
    }
  }
}
