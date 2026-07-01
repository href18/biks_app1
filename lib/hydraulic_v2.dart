import 'package:biks/l10n/app_localizations.dart';
import 'package:biks/widgets/asset_pdf_viewer.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'dart:math';

import 'package:biks/views/hydraulic_conversion.dart';

// --- Home Screen for the Hydraulic Calculator Feature ---
class HydraulicHomeScreen extends StatelessWidget {
  const HydraulicHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final isNo = l10n?.localeName.startsWith('no') == true;
    final theme = Theme.of(context);
    final calculatorTools = <_HydraulicMenuItem>[
      _HydraulicMenuItem(
        title: l10n?.cylinderCalculator ?? 'Cylinder Calculator',
        subtitle: isNo ? 'Areal, kraft og hastighet' : 'Area, force, and speed',
        icon: Icons.settings_applications_outlined,
        page: const CylinderCalculatorPage(),
      ),
      _HydraulicMenuItem(
        title: l10n?.motorCalculator ?? 'Motor Calculator',
        subtitle: isNo
            ? 'Dreiemoment, effekt og turtall'
            : 'Torque, power, and speed',
        icon: Icons.sync_alt,
        page: const MotorPumpCalculatorPage(),
      ),
      _HydraulicMenuItem(
        title: l10n?.pumpCalculator ?? 'Pump Calculator',
        subtitle:
            isNo ? 'Volumstrøm og driftspunkt' : 'Flow and operating point',
        icon: Icons.water_damage_outlined,
        page: const MotorPumpCalculatorPage(isPumpMode: true),
      ),
      _HydraulicMenuItem(
        title: l10n?.pressureDropCalculator ?? 'Pressure Drop & Power',
        subtitle: isNo
            ? 'Trykkfall, effekttap og virkningsgrad'
            : 'Pressure drop, power loss, and efficiency',
        icon: Icons.arrow_downward_outlined,
        page: const PowerAndEfficiencyCalculatorPage(),
      ),
      _HydraulicMenuItem(
        title: l10n?.convertionTool ?? 'Hose & Pipe Conversion',
        subtitle: isNo
            ? 'DN, dash, tommer og millimeter'
            : 'DN, dash, inches, and millimeters',
        icon: Icons.swap_horiz,
        page: const ConverterHomePage(),
      ),
    ];
    final referenceTools = <_HydraulicMenuItem>[
      _HydraulicMenuItem(
        title: l10n?.threadChart ?? 'Thread Chart',
        subtitle: isNo
            ? 'Gjenger, forkortelser og måleguider'
            : 'Threads, abbreviations, and measuring guides',
        icon: Icons.settings_input_component_outlined,
        page: const ThreadChartPage(),
      ),
      _HydraulicMenuItem(
        title: isNo ? 'Hydraulikkslanger' : 'Hydraulic hoses',
        subtitle: isNo ? 'Dimensjoner og oppslag' : 'Dimensions and references',
        icon: Icons.hvac_outlined,
        page: const HydraulicHosesPage(),
      ),
    ];
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n?.hydraulicCalculator ?? 'Hydraulic Calculator'),
        backgroundColor: theme.colorScheme.primary,
        foregroundColor: theme.colorScheme.onPrimary,
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(12, 12, 12, 24),
        children: [
          _HydraulicMenuSection(
            title: isNo ? 'Kalkulatorer' : 'Calculators',
            children: calculatorTools
                .map((item) => _HydraulicMenuTile(item: item))
                .toList(),
          ),
          const SizedBox(height: 12),
          _HydraulicMenuSection(
            title: isNo ? 'Oppslagsverk' : 'References',
            children: referenceTools
                .map((item) => _HydraulicMenuTile(item: item))
                .toList(),
          ),
        ],
      ),
    );
  }
}

class _HydraulicMenuItem {
  const _HydraulicMenuItem({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.page,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final Widget page;
}

class _HydraulicMenuSection extends StatelessWidget {
  const _HydraulicMenuSection({
    required this.title,
    required this.children,
  });

  final String title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      elevation: 0,
      color: theme.colorScheme.surfaceContainerLowest,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(12, 12, 12, 8),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
              child: Text(
                title,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            const SizedBox(height: 4),
            ...children,
          ],
        ),
      ),
    );
  }
}

class _HydraulicMenuTile extends StatelessWidget {
  const _HydraulicMenuTile({required this.item});

  final _HydraulicMenuItem item;

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
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => item.page),
            );
          },
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
                  child: Icon(
                    item.icon,
                    color: theme.colorScheme.onPrimaryContainer,
                  ),
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
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        item.subtitle,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
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

class SlingTensionCalculatorPage extends StatelessWidget {
  const SlingTensionCalculatorPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: const Text('Strekkbelastning pr. stropp')),
      backgroundColor: theme.colorScheme.surfaceContainerLow,
      body: ListView(
        padding: const EdgeInsets.fromLTRB(12, 12, 12, 24),
        children: const [
          _SlingDiagramCard(),
          SizedBox(height: 12),
          _SlingReferenceTable(),
        ],
      ),
    );
  }
}

class _SlingDiagramCard extends StatelessWidget {
  const _SlingDiagramCard();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      elevation: 0,
      color: theme.colorScheme.surface,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: InteractiveViewer(
            minScale: 1,
            maxScale: 4,
            child: Image.asset(
              'lib/assets/images/reference/sling_tension_diagram.png',
              fit: BoxFit.fitWidth,
              width: double.infinity,
              semanticLabel: 'Tegning av strekkbelastning ved to-parts løft',
            ),
          ),
        ),
      ),
    );
  }
}

