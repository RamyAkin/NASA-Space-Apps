import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/exoplanet_provider.dart';
import '../models/exoplanet.dart';

class ConfirmedScreen extends StatelessWidget {
  const ConfirmedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final prov = Provider.of<ExoplanetProvider>(context);
    return Scaffold(
      appBar: AppBar(title: const Text('Confirmed Exoplanets')),
      body: prov.loading
          ? const Center(child: CircularProgressIndicator())
          : prov.error != null
              ? Center(child: Text('Error: ${prov.error}'))
              : ListView.builder(
                  itemCount: prov.confirmed.length,
                  itemBuilder: (context, i) {
                    final Exoplanet p = prov.confirmed[i];
                    return ListTile(
                      title: Text(p.name),
                      subtitle: Text('${p.radius ?? '-'} R⊕ • ${p.mass ?? '-'} M⊕ • ${p.orbitalPeriod ?? '-'} d'),
                    );
                  },
                ),
    );
  }
}
