import 'package:a2z_app/core/helpers/spacing.dart';
import 'package:a2z_app/features/home/bottom_screens/our_teachers_tap/widgets/teacherDetails.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import '../../../../../core/utils/images_paths.dart';
import '../service/categoris_teachers_servise.dart';

class OurTeachersTapWidget extends StatefulWidget {
  final TextEditingController searchController;

  OurTeachersTapWidget({required this.searchController});

  @override
  _OurTeachersTapWidgetState createState() => _OurTeachersTapWidgetState();
}

class _OurTeachersTapWidgetState extends State<OurTeachersTapWidget> {
  final CategoriesService _categoriesService = CategoriesService();
  List<Map<String, dynamic>> _categories = [];
  List<Map<String, dynamic>> _filteredCategories = [];

  @override
  void initState() {
    super.initState();
    widget.searchController.addListener(_filterCategories);
  }

  @override
  void dispose() {
    widget.searchController.removeListener(_filterCategories);
    super.dispose();
  }

  void _filterCategories() {
    setState(() {
      if (widget.searchController.text.isEmpty) {
        _filteredCategories = _categories;
      } else {
        _filteredCategories = _categories
            .where((category) =>
        category['name']
            ?.toLowerCase()
            ?.contains(widget.searchController.text.toLowerCase()) ??
            false)
            .toList();
      }
    });
  }

  Future<void> _fetchCategories(GraphQLClient client) async {
    final categories = await _categoriesService.fetchCategories(client);
    if (_categories != categories) {
      setState(() {
        _categories = categories;
        _filterCategories();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Query(
      options: QueryOptions(document: gql(_categoriesService.query)),
      builder: (QueryResult result, {VoidCallback? refetch, FetchMore? fetchMore}) {
        if (result.hasException) {
          return Text(result.exception.toString());
        }

        if (result.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        // Fetch and process categories by passing the client directly
        _fetchCategories(GraphQLProvider.of(context).value);

        return _buildGridView();
      },
    );
  }

  Widget _buildGridView() {
    return GridView.builder(
      padding: const EdgeInsets.all(8.0),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 2 / 2.4,
        mainAxisSpacing: 8.0,
        crossAxisSpacing: 8.0,
      ),
      itemCount: _filteredCategories.length,
      itemBuilder: (context, index) {
        final category = _filteredCategories[index];
        return _buildCategoryCard(category);
      },
    );
  }

  Widget _buildCategoryCard(Map<String, dynamic> category) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CategoryDetailsScreen(
              categoryName: category['name'] ?? 'Unknown Category',
              categoryId: category['id'] ?? '',
              imageSrc: category['imgSrc'],
              parentName: category['parent']?['name'] ?? 'Language Parent',
              heroTag: 'category-${category['id']}',
            ),
          ),
        );
      },
      child: SizedBox(
        height: 280.h,
        width: 150,
        child: Card(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Expanded(
                child: Hero(
                  tag: 'category-${category['id']}', // Hero tag should be unique
                  child: category['imgSrc'] != null
                      ? Padding(
                    padding: const EdgeInsets.only(top: 4.0),
                    child: Image.network(
                      category['imgSrc'],
                      fit: BoxFit.cover,
                    ),
                  )
                      : SvgPicture.asset(
                    ImagesPaths.logoImage,
                    fit: BoxFit.cover,
                    height: 90,
                  ),
                ),
              ),
              verticalSpace(4),
              Text(
                category['name'] ?? 'Teacher Name',
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
              Text('${category['parent']?['name'] ?? 'Language Parent'}'),
              verticalSpace(4),
            ],
          ),
        ),
      ),
    );
  }

}
