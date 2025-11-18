import 'package:authentication_repository/authentication_repository.dart';
import 'package:felicette_recipes/app/common/widgets/footer/footer.dart';
import 'package:felicette_recipes/app/common/widgets/header/header.dart';
import 'package:felicette_recipes/app/routes/app_routes.dart';
import 'package:felicette_recipes/generated/l10n.dart';
import 'package:felicette_recipes/password_recovery/password_recovery.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:go_router/go_router.dart';

class PasswordRecoveryPage extends StatelessWidget {
  const PasswordRecoveryPage({super.key});

  static GoRoute route() {
    return GoRoute(
      path: AppRoutes.passwordRecovery,
      builder: (context, state) => const PasswordRecoveryPage(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => PasswordRecoveryBloc(
        authenticationRepository: context.read<AuthenticationRepository>(),
      ),
      child: const _RecoveryPageContent(),
    );
  }
}

class _RecoveryPageContent extends StatelessWidget {
  const _RecoveryPageContent();

  @override
  Widget build(BuildContext context) {
    return BlocListener<PasswordRecoveryBloc, PasswordRecoveryState>(
      listener: (context, state) {
        if (state.status.isFailure) {
          final s = S.of(context);
          final snackBar = SnackBar(
            content: Text(s.password_recovery_error),
          );
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(snackBar);
        } else if (state.status.isSuccess) {
          final s = S.of(context);
          final snackBar = SnackBar(
            content: Text(s.password_recovery_email_sent),
          );
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(snackBar);
        }
      },
      child: Scaffold(
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
                          _EmailInput(),
                          _SubmitButtons(),
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
      ),
    );
  }
}

class _EmailInput extends StatelessWidget {
  const _EmailInput();
  @override
  Widget build(BuildContext context) {
    final s = S.of(context);
    final displayError = context.select(
      (PasswordRecoveryBloc bloc) => bloc.state.email.displayError,
    );
    return TextFormField(
      key: const Key('passwordRecoveryForm_emailInput_textField'),
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
      onChanged: (email) {
        context.read<PasswordRecoveryBloc>().add(
          PasswordRecoveryEmailChanged(email),
        );
      },
    );
  }
}

class _RecoveryPasswordButton extends StatelessWidget {
  const _RecoveryPasswordButton();
  @override
  Widget build(BuildContext context) {
    final isValid = context.select(
      (PasswordRecoveryBloc bloc) => bloc.state.isValid,
    );
    return FilledButton(
      key: const Key('recoveryPasswordForm_continue_raisedButton'),
      onPressed: isValid
          ? () {
              context.read<PasswordRecoveryBloc>().add(
                const PasswordRecoverySubmitted(),
              );
            }
          : null,
      child: Text(S.of(context).reset_password),
    );
  }
}

class _SubmitButtons extends StatelessWidget {
  const _SubmitButtons();
  @override
  Widget build(BuildContext context) {
    final isInProgress = context.select(
      (PasswordRecoveryBloc bloc) => bloc.state.status.isInProgress,
    );

    if (isInProgress) {
      return const SizedBox(
        height: 48,
        width: 48,
        child: CircularProgressIndicator(),
      );
    }

    return const Wrap(
      key: Key('recoveryPasswordForm_buttons_wrap'),
      spacing: 8,
      runAlignment: .center,
      crossAxisAlignment: .center,
      alignment: .center,
      children: [
        _RecoveryPasswordButton(),
      ],
    );
  }
}

class _AlreadyHaveAccountButton extends StatelessWidget {
  const _AlreadyHaveAccountButton();
  @override
  Widget build(BuildContext context) {
    return TextButton(
      key: const Key('recoveryPasswordForm_alreadyHaveAccount_textButton'),
      onPressed: () {
        context.go(AppRoutes.login);
      },
      child: Text(S.of(context).already_have_account),
    );
  }
}

class _CreateAccountButton extends StatelessWidget {
  const _CreateAccountButton();
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return TextButton(
      key: const Key('recoveryPasswordForm_createAccount_textButton'),
      onPressed: () {
        context.go(AppRoutes.createAccount);
      },
      style: TextButton.styleFrom(
        foregroundColor: theme.colorScheme.secondary,
      ),
      child: Text(S.of(context).create_account),
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
      children: [
        _AlreadyHaveAccountButton(),
        _CreateAccountButton(),
      ],
    );
  }
}
