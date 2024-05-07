import 'package:ecampusguard/global/extensions/list_extension.dart';
import 'package:flutter/material.dart';

class LiveFeedStatusChip extends StatelessWidget {
  const LiveFeedStatusChip({
    super.key,
    required this.connected,
    required bool connecting,
    required this.onRefresh,
  }) : _connecting = connecting;

  final bool connected;
  final bool _connecting;
  final void Function() onRefresh;

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return Container(
      decoration: BoxDecoration(
        color: theme.colorScheme.background,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: theme.colorScheme.outline),
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(8),
        child: InkWell(
          onTap: connected || _connecting ? null : onRefresh,
          child: Padding(
            padding: const EdgeInsets.only(
              left: 8,
              top: 8,
              bottom: 8,
              right: 12,
            ),
            child: Row(
              children: <Widget>[
                SizedBox(
                  height: 16,
                  width: 16,
                  child: connected
                      ? Badge.count(
                          backgroundColor: theme.colorScheme.error,
                          textColor: theme.colorScheme.error,
                          count: 0,
                        )
                      : _connecting
                          ? const CircularProgressIndicator()
                          : const Icon(
                              Icons.refresh,
                              size: 16,
                            ),
                ),
                Text(
                  connected
                      ? "Live"
                      : _connecting
                          ? "Connecting..."
                          : "Reconnect",
                ),
              ].addElementBetweenElements(
                const SizedBox(
                  width: 12,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
