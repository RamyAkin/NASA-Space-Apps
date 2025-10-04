import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../widgets/website_scaffold.dart';

class AddOrTestPage extends StatefulWidget {
  const AddOrTestPage({super.key});

  @override
  State<AddOrTestPage> createState() => _AddOrTestPageState();
}

class _AddOrTestPageState extends State<AddOrTestPage> {
  final _formKey = GlobalKey<FormState>();

  // form controllers
  final _nameController = TextEditingController();
  final _orbitalPeriodController = TextEditingController();
  final _radiusController = TextEditingController();
  final _durationController = TextEditingController();

  String? _predictionResult;

  @override
  Widget build(BuildContext context) {
    return WebsiteScaffold(
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 600),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 20),
              Text(
                "Add or Test Exoplanet",
                style: GoogleFonts.poppins(
                  fontSize: 32,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                "Input new planet data or test it against the AI model",
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  color: Colors.white70,
                ),
              ),
              const SizedBox(height: 40),

              // 📝 Form
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    _buildTextField(
                      controller: _nameController,
                      label: "Planet Name",
                      hint: "e.g. Kepler-22b",
                    ),
                    _buildTextField(
                      controller: _orbitalPeriodController,
                      label: "Orbital Period (days)",
                      hint: "e.g. 365",
                      keyboard: TextInputType.number,
                    ),
                    _buildTextField(
                      controller: _radiusController,
                      label: "Planet Radius (Earth radii)",
                      hint: "e.g. 1.0",
                      keyboard: TextInputType.number,
                    ),
                    _buildTextField(
                      controller: _durationController,
                      label: "Transit Duration (hours)",
                      hint: "e.g. 10",
                      keyboard: TextInputType.number,
                    ),
                    const SizedBox(height: 30),

                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.cyanAccent,
                        foregroundColor: Colors.black,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 32, vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          setState(() {
                            // For now, just mock a result
                            _predictionResult =
                                "🪐 Prediction: Candidate Exoplanet (87% confidence)";
                          });
                        }
                      },
                      child: const Text(
                        "Submit",
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 30),

              // 🔮 Prediction Result
              if (_predictionResult != null)
                Text(
                  _predictionResult!,
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    color: Colors.greenAccent,
                    fontWeight: FontWeight.w500,
                  ),
                  textAlign: TextAlign.center,
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    TextInputType keyboard = TextInputType.text,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboard,
        style: const TextStyle(color: Colors.white),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(color: Colors.white70),
          hintText: hint,
          hintStyle: const TextStyle(color: Colors.white38),
          enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.white38),
            borderRadius: BorderRadius.circular(12),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.cyanAccent, width: 2),
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        validator: (value) =>
            value == null || value.isEmpty ? "Please enter $label" : null,
      ),
    );
  }
}
