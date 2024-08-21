import 'package:a2z_app/core/helpers/spacing.dart';
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
      builder: (QueryResult result,
          {VoidCallback? refetch, FetchMore? fetchMore}) {
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
        childAspectRatio: 2 / 2,
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
    return SizedBox(
      height: 200,
      width: 150,
      child: Card(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            category['imgSrc'] != null
                ? Padding(
                    padding: const EdgeInsets.only(top: 4.0),
                    child: Image.network(
                      category['imgSrc'],
                      height: 100.h,
                      width: 140.w,
                      fit: BoxFit.cover,
                    ),
                  )
                : SvgPicture.asset(
                    ImagesPaths.logoImage,
                    height: 110.h,
                    width: 90.w,
                  ),
            verticalSpace(4),
            Text(
              category['name'] ?? 'Unknown Category',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            Text('${category['parent']?['name'] ?? 'Unknown Parent'}'),
          ],
        ),
      ),
    );
  }
}