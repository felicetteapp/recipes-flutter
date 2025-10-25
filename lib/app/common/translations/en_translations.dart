import 'package:get/get.dart';
import 'package:recipes_flutter/app/common/translation_keys.dart';

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
      TranslationKeys.tryAgain: 'Try Again',

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
    },
  };
}
