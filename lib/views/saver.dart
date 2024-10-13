import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loftetabell/providers/database_provider.dart';

class Saver extends ConsumerWidget {

  const Saver({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final configs = ref.watch(equipmentConfigFetcherProvider);

    return Scaffold(
        backgroundColor: Colors.grey[400],
        appBar: AppBar(
          backgroundColor: Colors.orange,
          title: Text("Mine løft"),
          centerTitle: true,
          elevation: 0,
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
                                                if (context.mounted){
                                            Navigator.pop(context);
                                                }
                                          },
                                          child: Text("Ja")),
                                      TextButton(
                                          onPressed: () =>
                                              Navigator.pop(context),
                                          child: Text("Nei"))
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
