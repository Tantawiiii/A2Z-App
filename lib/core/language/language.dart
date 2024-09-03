import 'package:flutter/material.dart';

import '../../main.dart';

class Language extends ChangeNotifier {
  Language._privateConstructor();

  static final Language _instance = Language._privateConstructor();

  static Language get instance => _instance;

  String? _lang = language;

  getLanguage() {
    return _lang;
  }

  setLanguage(String lang) {
    _lang = lang;
  }


  titleOnBoard1() {
    if (getLanguage() == 'EN') {
      return "Discover Your Learning Journey";
    } else if (getLanguage() == 'AR') {
      return "اكتشف رحلة التعلم الخاصة بك";
    }
  }

  titleOnBoard3() {
    if (getLanguage() == 'EN') {
      return "Your Path to Success Starts Here";
    } else if (getLanguage() == 'AR') {
      return "طريقك إلى النجاح يبدأ هنا";
    }
  }

  titleOnBoard2() {
    if (getLanguage() == 'EN') {
      return "Achieve More, Learn Better";
    } else if (getLanguage() == 'AR') {
      return "حقق المزيد، وتعلم بشكل أفضل";
    }
  }

  desOnBoard1() {
    if (getLanguage() == 'EN') {
      return "Our platform offers a diverse range of courses and interactive content that adapts to your unique learning style.";
    } else if (getLanguage() == 'AR') {
      return "توفر منصتنا مجموعة متنوعة من الدورات والمحتوى التفاعلي الذي يتكيف مع أسلوب التعلم الفريد الخاص بك.";
    }
  }

  desOnBoard3() {
    if (getLanguage() == 'EN') {
      return "Our curated content and personalized learning paths are designed to help you achieve your goals.";
    } else if (getLanguage() == 'AR') {
      return "تم تصميم المحتوى المنسق لدينا ومسارات التعلم الشخصية لمساعدتك في تحقيق أهدافك.";
    }
  }

  desOnBoard2() {
    if (getLanguage() == 'EN') {
      return "Our platform is designed to help you reach your full potential—benefit from personalized recommendations, progress tracking, and a supportive community of learners.";
    } else if (getLanguage() == 'AR') {
      return "تم تصميم منصتنا لمساعدتك على تحقيق إمكاناتك الكاملة - الاستفادة من التوصيات المخصصة، وتتبع التقدم، والمجتمع الداعم للمتعلمين.";
    }
  }

  txtSkip() {
    if (getLanguage() == 'EN') {
      return "Skip";
    } else if (getLanguage() == 'AR') {
      return "يتخطى";
    }
  }

  txtNext() {
    if (getLanguage() == 'EN') {
      return "Next";
    } else if (getLanguage() == 'AR') {
      return "التالي";
    }
  }

  txtDone() {
    if (getLanguage() == 'EN') {
      return "Done";
    } else if (getLanguage() == 'AR') {
      return "انتهيت";
    }
  }

  txtOnBoardingHeadLine() {
    if (getLanguage() == 'EN') {
      return "Choose the best teacher \n suitable for you.";
    } else if (getLanguage() == 'AR') {
      return "إختر المعلم الأفضل المناسب لك";
    }
  }

  txGetStartedButton() {
    if (getLanguage() == 'EN') {
      return "Get Started";
    } else if (getLanguage() == 'AR') {
      return "البدء";
    }
  }

  txtOnBoardingDescription() {
    if (getLanguage() == 'EN') {
      return "Discover a wide range of teaching materials and tools to enhance your lessons.";
    } else if (getLanguage() == 'AR') {
      return "اكتشف مجموعة واسعة من مواد وأدوات التدريس لتحسين دروسك.";
    }
  }


  txtWelcomeBack() {
    if (getLanguage() == 'EN') {
      return "Welcome Back";
    } else if (getLanguage() == 'AR') {
      return "مرحبًا بعودتك";
    }
  }


  txtWelcome() {
    if (getLanguage() == 'EN') {
      return "Welcome";
    } else if (getLanguage() == 'AR') {
      return "مرحباً";
    }
  }

  txtDescriptionLogin() {
    if (getLanguage() == 'EN') {
      return "We're excited to have you back, can't wait to see what you've been up to since you last logged in.";
    } else if (getLanguage() == 'AR') {
      return "نحن متحمسون لعودتك، ولا نستطيع الانتظار لرؤية ما كنت تفعله منذ تسجيل الدخول آخر مرة.";
    }
  }

