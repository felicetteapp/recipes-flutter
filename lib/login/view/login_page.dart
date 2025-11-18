import 'package:authentication_repository/authentication_repository.dart';
import 'package:felicette_recipes/app/common/widgets/footer/footer.dart';
import 'package:felicette_recipes/app/common/widgets/header/header.dart';
import 'package:felicette_recipes/app/routes/app_routes.dart';
import 'package:felicette_recipes/generated/l10n.dart';
import 'package:felicette_recipes/login/login.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:formz/formz.dart';
import 'package:go_router/go_router.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  static GoRoute route() {
    return GoRoute(
      path: AppRoutes.login,
      builder: (context, state) => const LoginPage(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LoginBloc(
        authenticationRepository: context.read<AuthenticationRepository>(),
      ),
      child: const _LoginPageContent(),
    );
  }
}

class _LoginPageContent extends StatelessWidget {
  const _LoginPageContent();

  @override
  Widget build(BuildContext context) {
    return BlocListener<LoginBloc, LoginState>(
      listener: (context, state) {
        if (state.status.isFailure) {
          final s = S.of(context);
          final snackBar = SnackBar(
            content: Text(s.login_error),
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
                          _UsernameInput(),
                          _PasswordInput(),
                          _LoginButtons(),
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

class _UsernameInput extends StatelessWidget {
  const _UsernameInput();
  @override
  Widget build(BuildContext context) {
    final displayError = context.select(
      (LoginBloc bloc) => bloc.state.username.displayError,
    );
    final s = S.of(context);
    return TextFormField(
      key: const Key('loginForm_usernameInput_textField'),
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
        context.read<LoginBloc>().add(LoginUsernameChanged(username));
      },
    );
  }
}

class _PasswordInput extends StatelessWidget {
  const _PasswordInput();
  @override
  Widget build(BuildContext context) {
    final isPasswordHidden = context.select(
      (LoginBloc bloc) => bloc.state.isPasswordHidden,
    );

    final displayError = context.select(
      (LoginBloc bloc) => bloc.state.password.displayError,
    );

    final s = S.of(context);

    return TextFormField(
      key: const Key('loginForm_passwordInput_textField'),
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
            context.read<LoginBloc>().add(
              const LoginPasswordVisibilityToggled(),
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
        context.read<LoginBloc>().add(LoginPasswordChanged(password));
      },
    );
  }
}

class _LoginButton extends StatelessWidget {
  const _LoginButton();
  @override
  Widget build(BuildContext context) {
    final isValid = context.select((LoginBloc bloc) => bloc.state.isValid);
    return FilledButton(
      key: const Key('loginForm_continue_raisedButton'),
      onPressed: isValid
          ? () {
              context.read<LoginBloc>().add(const LoginSubmitted());
            }
          : null,
      child: Text(S.of(context).login),
    );
  }
}

class _PasswordlessLoginButton extends StatelessWidget {
  const _PasswordlessLoginButton();
  @override
  Widget build(BuildContext context) {
    final isUsernameValid = context.select(
      (LoginBloc bloc) => bloc.state.isUsernameValid,
    );
    return OutlinedButton(
      key: const Key('loginForm_passwordlessLogin_outlinedButton'),
      onPressed: isUsernameValid
          ? () {
              // Implement passwordless login logic here
            }
          : null,
      child: Text(S.of(context).login_without_password),
    );
  }
}

class _LoginButtons extends StatelessWidget {
  const _LoginButtons();
  @override
  Widget build(BuildContext context) {
    final isInProgressOrSuccess = context.select(
      (LoginBloc bloc) => bloc.state.status.isInProgressOrSuccess,
    );

    if (isInProgressOrSuccess) {
      return const SizedBox(
        height: 48,
        width: 48,
        child: CircularProgressIndicator(),
      );
    }

    return const Wrap(
      key: Key('loginForm_buttons_wrap'),
      spacing: 8,
      runAlignment: .center,
      crossAxisAlignment: .center,
      alignment: .center,
      children: [
        _LoginButton(),
        _PasswordlessLoginButton(),
      ],
    );
  }
}

class _ForgotPasswordButton extends StatelessWidget {
  const _ForgotPasswordButton();
  @override
  Widget build(BuildContext context) {
    return TextButton(
      key: const Key('loginForm_forgotPassword_textButton'),
      onPressed: () {
        context.go(AppRoutes.passwordRecovery);
      },
      child: Text(S.of(context).forgot_password),
    );
  }
}

class _CreateAccountButton extends StatelessWidget {
  const _CreateAccountButton();
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return TextButton(
      key: const Key('loginForm_createAccount_textButton'),
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
        _ForgotPasswordButton(),
        _CreateAccountButton(),
      ],
    );
  }
}
