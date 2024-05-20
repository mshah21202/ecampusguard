import 'package:ecampusguard/features/notifications/view/notification_details_dialog.dart';
import 'package:ecampusguard/global/extensions/list_extension.dart';
import 'package:ecampusguard/global/widgets/responsive.dart';
import 'package:ecampusguardapi/ecampusguardapi.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

class NotificationsListDialog extends StatelessWidget {
  const NotificationsListDialog({
    super.key,
    required this.notifications,
    required this.onNotificationRead,
  });

  final List<NotificationDto> notifications;
  final void Function(int index) onNotificationRead;

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return Dialog(
      child: SizedBox(
        width: MediaQuery.of(context).size.width *
            (ResponsiveWidget.isLargeScreen(context) ? 0.4 : 0.8),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Notifications",
                    style: theme.textTheme.headlineSmall!.copyWith(
                      color: theme.colorScheme.onBackground,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    color: theme.colorScheme.onBackground,
                    onPressed: () {
                      context.pop();
                    },
                  ),
                ],
              ),
              ListView.builder(
                shrinkWrap: true,
                itemCount: notifications.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    visualDensity: VisualDensity.comfortable,
                    onTap: () {
                      context.pop();
                      onNotificationRead(index);
                      showDialog(
                        useRootNavigator: false,
                        context: context,
                        builder: (context) => NotificationDetailsDialog(
                          notification: notifications[index],
                        ),
                      );
                    },
                    isThreeLine: true,
                    leading: SizedBox(
                      height: double.infinity,
                      child: Icon(
                        notifications[index].read!
                            ? Icons.check_circle
                            : Icons.circle,
                        color: notifications[index].read!
                            ? null
                            : Theme.of(context).colorScheme.primary,
                        size: 22,
                      ),
                    ),
                    minLeadingWidth: 25,
                    title: Text(notifications[index].title!),
                    subtitle: Text(notifications[index].body!),
                    trailing: Text(DateFormat("dd/MM/y\nh:m a")
                        .format(notifications[index].timestamp!)),
                  );
                },
              )
            ].addElementBetweenElements(
              SizedBox(
                height: ResponsiveWidget.smallPadding(context),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
