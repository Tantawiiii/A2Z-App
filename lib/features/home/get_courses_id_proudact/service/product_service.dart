import 'package:a2z_app/core/networking/const/api_constants.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProductService {
  static const String _accessTokenKey = 'access_token';

  static Future<List<dynamic>> fetchProducts(String categoryId) async {
    final dio = Dio();
    final response = await dio.post(
      ApiConstants.apiBaseUrlGraphQl,
      data: {
        'query': '''
        query Products {
          products(
            storeId: "A2Z"
            filter: "category.subtree:912b6897-e648-4a97-ae94-f4e7f7097958/$categoryId"
          ) {
            items {
              id
              name
              imgSrc
               category {
          id
          name
        }
            }
          }
        }
        '''
      },
    );

    if (response.statusCode == 200) {
      return response.data['data']['products']['items'];
    } else {
      throw Exception('Failed to load products');
    }
  }

  static Future<bool> checkSubscription(String productId) async {
    final token = await _getToken();

    if (token == null) {
      throw Exception('No token found');
    }

    final dio = Dio();
    dio.options.headers['Authorization'] = 'Bearer $token';

    final response = await dio.post(
      ApiConstants.apiCheckStudentSubscription,
      queryParameters: {'CourseId': productId},
    );

    print('Student Subscription: ${response.data}');

    return response.data['success'] == true;
  }

  static Future<String?> _getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(_accessTokenKey);
  }
}
