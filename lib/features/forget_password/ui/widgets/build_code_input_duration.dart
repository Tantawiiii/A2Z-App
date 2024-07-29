import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BuildInputFormDuration extends StatelessWidget {
  const BuildInputFormDuration({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 52.h,
      width: 48.w,
      child: TextFormField(
        onChanged: (value){
          if (value.length == 1) {
            FocusScope.of(context).nextFocus();
          }
        },
        style: Theme.of(context).textTheme.titleLarge,
        keyboardType: TextInputType.number,
        textAlign: TextAlign.center,
        inputFormatters: [
          LengthLimitingTextInputFormatter(1),
          FilteringTextInputFormatter.digitsOnly,
        ],
        decoration: InputDecoration(
          border: OutlineInputBorder(
            borderSide:
            const BorderSide(color: Colors.blue),
            borderRadius: BorderRadius.circular(10.0),
          ),
          hintText: "0",
          hintStyle: TextStyle(
              fontSize: 20.sp
          ),
        ),
      ),
    );
  }
}
