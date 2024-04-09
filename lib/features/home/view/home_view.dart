import 'package:ecampusguard/global/widgets/BackgroundLogo.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import '../home.dart';

class HomeView extends StatelessWidget {
  const HomeView({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cubit = context.read<HomeCubit>();
    final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: theme.colorScheme.background,
      appBar: AppBar(
        title: const Center(
          child: Text(
            "eCampusGuard",
            style: TextStyle(color: Colors.white),
          ),
        ),
        backgroundColor: theme.colorScheme.primary,
        leading: IconButton(
          icon: const Icon(Icons.menu),
          color: theme.colorScheme.onPrimary,
          onPressed: () {
            scaffoldKey.currentState?.openDrawer();
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications),
            color: theme.colorScheme.onPrimary,
            onPressed: () {
              // do smth
            },
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: theme.colorScheme.primary,
              ),
              child: Text(
                'eCampusGuard',
                style: TextStyle(
                  color: theme.colorScheme.onPrimary,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.home),
              title: const Text('Home'),
              onTap: () {
                // Update the state of the app
                // ...
                // Then close the drawer
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.badge),
              title: const Text('Permit'),
              onTap: () {
                // Update the state of the app
                // ...
                // Then close the drawer
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.apps),
              title: const Text('Applications'),
              onTap: () {
                // Update the state of the app
                // ...
                // Then close the drawer
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text('My Profile'),
              onTap: () {
                // Update the state of the app
                // ...
                // Then close the drawer
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
      body: Stack(
        children: [
          BlocBuilder<HomeCubit, HomeState>(
            builder: (context, state) {
              if (state is HomeInitial) {
                return _buildInitialApplicationView(context, cubit, []);
              } else if (state is ApplicationStatusState) {
                switch (state.applicationStatus) {
                  case PermitApplicationStatus.pending:
                    return _buildPendingView(context, cubit);
                  case PermitApplicationStatus.awaitingPayment:
                    return _buildAwaitingPaymentView(context, cubit);
                  // case PermitApplicationStatus.Valid:
                  //   return _buildValidPermitView(context, cubit);
                  default:
                    return _buildUnknownStatusView(context);
                }
              }
              return const Center(child: Text('ERROR!!.'));
            },
          ),
          const BackgroundLogo()
        ],
      ),
    );
  }
}

Widget _buildInitialApplicationView(
    BuildContext context, HomeCubit cubit, List<dynamic> permits) {
  final theme = Theme.of(context);
  return Scaffold(
    backgroundColor: theme.colorScheme.background,
    body: SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              decoration: BoxDecoration(
                color: theme.colorScheme.background,
                borderRadius: BorderRadius.circular(25.0),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.19),
                    blurRadius: 25.0,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    height: 100,
                    child: Expanded(
                      child: Text(
                        'Apply for a permit',
                        style: TextStyle(
                          fontSize: 24,
                          color: theme.colorScheme.onBackground,
                        ),
                      ),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      // do smth
                    },
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: theme.colorScheme.primary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18.0),
                      ),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 32.0, vertical: 8.0),
                      elevation: 0,
                    ),
                    child: const Text(
                      'Apply now',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'Previous Permits',
                style: TextStyle(
                  fontSize: 24,
                  color: theme.colorScheme.onSurfaceVariant,
                ),
              ),
            ),
            _buildPreviousPermitsList(context, permits),
          ],
        ),
      ),
    ),
  );
}

Widget _buildPreviousPermitsList(BuildContext context, List<dynamic> permits) {
  final theme = Theme.of(context);
  //Student has no previous permit
  if (permits.isEmpty) {
    return const Center(
      child: Text(
        "You have no previous permits.",
        style: TextStyle(
          fontSize: 18,
          color: Colors.black54,
        ),
      ),
    );
  }

  //Student has permits
  else {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.all(16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.15),
              blurRadius: 6,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: ListView.separated(
          itemCount: permits.length,
          separatorBuilder: (context, index) => const Divider(),
          itemBuilder: (context, index) {
            final permit = permits[index];
            return ListTile(
              title: Text(permit.name),
              subtitle: Text(
                  'Valid for ${permit.days} days - \$${permit.price.toStringAsFixed(2)}'),
              trailing: Text('Occupied: ${permit.occupied}/${permit.capacity}'),
            );
          },
        ),
      ),
    );
  }
}

Widget _buildPendingView(BuildContext context, HomeCubit cubit) {
  return Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(Icons.hourglass_empty, size: 48),
        const SizedBox(height: 8),
        const Text('Pending',
            style: TextStyle(fontSize: 18, color: Colors.black87)),
        const SizedBox(height: 24),
        ElevatedButton(
          onPressed: () {
            //do smth
          },
          child: const Text('Check Application'),
        ),
      ],
    ),
  );
}

Widget _buildAwaitingPaymentView(BuildContext context, HomeCubit cubit) {
  return Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(Icons.payment, size: 48),
        const SizedBox(height: 8),
        const Text('Awaiting Payment',
            style: TextStyle(fontSize: 18, color: Colors.black87)),
        const SizedBox(height: 24),
        ElevatedButton(
          onPressed: () {
            //do smth
          },
          child: const Text('Pay Now'),
        ),
      ],
    ),
  );
}

Widget _buildUnknownStatusView(BuildContext context) {
  return const Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.help_outline, size: 48),
        SizedBox(height: 8),
      ],
    ),
  );
}

//---------    !!!needs changes!!!
/*
  * 1- days
  * 2- Previous permit applications
  * 3- enter/ exit logs of the student
  * */
Widget _buildValidPermitView(BuildContext context, HomeCubit cubit) {
  return const Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.check, size: 48),
        SizedBox(height: 8),
        Text('Valid', style: TextStyle(fontSize: 18, color: Colors.black87)),
      ],
    ),
  );
}


















  // //icon functions
  // IconData? _getIconData(PermitApplicationStatus status) {
  //   switch (status) {
  //     case PermitApplicationStatus.Valid:
  //       return Icons.check_circle_outline;
  //     case PermitApplicationStatus.Pending:
  //       return Icons.hourglass_empty;
  //     case PermitApplicationStatus.AwaitingPayment:
  //       return Icons.payment;
  //     case PermitApplicationStatus.Expired:
  //       return Icons.alarm;
  //     default:
  //       return Icons.help_outline;
  //   }
  // }

  // String _getTextBasedOnStatus(PermitApplicationStatus status) {
  //   switch (status) {
  //     case PermitApplicationStatus.Valid:
  //       return 'Application is Valid';
  //     case PermitApplicationStatus.Pending:
  //       return 'Application Pending';
  //     case PermitApplicationStatus.AwaitingPayment:
  //       return 'Awaiting Payment';
  //     case PermitApplicationStatus.Expired:
  //       return 'Permit Expired';
  //     default:
  //       return '';
  //   }
  // }
