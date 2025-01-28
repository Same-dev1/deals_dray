import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class HomeController extends GetxController {
  var isLoading = true.obs;
  var products = [].obs;
  var categories = [].obs;
  var banners = [].obs;
  var bannerTwo = [].obs;
  var newArrivals = [].obs;
  var topSellingProducts = [].obs;
  late  int selectedIndex = 0;
  final imageLink = "https://is2-ssl.mzstatic.com/image/thumb/Purple114/v4/b5/60/9b/b5609b14-e928-3f4d-0a34-6ead78a0ada4/source/512x512bb.jpg";

  @override
  void onInit() {
    super.onInit();
    fetchProducts();
  }


  void onItemTapped(int index) {
    selectedIndex = index;
  }

  Future<void> fetchProducts() async {
    try {
      final response = await http.get(
        Uri.parse('http://devapiv4.dealsdray.com/api/v2/user/home/withoutPrice'),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        if (responseData.containsKey('data')) {
          final Map<String, dynamic> data = responseData['data'];
          if (data.containsKey('products')) {
            products.value = data['products'];
          }
          if (data.containsKey('category')) {
            categories.value = data['category'];
          }
          if (data.containsKey('banner_one')) {
            banners.value = data['banner_one'];
          }
          if (data.containsKey('banner_two')) {
            bannerTwo.value = data['banner_two'];
          }

          isLoading(false);
        } else {
          throw Exception('Data key not found in response');
        }
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      isLoading(false);
      Get.snackbar('Error', e.toString());
    }
  }
}