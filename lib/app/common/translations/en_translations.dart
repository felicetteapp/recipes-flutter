import 'package:get/get.dart';
import 'package:felicette_recipes/app/common/translation_keys.dart';

class EnTranslations extends Translations {
  @override
  Map<String, Map<String, String>> get keys => {
    'en_US': {
      TranslationKeys.nameMinLength: 'Name must be at least @min characters',
      TranslationKeys.nameMaxLength: 'Name cannot exceed @max characters',

      // common
      TranslationKeys.email: 'Email',
      TranslationKeys.password: 'Password',
      TranslationKeys.login: 'Login',
      TranslationKeys.logout: 'Logout',
      TranslationKeys.cancel: 'Cancel',
      TranslationKeys.save: 'Save',
      TranslationKeys.delete: 'Delete',
      TranslationKeys.edit: 'Edit',
      TranslationKeys.confirm: 'Confirm',
      TranslationKeys.success: 'Success',
      TranslationKeys.tryAgain: 'Try Again',
      TranslationKeys.list: 'list',
      '${TranslationKeys.list}_other': 'lists',
      TranslationKeys.onList: 'on list',
      TranslationKeys.recipe: 'recipe',
      '${TranslationKeys.recipe}_other': 'recipes',
      TranslationKeys.ingredient: 'ingredient',
      '${TranslationKeys.ingredient}_other': 'ingredients',
      TranslationKeys.showListByIngredients: 'Show list by ingredients',
      TranslationKeys.showListByRecipes: 'Show list by recipes',
      TranslationKeys.showCheckedFirst: 'Show checked first',
      TranslationKeys.showBudget: 'Show budget',
      TranslationKeys.otherIngredients: 'Other Ingredients',
      TranslationKeys.for_: 'for ',
      TranslationKeys.budget: 'Budget',
      TranslationKeys.no: 'No',
      TranslationKeys.yes: 'Yes',
      TranslationKeys.more: 'More',
      TranslationKeys.ok: 'OK',

      // home view
      TranslationKeys.unknownView: 'Unknown View',
      TranslationKeys.addRecipe: 'Add Recipe',
      TranslationKeys.addIngredient: 'Add Ingredient',
      TranslationKeys.selectRecipes: 'Select recipes',
      TranslationKeys.itemsSelected: '@count selected',
      '${TranslationKeys.itemsSelected}_other': '@count selected',

      // login
      TranslationKeys.loginErrorTitle: 'Login failed',

      // drawer
      TranslationKeys.yourGroups: 'Your Groups',
      TranslationKeys.language: 'Language',
      TranslationKeys.selectLanguage: 'Select Language',
      TranslationKeys.about: 'About',
      TranslationKeys.applicationName: 'Felicette Recipes',
      TranslationKeys.applicationDescription:
          'Felicette Recipes is an open-source application to help you manage your recipes and shopping lists.',
      TranslationKeys.developedWith: 'Developed with',
      TranslationKeys.loveAndCats: 'Love and Cats',
      TranslationKeys.developedIn: 'in Curitiba, Brazil.',
      TranslationKeys.developedBy: 'By felicette.dev',
      TranslationKeys.checkoutGithub: 'Check out the project on GitHub: ',

      // budget display
      TranslationKeys.spentOf: ' spent of ',
      TranslationKeys.available: ' available',

      // ingredients
      TranslationKeys.actualIngredients: 'Actual Ingredients',
      TranslationKeys.actualIngredientsSubtitle:
          'These items can be used in recipes and added to the shopping list',
      TranslationKeys.nonActualIngredients: 'Non-Actual Ingredients',
      TranslationKeys.nonActualIngredientsSubtitle:
          'This items can be added to the sopping list but can\'t be used in recipes',
      TranslationKeys.newIngredient: 'New Ingredient',
      TranslationKeys.ingredientName: 'Ingredient Name',
      TranslationKeys.isActualIngredient: 'Is Actual Ingredient',
      TranslationKeys.editIngredient: 'Edit Ingredient',
      TranslationKeys.confirmDeletion: 'Confirm Deletion',
      TranslationKeys.confirmDeletionMessage:
          'Are you sure you want to delete this ingredient?',
      TranslationKeys.ingredientUpdatedSuccessfully:
          'Ingredient updated successfully',
      TranslationKeys.ingredientDeletedSuccessfully:
          'Ingredient deleted successfully',
      TranslationKeys.ingredientCreatedSuccessfully:
          'Ingredient created successfully',
      TranslationKeys.confirmActualIngredientDescription:
          'Is "@ingredientName" an actual ingredient that can be used in recipes?',
      TranslationKeys.confirmActualIngredient: 'Confirm Actual Ingredient',

      // recipes
      TranslationKeys.editRecipe: 'Edit Recipe',
      TranslationKeys.createRecipe: 'Create Recipe',
      TranslationKeys.recipeName: 'Recipe Name',
      TranslationKeys.selectIngredients: 'Select Ingredients',
      TranslationKeys.chooseIngredientsText:
          'Choose the ingredients needed for the recipe. Quantities can be entered below.',
      TranslationKeys.optionalQuantitiesText:
          'Optionally, enter the quantities of the ingredients below.',
      TranslationKeys.quantitiesShoppingListText:
          'The quantities will appear in the shopping list when the recipe is selected.',
      TranslationKeys.quantityFor: 'Quantity for @ingredient',

      // select modal
      TranslationKeys.search: 'Search',
      TranslationKeys.create: 'Create',
      TranslationKeys.done: 'Done',

      // edit list
      TranslationKeys.editList: 'Edit List',
      TranslationKeys.selectCurrency: 'Select Currency',

      // currencies
      TranslationKeys.currencyUSD: 'US Dollar',
      TranslationKeys.currencyEUR: 'Euro',
      TranslationKeys.currencyGBP: 'British Pound',
      TranslationKeys.currencyJPY: 'Japanese Yen',
      TranslationKeys.currencyCNY: 'Chinese Yuan',
      TranslationKeys.currencyBRL: 'Brazilian Real',
      TranslationKeys.currencyARS: 'Argentine Peso',

      // validation messages
      TranslationKeys.pleaseEnterValidNumber: 'Please enter a valid number',
      TranslationKeys.budgetMustBePositive: 'Budget must be a positive number',

      // error messages
      TranslationKeys.error: 'Error',
      TranslationKeys.noGroupSelected: 'No group selected',
      TranslationKeys.listDetailsUpdatedSuccessfully:
          'List details updated successfully',
      TranslationKeys.failedToUpdateListDetails:
          'Failed to update list details: @error',

      // edit ingredient price
      TranslationKeys.quantity: 'Quantity',
      TranslationKeys.unitPrice: 'Unit Price',
      TranslationKeys.addPrice: 'Add Price',
      TranslationKeys.enterQuantity: 'Enter Quantity',
      TranslationKeys.saveWithoutPrice: 'Save Without Price',
      TranslationKeys.actualIngredientTitle: 'Actual Ingredient',
      TranslationKeys.actualIngredientContent:
          'Is this an actual ingredient that can be used in recipes?',
    },
  };
}
