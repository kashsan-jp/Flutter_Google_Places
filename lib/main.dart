import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'google_places/home_controller.dart';
//import 'package:get/get_core/src/get_main.dart';

class GooglePlaces extends StatelessWidget {
  GooglePlaces({super.key});

  final HomeController homeController = Get.put(HomeController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Google Place Autocomplte'),
        backgroundColor: Colors.red,
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              const Center(
                child: Text('Google auto complete address example'),
              ),
              const SizedBox(
                height: 40,
              ),
              Row(children: [
                Icon(Icons.location_on_outlined),
                SizedBox(width: 10),

                Expanded(
                  child: Obx(() => Text(homeController.selectedAddress.value, style: TextStyle(
                    color: Colors.redAccent,
                  ),
                  maxLines: 2,
                  )),
                )
              ],),
              const SizedBox(
                height: 40,
              ),
            TextFormField(
                decoration: const InputDecoration(
                  hintText: 'Address Search',
                ),
                controller: homeController.addressSearch,
                onChanged: (String value) {
                  homeController.selectedAddress1.value = value;
                  //debugPrint(value.toString());
                  debugPrint('value - $value');
                },
              ),
              Obx(() {
                homeController.isLoading.value;
                return homeController.shouldShowAutoCompleteList ?
                  homeController.isLoading.value
                    ? const Center(
                        child: SizedBox(
                          height: 60,
                          width: 60,
                          child: Padding(
                            padding: EdgeInsets.symmetric(
                                vertical: 10, horizontal: 8.0),
                            child: CircularProgressIndicator(
                              strokeWidth: 3,
                            ),
                          ),
                        ),
                      )
                    : ListView.separated(
                        separatorBuilder: ((context, index) => const Divider()),
                        itemCount: homeController
                                    .googleAutoCompleteModel?.predictions !=
                                null
                            ? homeController
                                .googleAutoCompleteModel!.predictions.length
                            : 0,
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemBuilder: (context, index) {
                          return ListTile(
                            onTap: () {
                              homeController.selectedAddress.value =
                                  homeController.googleAutoCompleteModel!
                                      .predictions[index].description;

                              //Clear and Reset
                              homeController.selectedAddress1.value = '';
                              homeController.addressSearch.text = '';

                              debugPrint(
                                  'Clicked! - ${homeController.selectedAddress.value}');
                            },
                            title: Text(
                              homeController.googleAutoCompleteModel!
                                  .predictions[index].description,
                            ),
                            leading: const Icon(Icons.location_on_outlined),
                          );
                        },
                      ) : const SizedBox();
              }),
            ],
          ),
        ),
      ),
    );
  }
}