  txtEmail() {
    if (getLanguage() == 'EN') {
      return "Email";
    } else if (getLanguage() == 'AR') {
      return "بريد إلكتروني";
    }
  }

  txtPassword() {
    if (getLanguage() == 'EN') {
      return "Password";
    } else if (getLanguage() == 'AR') {
      return "كلمة المرور";
    }
  }

  txtForgetPassword() {
    if (getLanguage() == 'EN') {
      return "Forgot Password?";
    } else if (getLanguage() == 'AR') {
      return "هل نسيت كلمة السر؟";
    }
  }

  txtLogin() {
    if (getLanguage() == 'EN') {
      return "Login";
    } else if (getLanguage() == 'AR') {
      return "تسجيل الدخول";
    }
  }

  txtEmailIsValid() {
    if (getLanguage() == 'EN') {
      return "please enter a valid email.";
    } else if (getLanguage() == 'AR') {
      return "الرجاء إدخال بريد إلكتروني صالح.";
    }
  }

  txtPasswordIsValid() {
    if (getLanguage() == 'EN') {
      return "please enter a valid password.";
    } else if (getLanguage() == 'AR') {
      return "الرجاء إدخال كلمة مرور صالحة.";
    }
  }


  txtDontHaveAcc() {
    if (getLanguage() == 'EN') {
      return "Don't have an account? ";
    } else if (getLanguage() == 'AR') {
      return "لا تملك حسابًا؟ ";
    }
  }

  txtSignUp() {
    if (getLanguage() == 'EN') {
      return "Sign Up";
    } else if (getLanguage() == 'AR') {
      return "سجل الآن";
    }
  }

  txtFirstName() {
    if (getLanguage() == 'EN') {
      return "First Name";
    } else if (getLanguage() == 'AR') {
      return "الاسم الأول";
    }
  }

  txtFirstNameValid() {
    if (getLanguage() == 'EN') {
      return "Enter First Name";
    } else if (getLanguage() == 'AR') {
      return "أدخل الاسم الأول";
    }
  }

  txtLastName() {
    if (getLanguage() == 'EN') {
      return "Last Name";
    } else if (getLanguage() == 'AR') {
      return "اسم العائلة";
    }
  }

  txtLastNameValid() {
    if (getLanguage() == 'EN') {
      return "Enter Last Name";
    } else if (getLanguage() == 'AR') {
      return "أدخل اسم العائلة";
    }
  }

  txtNameValid() {
    if (getLanguage() == 'EN') {
      return "Please enter a valid name";
    } else if (getLanguage() == 'AR') {
      return "الرجاء إدخال اسم صالح";
    }
  }

  txtGrade() {
    if (getLanguage() == 'EN') {
      return "Your Grades";
    } else if (getLanguage() == 'AR') {
      return "درجاتك";
    }
  }

  txtGradeValid() {
    if (getLanguage() == 'EN') {
      return "Please enter a valid Grades";
    } else if (getLanguage() == 'AR') {
      return "الرجاء إدخال درجات صالحة";
    }
  }

  txtPhoneNumber() {
    if (getLanguage() == 'EN') {
      return "ex: 01** *** ****";
    } else if (getLanguage() == 'AR') {
      return "مثال: 01** *** ****";
    }
  }

  txtHintValidPhoneNum() {
    if (getLanguage() == 'EN') {
      return "Please enter a valid phone number";
    } else if (getLanguage() == 'AR') {
      return "الرجاء إدخال رقم هاتف صالح";
    }
  }

  txtForgetPasswordTitle() {
    if (getLanguage() == 'EN') {
      return "Forgot your password";
    } else if (getLanguage() == 'AR') {
      return "نسيت كلمة المرور؟";
    }
  }

  txtForgetPasswordDes() {
    if (getLanguage() == 'EN') {
      return "At our app, we take the security of your information seriously. Enter your phone number to get the activation code.";
    } else if (getLanguage() == 'AR') {
      return "في تطبيقنا، نحن نهتم بسلامة معلوماتك. أدخل رقم هاتفك للحصول على رمز التفعيل.";
    }
  }

  txtVerifyOtp() {
    if (getLanguage() == 'EN') {
      return "Verification OTP Code";
    } else if (getLanguage() == 'AR') {
      return "رمز التحقق OTP";
    }
  }

