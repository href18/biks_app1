import 'package:biks/widgets/asset_pdf_viewer.dart';
import 'package:flutter/material.dart';

class RiggingScreen extends StatelessWidget {
  const RiggingScreen({super.key});

  static const _groups = <_RiggingGroup>[
    _RiggingGroup(
      title: 'Eagleclamp',
      documents: [
        _RiggingDocument('HEA-profil', 'eagleclamp_hea_profile.pdf'),
        _RiggingDocument('HEB-profil', 'eagleclamp_heb_profile.pdf'),
        _RiggingDocument('IPE-profil', 'eagleclamp_ipe_profile.pdf'),
        _RiggingDocument('L-profil', 'eagleclamp_l_profile.pdf'),
        _RiggingDocument('UPE-profil', 'eagleclamp_upe_profile.pdf'),
      ],
    ),
    _RiggingGroup(
      title: 'Kjettingløkke',
      documents: [
        _RiggingDocument('HEA-profil', 'chain_loop_hea_profile.pdf'),
        _RiggingDocument('HEB-profil', 'chain_loop_heb_profile.pdf'),
        _RiggingDocument('IPE-profil', 'chain_loop_ipe_profile.pdf'),
        _RiggingDocument('RHS-profil', 'chain_loop_rhs_profile.pdf'),
        _RiggingDocument('UNP-profil', 'chain_loop_unp_profile.pdf'),
        _RiggingDocument('UPE-profil', 'chain_loop_upe_profile.pdf'),
      ],
    ),
    _RiggingGroup(
      title: 'Superclamp',
      documents: [
        _RiggingDocument('HEA-profil', 'superclamp_hea_profile.pdf'),
        _RiggingDocument('HEB-profil', 'superclamp_heb_profile.pdf'),
        _RiggingDocument('IPE-profil', 'superclamp_ipe_profile.pdf'),
        _RiggingDocument('L-profil', 'superclamp_l_profile.pdf'),
        _RiggingDocument('UNP-profil', 'superclamp_unp_profile.pdf'),
        _RiggingDocument('UPE-profil', 'superclamp_upe_profile.pdf'),
      ],
    ),
  ];

  void _openDocument(
    BuildContext context,
    String groupTitle,
    _RiggingDocument document,
  ) {
    final title = '$groupTitle - ${document.title}';
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => Scaffold(
          appBar: AppBar(title: Text(title)),
          body: AssetPdfViewer(
            title: title,
            assetPath: 'lib/assets/rigging/${document.filename}',
            fitPolicy: AssetPdfFitPolicy.width,
            startInLandscape: true,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Rigging')),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.info_outline,
                    color: theme.colorScheme.primary,
                  ),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Text(
                      'Velg utstyrstype og profil for å åpne tabellen over '
                      'tillatt løftelast. Tabellene vises i liggende format.',
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          for (final group in _groups) ...[
            Card(
              clipBehavior: Clip.antiAlias,
              child: ExpansionTile(
                initiallyExpanded: group == _groups.first,
                leading: const Icon(Icons.hardware_outlined),
                title: Text(
                  group.title,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                subtitle: Text('${group.documents.length} profiler'),
                children: [
                  const Divider(height: 1),
                  for (final document in group.documents)
                    ListTile(
                      leading: const Icon(Icons.picture_as_pdf_outlined),
                      title: Text(document.title),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () =>
                          _openDocument(context, group.title, document),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 12),
          ],
        ],
      ),
    );
  }
}

class _RiggingGroup {
  const _RiggingGroup({required this.title, required this.documents});

  final String title;
  final List<_RiggingDocument> documents;
}

class _RiggingDocument {
  const _RiggingDocument(this.title, this.filename);

  final String title;
  final String filename;
}
