import 'package:ecampusguard/features/admin/home_admin/cubit/home_admin_cubit.dart';
import 'package:ecampusguard/features/admin/home_admin/view/widgets/applications_summary.dart';
import 'package:ecampusguard/features/admin/home_admin/view/widgets/areas_summary.dart';
import 'package:ecampusguard/global/extensions/list_extension.dart';
import 'package:ecampusguard/global/widgets/app_bar.dart';
import 'package:ecampusguard/global/widgets/admin_drawer.dart';
import 'package:ecampusguard/global/widgets/background_logo.dart';
import 'package:ecampusguard/global/widgets/full_screen_loading.dart';
import 'package:ecampusguard/global/widgets/responsive.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// import 'package:flutter_bloc/flutter_bloc.dart';

// import '../home_admin.dart';

class HomeAdminView extends StatefulWidget {
  const HomeAdminView({
    Key? key,
  }) : super(key: key);

  @override
  State<HomeAdminView> createState() => _HomeAdminViewState();
}

class _HomeAdminViewState extends State<HomeAdminView> {
  @override
  void initState() {
    super.initState();
    final cubit = context.read<HomeAdminCubit>();
    cubit.loadData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(),
      drawer: const AdminAppDrawer(),
      body: BlocBuilder<HomeAdminCubit, HomeAdminState>(
        builder: (context, state) {
          return Stack(
            fit: StackFit.expand,
            children: [
              const BackgroundLogo(),
              SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.symmetric(
                    horizontal: ResponsiveWidget.largePadding(context),
                    vertical: ResponsiveWidget.smallPadding(context),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      const ApplicationsSummary(),
                      const AreasSummary(),
                    ].addElementBetweenElements(
                      SizedBox(
                        height: ResponsiveWidget.largePadding(context),
                      ),
                    ),
                  ),
                ),
              ),
              FullScreenLoadingIndicator(visible: state is HomeAdminLoading)
            ],
          );
        },
      ),
    );
  }
}
