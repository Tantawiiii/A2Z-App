import 'package:flutter/material.dart';
import '../../../../../a2z_app.dart';
import '../../../../../core/language/language.dart';
import '../../../../../core/widgets/build_text_form_field.dart';
import '../widgets/our_teatchers_widgets.dart';

class OurTeachersTap extends StatelessWidget {
  final TextEditingController _searchController = TextEditingController();

  OurTeachersTap({super.key});

  @override
  Widget build(BuildContext context) {
    final isArabic = A2ZApp.getLocal(context).languageCode == 'ar';
    return Directionality(
      textDirection: isArabic ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(
        body: Column(
          children: [
            //"Search Our Favorite Teacher .."
            Padding(
              padding: const EdgeInsets.only(top: 40.0, right: 12, left: 12,bottom: 24),
              child: BuildTextFormField(
                controller: _searchController,
                hintText: Language.instance.txtHintSearch(),
              ),
            ),
            Expanded(
              child: OurTeachersTapWidget(searchController: _searchController),
            ),
          ],
        ),
      ),
    );
  }
}
