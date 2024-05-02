import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../user_permit_details.dart';
import 'user_permit_details_view.dart';

class UserPermitDetailsPage extends StatelessWidget {
  const UserPermitDetailsPage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => UserPermitDetailsCubit(),
      child: const UserPermitDetailsView(),
    );
  }
}
