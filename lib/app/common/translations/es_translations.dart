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
      TranslationKeys.success: 'Éxito',
      TranslationKeys.tryAgain: 'Intente de nuevo',
      TranslationKeys.list: 'lista',
      '${TranslationKeys.list}_other': 'listas',
      TranslationKeys.onList: 'en lista',
      TranslationKeys.recipe: 'receta',
      '${TranslationKeys.recipe}_other': 'recetas',
      TranslationKeys.ingredient: 'ingrediente',
      '${TranslationKeys.ingredient}_other': 'ingredientes',
      TranslationKeys.showListByIngredients: 'Mostrar lista por ingredientes',
      TranslationKeys.showListByRecipes: 'Mostrar lista por recetas',
      TranslationKeys.showCheckedFirst: 'Mostrar marcados primero',
      TranslationKeys.otherIngredients: 'Otros Ingredientes',
      TranslationKeys.for_: 'para ',

      // home view
      TranslationKeys.unknownView: 'Vista desconocida',
      TranslationKeys.addRecipe: 'Agregar receta',
      TranslationKeys.addIngredient: 'Agregar ingrediente',
      TranslationKeys.selectRecipes: 'Seleccionar recetas',
      TranslationKeys.itemsSelected: '@count seleccionado',
      '${TranslationKeys.itemsSelected}_other': '@count seleccionados',

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

      // budget display
      TranslationKeys.spentOf: ' gastado de ',
      TranslationKeys.available: ' disponible',

      // ingredients
      TranslationKeys.actualIngredients: 'Ingredientes Reales',
      TranslationKeys.actualIngredientsSubtitle:
          'Estos elementos se pueden usar en recetas y agregar a la lista de compras',
      TranslationKeys.nonActualIngredients: 'Ingredientes No Reales',
      TranslationKeys.nonActualIngredientsSubtitle:
          'Estos elementos se pueden agregar a la lista de compras pero no se pueden usar en recetas',
      TranslationKeys.newIngredient: 'Nuevo Ingrediente',
      TranslationKeys.ingredientName: 'Nombre del Ingrediente',
      TranslationKeys.isActualIngredient: 'Es Ingrediente Real',
      TranslationKeys.editIngredient: 'Editar Ingrediente',
      TranslationKeys.confirmDeletion: 'Confirmar Eliminación',
      TranslationKeys.confirmDeletionMessage:
          '¿Estás seguro de que quieres eliminar este ingrediente?',
      TranslationKeys.ingredientUpdatedSuccessfully:
          'Ingrediente actualizado exitosamente',
      TranslationKeys.ingredientDeletedSuccessfully:
          'Ingrediente eliminado exitosamente',
      TranslationKeys.ingredientCreatedSuccessfully:
          'Ingrediente creado exitosamente',
    },
  };
}
