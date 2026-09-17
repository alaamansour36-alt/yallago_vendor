import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/network/api_client.dart';
import '../data/repositories/vendor_auth_repository.dart';
import '../data/repositories/vendor_catalog_repository.dart';
import '../data/repositories/vendor_orders_repository.dart';
import '../data/services/vendor_auth_service.dart';
import '../data/services/vendor_catalog_service.dart';
import '../data/services/vendor_orders_service.dart';
import 'cubit/vendor_auth_cubit.dart';
import 'cubit/vendor_catalog_cubit.dart';
import 'cubit/vendor_orders_cubit.dart';
import 'vendor_screens.dart';

class VendorAppShell extends StatelessWidget {
  const VendorAppShell({super.key});

  @override
  Widget build(BuildContext context) {
    final apiClient = ApiClient();
    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider.value(value: apiClient),
        RepositoryProvider(
          create: (_) => VendorAuthRepository(VendorAuthService(apiClient)),
        ),
        RepositoryProvider(
          create: (_) =>
              VendorCatalogRepository(VendorCatalogService(apiClient)),
        ),
        RepositoryProvider(
          create: (_) => VendorOrdersRepository(VendorOrdersService(apiClient)),
        ),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(
            create: (context) =>
                VendorAuthCubit(context.read<VendorAuthRepository>()),
          ),
          BlocProvider(
            create: (context) =>
                VendorCatalogCubit(context.read<VendorCatalogRepository>()),
          ),
          BlocProvider(
            create: (context) =>
                VendorOrdersCubit(context.read<VendorOrdersRepository>()),
          ),
        ],
        child: BlocListener<VendorAuthCubit, VendorAuthState>(
          listenWhen: (previous, current) =>
              previous.session?.token != current.session?.token,
          listener: (context, state) {
            context.read<ApiClient>().updateToken(state.session?.token);
            if (state.isAuthenticated) {
              context.read<VendorCatalogCubit>().load();
              context.read<VendorOrdersCubit>().load();
            }
          },
          child: const VendorRootScreen(),
        ),
      ),
    );
  }
}
