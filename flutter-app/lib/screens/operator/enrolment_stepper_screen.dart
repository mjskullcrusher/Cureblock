import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../providers/child_provider.dart';
import '../../theme/app_text_styles.dart';
import '../../widgets/scan_ring_widget.dart';

class EnrolmentStepperScreen extends ConsumerStatefulWidget {
 const EnrolmentStepperScreen({super.key});

 @override
 ConsumerState<EnrolmentStepperScreen> createState() => _EnrolmentStepperScreenState();
}

class _EnrolmentStepperScreenState extends ConsumerState<EnrolmentStepperScreen> {
 static const _labels = ['Demographics', 'Biometric', 'Aadhaar', 'IoT Device', 'Review'];

 int _step = 0;
 final _nameController = TextEditingController();
 final _guardianNameController = TextEditingController();
 final _guardianPhoneController = TextEditingController();
 DateTime? _dob;
 String _gender = 'Female';
 String _enrolmentCenter = 'Delhi Central Centre';
 bool _aadhaarLinked = false;
 bool _submitted = false;
 double _scanQuality = 0.0;
 bool _biometricScanned = false;
 int _scanAttempt = 0;
 String? _selectedDevice;

 bool _saving = false;
 String? _saveError;

 @override
 void dispose() {
 _nameController.dispose();
 _guardianNameController.dispose();
 _guardianPhoneController.dispose();
 super.dispose();
 }

 Future<void> _next() async {
 if (_step < _labels.length - 1) {
 setState(() => _step++);
 return;
 }

 // Final step -> submit to backend
 setState(() {
 _saving = true;
 _saveError = null;
 });

 final body = {
 'name': _nameController.text.trim(),
 'age': _dob != null ? DateTime.now().year - _dob!.year : 0,
 'dateOfBirth': _dob?.toIso8601String().split('T').first,
 'gender': _gender.toLowerCase(),
 'enrolmentCenter': _enrolmentCenter,
 'externalSubjectId': null,
 'aadhaarToken':
 _aadhaarLinked ? 'TOK-MANUAL-${DateTime.now().millisecondsSinceEpoch}' : null,
 'guardians': [
 {
 'name': _guardianNameController.text.trim(),
 'relationship': 'Guardian',
 'phone': _guardianPhoneController.text.trim(),
 'accessLevel': 'full',
 }
 ],
 'fingerprints': _biometricScanned
 ? [
 {
 'hand': 'RIGHT',
 'finger': 'THUMB',
 'imageRef': 'manual_scan_${DateTime.now().millisecondsSinceEpoch}.png',
 'qualityPercent': (_scanQuality * 100).round(),
 }
 ]
 : [],
 };

 try {
 final api = ref.read(childApiServiceProvider);
 await api.enrolChild(body);
 ref.invalidate(childrenFromApiProvider);
 if (mounted) {
 setState(() {
 _saving = false;
 _submitted = true;
 });
 }
 } catch (e) {
 if (mounted) {
 setState(() {
 _saving = false;
 _saveError = 'Failed to save: $e';
 });
 }
 }
 }

 void _back() {
 if (_step > 0) setState(() => _step--);
 }

 @override
 Widget build(BuildContext context) {
 if (_submitted) return _buildSuccess(context);

 return Scaffold(
 appBar: AppBar(
 leading: BackButton(onPressed: () => context.pop()),
 title: const Text('New Enrolment'),
 ),
 body: SafeArea(
 child: Column(
  crossAxisAlignment: CrossAxisAlignment.stretch,
 children: [
 Padding(
  padding: const EdgeInsets.fromLTRB(20, 8, 20, 0),
 child: _StepHeader(
 step: _step,
 total: _labels.length,
 currentLabel: _labels[_step],
 ),
 ),
 Expanded(child: _buildStep()),
 Padding(
 padding: const EdgeInsets.all(20),
 child: Column(
 mainAxisSize: MainAxisSize.min,
 children: [
 if (_saveError != null)
 Padding(
 padding: const EdgeInsets.only(bottom: 8),
 child: Text(
 _saveError!,
 style: const TextStyle(color: Colors.red),
 ),
 ),
 Row(
  children: [
    if (_step > 0) ...[
      Expanded(
        child: OutlinedButton(
          onPressed: _back,
          child: const Text('Back'),
        ),
      ),
      const SizedBox(width: 12),
    ],
    Expanded(
      child: ElevatedButton(
        onPressed: (_canProceed() && !_saving) ? _next : null,
        child: _saving
            ? const SizedBox(
                height: 18,
                width: 18,
                child: CircularProgressIndicator(strokeWidth: 2),
              )
            : Text(
                _step == _labels.length - 1
                    ? 'Confirm & Submit'
                    : 'Next',
              ),
      ),
    ),
  ],
),
      ],
    ),
  ),
],
),
),
);
}
 bool _canProceed() {
 return switch (_step) {
 0 => _nameController.text.trim().isNotEmpty && _dob != null,
 1 => _biometricScanned,
 _ => true,
  };
 }

