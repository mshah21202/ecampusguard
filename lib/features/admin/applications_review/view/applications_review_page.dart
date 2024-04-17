import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../applications_review.dart';
import 'applications_review_view.dart';

class ApplicationsReviewPage extends StatelessWidget {
  const ApplicationsReviewPage({
    Key? key,
    required this.applicationId,
  }) : super(key: key);

  final int applicationId;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          ApplicationsReviewCubit(applicationId: applicationId),
      child: const ApplicationsReviewView(),
    );
  }
}
