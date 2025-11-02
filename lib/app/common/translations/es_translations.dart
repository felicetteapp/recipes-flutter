import 'package:get/get.dart';
import 'package:felicette_recipes/app/common/translation_keys.dart';

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
      TranslationKeys.showBudget: 'Mostrar presupuesto',
      TranslationKeys.otherIngredients: 'Otros Ingredientes',
      TranslationKeys.for_: 'para ',
      TranslationKeys.budget: 'Presupuesto',
      TranslationKeys.no: 'No',
      TranslationKeys.yes: 'Sí',
      TranslationKeys.more: 'Más',
      TranslationKeys.ok: 'OK',
      TranslationKeys.loading: 'Cargando',
      TranslationKeys.theme: 'Tema',
      TranslationKeys.darkMode: 'Modo Oscuro',
      TranslationKeys.lightMode: 'Modo Claro',

      // validation
      TranslationKeys.inputRequiredError: 'Este campo es obligatorio',
      TranslationKeys.invalidEmailError:
          'Por favor ingrese una dirección de correo válida',

      // home view
      TranslationKeys.unknownView: 'Vista desconocida',
      TranslationKeys.addRecipe: 'Agregar receta',
      TranslationKeys.addIngredient: 'Agregar ingrediente',
      TranslationKeys.selectRecipes: 'Seleccionar recetas',
      TranslationKeys.itemsSelected: '@count seleccionado',
      '${TranslationKeys.itemsSelected}_other': '@count seleccionados',

      // login
      TranslationKeys.loginErrorTitle: 'Error de inicio de sesión',
      TranslationKeys.forgotPassword: '¿Olvidaste tu contraseña?',
      TranslationKeys.alreadyHaveAccount: '¿Ya tienes una cuenta?',
      TranslationKeys.resetPassword: 'Restablecer Contraseña',
      TranslationKeys.resetPasswordSuccess:
          '¡Correo de restablecimiento de contraseña enviado! Por favor revisa tu bandeja de entrada.',
      TranslationKeys.resetPasswordError:
          'Error al enviar correo de restablecimiento de contraseña',
      TranslationKeys.createAccount: 'Crear Cuenta',
      TranslationKeys.confirmPassword: 'Confirmar Contraseña',
      TranslationKeys.passwordsDoNotMatchError: 'Las contraseñas no coinciden',
      TranslationKeys.createAccountErrorTitle: 'Error al crear cuenta',
      TranslationKeys.createAccountSuccess: '¡Cuenta creada exitosamente!',
      TranslationKeys.loginWithoutPassword: 'Iniciar sesión sin contraseña',

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
      TranslationKeys.confirmActualIngredientDescription:
          '¿Es "@ingredientName" un ingrediente real que se puede usar en recetas?',
      TranslationKeys.confirmActualIngredient: 'Confirmar Ingrediente Real',

      // recipes
      TranslationKeys.editRecipe: 'Editar Receta',
      TranslationKeys.createRecipe: 'Crear Receta',
      TranslationKeys.recipeName: 'Nombre de la Receta',
      TranslationKeys.selectIngredients: 'Seleccionar Ingredientes',
      TranslationKeys.chooseIngredientsText:
          'Elige los ingredientes necesarios para la receta. Las cantidades se pueden ingresar abajo.',
      TranslationKeys.optionalQuantitiesText:
          'Opcionalmente, ingresa las cantidades de los ingredientes abajo.',
      TranslationKeys.quantitiesShoppingListText:
          'Las cantidades aparecerán en la lista de compras cuando la receta esté seleccionada.',
      TranslationKeys.quantityFor: 'Cantidad para @ingredient',

      // select modal
      TranslationKeys.search: 'Buscar',
      TranslationKeys.create: 'Crear',
      TranslationKeys.done: 'Listo',

      // edit list
      TranslationKeys.editList: 'Editar Lista',
      TranslationKeys.selectCurrency: 'Seleccionar Moneda',

      // currencies
      TranslationKeys.currencyUSD: 'Dólar Estadounidense',
      TranslationKeys.currencyEUR: 'Euro',
      TranslationKeys.currencyGBP: 'Libra Esterlina',
      TranslationKeys.currencyJPY: 'Yen Japonés',
      TranslationKeys.currencyCNY: 'Yuan Chino',
      TranslationKeys.currencyBRL: 'Real Brasileño',
      TranslationKeys.currencyARS: 'Peso Argentino',

      // validation messages
      TranslationKeys.pleaseEnterValidNumber:
          'Por favor ingrese un número válido',
      TranslationKeys.budgetMustBePositive:
          'El presupuesto debe ser un número positivo',

      // error messages
      TranslationKeys.error: 'Error',
      TranslationKeys.noGroupSelected: 'Ningún grupo seleccionado',
      TranslationKeys.listDetailsUpdatedSuccessfully:
          'Detalles de la lista actualizados exitosamente',
      TranslationKeys.failedToUpdateListDetails:
          'Error al actualizar los detalles de la lista: @error',

      // edit ingredient price
      TranslationKeys.quantity: 'Cantidad',
      TranslationKeys.unitPrice: 'Precio Unitario',
      TranslationKeys.addPrice: 'Agregar Precio',
      TranslationKeys.enterQuantity: 'Ingresar Cantidad',
      TranslationKeys.saveWithoutPrice: 'Guardar Sin Precio',
      TranslationKeys.actualIngredientTitle: 'Ingrediente Real',
      TranslationKeys.actualIngredientContent:
          '¿Es este un ingrediente real que se puede usar en recetas?',

      // create group
      TranslationKeys.createGroup: 'Crear Grupo',
      TranslationKeys.editGroup: 'Editar Grupo',
      TranslationKeys.groupName: 'Nombre del Grupo',
      TranslationKeys.groupUpdated: 'Grupo actualizado exitosamente',
      TranslationKeys.deleteGroup: 'Eliminar Grupo',
      TranslationKeys.deleteGroupMessage:
          '¿Estás seguro de que quieres eliminar este grupo? Esta acción no se puede deshacer.',
      TranslationKeys.groupDeleted: 'Grupo eliminado exitosamente',
      TranslationKeys.groupCreationLimitReached:
          'Has alcanzado el número máximo de grupos permitidos.',
    },
  };
}
