import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../permits.dart';

class PermitDetailsView extends StatelessWidget {
  const PermitDetailsView({
    Key? key,
    this.permitId,
  }) : super(key: key);

  final int? permitId;

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<PermitsCubit>();
    return Container(
      child: null,
    );
  }
}
