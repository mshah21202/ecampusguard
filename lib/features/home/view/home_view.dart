import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../home.dart';

class HomeView extends StatelessWidget {
  const HomeView({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<HomeCubit>();
    return Scaffold(
      backgroundColor: const Color(0xFFFBF8FF),
      appBar: AppBar(
        title: const Center(
          child: Text(
            "TEST",
            style: TextStyle(color: Colors.white),
          ),
        ),
        backgroundColor: const Color(0xFF565992),
      ),
      body: Stack(
        children: [
          Positioned(
            left: -150,
            bottom: -150,
            child: Opacity(
              opacity: 0.2,
              child: Image.asset('assets/images/ecampusLogo.png'),
            ),
          ),




      /*    BlocBuilder<HomeCubit, HomeState>(
            builder: (context, state) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Icon(
                      _getIconData(state.applicationStatus),
                      size: 48,
                    ),
                    SizedBox(height: 8),

                    Text(
                      _getTextBasedOnStatus(state.applicationStatus),
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.black87,
                      ),
                    ),
                    SizedBox(height: 24),

                    ElevatedButton(
                      onPressed: cubit.fetchApplicationStatus,
                      child: const Text('Check Application Status'),
                    ),
                  ],
                ),
              );
            },
          ),*/
        ],
      ),
    );
  }
}

IconData _getIconData(PermitApplicationStatus status) {
  switch (status) {
    case PermitApplicationStatus.valid:
      return Icons.check_circle_outline;
    case PermitApplicationStatus.pending:
      return Icons.hourglass_empty;
    case PermitApplicationStatus.awaitingPayment:
      return Icons.payment;
    default:
      return Icons.help_outline;
  }
}

String _getTextBasedOnStatus(PermitApplicationStatus status) {
  switch (status) {
    case PermitApplicationStatus.valid:
      return 'Application is Valid';
    case PermitApplicationStatus.pending:
      return 'Application Pending';
    case PermitApplicationStatus.awaitingPayment:
      return 'Awaiting Payment';
    default:
      return 'Status Unknown';
  }
}
