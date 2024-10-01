import 'dart:async';

import 'package:a2z_app/features/no_internet/no_internet_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

import '../../../../../a2z_app.dart';
import '../../../../../core/helpers/spacing.dart';
import '../../../../../core/language/language.dart';
import '../../../../../core/networking/clients/dio_client_graphql.dart';
import '../../../../../core/theming/text_style.dart';
import '../../../../../core/widgets/build_button.dart';
import '../../../../../core/widgets/build_text_form_field.dart';
import '../services/change_password_request.dart';
import '../services/graphql_getprofile_service.dart';

class ChangePasswordScreen extends StatefulWidget {
  const ChangePasswordScreen({super.key});

  @override
  State<ChangePasswordScreen> createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  final TextEditingController userNameController = TextEditingController();
  final TextEditingController oldPasswordController = TextEditingController();
  final TextEditingController newPasswordController = TextEditingController();
  bool isObscuredText = true;
  bool newIsObscuredText = true;


  late ProfileGraphQLService _profileService;

  Map<String, dynamic>? _profileData;
  // Internet Connection
  bool isConnectedToInternet = true;
  StreamSubscription? _internetConnectionStreamSubscription;

  @override
  void initState() {
    super.initState();
    final dioClientGrapQl = DioClientGraphql();
    _profileService = ProfileGraphQLService(dioClientGrapQl);
    _fetchProfile();

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

  Future<void> _fetchProfile() async {
    try {
      final data = await _profileService.fetchProfile(context);
      setState(() {
        _profileData = data;
      });

    } catch (e) {
      print('Failed to load profile: $e');
    }
  }

  String currentLang = "";

  @override
  Widget build(BuildContext context) {
    final isArabic = A2ZApp.getLocal(context).languageCode == 'ar';
    return Directionality (


        textDirection: isArabic ? TextDirection.rtl : TextDirection.ltr,
        child: isConnectedToInternet
      ? Scaffold(
          appBar: AppBar(
            title: Text(
              Language.instance.txtChangePass(),
              style: TextStyles.font15DarkBlueMedium,
            ),
          ),
        body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.h, vertical: 24.w),
          child: ListView(
            children: [
              Text(
                Language.instance.txtChangePass(),
                style: TextStyles.font24BlueBold,
              ),
              verticalSpace(8),
              Text(
                Language.instance.txtChangePassDes(),
                style: TextStyles.font14GrayNormal,
              ),
              verticalSpace(42),
              // BuildTextFormField(
              //   controller: userNameController,
              //   hintText: _profileData?['userName'] ?? "Default Username",
              //   validator: (value) {
              //     if (value == null || value.isEmpty) {
              //       return Language.instance.txtNameValid;
              //     }
              //     return null;
              //   },
              // ),
             // verticalSpace(14),
              BuildTextFormField(
                controller: oldPasswordController,
                hintText: Language.instance.txtOldPassword(),
                isObscureText: isObscuredText,
                suffixIcon: GestureDetector(
                  onTap: () {
                    setState(() {
                      isObscuredText = !isObscuredText;
                    });
                  },
                  child: Icon(
                    isObscuredText ? Icons.visibility_off : Icons.visibility,
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return Language.instance.txtPasswordIsValid;
                  }
                  return null;
                },
              ),
              verticalSpace(14),
              BuildTextFormField(
                controller: newPasswordController,
                hintText: Language.instance.txtNewPassword(),
                isObscureText: newIsObscuredText,
                suffixIcon: GestureDetector(
                  onTap: () {
                    setState(() {
                      newIsObscuredText = !newIsObscuredText;
                    });
                  },
                  child: Icon(
                    newIsObscuredText ? Icons.visibility_off : Icons.visibility,
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return Language.instance.txtPasswordIsValid;
                  }
                  return null;
                },
              ),
              verticalSpace(50),
              BuildButton(
                textButton: Language.instance.txtChangePass(),
                textStyle: TextStyles.font16WhiteMedium,
                onPressed: () {
                  changePassword(
                    context: context,
                    username: _profileData?['userName'],
                    oldPassword: oldPasswordController.text,
                    newPassword: newPasswordController.text,
                  );
                },
              ),
            ],
          ),
        ),
      )
      : const NoInternetScreen(),


    );
  }
}
