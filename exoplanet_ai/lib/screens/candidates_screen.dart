import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/exoplanet_provider.dart';
import '../models/exoplanet.dart';

class CandidatesScreen extends StatelessWidget {
  const CandidatesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final prov = Provider.of<ExoplanetProvider>(context);
    return Scaffold(
      appBar: AppBar(title: const Text('Candidate Planets')),
      body: prov.loading
          ? const Center(child: CircularProgressIndicator())
          : prov.error != null
              ? Center(child: Text('Error: ${prov.error}'))
              : ListView.builder(
                  itemCount: prov.candidates.length,
                  itemBuilder: (context, i) {
                    final Exoplanet p = prov.candidates[i];
                    return ListTile(
                      title: Text(p.name),
                      subtitle: Text('${p.radius ?? '-'} R⊕ • ${p.mass ?? '-'} M⊕ • ${p.orbitalPeriod ?? '-'} d'),
                    );
                  },
                ),
    );
  }
}
