part of 'navigation_cubit.dart';

enum Pages { login, signUp, home, taskCreate, taskDetail, profile }

class NavigationState extends Equatable {
  const NavigationState({
    this.selectedPage = Pages.login,
  });

  final Pages selectedPage;

  NavigationState copyWith({
    Pages? selectedPage,
  }) {
    return NavigationState(
      selectedPage: selectedPage ?? this.selectedPage,
    );
  }

  @override
  List<Object?> get props => [selectedPage];
}
