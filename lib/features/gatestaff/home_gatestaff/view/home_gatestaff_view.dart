import 'package:ecampusguard/features/gatestaff/home_gatestaff/view/widgets/area_summary.dart';
import 'package:ecampusguard/global/extensions/list_extension.dart';
import 'package:ecampusguard/global/widgets/app_bar.dart';
import 'package:ecampusguard/global/widgets/background_logo.dart';
import 'package:ecampusguard/global/widgets/full_screen_loading.dart';
import 'package:ecampusguard/global/widgets/gatestaff_drawer.dart';
import 'package:ecampusguard/global/widgets/responsive.dart';
import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../home_gatestaff.dart';

class HomeGatestaffView extends StatefulWidget {
  const HomeGatestaffView({
    Key? key,
  }) : super(key: key);

  @override
  State<HomeGatestaffView> createState() => _HomeGatestaffViewState();
}

class _HomeGatestaffViewState extends State<HomeGatestaffView> {
  @override
  void initState() {
    super.initState();
    final cubit = context.read<HomeGatestaffCubit>();
    cubit.getAreaScreens();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeGatestaffCubit, HomeGatestaffState>(
        builder: (context, state) {
      final cubit = context.read<HomeGatestaffCubit>();
      var theme = Theme.of(context);
      return Scaffold(
        appBar: appBar(automaticallyImplyLeading: true),
        drawer: const GateStaffDrawer(),
        body: Stack(
          fit: StackFit.expand,
          children: [
            const BackgroundLogo(),
            SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: ResponsiveWidget.largePadding(context),
                  vertical: ResponsiveWidget.mediumPadding(context),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      "Areas Summary",
                      style: theme.textTheme.headlineMedium!.copyWith(
                        color: theme.colorScheme.onBackground,
                      ),
                    ),
                    if (cubit.areaScreens.isNotEmpty)
                      Wrap(
                        spacing: ResponsiveWidget.smallPadding(context),
                        runSpacing: ResponsiveWidget.smallPadding(context),
                        children: List.generate(
                          cubit.areaScreens.length,
                          (index) => AreaScreenSummary(
                            areaScreen: cubit.areaScreens[index],
                          ),
                        ),
                      ),
                  ].addElementBetweenElements(
                    const SizedBox(
                      height: 24,
                    ),
                  ),
                ),
              ),
            ),
            FullScreenLoadingIndicator(visible: state is HomeGatestaffLoading),
          ],
        ),
      );
    });
  }
}
