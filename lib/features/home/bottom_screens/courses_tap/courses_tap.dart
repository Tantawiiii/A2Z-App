import 'package:a2z_app/core/helpers/spacing.dart';
import 'package:a2z_app/core/networking/const/api_constants.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';
import '../../../../core/utils/StringsTexts.dart';
import '../../../../core/utils/images_paths.dart';
import '../../widgets/build_empty_courses.dart';

class CoursesTap extends StatefulWidget {
  const CoursesTap({Key? key}) : super(key: key);

  @override
  _CoursesTapState createState() => _CoursesTapState();
}

class _CoursesTapState extends State<CoursesTap> {
  final Dio _dio = Dio();
  List<String> _courseIds = [];
  List _products = [];
  bool _isLoading = true;
  static const String _accessTokenKey = 'access_token';

  @override
  void initState() {
    super.initState();
    _fetchSubscribedCourses();
  }

  Future<String?> getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final token = prefs.getString(_accessTokenKey);
    if (token != null) {
      print('Retrieved token: Success');
    } else {
      print('Token retrieval failed');
    }
    return token;
  }

  Future<void> _fetchSubscribedCourses() async {
    final token = await getToken();
    if (token == null) {
      setState(() {
        _isLoading = false;
      });
      print('No token found');
      return;
    }

    try {
      final response = await _dio.get(
        'http://centera2z.com/api/Subscriptions/GetStudentSubscribedCourses',
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
            'Content-Type': 'application/json',
          },
        ),
      );

      if (response.statusCode == 200) {
        final data = response.data;
        setState(() {
          _courseIds = List<String>.from(data['data']['data']);
        });
        _fetchProducts();
        print('data: ${response.data}');
      } else {
        setState(() {
          _isLoading = false;
        });
        print('Failed to load courses');
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      print('Error fetching courses: $e');
    }
  }

  Future<void> _fetchProducts() async {
    final String productsQuery = """
    query Products(\$productIds: [String!]) {
      products(storeId: "A2Z", productIds: \$productIds) {
        items {
          id
          productType
          name
          imgSrc
           category {
          id
          name
        }
        }
      }
    }
  """;

    final HttpLink httpLink = HttpLink(ApiConstants.apiBaseUrlGraphQl);

    final GraphQLClient client = GraphQLClient(
      cache: GraphQLCache(),
      link: httpLink,
    );

    final QueryOptions options = QueryOptions(
      document: gql(productsQuery),
      variables: {
        'productIds': _courseIds,
      },
    );

    final QueryResult result = await client.query(options);

    if (result.hasException) {
      print('Error fetching products: ${result.exception.toString()}');
    } else {
      setState(() {
        _products = result.data?['products']['items'] ?? [];
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: _isLoading
          ? Shimmer.fromColors(
              baseColor: Colors.grey[300]!,
              highlightColor: Colors.blue[200]!,
              child: ListView.builder(
                itemCount: 6,
                // Adjust the number based on how many shimmer items you want
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: ListTile(
                      leading: Container(
                        width: 50.0,
                        height: 50.0,
                        color: Colors.white,
                      ),
                      title: Container(
                        width: double.infinity,
                        height: 16.0,
                        color: Colors.white,
                      ),
                      subtitle: Container(
                        width: double.infinity,
                        height: 14.0,
                        color: Colors.white,
                      ),
                    ),
                  );
                },
              ),
            )
          : _products.isEmpty
              ? const BuildEmptyCourses(txtNot: StringTextsNames.txtNoCourses)
              : ListView.builder(
                  itemCount: _products.length,
                  itemBuilder: (context, index) {
                    final product = _products[index];
                    // Handle null values by providing default text or image
                    //  final imgSrc = product['imgSrc'] ?? 'https://via.placeholder.com/150';
                    final name = product['name'] ?? 'Unknown Product';
                    final categoryName = product['category']?['name'] ?? 'Unknown Category';

                    return Padding(
                      padding:
                          EdgeInsets.only(top: 10.h, right: 14.h, left: 14.h),
                      child: Card(
                        elevation: 1.5,
                        shadowColor: Colors.cyan,
                        child: Row(
                          children: [
                            product['imgSrc'] != null
                                ? Image.network(
                                    product['imgSrc'],
                                    fit: BoxFit.cover,
                                    width: 120,
                                    height: 100,
                                  )
                                : SvgPicture.asset(
                                    ImagesPaths.logoImage,
                                    height: 90.h,
                                    width: 60.w,
                                    fit: BoxFit.cover,
                                  ),
                            horizontalSpace(8),
                            Column(
                              children: [
                                Text(name),
                                Text(categoryName),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}
