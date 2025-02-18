import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:Biks/providers/database_provider.dart';

class Saver extends ConsumerWidget {
  const Saver({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final configs = ref.watch(equipmentConfigFetcherProvider);

    return Scaffold(
        backgroundColor: Colors.grey[200],
        appBar: AppBar(
          backgroundColor: Colors.blueGrey,
          centerTitle: true,
          elevation: 0,
          flexibleSpace: Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Colors.blue[900]!, Colors.blueGrey[900]!])),
          ),
          title: Text(
            "Mine løft",
            style: TextStyle(color: Colors.grey.shade200),
          ),
        ),
        body: switch (configs) {
          AsyncError(:final error) => Text('Error: $error'),
          AsyncData(:final value) => ListView.builder(
              scrollDirection: Axis.vertical,
              itemCount: value.length,
              itemBuilder: (context, index) {
                return Card(
                  child: ListTile(
                    subtitle: Text(
                        "${value[index].datetime.day}/${value[index].datetime.month}/${value[index].datetime.year} ${value[index].datetime.hour}:${value[index].datetime.minute}"),
                    title: Text(
                        "${value[index].lift.name} med vekt ${value[index].weight} med ${value[index].equipmentType}"),
                    leading: Text(
                      ("Løft nr: ${index + 1}"),
                    ),
                    trailing: IconButton(
                        onPressed: () {
                          showDialog(
                              context: context,
                              builder: (_) => AlertDialog(
                                    title: Text("Vil du slette dette løftet?"),
                                    actions: [
                                      TextButton(
                                          onPressed: () async {
                                            await ref
                                                .read(
                                                    equipmentConfigFetcherProvider
                                                        .notifier)
                                                .delete(value[index]);
                                            if (context.mounted) {
                                              Navigator.pop(context);
                                            }
                                          },
                                          child: Text(
                                            "Ja",
                                            style:
                                                TextStyle(color: Colors.black),
                                          )),
                                      TextButton(
                                          onPressed: () =>
                                              Navigator.pop(context),
                                          child: Text(
                                            "Nei",
                                            style:
                                                TextStyle(color: Colors.black),
                                          ))
                                    ],
                                  ));
                        },
                        icon: Icon(Icons.remove)),
                  ),
                );
              },
            ),
          _ => CircularProgressIndicator()
        });
  }
}
