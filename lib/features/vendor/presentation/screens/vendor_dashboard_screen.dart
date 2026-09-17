import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/layout.dart';
import '../../../../core/widgets/shared_widgets.dart';
import '../../data/models/vendor_models.dart';
import '../cubit/vendor_auth_cubit.dart';
import '../cubit/vendor_catalog_cubit.dart';
import '../cubit/vendor_orders_cubit.dart';
import '../dialogs/category_dialog.dart';
import '../widgets/product_editor_sheet.dart';
import '../widgets/vendor_shared_widgets.dart';
import 'vendor_order_detail_screen.dart';

class VendorDashboardScreen extends StatefulWidget {
  const VendorDashboardScreen({super.key});

  @override
  State<VendorDashboardScreen> createState() => _VendorDashboardScreenState();
}

class _VendorDashboardScreenState extends State<VendorDashboardScreen> {
  int _index = 0;

  @override
  Widget build(BuildContext context) {
    final pages = [
      const VendorOverviewTab(),
      const VendorProductsTab(),
      const VendorOrdersTab(),
      const VendorCategoriesTab(),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text('vendor.dashboard.title'.tr()),
        actions: [
          const LanguageButton(),
          IconButton(
            onPressed: () => context.read<VendorAuthCubit>().logout(),
            icon: const Icon(Icons.logout),
          ),
        ],
      ),
      body: pages[_index],
      bottomNavigationBar: NavigationBar(
        key: ValueKey(context.locale.languageCode),
        selectedIndex: _index,
        onDestinationSelected: (value) => setState(() => _index = value),
        destinations: [
          NavigationDestination(
            icon: const Icon(Icons.dashboard_outlined),
            selectedIcon: const Icon(Icons.dashboard),
            label: 'vendor.dashboard.nav.overview'.tr(),
          ),
          NavigationDestination(
            icon: const Icon(Icons.inventory_2_outlined),
            selectedIcon: const Icon(Icons.inventory_2),
            label: 'vendor.dashboard.nav.products'.tr(),
          ),
          NavigationDestination(
            icon: const Icon(Icons.receipt_long_outlined),
            selectedIcon: const Icon(Icons.receipt_long),
            label: 'vendor.dashboard.nav.orders'.tr(),
          ),
          NavigationDestination(
            icon: const Icon(Icons.category_outlined),
            selectedIcon: const Icon(Icons.category),
            label: 'vendor.dashboard.nav.categories'.tr(),
          ),
        ],
      ),
    );
  }
}

