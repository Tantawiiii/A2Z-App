import 'package:a2z_app/core/utils/colors_code.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:a2z_app/core/helpers/extentions.dart';
import 'package:a2z_app/core/theming/text_style.dart';
import 'package:a2z_app/core/utils/StringsTexts.dart';
import 'package:a2z_app/core/widgets/build_button.dart';
import 'package:a2z_app/core/widgets/build_toast.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import '../../../../core/helpers/spacing.dart';
import '../../../../core/routing/routers.dart';
import '../../services/login_services.dart';
import '../widgets/build_dont_have_acc_text.dart';
import '../widgets/build_email_and_password.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> with SingleTickerProviderStateMixin {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final AuthService _authService = AuthService();
  bool _isLoading = false;

  // Animation controllers and animations
  late AnimationController _animationController;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

    // Initialize the animation controller
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );

    // Initialize slide and fade animations
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeOut,
    ));

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeIn,
    ));

    // Start animations when the screen loads
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _animationController.forward();
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Stack(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 24.h, vertical: 24.h,),
              child: ListView(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SlideTransition(
                        position: _slideAnimation,
                        child: FadeTransition(
                          opacity: _fadeAnimation,
                          child: Text(
                            StringTextsNames.txtWelcomeBack,
                            style: TextStyles.font24BlueBold,
                          ),
                        ),
                      ),
                      verticalSpace(8),
                      SlideTransition(
                        position: _slideAnimation,
                        child: FadeTransition(
                          opacity: _fadeAnimation,
                          child: Text(
                            StringTextsNames.txtDescriptionLogin,
                            style: TextStyles.font14GrayNormal,
                          ),
                        ),
                      ),
                      verticalSpace(44),
                      SlideTransition(
                        position: _slideAnimation,
                        child: FadeTransition(
                          opacity: _fadeAnimation,
                          child: Column(
                            children: [
                              BuildEmailAndPassword(
                                emailController: _usernameController,
                                passwordController: _passwordController,
                              ),
                              verticalSpace(12),
                              Align(
                                alignment: AlignmentDirectional.centerEnd,
                                child: InkWell(
                                  child: Text(
                                    StringTextsNames.txtForgetPassword,
                                    style: TextStyles.font13BlueNormal,
                                  ),
                                  onTap: () {
                                    context.pushNamed(Routes.forgetPasswordScreen);
                                  },
                                ),
                              ),
                              verticalSpace(50),
                              BuildButton(
                                textButton: StringTextsNames.txtLogin,
                                textStyle: TextStyles.font16WhiteMedium,
                                onPressed: _login,
                              ),
                              verticalSpace(24),
                              const DontHaveAccountText(),
                              verticalSpace(50),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            if (_isLoading)
              const Center(
                child: SpinKitCircle(
                  color: ColorsCode.mainBlue,
                  size: 50.0,
                ),
              ),
          ],
        ),
      ),
    );
  }


  @override
  void dispose() {
    _animationController.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _login() async {
    final username = _usernameController.text;
    final password = _passwordController.text;

    if (username.isNotEmpty && password.isNotEmpty) {
      setState(() {
        _isLoading = true; // Start loading
      });
      // Perform login
      await _authService.login(context, username, password);

      setState(() {
        _isLoading = false; // Stop loading after response
      });
    } else {
      buildFailedToast(context, 'Please fill in both fields.');
    }
  }
}
