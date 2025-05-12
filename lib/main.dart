import 'package:biks/splash_screen.dart';
import 'package:biks/views/daily_check.dart';
import 'package:biks/views/lift_data_view.dart';
import 'package:biks/views/my_lifts.dart';
import 'package:biks/views/type_control.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:pdfx/pdfx.dart';
import 'package:shared_preferences/shared_preferences.dart';

// --- Constants ---
final Uri _urlMS = Uri.parse('https://biks.no/medlem/innlogging/');
final Uri _course = Uri.parse('https://biks.no/kurs/');
final Color navyBlue = Color.fromRGBO(4, 33, 90, 1.0);
final Color accentColor = Color(0xFF00B4D8);

// --- Providers ---
final localeProvider = StateProvider<Locale>((ref) => const Locale('no'));

final sharedPreferencesProvider =
    FutureProvider<SharedPreferences>((ref) async {
  return await SharedPreferences.getInstance();
});

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentLocale = ref.watch(localeProvider);

    return MaterialApp(
      locale: currentLocale,
      home: const SplashScreen(),
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.light(
          primary: navyBlue,
          secondary: accentColor,
          surface: Colors.white,
          background: Colors.grey[50]!,
        ),
        cardTheme: CardTheme(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          margin: EdgeInsets.zero,
        ),
        appBarTheme: AppBarTheme(
          centerTitle: true,
          elevation: 0,
          backgroundColor: navyBlue,
          titleTextStyle: TextStyle(
            color: Colors.white,
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
          iconTheme: IconThemeData(color: Colors.white),
        ),
        pageTransitionsTheme: PageTransitionsTheme(
          builders: {
            TargetPlatform.android: FadeUpwardsPageTransitionsBuilder(),
            TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
          },
        ),
      ),
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
    );
  }
}

class SlidePageRoute extends PageRouteBuilder {
  final Widget page;

  SlidePageRoute({required this.page})
      : super(
          pageBuilder: (context, animation, secondaryAnimation) => page,
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            const begin = Offset(1.0, 0.0);
            const end = Offset.zero;
            const curve = Curves.easeInOut;

            var tween =
                Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
            var offsetAnimation = animation.drive(tween);

            return SlideTransition(position: offsetAnimation, child: child);
          },
          transitionDuration: const Duration(milliseconds: 300),
        );
}

class FadePageRoute extends PageRouteBuilder {
  final Widget page;

  FadePageRoute({required this.page})
      : super(
          pageBuilder: (context, animation, secondaryAnimation) => page,
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(
              opacity: CurvedAnimation(
                parent: animation,
                curve: Curves.easeInOut,
              ),
              child: child,
            );
          },
          transitionDuration: const Duration(milliseconds: 250),
        );
}

class ScalePageRoute extends PageRouteBuilder {
  final Widget page;

  ScalePageRoute({required this.page})
      : super(
          pageBuilder: (context, animation, secondaryAnimation) => page,
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return ScaleTransition(
              scale: Tween<double>(begin: 0.95, end: 1.0).animate(
                CurvedAnimation(
                  parent: animation,
                  curve: Curves.easeInOut,
                ),
              ),
              child: FadeTransition(
                opacity: animation,
                child: child,
              ),
            );
          },
          transitionDuration: const Duration(milliseconds: 350),
        );
}

class SecondScreen extends ConsumerStatefulWidget {
  const SecondScreen({super.key});

  @override
  ConsumerState<SecondScreen> createState() => _SecondScreenState();
}

