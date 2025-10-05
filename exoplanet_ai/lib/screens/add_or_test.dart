import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import '../widgets/website_scaffold.dart';

class AddOrTestPage extends StatefulWidget {
  const AddOrTestPage({super.key});

  @override
  State<AddOrTestPage> createState() => _AddOrTestPageState();
}

class _AddOrTestPageState extends State<AddOrTestPage> {
  final _formKey = GlobalKey<FormState>();

  // form controllers for AI parameters
  final _periodController = TextEditingController();
  final _durationController = TextEditingController();
  final _depthController = TextEditingController();
  final _rorController = TextEditingController();

  String? _predictionResult;
  String? _confidenceResult;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    // Set default values for easy testing (in correct order)
    _periodController.text = '9.48803557±2.775e-05';
    _durationController.text = '2.9575±0.0819';
    _depthController.text = '615.8±19.5';
    _rorController.text = '2.26 +0.26-0.15';
  }

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
                      controller: _periodController,
                      label: "Period",
                      hint: "e.g. 9.48803557±2.775e-05",
                      keyboard: TextInputType.text,
                    ),
                    _buildTextField(
                      controller: _durationController,
                      label: "Duration", 
                      hint: "e.g. 2.5 or 1.23±0.08e-01",
                      keyboard: TextInputType.text,
                    ),
                    _buildTextField(
                      controller: _depthController,
                      label: "Depth",
                      hint: "e.g. 0.001 or 2.3e-03±1.2e-04",
                      keyboard: TextInputType.text,
                    ),
                    _buildTextField(
                      controller: _rorController,
                      label: "ROR (Radius Ratio)",
                      hint: "e.g. 0.1 or 8.7e-02±3.0e-03",
                      keyboard: TextInputType.text,
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
                      onPressed: _isLoading ? null : _submitPrediction,
                      child: _isLoading 
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              color: Colors.black,
                              strokeWidth: 2,
                            ),
                          )
                        : const Text(
                            "Test with AI",
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

              if (_predictionResult != null)
                Column(
                  children: [
                    Text(
                      _predictionResult!,
                      style: GoogleFonts.poppins(
                        fontSize: 18,
                        color: Colors.greenAccent,
                        fontWeight: FontWeight.w500,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    if (_confidenceResult != null) ...[
                      const SizedBox(height: 8),
                      Text(
                        _confidenceResult!,
                        style: GoogleFonts.poppins(
                          fontSize: 18,
                          color: Colors.greenAccent,
                          fontWeight: FontWeight.w500,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ],
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

  Future<void> _submitPrediction() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
      _predictionResult = null;
    });

    try {
      // Send raw string values - API will handle all parsing
      final period = _periodController.text.trim();
      final duration = _durationController.text.trim();
      final depth = _depthController.text.trim();
      final ror = _rorController.text.trim();

      print('Raw string values - Period: "$period", Duration: "$duration", Depth: "$depth", ROR: "$ror"');

      // Call AI API through local proxy to avoid CORS issues
      final response = await http.post(
        Uri.parse('http://localhost:3001/ai/predict'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
        body: jsonEncode({
          'period': period,
          'duration': duration,
          'depth': depth,
          'ror': ror,
        }),
      );

      if (response.statusCode == 200) {
        final result = jsonDecode(response.body);
        final prediction = result['prediction'];
        final confidence = result['confidence'];

        print('API Response - Prediction: $prediction, Confidence: $confidence'); 
        
        setState(() {
          // Display confidence only once, with percentage rounding
          _confidenceResult = confidence != null 
            ? 'Confidence: ${(confidence * 100).toStringAsFixed(2)}%'
            : null;
          if (prediction == 1) {
            _predictionResult = "✅ AI Result: Confirmed Exoplanet!";
          } else if (prediction == 0) {
            _predictionResult = "❌ AI Result: Not an Exoplanet";
          } else {
            _predictionResult = "🤖 AI Result: Prediction Score: $prediction";
          }
        });
      } else {
        throw Exception('API Error: ${response.statusCode}');
      }
    } catch (e) {
      setState(() {
        _predictionResult = "❌ Error: ${e.toString()}";
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _periodController.dispose();
    _durationController.dispose();
    _depthController.dispose();
    _rorController.dispose();
    super.dispose();
  }
}
