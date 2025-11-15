import 'package:get/get.dart';
import 'package:felicette_recipes/app/common/translation_keys.dart';

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
      TranslationKeys.showBudget: 'Mostrar orçamento',
      TranslationKeys.otherIngredients: 'Outros Ingredientes',
      TranslationKeys.for_: 'para ',
      TranslationKeys.budget: 'Orçamento',
      TranslationKeys.no: 'Não',
      TranslationKeys.yes: 'Sim',
      TranslationKeys.more: 'Mais',
      TranslationKeys.ok: 'OK',
      TranslationKeys.loading: 'Carregando',
      TranslationKeys.theme: 'Tema',
      TranslationKeys.darkMode: 'Modo Escuro',
      TranslationKeys.lightMode: 'Modo Claro',
      TranslationKeys.myFirstGroup: 'Meu Primeiro Grupo',
      TranslationKeys.wearOSSync: 'Sincronização com Wear OS',
      TranslationKeys.connected: 'Conectado',
      TranslationKeys.notConnected: 'Não Conectado',

      // validation
      TranslationKeys.inputRequiredError: 'Este campo é obrigatório',
      TranslationKeys.invalidEmailError:
          'Por favor, insira um endereço de email válido',
      TranslationKeys.emailIsRequiredError: 'Email é obrigatório',

      // home view
      TranslationKeys.unknownView: 'Vista desconhecida',
      TranslationKeys.addRecipe: 'Adicionar receita',
      TranslationKeys.addIngredient: 'Adicionar ingrediente',
      TranslationKeys.selectRecipes: 'Selecionar receitas',
      TranslationKeys.itemsSelected: '@count selecionado',
      '${TranslationKeys.itemsSelected}_other': '@count selecionados',
      TranslationKeys.noGroupsCreated: 'Nenhum grupo criado',

      // login
      TranslationKeys.loginErrorTitle: 'Falha no login',
      TranslationKeys.forgotPassword: 'Esqueceu a senha?',
      TranslationKeys.alreadyHaveAccount: 'Já tem uma conta?',
      TranslationKeys.resetPassword: 'Redefinir Senha',
      TranslationKeys.resetPasswordSuccess:
          'Email de redefinição de senha enviado! Por favor, verifique sua caixa de entrada.',
      TranslationKeys.resetPasswordError:
          'Falha ao enviar email de redefinição de senha',
      TranslationKeys.createAccount: 'Criar Conta',
      TranslationKeys.confirmPassword: 'Confirmar Senha',
      TranslationKeys.passwordsDoNotMatchError: 'As senhas não correspondem',
      TranslationKeys.createAccountErrorTitle: 'Falha ao criar conta',
      TranslationKeys.createAccountSuccess: 'Conta criada com sucesso!',
      TranslationKeys.loginWithoutPassword: 'Login sem senha',
      TranslationKeys.loginWithoutPasswordSuccessMessage:
          'Link de login enviado! Por favor, verifique seu email.',

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
      TranslationKeys.actualIngredients: 'Ingredientes',
      TranslationKeys.actualIngredientsSubtitle:
          'Estes itens podem ser usados em receitas e adicionados à lista de compras',
      TranslationKeys.nonActualIngredients: 'Não Ingredientes',
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
      TranslationKeys.confirmActualIngredientDescription:
          'É "@ingredientName" um ingrediente real que pode ser usado em receitas?',
      TranslationKeys.confirmActualIngredient: 'Confirmar Ingrediente Real',
      TranslationKeys.noIngredientsCreated: 'Nenhum ingrediente criado',
      TranslationKeys.noIngredientsCreatedDescription:
          'Crie seu primeiro ingrediente para começar com receitas e listas de compras.',

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
      TranslationKeys.noRecipesCreated: 'Nenhuma receita criada',
      TranslationKeys.noRecipesCreatedDescription:
          'Crie sua primeira receita para organizar sua culinária e gerar listas de compras.',

      // select modal
      TranslationKeys.search: 'Buscar',
      TranslationKeys.create: 'Criar',
      TranslationKeys.done: 'Concluído',

      // edit list
      TranslationKeys.editList: 'Editar Lista',
      TranslationKeys.selectCurrency: 'Selecionar Moeda',
      TranslationKeys.clearAllChecks: 'Desmarcar Tudo',

      // currencies
      TranslationKeys.currencyUSD: 'Dólar Americano',
      TranslationKeys.currencyEUR: 'Euro',
      TranslationKeys.currencyGBP: 'Libra Esterlina',
      TranslationKeys.currencyJPY: 'Iene Japonês',
      TranslationKeys.currencyCNY: 'Yuan Chinês',
      TranslationKeys.currencyBRL: 'Real Brasileiro',
      TranslationKeys.currencyARS: 'Peso Argentino',

      // validation messages
      TranslationKeys.pleaseEnterValidNumber:
          'Por favor, insira um número válido',
      TranslationKeys.budgetMustBePositive:
          'O orçamento deve ser um número positivo',

      // error messages
      TranslationKeys.error: 'Erro',
      TranslationKeys.noGroupSelected: 'Nenhum grupo selecionado',
      TranslationKeys.listDetailsUpdatedSuccessfully:
          'Detalhes da lista atualizados com sucesso',
      TranslationKeys.failedToUpdateListDetails:
          'Falha ao atualizar os detalhes da lista: @error',

      // edit ingredient price
      TranslationKeys.quantity: 'Quantidade',
      TranslationKeys.unitPrice: 'Preço Unitário',
      TranslationKeys.addPrice: 'Adicionar Preço',
      TranslationKeys.enterQuantity: 'Inserir Quantidade',
      TranslationKeys.saveWithoutPrice: 'Salvar Sem Preço',
      TranslationKeys.actualIngredientTitle: 'Ingrediente Real',
      TranslationKeys.actualIngredientContent:
          'Este é um ingrediente real que pode ser usado em receitas?',

      // create group
      TranslationKeys.createGroup: 'Criar Grupo',
      TranslationKeys.editGroup: 'Editar Grupo',
      TranslationKeys.groupName: 'Nome do Grupo',
      TranslationKeys.groupUpdated: 'Grupo atualizado com sucesso',
      TranslationKeys.deleteGroup: 'Excluir Grupo',
      TranslationKeys.deleteGroupMessage:
          'Tem certeza de que deseja excluir este grupo? Esta ação não pode ser desfeita.',
      TranslationKeys.groupDeleted: 'Grupo excluído com sucesso',
      TranslationKeys.groupCreationLimitReached:
          'Você atingiu o número máximo de grupos permitidos.',
    },
  };
}
