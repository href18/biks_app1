import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pdfx/pdfx.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:app_tracking_transparency/app_tracking_transparency.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:Biks/splash_screen.dart';
import 'package:Biks/views/saver.dart';
import 'package:Biks/views/lift_data_view.dart';

void main() {
  runApp(ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        locale: Locale('en'), // Default locale
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        home: SplashScreen(),
        supportedLocales: [Locale('en'), Locale('no')],
        title: 'Biks',
        debugShowCheckedModeBanner: false,
        theme: ThemeData.from(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue.shade900),
        ));
  }
}

class SecondScreen extends StatefulWidget {
  const SecondScreen({super.key});

  @override
  State<SecondScreen> createState() => _SecondScreenState();
}

class _SecondScreenState extends State<SecondScreen> {
  Locale _locale = Locale('en');
  bool _isLanguage = true;

  @override
  void initState() {
    super.initState();
    // _initTracking();
  }

  // Future<void> _initTracking() async {
  //   final prefs = await SharedPreferences.getInstance();
  //   if (prefs.getString('uuid') == null) {
  //     final status =
  //         await AppTrackingTransparency.requestTrackingAuthorization();
  //     if (status == TrackingStatus.authorized) {
  //       final uuid = await AppTrackingTransparency.getAdvertisingIdentifier();
  //       await prefs.setString('uuid', uuid);
  //     }
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () => setState(() => _isLanguage = !_isLanguage),
            icon: Image.asset(
              _isLanguage
                  ? "lib/assets/images/NORf.png"
                  : "lib/assets/images/ENGf.png",
              height: 20,
              width: 30,
            ),
          )
        ],
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.blue[900]!, Colors.blueGrey[900]!],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
        ),
        title: Image.asset(
          'lib/assets/images/Biks_industriopplaering_oransje.png',
          height: 45,
        ),
      ),
      body: ListView(
        children: [
          _buildFeatureCard(
            icon: Icons.calculate,
            title: AppLocalizations.of(context)!.firstMenu,
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => LiftingW()),
            ),
          ),
          _buildFeatureCard(
            icon: Icons.home,
            title: AppLocalizations.of(context)!.secondMenu,
            onTap: () {},
          ),
          _buildFeatureCard(
            icon: Icons.shopping_cart,
            title: AppLocalizations.of(context)!.courseMenu,
            onTap: () {},
          ),
          _buildFeatureCard(
            icon: Icons.table_chart,
            title: AppLocalizations.of(context)!.liftingTable,
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => LifttabellFinal()),
            ),
          ),
          _buildFeatureCard(
            icon: Icons.table_chart,
            title: AppLocalizations.of(context)!.threadChart,
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => GTable()),
            ),
          ),
          _buildFeatureCard(
            icon: Icons.my_library_add,
            title: AppLocalizations.of(context)!.myLifts,
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => Saver()),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 200),
            child: Center(
              child: Text(
                "Laget av: Entellix.no",
                style: TextStyle(fontSize: 10, color: Colors.black),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class GTable extends StatelessWidget {
  final PdfControllerPinch _controller = PdfControllerPinch(
    document: PdfDocument.openAsset("lib/assets/gjengetabell.pdf"),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.blue[900]!, Colors.blueGrey[900]!],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
        ),
        title: Text(
          AppLocalizations.of(context)!.threadChart,
          style: TextStyle(color: Colors.grey[200]),
        ),
      ),
      body: PdfViewPinch(controller: _controller),
    );
  }
}

class LiftingW extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () => showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: Text(AppLocalizations.of(context)!.howTo),
                content: Text(
                  AppLocalizations.of(context)!.howTo,
                  maxLines: 4,
                ),
              ),
            ),
            icon: Icon(Icons.info),
          ),
        ],
        title: Image.asset(
          "lib/assets/images/Biks_industriopplaering_oransje.png",
          height: 45,
        ),
      ),
      body: LiftDataView(),
    );
  }
}

class LifttabellFinal extends StatelessWidget {
  final PdfControllerPinch _controller = PdfControllerPinch(
    document: PdfDocument.openAsset("lib/assets/ilovepdf_merged.pdf"),
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.blue[900]!, Colors.blueGrey[900]!],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
          ),
        ),
        title: Text(
          AppLocalizations.of(context)!.liftingTable,
          style: TextStyle(color: Colors.grey[200]),
        ),
      ),
      body: PdfViewPinch(controller: _controller),
    );
  }
}

Widget _buildFeatureCard({
  required IconData icon,
  required String title,
  required VoidCallback onTap,
}) {
  return Card(
    margin: EdgeInsets.symmetric(vertical: 8, horizontal: 5),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
    child: ListTile(
      leading: Icon(icon, color: Colors.black),
      title: Text(title,
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500)),
      trailing:
          Icon(Icons.arrow_forward_ios, size: 16, color: Colors.blueGrey[800]),
      onTap: onTap,
    ),
  );
}
