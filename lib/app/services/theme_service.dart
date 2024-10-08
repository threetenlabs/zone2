import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:zone2/app/style/palette.dart';
import 'package:zone2/app/style/theme.dart';

class ThemeService extends GetxService {
  static ThemeService get to => Get.find();
  final box = GetStorage('theme_data');
  final palette = Palette();

  RxBool isDarkMode = false.obs;

  @override
  void onInit() {
    super.onInit();
    isDarkMode.value = box.read('isDarkMode') ?? false;
  }

  void toggleTheme() {
    isDarkMode.value = !isDarkMode.value;
    Get.changeTheme(
      isDarkMode.value ? MaterialTheme.dark() : MaterialTheme.light(),
    );
    box.write('isDarkMode', isDarkMode.value);
  }
}
