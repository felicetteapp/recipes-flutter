// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a pt locale. All the
// messages from the main program should be duplicated here with the same
// function name.

// Ignore issues from commonly used lints in this file.
// ignore_for_file:unnecessary_brace_in_string_interps, unnecessary_new
// ignore_for_file:prefer_single_quotes,comment_references, directives_ordering
// ignore_for_file:annotate_overrides,prefer_generic_function_type_aliases
// ignore_for_file:unused_import, file_names, avoid_escaping_inner_quotes
// ignore_for_file:unnecessary_string_interpolations, unnecessary_string_escapes

import 'package:intl/intl.dart';
import 'package:intl/message_lookup_by_library.dart';

final messages = new MessageLookup();

typedef String MessageIfAbsent(String messageStr, List<dynamic> args);

class MessageLookup extends MessageLookupByLibrary {
  String get localeName => 'pt';

  static String m0(ingredientName) =>
      "\"${ingredientName}\" é um ingrediente real que pode ser usado em receitas?";

  static String m1(error) => "Falha ao atualizar detalhes da lista: ${error}";

  static String m2(count) =>
      "${Intl.plural(count, one: 'ingrediente', other: 'ingredientes')}";

  static String m3(count) =>
      "${Intl.plural(count, zero: 'Nenhum item selecionado', one: '1 item selecionado', other: '${count} itens selecionados')}";

  static String m4(count) =>
      "${Intl.plural(count, one: 'lista', other: 'listas')}";

  static String m5(max) => "O nome não pode exceder ${max} caracteres";

  static String m6(min) => "O nome deve ter pelo menos ${min} caracteres";

  static String m7(ingredient) => "Quantidade para ${ingredient}";

