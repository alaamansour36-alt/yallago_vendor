import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:yallago/features/catalog/data/models/vendor_models.dart';
import 'package:yallago/features/catalog/presentation/widgets/vendor_shared_widgets.dart';

import '../../../../core/constants/app_colors.dart';
import '../../../../core/widgets/shared_widgets.dart';
import '../cubit/vendor_orders_cubit.dart';

class VendorOrderDetailScreen extends StatefulWidget {
  const VendorOrderDetailScreen({required this.orderId, super.key});

  final String orderId;

  @override
  State<VendorOrderDetailScreen> createState() =>
      _VendorOrderDetailScreenState();
}

class _VendorOrderDetailScreenState extends State<VendorOrderDetailScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<VendorOrdersCubit>().selectOrder(widget.orderId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return DetailScaffold(
      title: 'vendor.order_detail.title'.tr(),
      child: BlocBuilder<VendorOrdersCubit, VendorOrdersState>(
        builder: (context, state) {
          final order = state.selectedOrder;
          if (state.updating && order == null) {
            return const Center(child: CircularProgressIndicator());
          }
          if (order == null) {
            return Center(child: Text('vendor.order_detail.unavailable'.tr()));
          }
          return ListView(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
            children: [
              Container(
                padding: const EdgeInsets.all(18),
                decoration: const BoxDecoration(
                  gradient:
                      LinearGradient(colors: [AppColors.ink, AppColors.nile]),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(22),
                    topRight: Radius.circular(22),
                    bottomLeft: Radius.circular(22),
                    bottomRight: Radius.circular(6),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('#${order.id}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.w800,
                        )),
                    const SizedBox(height: 8),
                    Text(
                      order.deliveryAddress ??
                          'vendor.order_detail.no_delivery_address'.tr(),
                      style: const TextStyle(color: Colors.white70),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              SectionTitle(title: 'vendor.order_detail.items'.tr()),
              const SizedBox(height: 8),
              ...order.items.map(
                (item) => OrderLine(
                  label: '${item.productName} x${item.quantity}',
                  amount: (item.unitPrice * item.quantity).round(),
                ),
              ),
              const SizedBox(height: 16),
              PaymentSummary(simple: true, total: order.totalAmount.round()),
              const SizedBox(height: 16),
              InfoCard(
                icon: Icons.notes_outlined,
                title: 'vendor.order_detail.delivery_instructions'.tr(),
                body: order.deliveryInstructions ??
                    'vendor.order_detail.no_instructions'.tr(),
              ),
              const SizedBox(height: 16),
              OrderActions(order: order),
            ],
          );
        },
      ),
    );
  }
}

class OrderActions extends StatelessWidget {
  const OrderActions({required this.order, super.key});

  final VendorOrder order;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('vendor.order_detail.update_status'.tr(),
            style: const TextStyle(fontWeight: FontWeight.w800)),
        const SizedBox(height: 10),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            for (final status in const [
              'Pending',
              'Preparing',
              'Ready',
              'Cancelled'
            ])
              ChoiceChip(
                label: Text(status),
                selected: order.status == status,
                onSelected: (_) =>
                    context.read<VendorOrdersCubit>().updateStatus(
                          orderId: order.id,
                          status: status,
                        ),
              ),
          ],
        ),
        const SizedBox(height: 16),
        Text('vendor.order_detail.payment_status'.tr(),
            style: const TextStyle(fontWeight: FontWeight.w800)),
        const SizedBox(height: 10),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            for (final status in const ['Pending', 'Paid'])
              ChoiceChip(
                label: Text(status),
                selected: order.paymentStatus == status,
                onSelected: (_) =>
                    context.read<VendorOrdersCubit>().updatePaymentStatus(
                          orderId: order.id,
                          paymentStatus: status,
                        ),
              ),
          ],
        ),
      ],
    );
  }
}
