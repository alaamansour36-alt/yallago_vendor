import 'package:easy_localization/easy_localization.dart' hide TextDirection;
import 'package:flutter/material.dart';

import '../constants/app_colors.dart';
import '../../features/shared/app_scope.dart';

class DetailScaffold extends StatelessWidget {
  const DetailScaffold({required this.title, required this.child, super.key});
  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: Text(title), actions: [const LanguageButton()]),
        body: SafeArea(child: child),
      );
}

class PrimaryButton extends StatelessWidget {
  const PrimaryButton({
    required this.label,
    required this.icon,
    required this.onTap,
    this.critical = false,
    super.key,
  });

  final String label;
  final IconData icon;
  final VoidCallback onTap;
  final bool critical;

  @override
  Widget build(BuildContext context) => SizedBox(
        width: double.infinity,
        height: 54,
        child: FilledButton.icon(
          onPressed: onTap,
          icon: Icon(icon),
          label: Text(label),
          style: FilledButton.styleFrom(
            backgroundColor: critical ? AppColors.hibiscus : AppColors.nile,
            foregroundColor: Colors.white,
            textStyle:
                const TextStyle(fontWeight: FontWeight.w800, fontSize: 15),
          ),
        ),
      );
}

class QuantityControl extends StatelessWidget {
  const QuantityControl({
    required this.value,
    required this.onChanged,
    this.compact = false,
    super.key,
  });

  final int value;
  final ValueChanged<int> onChanged;
  final bool compact;

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.all(3),
        decoration: BoxDecoration(
          color: AppColors.mist,
          borderRadius: BorderRadius.circular(11),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          textDirection: TextDirection.ltr,
          children: [
            IconButton(
              onPressed: () => onChanged(value > 1 ? value - 1 : 1),
              icon: const Icon(Icons.remove),
              iconSize: compact ? 15 : 19,
              visualDensity: VisualDensity.compact,
            ),
            SizedBox(
              width: compact ? 16 : 22,
              child: Text(
                '$value',
                textAlign: TextAlign.center,
                style: const TextStyle(fontWeight: FontWeight.w800),
              ),
            ),
            IconButton(
              onPressed: () => onChanged(value + 1),
              icon: const Icon(Icons.add),
              iconSize: compact ? 15 : 19,
              visualDensity: VisualDensity.compact,
            ),
          ],
        ),
      );
}

class Price extends StatelessWidget {
  const Price({required this.value, this.size = 13, super.key});
  final int value;
  final double size;

  @override
  Widget build(BuildContext context) => Text(
        'EGP $value',
        textDirection: TextDirection.ltr,
        style: TextStyle(
          color: AppColors.nileDark,
          fontSize: size,
          fontWeight: FontWeight.w800,
        ),
      );
}

class PaymentSummary extends StatelessWidget {
  const PaymentSummary({this.simple = false, this.total = 241, super.key});
  final bool simple;
  final int total;

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.all(15),
        decoration: BoxDecoration(
          color: AppColors.paper,
          border: Border.all(color: AppColors.line),
          borderRadius: BorderRadius.circular(17),
        ),
        child: Column(
          children: [
            if (!simple) ...[
              const _OrderLine(label: 'Subtotal', amount: 238),
              const _OrderLine(label: 'Delivery fee', amount: 18),
              const _OrderLine(label: 'YallaGo discount', amount: -15),
            ],
            _OrderLine(
              label: 'common.total'.tr(),
              amount: total,
              total: true,
            ),
          ],
        ),
      );
}

class _OrderLine extends StatelessWidget {
  const _OrderLine(
      {required this.label, required this.amount, this.total = false});
  final String label;
  final int amount;
  final bool total;

  @override
  Widget build(BuildContext context) => Container(
        margin: total ? const EdgeInsets.only(top: 8) : EdgeInsets.zero,
        padding: const EdgeInsets.symmetric(vertical: 7),
        decoration: total
            ? const BoxDecoration(
                border: Border(top: BorderSide(color: AppColors.line)),
              )
            : null,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: TextStyle(
                color: total ? AppColors.ink : Colors.black54,
                fontWeight: total ? FontWeight.w800 : FontWeight.w500,
              ),
            ),
            Text(
              'EGP $amount',
              textDirection: TextDirection.ltr,
              style: const TextStyle(fontWeight: FontWeight.w800),
            ),
          ],
        ),
      );
}

