abstract class TabEvent {}

class TabUpdated extends TabEvent {
  final int tabIndex;

  TabUpdated(this.tabIndex);
}
