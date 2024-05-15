import 'package:ecampusguard/features/admin/update_request/view/widgets/update_request_chip.dart';
import 'package:ecampusguard/global/widgets/full_screen_loading.dart';
import 'package:ecampusguardapi/ecampusguardapi.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../global/widgets/admin_drawer.dart';
import '../../../../global/widgets/responsive.dart';
import '../cubit/update_request_cubit.dart'; 

class UpdateRequestDetailsView extends StatefulWidget {
  final int requestId;

  const UpdateRequestDetailsView({Key? key, required this.requestId}) : super(key: key);

  @override
  _UpdateRequestDetailsViewState createState() => _UpdateRequestDetailsViewState();
}

class _UpdateRequestDetailsViewState extends State<UpdateRequestDetailsView> {
  late final UpdateRequestCubit _cubit;

  @override
  void initState() {
    super.initState();
    _cubit = context.read<UpdateRequestCubit>();
    _cubit.loadRequestDetails(widget.requestId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const AdminAppDrawer(),
      body: BlocBuilder<UpdateRequestCubit, UpdateRequestState>(
        builder: (context, state) {
          if (state is UpdateRequestLoading) {
            return const FullScreenLoadingIndicator();
          } else if (state is UpdateRequestLoaded) {
            return _buildRequestDetails(context, state.requests as UpdateRequestDto);
          } else if (state is UpdateRequestError) {
            return Center(child: Text(state.errorMessage));
          }
          return const Placeholder();
        },
      ),
    );
  }

  Widget _buildRequestDetails(BuildContext context, UpdateRequestDto request) {
    var theme = Theme.of(context);
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.symmetric(
          vertical: ResponsiveWidget.mediumPadding(context),
          horizontal: ResponsiveWidget.xLargeWidthPadding(context) / 2,
        ),
        child: Form(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                "${request.userPermit?.user ?? 'Unknown'}'s Update Request",
                style: theme.textTheme.headlineLarge?.copyWith(
                  color: theme.colorScheme.onBackground),
              ),
              if (request.status != null)
                UpdateRequestStatusChip(status: request.status!),
              const SizedBox(height: 24),
              Text('Phone Number: ${request.phoneNumber} (${request.phoneNumberCountry})'),
              Text('Vehicle: ${request.updatedVehicle?.make ?? 'N/A'} ${request.updatedVehicle?.model ?? ''}'),
              // Additional details here
              const SizedBox(height: 24),
              _buildActionButtons(request.status),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActionButtons(UpdateRequestStatus? status) {
    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: <Widget>[
        if (status == UpdateRequestStatus.Accepted)
          ElevatedButton.icon(
            onPressed: () => _cubit.acceptRequest(widget.requestId),
            icon: const Icon(Icons.check),
            label: const Text("Accept"),
          ),
        if (status == UpdateRequestStatus.)
          ElevatedButton.icon(
            onPressed: () => _cubit.rejectRequest(widget.requestId),
            icon: const Icon(Icons.close),
            label: const Text("Reject"),
          ),
      ],
    );
  }
}
