import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';
import 'camera_registration.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _RegistrationScreenState createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _licenseNumberController = TextEditingController();
  final TextEditingController _vehicleNumberController = TextEditingController();
  final TextEditingController _vehicleNameController = TextEditingController();
  final TextEditingController _vehicleCapacityController = TextEditingController();
  String? _identityProof, _vehicleType;
  bool _isIdentityProofUploaded = false;
  bool _isLicenseUploaded = false;
  bool _isVehiclePhotoUploaded = false;
  bool _showIdentityProofOptions = false;
  bool _showVehicleTypeOptions = false;

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _addressController.dispose();
    _licenseNumberController.dispose();
    _vehicleNumberController.dispose();
    _vehicleNameController.dispose();
    _vehicleCapacityController.dispose();
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
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, fontFamily: 'Modern Sans Serif'),
                ),
                const Text(
                  'so that we can get to know you',
                  style: TextStyle(fontSize: 16, color: Colors.grey, fontFamily: 'Modern Sans Serif'),
                ),
                const SizedBox(height: 24),
                _buildTextField(
                  'Full Name',
                  _fullNameController,
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z\s]')),
                  ],
                ),
                _buildTextField('Email', _emailController, keyboardType: TextInputType.emailAddress),
                _buildTextField('Address', _addressController, maxLines: 3),
                _buildCustomDropdown(
                  'Identity Proof',
                  ['Aadhar Card', 'Pan Card'],
                  _identityProof,
                  _showIdentityProofOptions,
                  (value) {
                    setState(() {
                      _identityProof = value;
                      _showIdentityProofOptions = false;
                    });
                  },
                  () => setState(() => _showIdentityProofOptions = !_showIdentityProofOptions),
                ),
                if (_identityProof != null)
                  _buildUploadButton('Upload Identity Proof', () => _requestStoragePermissionAndUpload('identityProof')),
                _buildUploadButton('Upload License', () => _requestStoragePermissionAndUpload('license')),
                _buildTextField(
                  'License Number',
                  _licenseNumberController,
                  inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'[0-9]'))],
                ),
                _buildCustomDropdown(
                  'Vehicle Type',
                  ['Bike', 'Truck', 'Minitruck', 'Pickup', '3 Wheeler'],
                  _vehicleType,
                  _showVehicleTypeOptions,
                  (value) {
                    setState(() {
                      _vehicleType = value;
                      _showVehicleTypeOptions = false;
                      if (_vehicleType == 'Bike') {
                        _vehicleCapacityController.clear();
                      }
                    });
                  },
                  () => setState(() => _showVehicleTypeOptions = !_showVehicleTypeOptions),
                ),
                _buildTextField(
                  'Vehicle Name',
                  _vehicleNameController,
                  hintText: 'e.g.,Mahindra Bolero Pikup',
                ),
                _buildTextField(
                  'Vehicle Number',
                  _vehicleNumberController,
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'[A-Z0-9]')),
                    UpperCaseTextFormatter(),
                  ],
                  hintText: 'e.g., TSXX XX XXXX',
                ),
                _buildTextField(
                  'Vehicle Capacity',
                  _vehicleCapacityController,
                  hintText: 'e.g., in kgs',
                  enabled: _vehicleType != 'Bike',
                ),
                _buildUploadButton('Upload Vehicle Photo', () => _requestStoragePermissionAndUpload('vehiclePhoto')),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: _isFormComplete() ? _submitForm : null,
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(double.infinity, 50),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    backgroundColor: const Color.fromRGBO(160, 34, 45, 1),
                    foregroundColor: Colors.white,
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

  Widget _buildTextField(
    String label,
    TextEditingController? controller, {
    String? initialValue,
    bool enabled = true,
    int maxLines = 1,
    TextInputType keyboardType = TextInputType.text,
    List<TextInputFormatter>? inputFormatters,
    String? hintText,
  }) {
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
          hintText: hintText,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: Colors.grey, width: 2.0),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: Colors.grey, width: 2.0),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
            borderSide: const BorderSide(color: Color.fromRGBO(160, 34, 45, 1), width: 2.0),
          ),
        ),
        style: const TextStyle(fontFamily: 'Modern Sans Serif'),
        validator: (value) => value?.isEmpty ?? true ? 'This field is required' : null,
      ),
    );
  }

  Widget _buildCustomDropdown(
    String label,
    List<String> items,
    String? value,
    bool showOptions,
    Function(String?) onChanged,
    VoidCallback onTap,
  ) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          InkWell(
            onTap: onTap,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey, width: 2.0),
              ),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          value ?? 'Select $label',
                          style: TextStyle(
                            color: value == null ? Colors.grey : Colors.black,
                            fontSize: 16,
                          ),
                        ),
                        Icon(
                          showOptions ? Icons.arrow_drop_up : Icons.arrow_drop_down,
                          color: Colors.grey,
                        ),
                      ],
                    ),
                  ),
                  if (showOptions)
                    Container(
                      decoration: BoxDecoration(
                        border: Border(
                          top: BorderSide(color: Colors.grey.shade300),
                        ),
                      ),
                      child: Column(
                        children: items.map((item) => InkWell(
                          onTap: () => onChanged(item),
                          child: Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                            decoration: BoxDecoration(
                              color: value == item ? Colors.grey.shade200 : Colors.white,
                            ),
                            child: Text(item, style: const TextStyle(fontSize: 16)),
                          ),
                        )).toList(),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildUploadButton(String label, VoidCallback onPressed) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: ElevatedButton.icon(
        onPressed: onPressed,
        icon: const Icon(Icons.upload),
        label: Text(label),
        style: ElevatedButton.styleFrom(
          minimumSize: const Size(double.infinity, 50),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          backgroundColor: const Color.fromARGB(255, 90, 74, 75),
          foregroundColor: Colors.white,
        ),
      ),
    );
  }

  bool _isFormComplete() {
    return _fullNameController.text.isNotEmpty &&
        _emailController.text.isNotEmpty &&
        _addressController.text.isNotEmpty &&
        _licenseNumberController.text.isNotEmpty &&
        _vehicleNumberController.text.isNotEmpty &&
        (_vehicleType == 'Bike' || _vehicleCapacityController.text.isNotEmpty) &&
        _isIdentityProofUploaded &&
        _isLicenseUploaded &&
        _isVehiclePhotoUploaded;
  }

  void _submitForm() {
    if (_formKey.currentState?.validate() ?? false) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const CameraGuideScreen(),
        ),
      );
    }
  }

  Future<void> _requestStoragePermissionAndUpload(String documentType) async {
    final status = await Permission.storage.request();
    if (status.isGranted) {
      setState(() {
        if (documentType == 'identityProof') {
          _isIdentityProofUploaded = true;
        } else if (documentType == 'license') {
          _isLicenseUploaded = true;
        } else if (documentType == 'vehiclePhoto') {
          _isVehiclePhotoUploaded = true;
        }
      });
    } else {
      debugPrint('Storage permission denied');
    }
  }
}

class UpperCaseTextFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    return TextEditingValue(
      text: newValue.text.toUpperCase(),
      selection: newValue.selection,
    );
  }
}