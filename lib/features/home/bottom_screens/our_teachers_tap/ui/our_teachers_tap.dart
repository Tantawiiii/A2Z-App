import 'package:flutter/material.dart';
import '../../../../../core/utils/StringsTexts.dart';
import '../../../../../core/widgets/build_text_form_field.dart';
import '../widgets/our_teatchers_widgets.dart';

class OurTeachersTap extends StatelessWidget {
  final TextEditingController _searchController = TextEditingController();

  OurTeachersTap({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          //"Search Our Favorite Teacher .."
          Padding(
            padding: const EdgeInsets.only(top: 40.0, right: 12, left: 12,bottom: 24),
            child: BuildTextFormField(
              controller: _searchController,
              hintText: StringTextsNames.txtHintSearch,
            ),
          ),
          Expanded(
            child: OurTeachersTapWidget(searchController: _searchController),
          ),
        ],
      ),
    );
  }
}
