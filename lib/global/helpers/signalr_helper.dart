import 'package:signalr_netcore/signalr_client.dart';

class SignalRHelper {
  SignalRHelper({
    this.clientMethods,
    required this.fullPath,
    required this.bearerToken,
    this.onClose,
    this.onReconnecting,
    this.onReconnected,
  }) {
    _init();
  }

  late HubConnection hubConnection;
  final String fullPath;
  final String bearerToken;
  final Map<String, void Function(List<Object?>? args)>? clientMethods;
  final void Function({Exception? error})? onClose;
  final void Function({Exception? error})? onReconnecting;
  final void Function({String? connectionId})? onReconnected;
  bool connected = false;

  void _init() {
    hubConnection = HubConnectionBuilder().withUrl(
      fullPath,
      options: HttpConnectionOptions(
        accessTokenFactory: () async {
          return bearerToken;
        },
      ),
    ).withAutomaticReconnect(
        retryDelays: [0, 250, 500, 1000, 2000, 10000]).build();
  }

  Future<void> connect() async {
    await hubConnection.start();
    if (hubConnection.state == HubConnectionState.Connected) {
      connected = true;
      _addListeners();
    }
  }

  void _addListeners() {
    if (clientMethods == null) {
      return;
    }

    clientMethods!.forEach((methodName, method) {
      hubConnection.on(methodName, method);
    });

    hubConnection.onclose(({error}) {
      print("Connection Closed: $error");
      connected = false;
      if (onClose != null) {
        onClose!(error: error);
      }
    });

    hubConnection.onreconnecting(
      ({error}) {
        print("Connection Reconnecting: $error");

        connected = false;
        if (onReconnecting != null) {
          onReconnecting!(error: error);
        }
      },
    );

    hubConnection.onreconnected(
      ({connectionId}) {
        print("Connection Reconnected: $connected");
        connected = true;
        if (onReconnected != null) {
          onReconnected!(connectionId: connectionId);
        }
      },
    );
  }
}
