import 'package:biks/widgets/asset_pdf_viewer.dart';
import 'package:flutter/material.dart';

enum MyMenuItems {
  viewColorTable,
  viewLiftingTable,
  viewGjengeTabell,
}

class PdfMenuWidget extends StatelessWidget {
  const PdfMenuWidget({super.key});

  void _openPdf(
    BuildContext context,
    String assetPath,
    String title, {
    AssetPdfFitPolicy fitPolicy = AssetPdfFitPolicy.width,
  }) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => Scaffold(
          appBar: AppBar(title: Text(title)),
          body: AssetPdfViewer(
            title: title,
            assetPath: assetPath,
            fitPolicy: fitPolicy,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<MyMenuItems>(
      icon: const Icon(Icons.menu), // You can customize the icon
      onSelected: (MyMenuItems selectedItem) {
        const String pathForColorTable = "lib/assets/ilovepdf_merged.pdf";
        const String pathForLiftingTable = "lib/assets/loftetabell_merged.pdf";
        const String pathForGjengeTabell = "lib/assets/gjengetabell.pdf";

        switch (selectedItem) {
          case MyMenuItems.viewColorTable:
            _openPdf(context, pathForColorTable, "Fargetabell");
            break;
          case MyMenuItems.viewLiftingTable:
            _openPdf(context, pathForLiftingTable, "Løftetabell");
            break;
          case MyMenuItems.viewGjengeTabell:
            _openPdf(context, pathForGjengeTabell, "Gjengetabell");
            break;
        }
      },
      itemBuilder: (BuildContext context) => <PopupMenuEntry<MyMenuItems>>[
        const PopupMenuItem<MyMenuItems>(
          value: MyMenuItems.viewColorTable,
          child: Text('Fargetabell'),
        ),
        const PopupMenuItem<MyMenuItems>(
          value: MyMenuItems.viewLiftingTable,
          child: Text('Løftetabell'),
        ),
        const PopupMenuItem<MyMenuItems>(
          value: MyMenuItems.viewGjengeTabell,
          child: Text('Gjengetabell'),
        ),
      ],
    );
  }
}
