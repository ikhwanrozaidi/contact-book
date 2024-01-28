import 'package:flutter_bloc/flutter_bloc.dart';
import 'tab_event.dart';
import 'tab_state.dart';

class TabBloc extends Bloc<TabEvent, TabState> {
  TabBloc() : super(TabState(0)) {
    on<TabUpdated>((event, emit) {
      emit(TabState(event.tabIndex));
    });
  }

  @override
  void onChange(Change<TabState> change) {
    print(change);
    super.onChange(change);
  }
}
