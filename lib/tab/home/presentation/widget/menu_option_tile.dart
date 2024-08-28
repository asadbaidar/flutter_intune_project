import 'package:common/common.dart';
import 'package:flutter/material.dart';

class MenuOptionTile extends StatelessWidget {
  const MenuOptionTile({
    super.key,
    required this.title,
    required this.icon,
    this.onTap,
  });

  final String title;
  final Widget icon;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return CustomInkWell(
      onTap: onTap,
      padding: const EdgeInsets.all(16),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: CustomListTile(
          leading: Padding(
            padding: const EdgeInsetsDirectional.only(end: 4),
            child: IconTheme(
              data: context.localIconTheme.copyWith(color: context.primary),
              child: icon,
            ),
          ),
          title: title,
          titleStyle: context.body1,
        ),
      ),
    );
  }
}