  txtVerifyOtpDes() {
    if (getLanguage() == 'EN') {
      return "We have sent the OTP code. Please check your messages.";
    } else if (getLanguage() == 'AR') {
      return "لقد أرسلنا رمز OTP. يرجى التحقق من رسائلك.";
    }
  }

  txtConfirmBtn() {
    if (getLanguage() == 'EN') {
      return "Confirm";
    } else if (getLanguage() == 'AR') {
      return "تأكيد";
    }
  }

  txtPasswordReset() {
    if (getLanguage() == 'EN') {
      return "Password Reset";
    } else if (getLanguage() == 'AR') {
      return "إعادة تعيين كلمة المرور";
    }
  }

  txtOtpEnterData() {
    if (getLanguage() == 'EN') {
      return "Enter your OTP code.";
    } else if (getLanguage() == 'AR') {
      return "أدخل رمز OTP الخاص بك.";
    }
  }

  txtNewPassword() {
    if (getLanguage() == 'EN') {
      return "Enter your New Password.";
    } else if (getLanguage() == 'AR') {
      return "أدخل كلمة المرور الجديدة.";
    }
  }

  txtSuccessfully() {
    if (getLanguage() == 'EN') {
      return "Successfully";
    } else if (getLanguage() == 'AR') {
      return "بنجاح";
    }
  }

  txtSuccessDes() {
    if (getLanguage() == 'EN') {
      return "Valia! You nailed it. You have successfully reset your account password.";
    } else if (getLanguage() == 'AR') {
      return "رائع! لقد قمت بإعادة تعيين كلمة المرور لحسابك بنجاح.";
    }
  }

  txtCreateAccount() {
    if (getLanguage() == 'EN') {
      return "Create Account";
    } else if (getLanguage() == 'AR') {
      return "إنشاء حساب";
    }
  }

  txtCreateAccDes() {
    if (getLanguage() == 'EN') {
      return "Sign up now and start exploring all that our app has to offer. We’re excited to welcome you to our community!";
    } else if (getLanguage() == 'AR') {
      return "اشترك الآن وابدأ في استكشاف كل ما يقدمه تطبيقنا. نحن متحمسون للترحيب بك في مجتمعنا!";
    }
  }

  txtNoCourses() {
    if (getLanguage() == 'EN') {
      return "You have no Courses yet.";
    } else if (getLanguage() == 'AR') {
      return "ليس لديك دورات بعد.";
    }
  }

  txtNoCategories() {
    if (getLanguage() == 'EN') {
      return "You have no Categories in your Grade yet.";
    } else if (getLanguage() == 'AR') {
      return "ليس لديك فئات في صفك بعد.";
    }
  }

  txtSubNow() {
    if (getLanguage() == 'EN') {
      return "Subscribe Now.";
    } else if (getLanguage() == 'AR') {
      return "اشترك الآن.";
    }
  }

  txtAhmedRamadan() {
    if (getLanguage() == 'EN') {
      return "Ahmed Ramadan";
    } else if (getLanguage() == 'AR') {
      return "أحمد رمضان";
    }
  }

  txtStudent() {
    if (getLanguage() == 'EN') {
      return "Student";
    } else if (getLanguage() == 'AR') {
      return "طالب";
    }
  }

  txtChangePass() {
    if (getLanguage() == 'EN') {
      return "Change Password";
    } else if (getLanguage() == 'AR') {
      return "تغيير كلمة المرور";
    }
  }

  txtChangePassDes() {
    if (getLanguage() == 'EN') {
      return "Now you can change your password with the new password and the old password.";
    } else if (getLanguage() == 'AR') {
      return "يمكنك الآن تغيير كلمة المرور باستخدام كلمة المرور الجديدة والقديمة.";
    }
  }

  txtOldPassword() {
    if (getLanguage() == 'EN') {
      return "Enter Your Old Password";
    } else if (getLanguage() == 'AR') {
      return "أدخل كلمة المرور القديمة";
    }
  }

  txtFaq() {
    if (getLanguage() == 'EN') {
      return "FAQ";
    } else if (getLanguage() == 'AR') {
      return "الأسئلة الشائعة";
    }
  }

  txtAboutUs() {
    if (getLanguage() == 'EN') {
      return "About Us";
    } else if (getLanguage() == 'AR') {
      return "معلومات عنا";
    }
  }