 Widget _buildStep() {
 return switch (_step) {
 0 => _demographics(),
 1 => _biometric(),
 2 => _aadhaar(),
 3 => _iot(),
 _ => _review(),
 };
 }

 Widget _demographics() {
 return ListView(
 padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
 children: [
 TextFormField(
 controller: _nameController,
 decoration: const InputDecoration(labelText: 'Child name'),
 onChanged: (_) => setState(() {}),
 ),
 const SizedBox(height: 8),
 ListTile(
 contentPadding: EdgeInsets.zero,
 title: const Text('Date of birth'),
 subtitle: Text(_dob == null ? 'Select date' : _dob!.toString().split(' ').first),
 trailing: const Icon(Icons.calendar_today),
 onTap: () async {
 final picked = await showDatePicker(
 context: context,
 initialDate: DateTime(2020),
 firstDate: DateTime(2010),
 lastDate: DateTime.now(),
 );
 if (picked != null) setState(() => _dob = picked);
 },
 ),
 const SizedBox(height: 8),
 SegmentedButton<String>(
 segments: const [
 ButtonSegment(value: 'Male', label: Text('Male')),
 ButtonSegment(value: 'Female', label: Text('Female')),
 ],
 selected: {_gender},
 onSelectionChanged: (s) => setState(() => _gender = s.first),
 ),
 const SizedBox(height: 16),
 TextFormField(
 controller: _guardianNameController,
 decoration: const InputDecoration(labelText: 'Guardian name'),
 ),
 const SizedBox(height: 16),
 TextFormField(
 controller: _guardianPhoneController,
 keyboardType: TextInputType.phone,
 decoration: const InputDecoration(labelText: 'Guardian phone'),
 ),
 const SizedBox(height: 16),
 DropdownButtonFormField<String>(
 value: _enrolmentCenter,
 isExpanded: true,
 decoration: const InputDecoration(labelText: 'Enrolment center'),
 items: const [
 DropdownMenuItem(value: 'Delhi Central Centre', child: Text('Delhi Central Centre')),
 DropdownMenuItem(value: 'Mumbai West Centre', child: Text('Mumbai West Centre')),
 ],
 onChanged: (v) {
 if (v != null) setState(() => _enrolmentCenter = v);
 },
 ),
 ],
 );
 }

 Widget _biometric() {
 final qualityLabel = _scanQuality >= 0.85
 ? 'Excellent'
 : _scanQuality >= 0.7
 ? 'Good'
 : _scanQuality >= 0.5
 ? 'Fair'
 : 'Poor';

 return ListView(
 padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
 children: [
 Center(
 child: ScanRingWidget(
 key: ValueKey(_scanAttempt),
 onScanComplete: () {
 if (!mounted) return;
 setState(() {
 _biometricScanned = true;
 _scanQuality = 0.87;
 });
 },
 ),
 ),
 const SizedBox(height: 24),
 LinearProgressIndicator(value: _biometricScanned ? _scanQuality : 0),
 const SizedBox(height: 8),
 Text(
 _biometricScanned
 ? 'Quality: ${(_scanQuality * 100).round()}% · $qualityLabel'
 : 'Place finger on scanner…',
 textAlign: TextAlign.center,
 ),
 const SizedBox(height: 12),
 OutlinedButton(
 onPressed: () => setState(() {
 _biometricScanned = false;
 _scanQuality = 0;
 _scanAttempt++;
 }),
 child: const Text('Re-capture'),
 ),
 if (_biometricScanned) ...[
 const SizedBox(height: 8),
 Text(
 'Scan detected · Quality: ${(_scanQuality * 100).round()}% · Proceed',
 textAlign: TextAlign.center,
 style: Theme.of(context).textTheme.bodySmall,
 ),
 ],
 ],
 );
 }

