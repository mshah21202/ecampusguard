import 'package:bloc/bloc.dart';
import 'package:ecampusguardapi/ecampusguardapi.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import 'package:get_it/get_it.dart';

part 'notifications_state.dart';

class NotificationsCubit extends Cubit<NotificationsState> {
  NotificationsCubit() : super(NotificationsInitial()) {
    loadNotifications();
  }

  final Ecampusguardapi _api = GetIt.I.get<Ecampusguardapi>();
  List<NotificationDto> notifications = [];
  int? unreadNotifications;

  void loadNotifications() async {
    emit(NotificationsLoading());
    try {
      var result = await _api.getHomeScreenApi().homeScreenNotificationsGet();

      if (result.data == null) {
        emit(NotificationsError());
        return;
      }

      notifications = result.data!;
      unreadNotifications = notifications
          .where(
            (notification) => !notification.read!,
          )
          .length;
      emit(NotificationsLoaded(notifications: notifications));
    } catch (e) {
      emit(NotificationsError());
    }
  }

  void readNotification(int index) async {
    try {
      await _api
          .getHomeScreenApi()
          .homeScreenNotificationsIdPost(id: notifications[index].id!);
      loadNotifications();
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

  void clear() {
    notifications = [];
    unreadNotifications = null;
    emit(NotificationsInitial());
  }
}
