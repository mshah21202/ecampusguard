import 'package:ecampusguard/features/admin/update_request/view/widgets/update_request_chip.dart';
import 'package:ecampusguard/global/widgets/full_screen_loading.dart';
import 'package:ecampusguardapi/ecampusguardapi.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
    // cubit.loadUpdateRequests(widget.requestId);
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<UpdateRequestCubit>();
    var theme = Theme.of(context);

    return Scaffold(
        //     drawer: const AdminAppDrawer(),
        //     appBar: appBar(),
        //     body: BlocBuilder<UpdateRequestCubit, UpdateRequestState>(
        //       builder: (context, state) {
        //         return Stack(
        //           children: [
        //             const BackgroundLogo(),
        //             if (cubit.updateRequest != null)
        //               SingleChildScrollView(
        //                 child: Padding(
        //                   padding: EdgeInsets.symmetric(
        //                     vertical: ResponsiveWidget.mediumPadding(context),
        //                     horizontal: ResponsiveWidget.xLargeWidthPadding(context) / 2,
        //                   ),
        //                   child: Form(
        //                     key: cubit.formKey,
        //                     child: Column(
        //                       crossAxisAlignment: CrossAxisAlignment.start,
        //                       children: <Widget>[
        //                         Column(
        //                           crossAxisAlignment: CrossAxisAlignment.start,
        //                           children: <Widget>[
        //                             Text(
        //                               "${cubit.updateRequest!.userPermit?.user ?? 'Unknown'}'s Update Request",
        //                               style: theme.textTheme.headlineLarge?.copyWith(
        //                                   color: theme.colorScheme.onBackground),
        //                             ),
        //                             if (cubit.updateRequest != null)
        //                               UpdateRequestStatusChip(
        //                                   status: cubit.updateRequest!.status!),
        //                           ].addElementBetweenElements(
        //                             const SizedBox(
        //                               height: 12,
        //                             ),
        //                           ),
        //                         ),
        //                         Wrap(
        //                           spacing: 12,
        //                           runSpacing: 12,
        //                           children: [
        //                             if (cubit.updateRequest!.status == UpdateRequestStatus.Pending)
        //                               FilledButton.icon(
        //                                 onPressed: () {
        //                                   cubit.acceptRequest(widget.requestId).then((value) {
        //                                     context.pop();
        //                                   });
        //                                 },
        //                                 icon: const Icon(Icons.check),
        //                                 label: const Text("Accept"),
        //                               ),
        //                             if (cubit.updateRequest!.status == UpdateRequestStatus.Accepted)
        //                               FilledButton.icon(
        //                                 onPressed: () {
        //                                   cubit.rejectRequest(widget.requestId).then((value) {
        //                                     context.pop();
        //                                   });
        //                                 },
        //                                 icon: const Icon(Icons.close),
        //                                 label: const Text("Reject"),
        //                               ),
        //                           ],
        //                         ),
        //                         Text('Phone Number: ${cubit.updateRequest!.phoneNumber} (${cubit.updateRequest!.phoneNumberCountry})'),
        //                         Text('Vehicle: ${cubit.updateRequest!.updatedVehicle?.make ?? 'N/A'} ${cubit.updateRequest!.updatedVehicle?.model ?? ''}'),
        //                         // Additional details here
        //                       ].addElementBetweenElements(
        //                         const SizedBox(
        //                           height: 24,
        //                         ),
        //                       ),
        //                     ),
        //                   ),
        //                 ),
        //               ),
        //             FullScreenLoadingIndicator(
        //               visible: state is UpdateRequestLoading ||
        //                   cubit.updateRequest == null,
        //             )
        //           ],
        //         );
        //       },
        //     ),
        );
  }
}
