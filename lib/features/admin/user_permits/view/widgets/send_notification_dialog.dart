import 'package:ecampusguard/global/extensions/list_extension.dart';
import 'package:ecampusguard/global/widgets/responsive.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SendNotificationDialog extends StatefulWidget {
  const SendNotificationDialog({
    super.key,
    required this.onSave,
  });

  final void Function(String title, String body) onSave;

  @override
  State<SendNotificationDialog> createState() => _SendNotificationDialogState();
}

class _SendNotificationDialogState extends State<SendNotificationDialog> {
  final GlobalKey<FormFieldState> formKey = GlobalKey<FormFieldState>();
  final TextEditingController titleController = TextEditingController();
  final TextEditingController bodyController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return Dialog(
      child: SizedBox(
        width: MediaQuery.of(context).size.width *
            (!ResponsiveWidget.isSmallScreen(context) ? 0.35 : 0.9),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: IntrinsicHeight(
            child: Column(
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Send Notification",
                      style: theme.textTheme.headlineSmall!.copyWith(
                        color: theme.colorScheme.onBackground,
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        context.pop();
                      },
                      icon: const Icon(Icons.close),
                    ),
                  ],
                ),
                Form(
                  key: formKey,
                  child: Column(
                    children: <Widget>[
                      TextFormField(
                        controller: titleController,
                        decoration: const InputDecoration(labelText: "Title"),
                        validator: (value) {
                          if (value == null || value == "") {
                            return "This field is required";
                          }

                          return null;
                        },
                      ),
                      TextFormField(
                        controller: bodyController,
                        maxLines: 5,
                        decoration: const InputDecoration(
                          labelText: "Body",
                          alignLabelWithHint: true,
                        ),
                        validator: (value) {
                          if (value == null || value == "") {
                            return "This field is required";
                          }

                          return null;
                        },
                      )
                    ].addElementBetweenElements(
                      SizedBox(
                        height: ResponsiveWidget.smallPadding(context),
                      ),
                    ),
                  ),
                ),
                Row(
                  children: <Widget>[
                    FilledButton.icon(
                      onPressed: () {
                        widget.onSave(
                            titleController.text, bodyController.text);
                        context.pop();
                      },
                      icon: const Icon(Icons.check),
                      label: const Text("Send"),
                    ),
                    OutlinedButton.icon(
                      onPressed: () {
                        context.pop();
                      },
                      icon: const Icon(Icons.close),
                      label: const Text("Cancel"),
                    ),
                  ].addElementBetweenElements(
                    SizedBox(
                      width: ResponsiveWidget.smallPadding(context),
                    ),
                  ),
                )
              ].addElementBetweenElements(
                SizedBox(
                  height: ResponsiveWidget.smallPadding(context),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
