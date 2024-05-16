import 'package:ecampusguard/features/admin/update_request/view/widgets/update_request_chip.dart';
import 'package:ecampusguard/global/extensions/list_extension.dart';
import 'package:ecampusguard/global/widgets/full_screen_loading.dart';
import 'package:ecampusguardapi/ecampusguardapi.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../../global/widgets/admin_drawer.dart';
import '../../../../global/widgets/responsive.dart';
import '../cubit/update_request_cubit.dart';
import 'package:ecampusguard/global/widgets/background_logo.dart';
import 'package:ecampusguard/global/widgets/app_bar.dart';

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
            children: [
              const BackgroundLogo(),
              if (state is UpdateRequestLoaded)
                SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      vertical: ResponsiveWidget.mediumPadding(context),
                      horizontal:
                          ResponsiveWidget.xLargeWidthPadding(context) / 2,
                    ),
                    child: Form(
                      key: cubit.formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                "${cubit.UpdateRequest?.userPermit?.user ?? 'Unknown'}'s Update Request",
                                style: theme.textTheme.headlineLarge?.copyWith(
                                    color: theme.colorScheme.onBackground),
                              ),
                              UpdateRequestStatusChip(
                                  status: cubit.UpdateRequest!.status!),
                            ].addElementBetweenElements(
                              const SizedBox(
                                height: 12,
                              ),
                            ),
                          ),
                          Wrap(
                            spacing: 12,
                            runSpacing: 12,
                            children: [
                              if (cubit.UpdateRequest?.status == UpdateRequestStatus.Pending)
                                FilledButton.icon(
                                  onPressed: () {
                                    // cubit.acceptRequest(true)
                                    //     .then((value) {
                                     
                                    // });
                                     context.pop();
                                  },
                                  icon: const Icon(Icons.check),
                                  label: const Text("Accept"),
                                ),
                              if (cubit.UpdateRequest?.status ==
                                  UpdateRequestStatus.Accepted)
                                FilledButton.icon(
                                  onPressed: () {
                                    // cubit.rejectRequest(requestId).then((value) {
                                      
                                    // });
                                    context.pop();
                                  },
                                  icon: const Icon(Icons.close),
                                  label: const Text("Reject"),
                                ),
                            ],
                          ),
                          Text(
                              'Phone Number: ${cubit.UpdateRequest?.phoneNumber} (${cubit.UpdateRequest?.phoneNumberCountry})'),
                          Text(
                              'Vehicle: ${cubit.UpdateRequest?.updatedVehicle?.make ?? 'N/A'} ${cubit.UpdateRequest?.updatedVehicle?.model ?? ''}'),
                          // Additional details here
                        ].addElementBetweenElements(
                          const SizedBox(
                            height: 24,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              FullScreenLoadingIndicator(
                visible: state is UpdateRequestLoading ||
                    cubit.UpdateRequest == null,
              )
            ],
          );
        },
      ),
    );
  }
}
