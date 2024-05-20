import 'package:ecampusguard/global/extensions/list_extension.dart';
import 'package:ecampusguard/global/widgets/responsive.dart';
import 'package:ecampusguardapi/ecampusguardapi.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';

class NotificationDetailsDialog extends StatelessWidget {
  const NotificationDetailsDialog({super.key, required this.notification});

  final NotificationDto notification;

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
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    notification.title!,
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
              Row(
                children: [
                  Flexible(
                    fit: FlexFit.tight,
                    child: Text(
                      notification.body!,
                      style: theme.textTheme.titleLarge!.copyWith(
                        color: theme.colorScheme.onBackground,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
              Text(
                DateFormat("dd/MM/y\nh:m a").format(notification.timestamp!),
                style: theme.textTheme.bodyLarge!.copyWith(
                  color: theme.colorScheme.onBackground.withOpacity(0.5),
                ),
              )
            ].addElementBetweenElements(
              SizedBox(
                height: ResponsiveWidget.mediumPadding(context),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