class _SlingReferenceTable extends StatelessWidget {
  const _SlingReferenceTable();

  static const rows = [
    _SlingReferenceRow(angle: '15°', load: '5.18 t', isWarning: false),
    _SlingReferenceRow(angle: '30°', load: '5.77 t', isWarning: false),
    _SlingReferenceRow(angle: '45°', load: '7.07 t', isWarning: false),
    _SlingReferenceRow(angle: '60°', load: '10.00 t', isWarning: false),
    _SlingReferenceRow(angle: '70°', load: '14.62 t', isWarning: true),
    _SlingReferenceRow(angle: '80°', load: '28.79 t', isWarning: true),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      elevation: 0,
      color: theme.colorScheme.surface,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Strekkbelastning pr. stropp',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              'Rett løft, 10 tonn last, 2 stropper',
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 14),
            Container(
              decoration: BoxDecoration(
                color: theme.colorScheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(10),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      'Vinkel',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ),
                  Text(
                    'Pr. stropp',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            for (final row in rows) _SlingReferenceTile(row: row),
          ],
        ),
      ),
    );
  }
}

class _SlingReferenceRow {
  const _SlingReferenceRow({
    required this.angle,
    required this.load,
    required this.isWarning,
  });

  final String angle;
  final String load;
  final bool isWarning;
}

class _SlingReferenceTile extends StatelessWidget {
  const _SlingReferenceTile({required this.row});

  final _SlingReferenceRow row;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final foreground =
        row.isWarning ? theme.colorScheme.error : theme.colorScheme.onSurface;
    final background = row.isWarning
        ? theme.colorScheme.errorContainer.withAlpha(80)
        : theme.colorScheme.surface;

    return Container(
      margin: const EdgeInsets.only(top: 8),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: row.isWarning
              ? theme.colorScheme.error
              : theme.colorScheme.outlineVariant,
          width: row.isWarning ? 1.4 : 1,
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Text(
              row.angle,
              style: theme.textTheme.headlineSmall?.copyWith(
                color: foreground,
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          Text(
            row.load,
            style: theme.textTheme.headlineSmall?.copyWith(
              color: foreground,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}

// --- PDF Viewer Pages (G-Table & Thread Chart) ---
class GTablePage extends StatelessWidget {
  const GTablePage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n?.gTable ?? 'G-Table'),
      ),
      body: const AssetPdfViewer(
        title: 'Gjengetabell',
        assetPath: 'lib/assets/gjengetabell.pdf',
      ),
    );
  }
}

class ThreadChartPage extends StatelessWidget {
  const ThreadChartPage({super.key});

  static const List<_PdfDocItem> _threadDocs = [
    _PdfDocItem(
      title: 'Gjengetabell',
      subtitle: 'Oversikt over gjengestandarder og dimensjoner',
      path: 'lib/assets/gjengetabell.pdf',
    ),
    _PdfDocItem(
      title: 'Gjengeforkortelser',
      subtitle: 'Forklaringer på vanlige betegnelser',
      path: 'lib/assets/hydraulikk/gjenger/gjengeforkortelser.pdf',
    ),
    _PdfDocItem(
      title: 'Standard forkortelser for gjenger',
      subtitle: 'Oppslag over standardiserte forkortelser',
      path: 'lib/assets/hydraulikk/gjenger/standard_forkortelser.pdf',
    ),
    _PdfDocItem(
      title: 'Måling av flenser, del 1',
      subtitle: 'Praktisk guide for flensmåling',
      path: 'lib/assets/hydraulikk/gjenger/maling_av_flenser.pdf',
    ),
    _PdfDocItem(
      title: 'Måling av flenser, del 2',
      subtitle: 'Videreføring av måleguide for flenser',
      path: 'lib/assets/hydraulikk/gjenger/maling_av_flenser_2.pdf',
    ),
    _PdfDocItem(
      title: 'Måling av gjenger, del 1',
      subtitle: 'Måling og identifisering av gjenger',
      path: 'lib/assets/hydraulikk/gjenger/maling_av_gjenger_1.pdf',
    ),
    _PdfDocItem(
      title: 'Måling av gjenger, del 2',
      subtitle: 'Måling og identifisering av gjenger',
      path: 'lib/assets/hydraulikk/gjenger/maling_av_gjenger_2.pdf',
    ),
    _PdfDocItem(
      title: 'Måling av gjenger, del 3',
      subtitle: 'Måling og identifisering av gjenger',
      path: 'lib/assets/hydraulikk/gjenger/maling_av_gjenger_3.pdf',
    ),
    _PdfDocItem(
      title: 'Måling av gjenger, del 4',
      subtitle: 'Måling og identifisering av gjenger',
      path: 'lib/assets/hydraulikk/gjenger/maling_av_gjenger_4.pdf',
    ),
    _PdfDocItem(
      title: 'Måling av gjenger, del 5',
      subtitle: 'Måling og identifisering av gjenger',
      path: 'lib/assets/hydraulikk/gjenger/maling_av_gjenger_5.pdf',
    ),
    _PdfDocItem(
      title: 'Måling av gjenger, del 6',
      subtitle: 'Måling og identifisering av gjenger',
      path: 'lib/assets/hydraulikk/gjenger/maling_av_gjenger_6.pdf',
    ),
    _PdfDocItem(
      title: 'Måling av gjenger, del 7',
      subtitle: 'Måling og identifisering av gjenger',
      path: 'lib/assets/hydraulikk/gjenger/maling_av_gjenger_7.pdf',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n?.threadChart ?? 'Gjenger'),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(12, 12, 12, 24),
        children: [
          _HydraulicMenuSection(
            title: '',
            children: _threadDocs.map((doc) => _PdfDocTile(doc: doc)).toList(),
          ),
        ],
      ),
    );
  }
}

