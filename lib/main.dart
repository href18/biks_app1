import 'package:biks/hydraulic_v2.dart';
import 'package:biks/l10n/app_localizations.dart';
import 'package:biks/models/equipment_type.dart';
import 'package:biks/models/lift.dart';
import 'package:biks/splash_screen.dart';
import 'package:biks/utils/external_link_launcher.dart';
import 'package:biks/views/daily_check.dart';
import 'package:biks/views/crane_plan_examples.dart';
import 'package:biks/views/lift_data_view.dart';
import 'package:biks/views/my_lifts.dart';
import 'package:biks/views/risk_assesment.dart';
import 'package:biks/views/type_control_truck.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:qr_flutter/qr_flutter.dart';

// --- Constants ---
final Uri _urlMS = Uri.parse('https://biks.no/medlem/innlogging/');
final Uri _course = Uri.parse('https://biks.no/kurs/');
final Uri _fireSafetyChecklist = Uri.parse(
    'https://brannvernforeningen.no/sertifisering/varme-arbeider/om-sertifiseringsordningen-og-varme-arbeider/sikkerhetsforskrift-og-sjekkliste-gjeldende-fra-1.1.2024');
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
      builder: (context, child) {
        final l10n = AppLocalizations.of(context);
        if (l10n != null) {
          EquipmentTypes.updateLocalizations(l10n);
          Lifts.updateLocalizations(l10n);
        }
        return child ?? const SizedBox.shrink();
      },
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
    final items = [
      _MenuItem(
        title: l10n?.dailyCheck ?? "Daily check",
        subtitle: 'Daglig kontroll og sjekklister',
        leadingWidget: Icon(
          Icons.check,
          color: theme.colorScheme.onPrimaryContainer,
          size: 24,
        ),
        action: () => _navigateWithAnimation(context, const DailyCheckScreen()),
      ),
      _MenuItem(
        title: l10n?.typeControl ?? "Type control",
        subtitle: 'Kontroll og dokumentasjon',
        leadingWidget: Icon(
          Icons.engineering,
          color: theme.colorScheme.onPrimaryContainer,
          size: 24,
        ),
        action: () =>
            _navigateWithAnimation(context, const TypeControlScreen()),
      ),
      _MenuItem(
        title: l10n?.riskAssessment ?? "Risikovurdering Truck",
        subtitle: 'Sikkerhetsvurdering før arbeid',
        leadingWidget: Icon(
          Icons.assignment_late,
          color: theme.colorScheme.onPrimaryContainer,
          size: 24,
        ),
        action: () =>
            _navigateWithAnimation(context, const RiskAssessmentScreen()),
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n?.inspectionsAndChecks ?? 'Inspections & Checks'),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
        children: [
          _AppMenuSection(
            title: l10n?.inspectionsAndChecks ?? 'Inspections & Checks',
            children: items.map((item) => _AppMenuTile(item: item)).toList(),
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
      final launched = await openExternalLink(url);
      if (!launched) {
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
    final theme = Theme.of(context);

    final menuItems = [
      _MenuItem(
        title: l10n?.courseMenu ?? 'Our courses',
        subtitle: 'Kurs og opplaering',
        leadingWidget: Icon(
          Icons.school,
          color: theme.colorScheme.onPrimaryContainer,
          size: 24,
        ),
        action: () => _launchUrl(_course),
      ),
      _MenuItem(
        title: l10n?.secondMenu ?? 'My pages',
        subtitle: 'Medlemssider og konto',
        leadingWidget: Icon(
          Icons.account_circle,
          color: theme.colorScheme.onPrimaryContainer,
          size: 24,
        ),
        action: () => _launchUrl(_urlMS),
      ),
      _MenuItem(
        title: l10n?.firstMenu ?? 'Lift calculator',
        subtitle: 'Beregning av loft og vinkler',
        leadingWidget: Image.asset(
          'lib/assets/icons/crane.png',
          width: 24,
          height: 24,
          color: theme.colorScheme.onPrimaryContainer,
        ),
        action: () => _navigateWithAnimation(const LiftingW()),
      ),
      _MenuItem(
        title: 'Kranplan',
        subtitle: 'Interaktiv plan for radius, bom og hinder',
        leadingWidget: Icon(
          Icons.precision_manufacturing_outlined,
          color: theme.colorScheme.onPrimaryContainer,
          size: 24,
        ),
        action: () => _navigateWithAnimation(const CranePlanExamplesPage()),
      ),
      _MenuItem(
        title: l10n?.liftingTable ?? 'Lifting chart',
        subtitle: 'Oppslag for tabeller og last',
        leadingWidget: Image.asset(
          'lib/assets/icons/chart.png',
          width: 24,
          height: 24,
          color: theme.colorScheme.onPrimaryContainer,
        ),
        action: () => _navigateWithAnimation(const LifttabellFinal()),
      ),
      _MenuItem(
        title: l10n?.myLifts ?? 'My lifts',
        subtitle: 'Historikk og lagrede loft',
        leadingWidget: Icon(
          Icons.history,
          color: theme.colorScheme.onPrimaryContainer,
          size: 24,
        ),
        action: () => _navigateWithAnimation(const Saver()),
      ),
      _MenuItem(
        title: l10n?.hydraulicCalculator ?? 'Hydraulic',
        subtitle: 'Hydraulikk, gjenger og slanger',
        leadingWidget: Icon(
          Icons.opacity,
          color: theme.colorScheme.onPrimaryContainer,
          size: 24,
        ),
        action: () => _navigateWithAnimation(const HydraulicHomeScreen()),
      ),
      _MenuItem(
        title: 'Strekkbelastning pr. stropp',
        subtitle: 'Oppslag for vinkel og stroppbelastning',
        leadingWidget: Icon(
          Icons.architecture_outlined,
          color: theme.colorScheme.onPrimaryContainer,
          size: 24,
        ),
        action: () =>
            _navigateWithAnimation(const SlingTensionCalculatorPage()),
      ),
      _MenuItem(
        title: l10n?.inspectionsAndChecks ?? "Inspections & Checks",
        subtitle: 'Daglig kontroll, typekontroll og risiko',
        leadingWidget: Icon(
          Icons.checklist_rtl_outlined,
          color: theme.colorScheme.onPrimaryContainer,
          size: 24,
        ),
        action: () => _navigateWithAnimation(const InspectionsMenuScreen()),
      ),
      _MenuItem(
        title: l10n?.hotWork ?? 'Hot Work',
        subtitle: 'Forskrift og sjekkliste',
        leadingWidget: Icon(
          Icons.folder_open,
          color: theme.colorScheme.onPrimaryContainer,
          size: 24,
        ),
        action: () => _launchUrl(_fireSafetyChecklist),
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
                  },
                ),
              ),
            ],
          ),
          SliverPadding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12),
            sliver: SliverList(
              delegate: SliverChildListDelegate.fixed([
                _AppMenuSection(
                  title: '',
                  children: menuItems
                      .map((item) => _AppMenuTile(item: item))
                      .toList(),
                ),
              ]),
            ),
          ),
        ],
      ),
      bottomNavigationBar: kIsWeb
          ? Container(
              height: 220,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.white,
                    Colors.white.withAlpha((0.9 * 255).round())
                  ],
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    l10n?.qrDownloadTitle ?? 'Last ned mobilversjon',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Column(
                        children: [
                          SizedBox(
                            height: 90,
                            width: 90,
                            child: QrImageView(
                              data:
                                  'https://play.google.com/store/apps/details?id=com.entellix.Biks&pcampaignid=web_share',
                              backgroundColor: Colors.white,
                              gapless: true,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            l10n?.qrAndroidLabel ?? 'Android (Play Store)',
                            style: const TextStyle(fontSize: 12),
                          ),
                        ],
                      ),
                      const SizedBox(width: 24),
                      Column(
                        children: [
                          SizedBox(
                            height: 90,
                            width: 90,
                            child: QrImageView(
                              data:
                                  'https://apps.apple.com/no/app/biks/id6502571502',
                              backgroundColor: Colors.white,
                              gapless: true,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            l10n?.qrIOSLabel ?? 'iPhone (App Store)',
                            style: const TextStyle(fontSize: 12),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12.0),
                    child: Text(
                      l10n?.qrDownloadHint ??
                          'Skann med telefonen for å åpne BIKS i din butikk.',
                      style: const TextStyle(fontSize: 12),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    l10n?.createdBy ?? 'Created by Entellix.no',
                    style: TextStyle(
                      color: navyBlue.withAlpha((0.7 * 255).round()),
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            )
          : SafeArea(
              top: false,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 20),
                child: Text(
                  l10n?.createdBy ?? 'Created by Entellix.no',
                  textAlign: TextAlign.center,
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
  final String? subtitle;
  final Widget leadingWidget;
  final VoidCallback action;

  const _MenuItem({
    required this.title,
    this.subtitle,
    required this.leadingWidget,
    required this.action,
  });
}

class _AppMenuSection extends StatelessWidget {
  const _AppMenuSection({
    required this.title,
    required this.children,
  });

  final String title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final hasTitle = title.trim().isNotEmpty;
    return Card(
      elevation: 0,
      color: theme.colorScheme.surfaceContainerLowest,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      child: Padding(
        padding: EdgeInsets.fromLTRB(12, hasTitle ? 12 : 8, 12, 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (hasTitle) ...[
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
                child: Text(
                  title,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: navyBlue,
                  ),
                ),
              ),
              const SizedBox(height: 4),
            ],
            ...children,
          ],
        ),
      ),
    );
  }
}

class _AppMenuTile extends StatelessWidget {
  const _AppMenuTile({required this.item});

  final _MenuItem item;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Material(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(14),
        child: InkWell(
          borderRadius: BorderRadius.circular(14),
          onTap: item.action,
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: theme.colorScheme.primaryContainer,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  alignment: Alignment.center,
                  child: item.leadingWidget,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.title,
                        style: theme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w700,
                          color: navyBlue,
                        ),
                      ),
                      if (item.subtitle != null) ...[
                        const SizedBox(height: 2),
                        Text(
                          item.subtitle!,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                Icon(Icons.chevron_right, color: theme.colorScheme.outline),
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
      body: const _PdfUnavailableView(
        title: 'Løftetabell',
        assetPath: 'lib/assets/loftetabell_merged.pdf',
      ),
    );
  }
}

class _PdfUnavailableView extends StatelessWidget {
  const _PdfUnavailableView({
    required this.title,
    required this.assetPath,
  });

  final String title;
  final String assetPath;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.picture_as_pdf_outlined,
                  size: 48,
                  color: theme.colorScheme.primary,
                ),
                const SizedBox(height: 12),
                Text(
                  title,
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'PDF-visning er midlertidig avkoblet på iOS-testbuilden.',
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodyMedium,
                ),
                const SizedBox(height: 8),
                Text(
                  assetPath,
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
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
