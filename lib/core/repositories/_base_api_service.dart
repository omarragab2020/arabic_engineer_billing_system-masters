import 'dart:async';
import 'dart:io';

import 'package:dart_extensions/dart_extensions.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:neuss_utils/utils/helpers.dart';

import '../../app/controllers/app_controller.dart';
import '../../app/controllers/mixins/users_mixin.dart';
import '../../app/models/api_response.dart';
import '../services/offline_storage.dart';
import '../utils/app_constants.dart';

class BaseApiService extends GetConnect {
  static const String serverUrl = 'https://api.aljalasi-haj.com/';
  static String filesUrl = '${serverUrl}files';
  static String assetsUrl = '${serverUrl}assets';

  @override
  void onInit() {
    // All request will pass to jsonEncode so CasesModel.fromJson()
    httpClient.baseUrl = serverUrl;
    httpClient.defaultContentType = "application/json; charset=UTF-8";
    httpClient.timeout = 30.seconds;

    // It's will attach 'apikey' property on header from all requests
    httpClient.addRequestModifier<dynamic>((request) async {
      if (!(request.method.toUpperCase() == 'POST' && request.url.toString().endsWith('users')) &&
          !request.url.toString().endsWith('auth/login') &&
          !request.url.toString().endsWith('auth/refresh') &&
          OfflineStorage.getAuthToken()?.accessToken != null) {
        request.headers['Authorization'] = "Bearer ${OfflineStorage.getAuthToken()?.accessToken}";
      }
      request.headers['Accept'] = 'application/json';
      return request;
    });

    httpClient.addResponseModifier((request, response) async {
      if (kDebugMode) {
        // getFormatted() {
        //   var data;
        //   if (response.body is Map) {
        //     data = (response.body as Map)['data'];
        //   }
        //   data ??= response.body;
        //   switch (data.runtimeType.toString()) {
        //     case 'Map':
        //       return formatMapStr(data);
        //     case 'List':
        //       return formatListStr(data);
        //     default:
        //       return data.toString();
        //   }
        // }

        // mPrint('Request URL: ${request.method.toUpperCase()}: ${request.url}\n'
        //     'Request Headers: ${request.headers}\n'
        //     'Response status: ${response.statusCode} - ${response.statusText}\n'
        //     'Response Body: ${response.body.toString()}');
      }

      if (response.hasError) {
        if (response.status.isUnauthorized) {
          if (response.body is Map && (response.body as Map)['errors'] != null) {
            var errors = (response.body as Map)['errors'];

            if (errors is List && !errors.isEmptyOrNull) {
              mPrintError('isUnauthorized: ${errors[0]['message']}');
              if (errors[0]['message'].toString().contains('Token expired')) {
                if (!request.url.toString().endsWith('auth/login')) {
                  await UsersMixin.refreshTokenBG();
                }
              }
            }
          }
          // OfflineStorage.eraseToken();
          // AppController.to.refreshToken();
          // mPrintError('isUnauthorized');
        }
        mPrintError('Error: (${request.method.toUpperCase()}: ${request.url}) : ${response.statusCode} - ${response.statusText}');
      }
      return response;
    });

    //Authenticator will be called 2   times if HttpStatus is HttpStatus.unauthorized
    httpClient.maxAuthRetries = 3;
    super.onInit();
  }

  Future<ApiResponse> getDataFromUrl(String url) async {
    ApiResponse apiResponse = ApiResponse.failed();
    try {
      Response response = await GetHttpClient().get(url);
      apiResponse = ApiResponse.fromResponse(response);
      apiResponse.print('getDataFromUrl - ($url)');
      if (apiResponse.errors != null) {
        mPrintError('Error: ${apiResponse.statusText}');
      }
    } catch (e) {
      mPrintError(e);
    }
    return apiResponse;
  }

  Future<ApiResponse> getData(String url, {bool printData = true}) async {
    ApiResponse apiResponse = ApiResponse.failed();
    try {
      Response response = await get(url);
      apiResponse = ApiResponse.fromResponse(response);
      if (printData) apiResponse.print('GET - $serverUrl$url');
      if (apiResponse.errors != null) {
        mPrintError('Error: ${apiResponse.statusText!}');
      }
    } catch (e) {
      mPrintError(e.toString());
    }
    return apiResponse;
  }

  Future<ApiResponse> postData(String url, dynamic bodyJson, {bool printData = true}) async {
    ApiResponse apiResponse = ApiResponse.failed();
    try {
      Response response = await post(url, bodyJson);
      apiResponse = ApiResponse.fromResponse(response);
      apiResponse.print('POST - $serverUrl$url ? body:($bodyJson)');
      if (apiResponse.errors != null) {
        mPrintError('Error: ${apiResponse.statusText!}');
      }
    } catch (e) {
      mPrintError(e.toString());
    }
    return apiResponse;
  }

  Future<ApiResponse> patchData(String url, String bodyJson, {bool printData = true}) async {
    ApiResponse apiResponse = ApiResponse.failed();
    try {
      Response response = await patch(url, bodyJson);
      apiResponse = ApiResponse.fromResponse(response);
      if (printData) apiResponse.print('PATCH - $serverUrl$url ? body:($bodyJson)');
      if (apiResponse.errors != null) {
        mPrintError('Error: ${apiResponse.statusText!}');
      }
    } catch (e) {
      mPrintError(e.toString());
    }
    return apiResponse;
  }

  Future<ApiResponse> deleteData(String url, {Map<String, dynamic>? query, bool printData = true}) async {
    ApiResponse apiResponse = ApiResponse.failed();
    try {
      Response response = await delete(url, query: query);
      apiResponse = ApiResponse.fromResponse(response);
      if (printData) apiResponse.print('DELETE - $serverUrl$url');
      if (apiResponse.errors != null) {
        mPrintError('Error: ${apiResponse.statusText!}');
      }
    } catch (e) {
      mPrintError(e.toString());
    }
    return apiResponse;
  }

  Future<String?> uploadImage(File file, {String type = 'Avatar'}) async {
    mPrint('uploadAbuZeitImage is called');
    mPrint('File path = ${file.path}');
    String fileName = file.path.split('/').last;
    String imageType = fileName.split('.').last;
    fileName = '${AppConstants.appUploadCenter}_${AppController.to.mUser?.phone}_$type';

    // mPrint('uploadImage Type = ${MediaType('image', imageType).type}');
    final FormData formData = FormData({
      'file1': MultipartFile(file, filename: fileName, contentType: 'image/$imageType'),
      // 'file1': MultipartFile(file, filename: fileName, contentType: MediaType('image', imageType).type),
      'title': fileName,
    });

    ApiResponse apiResponse = await postData("files", formData);
    if (apiResponse.success) {
      String id = apiResponse.data['id'].toString();
      mPrint("Uploaded!, id = $id");
      return id;
    }
    return null;
  }
}
