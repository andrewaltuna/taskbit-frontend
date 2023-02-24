import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'navigation_state.dart';

class NavigationCubit extends Cubit<NavigationState> {
  NavigationCubit() : super(const NavigationState());

  bool pageIsAuth() {
    return state.selectedPage == Pages.login ||
        state.selectedPage == Pages.signUp;
  }

  int getPageNavIndex(Pages page) {
    if (page == Pages.profile) {
      return 1;
    }
    return 0;
  }

  void pageChanged(Pages page) {
    emit(state.copyWith(selectedPage: page));
  }
}
