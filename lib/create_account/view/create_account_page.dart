import 'package:authentication_repository/authentication_repository.dart';
import 'package:felicette_recipes/app/common/widgets/footer/footer.dart';
import 'package:felicette_recipes/app/common/widgets/header/header.dart';
import 'package:felicette_recipes/app/routes/app_routes.dart';
import 'package:felicette_recipes/authentication/models/confirmed_password.dart';
import 'package:felicette_recipes/create_account/create_account.dart';
import 'package:felicette_recipes/generated/l10n.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:go_router/go_router.dart';

class CreateAccountPage extends StatelessWidget {
  const CreateAccountPage({super.key});

  static GoRoute route() {
    return GoRoute(
      path: AppRoutes.createAccount,
      builder: (context, state) => const CreateAccountPage(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CreateAccountBloc(
        authenticationRepository: context.read<AuthenticationRepository>(),
      ),
      child: const _CreateAccountPageContent(),
    );
  }
}

class _CreateAccountPageContent extends StatelessWidget {
  const _CreateAccountPageContent();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              child: Form(
                child: AutofillGroup(
                  child: Container(
                    constraints: BoxConstraints(
                      minHeight: constraints.maxHeight,
                    ),
                    padding: const .all(16),
                    child: const Column(
                      spacing: 16,
                      mainAxisAlignment: .center,
                      children: [
                        FRHeader(),
                        _UsernameInput(),
                        _PasswordInput(),
                        _PasswordConfirmationInput(),
                        _CreateAccountButtons(),
                        _SecondaryActionsButtons(),
                        FRFooter(),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _UsernameInput extends StatelessWidget {
  const _UsernameInput();
  @override
  Widget build(BuildContext context) {
    final displayError = context.select(
      (CreateAccountBloc bloc) => bloc.state.username.displayError,
    );
    final s = S.of(context);
    return TextFormField(
      key: const Key('createAccountForm_usernameInput_textField'),
      autocorrect: false,
      decoration: InputDecoration(
        labelText: s.email,
        errorText: displayError != null ? s.invalid_email_error : null,
      ),
      keyboardType: .emailAddress,
      autofillHints: const [
        AutofillHints.email,
        AutofillHints.username,
      ],
      autovalidateMode: .onUserInteraction,
      onChanged: (username) {
        context.read<CreateAccountBloc>().add(
          CreateAccountUsernameChanged(username),
        );
      },
    );
  }
}

class _PasswordInput extends StatelessWidget {
  const _PasswordInput();
  @override
  Widget build(BuildContext context) {
    final isPasswordHidden = context.select(
      (CreateAccountBloc bloc) => bloc.state.isPasswordHidden,
    );

    final displayError = context.select(
      (CreateAccountBloc bloc) => bloc.state.password.displayError,
    );

    final s = S.of(context);

    return TextFormField(
      key: const Key('createAccountForm_passwordInput_textField'),
      autocorrect: false,
      decoration: InputDecoration(
        labelText: s.password,
        errorText: displayError != null ? s.input_required_error : null,
        suffix: IconButton(
          iconSize: 18,
          style: const ButtonStyle(
            tapTargetSize: .shrinkWrap,
          ),
          padding: .zero,
          visualDensity: .compact,

          onPressed: () {
            context.read<CreateAccountBloc>().add(
              const CreateAccountPasswordVisibilityToggled(),
            );
          },
          icon: Icon(
            isPasswordHidden ? Icons.visibility : Icons.visibility_off,
          ),
        ),
      ),
      obscureText: isPasswordHidden,
      autofillHints: const [AutofillHints.password],
      autovalidateMode: .onUserInteraction,
      onChanged: (password) {
        context.read<CreateAccountBloc>().add(
          CreateAccountPasswordChanged(password),
        );
      },
    );
  }
}

class _PasswordConfirmationInput extends StatelessWidget {
  const _PasswordConfirmationInput();
  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    final isPasswordConfirmationHidden = context.select(
      (CreateAccountBloc bloc) => bloc.state.isPasswordConfirmationHidden,
    );
    final displayError = context.select(
      (CreateAccountBloc bloc) => bloc.state.passwordConfirmation.displayError,
    );

    final errorMessages = {
      ConfirmedPasswordValidationError.empty: s.input_required_error,
      ConfirmedPasswordValidationError.invalid: s.passwords_do_not_match_error,
    };

    return TextFormField(
      key: const Key('createAccountForm_passwordConfirmationInput_textField'),
      autocorrect: false,
      decoration: InputDecoration(
        labelText: s.confirm_password,
        errorText: displayError != null ? errorMessages[displayError] : null,
        suffix: IconButton(
          iconSize: 18,
          style: const ButtonStyle(
            tapTargetSize: .shrinkWrap,
          ),
          padding: .zero,
          visualDensity: .compact,
          onPressed: () {
            context.read<CreateAccountBloc>().add(
              const CreateAccountPasswordConfirmationVisibilityToggled(),
            );
          },
          icon: Icon(
            isPasswordConfirmationHidden
                ? Icons.visibility
                : Icons.visibility_off,
          ),
        ),
      ),
      obscureText: isPasswordConfirmationHidden,
      autofillHints: const [AutofillHints.password],
      autovalidateMode: .onUserInteraction,
      onChanged: (passwordConfirmation) {
        context.read<CreateAccountBloc>().add(
          CreateAccountPasswordConfirmationChanged(
            passwordConfirmation,
          ),
        );
      },
    );
  }
}

class _CreateAccountButton extends StatelessWidget {
  const _CreateAccountButton();
  @override
  Widget build(BuildContext context) {
    final isValid = context.select(
      (CreateAccountBloc bloc) => bloc.state.isValid,
    );
    return FilledButton(
      key: const Key('createAccountForm_continue_raisedButton'),
      onPressed: isValid
          ? () {
              context.read<CreateAccountBloc>().add(
                const CreateAccountSubmitted(),
              );
            }
          : null,
      child: Text(S.of(context).create_account),
    );
  }
}

class _CreateAccountButtons extends StatelessWidget {
  const _CreateAccountButtons();
  @override
  Widget build(BuildContext context) {
    final isInProgressOrSuccess = context.select(
      (CreateAccountBloc bloc) =>
          bloc.state.submissionStatus.isInProgressOrSuccess,
    );

    if (isInProgressOrSuccess) {
      return const SizedBox(
        height: 48,
        width: 48,
        child: CircularProgressIndicator(),
      );
    }

    return const Wrap(
      key: Key('createAccountForm_buttons_wrap'),
      spacing: 8,
      runAlignment: .center,
      crossAxisAlignment: .center,
      alignment: .center,
      children: [
        _CreateAccountButton(),
      ],
    );
  }
}

class _AlreadyHaveAccountButton extends StatelessWidget {
  const _AlreadyHaveAccountButton();
  @override
  Widget build(BuildContext context) {
    return TextButton(
      key: const Key('createAccountForm_alreadyHaveAccount_textButton'),
      onPressed: () {
        context.go(AppRoutes.login);
      },
      child: Text(S.of(context).already_have_account),
    );
  }
}

class _SecondaryActionsButtons extends StatelessWidget {
  const _SecondaryActionsButtons();
  @override
  Widget build(BuildContext context) {
    return const Wrap(
      alignment: .center,
      spacing: 8,
      children: [_AlreadyHaveAccountButton()],
    );
  }
}