class _SecondScreenState extends ConsumerState<SecondScreen> {
  Future<void> _launchUrl(Uri url) async {
    try {
      if (!await launchUrl(url, mode: LaunchMode.externalApplication)) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Could not launch URL'),
              behavior: SnackBarBehavior.floating,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          );
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error launching URL'),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        );
      }
    }
  }

  void _navigateWithAnimation(Widget page, {String animationType = 'slide'}) {
    switch (animationType) {
      case 'fade':
        Navigator.push(context, FadePageRoute(page: page));
        break;
      case 'scale':
        Navigator.push(context, ScalePageRoute(page: page));
        break;
      default:
        Navigator.push(context, SlidePageRoute(page: page));
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentLocale = ref.watch(localeProvider);
    final l10n = AppLocalizations.of(context);

    final menuItems = [
      _MenuItem(
        title: l10n?.firstMenu ?? 'Lift calculator',
        icon: Icons.calculate_outlined,
        action: () => _navigateWithAnimation(
          const LiftingW(),
          animationType: 'slide',
        ),
      ),
      _MenuItem(
        title: l10n?.secondMenu ?? 'My page',
        icon: Icons.person_outline,
        action: () => _launchUrl(_urlMS),
      ),
      _MenuItem(
        title: l10n?.courseMenu ?? 'Courses',
        icon: Icons.school_outlined,
        action: () => _launchUrl(_course),
      ),
      _MenuItem(
        title: l10n?.liftingTable ?? 'Lifting chart',
        icon: Icons.insert_chart_outlined,
        action: () => _navigateWithAnimation(
          const LifttabellFinal(),
          animationType: 'fade',
        ),
      ),
      _MenuItem(
        title: l10n?.threadChart ?? 'Thread chart',
        icon: Icons.settings_outlined,
        action: () => _navigateWithAnimation(
          const GTable(),
          animationType: 'fade',
        ),
      ),
      _MenuItem(
        title: l10n?.myLifts ?? 'My lifts',
        icon: Icons.history_outlined,
        action: () => _navigateWithAnimation(
          const Saver(),
          animationType: 'scale',
        ),
      ),
      _MenuItem(
        title: l10n?.dailyCheck ?? "Daily check",
        icon: Icons.checklist_outlined,
        action: () => _navigateWithAnimation(
          const ForkliftInspectionForm(),
          animationType: 'slide',
        ),
      ),
      _MenuItem(
        title: l10n?.typeControl ?? "Type control",
        icon: Icons.construction_outlined,
        action: () => _navigateWithAnimation(
          const TruckInspectionForm(),
          animationType: 'slide',
        ),
      ),
    ];

    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 120,
            flexibleSpace: FlexibleSpaceBar(
              title: Text("Biks"),
              centerTitle: true,
              background: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [navyBlue, accentColor],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
              ),
            ),
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 16),
                child: IconButton(
                  icon: Container(
                    padding: EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white),
                    ),
                    child: Image.asset(
                      currentLocale.languageCode == 'no'
                          ? "lib/assets/images/ENGf.png"
                          : "lib/assets/images/NORf.png",
                      height: 20,
                      width: 20,
                    ),
                  ),
                  onPressed: () => ref.read(localeProvider.notifier).state =
                      currentLocale.languageCode == 'no'
                          ? const Locale('en')
                          : const Locale('no'),
                ),
              ),
            ],
          ),
          SliverPadding(
            padding: EdgeInsets.all(20),
            sliver: SliverGrid(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 20,
                crossAxisSpacing: 20,
                childAspectRatio: 1.2,
              ),
              delegate: SliverChildBuilderDelegate(
                (context, index) => _ModernMenuCard(item: menuItems[index]),
                childCount: menuItems.length,
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        height: 80,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.white, Colors.white.withOpacity(0.9)],
          ),
        ),
        child: Center(
          child: Text(
            l10n?.createdBy ?? 'Created by Entellix.no',
            style: TextStyle(
              color: navyBlue.withOpacity(0.7),
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }
}

class _MenuItem {
  final String title;
  final IconData icon;
  final VoidCallback action;

  const _MenuItem({
    required this.title,
    required this.icon,
    required this.action,
  });
}

class _ModernMenuCard extends StatelessWidget {
  final _MenuItem item;

  const _ModernMenuCard({required this.item});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: item.action,
        splashColor: accentColor.withOpacity(0.2),
        highlightColor: accentColor.withOpacity(0.1),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                navyBlue.withOpacity(0.8),
                navyBlue.withOpacity(0.95),
              ],
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  item.icon,
                  size: 32,
                  color: Colors.white.withOpacity(0.9),
                ),
                SizedBox(height: 12),
                Text(
                  item.title,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
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
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n?.liftingTable ?? 'Lifting chart'),
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
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n?.threadChart ?? 'Thread chart'),
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
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n?.firstMenu ?? 'Lift calculator'),
        actions: [
          IconButton(
            tooltip: l10n?.howTo ?? 'How to calculate',
            onPressed: () => showDialog(
              context: context,
              builder: (context) => Dialog(
                backgroundColor: Colors.transparent,
                insetPadding: EdgeInsets.all(20),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  padding: EdgeInsets.all(24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        l10n?.howTo ?? 'How to calculate',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: navyBlue,
                        ),
                      ),
                      SizedBox(height: 16),
                      Text(
                        l10n?.howToDescription ??
                            'The unit is tonnes. If you want to calculate in kilograms, write it as a decimal. Example: 0.2 = 200kg.',
                        style: TextStyle(fontSize: 16),
                      ),
                      SizedBox(height: 24),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: navyBlue,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          padding: EdgeInsets.symmetric(
                              horizontal: 24, vertical: 12),
                        ),
                        onPressed: () => Navigator.of(context).pop(),
                        child: Text(
                          MaterialLocalizations.of(context).okButtonLabel,
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            icon: Icon(Icons.info_outline, color: Colors.white),
          ),
        ],
      ),
      body: const LiftDataView(),
    );
  }
}
