import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/widgets/shared_widgets.dart';
import '../../data/models/vendor_models.dart';
import '../cubit/vendor_catalog_cubit.dart';

class ProductEditorSheet extends StatefulWidget {
  const ProductEditorSheet({this.product, super.key});

  final VendorProduct? product;

  @override
  State<ProductEditorSheet> createState() => _ProductEditorSheetState();
}

class _ProductEditorSheetState extends State<ProductEditorSheet> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _descriptionController;
  late final TextEditingController _priceController;
  late final TextEditingController _imageController;
  String? _categoryId;
  bool _isAvailable = true;

  @override
  void initState() {
    super.initState();
    final product = widget.product;
    _nameController = TextEditingController(text: product?.name ?? '');
    _descriptionController =
        TextEditingController(text: product?.description ?? '');
    _priceController = TextEditingController(
      text: product == null ? '' : product.price.toStringAsFixed(0),
    );
    _imageController = TextEditingController(text: product?.imageUrl ?? '');
    _categoryId = product?.categoryId;
    _isAvailable = product?.isAvailable ?? true;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    _imageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;
    return Padding(
      padding: EdgeInsets.fromLTRB(20, 20, 20, bottomInset + 20),
      child: BlocBuilder<VendorCatalogCubit, VendorCatalogState>(
        builder: (context, state) => SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.product == null
                      ? 'vendor.product_editor.add_title'.tr()
                      : 'vendor.product_editor.edit_title'.tr(),
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.w800),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _nameController,
                  decoration: InputDecoration(
                      labelText: 'vendor.product_editor.name'.tr()),
                  validator: (value) => (value == null || value.isEmpty)
                      ? 'vendor.product_editor.name_required'.tr()
                      : null,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _descriptionController,
                  decoration: InputDecoration(
                    labelText: 'vendor.product_editor.description'.tr(),
                  ),
                  maxLines: 3,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _priceController,
                  decoration: InputDecoration(
                      labelText: 'vendor.product_editor.price'.tr()),
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                  validator: (value) => (double.tryParse(value ?? '') == null)
                      ? 'vendor.product_editor.price_required'.tr()
                      : null,
                ),
                const SizedBox(height: 12),
                DropdownButtonFormField<String?>(
                  value: _categoryId,
                  items: [
                    DropdownMenuItem<String?>(
                      value: null,
                      child: Text('vendor.product_editor.no_category'.tr()),
                    ),
                    ...state.categories.map(
                      (category) => DropdownMenuItem<String?>(
                        value: category.id,
                        child: Text(category.name),
                      ),
                    ),
                  ],
                  onChanged: (value) => setState(() => _categoryId = value),
                  decoration: InputDecoration(
                    labelText: 'vendor.product_editor.category'.tr(),
                  ),
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _imageController,
                  decoration: InputDecoration(
                    labelText: 'vendor.product_editor.image_url'.tr(),
                  ),
                ),
                const SizedBox(height: 12),
                SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  value: _isAvailable,
                  onChanged: (value) => setState(() => _isAvailable = value),
                  title: Text('vendor.product_editor.available'.tr()),
                ),
                const SizedBox(height: 16),
                PrimaryButton(
                  label: state.saving
                      ? 'vendor.product_editor.saving'.tr()
                      : 'vendor.product_editor.save'.tr(),
                  icon: Icons.save_outlined,
                  onTap: state.saving
                      ? () {}
                      : () async {
                          if (!_formKey.currentState!.validate()) {
                            return;
                          }
                          await context.read<VendorCatalogCubit>().saveProduct(
                                productId: widget.product?.id,
                                name: _nameController.text.trim(),
                                description: _descriptionController.text.trim(),
                                price:
                                    double.parse(_priceController.text.trim()),
                                isAvailable: _isAvailable,
                                imageUrl: _imageController.text.trim().isEmpty
                                    ? null
                                    : _imageController.text.trim(),
                                categoryId: _categoryId,
                              );
                          if (context.mounted) {
                            Navigator.of(context).pop();
                          }
                        },
                ),
                if (widget.product != null) ...[
                  const SizedBox(height: 10),
                  PrimaryButton(
                    label: 'vendor.product_editor.delete'.tr(),
                    icon: Icons.delete_outline,
                    critical: true,
                    onTap: () async {
                      await context
                          .read<VendorCatalogCubit>()
                          .deleteProduct(widget.product!.id);
                      if (context.mounted) {
                        Navigator.of(context).pop();
                      }
                    },
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
