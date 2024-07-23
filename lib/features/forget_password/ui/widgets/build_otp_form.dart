import 'package:a2z_app/features/forget_password/ui/widgets/build_form_otp_faild_item.dart';
import 'package:flutter/material.dart';

class BuildOtpForm extends StatelessWidget {
  const BuildOtpForm({super.key});

  @override
  Widget build(BuildContext context) {
    return  const Form(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          BuildFormOtpItem(),
          BuildFormOtpItem(),
          BuildFormOtpItem(),
          BuildFormOtpItem(),
          BuildFormOtpItem(),
          BuildFormOtpItem(),
        ],
      ),
    );
  }
}