class VendorOverviewTab extends StatelessWidget {
  const VendorOverviewTab({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<VendorCatalogCubit, VendorCatalogState>(
      builder: (context, catalogState) {
        return BlocBuilder<VendorOrdersCubit, VendorOrdersState>(
          builder: (context, ordersState) {
            final pendingOrders = ordersState.orders
                .where((order) => order.status.toLowerCase() == 'pending')
                .length;
            final availableProducts = catalogState.products
                .where((product) => product.isAvailable)
                .length;
            return RefreshIndicator(
              onRefresh: () async {
                final catalogCubit = context.read<VendorCatalogCubit>();
                final ordersCubit = context.read<VendorOrdersCubit>();
                await catalogCubit.load();
                await ordersCubit.load();
              },
              child: ListView(
                padding: pagePadding,
                children: [
                  OverviewHero(
                    pendingOrders: pendingOrders,
                    productsCount: catalogState.products.length,
                    categoriesCount: catalogState.categories.length,
                  ),
                  const SizedBox(height: 20),
                  SectionTitle(title: 'vendor.dashboard.quick_summary'.tr()),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: MetricCard(
                          label: 'vendor.dashboard.available_products'.tr(),
                          value: '$availableProducts',
                          icon: Icons.check_circle_outline,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: MetricCard(
                          label: 'vendor.dashboard.active_orders'.tr(),
                          value: '${ordersState.orders.length}',
                          icon: Icons.local_shipping_outlined,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  SectionTitle(title: 'vendor.dashboard.latest_orders'.tr()),
                  const SizedBox(height: 10),
                  if (ordersState.loading)
                    const Center(
                        child: Padding(
                      padding: EdgeInsets.all(24),
                      child: CircularProgressIndicator(),
                    ))
                  else if (ordersState.orders.isEmpty)
                    EmptyState(
                      icon: Icons.receipt_long_outlined,
                      title: 'vendor.dashboard.empty_orders_title'.tr(),
                      subtitle: 'vendor.dashboard.empty_orders_subtitle'.tr(),
                    )
                  else
                    ...ordersState.orders.take(3).map(
                          (order) => Padding(
                            padding: const EdgeInsets.only(bottom: 10),
                            child: VendorOrderCard(order: order),
                          ),
                        ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}

class VendorProductsTab extends StatelessWidget {
  const VendorProductsTab({super.key});

  void _showProductEditor(
    BuildContext context, {
    VendorProduct? product,
  }) {
    final catalogCubit = context.read<VendorCatalogCubit>();
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (_) => BlocProvider.value(
        value: catalogCubit,
        child: ProductEditorSheet(product: product),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<VendorCatalogCubit, VendorCatalogState>(
      listener: (context, state) {
        if (state.error != null && state.error!.isNotEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.error!)),
          );
        }
      },
      builder: (context, state) => RefreshIndicator(
        onRefresh: () => context.read<VendorCatalogCubit>().load(),
        child: ListView(
          padding: pagePadding,
          children: [
            SectionTitle(
              title: 'vendor.products.title'.tr(),
              action: 'vendor.products.add'.tr(),
              onAction: () => _showProductEditor(context),
            ),
            const SizedBox(height: 12),
            if (state.loading)
              const Center(
                  child: Padding(
                padding: EdgeInsets.all(24),
                child: CircularProgressIndicator(),
              ))
            else if (state.products.isEmpty)
              EmptyState(
                icon: Icons.inventory_2_outlined,
                title: 'vendor.products.empty_title'.tr(),
                subtitle: 'vendor.products.empty_subtitle'.tr(),
              )
            else
              ...state.products.map(
                (product) => Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: ProductListTile(product: product),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class VendorOrdersTab extends StatelessWidget {
  const VendorOrdersTab({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<VendorOrdersCubit, VendorOrdersState>(
      listener: (context, state) {
        if (state.error != null && state.error!.isNotEmpty) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.error!)),
          );
        }
      },
      builder: (context, state) => RefreshIndicator(
        onRefresh: () => context.read<VendorOrdersCubit>().load(),
        child: ListView(
          padding: pagePadding,
          children: [
            SectionTitle(title: 'vendor.orders.title'.tr()),
            const SizedBox(height: 12),
            if (state.loading)
              const Center(
                  child: Padding(
                padding: EdgeInsets.all(24),
                child: CircularProgressIndicator(),
              ))
            else if (state.orders.isEmpty)
              EmptyState(
                icon: Icons.inbox_outlined,
                title: 'vendor.orders.empty_title'.tr(),
                subtitle: 'vendor.orders.empty_subtitle'.tr(),
              )
            else
              ...state.orders.map(
                (order) => Padding(
                  padding: const EdgeInsets.only(bottom: 10),
                  child: VendorOrderCard(order: order),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class VendorCategoriesTab extends StatelessWidget {
  const VendorCategoriesTab({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<VendorCatalogCubit, VendorCatalogState>(
      builder: (context, state) => ListView(
        padding: pagePadding,
        children: [
          SectionTitle(
            title: 'vendor.categories.title'.tr(),
            action: 'vendor.categories.add'.tr(),
            onAction: () {
              final catalogCubit = context.read<VendorCatalogCubit>();
              showDialog<void>(
                context: context,
                builder: (_) => BlocProvider.value(
                  value: catalogCubit,
                  child: const CategoryDialog(),
                ),
              );
            },
          ),
          const SizedBox(height: 12),
          if (state.loading)
            const Center(
                child: Padding(
              padding: EdgeInsets.all(24),
              child: CircularProgressIndicator(),
            ))
          else if (state.categories.isEmpty)
            EmptyState(
              icon: Icons.category_outlined,
              title: 'vendor.categories.empty_title'.tr(),
              subtitle: 'vendor.categories.empty_subtitle'.tr(),
            )
          else
            Wrap(
              spacing: 10,
              runSpacing: 10,
              children: state.categories
                  .map((category) => CategoryChip(category: category))
                  .toList(growable: false),
            ),
        ],
      ),
    );
  }
}

class ProductListTile extends StatelessWidget {
  const ProductListTile({required this.product, super.key});

  final VendorProduct product;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        final catalogCubit = context.read<VendorCatalogCubit>();
        showModalBottomSheet<void>(
          context: context,
          isScrollControlled: true,
          builder: (_) => BlocProvider.value(
            value: catalogCubit,
            child: ProductEditorSheet(product: product),
          ),
        );
      },
      borderRadius: BorderRadius.circular(18),
      child: Ink(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.paper,
          border: Border.all(color: AppColors.line),
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(18),
            topRight: Radius.circular(18),
            bottomLeft: Radius.circular(18),
            bottomRight: Radius.circular(6),
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                color: AppColors.mist,
                borderRadius: BorderRadius.circular(14),
              ),
              child: const Icon(Icons.fastfood_outlined, color: AppColors.nile),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(product.name,
                      style: const TextStyle(fontWeight: FontWeight.w800)),
                  const SizedBox(height: 4),
                  Text(
                    product.categoryName ??
                        'vendor.products.uncategorized'.tr(),
                    style: const TextStyle(color: Colors.black54, fontSize: 12),
                  ),
                  if ((product.description ?? '').isNotEmpty) ...[
                    const SizedBox(height: 4),
                    Text(
                      product.description!,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style:
                          const TextStyle(color: Colors.black54, fontSize: 12),
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Price(value: product.price.round()),
                const SizedBox(height: 8),
                Switch(
                  value: product.isAvailable,
                  onChanged: (_) =>
                      context.read<VendorCatalogCubit>().saveProduct(
                            productId: product.id,
                            name: product.name,
                            description: product.description ?? '',
                            price: product.price,
                            isAvailable: !product.isAvailable,
                            imageUrl: product.imageUrl,
                            categoryId: product.categoryId,
                          ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class VendorOrderCard extends StatelessWidget {
  const VendorOrderCard({required this.order, super.key});

  final VendorOrder order;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => Navigator.of(context).push(
        MaterialPageRoute(
            builder: (_) => VendorOrderDetailScreen(orderId: order.id)),
      ),
      borderRadius: BorderRadius.circular(18),
      child: Ink(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.paper,
          border: Border.all(color: AppColors.line),
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(18),
            topRight: Radius.circular(18),
            bottomLeft: Radius.circular(18),
            bottomRight: Radius.circular(6),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    '#${order.id}',
                    style: const TextStyle(
                        fontWeight: FontWeight.w800, fontSize: 16),
                  ),
                ),
                StatusBadge(label: order.status),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              order.customerName ?? 'vendor.orders.customer'.tr(),
              style: const TextStyle(color: Colors.black54),
            ),
            const SizedBox(height: 8),
            Text(
              order.items
                  .map((item) => '${item.productName} x${item.quantity}')
                  .join(' • '),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(color: Colors.black54),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Price(value: order.totalAmount.round()),
                Text(
                  order.paymentStatus,
                  style: const TextStyle(fontWeight: FontWeight.w700),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
