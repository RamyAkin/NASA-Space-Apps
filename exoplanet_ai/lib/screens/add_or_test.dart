import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;

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
    _periodController.text = '8.6893015e+00';
    _durationController.text = '22.5630000e+00';
    _depthController.text = '1.1170000e+03';
    _rorController.text = '2.9843001e-02';
  }

  @override
  Widget build(BuildContext context) {
  // size not used here; removed to avoid unused-variable warnings
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset('assets/background.png', fit: BoxFit.cover, errorBuilder: (c, e, s) => Container(color: Colors.black)),
          ),
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: 64,
            child: Container(
              color: const Color(0xFFE9CC6C),
              child: SafeArea(
                child: SizedBox(
                  height: 56,
                  child: Stack(
                    children: [
                      Center(
                        child: Text(
                          'A World Away',
                          style: GoogleFonts.poppins(
                            fontSize: 24,
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.2,
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: IconButton(
                          icon: const Icon(Icons.arrow_back, color: Colors.black),
                          onPressed: () => Navigator.maybePop(context),
                        ),
                      ),
                      Align(
                        alignment: Alignment.centerRight,
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            TextButton(
                              onPressed: () => Navigator.pushNamed(context, '/'),
                              child: Text('Home', style: GoogleFonts.poppins(color: Colors.black)),
                            ),
                            TextButton(
                              onPressed: () => Navigator.pushNamed(context, '/confirmed'),
                              child: Text('Confirmed', style: GoogleFonts.poppins(color: Colors.black)),
                            ),
                            TextButton(
                              onPressed: () => Navigator.pushNamed(context, '/candidates'),
                              child: Text('Candidates', style: GoogleFonts.poppins(color: Colors.black)),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 64),
            child: Center(
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
                              backgroundColor: const Color(0xFFE9CC6C),
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
          ),
        ],
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

  // raw string values logged in debug during development (removed prints for production)

      // Call AI API
      const String _aiApiBase = String.fromEnvironment('API_AI_BASE', defaultValue: 'https://nasaserver.onrender.com');
      final response = await http.post(
        Uri.parse('$_aiApiBase/ai/predict'),
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

        //print('API Response - Prediction: $prediction, Confidence: $confidence'); 
        // API response received (removed prints for production)
        
        if (!mounted) return;
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
      if (mounted) {
        setState(() {
          _predictionResult = "❌ Error: ${e.toString()}";
        });
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
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