class InfoCard extends StatelessWidget {
  const InfoCard({
    required this.icon,
    required this.title,
    required this.body,
    this.selected = false,
    super.key,
  });

  final IconData icon;
  final String title;
  final String body;
  final bool selected;

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: selected ? AppColors.mist : AppColors.paper,
          border: Border.all(
            color: selected ? AppColors.nile : AppColors.line,
          ),
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(18),
            topRight: Radius.circular(18),
            bottomLeft: Radius.circular(18),
            bottomRight: Radius.circular(5),
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: selected ? AppColors.nile : AppColors.hibiscus),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title,
                      style: const TextStyle(fontWeight: FontWeight.w800)),
                  const SizedBox(height: 4),
                  Text(
                    body,
                    style: const TextStyle(
                      color: Colors.black54,
                      fontSize: 12,
                      height: 1.45,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
}

class CartDock extends StatelessWidget {
  const CartDock({required this.onTap, super.key});
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => Material(
        elevation: 9,
        borderRadius: BorderRadius.circular(17),
        color: AppColors.hibiscus,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(17),
          child: Container(
            width: 350,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 11),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'common.items_in_cart'.tr(
                        namedArgs: {
                          'count': '${YallaScope.of(context).cartCount}',
                        },
                      ),
                      style: const TextStyle(color: Colors.white, fontSize: 12),
                    ),
                    const Text(
                      'EGP 241.00',
                      textDirection: TextDirection.ltr,
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
                Text(
                  'common.view_cart'.tr(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
          ),
        ),
      );
}

class SectionTitle extends StatelessWidget {
  const SectionTitle(
      {required this.title, this.action, this.onAction, super.key});
  final String title;
  final String? action;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) => Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 18),
          ),
          if (action != null)
            TextButton(
              onPressed: onAction,
              child: Text(
                action!,
                style: const TextStyle(fontWeight: FontWeight.w800),
              ),
            ),
        ],
      );
}

class TicketLabel extends StatelessWidget {
  const TicketLabel({required this.label, this.light = false, super.key});
  final String label;
  final bool light;

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 4),
        decoration: BoxDecoration(
          color: light ? Colors.white24 : AppColors.mist,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(7),
            bottomLeft: Radius.circular(7),
            bottomRight: Radius.circular(2),
            topRight: Radius.circular(7),
          ),
          border: BorderDirectional(
            start: BorderSide(
              color: light ? Colors.white : AppColors.nile,
              width: 3,
            ),
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: light ? Colors.white : AppColors.nileDark,
            fontSize: 9,
            fontWeight: FontWeight.w800,
          ),
        ),
      );
}

class FilterChipWidget extends StatelessWidget {
  const FilterChipWidget({required this.label, this.active = false, super.key});
  final String label;
  final bool active;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsetsDirectional.only(end: 8),
        child: ChoiceChip(
          label: Text(label),
          selected: active,
          selectedColor: AppColors.mist,
          shape: StadiumBorder(
            side: BorderSide(color: active ? AppColors.nile : AppColors.line),
          ),
          onSelected: (_) {},
        ),
      );
}

class RouteRibbon extends StatelessWidget {
  const RouteRibbon({super.key});

  @override
  Widget build(BuildContext context) => Row(
        children: [
          const Expanded(
            child: Divider(
              color: AppColors.nile,
              thickness: 1.5,
              indent: 2,
              endIndent: 6,
            ),
          ),
          Container(
            width: 10,
            height: 10,
            decoration: const BoxDecoration(
              color: AppColors.hibiscus,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(color: AppColors.hibiscus, blurRadius: 8),
              ],
            ),
          ),
          const Expanded(
            child: Divider(
              color: AppColors.nile,
              thickness: 1.5,
              indent: 6,
              endIndent: 2,
            ),
          ),
        ],
      );
}

class LanguageButton extends StatelessWidget {
  const LanguageButton({super.key});

  @override
  Widget build(BuildContext context) => TextButton(
        onPressed: () {
          final nextLocale = context.locale.languageCode == 'ar'
              ? const Locale('en')
              : const Locale('ar');
          context.setLocale(nextLocale);
        },
        child: Text(context.locale.languageCode == 'ar' ? 'EN' : 'ع'),
      );
}

class RouteArc extends StatelessWidget {
  const RouteArc({required this.size, required this.color, super.key});
  final double size;
  final Color color;

  @override
  Widget build(BuildContext context) => Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(size),
          border: Border.all(color: color, width: 1.5),
        ),
      );
}
