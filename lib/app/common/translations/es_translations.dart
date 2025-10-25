import 'package:get/get.dart';
import 'package:recipes_flutter/app/common/translation_keys.dart';

class EsTranslations extends Translations {
  @override
  Map<String, Map<String, String>> get keys => {
    'es_AR': {
      TranslationKeys.nameMinLength:
          'El nombre debe tener al menos @min caracteres',
      TranslationKeys.nameMaxLength:
          'El nombre no puede exceder @max caracteres',

      // common
      TranslationKeys.email: 'Email',
      TranslationKeys.password: 'Contraseña',
      TranslationKeys.login: 'Iniciar sesión',
      TranslationKeys.logout: 'Cerrar sesión',
      TranslationKeys.cancel: 'Cancelar',
      TranslationKeys.save: 'Guardar',
      TranslationKeys.delete: 'Eliminar',
      TranslationKeys.edit: 'Editar',
      TranslationKeys.confirm: 'Confirmar',
      TranslationKeys.tryAgain: 'Intente de nuevo',
      TranslationKeys.list: 'lista',
      '${TranslationKeys.list}_zero': 'listas',
      '${TranslationKeys.list}_one': 'lista',
      '${TranslationKeys.list}_other': 'listas',
      TranslationKeys.onList: 'en lista',
      TranslationKeys.recipe: 'receta',
      '${TranslationKeys.recipe}_zero': 'recetas',
      '${TranslationKeys.recipe}_one': 'receta',
      '${TranslationKeys.recipe}_other': 'recetas',
      TranslationKeys.ingredient: 'ingrediente',
      '${TranslationKeys.ingredient}_zero': 'ingredientes',
      '${TranslationKeys.ingredient}_one': 'ingrediente',
      '${TranslationKeys.ingredient}_other': 'ingredientes',

      // login
      TranslationKeys.loginErrorTitle: 'Error de inicio de sesión',

      // drawer
      TranslationKeys.yourGroups: 'Tus Grupos',
      TranslationKeys.language: 'Idioma',
      TranslationKeys.selectLanguage: 'Seleccionar Idioma',
      TranslationKeys.about: 'Acerca de',
      TranslationKeys.applicationName: 'Felicette Recetas',
      TranslationKeys.applicationDescription:
          'Felicette Recetas es una aplicación de código abierto que te ayuda a gestionar tus recetas y listas de compras.',
      TranslationKeys.developedWith: 'Desarrollado con',
      TranslationKeys.loveAndCats: 'Amor y Gatos',
      TranslationKeys.developedIn: 'en Curitiba, Brasil.',
      TranslationKeys.developedBy: 'Por felicette.dev',
      TranslationKeys.checkoutGithub: 'Visita el proyecto en GitHub: ',
    },
  };
}
