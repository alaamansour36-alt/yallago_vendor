import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../cubit/vendor_catalog_cubit.dart';

class CategoryDialog extends StatefulWidget {
  const CategoryDialog({super.key});

  @override
  State<CategoryDialog> createState() => _CategoryDialogState();
}

class _CategoryDialogState extends State<CategoryDialog> {
  final _nameController = TextEditingController();
  final _imageController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _imageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('vendor.category_dialog.title'.tr()),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _nameController,
            decoration:
                InputDecoration(labelText: 'vendor.category_dialog.name'.tr()),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _imageController,
            decoration: InputDecoration(
              labelText: 'vendor.category_dialog.image_url'.tr(),
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text('common.cancel'.tr()),
        ),
        FilledButton(
          onPressed: () async {
            await context.read<VendorCatalogCubit>().createCategory(
                  name: _nameController.text.trim(),
                  imageUrl: _imageController.text.trim().isEmpty
                      ? null
                      : _imageController.text.trim(),
                );
            if (context.mounted) {
              Navigator.of(context).pop();
            }
          },
          child: Text('common.save'.tr()),
        ),
      ],
    );
  }
}
