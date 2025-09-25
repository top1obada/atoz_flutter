import 'package:a_to_z_dto/AddressDTO/adress_dto.dart';
import 'package:flutter/material.dart';

class WDUpdateAddress extends StatefulWidget {
  const WDUpdateAddress({
    super.key,
    required this.address,
    required this.onUpdateAddress,
  });

  final ClsAddressDTO address;
  final Function(ClsAddressDTO)? onUpdateAddress;

  @override
  State<WDUpdateAddress> createState() => _WDUpdateAddressState();
}

class _WDUpdateAddressState extends State<WDUpdateAddress> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _cityController;
  late TextEditingController _areaNameController;
  late TextEditingController _streetController;
  late TextEditingController _buildingController;
  late TextEditingController _notesController;

  @override
  void initState() {
    super.initState();
    // Initialize controllers with current address data
    _cityController = TextEditingController(text: widget.address.city ?? '');
    _areaNameController = TextEditingController(
      text: widget.address.areaName ?? '',
    );
    _streetController = TextEditingController(
      text: widget.address.streetNameOrNumber ?? '',
    );
    _buildingController = TextEditingController(
      text: widget.address.buildingName ?? '',
    );
    _notesController = TextEditingController(
      text: widget.address.importantNotes ?? '',
    );
  }

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

  void _onUpdatePressed() {
    if (_formKey.currentState?.validate() ?? false) {
      final updatedAddressDTO = ClsAddressDTO(
        personID: widget.address.personID,
        addressID: widget.address.addressID, // Keep the same ID
        city: _cityController.text,
        areaName: _areaNameController.text,
        streetNameOrNumber: _streetController.text,
        buildingName: _buildingController.text,
        importantNotes:
            _notesController.text.isNotEmpty ? _notesController.text : null,
      );

      widget.onUpdateAddress?.call(updatedAddressDTO);
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
              // Title with Address ID
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'تعديل العنوان',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.blue[800],
                      fontFamily: 'Tajawal',
                    ),
                  ),
                  if (widget.address.addressID != null)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.blue[50],
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: Colors.blue[200]!),
                      ),
                      child: Text(
                        'ID: ${widget.address.addressID}',
                        style: TextStyle(
                          color: Colors.blue[800],
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                          fontFamily: 'Tajawal',
                        ),
                      ),
                    ),
                ],
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

              // Update Button (full width)
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _onUpdatePressed,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green[700],
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    elevation: 2,
                  ),
                  child: Text(
                    'تحديث العنوان',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
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
        fillColor: Colors.grey[50],
        prefixIcon: Icon(icon, color: Colors.blue[700]),
        contentPadding: EdgeInsets.symmetric(
          horizontal: 16,
          vertical: maxLines > 1 ? 12 : 14,
        ),
      ),
      validator: validator,
    );
  }
}
