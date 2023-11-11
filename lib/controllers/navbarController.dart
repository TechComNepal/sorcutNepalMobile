import 'package:get/get.dart';

class NavBarController extends GetxController {
  var scrollY = 0.obs;
  int scrollYValue = 0;

  var isLoading = true.obs;

  updateScrollY(int y) {
    scrollYValue = y;
    scrollY(y);
    //  update();
  }

  updateIsLoading(bool status) {
    isLoading(false);
    update();
  }

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    // isLoading(true);
  }
}
