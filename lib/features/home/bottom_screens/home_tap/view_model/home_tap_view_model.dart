import 'package:a2z_app/core/networking/const/api_constants.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import '../../../../../core/networking/clients/dio_client_graphql.dart';
import '../../profile_tap/services/graphql_getprofile_service.dart';

class HomeTapViewModel {
  final GetProfileGraphQLService _graphQLService;
  Map<String, dynamic>? profileData;
  List<String> banners = [];

  HomeTapViewModel()
      : _graphQLService = GetProfileGraphQLService(DioClientGraphql());

  Future<void> loadData(BuildContext context) async {
    await Future.wait([
      _fetchProfile(context),
      _fetchBanners(),
    ]);
  }

  Future<void> _fetchProfile(BuildContext context) async {
    try {
      final data = await _graphQLService.fetchProfile(context);
      profileData = data?['me'];
    } catch (e) {
      print('Failed to load profile: $e');
    }
  }

  Future<void> _fetchBanners() async {
    try {
      final dio = Dio();
      final response = await dio.post(
        ApiConstants.apiGetBanners,
        queryParameters: {'BannarArea': 'Home'},
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        banners = data.cast<String>();
      } else {
        print('Failed to load banners, status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error occurred while fetching banners: $e');
    }
  }
}
