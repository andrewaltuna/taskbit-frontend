import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:taskbit/auth/cubit/signup_cubit.dart';
import 'package:taskbit/widgets/sprite.dart';

class AvatarSelect extends StatelessWidget {
  const AvatarSelect({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SignupCubit, SignupState>(
      builder: (context, state) {
        final signupCubit = context.read<SignupCubit>();
        return Container(
          padding: const EdgeInsets.all(20.0),
          width: double.infinity,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10.0),
            image: const DecorationImage(
              fit: BoxFit.cover,
              image: AssetImage('assets/images/stats_background.png'),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Choose your Avatar',
                style: GoogleFonts.pressStart2p(color: Colors.white),
              ),
              const SizedBox(height: 10.0),
              SizedBox(
                height: 70,
                child: ListView.separated(
                  itemBuilder: ((context, index) {
                    return ClipRRect(
                      borderRadius: BorderRadius.circular(10.0),
                      child: Material(
                        color: index == signupCubit.state.selectedAvatarIndex
                            ? Colors.black.withOpacity(0.5)
                            : Colors.transparent,
                        child: InkWell(
                          onTap: () {
                            signupCubit.avatarSelected(index);
                          },
                          child: Sprite(
                            signupCubit.state.avatars[index],
                            height: 70,
                          ),
                        ),
                      ),
                    );
                  }),
                  separatorBuilder: ((context, index) =>
                      const SizedBox(width: 10.0)),
                  itemCount: 3,
                  shrinkWrap: true,
                  scrollDirection: Axis.horizontal,
                ),
              )
            ],
          ),
        );
      },
    );
  }
}