  txtLogOut() {
    if (getLanguage() == 'EN') {
      return "Log Out";
    } else if (getLanguage() == 'AR') {
      return "تسجيل الخروج";
    }
  }

  txtUserName() {
    if (getLanguage() == 'EN') {
      return "User Name";
    } else if (getLanguage() == 'AR') {
      return "اسم المستخدم";
    }
  }

  txtAllCourses() {
    if (getLanguage() == 'EN') {
      return "All Courses";
    } else if (getLanguage() == 'AR') {
      return "جميع الدورات";
    }
  }

  txtCourses() {
    if (getLanguage() == 'EN') {
      return "Courses";
    } else if (getLanguage() == 'AR') {
      return "الدورات";
    }
  }

  txtCategories() {
    if (getLanguage() == 'EN') {
      return "Categories";
    } else if (getLanguage() == 'AR') {
      return "الفئات";
    }
  }

  txtShowAll() {
    if (getLanguage() == 'EN') {
      return "Show All";
    } else if (getLanguage() == 'AR') {
      return "عرض الكل";
    }
  }

  txtHowAre() {
    if (getLanguage() == 'EN') {
      return "How are you today?";
    } else if (getLanguage() == 'AR') {
      return "كيف حالك اليوم؟";
    }
  }

  txtReady() {
    if (getLanguage() == 'EN') {
      return "Ready...!";
    } else if (getLanguage() == 'AR') {
      return "جاهز...!";
    }
  }

  txtHintSearch() {
    if (getLanguage() == 'EN') {
      return "Search for your favorite Teacher..";
    } else if (getLanguage() == 'AR') {
      return "ابحث عن معلمك المفضل..";
    }
  }

  txtCheckOut() {
    if (getLanguage() == 'EN') {
      return "CheckOut";
    } else if (getLanguage() == 'AR') {
      return "الدفع";
    }
  }

  txtSubscribe() {
    if (getLanguage() == 'EN') {
      return "Subscribe";
    } else if (getLanguage() == 'AR') {
      return "اشتراك";
    }
  }

  txtSubscribeAppBar() {
    if (getLanguage() == 'EN') {
      return "Subscribe to Course";
    } else if (getLanguage() == 'AR') {
      return "الاشتراك في الدورة";
    }
  }

  txtSubscribeDes() {
    if (getLanguage() == 'EN') {
      return "Subscription Codes App makes the learner enrollment process faster and more automated.";
    } else if (getLanguage() == 'AR') {
      return "تطبيق رموز الاشتراك يجعل عملية تسجيل المتعلم أسرع وأكثر تلقائية.";
    }
  }

  txtSubscribeSuccess() {
    if (getLanguage() == 'EN') {
      return "Subscribe Successfully";
    } else if (getLanguage() == 'AR') {
      return "تم الاشتراك بنجاح";
    }
  }

  txtSubscribeFailed() {
    if (getLanguage() == 'EN') {
      return "Subscribe Failed";
    } else if (getLanguage() == 'AR') {
      return "فشل الاشتراك";
    }
  }

  txtSubscribeSuccessDes() {
    if (getLanguage() == 'EN') {
      return "You have successfully subscribed to the course.";
    } else if (getLanguage() == 'AR') {
      return "لقد قمت بالاشتراك في الدورة بنجاح.";
    }
  }

  txtSubscribeFailedDes() {
    if (getLanguage() == 'EN') {
      return "You have failed to subscribe to the course.";
    } else if (getLanguage() == 'AR') {
      return "لقد فشلت في الاشتراك في الدورة.";
    }
  }

  txtNoCategoriesAval() {
    if (getLanguage() == 'EN') {
      return "No categories available";
    } else if (getLanguage() == 'AR') {
      return "لا توجد فئات متاحة";
    }
  }

  txtNoProductsAval() {
    if (getLanguage() == 'EN') {
      return "No products available.";
    } else if (getLanguage() == 'AR') {
      return "لا توجد منتجات متاحة.";
    }
  }

  txtValidateSubscriptionCode() {
    if (getLanguage() == 'EN') {
      return "Please enter your Subscription Code.";
    } else if (getLanguage() == 'AR') {
      return "الرجاء إدخال رمز الاشتراك الخاص بك.";
    }
  }

  txtEmptyExams() {
    if (getLanguage() == 'EN') {
      return "Don't worry, there is still time left for the exam. Be ready with us.";
    } else if (getLanguage() == 'AR') {
      return "لا تقلق، لا يزال هناك وقت متبقي للامتحان. كن مستعدًا معنا.";
    }
  }

