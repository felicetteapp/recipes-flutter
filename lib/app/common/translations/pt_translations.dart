import 'package:get/get.dart';
import 'package:recipes_flutter/app/common/translation_keys.dart';

class PtTranslations extends Translations {
  @override
  Map<String, Map<String, String>> get keys => {
    'pt_BR': {
      TranslationKeys.nameMinLength:
          'O nome deve ter pelo menos @min caracteres',
      TranslationKeys.nameMaxLength: 'O nome não pode exceder @max caracteres',

      // common
      TranslationKeys.email: 'Email',
      TranslationKeys.password: 'Senha',
      TranslationKeys.login: 'Entrar',
      TranslationKeys.logout: 'Sair',
      TranslationKeys.cancel: 'Cancelar',
      TranslationKeys.save: 'Salvar',
      TranslationKeys.delete: 'Excluir',
      TranslationKeys.edit: 'Editar',
      TranslationKeys.confirm: 'Confirmar',
      TranslationKeys.success: 'Sucesso',
      TranslationKeys.tryAgain: 'Tentar Novamente',
      TranslationKeys.list: 'lista',
      '${TranslationKeys.list}_other': 'listas',
      TranslationKeys.onList: 'na lista',
      TranslationKeys.recipe: 'receita',
      '${TranslationKeys.recipe}_other': 'receitas',
      TranslationKeys.ingredient: 'ingrediente',
      '${TranslationKeys.ingredient}_other': 'ingredientes',
      TranslationKeys.showListByIngredients: 'Mostrar lista por ingredientes',
      TranslationKeys.showListByRecipes: 'Mostrar lista por receitas',
      TranslationKeys.showCheckedFirst: 'Mostrar marcados primeiro',
      TranslationKeys.otherIngredients: 'Outros Ingredientes',
      TranslationKeys.for_: 'para ',

      // home view
      TranslationKeys.unknownView: 'Vista desconhecida',
      TranslationKeys.addRecipe: 'Adicionar receita',
      TranslationKeys.addIngredient: 'Adicionar ingrediente',
      TranslationKeys.selectRecipes: 'Selecionar receitas',
      TranslationKeys.itemsSelected: '@count selecionado',
      '${TranslationKeys.itemsSelected}_other': '@count selecionados',

      // login
      TranslationKeys.loginErrorTitle: 'Falha no login',

      // drawer
      TranslationKeys.yourGroups: 'Seus Grupos',
      TranslationKeys.language: 'Idioma',
      TranslationKeys.selectLanguage: 'Selecionar Idioma',
      TranslationKeys.about: 'Sobre',
      TranslationKeys.applicationName: 'Felicette Receitas',
      TranslationKeys.applicationDescription:
          'Felicette Receitas é um aplicativo de código aberto para ajudar você a gerenciar suas receitas e listas de compras.',
      TranslationKeys.developedWith: 'Desenvolvido com',
      TranslationKeys.loveAndCats: 'Amor e Gatos',
      TranslationKeys.developedIn: 'em Curitiba, Brasil.',
      TranslationKeys.developedBy: 'Por felicette.dev',
      TranslationKeys.checkoutGithub: 'Confira o projeto no GitHub: ',

      // budget display
      TranslationKeys.spentOf: ' gasto de ',
      TranslationKeys.available: ' disponível',

      // ingredients
      TranslationKeys.actualIngredients: 'Ingredientes Reais',
      TranslationKeys.actualIngredientsSubtitle:
          'Estes itens podem ser usados em receitas e adicionados à lista de compras',
      TranslationKeys.nonActualIngredients: 'Ingredientes Não-Reais',
      TranslationKeys.nonActualIngredientsSubtitle:
          'Estes itens podem ser adicionados à lista de compras, mas não podem ser usados em receitas',
      TranslationKeys.newIngredient: 'Novo Ingrediente',
      TranslationKeys.ingredientName: 'Nome do Ingrediente',
      TranslationKeys.isActualIngredient: 'É Ingrediente Real',
      TranslationKeys.editIngredient: 'Editar Ingrediente',
      TranslationKeys.confirmDeletion: 'Confirmar Exclusão',
      TranslationKeys.confirmDeletionMessage:
          'Tem certeza de que deseja excluir este ingrediente?',
      TranslationKeys.ingredientUpdatedSuccessfully:
          'Ingrediente atualizado com sucesso',
      TranslationKeys.ingredientDeletedSuccessfully:
          'Ingrediente excluído com sucesso',
      TranslationKeys.ingredientCreatedSuccessfully:
          'Ingrediente criado com sucesso',

      // recipes
      TranslationKeys.editRecipe: 'Editar Receita',
      TranslationKeys.createRecipe: 'Criar Receita',
      TranslationKeys.recipeName: 'Nome da Receita',
      TranslationKeys.selectIngredients: 'Selecionar Ingredientes',
      TranslationKeys.chooseIngredientsText:
          'Escolha os ingredientes necessários para a receita. As quantidades podem ser inseridas abaixo.',
      TranslationKeys.optionalQuantitiesText:
          'Opcionalmente, insira as quantidades dos ingredientes abaixo.',
      TranslationKeys.quantitiesShoppingListText:
          'As quantidades aparecerão na lista de compras quando a receita for selecionada.',
      TranslationKeys.quantityFor: 'Quantidade para @ingredient',

      // select modal
      TranslationKeys.search: 'Buscar',
      TranslationKeys.create: 'Criar',
      TranslationKeys.done: 'Concluído',
    },
  };
}
