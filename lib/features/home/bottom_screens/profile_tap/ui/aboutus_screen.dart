//
// About Us
//
// Welcome to [Your App Name], your gateway to online education designed to empower learners of all ages. Our platform provides high-quality, interactive learning experiences, offering courses across a wide range of subjects. Whether you're a student looking to enhance your skills, a professional seeking career advancement, or simply someone eager to learn something new, we've got the right course for you.
//
// At [Your App Name], we believe that education should be accessible to everyone, anywhere. Our expert instructors and innovative tools ensure that learning is engaging, flexible, and tailored to your needs.
//
// Join us today and start your journey towards mastering new knowledge and skills, all from the comfort of your home.
//


import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../../../../core/theming/text_style.dart';

class AboutUsScreen extends StatelessWidget {
  const AboutUsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        title: Text(
          'About Us',
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
                "Welcome to The Best Platform, your gateway to online education designed to empower learners of all ages. Our platform provides high-quality, interactive learning experiences, offering courses across a wide range of subjects. Whether you're a student looking to enhance your skills, a professional seeking career advancement, or simply someone eager to learn something new, we've got the right course for you."
                    "At The Best Platform, we believe that education should be accessible to everyone, anywhere. Our expert instructors and innovative tools ensure that learning is engaging, flexible, and tailored to your needs."
                    "Join us today and start your journey towards mastering new knowledge and skills, all from the comfort of your home.",
                style: TextStyle(fontSize: 16.sp, height: 1.5),
              ),
              SizedBox(height: 24.h),
              Text(
                "Meet the Developers",
                style: TextStyle(
                  fontSize: 20.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.blueAccent,
                ),
              ),
              SizedBox(height: 16.h),

              Row(
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundImage: AssetImage('assets/ahmed_tantawy.jpg'), // Add image path or use placeholder
                  ),
                  SizedBox(width: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Ahmed Tantawy",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        "Mobile App Developer",
                        style: TextStyle(fontSize: 16),
                      ),
                      SizedBox(height: 8),
                      Text(
                        "Ahmed is the mobile app developer responsible for bringing our vision to life "
                            "on mobile devices. With expertise in Flutter, Ahmed has built a user-friendly app "
                            "that offers seamless navigation and excellent functionality.",
                        style: TextStyle(fontSize: 14),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 24),

              // Developer 2: Ahmed Elrahawy (Backend Developer)
              Row(
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundImage: AssetImage('assets/ahmed_elrahawy.jpg'), // Add image path or use placeholder
                  ),
                  SizedBox(width: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Ahmed Elrahawy",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        "Backend Developer",
                        style: TextStyle(fontSize: 16),
                      ),
                      SizedBox(height: 8),
                      Text(
                        "Ahmed Elrahawy is the backend developer who ensures that the app's server-side "
                            "components are robust and secure. His skills in managing databases, APIs, and integrations "
                            "enable smooth performance and data management for our app.",
                        style: TextStyle(fontSize: 14),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 24),

              // Mission/Closing Text
              Text(
                "We believe in the power of education to transform lives. Our goal is to make learning accessible "
                    "to everyone, anytime, anywhere.",
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 24),

              // Contact Section (Optional)
              Text(
                "Contact Us",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.blueAccent,
                ),
              ),
              SizedBox(height: 8),
              Text(
                "Email: support@onlineeducation.com",
                style: TextStyle(fontSize: 16),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