class HydraulicPdfPage extends StatelessWidget {
  const HydraulicPdfPage({
    super.key,
    required this.title,
    required this.assetPath,
  });

  final String title;
  final String assetPath;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: AssetPdfViewer(
        title: title,
        assetPath: assetPath,
      ),
    );
  }
}

class HydraulicHosesPage extends StatelessWidget {
  const HydraulicHosesPage({super.key});

  static const List<_HoseDimensionRow> _hoseDimensions = [
    _HoseDimensionRow(mm: '4,8', dn: 'DN 5', inches: '3/16"', dash: '-03'),
    _HoseDimensionRow(mm: '6,3', dn: 'DN 6', inches: '1/4"', dash: '-04'),
    _HoseDimensionRow(mm: '7,9', dn: 'DN 8', inches: '5/16"', dash: '-05'),
    _HoseDimensionRow(mm: '9,5', dn: 'DN 10', inches: '3/8"', dash: '-06'),
    _HoseDimensionRow(mm: '12,7', dn: 'DN 13', inches: '1/2"', dash: '-08'),
    _HoseDimensionRow(mm: '15,9', dn: 'DN 16', inches: '5/8"', dash: '-10'),
    _HoseDimensionRow(mm: '19,0', dn: 'DN 19', inches: '3/4"', dash: '-12'),
    _HoseDimensionRow(mm: '25,4', dn: 'DN 25', inches: '1"', dash: '-16'),
    _HoseDimensionRow(mm: '31,8', dn: 'DN 32', inches: '1 1/4"', dash: '-20'),
    _HoseDimensionRow(mm: '38,1', dn: 'DN 38', inches: '1 1/2"', dash: '-24'),
    _HoseDimensionRow(mm: '50,8', dn: 'DN 51', inches: '2"', dash: '-32'),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Hydraulikkslanger'),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(12, 12, 12, 24),
        children: [
          Card(
            elevation: 0,
            color: theme.colorScheme.surfaceContainerLowest,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Slangedimensjoner',
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Siden slangene bruker tomme eller din-mål (metrisk), kan det være vanskelig å huske alle dimensjonene.',
                    style: theme.textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Slangenes innvendige mål:',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 12),
                  _HydraulicHoseDimensionTable(rows: _hoseDimensions),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _HoseDimensionRow {
  const _HoseDimensionRow({
    required this.mm,
    required this.dn,
    required this.inches,
    required this.dash,
  });

  final String mm;
  final String dn;
  final String inches;
  final String dash;
}

class _HydraulicHoseDimensionTable extends StatelessWidget {
  const _HydraulicHoseDimensionTable({required this.rows});

  final List<_HoseDimensionRow> rows;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final borderColor = theme.colorScheme.outlineVariant;

    TableRow buildRow({
      required String mm,
      required String dn,
      required String inches,
      required String dash,
      bool isHeader = false,
      bool isLast = false,
    }) {
      final textStyle = (isHeader
              ? theme.textTheme.titleSmall
              : theme.textTheme.bodyMedium)
          ?.copyWith(fontWeight: isHeader ? FontWeight.w700 : FontWeight.w500);

      BoxDecoration decoration({bool addDivider = true}) {
        return BoxDecoration(
          border: Border(
            bottom: addDivider
                ? BorderSide(color: borderColor, width: 0.8)
                : BorderSide.none,
          ),
        );
      }

      Widget buildCell(String value, {TextAlign align = TextAlign.left}) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
          child: Text(
            value,
            textAlign: align,
            style: textStyle,
          ),
        );
      }

      return TableRow(
        decoration: decoration(addDivider: !isLast),
        children: [
          buildCell(mm),
          buildCell(dn),
          buildCell(inches),
          buildCell(dash),
        ],
      );
    }

    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: borderColor),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: ConstrainedBox(
            constraints: const BoxConstraints(minWidth: 420),
            child: Table(
              columnWidths: const {
                0: FlexColumnWidth(1.0),
                1: FlexColumnWidth(1.2),
                2: FlexColumnWidth(1.0),
                3: FlexColumnWidth(0.8),
              },
              defaultVerticalAlignment: TableCellVerticalAlignment.middle,
              children: [
                buildRow(
                  mm: 'mm',
                  dn: 'DN (metrisk)',
                  inches: 'Tommer',
                  dash: 'Dash',
                  isHeader: true,
                ),
                for (var i = 0; i < rows.length; i++)
                  buildRow(
                    mm: rows[i].mm,
                    dn: rows[i].dn,
                    inches: rows[i].inches,
                    dash: rows[i].dash,
                    isLast: i == rows.length - 1,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _PdfDocItem {
  const _PdfDocItem({
    required this.title,
    required this.subtitle,
    required this.path,
  });

  final String title;
  final String subtitle;
  final String path;
}

class _PdfDocTile extends StatelessWidget {
  const _PdfDocTile({required this.doc});

  final _PdfDocItem doc;

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
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => HydraulicPdfPage(
                  title: doc.title,
                  assetPath: doc.path,
                ),
              ),
            );
          },
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
                  child: Icon(
                    Icons.picture_as_pdf,
                    color: theme.colorScheme.onPrimaryContainer,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        doc.title,
                        style: theme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        doc.subtitle,
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
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

// --- Reusable Widgets (Modernized) ---
class _InputCard extends StatelessWidget {
  final String title;
  final List<Widget> children;
  final IconData? titleIcon;

  const _InputCard(
      {required this.title, this.titleIcon, required this.children});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                if (titleIcon != null) ...[
                  Icon(titleIcon, color: theme.colorScheme.primary),
                  const SizedBox(width: 8),
                ],
                Expanded(
                  child: Text(
                    title,
                    style: theme.textTheme.titleLarge,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                  ),
                ),
              ],
            ),
            const Divider(height: 24),
            ...children,
          ],
        ),
      ),
    );
  }
}

