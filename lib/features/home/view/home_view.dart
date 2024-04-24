import 'package:ecampusguard/features/home/view/widgets/permit_application_status.dart';
import 'package:ecampusguard/features/home/view/widgets/permit_status.dart';
import 'package:ecampusguard/features/home/view/widgets/previous_permits.dart';
import 'package:ecampusguard/global/widgets/background_logo.dart';
import 'package:ecampusguard/global/widgets/app_bar.dart';
import 'package:ecampusguard/global/widgets/drawer.dart';
import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import '../home.dart';

class HomeView extends StatelessWidget {
  const HomeView({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

    return Scaffold(
      key: scaffoldKey,
      appBar: appBar,
      drawer: AppDrawer(),
      body: Stack(
        children: [


          BlocBuilder<HomeCubit, HomeState>(
            builder: (context, state) {
              return Column(
                children: [
                  const SizedBox(height: 20,),
                  if (state.applicationStatus != null)
                    PermitApplicationStatusWidget(
                      status: state.applicationStatus!,
                    ),
                  if (state.applicationStatus == null &&
                      state.permitStatus != null)
                    PermitStatusWidget(status: state.permitStatus!),
                  const PreviousPermits(permits: [])
                ],
              );
            },
          ),

          const BackgroundLogo()
        ],


      ),

    );

  }
}


















