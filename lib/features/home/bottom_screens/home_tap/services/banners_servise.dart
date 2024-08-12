import 'package:a2z_app/core/networking/const/api_constants.dart';
import 'package:dio/dio.dart';

class BannerService {
  final Dio _dio;

  BannerService(this._dio);

  Future<List<String>> fetchBanners() async {

    final String url = ApiConstants.apiGetBanners;

    try {
      // Ensure GET method is used
      final response = await _dio.get(
        url,
      );

      if (response.statusCode == 200) {
        final List banners = response.data['result'];
        return banners.map<String>((banner) => banner['imageUrl']).toList();
      } else {
        throw Exception('Failed to load banners');
      }
    } catch (e) {
      throw Exception('Failed to load banners: $e');
    }
  }
}
