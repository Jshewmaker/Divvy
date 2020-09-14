import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:divvy/tab_bar/blocs/tab/tab.dart';
import 'package:divvy/tab_bar/models/models.dart';

class TabBloc extends Bloc<TabEvent, AppTab> {
  TabBloc() : super(AppTab.home);

  @override
  Stream<AppTab> mapEventToState(TabEvent event) async* {
    if (event is TabUpdated) {
      yield event.tab;
    }
  }
}