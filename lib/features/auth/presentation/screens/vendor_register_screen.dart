import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/widgets/shared_widgets.dart';
import '../../data/services/vendor_auth_service.dart';
import '../cubit/vendor_auth_cubit.dart';

class VendorRegisterScreen extends StatefulWidget {
  const VendorRegisterScreen({super.key});

  @override
  State<VendorRegisterScreen> createState() => _VendorRegisterScreenState();
}

class _VendorRegisterScreenState extends State<VendorRegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _fullNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();
  final _storeNameController = TextEditingController();
  final _storeDescriptionController = TextEditingController();
  final _businessAddressController = TextEditingController();
  final _logoUrlController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _storeNameController.dispose();
    _storeDescriptionController.dispose();
    _businessAddressController.dispose();
    _logoUrlController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Vendor registration')),
      body: SafeArea(
        child: BlocListener<VendorAuthCubit, VendorAuthState>(
          listenWhen: (previous, current) =>
              previous.error != current.error ||
              previous.isAuthenticated != current.isAuthenticated,
          listener: (context, state) {
            if (state.error != null && state.error!.isNotEmpty) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.error!)),
              );
            }
            if (state.isAuthenticated) {
              Navigator.of(context).pop();
            }
          },
          child: BlocBuilder<VendorAuthCubit, VendorAuthState>(
            builder: (context, state) => ListView(
              padding: const EdgeInsets.all(20),
              children: [
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      _buildField(_fullNameController, 'Full name'),
                      _buildField(
                        _emailController,
                        'Email',
                        keyboardType: TextInputType.emailAddress,
                      ),
                      _buildField(
                        _phoneController,
                        'Phone number',
                        keyboardType: TextInputType.phone,
                      ),
                      _buildField(_addressController, 'Address',
                          required: false),
                      _buildField(_storeNameController, 'Store name'),
                      _buildField(
                        _storeDescriptionController,
                        'Store description',
                        required: false,
                        maxLines: 3,
                      ),
                      _buildField(
                        _businessAddressController,
                        'Business address',
                        required: false,
                      ),
                      _buildField(
                        _logoUrlController,
                        'Logo URL',
                        required: false,
                        keyboardType: TextInputType.url,
                      ),
                      _buildField(
                        _passwordController,
                        'Password',
                        obscureText: true,
                      ),
                      _buildField(
                        _confirmPasswordController,
                        'Confirm password',
                        obscureText: true,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Confirm password is required';
                          }
                          if (value != _passwordController.text) {
                            return 'Passwords do not match';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 20),
                      PrimaryButton(
                        label:
                            state.loading ? 'Creating account...' : 'Register',
                        icon: Icons.storefront_outlined,
                        onTap: state.loading
                            ? () {}
                            : () {
                                if (_formKey.currentState!.validate()) {
                                  context.read<VendorAuthCubit>().register(
                                        VendorRegisterRequest(
                                          fullName:
                                              _fullNameController.text.trim(),
                                          email: _emailController.text.trim(),
                                          phoneNumber:
                                              _phoneController.text.trim(),
                                          address: _optional(
                                              _addressController.text),
                                          password: _passwordController.text,
                                          confirmPassword:
                                              _confirmPasswordController.text,
                                          storeName:
                                              _storeNameController.text.trim(),
                                          storeDescription: _optional(
                                              _storeDescriptionController.text),
                                          businessAddress: _optional(
                                              _businessAddressController.text),
                                          logoUrl: _optional(
                                              _logoUrlController.text),
                                        ),
                                      );
                                }
                              },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildField(
    TextEditingController controller,
    String label, {
    bool required = true,
    bool obscureText = false,
    int maxLines = 1,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        controller: controller,
        obscureText: obscureText,
        maxLines: obscureText ? 1 : maxLines,
        keyboardType: keyboardType,
        validator: validator ??
            (value) {
              if (!required) {
                return null;
              }
              if (value == null || value.trim().isEmpty) {
                return '$label is required';
              }
              return null;
            },
        decoration: InputDecoration(labelText: label),
      ),
    );
  }

  String? _optional(String value) {
    final trimmed = value.trim();
    return trimmed.isEmpty ? null : trimmed;
  }
}
