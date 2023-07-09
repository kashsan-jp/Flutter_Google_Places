import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'google_autocomplete_model.dart';
import 'package:uuid/uuid.dart';

//import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'constants.dart';
//import '../.env';

class HomeController extends GetxController {
  //TextEditting controller
  TextEditingController addressSearch = TextEditingController();

  //model
  GoogleAutoCompleteModel? googleAutoCompleteModel;

//uuid
  final uuid = const Uuid();
  String sessionToken = '';

  RxBool isLoading = false.obs;
  RxString selectedAddress = ''.obs;
  RxString selectedAddress1 = ''.obs;

  @override
  void onInit() {
    addressSearch.addListener(() {
      autoCompleteApi();
    });
    super.onInit();
  }

  Future<void> autoCompleteApi() async {
    isLoading.value = true;
    if (sessionToken == '') {
      sessionToken = uuid.v4();
    }

    final url =
        '$BASE_URL?input=${addressSearch.text}&sessionToken=$sessionToken&key=$PLACE_API_KEY&types=address&language=en';

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      isLoading.value = false;
      final data = jsonDecode(response.body.toString());
      if (data['status'] == 'OK') {
        googleAutoCompleteModel = GoogleAutoCompleteModel.fromJson(data);
        debugPrint('BODY -${googleAutoCompleteModel!.toJson()}}');
        //debugPrint('BODY - $data');
      }

      if (data['status'] == 'ZERO_RESULTS') {
        Get.snackbar(
          'Error',
          'Address not found',
          backgroundColor: Colors.red,
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } else {
      throw Exception('Failed to load google place data');
    }
  }

  bool get shouldShowAutoCompleteList {
    return selectedAddress1.value.isNotEmpty &&
        googleAutoCompleteModel?.predictions != [];
  }
}