  txtEmptyDoc() {
    if (getLanguage() == 'EN') {
      return "Not available documentation for the course yet.";
    } else if (getLanguage() == 'AR') {
      return "لم يتم توفير الوثائق للدورة بعد.";
    }
  }

  txtNoProducts() {
    if (getLanguage() == 'EN') {
      return "Product not found.";
    } else if (getLanguage() == 'AR') {
      return "المنتج غير موجود.";
    }
  }

  txtDetails() {
    if (getLanguage() == 'EN') {
      return "Details";
    } else if (getLanguage() == 'AR') {
      return "تفاصيل";
    }
  }

  txtVideos() {
    if (getLanguage() == 'EN') {
      return "Videos";
    } else if (getLanguage() == 'AR') {
      return "فيديوهات";
    }
  }

  txtExams() {
    if (getLanguage() == 'EN') {
      return "Exams";
    } else if (getLanguage() == 'AR') {
      return "الامتحانات";
    }
  }

  txtAttachment() {
    if (getLanguage() == 'EN') {
      return "Attachment";
    } else if (getLanguage() == 'AR') {
      return "مرفق";
    }
  }

  txtNoInternet() {
    if (getLanguage() == 'EN') {
      return "No Internet Connection";
    } else if (getLanguage() == 'AR') {
      return "لا يوجد اتصال بالإنترنت";
    }
  }

  txtPleaseCheckInternet() {
    if (getLanguage() == 'EN') {
      return "Please check your internet connection and try again.";
    } else if (getLanguage() == 'AR') {
      return "يرجى التحقق من اتصال الإنترنت الخاص بك والمحاولة مرة أخرى.";
    }
  }

  txtRetry() {
    if (getLanguage() == 'EN') {
      return "Retry";
    } else if (getLanguage() == 'AR') {
      return "أعد المحاولة";
    }
  }

  txtUserNotExist() {
    if (getLanguage() == 'EN') {
      return "User does not exist. Please check your phone number.";
    } else if (getLanguage() == 'AR') {
      return "المستخدم غير موجود. يرجى التحقق من رقم هاتفك.";
    }
  }

  txtOTPSuccessful() {
    if (getLanguage() == 'EN') {
      return "OTP successful. Please check your email.";
    } else if (getLanguage() == 'AR') {
      return "تم تنفيذ عملية OTP بنجاح. يرجى التحقق من بريدك الإلكتروني.";
    }
  }

  txtFailedPasswordReset() {
    if (getLanguage() == 'EN') {
      return "Failed to request password reset. Please try again.";
    } else if (getLanguage() == 'AR') {
      return "فشل طلب إعادة تعيين كلمة المرور. يرجى المحاولة مرة أخرى.";
    }
  }

  txtValidPhoneNumber() {
    if (getLanguage() == 'EN') {
      return "Please enter a valid phone number";
    } else if (getLanguage() == 'AR') {
      return "الرجاء إدخال رقم هاتف صالح";
    }
  }

  txtEnterOTPCode() {
    if (getLanguage() == 'EN') {
      return "Please enter a OTP Code";
    } else if (getLanguage() == 'AR') {
      return "الرجاء إدخال رمز OTP";
    }
  }

  txtEnterNewPass() {
    if (getLanguage() == 'EN') {
      return "Please enter a new password";
    } else if (getLanguage() == 'AR') {
      return "الرجاء إدخال كلمة مرور جديدة";
    }
  }

  txtEmptySubscription() {
    if (getLanguage() == 'EN') {
      return "You don\'t have any subscription for this course.";
    } else if (getLanguage() == 'AR') {
      return "ليس لديك أي اشتراك لهذه الدورة.";
    }
  }
  txtSubscridsbe() {
    if (getLanguage() == 'EN') {
      return "You don\'t have any subscription for this course.";
    } else if (getLanguage() == 'AR') {
      return "ليس لديك أي اشتراك لهذه الدورة.";
    }
  }

  txtSection() {
    if (getLanguage() == 'EN') {
      return "Section";
    } else if (getLanguage() == 'AR') {
      return "الفصل";
    }
  }

  txtStoragePermission() {
    if (getLanguage() == 'EN') {
      return "Storage permission denied";
    } else if (getLanguage() == 'AR') {
      return "تم رفض إذن التخزين";
    }
  }


}