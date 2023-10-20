part of 'drawer_bloc.dart';

abstract class DrawerState extends Equatable {
  const DrawerState();

  @override
  List<Object> get props => [];
}

class DrawerInitial extends DrawerState {
  const DrawerInitial();

  @override
  List<Object> get props => [];
}

class DrawerError extends DrawerState {
  const DrawerError(this.message);

  final String message;

  @override
  List<Object> get props => [message];
}

class SelectedMenuDrawer extends DrawerState {
  const SelectedMenuDrawer(this.menu);

  final DrawerMenuModel menu;

  @override
  List<Object> get props => [menu];
}
