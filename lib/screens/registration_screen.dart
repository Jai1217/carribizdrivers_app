import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class RegistrationScreen extends StatefulWidget {
  final String phoneNumber;

  const RegistrationScreen({super.key, required this.phoneNumber});

  @override
  // ignore: library_private_types_in_public_api
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  String? _identityProof, _licenseNumber, _vehicleType, _vehicleNumber, _vehicleCapacity;
  bool _isIdentityProofUploaded = false;
  bool _isLicenseUploaded = false;
  bool _isVehiclePhotoUploaded = false;

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _addressController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Register with us',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, fontFamily: 'Roboto'),
                ),
                const Text(
                  'so that we can get to know you',
                  style: TextStyle(fontSize: 16, color: Colors.grey, fontFamily: 'Roboto'),
                ),
                const SizedBox(height: 24),
                _buildTextField('Full Name', _fullNameController),
                _buildTextField('Phone Number', null, initialValue: widget.phoneNumber, enabled: false),
                _buildTextField('Email', _emailController, keyboardType: TextInputType.emailAddress),
                _buildTextField('Address', _addressController, maxLines: 3),
                _buildDropdown('Identity Proof', ['Aadhar Card', 'Pan Card'], (value) => setState(() => _identityProof = value)),
                if (_identityProof != null)
                  _buildUploadButton('Upload Identity Proof', () => setState(() => _isIdentityProofUploaded = true)),
                _buildUploadButton('Upload License', () => setState(() => _isLicenseUploaded = true)),
                _buildTextField('License Number', _licenseNumber as TextEditingController?),
                _buildDropdown('Vehicle Type', ['Bike', 'Truck', 'Minitruck'], (value) => setState(() => _vehicleType = value)),
                _buildTextField('Vehicle Number', _vehicleNumber as TextEditingController?, inputFormatters: [UpperCaseTextFormatter()]),
                _buildTextField('Vehicle Capacity', _vehicleCapacity as TextEditingController?),
                _buildUploadButton('Upload Vehicle Photo', () => setState(() => _isVehiclePhotoUploaded = true)),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: _isFormComplete() ? _submitForm : null,
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 50),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                  ),
                  child: const Text('Complete'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String label, TextEditingController? controller, {String? initialValue, bool enabled = true, int maxLines = 1, TextInputType keyboardType = TextInputType.text, List<TextInputFormatter>? inputFormatters}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        controller: controller,
        initialValue: initialValue,
        enabled: enabled,
        maxLines: maxLines,
        keyboardType: keyboardType,
        inputFormatters: inputFormatters,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        ),
        style: const TextStyle(fontFamily: 'Roboto'),
        validator: (value) => value?.isEmpty ?? true ? 'This field is required' : null,
      ),
    );
  }

  Widget _buildDropdown(String label, List<String> items, Function(String?) onChanged) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: DropdownButtonFormField<String>(
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        ),
        items: items.map((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value, style: const TextStyle(fontFamily: 'Roboto')),
          );
        }).toList(),
        onChanged: onChanged,
        validator: (value) => value == null ? 'This field is required' : null,
      ),
    );
  }

  Widget _buildUploadButton(String label, VoidCallback onPressed) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: ElevatedButton.icon(
        onPressed: onPressed,
        icon: const Icon(Icons.upload_file),
        label: Text(label),
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      ),
    );
  }

  bool _isFormComplete() {
    return _formKey.currentState?.validate() == true &&
        _isIdentityProofUploaded &&
        _isLicenseUploaded &&
        _isVehiclePhotoUploaded;
  }

  void _submitForm() {
    if (_isFormComplete()) {
      // Capture values from controllers
      final fullName = _fullNameController.text;
      final email = _emailController.text;
      final address = _addressController.text;
      final licenseNumber = _licenseNumber;
      final vehicleNumber = _vehicleNumber;
      final vehicleCapacity = _vehicleCapacity;

      // Use the captured values
      if (kDebugMode) {
        print('Form submitted');
        print('Full Name: $fullName');
        print('Email: $email');
        print('Address: $address');
        print('Identity Proof: $_identityProof');
        print('License Number: $licenseNumber');
        print('Vehicle Type: $_vehicleType');
        print('Vehicle Number: $vehicleNumber');
        print('Vehicle Capacity: $vehicleCapacity');
      }
    }
  }
}

class UpperCaseTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    return TextEditingValue(
      text: newValue.text.toUpperCase(),
      selection: newValue.selection,
    );
  }
}
