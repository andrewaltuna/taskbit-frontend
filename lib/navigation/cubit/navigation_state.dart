part of 'navigation_cubit.dart';

enum Pages { login, signUp, home, taskCreate, taskUpdate, taskDelete, profile }

class NavigationState extends Equatable {
  const NavigationState({
    this.navIndex = 0,
    this.selectedPage = Pages.login,
  });

  final int navIndex;
  final Pages? selectedPage;

  NavigationState copyWith({
    int? navIndex,
    ValueGetter<Pages?>? selectedPage,
  }) {
    return NavigationState(
      navIndex: navIndex ?? this.navIndex,
      selectedPage: selectedPage != null ? selectedPage() : this.selectedPage,
    );
  }

  @override
  List<Object?> get props => [navIndex, selectedPage];

  // GETTERS

  bool pageIsAuth() {
    return selectedPage == Pages.login || selectedPage == Pages.signUp;
  }
}