class _InputRow extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final String unit;
  final IconData icon;

  const _InputRow({
    required this.controller,
    required this.label,
    required this.unit,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(icon, color: Theme.of(context).colorScheme.primary, size: 28),
          const SizedBox(width: 16),
          Expanded(
            child: TextField(
              controller: controller,
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              inputFormatters: [
                FilteringTextInputFormatter.allow(RegExp(r'[0-9.,]')),
              ],
              textInputAction: TextInputAction.done,
              onEditingComplete: () => FocusScope.of(context).unfocus(),
              decoration: InputDecoration(
                labelText: label,
                hintText: '0',
                border: const OutlineInputBorder(),
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              ),
            ),
          ),
          const SizedBox(width: 8),
          SizedBox(
            width: 72,
            child: FittedBox(
              fit: BoxFit.scaleDown,
              alignment: Alignment.centerLeft,
              child: Text(
                unit,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _FormulaHint extends StatelessWidget {
  final String text;

  const _FormulaHint({required this.text});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(
        text,
        style: theme.textTheme.bodyMedium?.copyWith(
          color: theme.colorScheme.onSurfaceVariant,
          fontStyle: FontStyle.italic,
        ),
      ),
    );
  }
}

class _InfoNote extends StatelessWidget {
  final String text;

  const _InfoNote({required this.text});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        text,
        style: theme.textTheme.bodySmall?.copyWith(
          color: theme.colorScheme.onSurfaceVariant,
        ),
      ),
    );
  }
}

class _ResultCard extends StatelessWidget {
  final String title;
  final List<Widget> results;
  final IconData titleIcon;

  const _ResultCard(
      {required this.title, required this.results, required this.titleIcon});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      color: theme.colorScheme.surfaceContainerHighest,
      elevation: 0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(titleIcon, color: theme.colorScheme.primary),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    title,
                    style: theme.textTheme.titleLarge,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                  ),
                ),
              ],
            ),
            const Divider(height: 24),
            ...results,
          ],
        ),
      ),
    );
  }
}

class _ResultRow extends StatelessWidget {
  final String label;
  final String value;
  final String unit;

  const _ResultRow(
      {required this.label, required this.value, required this.unit});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Wrap(
        alignment: WrapAlignment.spaceBetween,
        crossAxisAlignment: WrapCrossAlignment.center,
        spacing: 12,
        runSpacing: 4,
        children: [
          ConstrainedBox(
            constraints: const BoxConstraints(minWidth: 160, maxWidth: 280),
            child: Text(label, style: theme.textTheme.bodyLarge),
          ),
          Text(
            "$value $unit",
            textAlign: TextAlign.right,
            style: theme.textTheme.headlineSmall
                ?.copyWith(color: theme.colorScheme.primary),
          ),
        ],
      ),
    );
  }
}

// --- 1. Cylinder Calculator Page ---
class CylinderCalculatorPage extends StatefulWidget {
  const CylinderCalculatorPage({super.key});
  @override
  CylinderCalculatorPageState createState() => CylinderCalculatorPageState();
}

class CylinderCalculatorPageState extends State<CylinderCalculatorPage> {
  final _boreDiaCtrl = TextEditingController();
  final _rodDiaCtrl = TextEditingController();
  final _pressureCtrl = TextEditingController();
  final _flowCtrl = TextEditingController();

  Map<String, double> results = {};
  String? _inputError;

  @override
  void initState() {
    super.initState();
    final controllers = [_boreDiaCtrl, _rodDiaCtrl, _pressureCtrl, _flowCtrl];
    for (var ctrl in controllers) {
      ctrl.addListener(_calculate);
    }
  }

  @override
  void dispose() {
    final controllers = [_boreDiaCtrl, _rodDiaCtrl, _pressureCtrl, _flowCtrl];
    for (var ctrl in controllers) {
      ctrl.removeListener(_calculate);
      ctrl.dispose();
    }
    super.dispose();
  }

