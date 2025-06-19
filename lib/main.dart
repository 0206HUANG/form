import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:signature/signature.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Form Validation',
      theme: ThemeData(primarySwatch: Colors.purple, useMaterial3: false),
      home: const FormScreen(),
    );
  }
}

class FormScreen extends StatefulWidget {
  const FormScreen({super.key});

  @override
  State<FormScreen> createState() => _FormScreenState();
}

class _FormScreenState extends State<FormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _dobController = TextEditingController();
  String? _gender;
  double _familyMembers = 5.0;
  int _segmentedRating = -1;
  int _stepperValue = 10;
  bool _langEng = false;
  bool _langHindi = false;
  bool _langOther = false;
  final SignatureController _signatureController = SignatureController(
    penStrokeWidth: 2,
    penColor: Colors.black,
  );
  double _starRating = 0;
  bool _acceptedTerms = false;

  @override
  void dispose() {
    _nameController.dispose();
    _dobController.dispose();
    _signatureController.dispose();
    super.dispose();
  }

  Future<void> _pickDob() async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime(2000),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      _dobController.text = '${picked.year}-${picked.month}-${picked.day}';
    }
  }

  void _submit() {
    if (_formKey.currentState!.validate() && _acceptedTerms) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Form submitted')));
    } else if (!_acceptedTerms) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('You must accept terms and conditions to continue'),
        ),
      );
    }
  }

  void _reset() {
    _formKey.currentState!.reset();
    _nameController.clear();
    _dobController.clear();
    setState(() {
      _gender = null;
      _familyMembers = 0.0;
      _segmentedRating = -1;
      _stepperValue = 0;
      _langEng = _langHindi = _langOther = false;
      _signatureController.clear();
      _starRating = 0;
      _acceptedTerms = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Flutter Form Validation'),
        backgroundColor: Colors.purple,
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Full Name
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Full Name'),
              validator:
                  (v) =>
                      (v == null || v.trim().isEmpty)
                          ? 'This field cannot be empty.'
                          : null,
            ),

            const SizedBox(height: 16),
            // Date of Birth
            TextFormField(
              controller: _dobController,
              readOnly: true,
              decoration: const InputDecoration(labelText: 'Date of Birth'),
              validator:
                  (v) =>
                      (v == null || v.trim().isEmpty)
                          ? 'This field cannot be empty.'
                          : null,
              onTap: _pickDob,
            ),

            const SizedBox(height: 16),
            // Gender
            DropdownButtonFormField<String>(
              value: _gender,
              decoration: const InputDecoration(labelText: 'Gender'),
              items: const [
                DropdownMenuItem(value: 'Male', child: Text('Male')),
                DropdownMenuItem(value: 'Female', child: Text('Female')),
                DropdownMenuItem(value: 'Other', child: Text('Other')),
              ],
              onChanged: (v) => setState(() => _gender = v),
              validator:
                  (v) => (v == null) ? 'This field cannot be empty.' : null,
            ),

            const SizedBox(height: 24),
            // Slider
            const Text('Number of Family Members'),
            Slider(
              value: _familyMembers,
              min: 0,
              max: 10,
              divisions: 10,
              label: _familyMembers.round().toString(),
              onChanged: (v) => setState(() => _familyMembers = v),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: const [Text('0.0'), Text('10.0')],
            ),

            const SizedBox(height: 24),
            // Segmented Rating
            const Text('Rating'),
            const SizedBox(height: 12),
            ToggleButtons(
              borderRadius: BorderRadius.circular(4),
              isSelected: List.generate(5, (i) => i == _segmentedRating),
              onPressed: (i) => setState(() => _segmentedRating = i),
              children: List.generate(
                5,
                (i) => Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Text('${i + 1}'),
                ),
              ),
            ),

            const SizedBox(height: 24),
            // Stepper
            const Text('Stepper'),
            const SizedBox(height: 12),
            Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.remove),
                  onPressed:
                      () => setState(
                        () => _stepperValue = (_stepperValue - 1).clamp(0, 100).toInt(),
                      ),
                ),
                Expanded(child: Center(child: Text('$_stepperValue'))),
                IconButton(
                  icon: const Icon(Icons.add),
                  onPressed:
                      () => setState(
                        () => _stepperValue = (_stepperValue + 1).clamp(0, 100).toInt(),
                      ),
                ),
              ],
            ),

            const SizedBox(height: 24),
            const Divider(),

            // Checkboxes
            const Text('Languages you know'),
            CheckboxListTile(
              title: const Text('English'),
              value: _langEng,
              onChanged: (v) => setState(() => _langEng = v!),
            ),
            CheckboxListTile(
              title: const Text('Hindi'),
              value: _langHindi,
              onChanged: (v) => setState(() => _langHindi = v!),
            ),
            CheckboxListTile(
              title: const Text('Other'),
              value: _langOther,
              onChanged: (v) => setState(() => _langOther = v!),
            ),

            const Divider(),
            // Signature
            const Text('Signature'),
            const SizedBox(height: 8),
            Container(
              height: 150,
              decoration: BoxDecoration(border: Border.all(color: Colors.grey)),
              child: Signature(
                controller: _signatureController,
                backgroundColor: Colors.white,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                  onPressed: _signatureController.clear,
                  icon: const Icon(Icons.clear, color: Colors.red),
                ),
                const Text('Clear'),
              ],
            ),

            const Divider(),
            // Star rating
            const Text('Rate this site'),
            const SizedBox(height: 8),
            RatingBar.builder(
              initialRating: 0,
              minRating: 0,
              allowHalfRating: false,
              itemCount: 5,
              itemBuilder:
                  (context, _) => const Icon(
                    Icons.star,
                    color: Colors.orange,
                  ),
              onRatingUpdate: (v) => setState(() => _starRating = v),
            ),

            const SizedBox(height: 24),
            // Terms
            CheckboxListTile(
              title: const Text(
                'I have read and agree to the terms and conditions',
              ),
              value: _acceptedTerms,
              onChanged: (v) => setState(() => _acceptedTerms = v!),
            ),
            if (!_acceptedTerms)
              const Padding(
                padding: EdgeInsets.only(left: 16),
                child: Text(
                  'You must accept terms and conditions to continue',
                  style: TextStyle(color: Colors.red),
                ),
              ),

            const SizedBox(height: 24),
            // Buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(onPressed: _submit, child: const Text('Submit')),
                OutlinedButton(onPressed: _reset, child: const Text('Reset')),
              ],
            ),

            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}
