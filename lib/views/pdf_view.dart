import 'package:flutter/material.dart';

// For a real PDF viewer, you'll need to add a package to your pubspec.yaml,
// such as 'flutter_pdfview', 'syncfusion_flutter_pdfviewer', or 'pdfx' (which you have).
// Then import it, for example:
import 'package:pdfx/pdfx.dart'; // Example import for pdfx

// Enum to represent the different menu items for better type safety and readability
enum MyMenuItems {
  viewDocumentAlpha,
  viewDocumentBeta,
  optionOne,
  optionTwo,
  viewGjengeTabell,
  viewMergedDocument,
}

class PdfMenuWidget extends StatelessWidget {
  const PdfMenuWidget({super.key});

  // Function to show the dialog
  void _showPdfDialog(
      BuildContext context, String pdfPath, String documentTitle) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(documentTitle),
          content: SizedBox(
            // Adjust width and height as per your needs
            width: double.maxFinite,
            height: MediaQuery.of(context).size.height * 0.7,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                Text(
                  'The PDF viewer for "$pdfPath" would be displayed below.\n'
                  'You need to integrate a PDF viewing package.',
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                const Divider(),
                // --- PDF Viewer Integration ---
                // Replace the Icon below with your chosen PDF viewer.
                // Example using 'pdfx' package for PDFs loaded from assets:
                Expanded(
                  child: PdfView(
                    controller: PdfController(
                      document: PdfDocument.openAsset(pdfPath),
                    ),
                    // You can customize other PdfView parameters here:
                    // onPageChanged: (page) {},
                    // onDocumentLoaded: (document) {},
                    // onDocumentError: (error) {},
                    // scrollDirection: Axis.vertical,
                    // pageSnapping: true,
                    // backgroundDecoration: BoxDecoration(color: Colors.grey[200]),
                  ),
                ),
                // --- End PDF Viewer Integration ---
                // Original placeholder (remove if using a real viewer above):
                /*
                const Expanded(
                  child: Center(
                    child: Icon(Icons.picture_as_pdf,
                        size: 100, color: Colors.grey),
                  ),
                ),
                const Divider(),
                const SizedBox(height: 8),*/
                // Keep this note if you want to remind yourself or others about viewer integration
                const Text(
                  "Ensure the PDF viewer above is correctly configured.",
                  style: TextStyle(fontSize: 12, fontStyle: FontStyle.italic),
                  textAlign: TextAlign.center,
                ),
                // ---
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Close'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<MyMenuItems>(
      icon: const Icon(Icons.menu), // You can customize the icon
      onSelected: (MyMenuItems selectedItem) {
        // --- IMPORTANT ---
        // Replace these with your actual PDF paths
        // Using asset paths as an example, based on your pubspec.yaml
        const String pathForDocAlpha =
            "lib/assets/ilovepdf_merged.pdf"; // Example
        const String pathForDocBeta =
            "lib/assets/loftetabell_merged.pdf"; // Example
        const String pathForGjengeTabell = "lib/assets/gjengetabell.pdf";
        const String pathForAnotherDoc =
            "lib/assets/loftetabell_merged.pdf"; // Add your 4th PDF path

        // --- ----------- ---

        switch (selectedItem) {
          case MyMenuItems.viewDocumentAlpha:
            _showPdfDialog(context, pathForDocAlpha, "Document Alpha");
            break;
          case MyMenuItems.viewDocumentBeta:
            _showPdfDialog(context, pathForDocBeta, "Document Beta");
            break;
          case MyMenuItems.viewGjengeTabell:
            _showPdfDialog(context, pathForGjengeTabell, "Gjengetabell");
            break;
          case MyMenuItems
                .viewMergedDocument: // Renamed from viewDocumentGamma for clarity
            _showPdfDialog(
                context, pathForAnotherDoc, "Another Document"); // Update title
            break;
          case MyMenuItems.optionOne:
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Option One selected')),
            );
            // Implement action for Option One
            break;
          case MyMenuItems.optionTwo:
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Option Two selected')),
            );
            // Implement action for Option Two
            break;
        }
      },
      itemBuilder: (BuildContext context) => <PopupMenuEntry<MyMenuItems>>[
        const PopupMenuItem<MyMenuItems>(
          value: MyMenuItems.viewDocumentAlpha,
          child: Text('View Document Alpha (PDF)'),
        ),
        const PopupMenuItem<MyMenuItems>(
          value: MyMenuItems.viewDocumentBeta,
          child: Text('View Document Beta (PDF)'),
        ),
        const PopupMenuItem<MyMenuItems>(
          value: MyMenuItems.viewGjengeTabell,
          child: Text('View Gjengetabell (PDF)'),
        ),
        const PopupMenuItem<MyMenuItems>(
          value:
              MyMenuItems.viewMergedDocument, // Renamed from viewDocumentGamma
          child: Text('View Another Document (PDF)'), // Update text
        ),
        const PopupMenuDivider(),
        const PopupMenuItem<MyMenuItems>(
          value: MyMenuItems.optionOne,
          child: Text('Option One'),
        ),
        const PopupMenuItem<MyMenuItems>(
          value: MyMenuItems.optionTwo,
          child: Text('Option Two'),
        ),
      ],
    );
  }
}
