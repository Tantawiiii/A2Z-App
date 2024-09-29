import 'package:a2z_app/core/helpers/spacing.dart';
import 'package:a2z_app/core/networking/const/api_constants.dart';
import 'package:a2z_app/features/home/bottom_screens/our_teachers_tap/widgets/teacherDetails.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../../core/utils/colors_code.dart';
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
  String _grade = ''; // This will hold the grade value

  @override
  void initState() {
    super.initState();
    widget.searchController.addListener(_filterCategories);
    _initialize();
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

  Future<void> _initialize() async {
    final token = await _getToken();
    if (token != null) {
      final client = _createGraphQLClient(token);
      await _fetchGrade(client);
      await _fetchCategories(client);
    } else {
      print('Token not found');
    }
  }

  Future<String?> _getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('access_token');
    return token;
  }

  GraphQLClient _createGraphQLClient(String token) {
    final HttpLink httpLink = HttpLink(
      ApiConstants.apiBaseUrlGraphQl,
      defaultHeaders: {
        'Authorization': 'Bearer $token',
      },
    );

    return GraphQLClient(
      link: httpLink,
      cache: GraphQLCache(),
    );
  }

  Future<void> _fetchGrade(GraphQLClient client) async {
    const String query = """
      query Me {
        me {
          contact {
            dynamicProperties {
              name
              value
            }
          }
        }
      }
    """;

    final result = await client.query(
      QueryOptions(
        document: gql(query),
      ),
    );

    if (result.hasException) {
      print('Error fetching grade: ${result.exception.toString()}');
      return;
    }

    final dynamicProperties = result.data?['me']?['contact']?['dynamicProperties'];
    if (dynamicProperties != null) {
      for (var prop in dynamicProperties) {
        if (prop['name'] == 'grade') {
          setState(() {
            _grade = prop['value'];
          });
          break;
        }
      }
    }
  }

  Future<void> _fetchCategories(GraphQLClient client) async {
    if (_grade.isEmpty) return; // Ensure the grade is available before fetching categories

    final categories = await _categoriesService.fetchCategories(client, _grade);

    if (!mounted) return;

    setState(() {
      _categories = categories;
      _filterCategories();
    });
  }

  @override
  Widget build(BuildContext context) {
    return _buildGridView();
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
              parentName: category['parentName'] ?? 'Language Parent',
              heroTag: 'category-${category['id']}',
            ),
          ),
        );
      },
      child: SizedBox(
        height: 280.h,
        width: 150,
        child: Card(
          color: ColorsCode.backBottomNav,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Expanded(
                child: Hero(
                  tag: 'category-${category['id']}',
                  child: category['imgSrc'] != null
                      ? Padding(
                    padding: const EdgeInsets.only(top: 4.0),
                    child: Image.network(
                      category['imgSrc'],
                      fit: BoxFit.cover,
                    ),
                  )
                      : Image.asset(
                    ImagesPaths.logoImage,
                    fit: BoxFit.cover,
                    height: 90,
                  ),
                ),
              ),
              verticalSpace(4),
              Text(
                category['name'] ?? 'Teacher Name',
                style: const TextStyle(
                    fontSize: 16, fontWeight: FontWeight.bold),
              ),
              Text('${category['parentName'] ?? 'Language Parent'}'),
              verticalSpace(4),
            ],
          ),
        ),
      ),
    );
  }
}
