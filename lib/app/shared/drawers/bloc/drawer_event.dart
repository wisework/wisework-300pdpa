part of 'drawer_bloc.dart';

abstract class DrawerEvent extends Equatable {
  const DrawerEvent();

  @override
  List<Object> get props => [];
}

class SelectMenuDrawerEvent extends DrawerEvent {
  const SelectMenuDrawerEvent({required this.menu});

  final DrawerMenuModel menu;

  @override
  List<Object> get props => [menu];
}
