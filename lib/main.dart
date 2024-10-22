import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:Biks/views/saver.dart';
import 'package:Biks/splash_screen.dart';
import 'package:Biks/views/lift_data_view.dart';
import 'package:pdfx/pdfx.dart';
import 'package:url_launcher/url_launcher.dart';



void main() {
  runApp(ProviderScope(
    child: MaterialApp(
      title: 'Biks',
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
      theme: ThemeData.from(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue.shade900)),
    ),
    
  ));
} 

class SecondScreen extends StatefulWidget {
  const SecondScreen({super.key});

  @override
  State<SecondScreen> createState() => _SecondScreenState();
}

Future<void> launchLink(String url, {bool isNewTab = true}) async {
  await launchUrl(
    Uri.parse(url),
    webOnlyWindowName: isNewTab ? '_blank' : '_self',
  );
}

class _SecondScreenState extends State<SecondScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.blueGrey[900]!, Colors.blue[900]!])),
        ),
        title: Image.asset('lib/assets/images/BIKS_industriopplaering_oransje.png', height: 45),
      ),
      body: ListView(
            padding: EdgeInsets.only(left: 20),
            children: [
              SizedBox(
                height: 0,
                child: DrawerHeader(
                  child: Image.asset("lib/assets/images/BIKS_industriopplaering_oransje.png"),
                ),
              ),
              ListTile(
                leading: Icon(Icons.calculate),
                title: Text("Løftekalkulator"),
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) => LiftingW()));
                },
              ),
              ListTile(
                leading: Icon(Icons.home),
                title: Text("Mine sider"),
                onTap: () {
                  launchLink("https://biks.no/medlem/innlogging/");
                },
              ),
              ListTile(
                leading: Icon(Icons.shopping_cart),
                title: Text("Kurs"),
                onTap: () {
                  launchLink("https://biks.no/kurs/");
                },
              ),
              ListTile(
                leading: Icon(Icons.table_chart),
                title: Text("Løftetabeller"),
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => LifttabellFinal()));
                },
              ),
              
              ListTile(title: Text("Gjengetabell"),leading: Icon(Icons.table_chart), onTap: () {
                Navigator.push(context,
                      MaterialPageRoute(builder: (context) => GTable()));
              },),
              ListTile(
                leading: Icon(Icons.iron),
                title: Text(("Mine løft")),
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => Saver()));
                },
              ),
              Padding(
                padding: const EdgeInsets.only(top: 200),
                child: ListTile(title: Image.asset("lib/assets/Entellix-.png", height: 75, width: 75,), onTap: () {
                  launchLink("https://entellix.no/");
                  },),
              )
            
            ],
            
          )
        );
  }
}


class GTable extends StatefulWidget {
  const GTable({super.key});

  @override
  State<GTable> createState() => _GTableState();
}

class _GTableState extends State<GTable> {
late PdfControllerPinch _controller;

  @override
  void initState() {
    super.initState();
    _controller  = PdfControllerPinch(document: PdfDocument.openAsset("lib/assets/gjengetabell.pdf"));
    
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(title: Text("Gjengetabell"),),
    body: _buildUI());
  }


Widget _buildUI () {
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


class LiftingW extends StatefulWidget {
  const LiftingW({super.key});

  @override
  State<LiftingW> createState() => _LiftingWState();
}

class _LiftingWState extends State<LiftingW> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(
      actions: [IconButton(onPressed: () {
          showDialog(context: context, builder: (context) {
            return AlertDialog(title: Text("Hvordan gjør du utregninger?"), content: Text("Enhet er tonn, skal du regne ut med kilo skrives dette som desimal. Eksempel: 0.2 = 200kg", maxLines: 3,),);
          });
        }, icon: Icon(Icons.info)),],
      title: Image.asset("lib/assets/images/BIKS_industriopplaering_oransje.png", height: 700, width: 70,),
      ),
    body: LiftDataView(),
    );
  }
}


class LifttabellFinal extends StatefulWidget {
   const LifttabellFinal({super.key});

  @override
  State<LifttabellFinal> createState() => LifttabellFinalState();
}

class LifttabellFinalState extends State<LifttabellFinal> {
late PdfControllerPinch _controller;

  @override
  void initState() {
    super.initState();
    _controller  = PdfControllerPinch(document: PdfDocument.openAsset("lib/assets/ilovepdf_merged.pdf"));
    
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(title: Text("Løftetabeller"),),
    body: _buildUI());
  }
  

Widget _buildUI () {
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