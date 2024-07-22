import 'package:a2z_app/core/helpers/extentions.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../core/helpers/spacing.dart';
import '../../../../core/routing/routers.dart';
import '../../../../core/theming/text_style.dart';
import '../../../../core/utils/StringsTexts.dart';
import '../../../../core/widgets/build_button.dart';
import '../../../../core/widgets/build_text_form_field.dart';
import '../../bloc/password_reset_bloc.dart';
import '../../bloc/password_reset_event.dart';
import '../../bloc/password_reset_state.dart';
import '../../services/password_reset_service.dart';

class ForgetPassword extends StatefulWidget {
  const ForgetPassword({super.key});

  @override
  State<ForgetPassword> createState() => _ForgetPasswordState();
}

class _ForgetPasswordState extends State<ForgetPassword> {

  final TextEditingController phoneNumberController = TextEditingController();

  @override
  void dispose() {
    // TODO: implement dispose
    phoneNumberController.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => PasswordResetBloc(PasswordResetService()),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.h, vertical: 30.h),
            child: ListView(
              children: [
                Text(
                  StringsTexts.txtForgetPasswordTitle,
                  style: TextStyles.font24BlueBold,
                ),
                verticalSpace(8),
                Text(
                  StringsTexts.txtForgetPasswordDes,
                  style: TextStyles.font13GrayNormal,
                ),
                verticalSpace(42),
                BuildTextFormField(
                  controller: phoneNumberController,
                  hintText: StringsTexts.txtHintValidPhoneNum,
                  validator: (value) {},
                ),
                verticalSpace(160),
                BlocConsumer<PasswordResetBloc, PasswordResetState>(
                  listener: (context, state) {
                    if (state is PasswordResetFailure) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(state.error)),
                      );
                    } else if (state is PasswordResetSuccess) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('OTP has been sent to your email or login.')),
                      );
                      context.pushNamed(Routes.verifyOtpScreen);
                    }
                  },
                  builder: (context, state) {
                    if (state is PasswordResetLoading) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    return BuildButton(
                      textButton: StringsTexts.txtPasswordReset,
                      textStyle: TextStyles.font16WhiteMedium,
                      onPressed: () {
                        BlocProvider.of<PasswordResetBloc>(context).add(
                          PasswordResetRequested(phoneNumberController.text),
                        );
                      },
                    );
                  },
                )


              ],
            ),
          ),
        ),
      ),
    );
  }
}
