// ignore: depend_on_referenced_packages
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:pdpa/app/shared/drawers/models/drawer_menu_models.dart';

part 'drawer_event.dart';
part 'drawer_state.dart';

class DrawerBloc extends Bloc<DrawerEvent, DrawerState> {
  DrawerBloc() : super(const DrawerInitial()) {
    on<SelectMenuDrawerEvent>(_selectingMenuHandler);
  }

  void _selectingMenuHandler(
    SelectMenuDrawerEvent event,
    Emitter<DrawerState> emit,
  ) {
    emit(SelectedMenuDrawer(event.menu));
  }
}