  static String m8(count) =>
      "${Intl.plural(count, one: 'receita', other: 'receitas')}";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
    "about": MessageLookupByLibrary.simpleMessage("Sobre"),
    "actual_ingredient_content": MessageLookupByLibrary.simpleMessage(
      "Este é um ingrediente real que pode ser usado em receitas?",
    ),
    "actual_ingredient_title": MessageLookupByLibrary.simpleMessage(
      "Ingrediente Real",
    ),
    "actual_ingredients": MessageLookupByLibrary.simpleMessage(
      "Ingredientes Reais",
    ),
    "actual_ingredients_subtitle": MessageLookupByLibrary.simpleMessage(
      "Estes itens podem ser usados em receitas e adicionados à lista de compras",
    ),
    "add_ingredient": MessageLookupByLibrary.simpleMessage(
      "Adicionar Ingrediente",
    ),
    "add_price": MessageLookupByLibrary.simpleMessage("Adicionar Preço"),
    "add_recipe": MessageLookupByLibrary.simpleMessage("Adicionar Receita"),
    "all_checks_cleared": MessageLookupByLibrary.simpleMessage(
      "Todas as marcações foram removidas",
    ),
    "already_have_account": MessageLookupByLibrary.simpleMessage(
      "Já tem uma conta?",
    ),
    "also": MessageLookupByLibrary.simpleMessage("também"),
    "application_description": MessageLookupByLibrary.simpleMessage(
      "Felicette Receitas é um aplicativo de código aberto para ajudá-lo a gerenciar suas receitas e listas de compras.",
    ),
    "application_name": MessageLookupByLibrary.simpleMessage(
      "Felicette Receitas",
    ),
    "available": MessageLookupByLibrary.simpleMessage(" disponível"),
    "budget": MessageLookupByLibrary.simpleMessage("Orçamento"),
    "budget_must_be_positive": MessageLookupByLibrary.simpleMessage(
      "O orçamento deve ser um número positivo",
    ),
    "cancel": MessageLookupByLibrary.simpleMessage("Cancelar"),
    "checkout_github": MessageLookupByLibrary.simpleMessage(
      "Confira o projeto no GitHub: ",
    ),
    "choose_ingredients_text": MessageLookupByLibrary.simpleMessage(
      "Escolha os ingredientes necessários para a receita. As quantidades podem ser inseridas abaixo.",
    ),
    "clear_all_checks": MessageLookupByLibrary.simpleMessage("Desmarcar Todos"),
    "clear_all_checks_confirmation": MessageLookupByLibrary.simpleMessage(
      "Tem certeza de que quer desmarcar todos os itens?",
    ),
    "confirm": MessageLookupByLibrary.simpleMessage("Confirmar"),
    "confirm_actual_ingredient": MessageLookupByLibrary.simpleMessage(
      "Confirmar Ingrediente Real",
    ),
    "confirm_actual_ingredient_description": m0,
    "confirm_ingredient_deletion": MessageLookupByLibrary.simpleMessage(
      "Confirmar Exclusão",
    ),
    "confirm_ingredient_deletion_message": MessageLookupByLibrary.simpleMessage(
      "Tem certeza de que deseja excluir este ingrediente?",
    ),
    "confirm_password": MessageLookupByLibrary.simpleMessage("Confirmar Senha"),
    "confirm_recipe_deletion": MessageLookupByLibrary.simpleMessage(
      "Confirmar Exclusão",
    ),
    "confirm_recipe_deletion_message": MessageLookupByLibrary.simpleMessage(
      "Tem certeza de que deseja excluir esta receita?",
    ),
    "connected": MessageLookupByLibrary.simpleMessage("Conectado"),
    "create": MessageLookupByLibrary.simpleMessage("Criar"),
    "create_account": MessageLookupByLibrary.simpleMessage("Criar Conta"),
    "create_account_error": MessageLookupByLibrary.simpleMessage(
      "Falha ao criar conta",
    ),
    "create_account_success": MessageLookupByLibrary.simpleMessage(
      "Conta criada com sucesso!",
    ),
    "create_group": MessageLookupByLibrary.simpleMessage("Criar Grupo"),
    "create_recipe": MessageLookupByLibrary.simpleMessage("Criar Receita"),
    "currency_ars": MessageLookupByLibrary.simpleMessage("Peso Argentino"),
    "currency_brl": MessageLookupByLibrary.simpleMessage("Real Brasileiro"),
    "currency_cny": MessageLookupByLibrary.simpleMessage("Yuan Chinês"),
    "currency_eur": MessageLookupByLibrary.simpleMessage("Euro"),
    "currency_gbp": MessageLookupByLibrary.simpleMessage("Libra Esterlina"),
    "currency_inr": MessageLookupByLibrary.simpleMessage("Rúpia Indiana"),
    "currency_jpy": MessageLookupByLibrary.simpleMessage("Iene Japonês"),
    "currency_usd": MessageLookupByLibrary.simpleMessage("Dólar Americano"),
    "dark_mode": MessageLookupByLibrary.simpleMessage("Modo Escuro"),
    "delete": MessageLookupByLibrary.simpleMessage("Excluir"),
    "delete_group": MessageLookupByLibrary.simpleMessage("Excluir Grupo"),
    "delete_group_message": MessageLookupByLibrary.simpleMessage(
      "Tem certeza de que deseja excluir este grupo? Esta ação não pode ser desfeita.",
    ),
    "developed_by": MessageLookupByLibrary.simpleMessage("Por felicette.dev"),
    "developed_in": MessageLookupByLibrary.simpleMessage(
      "em Curitiba, Brasil.",
    ),
    "developed_with_love": MessageLookupByLibrary.simpleMessage(
      "Desenvolvido com",
    ),
    "done": MessageLookupByLibrary.simpleMessage("Concluído"),
    "edit": MessageLookupByLibrary.simpleMessage("Editar"),
    "edit_group": MessageLookupByLibrary.simpleMessage("Editar Grupo"),
    "edit_ingredient": MessageLookupByLibrary.simpleMessage(
      "Editar Ingrediente",
    ),
    "edit_list": MessageLookupByLibrary.simpleMessage("Editar Lista"),
    "edit_recipe": MessageLookupByLibrary.simpleMessage("Editar Receita"),
    "email": MessageLookupByLibrary.simpleMessage("E-mail"),
    "email_is_required_error": MessageLookupByLibrary.simpleMessage(
      "E-mail é obrigatório",
    ),
    "enter_quantity": MessageLookupByLibrary.simpleMessage(
      "Inserir Quantidade",
    ),
    "error": MessageLookupByLibrary.simpleMessage("Erro"),
    "failed_to_update_list_details": m1,
    "forgot_password": MessageLookupByLibrary.simpleMessage(
      "Esqueceu a Senha?",
    ),
    "group_creation_limit_reached": MessageLookupByLibrary.simpleMessage(
      "Você atingiu o número máximo de grupos permitidos.",
    ),
    "group_deleted": MessageLookupByLibrary.simpleMessage(
      "Grupo excluído com sucesso",
    ),
    "group_name": MessageLookupByLibrary.simpleMessage("Nome do Grupo"),
    "group_name_updated": MessageLookupByLibrary.simpleMessage(
      "Grupo atualizado com sucesso",
    ),
    "ingredient": m2,
    "ingredient_created_successfully": MessageLookupByLibrary.simpleMessage(
      "Ingrediente criado com sucesso",
    ),
    "ingredient_deleted_successfully": MessageLookupByLibrary.simpleMessage(
      "Ingrediente excluído com sucesso",
    ),
    "ingredient_name": MessageLookupByLibrary.simpleMessage(
      "Nome do Ingrediente",
    ),
    "ingredient_updated_successfully": MessageLookupByLibrary.simpleMessage(
      "Ingrediente atualizado com sucesso",
    ),
    "input_required_error": MessageLookupByLibrary.simpleMessage(
      "Este campo é obrigatório",
    ),
    "invalid_email_error": MessageLookupByLibrary.simpleMessage(
      "Por favor, insira um endereço de e-mail válido",
    ),
    "is_actual_ingredient": MessageLookupByLibrary.simpleMessage(
      "É Ingrediente Real",
    ),
    "items_selected": m3,
    "language": MessageLookupByLibrary.simpleMessage("Idioma"),
    "light_mode": MessageLookupByLibrary.simpleMessage("Modo Claro"),
    "list": m4,
    "list_details_updated_successfully": MessageLookupByLibrary.simpleMessage(
      "Detalhes da lista atualizados com sucesso",
    ),
    "loading": MessageLookupByLibrary.simpleMessage("Carregando"),
    "login": MessageLookupByLibrary.simpleMessage("Entrar"),
    "login_error": MessageLookupByLibrary.simpleMessage("Falha no login"),
    "login_without_password": MessageLookupByLibrary.simpleMessage(
      "Entrar sem senha",
    ),
    "login_without_password_success_message":
        MessageLookupByLibrary.simpleMessage(
          "Link de login enviado! Por favor, verifique seu e-mail.",
        ),
    "logout": MessageLookupByLibrary.simpleMessage("Sair"),
    "love_and_cats": MessageLookupByLibrary.simpleMessage("Amor e Gatos"),
    "more": MessageLookupByLibrary.simpleMessage("Mais"),
    "my_first_group": MessageLookupByLibrary.simpleMessage(
      "Meu Primeiro Grupo",
    ),
    "name_max_length": m5,
    "name_min_length": m6,
    "new_ingredient": MessageLookupByLibrary.simpleMessage("Novo Ingrediente"),
    "no": MessageLookupByLibrary.simpleMessage("Não"),
    "no_group_selected": MessageLookupByLibrary.simpleMessage(
      "Nenhum grupo selecionado",
    ),
    "no_groups_created": MessageLookupByLibrary.simpleMessage(
      "Nenhum grupo criado",
    ),
    "no_ingredients_created": MessageLookupByLibrary.simpleMessage(
      "Nenhum ingrediente criado",
    ),
    "no_ingredients_created_description": MessageLookupByLibrary.simpleMessage(
      "Crie seu primeiro ingrediente para começar com receitas e listas de compras.",
    ),
    "no_recipes_created": MessageLookupByLibrary.simpleMessage(
      "Nenhuma receita criada",
    ),
    "no_recipes_created_description": MessageLookupByLibrary.simpleMessage(
      "Crie sua primeira receita para organizar sua cozinha e gerar listas de compras.",
    ),
    "non_actual_ingredients": MessageLookupByLibrary.simpleMessage(
      "Não-Ingredientes",
    ),
    "non_actual_ingredients_subtitle": MessageLookupByLibrary.simpleMessage(
      "Estes itens podem ser adicionados à lista de compras, mas não podem ser usados em receitas",
    ),
    "not_connected": MessageLookupByLibrary.simpleMessage("Não Conectado"),
    "ok": MessageLookupByLibrary.simpleMessage("OK"),
    "on_list": MessageLookupByLibrary.simpleMessage("na lista"),
    "optional_quantities_text": MessageLookupByLibrary.simpleMessage(
      "Opcionalmente, insira as quantidades dos ingredientes abaixo.",
    ),
    "other_ingredients": MessageLookupByLibrary.simpleMessage(
      "Outros Ingredientes",
    ),
    "password": MessageLookupByLibrary.simpleMessage("Senha"),
    "password_recovery_email_sent": MessageLookupByLibrary.simpleMessage(
      "E-mail de recuperação de senha enviado",
    ),
    "password_recovery_error": MessageLookupByLibrary.simpleMessage(
      "Erro ao enviar e-mail de recuperação de senha",
    ),
    "passwords_do_not_match_error": MessageLookupByLibrary.simpleMessage(
      "As senhas não coincidem",
    ),
    "please_enter_valid_number": MessageLookupByLibrary.simpleMessage(
      "Por favor, insira um número válido",
    ),
    "quantities_shopping_list_text": MessageLookupByLibrary.simpleMessage(
      "As quantidades aparecerão na lista de compras quando a receita for selecionada.",
    ),
    "quantity": MessageLookupByLibrary.simpleMessage("Quantidade"),
    "quantity_for": m7,
    "recipe": m8,
    "recipe_created_successfully": MessageLookupByLibrary.simpleMessage(
      "Receita criada com sucesso",
    ),
    "recipe_deleted_successfully": MessageLookupByLibrary.simpleMessage(
      "Receita excluída com sucesso",
    ),
    "recipe_ingredients_error": MessageLookupByLibrary.simpleMessage(
      "Há erros nos ingredientes da receita",
    ),
    "recipe_name": MessageLookupByLibrary.simpleMessage("Nome da Receita"),
    "recipe_updated_successfully": MessageLookupByLibrary.simpleMessage(
      "Receita atualizada com sucesso",
    ),
    "recipes_should_have_at_least_one_ingredient":
        MessageLookupByLibrary.simpleMessage(
          "As receitas devem ter pelo menos um ingrediente",
        ),
    "reset_password": MessageLookupByLibrary.simpleMessage("Redefinir Senha"),
    "reset_password_error": MessageLookupByLibrary.simpleMessage(
      "Falha ao enviar e-mail de redefinição de senha",
    ),
    "reset_password_success": MessageLookupByLibrary.simpleMessage(
      "E-mail de redefinição de senha enviado! Por favor, verifique sua caixa de entrada.",
    ),
    "save": MessageLookupByLibrary.simpleMessage("Salvar"),
    "save_without_price": MessageLookupByLibrary.simpleMessage(
      "Salvar Sem Preço",
    ),
    "search": MessageLookupByLibrary.simpleMessage("Buscar"),
    "select_at_least_one_ingredient": MessageLookupByLibrary.simpleMessage(
      "Por favor, selecione pelo menos um ingrediente para prosseguir.",
    ),
    "select_currency": MessageLookupByLibrary.simpleMessage("Selecionar Moeda"),
    "select_ingredients": MessageLookupByLibrary.simpleMessage(
      "Selecionar Ingredientes",
    ),
    "select_language": MessageLookupByLibrary.simpleMessage(
      "Selecionar Idioma",
    ),
    "select_recipes": MessageLookupByLibrary.simpleMessage(
      "Selecionar receitas",
    ),
    "show_budget": MessageLookupByLibrary.simpleMessage("Mostrar orçamento"),
    "show_checked_first": MessageLookupByLibrary.simpleMessage(
      "Mostrar marcados primeiro",
    ),
    "show_list_by_ingredients": MessageLookupByLibrary.simpleMessage(
      "Mostrar lista por ingredientes",
    ),
    "show_list_by_recipes": MessageLookupByLibrary.simpleMessage(
      "Mostrar lista por receitas",
    ),
    "spent_of": MessageLookupByLibrary.simpleMessage(" gasto de "),
    "success": MessageLookupByLibrary.simpleMessage("Sucesso"),
    "tfor": MessageLookupByLibrary.simpleMessage("para "),
    "theme": MessageLookupByLibrary.simpleMessage("Tema"),
    "try_again": MessageLookupByLibrary.simpleMessage("Tentar Novamente"),
    "unit_price": MessageLookupByLibrary.simpleMessage("Preço Unitário"),
    "unknown_view": MessageLookupByLibrary.simpleMessage(
      "Visualização Desconhecida",
    ),
    "wear_os_sync": MessageLookupByLibrary.simpleMessage(
      "Sincronização Wear OS",
    ),
    "yes": MessageLookupByLibrary.simpleMessage("Sim"),
    "your_groups": MessageLookupByLibrary.simpleMessage("Seus Grupos"),
  };
}
