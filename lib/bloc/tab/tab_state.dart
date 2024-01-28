import 'package:equatable/equatable.dart';

class TabState extends Equatable {
  final int selectedTabIndex;

  TabState(this.selectedTabIndex);

  @override
  List<Object> get props => [selectedTabIndex];
}
