//
// About Us
//
// Welcome to [Your App Name], your gateway to online education designed to empower learners of all ages. Our platform provides high-quality, interactive learning experiences, offering courses across a wide range of subjects. Whether you're a student looking to enhance your skills, a professional seeking career advancement, or simply someone eager to learn something new, we've got the right course for you.
//
// At [Your App Name], we believe that education should be accessible to everyone, anywhere. Our expert instructors and innovative tools ensure that learning is engaging, flexible, and tailored to your needs.
//
// Join us today and start your journey towards mastering new knowledge and skills, all from the comfort of your home.
//
import 'dart:async';

import 'package:a2z_app/features/no_internet/no_internet_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

import '../../../../../a2z_app.dart';
import '../../../../../core/language/language.dart';
import '../../../../../core/theming/text_style.dart';

class AboutUsScreen extends StatefulWidget {
  const AboutUsScreen({super.key});

  @override
  State<AboutUsScreen> createState() => _AboutUsScreenState();
}

class _AboutUsScreenState extends State<AboutUsScreen> {


  // Internet Connection
  bool isConnectedToInternet = true;
  StreamSubscription? _internetConnectionStreamSubscription;

  @override
  void initState() {
    // TODO: implement initState

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
    super.initState();
  }


  @override
  Widget build(BuildContext context) {

    final isArabic = A2ZApp.getLocal(context).languageCode == 'ar';

    return Directionality(
      textDirection: isArabic ? TextDirection.rtl : TextDirection.ltr,
      child: isConnectedToInternet
        ? Scaffold(
        appBar: AppBar(
          title: Text(
            Language.instance.txtAboutUs(),
            style: TextStyles.font15DarkBlueMedium,
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                 Language.instance.txtAboutDes(),
                  style: TextStyles.font13DarkBlueMedium ),

                SizedBox(height: 24.h),
                Text(
                  Language.instance.txtMeetDevelopers(),
                  style: TextStyles.font16BlueSemiBold
                ),
                SizedBox(height: 16.h),

                 Row(
                  children: [
                    CircleAvatar(
                      radius: 26.sp,
                    ),
                    SizedBox(width: 12.w),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Ahmed Tantawy",
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          "Mobile App Developer",
                          style: TextStyle(fontSize: 14.sp),
                        ),
                        SizedBox(height: 4.h),
                         Text(
                          "Tel: 01094642577  \n"
                              "Email: ahmedtramadan4@gmail.com",
                          style: TextStyle(fontSize: 14.sp),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: 24),

                Row(
                  children: [
                    CircleAvatar(
                      radius: 26.sp,
                    ),
                    SizedBox(width: 12.w),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Ahmed Elrakhawy",
                          style: TextStyle(
                            fontSize: 16.sp,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          "Backend Developer",
                          style: TextStyle(fontSize: 14.sp),
                        ),
                        SizedBox(height: 4.h),
                        Text(
                          "Tel: 01064188997  \n"
                              "Email: ahmedelrakhawy79@gmail.com",
                          style: TextStyle(fontSize: 14.sp),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: 24.h),

                Text(
                  Language.instance.txtWeBelieve(),
                  style: TextStyle(fontSize: 14.sp),
                ),
                SizedBox(height: 24.h),

                // Contact Section (Optional)
                // Text(
                //   "Contact Us",
                //   style: TextStyle(
                //     fontSize: 18,
                //     fontWeight: FontWeight.bold,
                //     color: Colors.blueAccent,
                //   ),
                // ),
                // SizedBox(height: 8),
                // Text(
                //   "Email: support@onlineeducation.com",
                //   style: TextStyle(fontSize: 16),
                // ),
              ],
            ),
          ),
        ),
      )
      : const NoInternetScreen(),
    );
  }
}
