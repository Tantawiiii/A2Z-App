import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

import 'package:a2z_app/core/helpers/extentions.dart';
import 'package:a2z_app/core/routing/routers.dart';
import 'package:a2z_app/core/widgets/build_toast.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import '../../../a2z_app.dart';
import '../../../core/language/language.dart';
import '../../../core/networking/clients/get_grades_graphql_client.dart';
import '../../../core/utils/colors_code.dart';
import '../../no_internet/no_internet_screen.dart';
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
  bool _isLoading = false;

  XFile? _profileImage;

  // Internet Connection
  bool isConnectedToInternet = true;
  StreamSubscription? _internetConnectionStreamSubscription;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    // start checker internet connection
    _internetConnectionStreamSubscription =
        InternetConnection().onStatusChange.listen((event) {
          switch (event) {
            case InternetStatus.connected:
              setState(() {
                isConnectedToInternet = true;
              });
              break;
            case InternetStatus.disconnected:
              setState(() {
                isConnectedToInternet = false;
              });
              break;
            default:
              setState(() {
                isConnectedToInternet = false;
              });
              break;
          }
        });
  }


  @override
  Widget build(BuildContext context) {
    final isArabic = A2ZApp.getLocal(context).languageCode == 'ar';
    return Directionality(
      textDirection: isArabic ? TextDirection.rtl : TextDirection.ltr,
      child: isConnectedToInternet
      ? Scaffold(
        resizeToAvoidBottomInset: false,
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 24.h),
          child: ListView(
            children: [
              Text(
                Language.instance.txtCreateAccount(),
                style: TextStyles.font24BlueBold,
              ),
              verticalSpace(8),
              Text(
                Language.instance.txtCreateAccDes(),
                style: TextStyles.font14GrayNormal,
              ),
              verticalSpace(36),
              GestureDetector(
                onTap: _pickImage,
                child: CircleAvatar(
                  radius: 75,
                  backgroundImage: _profileImage != null
                      ? null // Set to null since we're using the `child` property to display the image
                      : const AssetImage('asset/images/teacher.png')
                          as ImageProvider,
                  child: _profileImage == null
                      ? const Icon(Icons.add_a_photo)
                      : ClipOval(
                          // Ensures the image fits the circular shape
                          child: Image.file(
                            File(_profileImage!.path),
                            width: 140, // Adjust to your needs (2 * radius)
                            height: 140,
                            fit: BoxFit
                                .cover, // Ensures the image covers the circle
                          ),
                        ),
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
              _isLoading
                  ? const Center(
                      child: SpinKitFadingCircle(
                      color: ColorsCode.mainBlue,
                      size: 50.0,
                    ))
                  : BuildButton(
                      textButton: Language.instance.txtCreateAccount(),
                      textStyle: TextStyles.font18WhiteSemiBold,
                      onPressed: _register,
                    ),
              verticalSpace(16),
              const AlreadyHaveAccountText(),
              verticalSpace(160),
            ],
          ),
        ),
      )
          : const NoInternetScreen(),
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

    _internetConnectionStreamSubscription?.cancel();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(
      source: ImageSource.gallery,
      maxWidth: 1024,
      maxHeight: 1024,
      preferredCameraDevice: CameraDevice.rear,
      imageQuality: 85,
    );

    if (pickedFile != null) {
      CroppedFile? croppedFile = await ImageCropper().cropImage(
        sourcePath: pickedFile.path,
        uiSettings: [
          AndroidUiSettings(
            toolbarTitle: 'Cropper',
            toolbarColor: Colors.deepOrange,
            toolbarWidgetColor: Colors.white,
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: false,
            // hideBottomControls: true,
            aspectRatioPresets: [
              CropAspectRatioPreset.original,
              CropAspectRatioPreset.square,
              CropAspectRatioPreset.ratio4x3,
            ],
          ),
          IOSUiSettings(
            title: 'Cropper',
            aspectRatioPresets: [
              CropAspectRatioPreset.original,
              CropAspectRatioPreset.square,
              CropAspectRatioPreset.ratio4x3,
            ],
          ),
        ],
      );

      if (croppedFile != null) {
        setState(() {
          _profileImage = XFile(croppedFile.path);
        });
      }
    }
  }

  void _register() async {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() {
        _isLoading = true; // Start loading
      });

      String? profilePhotoUrl;
      if (_profileImage != null) {
        profilePhotoUrl = _profileImage!.path;
      }

      GraphQLClientInstance.initializeClient();

      final MutationOptions options = MutationOptions(
        document: gql(r'''
  mutation RequestRegistration($storeId: String!, $firstName: String!, $lastName: String!, $phoneNumber: String!, $dynamicProperties: [InputDynamicPropertyValueType!]!, $username: String!, $email: String!, $password: String!) {
    requestRegistration(
      command: {
        storeId: $storeId,
        contact: {
          firstName: $firstName,
          lastName: $lastName,
          phoneNumber: $phoneNumber,
          dynamicProperties: $dynamicProperties
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
          'phoneNumber': "+2${_phoneNumberController.text}",
          'dynamicProperties': [
            {'name': 'grade', 'value': _gradeController.text},
            {'name': 'ProfilePhoto', 'value': profilePhotoUrl ?? ''}
          ],
          'username': _usernameController.text,
          'email': _emailController.text,
          'password': _passwordController.text,
        },
      );


      final QueryResult result =
          await GraphQLClientInstance.client.mutate(options);

      setState(() {
        _isLoading = false; // Stop loading
      });

      if (result.hasException) {
        print(result.exception.toString());
      } else {
        final response = result.data?['requestRegistration'];
        final succeeded = response['result']['succeeded'] as bool;

        if (succeeded) {
          buildSuccessToast(context, Language.instance.txtSuccessRegister());
          context.pushNamed(Routes.loginScreen);
        } else {
          final errors = response['result']['errors'] as List<dynamic>;
          for (var error in errors) {
            print('Error: ${error['description']}');

            buildFailedToast(context, Language.instance.txtFailedRegister());
          }
        }
      }
    }
  }
}
