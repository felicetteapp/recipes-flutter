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
      TranslationKeys.loading: 'Loading',
      TranslationKeys.theme: 'Theme',
      TranslationKeys.darkMode: 'Dark Mode',
      TranslationKeys.lightMode: 'Light Mode',
      TranslationKeys.myFirstGroup: 'My First Group',

      // validation
      TranslationKeys.inputRequiredError: 'This field is required',
      TranslationKeys.invalidEmailError: 'Please enter a valid email address',
      TranslationKeys.emailIsRequiredError: 'Email is required',

      // home view
      TranslationKeys.unknownView: 'Unknown View',
      TranslationKeys.addRecipe: 'Add Recipe',
      TranslationKeys.addIngredient: 'Add Ingredient',
      TranslationKeys.selectRecipes: 'Select recipes',
      TranslationKeys.itemsSelected: '@count selected',
      '${TranslationKeys.itemsSelected}_other': '@count selected',
      TranslationKeys.noGroupsCreated: 'No groups created',

      // login
      TranslationKeys.loginErrorTitle: 'Login failed',
      TranslationKeys.forgotPassword: 'Forgot Password?',
      TranslationKeys.alreadyHaveAccount: 'Already have an account?',
      TranslationKeys.resetPassword: 'Reset Password',
      TranslationKeys.resetPasswordSuccess:
          'Password reset email sent! Please check your inbox.',
      TranslationKeys.resetPasswordError: 'Failed to send password reset email',
      TranslationKeys.createAccount: 'Create Account',
      TranslationKeys.confirmPassword: 'Confirm Password',
      TranslationKeys.passwordsDoNotMatchError: 'Passwords do not match',
      TranslationKeys.createAccountErrorTitle: 'Failed to create account',
      TranslationKeys.createAccountSuccess: 'Account created successfully!',
      TranslationKeys.loginWithoutPassword: 'Login without password',
      TranslationKeys.loginWithoutPasswordSuccessMessage:
          'Login link sent! Please check your email.',

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
      TranslationKeys.noIngredientsCreated: 'No ingredients created',
      TranslationKeys.noIngredientsCreatedDescription:
          'Create your first ingredient to get started with recipes and shopping lists.',

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
      TranslationKeys.noRecipesCreated: 'No recipes created',
      TranslationKeys.noRecipesCreatedDescription:
          'Create your first recipe to organize your cooking and generate shopping lists.',

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

      // create group
      TranslationKeys.createGroup: 'Create Group',
      TranslationKeys.editGroup: 'Edit Group',
      TranslationKeys.groupName: 'Group Name',
      TranslationKeys.groupUpdated: 'Group updated successfully',
      TranslationKeys.deleteGroup: 'Delete Group',
      TranslationKeys.deleteGroupMessage:
          'Are you sure you want to delete this group? This action cannot be undone.',
      TranslationKeys.groupDeleted: 'Group deleted successfully',
      TranslationKeys.groupCreationLimitReached:
          'You have reached the maximum number of groups allowed.',
    },
  };
}
