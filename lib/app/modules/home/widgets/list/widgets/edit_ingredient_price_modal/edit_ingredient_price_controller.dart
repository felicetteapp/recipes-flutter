import 'package:get/get.dart';
import 'package:felicette_recipes/app/data/models/group_models.dart';
import 'package:felicette_recipes/app/modules/home/widgets/list/list_controller.dart';
import 'package:felicette_recipes/app/services/groups_service.dart';

class EditIngredientPriceModalController extends GetxController {
  final FRGroup group;
  final ListIngredientItem item;
  final GroupsService groupsService = Get.find<GroupsService>();

  final RxBool isLoading = false.obs;
  final RxList<FRIngredientPrice> ingredientPrices = RxList.empty();

  EditIngredientPriceModalController({required this.group, required this.item});

  handleSaveWithoutPrice() async {
    isLoading.value = true;
    await groupsService.removeIngredientPrice(ingredientId: item.ingredient.id);
    isLoading.value = false;
    Get.back(result: []);
  }

  handleSave() async {
    isLoading.value = true;
    await groupsService.updateIngredientPrices(
      ingredientId: item.ingredient.id,
      prices: ingredientPrices,
    );
    isLoading.value = false;
    Get.back(result: ingredientPrices);
  }

  @override
  void onInit() {
    super.onInit();
    ingredientPrices.value = [...item.price];

    if (ingredientPrices.isEmpty) {
      ingredientPrices.add(FRIngredientPrice(quantity: 1, unitPrice: 0.0));
    }
  }
}
