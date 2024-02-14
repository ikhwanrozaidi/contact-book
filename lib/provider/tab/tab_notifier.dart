import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'tab_state.dart';

final tabNotifierProvider =
    NotifierProvider.autoDispose<TabNotifier, TabState>(TabNotifier.new);

class TabNotifier extends StateNotifier<TabState> {
  TabNotifier() : super(TabState(0));

  void updateTab(int tabIndex) {
    state = TabState(tabIndex);
  }
}
