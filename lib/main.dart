import 'package:Biks/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:Biks/views/saver.dart';
import 'package:Biks/views/lift_data_view.dart';
import 'package:pdfx/pdfx.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:app_tracking_transparency/app_tracking_transparency.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

void main() {
  runApp(ProviderScope(
    child: MaterialApp(
      locale: Locale(_locale),
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate
      ],
      supportedLocales: [Locale('en'), Locale('no')],
      title: 'Biks',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.from(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue.shade900)),
      home: SplashScreen(),
    ),
  ));
}

String _locale = 'no';

class SecondScreen extends StatefulWidget {
  const SecondScreen({super.key});

  @override
  State<SecondScreen> createState() => _SecondScreenState();
}

Future<void> launchLink(String url, {bool isNewTab = true}) async {
  LaunchMode.externalApplication;
  await launchUrl(
    Uri.parse(url),
    webOnlyWindowName: isNewTab ? '_blank' : '_self',
  );
}

class _SecondScreenState extends State<SecondScreen> {
  @override
  void initState() {
    super.initState();
    // Show tracking authorization dialog and ask for permission
    WidgetsFlutterBinding.ensureInitialized().addPostFrameCallback((_) async {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final String? uuid = prefs.getString('uuid');
      debugPrint('Read uuid: $uuid');

      if (uuid == null) {
        final status =
            await AppTrackingTransparency.requestTrackingAuthorization();
        debugPrint('Read status: $status');
        setState(() {});
        final uuid = await AppTrackingTransparency.getAdvertisingIdentifier();
        debugPrint('Read uuid: $uuid');
        await prefs.setString('uuid', uuid);
      }
    });
  }

  bool _isLanguage = true;
  void _changeLanguage() {
    setState(() {
      _isLanguage = !_isLanguage; // Toggle the flag
      if (_locale == 'no') {
        setState(() {
          _locale == 'en';
        });
      } else if (_locale == 'en') {
        setState(() {
          _locale == 'no';
        });
      }
    });
    SplashScreen();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () {
              _changeLanguage();
            },
            icon: Image.asset(
                _isLanguage
                    ? "lib/assets/images/NORf.png"
                    : "lib/assets/images/ENGf.png",
                height: 20,
                width: 30),
          )
        ],
        flexibleSpace: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.blue[900]!, Colors.blueGrey[900]!])),
        ),
        title: Image.asset(
            'lib/assets/images/Biks_industriopplaering_oransje.png',
            height: 45),
      ),
      body: Center(
        child: ListView(
          children: [
            _buildFeatureCard(
                icon: Icons.calculate,
                title: AppLocalizations.of(context)!.firstMenu,
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => LiftingW()));
                }),
            _buildFeatureCard(
                icon: Icons.home,
                title: AppLocalizations.of(context)!.secondMenu,
                onTap: () {
                  () {};
                }),
            _buildFeatureCard(
                icon: Icons.shopping_cart,
                title: AppLocalizations.of(context)!.courseMenu,
                onTap: () {}),
            _buildFeatureCard(
                icon: Icons.table_chart,
                title: AppLocalizations.of(context)!.liftingTable,
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => LifttabellFinal()));
                }),
            _buildFeatureCard(
                icon: Icons.table_chart,
                title: AppLocalizations.of(context)!.threadChart,
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => GTable()));
                }),
            _buildFeatureCard(
                icon: Icons.my_library_add,
                title: AppLocalizations.of(context)!.myLifts,
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => Saver()));
                }),
            Padding(
              padding: const EdgeInsets.only(top: 200),
              child: ListTile(
                title: Container(
                  height: 75,
                  width: 75,
                  child: Text(
                    "Laget av: Entellix.no",
                    style: TextStyle(fontSize: 10, color: Colors.black),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
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
    _controller = PdfControllerPinch(
        document: PdfDocument.openAsset("lib/assets/gjengetabell.pdf"));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          flexibleSpace: Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Colors.blue[900]!, Colors.blueGrey[900]!])),
          ),
          title: Text(
            AppLocalizations.of(context)!.threadChart,
            style: TextStyle(color: Colors.grey[200]),
          ),
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

class LiftingW extends StatefulWidget {
  const LiftingW({super.key});

  @override
  State<LiftingW> createState() => _LiftingWState();
}

class _LiftingWState extends State<LiftingW> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
              onPressed: () {
                showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: Text("Hvordan gjør du utregninger?"),
                        content: Text(
                          "Enhet er tonn, skal du regne ut med kilo skrives dette som desimal. Eksempel: 0.2 = 200kg",
                          maxLines: 3,
                        ),
                      );
                    });
              },
              icon: Icon(Icons.info)),
        ],
        title: Image.asset(
          "lib/assets/images/Biks_industriopplaering_oransje.png",
          height: 700,
          width: 70,
        ),
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
    _controller = PdfControllerPinch(
        document: PdfDocument.openAsset("lib/assets/ilovepdf_merged.pdf"));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          flexibleSpace: Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Colors.blue[900]!, Colors.blueGrey[900]!])),
          ),
          title: Text(
            AppLocalizations.of(context)!.liftingTable,
            style: TextStyle(color: Colors.grey[200]),
          ),
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

Widget _buildFeatureCard({
  required IconData icon,
  required String title,
  required VoidCallback onTap,
}) {
  return Card(
    color: Colors.blueGrey[20],
    elevation: 2,
    margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 5),
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(12),
    ),
    child: ListTile(
      leading: Icon(icon, color: Colors.black),
      title: Text(
        title,
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
          color: Colors.black,
        ),
      ),
      trailing:
          Icon(Icons.arrow_forward_ios, size: 16, color: Colors.blueGrey[800]),
      onTap: onTap,
    ),
  );
}
