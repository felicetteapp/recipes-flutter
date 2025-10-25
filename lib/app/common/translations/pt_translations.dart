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
      TranslationKeys.tryAgain: 'Tentar Novamente',

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
    },
  };
}
