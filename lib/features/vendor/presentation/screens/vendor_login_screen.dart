import 'package:easy_localization/easy_localization.dart' hide TextDirection;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/layout.dart';
import '../../../../core/widgets/shared_widgets.dart';
import '../cubit/vendor_auth_cubit.dart';

class VendorLoginScreen extends StatefulWidget {
  const VendorLoginScreen({super.key});

  @override
  State<VendorLoginScreen> createState() => _VendorLoginScreenState();
}

class _VendorLoginScreenState extends State<VendorLoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController(text: 'vendor@example.com');
  final _passwordController = TextEditingController(text: 'P@ssw0rd123');

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('YallaGo Vendor'),
        actions: [
          const LanguageButton(),
        ],
      ),
      body: SafeArea(
        child: BlocConsumer<VendorAuthCubit, VendorAuthState>(
          listener: (context, state) {
            if (state.error != null && state.error!.isNotEmpty) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.error!)),
              );
            }
          },
          builder: (context, state) => ListView(
            padding: pagePadding,
            children: [
              Container(
                padding: const EdgeInsets.all(20),
                decoration: const BoxDecoration(
                  gradient:
                      LinearGradient(colors: [AppColors.ink, AppColors.nile]),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(24),
                    topRight: Radius.circular(24),
                    bottomLeft: Radius.circular(24),
                    bottomRight: Radius.circular(6),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const TicketLabel(label: 'Vendor APIs', light: true),
                    const SizedBox(height: 12),
                    Text(
                      'vendor.login.title'.tr(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 28,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'vendor.login.subtitle'.tr(),
                      style:
                          const TextStyle(color: Colors.white70, height: 1.5),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('vendor.login.email'.tr(),
                        style: const TextStyle(fontWeight: FontWeight.w800)),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      textDirection: TextDirection.ltr,
                      validator: (value) => (value == null || value.isEmpty)
                          ? 'vendor.login.email_required'.tr()
                          : null,
                      decoration: InputDecoration(
                        hintText: 'vendor.login.email_hint'.tr(),
                        prefixIcon: const Icon(Icons.alternate_email),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text('vendor.login.password'.tr(),
                        style: const TextStyle(fontWeight: FontWeight.w800)),
                    const SizedBox(height: 8),
                    TextFormField(
                      controller: _passwordController,
                      obscureText: true,
                      textDirection: TextDirection.ltr,
                      validator: (value) => (value == null || value.isEmpty)
                          ? 'vendor.login.password_required'.tr()
                          : null,
                      decoration: InputDecoration(
                        hintText: 'vendor.login.password_hint'.tr(),
                        prefixIcon: const Icon(Icons.lock_outline),
                      ),
                    ),
                    const SizedBox(height: 20),
                    PrimaryButton(
                      label: state.loading
                          ? 'vendor.login.signing_in'.tr()
                          : 'vendor.login.sign_in'.tr(),
                      icon: Icons.login,
                      onTap: state.loading
                          ? () {}
                          : () {
                              if (_formKey.currentState!.validate()) {
                                context.read<VendorAuthCubit>().login(
                                      email: _emailController.text.trim(),
                                      password: _passwordController.text,
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
    );
  }
}
