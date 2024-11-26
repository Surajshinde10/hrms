import 'dart:convert';
import 'dart:developer';

import 'package:get/get.dart';
import 'package:FaceAxis/routes/app_routes.dart';
import 'package:FaceAxis/utilities/variable_utilities.dart';
import 'package:http/http.dart' as http;

enum APIType { tPost, tGet, tPut, tDelete }

class API {
  static Future<dynamic> callAPI({
    required String url,
    required APIType type,
    isListBody = false,
    Map<String, dynamic>? body,
    List<Map<String, dynamic>>? listBody,
    Map<String, String>? header,
  }) async {
    print("URL==>>${url}");

    try {
      http.Response apiResponse;

      dynamic apiBody = (isListBody)?listBody:body;

      Map<String, String> appHeader = {
        "content-type": "application/json",
      };
      log("REQ BODY===>>>>${jsonEncode(apiBody)}");

      /// if there are any other header for different kind of apis then attach
      /// dynamically passed parameters.
      if (header != null) {
        appHeader.addAll(header);
        print("Header===>>>>${appHeader}");
      }

      /// [POST CALL]

      if (type == APIType.tPost) {
        assert(body != null);
        apiResponse = await http.post(
          Uri.parse(url),
          body: jsonEncode(apiBody),
          headers: appHeader,
        );
      } else if (type == APIType.tGet) {
        apiResponse = await http.get(
          Uri.parse(url),
          headers: appHeader,
        );
      } else if (type == APIType.tPut) {
        apiResponse = await http.put(
          Uri.parse(url),
          body: jsonEncode(apiBody),
          headers: appHeader,
        );
      } else {
        apiResponse = await http.delete(
          Uri.parse(url),
          body: jsonEncode(apiBody),
          headers: appHeader,
        );
      }

      print("STATUS CODE===>>>>>${apiResponse.statusCode}");
      print("APIBODY===>>>>>${apiResponse.body}");

      switch (apiResponse.statusCode) {
        case 200:
          dynamic response = jsonDecode(apiResponse.body);
          if (response["success"] == true) {
            if (response["data"] == null) {
              return response;
            } else {
              return response["data"];
            }
          } else if(response["status"] == true) {
              return response;

          } else{
            return "error_${response["message"]}";
          }
        case 201:
          Map<String, dynamic> response = jsonDecode(apiResponse.body);
          if (response["success"] == true) {
            return response["data"];
          } else {
            return "error_${response["message"]}";
          }
        case 500:
          Map<String, dynamic> response = jsonDecode(apiResponse.body);
          return "error_${response["message"]}";
        case 404:
          Map<String, dynamic> response = jsonDecode(apiResponse.body);
          return "error_${response["message"]}";
        case 406:
          Map<String, dynamic> response = jsonDecode(apiResponse.body);
          return "error_${response["message"]}";
        case 400:
          Map<String, dynamic> response = jsonDecode(apiResponse.body);
          return "error_${response["message"]}";
        case 401:
          await VariableUtilities.storage.erase();
          Get.offAllNamed(Routes.splash);
          return null;
        default:
          return null;
      }
    } catch (e) {
      print("ERR===>>>>${e}");
      return null;
    }
  }
}
