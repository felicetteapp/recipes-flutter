import 'package:equatable/equatable.dart';
import 'package:felicette_recipes/list/list.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:group_repository/group_repository.dart';
import 'package:uuid/uuid.dart';

part 'ingredient_modal_state.dart';

class IngredientModalCubit extends Cubit<IngredientModalState> {
  IngredientModalCubit() : super(const IngredientModalState());

  void loadItem(ListIngredientItem item) {
    if (item.prices.isNotEmpty) {
      emit(state.copyWith(item: item));
      return;
    }
    final itemWithDefaultPrice = item.copyWith(
      prices: [
        FRIngredientPrice(
          quantity: 1,
          unitPrice: 0,
          uuid: const Uuid().v4(),
        ),
      ],
    );
    emit(state.copyWith(item: itemWithDefaultPrice));
  }

  void addPrice() {
    if (state.item == null) return;
    final updatedPrices = List<FRIngredientPrice>.from(state.item!.prices)
      ..add(
        FRIngredientPrice(
          quantity: 1,
          unitPrice: 0,
          uuid: const Uuid().v4(),
        ),
      );
    final updatedItem = state.item!.copyWith(prices: updatedPrices);
    emit(state.copyWith(item: updatedItem));
  }

  void removePrice(FRIngredientPrice price) {
    if (state.item == null) return;
    final updatedPrices = List<FRIngredientPrice>.from(state.item!.prices)
      ..remove(price);
    final updatedItem = state.item!.copyWith(prices: updatedPrices);
    emit(state.copyWith(item: updatedItem));
  }

  void updatePrice(FRIngredientPrice oldPrice, FRIngredientPrice newPrice) {
    if (state.item == null) return;
    final updatedPrices = state.item!.prices.map((price) {
      if (price.uuid == oldPrice.uuid) {
        return newPrice;
      }
      return price;
    }).toList();
    final updatedItem = state.item!.copyWith(prices: updatedPrices);
    emit(state.copyWith(item: updatedItem));
  }
}