  void _calculate() {
    final boreDia = _parseInput(_boreDiaCtrl.text);
    final rodDia = _parseInput(_rodDiaCtrl.text);
    final pressure = _parseInput(_pressureCtrl.text);
    final flow = _parseInput(_flowCtrl.text);

    if (boreDia > 0 && rodDia >= boreDia) {
      setState(() {
        _inputError = 'Rod diameter must be smaller than bore diameter';
        results = {
          'boreArea': 0,
          'rodArea': 0,
          'boreForce': 0,
          'rodForce': 0,
          'boreSpeed': 0,
          'rodSpeed': 0,
        };
      });
      return;
    }

    final boreRadiusCm = boreDia / 20.0;
    final rodRadiusCm = rodDia / 20.0;

    // FIX: Ensure all values are doubles by using .toDouble() after calculations like pow()
    final double boreArea = (pi * pow(boreRadiusCm, 2)).toDouble();
    final double rodArea = (boreArea - (pi * pow(rodRadiusCm, 2))).toDouble();
    final double validRodArea = rodArea > 0 ? rodArea : 0;

    setState(() {
      _inputError = null;
      results = {
        'boreArea': boreArea,
        'rodArea': validRodArea,
        'boreForce': pressure * boreArea * 1.019716,
        'rodForce': pressure * validRodArea * 1.019716,
        'boreSpeed': boreArea > 0 ? flow / (6 * boreArea) : 0,
        'rodSpeed': validRodArea > 0 ? flow / (6 * validRodArea) : 0,
      };
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(
          title: Text(l10n?.cylinderCalculator ?? 'Cylinder Calculator')),
      body: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => FocusScope.of(context).unfocus(),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              _InputCard(
                title: l10n?.localeName.startsWith('no') == true
                    ? 'Inndata'
                    : 'Inputs',
                titleIcon: Icons.edit_note,
                children: [
                  _FormulaHint(
                    text:
                        l10n?.pistonSpeedCalculatorFormula ?? 'v = q / (6 * A)',
                  ),
                  _InfoNote(
                    text: l10n?.localeName.startsWith('no') == true
                        ? 'Enheter: diameter i mm, trykk i bar og volumstrøm i dm³/min. Areal vises i cm², kraft i kgf og hastighet i m/s.'
                        : 'Units: diameter in mm, pressure in bar, and flow in dm³/min. Area is shown in cm², force in kgf, and speed in m/s.',
                  ),
                  _InputRow(
                      controller: _boreDiaCtrl,
                      label: l10n?.pistonBoreDiameter ?? 'Piston/Bore Diameter',
                      unit: "mm",
                      icon: Icons.fullscreen),
                  _InputRow(
                      controller: _rodDiaCtrl,
                      label: l10n?.rodDiameter ?? 'Rod Diameter',
                      unit: "mm",
                      icon: Icons.linear_scale),
                  _InputRow(
                      controller: _pressureCtrl,
                      label: l10n?.pressure ?? 'Pressure',
                      unit: "bar",
                      icon: Icons.speed),
                  _InputRow(
                      controller: _flowCtrl,
                      label: l10n?.oilFlow ?? 'Oil Flow',
                      unit: "dm³/min",
                      icon: Icons.opacity),
                ],
              ),
              const SizedBox(height: 24),
              _ResultCard(
                title: l10n?.results ?? 'Results',
                titleIcon: Icons.bar_chart,
                results: [
                  if (_inputError != null)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: Text(
                        '${l10n?.errorPrefix ?? 'Error: '}${l10n?.localeName.startsWith('no') == true ? 'Stangdiameter må være mindre enn sylinderdiameter' : _inputError!}',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.error,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  _ResultRow(
                      label: l10n?.boreSideArea ?? 'Bore Side Area',
                      value: (results['boreArea'] ?? 0).toStringAsFixed(2),
                      unit: "cm²"),
                  _ResultRow(
                      label: l10n?.boreSideForce ?? 'Bore Side Force',
                      value: (results['boreForce'] ?? 0).toStringAsFixed(2),
                      unit: "kgf"),
                  _ResultRow(
                      label: l10n?.rodSideArea ?? 'Rod Side Area',
                      value: (results['rodArea'] ?? 0).toStringAsFixed(2),
                      unit: "cm²"),
                  _ResultRow(
                      label: l10n?.rodSideForce ?? 'Rod Side Force',
                      value: (results['rodForce'] ?? 0).toStringAsFixed(2),
                      unit: "kgf"),
                  _ResultRow(
                      label: l10n?.boreSideVelocity ?? 'Bore Side Velocity',
                      value: (results['boreSpeed'] ?? 0).toStringAsFixed(2),
                      unit: "m/s"),
                  _ResultRow(
                      label: l10n?.rodSideVelocity ?? 'Rod Side Velocity',
                      value: (results['rodSpeed'] ?? 0).toStringAsFixed(2),
                      unit: "m/s"),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// --- 2. Motor & Pump Calculator Page ---
enum CalculationMode { torque, power, flow, speed }

class MotorPumpCalculatorPage extends StatefulWidget {
  final bool isPumpMode;
  const MotorPumpCalculatorPage({super.key, this.isPumpMode = false});

  @override
  MotorPumpCalculatorPageState createState() => MotorPumpCalculatorPageState();
}

class MotorPumpCalculatorPageState extends State<MotorPumpCalculatorPage> {
  late CalculationMode _mode;
  final _displacementCtrl = TextEditingController();
  final _pressureCtrl = TextEditingController();
  final _speedCtrl = TextEditingController();
  final _flowCtrl = TextEditingController();
  final _torqueCtrl = TextEditingController();
  final _powerCtrl = TextEditingController();
  String _resultValue = "0.00";

  @override
  void initState() {
    super.initState();
    _mode = widget.isPumpMode ? CalculationMode.flow : CalculationMode.torque;
    final controllers = [
      _displacementCtrl,
      _pressureCtrl,
      _speedCtrl,
      _flowCtrl,
      _torqueCtrl,
      _powerCtrl
    ];
    for (var ctrl in controllers) {
      ctrl.addListener(_calculate);
    }
  }

  @override
  void dispose() {
    final controllers = [
      _displacementCtrl,
      _pressureCtrl,
      _speedCtrl,
      _flowCtrl,
      _torqueCtrl,
      _powerCtrl
    ];
    for (var ctrl in controllers) {
      ctrl.removeListener(_calculate);
      ctrl.dispose();
    }
    super.dispose();
  }

  void _calculate() {
    final V = _parseInput(_displacementCtrl.text);
    final p = _parseInput(_pressureCtrl.text);
    final n = _parseInput(_speedCtrl.text);
    final q = _parseInput(_flowCtrl.text);

    double result = 0.0;
    switch (_mode) {
      case CalculationMode.torque:
        result = (V * p) / 63;
        break;
      case CalculationMode.power:
        result = (p * q) / 600;
        break;
      case CalculationMode.flow:
        result = (V * n) / 1000;
        break;
      case CalculationMode.speed:
        result = V > 0 ? (q * 1000) / V : 0;
        break;
    }
    if (mounted) {
      setState(() => _resultValue = result.toStringAsFixed(2));
    }
  }

  void _onModeChanged(CalculationMode? newValue) {
    if (newValue == null) return;
    setState(() {
      _mode = newValue;
      final controllers = [
        _displacementCtrl,
        _pressureCtrl,
        _speedCtrl,
        _flowCtrl,
        _torqueCtrl,
        _powerCtrl
      ];
      for (var ctrl in controllers) {
        ctrl.clear();
      }
      _resultValue = "0.00";
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final pageTitle = widget.isPumpMode
        ? (l10n?.pumpCalculator ?? 'Pump Calculator')
        : (l10n?.motorCalculator ?? 'Motor Calculator');

    return Scaffold(
      appBar: AppBar(title: Text(pageTitle)),
      body: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => FocusScope.of(context).unfocus(),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              _buildModeSelector(l10n),
              const SizedBox(height: 24),
              _InputCard(
                title: l10n?.localeName.startsWith('no') == true
                    ? 'Inndata'
                    : 'Inputs',
                titleIcon: Icons.edit_note,
                children: [
                  _FormulaHint(text: _formulaForMode(l10n)),
                  _InfoNote(
                    text: l10n?.localeName.startsWith('no') == true
                        ? 'Enheter: fortrengningsvolum i cm³/r, trykk i bar, volumstrøm i dm³/min og turtall i r/min.'
                        : 'Units: displacement in cm³/r, pressure in bar, flow in dm³/min, and rotational speed in r/min.',
                  ),
                  _buildInputs(l10n),
                ],
              ),
              const SizedBox(height: 24),
              _ResultCard(
                title: l10n?.results ?? 'Result',
                titleIcon: Icons.show_chart,
                results: [_buildResult(l10n)],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildModeSelector(AppLocalizations? l10n) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: DropdownButtonFormField<CalculationMode>(
          initialValue: _mode,
          decoration: InputDecoration(
            labelText: l10n?.calculate ?? 'Select Calculation',
            border: const OutlineInputBorder(),
          ),
          items: CalculationMode.values.map((mode) {
            return DropdownMenuItem(
              value: mode,
              child: Text(mode.toString().split('.').last.capitalize()),
            );
          }).toList(),
          onChanged: _onModeChanged,
        ),
      ),
    );
  }

  Widget _buildInputs(AppLocalizations? l10n) {
    switch (_mode) {
      case CalculationMode.torque:
        return Column(children: [
          _InputRow(
              controller: _displacementCtrl,
              label:
                  l10n?.volumeFlowCalculatorDisplacementLabel ?? 'Displacement',
              unit: "cm³/r",
              icon: Icons.open_in_full),
          _InputRow(
              controller: _pressureCtrl,
              label: l10n?.pressure ?? 'Pressure',
              unit: "bar",
              icon: Icons.speed),
        ]);
      case CalculationMode.power:
        return Column(children: [
          _InputRow(
              controller: _pressureCtrl,
              label: l10n?.pressure ?? 'Pressure',
              unit: "bar",
              icon: Icons.speed),
          _InputRow(
              controller: _flowCtrl,
              label: l10n?.volumeFlow ?? 'Volume Flow',
              unit: "dm³/min",
              icon: Icons.opacity),
        ]);
      case CalculationMode.flow:
        return Column(children: [
          _InputRow(
              controller: _displacementCtrl,
              label:
                  l10n?.volumeFlowCalculatorDisplacementLabel ?? 'Displacement',
              unit: "cm³/r",
              icon: Icons.open_in_full),
          _InputRow(
              controller: _speedCtrl,
              label: l10n?.volumeFlowCalculatorRpmLabel ?? 'Rotational Speed',
              unit: "r/min",
              icon: Icons.rotate_right),
        ]);
      case CalculationMode.speed:
        return Column(children: [
          _InputRow(
              controller: _flowCtrl,
              label: l10n?.volumeFlow ?? 'Volume Flow',
              unit: "dm³/min",
              icon: Icons.opacity),
          _InputRow(
              controller: _displacementCtrl,
              label:
                  l10n?.volumeFlowCalculatorDisplacementLabel ?? 'Displacement',
              unit: "cm³/r",
              icon: Icons.open_in_full),
        ]);
    }
  }

  Widget _buildResult(AppLocalizations? l10n) {
    switch (_mode) {
      case CalculationMode.torque:
        return _ResultRow(
            label: l10n?.torqueCalculatorResultLabel ?? 'Torque (M)',
            value: _resultValue,
            unit: "Nm");
      case CalculationMode.power:
        return _ResultRow(
            label: l10n?.hydraulicPowerCalculatorResultLabel ?? 'Power (P)',
            value: _resultValue,
            unit: "kW");
      case CalculationMode.flow:
        return _ResultRow(
            label: l10n?.volumeFlowCalculatorResultLabel ?? 'Volume Flow (q)',
            value: _resultValue,
            unit: "dm³/min");
      case CalculationMode.speed:
        return _ResultRow(
            label: l10n?.speed ?? 'Speed (RPM)',
            value: _resultValue,
            unit: "r/min");
    }
  }

  String _formulaForMode(AppLocalizations? l10n) {
    switch (_mode) {
      case CalculationMode.torque:
        return l10n?.torqueCalculatorFormula ?? 'M = (V * Δp) / 63';
      case CalculationMode.power:
        return l10n?.hydraulicPowerCalculatorFormula ?? 'P = (p * q) / 600';
      case CalculationMode.flow:
        return l10n?.volumeFlowCalculatorFormula ?? 'q = (V * n) / 1000';
      case CalculationMode.speed:
        return 'n = (q * 1000) / V';
    }
  }
}

// --- 3. Power & Efficiency Calculator Page ---
class PowerAndEfficiencyCalculatorPage extends StatefulWidget {
  const PowerAndEfficiencyCalculatorPage({super.key});

  @override
  PowerAndEfficiencyCalculatorPageState createState() =>
      PowerAndEfficiencyCalculatorPageState();
}

class PowerAndEfficiencyCalculatorPageState
    extends State<PowerAndEfficiencyCalculatorPage> {
  final _pressureDropCtrl = TextEditingController();
  final _powerLossFlowCtrl = TextEditingController();
  double _powerLoss = 0.0;

  final _pInCtrl = TextEditingController();
  final _pOutCtrl = TextEditingController();
  double _efficiency = 0.0;

  final _hoseFlowCtrl = TextEditingController();
  final _targetSpeedCtrl = TextEditingController(text: '5.0');
  HoseLineType _hoseLineType = HoseLineType.pressure;
  double _recommendedDiameter = 0.0;
  PipeSize? _recommendedPipeSize;

  @override
  void initState() {
    super.initState();
    _pressureDropCtrl.addListener(_calculatePowerLoss);
    _powerLossFlowCtrl.addListener(_calculatePowerLoss);
    _pInCtrl.addListener(_calculateEfficiency);
    _pOutCtrl.addListener(_calculateEfficiency);
    _hoseFlowCtrl.addListener(_calculateHoseSizing);
    _targetSpeedCtrl.addListener(_calculateHoseSizing);
  }

  @override
  void dispose() {
    _pressureDropCtrl.dispose();
    _powerLossFlowCtrl.dispose();
    _pInCtrl.dispose();
    _pOutCtrl.dispose();
    _hoseFlowCtrl.dispose();
    _targetSpeedCtrl.dispose();
    super.dispose();
  }

  void _calculatePowerLoss() {
    final deltaP = _parseInput(_pressureDropCtrl.text);
    final q = _parseInput(_powerLossFlowCtrl.text);
    setState(() => _powerLoss = (deltaP * q) / 600);
  }

  void _calculateEfficiency() {
    final pIn = _parseInput(_pInCtrl.text);
    final pOut = _parseInput(_pOutCtrl.text);
    setState(() => _efficiency = pIn > 0 ? (pOut / pIn) * 100 : 0);
  }

  void _calculateHoseSizing() {
    final q = _parseInput(_hoseFlowCtrl.text);
    final targetSpeed = _parseInput(_targetSpeedCtrl.text);
    final diameter =
        (q > 0 && targetSpeed > 0) ? sqrt((q * 21.2) / targetSpeed) : 0.0;

    PipeSize? recommendedSize;
    if (diameter > 0) {
      for (final size in pipeSizesData) {
        if (size.mm >= diameter) {
          recommendedSize = size;
          break;
        }
      }
      recommendedSize ??= pipeSizesData.last;
    }

    setState(() {
      _recommendedDiameter = diameter;
      _recommendedPipeSize = recommendedSize;
    });
  }

  void _onHoseLineTypeChanged(HoseLineType? value) {
    if (value == null) return;

    final defaultSpeed = switch (value) {
      HoseLineType.suction => 1.0,
      HoseLineType.returnLine => 3.0,
      HoseLineType.pressure => 5.0,
    };

    setState(() {
      _hoseLineType = value;
      _targetSpeedCtrl.text = defaultSpeed.toStringAsFixed(1);
    });
    _calculateHoseSizing();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(
          title: Text(l10n?.pressureDropCalculator ?? 'Power & Efficiency')),
      body: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => FocusScope.of(context).unfocus(),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              _InputCard(
                title: l10n?.powerLossCalculatorTitle ?? 'Power Loss',
                titleIcon: Icons.bolt_outlined,
                children: [
                  _FormulaHint(
                    text: l10n?.powerLossCalculatorFormula ??
                        'P = (Δp * q) / 600',
                  ),
                  _InfoNote(
                    text: l10n?.localeName.startsWith('no') == true
                        ? 'Enheter: trykkfall i bar, volumstrøm i dm³/min og resultat i kW.'
                        : 'Units: pressure drop in bar, volume flow in dm³/min, and result in kW.',
                  ),
                  _InputRow(
                      controller: _pressureDropCtrl,
                      label: l10n?.pressureDrop ?? 'Pressure Drop',
                      unit: "bar",
                      icon: Icons.arrow_downward),
                  _InputRow(
                      controller: _powerLossFlowCtrl,
                      label: l10n?.volumeFlow ?? 'Volume Flow',
                      unit: "dm³/min",
                      icon: Icons.opacity),
                ],
              ),
              const SizedBox(height: 24),
              _InputCard(
                title: l10n?.efficiencyCalculatorTitle ?? 'Efficiency',
                titleIcon: Icons.percent_outlined,
                children: [
                  _FormulaHint(
                    text: l10n?.efficiencyCalculatorFormula ??
                        'η = P.avg / P.tilf',
                  ),
                  _InfoNote(
                    text: l10n?.localeName.startsWith('no') == true
                        ? 'Oppgi tilført og avgitt effekt i kW. Resultatet vises i prosent.'
                        : 'Enter input and output power in kW. The result is shown as a percentage.',
                  ),
                  _InputRow(
                      controller: _pInCtrl,
                      label: l10n?.efficiencyCalculatorInputPowerLabel ??
                          'Input Power (P.tilf)',
                      unit: "kW",
                      icon: Icons.input),
                  _InputRow(
                      controller: _pOutCtrl,
                      label: l10n?.efficiencyCalculatorOutputPowerLabel ??
                          'Output Power (P.avg)',
                      unit: "kW",
                      icon: Icons.output),
                ],
              ),
              const SizedBox(height: 24),
              _InputCard(
                title: l10n?.localeName.startsWith('no') == true
                    ? 'Slangedimensjonering'
                    : 'Hose sizing',
                titleIcon: Icons.straighten,
                children: [
                  _FormulaHint(
                    text:
                        'd = sqrt((q * 21.2) / v), ${l10n?.oilSpeedCalculatorFormula ?? 'v = (q * 21.2) / d²'}',
                  ),
                  _InfoNote(
                    text: l10n?.localeName.startsWith('no') == true
                        ? 'Typiske oljehastigheter: sugeside ca. 0,5-1,5 m/s, returlinje ca. 2-4 m/s og trykklinje ca. 4-6 m/s.'
                        : 'Typical oil speeds: suction line about 0.5-1.5 m/s, return line about 2-4 m/s, and pressure line about 4-6 m/s.',
                  ),
                  DropdownButtonFormField<HoseLineType>(
                    initialValue: _hoseLineType,
                    decoration: InputDecoration(
                      labelText: l10n?.localeName.startsWith('no') == true
                          ? 'Linjetype'
                          : 'Line type',
                      border: const OutlineInputBorder(),
                    ),
                    items: HoseLineType.values.map((type) {
                      return DropdownMenuItem(
                        value: type,
                        child: Text(_hoseLineTypeLabel(type, l10n)),
                      );
                    }).toList(),
                    onChanged: _onHoseLineTypeChanged,
                  ),
                  const SizedBox(height: 12),
                  _InputRow(
                    controller: _hoseFlowCtrl,
                    label: l10n?.oilSpeedCalculatorFlowLabel ?? 'Oil Flow (q)',
                    unit: "dm³/min",
                    icon: Icons.opacity,
                  ),
                  _InputRow(
                    controller: _targetSpeedCtrl,
                    label: l10n?.localeName.startsWith('no') == true
                        ? 'Ønsket oljehastighet'
                        : 'Target oil speed',
                    unit: "m/s",
                    icon: Icons.speed,
                  ),
                ],
              ),
              const SizedBox(height: 24),
              _ResultCard(
                title: l10n?.results ?? 'Results',
                titleIcon: Icons.assessment_outlined,
                results: [
                  _ResultRow(
                      label: l10n?.powerLoss ?? 'Power Loss',
                      value: _powerLoss.toStringAsFixed(2),
                      unit: "kW"),
                  _ResultRow(
                      label: l10n?.efficiency ?? 'Efficiency (η)',
                      value: _efficiency.toStringAsFixed(1),
                      unit: "%"),
                  _ResultRow(
                    label: l10n?.localeName.startsWith('no') == true
                        ? 'Anbefalt innvendig slangediameter'
                        : 'Recommended internal hose diameter',
                    value: _recommendedDiameter.toStringAsFixed(1),
                    unit: "mm",
                  ),
                  if (_recommendedPipeSize != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Text(
                        l10n?.localeName.startsWith('no') == true
                            ? 'Nærmeste standard: ${_recommendedPipeSize!.dn} / -${_recommendedPipeSize!.dashSize} / ${_recommendedPipeSize!.inchesFraction}'
                            : 'Nearest standard: ${_recommendedPipeSize!.dn} / -${_recommendedPipeSize!.dashSize} / ${_recommendedPipeSize!.inchesFraction}',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _hoseLineTypeLabel(HoseLineType type, AppLocalizations? l10n) {
    final isNo = l10n?.localeName.startsWith('no') == true;
    return switch (type) {
      HoseLineType.suction => isNo ? 'Sugeside' : 'Suction',
      HoseLineType.returnLine => isNo ? 'Returlinje' : 'Return line',
      HoseLineType.pressure => isNo ? 'Trykklinje' : 'Pressure line',
    };
  }
}

enum HoseLineType { suction, returnLine, pressure }

// Simple String extension for capitalizing first letter
extension StringExtension on String {
  String capitalize() {
    if (isEmpty) return this;
    return "${this[0].toUpperCase()}${substring(1)}";
  }
}

double _parseInput(String raw) {
  final normalized = raw.replaceAll(',', '.');
  return double.tryParse(normalized) ?? 0;
}
