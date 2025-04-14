import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:Biks/models/equipment_type.dart';
import 'package:Biks/models/lift.dart';
import 'package:Biks/splash_screen.dart';
import 'package:Biks/views/daily_check.dart';
import 'package:Biks/views/lift_data_view.dart';
import 'package:Biks/views/saver.dart';
import 'package:Biks/views/type_control.dart';
import 'package:app_tracking_transparency/app_tracking_transparency.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:pdfx/pdfx.dart';
import 'package:shared_preferences/shared_preferences.dart';

// --- Providers ---
final localeProvider = StateProvider<Locale>((ref) => const Locale('no'));

final sharedPreferencesProvider =
    FutureProvider<SharedPreferences>((ref) async {
  return await SharedPreferences.getInstance();
});

// --- Constants ---
final Uri _urlMS = Uri.parse('https://biks.no/medlem/innlogging/');
final Uri _course = Uri.parse('https://biks.no/kurs/');

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    ProviderScope(
      child: MaterialApp(
        home: const SplashScreen(),
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue.shade900),
        ),
        localizationsDelegates: const [
          AppLocalizations.delegate,
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: AppLocalizations.supportedLocales,
        onGenerateRoute: (settings) {
          if (settings.name == '/home') {
            return MaterialPageRoute(builder: (_) => const SecondScreen());
          }
          return null;
        },
      ),
    ),
  );
}

class SecondScreen extends ConsumerStatefulWidget {
  const SecondScreen({super.key});

  @override
  ConsumerState<SecondScreen> createState() => _SecondScreenState();
}

class _SecondScreenState extends ConsumerState<SecondScreen> {
  final ScrollController _scrollController = ScrollController();

