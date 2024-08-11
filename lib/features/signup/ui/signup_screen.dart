import 'package:a2z_app/core/helpers/extentions.dart';
import 'package:a2z_app/core/routing/routers.dart';
import 'package:a2z_app/core/widgets/build_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

import '../../../core/networking/clients/get_grades_graphql_client.dart';
import '../../../core/utils/StringsTexts.dart';
import 'widgets/already_have_account_text.dart';
import 'widgets/build_sign_up_form.dart';
import '../../../../../core/helpers/spacing.dart';
import '../../../../../core/theming/text_style.dart';
import '../../../core/widgets/build_button.dart';

class SignupScreen extends StatefulWidget {
  SignupScreen({super.key});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _phoneNumberController = TextEditingController();
  final _emailController = TextEditingController();
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _gradeController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 24.h),
        child: ListView(
          children: [
            Text(
              StringTextsNames.txtCreateAccount,
              style: TextStyles.font24BlueBold,
            ),
            verticalSpace(8),
            Text(
              StringTextsNames.txtCreateAccDes,
              style: TextStyles.font14GrayNormal,
            ),
            verticalSpace(36),
            SignupForm(
              formKey: _formKey,
              firstNameController: _firstNameController,
              lastNameController: _lastNameController,
              phoneNumberController: _phoneNumberController,
              emailController: _emailController,
              usernameController: _usernameController,
              passwordController: _passwordController,
              gradeController: _gradeController,
            ),
            verticalSpace(40),
            BuildButton(
              textButton: StringTextsNames.txtCreateAccount,
              textStyle: TextStyles.font16WhiteMedium,
              onPressed: _register,
            ),
            verticalSpace(16),
            const AlreadyHaveAccountText(),
            verticalSpace(160),
          ],
        ),
      ),
    );
  }

  void _register() async {
    if (_formKey.currentState?.validate() ?? false) {
      GraphQLClientInstance.initializeClient(); // Ensure the client is initialized

      final MutationOptions options = MutationOptions(
        document: gql(r'''
          mutation RequestRegistration($storeId: String!, $firstName: String!, $lastName: String!, $phoneNumber: String!, $grade: String!, $username: String!, $email: String!, $password: String!) {
            requestRegistration(
              command: {
                storeId: $storeId,
                contact: {
                  firstName: $firstName,
                  lastName: $lastName,
                  phoneNumber: $phoneNumber,
                  dynamicProperties: [
                    {
                      name: "grade",
                      value: $grade
                    }
                  ]
                },
                account: {
                  username: $username,
                  email: $email,
                  password: $password
                }
              }
            ) {
              result {
                succeeded
                requireEmailVerification
                oTP
                errors {
                  code
                  description
                  parameter
                }
              }
              account {
                id
              }
            }
          }
        '''),
        variables: {
          'storeId': 'A2Z',
          'firstName': _firstNameController.text,
          'lastName': _lastNameController.text,
          'phoneNumber': _phoneNumberController.text,
          'grade': _gradeController.text,
          'username': _usernameController.text,
          'email': _emailController.text,
          'password': _passwordController.text,
        },
      );

      final QueryResult result = await GraphQLClientInstance.client.mutate(options);

      if (result.hasException) {
        // Handle GraphQL errors here
        print(result.exception.toString());
        // Show error to the user
      } else {
        final response = result.data?['requestRegistration'];
        final succeeded = response['result']['succeeded'] as bool;

        if (succeeded) {
          // Registration was successful
          // Navigate to the next screen or show a success message
          buildSuccessToast(context, "Successfully registered");
          context.pushNamed(Routes.loginScreen);
        } else {
          // Registration failed, handle errors
          final errors = response['result']['errors'] as List<dynamic>;
          for (var error in errors) {
            print('Error: ${error['description']}');
            // Show error to the user
            buildFailedToast(context, "Sorry Registration failed");
          }
        }
      }
    }
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _phoneNumberController.dispose();
    _emailController.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    _gradeController.dispose();
    super.dispose();
  }
}
