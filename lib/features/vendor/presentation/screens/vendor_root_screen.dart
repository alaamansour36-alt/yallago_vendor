import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubit/vendor_auth_cubit.dart';
import 'vendor_dashboard_screen.dart';
import 'vendor_login_screen.dart';

class VendorRootScreen extends StatelessWidget {
  const VendorRootScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<VendorAuthCubit, VendorAuthState>(
      builder: (context, authState) {
        if (!authState.isAuthenticated) {
          return const VendorLoginScreen();
        }
        return const VendorDashboardScreen();
      },
    );
  }
}
