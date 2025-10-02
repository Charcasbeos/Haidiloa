// ───── Event ─────
abstract class UserEvent {}

class LoadUserEvent extends UserEvent {}

class UpdateTableIdUserEvent extends UserEvent {
  final int tableId;
  UpdateTableIdUserEvent(this.tableId);
}

class RefreshUserEvent extends UserEvent {}

class ClearUserEvent extends UserEvent {}
