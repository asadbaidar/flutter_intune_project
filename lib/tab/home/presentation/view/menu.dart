import 'package:common/common.dart';
import 'package:core/tab/home/home.dart';
import 'package:flutter/material.dart';
import 'package:locale/locale.dart';

class HomeMenu extends StatelessWidget {
  const HomeMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomIconButton(
      tooltip: LocaleStrings.menu,
      icon: const Icon(Icons.more_vert),
      onPressed: () => _showMenu(context),
    );
  }

  void _showMenu(BuildContext context) => showModalBottomSheet<void>(
        context: context,
        scrollControlDisabledMaxHeightRatio: 0.3,
        builder: (context) {
          return CustomBottomSheet(
            stretch: false,
            content: CustomListView.fixed(
              physics: const NeverScrollableScrollPhysics(),
              divider: const Divider(indent: 16, endIndent: 16),
              children: [
                MenuOptionTile(
                  title: context.locale == LocaleConstants.esES
                      ? 'English'
                      : 'Español',
                  icon: const Icon(Icons.language),
                  onTap: () {
                    final upComingLocale =
                        context.locale == LocaleConstants.esES
                            ? LocaleConstants.enUS
                            : LocaleConstants.esES;
                    context.setLocale(
                      upComingLocale,
                    );
                  },
                ),
                MenuOptionTile(
                  title: LocaleStrings.logOut,
                  icon: const AssetIcon(AssetIcons.exit),
                  onTap: () {},
                ),
              ],
            ),
          );
        },
      );
}
