import 'package:ecampusguard/features/admin/update_request/view/widgets/update_request_chip.dart';
import 'package:ecampusguard/global/extensions/list_extension.dart';
import 'package:ecampusguard/global/widgets/full_screen_loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../global/widgets/admin_drawer.dart';
import '../../../../global/widgets/responsive.dart';
import '../cubit/update_request_cubit.dart';
import 'package:ecampusguard/global/widgets/background_logo.dart';
import 'package:ecampusguard/global/widgets/app_bar.dart';
import '../../../admin/update_request/view/widgets/update_request_information.dart';

class UpdateRequestDetailsView extends StatefulWidget {
  final int requestId;

  const UpdateRequestDetailsView({Key? key, required this.requestId})
      : super(key: key);

  @override
  State<UpdateRequestDetailsView> createState() =>
      _UpdateRequestDetailsViewState();
}

class _UpdateRequestDetailsViewState extends State<UpdateRequestDetailsView> {
  @override
  void initState() {
    super.initState();
    final cubit = context.read<UpdateRequestCubit>();
    cubit.requestId = widget.requestId;
    cubit.loadRequestDetails();
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<UpdateRequestCubit>();
    var theme = Theme.of(context);

    return Scaffold(
      drawer: const AdminAppDrawer(),
      appBar: appBar(),
      body: BlocBuilder<UpdateRequestCubit, UpdateRequestState>(
        builder: (context, state) {
          return Stack(
            fit: StackFit.expand,
            children: [
              const BackgroundLogo(),
              if (cubit.updaterequest != null)
                SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      vertical: ResponsiveWidget.mediumPadding(context),
                      horizontal:
                          ResponsiveWidget.xLargeWidthPadding(context) / 2,
                    ),
                    child: Form(
                      key: cubit.formKey,
                      child: Container(
                        decoration: BoxDecoration(
                          color: theme.colorScheme.background,
                          borderRadius: BorderRadius.circular(25.0),
                          border: Border.all(
                            color: theme.colorScheme.outlineVariant,
                          ),
                        ),
                        padding: EdgeInsets.all(
                          ResponsiveWidget.smallPadding(context) + 12,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: <Widget>[
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                SelectableText(
                                  "${cubit.updaterequest!.userPermit!.user!.name!}'s Update Request",
                                  style: theme.textTheme.headlineLarge?.copyWith(
                                      color: theme.colorScheme.onBackground),
                                ),
                                Row(
                                  children: [
                                    SelectableText(
                                      "Status: ",
                                      style: theme.textTheme.bodyMedium?.copyWith(
                                        fontSize: 20,
                                      ),
                                    ),
                                    UpdateRequestStatusChip(
                                        status: cubit.updaterequest!.status!),
                                  ],
                                ),
                              ].addElementBetweenElements(
                                const SizedBox(
                                  height: 12,
                                ),
                              ),
                            ),
                            buildInfoBox(
                          
                              content:
                                  '${cubit.updaterequest?.phoneNumber} (${cubit.updaterequest?.phoneNumberCountry})',
                            context:context,
                            ),
                            buildVehicleInfoBox(
                              vehicle: cubit.updaterequest!.updatedVehicle,
                              context:context,
                            ),
                            Wrap(
                              spacing: 12,
                              runSpacing: 12,
                              children: [
                                FilledButton.icon(
                                  onPressed: () {
                                    // cubit.acceptRequest(requestId);
                                    context.pop();
                                  },
                                  icon: const Icon(Icons.check),
                                  label: const Text("Accept"),
                                ),
                                FilledButton.tonalIcon(
                                  onPressed: () {
                                    // cubit.rejectRequest(requestId);
                                    context.pop();
                                  },
                                  icon: const Icon(Icons.close),
                                  label: const Text("Reject"),
                                ),
                              ],
                            ),
                          ].addElementBetweenElements(
                            const SizedBox(
                              height: 24,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              FullScreenLoadingIndicator(
                visible: state is UpdateRequestLoading,
              ),
            ],
          );
        },
      ),
    );
  }


}
