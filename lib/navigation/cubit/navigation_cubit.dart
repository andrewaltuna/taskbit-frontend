import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

part 'navigation_state.dart';

class NavigationCubit extends Cubit<NavigationState> {
  NavigationCubit() : super(const NavigationState());

  void navChanged(int index) {
    emit(state.copyWith(navIndex: index, selectedPage: () => null));
  }

  void pageChanged(Pages page) {
    emit(state.copyWith(selectedPage: () => page));
  }

  void pageDeselected() {
    emit(state.copyWith(selectedPage: () => Pages.home));
  }

  void resetState() {
    emit(const NavigationState());
  }
}
