import 'package:a2z_app/core/utils/StringsTexts.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

import '../../../../core/helpers/app_regex.dart';
import '../../../../core/helpers/spacing.dart';
import '../../../../core/widgets/build_text_form_field.dart';
import '../../../login/ui/widgets/build_password_validatons.dart';
import '../../helper/fetch_grades.dart';
import '../../../../core/networking/clients/get_grades_graphql_client.dart';

class SignupForm extends StatefulWidget {
  SignupForm(
      {super.key,
      required this.formKey,
      required this.firstNameController,
      required this.lastNameController,
      required this.phoneNumberController,
      required this.emailController,
      required this.usernameController,
      required this.passwordController,
      required this.gradeController});

  final GlobalKey<FormState> formKey;

  TextEditingController firstNameController = TextEditingController();
  TextEditingController lastNameController = TextEditingController();
  TextEditingController phoneNumberController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController gradeController = TextEditingController();

  @override
  State<SignupForm> createState() => _SignupFormState();
}

class _SignupFormState extends State<SignupForm> {
  bool isPasswordObscureText = true;

  bool hasLowercase = false;
  bool hasUppercase = false;
  bool hasSpecialCharacters = false;
  bool hasNumber = false;
  bool hasMinLength = false;

  List<String> _grades = [];
  List<DropdownMenuItem<String>> _dropdownItems = [];
  late GraphQLClient client;

  @override
  void initState() {
    super.initState();

    // Ensure the client is initialized
    GraphQLClientInstance.initializeClient();

    // Fetch grades and update the state
    fetchGrades(GraphQLClientInstance.client).then((fetchedCategories) {
      setState(() {
        _grades = fetchedCategories;
        _dropdownItems = _grades
            .map((String category) => DropdownMenuItem<String>(
                  value: category,
                  child: Text(category),
                ))
            .toList();
      });
    });
  }

  // void setupPasswordControllerListener() {
  //   widget.passwordController.addListener(() {
  //     setState(() {
  //       hasLowercase = AppRegex.hasLowerCase(widget.passwordController.text);
  //       hasUppercase = AppRegex.hasUpperCase(widget.passwordController.text);
  //       hasSpecialCharacters =
  //           AppRegex.hasSpecialCharacter(widget.passwordController.text);
  //       hasNumber = AppRegex.hasNumber(widget.passwordController.text);
  //       hasMinLength = AppRegex.hasMinLength(widget.passwordController.text);
  //     });
  //   });
  // }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: widget.formKey,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            mainAxisSize: MainAxisSize.max,
            children: [
              SizedBox(
                width: 150.w,
                child: BuildTextFormField(
                  inputType: TextInputType.text,
                  controller: widget.firstNameController,
                  hintText: StringTextsNames.txtFirstName,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return StringTextsNames.txtFirstNameValid;
                    }
                  },
                ),
              ),
              SizedBox(
                width: 150.w,
                child: BuildTextFormField(
                  inputType: TextInputType.text,
                  controller: widget.lastNameController,
                  hintText: StringTextsNames.txtLastName,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return StringTextsNames.txtLastNameValid;
                    }
                  },
                ),
              ),
            ],
          ),
          verticalSpace(18),
          BuildTextFormField(
            controller: widget.usernameController,
            hintText: StringTextsNames.txtUserName,
            inputType: TextInputType.text,
            validator: (value) {
              if (value == null || value.isEmpty
                  //|| !AppRegex.isPhoneNumValid(value)
                  ) {
                return StringTextsNames.txtUserName;
              }
            },
          ),
          verticalSpace(18),
          BuildTextFormField(
            controller: widget.phoneNumberController,
            hintText: StringTextsNames.txtPhoneNumber,
            inputType: TextInputType.number,
            validator: (value) {
              if (value == null || value.isEmpty
                  //|| !AppRegex.isPhoneNumValid(value)
                  ) {
                return StringTextsNames.txtHintValidPhoneNum;
              }
            },
          ),
          verticalSpace(18),
          BuildTextFormField(
            controller: widget.emailController,
            hintText: StringTextsNames.txtEmail,
            inputType: TextInputType.emailAddress,
            validator: (value) {
              if (value == null ||
                  value.isEmpty ||
                  !AppRegex.isEmailValid(value)) {
                return StringTextsNames.txtEmailIsValid;
              }
            },
          ),
          verticalSpace(18),
          BuildTextFormField(
            controller: widget.passwordController,
            hintText: StringTextsNames.txtPassword,
            isObscureText: isPasswordObscureText,
            suffixIcon: GestureDetector(
              onTap: () {
                setState(() {
                  isPasswordObscureText = !isPasswordObscureText;
                });
              },
              child: Icon(
                isPasswordObscureText ? Icons.visibility_off : Icons.visibility,
              ),
            ),
            validator: (value) {
              if (value == null || value.isEmpty
                  // || !AppRegex.isPasswordValid(value)
                  ) {
                return StringTextsNames.txtPasswordIsValid;
              }
            },
          ),
          verticalSpace(18),
          DropdownButtonFormField<String>(
            value: widget.gradeController.text.isEmpty
                ? null
                : widget.gradeController.text,
            hint: Text('Select Grade'),
            items: _dropdownItems,
            onChanged: (String? newValue) {
              setState(() {
                widget.gradeController.text = newValue!;
              });
            },
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Please select a grade';
              }
              return null;
            },
          ),
          verticalSpace(24),
          // BuildPasswordValidations(
          //   hasLowerCase: hasLowercase,
          //   hasUpperCase: hasUppercase,
          //   hasMinLength: hasMinLength,
          //   hasNumber: hasNumber,
          //   hasSpecialCharacter: hasSpecialCharacters,
          // ),
        ],
      ),
    );
  }
}
