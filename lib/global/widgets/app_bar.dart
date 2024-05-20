import 'dart:math';

import 'package:ecampusguard/features/notifications/notifications.dart';
import 'package:ecampusguard/features/notifications/view/notifications_list_dialog.dart';
import 'package:ecampusguard/global/theme/cubit/theme_cubit.dart';
import 'package:ecampusguard/global/widgets/custom_menu_shape.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

AppBar appBar({
  bool automaticallyImplyLeading = true,
  Widget? leading,
}) =>
    AppBar(
      title: const Text("eCampusGuard"),
      automaticallyImplyLeading: automaticallyImplyLeading,
      centerTitle: true,
      leading: leading,
      actions: [
        BlocBuilder<NotificationsCubit, NotificationsState>(
          builder: (context, state) {
            var cubit = context.read<NotificationsCubit>();
            return PopupMenuButton(
              constraints: const BoxConstraints(
                minWidth: 5 * 56.0,
                maxWidth: 8 * 56.0,
              ),
              onSelected: (index) {
                if (index < min(cubit.notifications.length, 5)) {
                  cubit.readNotification(index);
                  showDialog(
                    useRootNavigator: false,
                    context: context,
                    builder: (context) => NotificationDetailsDialog(
                      notification: cubit.notifications[index],
                    ),
                  );
                } else {
                  showDialog(
                    useRootNavigator: false,
                    context: context,
                    builder: (context) => NotificationsListDialog(
                      notifications: cubit.notifications,
                      onNotificationRead: (index) {
                        cubit.readNotification(index);
                      },
                    ),
                  );
                }
              },
              shape: const TooltipShape(),
              position: PopupMenuPosition.under,
              offset: const Offset(0, 56.0 / 3),
              icon: Stack(
                clipBehavior: Clip.none,
                children: [
                  const Icon(Icons.notifications),
                  Positioned(
                    top: -2.5,
                    left: -2.5,
                    child: Visibility(
                      visible: (cubit.unreadNotifications ?? 0) > 0,
                      child: Badge(
                        label: Text(
                          cubit.unreadNotifications.toString(),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              enabled: state is NotificationsLoaded,
              itemBuilder: (context) {
                if (cubit.notifications.isNotEmpty) {
                  return List.generate(
                    state is! NotificationsLoading
                        ? min(cubit.notifications.length, 5) + 1
                        : 0,
                    (index) => PopupMenuItem(
                      value: index,
                      child: index < min(cubit.notifications.length, 5)
                          ? ListTile(
                              visualDensity: VisualDensity.comfortable,
                              isThreeLine: true,
                              leading: SizedBox(
                                height: double.infinity,
                                child: Icon(
                                  cubit.notifications[index].read!
                                      ? Icons.check_circle
                                      : Icons.circle,
                                  color: cubit.notifications[index].read!
                                      ? null
                                      : Theme.of(context).colorScheme.primary,
                                  size: 22,
                                ),
                              ),
                              minLeadingWidth: 25,
                              title: Text(cubit.notifications[index].title!),
                              subtitle: Text(cubit.notifications[index].body!),
                              trailing: Text(DateFormat("dd/MM/y\nh:m a")
                                  .format(
                                      cubit.notifications[index].timestamp!)),
                            )
                          : const ListTile(
                              title: Text("See all notifictions"),
                            ),
                    ),
                  );
                } else {
                  return [
                    const PopupMenuItem(
                      enabled: false,
                      child: Text("No notifications"),
                    ),
                  ];
                }
              },
            );
          },
        ),
        BlocBuilder<ThemeCubit, ThemeState>(
          builder: (context, state) {
            var cubit = context.read<ThemeCubit>();
            return IconButton(
              onPressed: () {
                cubit.toggleTheme();
              },
              icon: Icon(cubit.darkMode ? Icons.light_mode : Icons.dark_mode),
            );
          },
        ),
      ],
    );
