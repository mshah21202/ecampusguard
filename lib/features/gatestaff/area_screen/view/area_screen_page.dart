import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../area_screen.dart';
import 'area_screen_view.dart';

class AreaScreenPage extends StatelessWidget {
  const AreaScreenPage({
    Key? key,
    required this.areaId,
  }) : super(key: key);

  final int areaId;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AreaScreenCubit(areaId: areaId),
      child: const AreaScreenView(),
    );
  }
}
