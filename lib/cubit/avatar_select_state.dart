part of 'avatar_select_cubit.dart';

class AvatarSelectState extends Equatable {
  AvatarSelectState({
    this.selectedAvatarIndex,
    this.isProfileAvatarSelectVisible = false,
  });

  final int? selectedAvatarIndex;
  final bool isProfileAvatarSelectVisible;

  final List<String> avatars = [
    'knight',
    'wizard',
    'barbarian',
  ];

  AvatarSelectState copyWith({
    ValueGetter<int?>? selectedAvatarIndex,
    bool? isProfileAvatarSelectVisible,
  }) {
    return AvatarSelectState(
      selectedAvatarIndex: selectedAvatarIndex != null
          ? selectedAvatarIndex()
          : this.selectedAvatarIndex,
      isProfileAvatarSelectVisible:
          isProfileAvatarSelectVisible ?? this.isProfileAvatarSelectVisible,
    );
  }

  @override
  List<Object?> get props => [
        selectedAvatarIndex,
        isProfileAvatarSelectVisible,
      ];

  String? get selectedAvatar =>
      selectedAvatarIndex == null ? null : avatars[selectedAvatarIndex!];

  String avatarFromIndex(int index) {
    return avatars[index];
  }
}
