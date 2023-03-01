import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

part 'avatar_select_state.dart';

class AvatarSelectCubit extends Cubit<AvatarSelectState> {
  AvatarSelectCubit() : super(AvatarSelectState());

  void avatarSelected(int index) {
    emit(state.copyWith(selectedAvatarIndex: () => index));
  }

  void toggleProfileAvatarSelectVisibility() {
    emit(state.copyWith(
        isProfileAvatarSelectVisible: !state.isProfileAvatarSelectVisible));
  }

  void resetState() {
    emit(AvatarSelectState());
  }
}
