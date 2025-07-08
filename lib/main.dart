import 'package:biks/hydraulic_v2.dart';
import 'package:biks/l10n/app_localizations.dart';
import 'package:biks/models/equipment_type.dart';
import 'package:biks/models/lift.dart';
import 'package:biks/splash_screen.dart';
import 'package:biks/views/daily_check.dart';
import 'package:biks/views/lift_data_view.dart';
import 'package:biks/views/my_lifts.dart';
import 'package:biks/views/risk_assesment.dart';
import 'package:biks/views/typeControlTruck.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:pdfx/pdfx.dart';
import 'package:shared_preferences/shared_preferences.dart';

// --- Constants ---
final Uri _urlMS = Uri.parse('https://biks.no/medlem/innlogging/');
final Uri _course = Uri.parse('https://biks.no/kurs/');
final Color navyBlue = Color(0xFF040D3C); // Updated to new color
final Color accentColor = Color(0xFF00B4D8);

// --- Providers ---
final localeProvider = StateProvider<Locale>((ref) => const Locale('no'));

final sharedPreferencesProvider =
    FutureProvider<SharedPreferences>((ref) async {
  return await SharedPreferences.getInstance();
});

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final l10n = await AppLocalizations.delegate.load(const Locale('no'));

  EquipmentTypes.initialize(l10n);
  Lifts.initializeLocalizations(l10n); // Initialize Lifts localization

  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      locale: ref.watch(localeProvider),
      supportedLocales: AppLocalizations.supportedLocales,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      home: const SplashScreen(),
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        fontFamily: 'DM Sans', // Set DM Sans as the default font
        colorScheme: ColorScheme.light(
          primary: navyBlue,
          secondary: accentColor,
          surface: Colors
              .white, // Used for surfaces of components like Cards, Dialogs
          // The 'background' parameter in ColorScheme.light() is deprecated.
        ),
        scaffoldBackgroundColor:
            Colors.grey[50], // Sets default background for Scaffolds
        cardTheme: CardThemeData(
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

class InspectionsMenuScreen extends StatelessWidget {
  const InspectionsMenuScreen({super.key});

  void _navigateWithAnimation(BuildContext context, Widget page) {
    Navigator.push(context, SlidePageRoute(page: page));
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n?.inspectionsAndChecks ?? 'Inspections & Checks'),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
        children: [
          Card(
            margin: const EdgeInsets.symmetric(vertical: 6.0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(4.0),
            ),
            child: ListTile(
              leading:
                  Icon(Icons.check, color: theme.colorScheme.primary, size: 30),
              title: Text(
                l10n?.dailyCheck ?? "Daily check",
                style: theme.textTheme.titleMedium
                    ?.copyWith(fontWeight: FontWeight.bold, color: navyBlue),
              ),
              trailing:
                  Icon(Icons.chevron_right, color: navyBlue.withAlpha(150)),
              onTap: () =>
                  _navigateWithAnimation(context, const DailyCheckScreen()),
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            ),
          ),
          Card(
            margin: const EdgeInsets.symmetric(vertical: 6.0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(4.0),
            ),
            child: ListTile(
              leading: Icon(Icons.engineering,
                  color: theme.colorScheme.primary, size: 30),
              title: Text(
                l10n?.typeControl ?? "Type control",
                style: theme.textTheme.titleMedium
                    ?.copyWith(fontWeight: FontWeight.bold, color: navyBlue),
              ),
              trailing:
                  Icon(Icons.chevron_right, color: navyBlue.withAlpha(150)),
              onTap: () =>
                  _navigateWithAnimation(context, const TypeControlScreen()),
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            ),
          ),
          Card(
            margin: const EdgeInsets.symmetric(vertical: 6.0),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(4.0),
            ),
            child: ListTile(
              leading: Icon(Icons.assignment_late,
                  color: theme.colorScheme.primary, size: 30),
              title: Text(
                l10n?.riskAssessment ?? "Risikovurdering Truck",
                style: theme.textTheme.titleMedium
                    ?.copyWith(fontWeight: FontWeight.bold, color: navyBlue),
              ),
              trailing:
                  Icon(Icons.chevron_right, color: navyBlue.withAlpha(150)),
              onTap: () =>
                  _navigateWithAnimation(context, const RiskAssessmentScreen()),
              contentPadding:
                  const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            ),
          ),
        ],
      ),
    );
  }
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

  void _navigateWithAnimation(Widget page) {
    Navigator.push(context, SlidePageRoute(page: page));
  }

  @override
  Widget build(BuildContext context) {
    final currentLocale = ref.watch(localeProvider);
    final l10n = AppLocalizations.of(context);
    final theme = Theme.of(context); // Get theme for styling

    final menuItems = [
      _MenuItem(
        title: l10n?.firstMenu ?? 'Lift calculator',
        // Use Image.asset for the custom icon
        leadingWidget: Image.asset(
          'lib/assets/icons/crane.png', // Changed to crane.png
          width: 30,
          height: 30,
          color: theme.colorScheme.primary, // Apply theme color
        ),
        action: () => _navigateWithAnimation(const LiftingW()),
      ),
      _MenuItem(
        title: l10n?.secondMenu ?? 'My page',
        leadingWidget: Icon(
          Icons.account_circle,
          color: theme.colorScheme.primary,
          size: 30,
        ),
        action: () => _launchUrl(_urlMS),
      ),
      _MenuItem(
        title: l10n?.hydraulicCalculator ?? 'Hydraulic calculator',
        leadingWidget: Icon(
          Icons.opacity,
          color: theme.colorScheme.primary,
          size: 30,
        ),
        action: () => _navigateWithAnimation(const HydraulicHomeScreen()),
      ),
      _MenuItem(
        title: l10n?.courseMenu ?? 'Courses',
        leadingWidget: Icon(
          Icons.school,
          color: theme.colorScheme.primary,
          size: 30,
        ),
        action: () => _launchUrl(_course),
      ),
      _MenuItem(
        title: l10n?.liftingTable ?? 'Lifting chart',
        leadingWidget: Image.asset(
          'lib/assets/icons/chart.png', // Using your chart icon
          width: 30,
          height: 30,
          color: theme.colorScheme.primary,
        ),
        action: () => _navigateWithAnimation(const LifttabellFinal()),
      ),
      // _MenuItem(
      //   title: l10n?.threadChart ?? 'Thread chart',
      //   leadingWidget: Icon(
      //     Icons.settings_input_component,
      //     color: theme.colorScheme.primary,
      //     size: 30,
      //   ),
      //   action: () => _navigateWithAnimation(const threadChart()),
      // ),
      _MenuItem(
        title: l10n?.myLifts ?? 'My lifts',
        leadingWidget: Icon(
          Icons.history,
          color: theme.colorScheme.primary,
          size: 30,
        ),
        action: () => _navigateWithAnimation(const Saver()),
      ),
      _MenuItem(
        title: l10n?.inspectionsAndChecks ?? "Inspections & Checks",
        leadingWidget: Icon(
          Icons.checklist_rtl_outlined,
          color: theme.colorScheme.primary,
          size: 30,
        ),
        action: () => _navigateWithAnimation(const InspectionsMenuScreen()),
      ),
    ];

    return Scaffold(
      backgroundColor: Colors.grey[50],
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 105.0, // Increased height for logo when expanded
            pinned: true, // Keeps the app bar visible when scrolling
            backgroundColor: navyBlue, // Ensures collapsed app bar is navy blue
            flexibleSpace: FlexibleSpaceBar(
              title: Image.asset(
                'lib/assets/images/biks_logo.png',
                height: 35.0, // This is the approximate height when collapsed
                fit: BoxFit.contain,
              ),
              centerTitle: true, // Horizontally centers the logo
              titlePadding: EdgeInsets.only(
                  bottom: 16.0), // Positions logo in collapsed bar
              background: Container(
                color: navyBlue, // Solid navyBlue background
              ),
            ),
            actions: [
              // Moved actions to be a direct child of SliverAppBar
              Padding(
                padding: const EdgeInsets.only(right: 16.0),
                child: IconButton(
                  icon: Image.asset(
                    // The flag image is now the direct icon
                    currentLocale.languageCode == 'no'
                        ? "lib/assets/images/ENGf.png"
                        : "lib/assets/images/NORf.png",
                    height: 30, // Increased height for a bigger flag
                    width: 30, // Increased width for a bigger flag
                  ),
                  // IconButton's default padding will still provide a good tap area
                  onPressed: () {
                    final newLocale = currentLocale.languageCode == 'no'
                        ? const Locale('en')
                        : const Locale('no');
                    ref.read(localeProvider.notifier).state = newLocale;
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      final l10n = AppLocalizations.of(context);
                      if (l10n != null) {
                        Lifts.updateLocalizations(l10n);
                        EquipmentTypes.updateLocalizations(l10n);
                        if (mounted) setState(() {});
                      }
                    });
                  },
                ),
              ),
            ],
          ),
          SliverPadding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final item = menuItems[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 6.0),
                    shape: RoundedRectangleBorder(
                      // Sharpened corners for main menu items
                      borderRadius: BorderRadius.circular(4.0),
                    ),
                    child: ListTile(
                      leading: item.leadingWidget, // Use the widget directly
                      title: Text(
                        item.title,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.bold, // Made title bold
                          color: navyBlue, // Use the new primary color for text
                        ),
                      ),
                      trailing: Icon(Icons.chevron_right,
                          color: navyBlue.withAlpha((0.6 * 255)
                              .round())), // Use new primary color for trailing icon
                      onTap: item.action,
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 10),
                    ),
                  );
                },
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
            colors: [Colors.white, Colors.white.withAlpha((0.9 * 255).round())],
          ),
        ),
        child: Center(
          child: Text(
            l10n?.createdBy ?? 'Created by Entellix.no',
            style: TextStyle(
              color: navyBlue.withAlpha((0.7 * 255).round()),
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
  final Widget leadingWidget; // Changed from IconData to Widget
  final VoidCallback action;

  const _MenuItem({
    required this.title,
    required this.leadingWidget, // Updated constructor
    required this.action,
  });
}

// The _ModernMenuCard widget is no longer needed and can be removed.

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
          document: PdfDocument.openAsset("lib/assets/loftetabell_merged.pdf"),
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
                          color: navyBlue, // Updated color
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
                          backgroundColor: navyBlue, // Updated color
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
            icon: Icon(
              Icons.info,
              color: Colors.white, // To match the app bar icon color
            ),
          )
        ],
      ),
      body: const LiftDataView(),
    );
  }
}
