import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

import 'package:a2z_app/core/helpers/extentions.dart';
import 'package:a2z_app/core/routing/routers.dart';
import 'package:a2z_app/core/widgets/build_toast.dart';
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

  File? _profileImage;

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
            GestureDetector(
              onTap: _pickImage,
              child: CircleAvatar(
                radius: 60,
                backgroundImage: _profileImage != null
                    ? FileImage(_profileImage!)
                    : const AssetImage('asset/images/teacher.png') as ImageProvider,
                child: _profileImage == null ? const Icon(Icons.add_a_photo) : null,
              ),
            ),
            verticalSpace(24),
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


  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _profileImage = File(pickedFile.path);
      });
    }
  }

  void _register() async {
    if (_formKey.currentState?.validate() ?? false) {
      String? profilePhotoUrl;

      // TODO: this is not really FINISH
      // upload the image to a server and get a URL.
      // using the file path directly.
      if (_profileImage != null) {
        profilePhotoUrl = _profileImage!.path;
      }

      GraphQLClientInstance.initializeClient();

      final MutationOptions options = MutationOptions(
        document: gql(r'''
    mutation RequestRegistration($storeId: String!, $firstName: String!, $lastName: String!, $phoneNumber: String!, $grade: String!, $profilePhoto: String!, $username: String!, $email: String!, $password: String!) {
      requestRegistration(
        command: {
          storeId: $storeId,
          contact: {
            firstName: $firstName,
            lastName: $lastName,
            phoneNumber: $phoneNumber,
            dynamicProperties: [
              { name: "grade", value: $grade },
              { name: "ProfilePhoto", value: $profilePhoto }
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
          'profilePhoto': profilePhotoUrl ?? '',
          'username': _usernameController.text,
          'email': _emailController.text,
          'password': _passwordController.text,
        },
      );

      final QueryResult result = await GraphQLClientInstance.client.mutate(options);

      if (result.hasException) {
        print(result.exception.toString());
      } else {
        final response = result.data?['requestRegistration'];
        final succeeded = response['result']['succeeded'] as bool;

        if (succeeded) {
          buildSuccessToast(context, "Successfully registered");
          context.pushNamed(Routes.loginScreen);
        } else {
          final errors = response['result']['errors'] as List<dynamic>;
          for (var error in errors) {
            print('Error: ${error['description']}');
            buildFailedToast(context, "Sorry Registration failed");
          }
        }
      }
    }
  }

}
