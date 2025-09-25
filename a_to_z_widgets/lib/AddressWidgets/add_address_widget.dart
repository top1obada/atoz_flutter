import 'package:a_to_z_dto/AddressDTO/adress_dto.dart';
import 'package:flutter/material.dart';

class WDAddAddress extends StatefulWidget {
  const WDAddAddress({super.key, required this.onAddAddress});

  final Function(ClsAddressDTO)? onAddAddress;

  @override
  State<WDAddAddress> createState() => _WDAddAddressState();
}

class _WDAddAddressState extends State<WDAddAddress> {
  final _formKey = GlobalKey<FormState>();
  final _cityController = TextEditingController();
  final _areaNameController = TextEditingController();
  final _streetController = TextEditingController();
  final _buildingController = TextEditingController();
  final _notesController = TextEditingController();

  bool _isLoading = false; // Add loading state

  @override
  void dispose() {
    _cityController.dispose();
    _areaNameController.dispose();
    _streetController.dispose();
    _buildingController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  String? _validateRequired(String? value, String fieldName) {
    if (value == null || value.isEmpty) {
      return 'يرجى إدخال $fieldName';
    }
    return null;
  }

  void _onAddPressed() async {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() {
        _isLoading = true; // Disable button
      });

      final addressDTO = ClsAddressDTO(
        city: _cityController.text,
        areaName: _areaNameController.text,
        streetNameOrNumber: _streetController.text,
        buildingName: _buildingController.text,
        importantNotes:
            _notesController.text.isNotEmpty ? _notesController.text : null,
      );

      // Call the callback function
      await widget.onAddAddress?.call(addressDTO);

      // Re-enable button after operation completes
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }

      // Clear form after submission
      _formKey.currentState?.reset();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      margin: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title
              Text(
                'إضافة عنوان جديد',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue[800],
                  fontFamily: 'Tajawal',
                ),
                textAlign: TextAlign.right,
              ),

              const SizedBox(height: 20),

              // City Field
              _buildTextField(
                controller: _cityController,
                label: 'المدينة *',
                hint: 'أدخل اسم المدينة',
                icon: Icons.location_city,
                validator: (value) => _validateRequired(value, 'المدينة'),
              ),

              const SizedBox(height: 16),

              // Area Name Field
              _buildTextField(
                controller: _areaNameController,
                label: 'اسم المنطقة *',
                hint: 'أدخل اسم المنطقة',
                icon: Icons.map,
                validator: (value) => _validateRequired(value, 'اسم المنطقة'),
              ),

              const SizedBox(height: 16),

              // Street Field
              _buildTextField(
                controller: _streetController,
                label: 'اسم الشارع أو الرقم *',
                hint: 'أدخل اسم الشارع أو الرقم',
                icon: Icons.streetview,
                validator: (value) => _validateRequired(value, 'اسم الشارع'),
              ),

              const SizedBox(height: 16),

              // Building Field
              _buildTextField(
                controller: _buildingController,
                label: 'اسم المبنى',
                hint: 'أدخل اسم المبنى (اختياري)',
                icon: Icons.apartment,
              ),

              const SizedBox(height: 16),

              // Important Notes Field
              _buildTextField(
                controller: _notesController,
                label: 'ملاحظات مهمة',
                hint: 'أدخل أي ملاحظات إضافية (اختياري)',
                icon: Icons.note,
                maxLines: 3,
              ),

              const SizedBox(height: 24),

              // Add Button with loading state
              SizedBox(
                width: double.infinity,
                child:
                    _isLoading
                        ? ElevatedButton(
                          onPressed: null, // Disabled when loading
                          style: ElevatedButton.styleFrom(
                            backgroundColor:
                                Colors.blue[300], // Lighter color when disabled
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation: 0,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                    Colors.white,
                                  ),
                                ),
                              ),
                              const SizedBox(width: 12),
                              Text(
                                'جاري الإضافة...',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Tajawal',
                                ),
                              ),
                            ],
                          ),
                        )
                        : ElevatedButton(
                          onPressed: _onAddPressed,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue[700],
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            elevation: 2,
                          ),
                          child: Text(
                            'إضافة العنوان',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Tajawal',
                            ),
                          ),
                        ),
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
    required IconData icon,
    String? Function(String?)? validator,
    int maxLines = 1,
  }) {
    return TextFormField(
      controller: controller,
      textAlign: TextAlign.right,
      maxLines: maxLines,
      enabled: !_isLoading, // Disable text fields when loading
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: Colors.blue[700], fontFamily: 'Tajawal'),
        hintText: hint,
        hintStyle: TextStyle(color: Colors.grey[500], fontFamily: 'Tajawal'),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.blue[300]!),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.blue[500]!),
        ),
        filled: true,
        fillColor:
            _isLoading
                ? Colors.grey[100]
                : Colors.grey[50], // Different color when disabled
        prefixIcon: Icon(
          icon,
          color: _isLoading ? Colors.grey[400] : Colors.blue[700],
        ),
        contentPadding: EdgeInsets.symmetric(
          horizontal: 16,
          vertical: maxLines > 1 ? 12 : 14,
        ),
      ),
      validator: validator,
    );
  }
}
