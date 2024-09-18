import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:ostad_assignment/models/product.dart';

class UpdateProductScreen extends StatefulWidget {
  final Product product;
  const UpdateProductScreen({required this.product, super.key});

  @override
  State<UpdateProductScreen> createState() => _UpdateProductScreenState();
}

class _UpdateProductScreenState extends State<UpdateProductScreen> {
  late TextEditingController _productNameTEController;
  late TextEditingController _unitPriceTEController;
  late TextEditingController _totalPriceTEController;
  late TextEditingController _imageTEController;
  late TextEditingController _codeTEController;
  late TextEditingController _quantityTEController;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _inProgress = false;

  @override
  void initState() {
    super.initState();
    // Initialize the controllers inside initState
    _productNameTEController = TextEditingController(text: widget.product.productName);
    _unitPriceTEController = TextEditingController(text: widget.product.unitPrice);
    _totalPriceTEController = TextEditingController(text: widget.product.totalPrice);
    _imageTEController = TextEditingController(text: widget.product.productImage);
    _codeTEController = TextEditingController(text: widget.product.productCode);
    _quantityTEController = TextEditingController(text: widget.product.quantity);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Update Product'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: _updateProductForm(),
        ),
      ),
    );
  }

  Widget _updateProductForm() {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildFormTitle('Product Information'),
          const SizedBox(height: 20),
          _buildTextFormField(
            controller: _productNameTEController,
            labelText: 'Product Name',
            hintText: 'Enter product name',
          ),
          const SizedBox(height: 16),
          _buildTextFormField(
            controller: _unitPriceTEController,
            labelText: 'Unit Price',
            hintText: 'Enter unit price',
          ),
          const SizedBox(height: 16),
          _buildTextFormField(
            controller: _totalPriceTEController,
            labelText: 'Total Price',
            hintText: 'Enter total price',
          ),
          const SizedBox(height: 16),
          _buildTextFormField(
            controller: _imageTEController,
            labelText: 'Product Image',
            hintText: 'Enter image URL',
          ),
          const SizedBox(height: 16),
          _buildTextFormField(
            controller: _codeTEController,
            labelText: 'Product Code',
            hintText: 'Enter product code',
          ),
          const SizedBox(height: 16),
          _buildTextFormField(
            controller: _quantityTEController,
            labelText: 'Quantity',
            hintText: 'Enter quantity',
          ),
          const SizedBox(height: 24),
          _inProgress
              ? Center(
            child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.teal),
            ),
          )
              : Center(
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white, backgroundColor: Colors.teal, // Text color
                padding: const EdgeInsets.symmetric(
                  vertical: 16.0,
                  horizontal: 100.0,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 5,
              ),
              onPressed: _onTapUpdateProductButton,
              child: const Text(
                'Update Product',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

// Helper function to build form title
  Widget _buildFormTitle(String title) {
    return Text(
      title,
      style: TextStyle(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: Colors.teal,
      ),
    );
  }

// Helper function to build styled text fields
  Widget _buildTextFormField({
    required TextEditingController controller,
    required String labelText,
    required String hintText,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: labelText,
        hintText: hintText,
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        contentPadding: const EdgeInsets.symmetric(vertical: 18, horizontal: 16),
        labelStyle: TextStyle(color: Colors.teal),
        hintStyle: TextStyle(color: Colors.grey[400]),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.teal, width: 2),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.grey[300]!, width: 1),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.red, width: 2),
        ),
      ),
      validator: (String? value) {
        if (value == null || value.isEmpty) {
          return 'Enter a valid value';
        }
        return null;
      },
    );
  }
  
  void _onTapUpdateProductButton() {
    if (_formKey.currentState!.validate()) {
      updateProduct();
    }
  }

  Future<void> updateProduct() async {
    _inProgress = true;
    String id = widget.product.id;
    Uri uri = Uri.parse('http://164.68.107.70:6060/api/v1/UpdateProduct/$id');
    Map<String, dynamic> requestBody = {
      "Img": _imageTEController.text,
      "ProductCode": _codeTEController.text,
      "ProductName": _productNameTEController.text,
      "Qty": _quantityTEController.text,
      "TotalPrice": _totalPriceTEController.text,
      "UnitPrice": _unitPriceTEController.text
    };

    Response response = await post(
      uri,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(requestBody),
    );

    if (response.statusCode == 200) {
      print("Product updated successfully.");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('${widget.product.productName} update successful')),
      );
      _inProgress = false;
      Navigator.pop(context, true);// Optionally pop the screen after update
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to update')),
      );
    }
  }

  @override
  void dispose() {
    _productNameTEController.dispose();
    _quantityTEController.dispose();
    _totalPriceTEController.dispose();
    _unitPriceTEController.dispose();
    _imageTEController.dispose();
    _codeTEController.dispose();
    super.dispose();
  }
}
