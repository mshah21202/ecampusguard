import 'package:ecampusguard/features/home/home.dart';
import 'package:ecampusguard/global/extensions/list_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AccessLogsList extends StatelessWidget {
  const AccessLogsList({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeState>(
      builder: (context, state) {
        var cubit = context.read<HomeCubit>();
        return ListView.builder(
          shrinkWrap: true,
          itemCount: cubit.userPermit != null
              ? !cubit.userPermit!.accessLogs.isEmptyOrNull
                  ? 4
                  : 0
              : 0,
          itemBuilder: (BuildContext context, int index) {
            return ListTile(
              title: Text(
                cubit.userPermit!.accessLogs![index].licensePlate!,
              ),
            );
          },
        );
      },
    );
  }
}