 Widget _aadhaar() {
 return Padding(
 padding: const EdgeInsets.all(20),
 child: AnimatedSwitcher(
 duration: const Duration(milliseconds: 300),
 child: _aadhaarLinked
 ? const Chip(
 key: ValueKey('linked'),
 label: Text('Aadhaar Linked ✓'),
 backgroundColor: Color(0x3310B981),
 )
: Column(
 key: const ValueKey('form'),
 crossAxisAlignment: CrossAxisAlignment.stretch,
 children: [
 const TextField(
 decoration: InputDecoration(
 labelText: 'Aadhaar reference',
 hintText: 'XXXX-XXXX-1234',
 ),
 ),
 const SizedBox(height: 16),
 ElevatedButton(
 onPressed: () => setState(() => _aadhaarLinked = true),
 child: const Text('Link to profile'),
 ),
  ],
 ),
 ),
 );
 }

 Widget _iot() {
 return ListView(
 padding: const EdgeInsets.all(20),
 children: [
 const Center(child: Icon(Icons.nfc, size: 64)),
 const SizedBox(height: 16),
 DropdownButtonFormField<String>(
 value: _selectedDevice,
 isExpanded: true,
 hint: const Text('Select GPS device'),
 decoration: const InputDecoration(labelText: 'GPS device'),
 items: const [
 DropdownMenuItem(value: 'v2', child: Text('CureBlock GPS Band v2')),
 DropdownMenuItem(value: 'v1', child: Text('CureBlock GPS Band v1')),
 ],
 onChanged: (v) => setState(() => _selectedDevice = v),
 ),
 if (_selectedDevice != null) ...[
 const SizedBox(height: 16),
 Card(
 child: ListTile(
 leading: const Icon(Icons.watch),
 title: Text(_selectedDevice == 'v2' ? 'GPS Band v2' : 'GPS Band v1'),
 subtitle: const Text('RFID paired · Ready to assign'),
 ),
 ),
 ],
 ],
 );
 }

 Widget _review() {
 return ListView(
 padding: const EdgeInsets.all(20),
 children: [
 Card(
 child: Padding(
 padding: const EdgeInsets.all(16),
 child: Column(
 crossAxisAlignment: CrossAxisAlignment.start,
 children: [
 Text('Name: ${_nameController.text}'),
 Text('DOB: ${_dob?.toString().split(' ').first ?? '—'}'),
 Text('Gender: $_gender'),
 Text('Guardian: ${_guardianNameController.text}'),
 Text('Phone: ${_guardianPhoneController.text}'),
 Text('Center: $_enrolmentCenter'),
 Text('Aadhaar: ${_aadhaarLinked ? 'Linked' : 'Pending'}'),
 Text('Device: ${_selectedDevice ?? 'Not assigned'}'),
 ],
 ),
  ),
 ),
 ],
 );
 }

 Widget _buildSuccess(BuildContext context) {
 return Scaffold(
 appBar: AppBar(
 leading: BackButton(onPressed: () => context.pop()),
 title: const Text('Enrolment Complete'),
 ),
 body: Center(
 child: Column(
 mainAxisSize: MainAxisSize.min,
 children: [
 const Icon(Icons.check_circle, size: 80, color: Colors.green),
 const SizedBox(height: 16),
 Text('${_nameController.text} enrolled successfully',
 style: Theme.of(context).textTheme.titleLarge),
 const SizedBox(height: 24),
 ElevatedButton(
 onPressed: () => context.pop(),
 child: const Text('Done'),
 ),
 ],
 ),
 ),
 );
 }
}

class _StepHeader extends StatelessWidget {
 const _StepHeader({required this.step, required this.total, required this.currentLabel});

 final int step;
 final int total;
 final String currentLabel;

 @override
 Widget build(BuildContext context) {
 return Column(
 crossAxisAlignment: CrossAxisAlignment.stretch,
 children: [
 const SizedBox(height: 8),
 Text('Step ${step + 1} of $total · $currentLabel',
 style: Theme.of(context).textTheme.titleMedium),
 const SizedBox(height: 8),
 LinearProgressIndicator(value: (step + 1) / total),
 ],
 );
 }
}