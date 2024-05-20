part of 'notifications_cubit.dart';

class NotificationsState extends Equatable {
  const NotificationsState({
    this.notifications,
  });

  final List<NotificationDto>? notifications;

  @override
  List<Object?> get props => [
        notifications,
      ];
}

class NotificationsInitial extends NotificationsState {}

class NotificationsLoading extends NotificationsState {}

class NotificationsLoaded extends NotificationsState {
  const NotificationsLoaded({super.notifications});
}

class NotificationsError extends NotificationsState {}