  Future<void> _launchUrl(Uri url) async {
    try {
      if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Could not launch URL')),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: ${e.toString()}')),
        );
      }
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final appLocalizations = AppLocalizations.of(context);
    final currentLocale = ref.watch(localeProvider);
    final theme = Theme.of(context);

    if (appLocalizations == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    final menuItems = [
      _MenuItem(
        icon: Icons.calculate_outlined,
        title: appLocalizations.firstMenu,
        color: Colors.blue.shade700 ?? Colors.blue,
        action: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const LiftingW()),
        ),
      ),
      _MenuItem(
        icon: Icons.home_outlined,
        title: appLocalizations.secondMenu,
        color: Colors.green.shade700 ?? Colors.green,
        action: () => _launchUrl(_urlMS),
      ),
      _MenuItem(
        icon: Icons.shopping_cart_outlined,
        title: appLocalizations.courseMenu,
        color: Colors.orange.shade700 ?? Colors.orange,
        action: () => _launchUrl(_course),
      ),
      _MenuItem(
        icon: Icons.table_chart_outlined,
        title: appLocalizations.liftingTable,
        color: Colors.purple.shade700 ?? Colors.purple,
        action: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const LifttabellFinal()),
        ),
      ),
      _MenuItem(
        icon: Icons.grid_on_outlined,
        title: appLocalizations.threadChart,
        color: Colors.red.shade700 ?? Colors.red,
        action: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const GTable()),
        ),
      ),
      _MenuItem(
        icon: Icons.library_books_outlined,
        title: appLocalizations.myLifts,
        color: Colors.teal.shade700 ?? Colors.teal,
        action: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const Saver()),
        ),
      ),
      _MenuItem(
        icon: Icons.checklist_outlined,
        title: "Daglig",
        color: Colors.indigo.shade700 ?? Colors.indigo,
        action: () => Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => const ForkliftInspectionForm()),
        ),
      ),
      _MenuItem(
        icon: Icons.build_outlined,
        title: "Type",
        color: Colors.amber.shade700 ?? Colors.amber,
        action: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const TruckInspectionForm()),
        ),
      ),
    ];

    return Scaffold(
      backgroundColor: theme.colorScheme.background,
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            controller: _scrollController,
            physics: const AlwaysScrollableScrollPhysics(),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: constraints.maxHeight,
              ),
              child: Column(
                children: [
                  // App Bar
                  Container(
                    height: 180,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Colors.blue.shade900 ?? Colors.blue,
                          Colors.blueGrey.shade800 ?? Colors.blueGrey,
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                    child: Stack(
                      children: [
                        Center(
                          child: Image.asset(
                            'lib/assets/images/Biks_industriopplaering_oransje.png',
                            height: 40,
                            filterQuality: FilterQuality.high,
                          ),
                        ),
                        Positioned(
                          right: 12,
                          top: MediaQuery.of(context).padding.top + 12,
                          child: IconButton(
                            onPressed: () =>
                                ref.read(localeProvider.notifier).state =
                                    currentLocale.languageCode == 'no'
                                        ? const Locale('en')
                                        : const Locale('no'),
                            icon: Image.asset(
                              currentLocale.languageCode == 'no'
                                  ? "lib/assets/images/ENGf.png"
                                  : "lib/assets/images/NORf.png",
                              height: 20,
                              width: 30,
                              filterQuality: FilterQuality.high,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Grid View
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisSpacing: 16,
                        crossAxisSpacing: 16,
                        childAspectRatio: 0.9,
                      ),
                      itemCount: menuItems.length,
                      itemBuilder: (context, index) =>
                          _MenuCard(item: menuItems[index]),
                    ),
                  ),

                  // Footer
                  Padding(
                    padding: const EdgeInsets.only(bottom: 32, top: 24),
                    child: Center(
                      child: Text(
                        appLocalizations.createdBy,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color:
                              theme.colorScheme.onBackground.withOpacity(0.6),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

class _MenuItem {
  final IconData icon;
  final String title;
  final Color color;
  final VoidCallback action;

  const _MenuItem({
    required this.icon,
    required this.title,
    required this.color,
    required this.action,
  });
}

class _MenuCard extends StatefulWidget {
  final _MenuItem item;

  const _MenuCard({required this.item});

  @override
  State<_MenuCard> createState() => _MenuCardState();
}

class _MenuCardState extends State<_MenuCard> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return Listener(
      onPointerDown: (_) => setState(() => _isPressed = true),
      onPointerUp: (_) => setState(() => _isPressed = false),
      onPointerCancel: (_) => setState(() => _isPressed = false),
      child: AnimatedScale(
        duration: const Duration(milliseconds: 100),
        scale: _isPressed ? 0.97 : 1.0,
        child: Card(
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            onTap: widget.item.action,
            splashColor: widget.item.color.withOpacity(0.2),
            highlightColor: widget.item.color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(16),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 60,
                    height: 60,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          widget.item.color,
                          Color.lerp(widget.item.color, Colors.white, 0.3) ??
                              widget.item.color,
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: widget.item.color.withOpacity(0.3),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Icon(
                      widget.item.icon,
                      size: 30,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Flexible(
                    child: Text(
                      widget.item.title,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: Theme.of(context).colorScheme.onSurface,
                            fontWeight: FontWeight.w600,
                          ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class LifttabellFinal extends StatelessWidget {
  const LifttabellFinal({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.liftingTable),
        backgroundColor: Colors.blue[900],
        foregroundColor: Colors.white,
      ),
      body: PdfViewPinch(
        controller: PdfControllerPinch(
          document: PdfDocument.openAsset("lib/assets/ilovepdf_merged.pdf"),
        ),
      ),
    );
  }
}

class GTable extends StatelessWidget {
  const GTable({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.threadChart),
        backgroundColor: Colors.blue[900],
        foregroundColor: Colors.white,
      ),
      body: PdfViewPinch(
        controller: PdfControllerPinch(
          document: PdfDocument.openAsset("lib/assets/gjengetabell.pdf"),
        ),
      ),
    );
  }
}

class LiftingW extends StatelessWidget {
  const LiftingW({super.key});

  @override
  Widget build(BuildContext context) {
    final appLocalizations = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue[900],
        foregroundColor: Colors.white,
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
          "lib/assets/images/Biks_industriopplaering_oransje.png",
          height: 45,
          filterQuality: FilterQuality.high,
        ),
        actions: [
          IconButton(
            tooltip: appLocalizations.howTo,
            onPressed: () => showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: Text(appLocalizations.howTo),
                content: SingleChildScrollView(
                  child: Text(appLocalizations.howToDescription),
                ),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: Text(
                        MaterialLocalizations.of(context).closeButtonLabel),
                  ),
                ],
              ),
            ),
            icon: const Icon(Icons.info_outline),
          ),
        ],
      ),
      body: const LiftDataView(),
    );
  }
}
