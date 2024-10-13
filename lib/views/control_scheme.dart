import 'package:flutter/material.dart';
import 'package:pdfx/pdfx.dart';

class ControlScheme extends StatefulWidget {
  const ControlScheme({super.key});

  @override
  State<ControlScheme> createState() => _ControlSchemeState();
}

class _ControlSchemeState extends State<ControlScheme> {
  late PdfControllerPinch _controller;

  @override
  void initState() {
    super.initState();
    _controller = PdfControllerPinch(
        document: PdfDocument.openAsset("lib/assets/images/dk_skjema.pdf"));
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Image.asset("lib/assets/images/biks-logo.png",
              height: 700, width: 70),
        ),
        body: _buildUI());
  }

  Widget _buildUI() {
    return Column(
      children: [
        _pdfView(),
      ],
    );
  }

  Widget _pdfView() {
    return Expanded(child: PdfViewPinch(controller: _controller));
  }
}
