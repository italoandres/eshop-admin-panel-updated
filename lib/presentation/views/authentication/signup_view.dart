import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:sizer/sizer.dart';

import '../../../core/constant/app_sizes.dart';
import '../../../core/constant/images.dart';
import '../../../core/constant/strings.dart';
import '../../../core/constant/validators.dart';
import '../../../core/error/failures.dart';
import '../../../core/router/app_router.dart';
import '../../../domain/usecases/user/sign_up_usecase.dart';
import '../../blocs/cart/cart_bloc.dart';
import '../../blocs/user/user_bloc.dart';
import '../../widgets/input_form_button.dart';
import '../../widgets/input_text_form_field.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocListener<UserBloc, UserState>(
      listener: (context, state) {
        EasyLoading.dismiss();
        if (state is UserLoading) {
          EasyLoading.show(status: 'Loading...');
        } else if (state is UserLogged) {
          context.read<CartBloc>().add(const GetCart());
          Navigator.of(context).pushNamedAndRemoveUntil(
            AppRouter.home,
            (Route<dynamic> route) => false,
          );
        } else if (state is UserLoggedFail) {
          String errorMessage = errorOccurred;
          if (state.failure is CredentialFailure) {
            errorMessage = incorrectUsernamePassword;
          } else if (state.failure is NetworkFailure) {
            errorMessage = networkError;
          }
          EasyLoading.showError(errorMessage);
        }
      },
      child: Scaffold(
          body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: kPaddingMedium),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const SizedBox(
                    height: 50,
                  ),
                  SizedBox(
                      height: 80,
                      child: Image.asset(
                        kAppLogo,
                        color: Colors.black,
                      )),
                  const SizedBox(
                    height: 10,
                  ),
                  const Text(
                    signUpMessage,
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(
                    height: 6.h,
                  ),
                  InputTextFormField(
                    controller: _firstNameController,
                    hint: firstName,
                    textInputAction: TextInputAction.next,
                    validation: (String? val) =>
                        Validators.validateField(val, firstName),
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  InputTextFormField(
                    controller: _lastNameController,
                    hint: lastName,
                    textInputAction: TextInputAction.next,
                    validation: (String? val) =>
                        Validators.validateField(val, lastName),
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  InputTextFormField(
                    controller: _emailController,
                    hint: email,
                    textInputAction: TextInputAction.next,
                    validation: (String? val) => Validators.validateEmail(val),
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  InputTextFormField(
                    controller: _passwordController,
                    hint: password,
                    textInputAction: TextInputAction.next,
                    isSecureField: true,
                    validation: (String? val) =>
                        Validators.validateField(val, password),
                  ),
                  const SizedBox(
                    height: 12,
                  ),
                  InputTextFormField(
                    controller: _confirmPasswordController,
                    hint: confirmPassword,
                    isSecureField: true,
                    textInputAction: TextInputAction.go,
                    validation: (String? val) =>
                        Validators.validatePasswordMatch(
                      val,
                      _passwordController.text,
                    ),
                    onFieldSubmitted: (_) => _onSignUp(context),
                  ),
                  const SizedBox(
                    height: 24,
                  ),
                  InputFormButton(
                    color: Colors.black87,
                    onClick: () => _onSignUp(context),
                    titleText: signUp,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  InputFormButton(
                    color: Colors.black87,
                    onClick: () {
                      Navigator.of(context).pop();
                    },
                    titleText: back,
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                ],
              ),
            ),
          ),
        ),
      )),
    );
  }

  void _onSignUp(BuildContext context) {
    if (_formKey.currentState!.validate()) {
      if (_passwordController.text != _confirmPasswordController.text) {
        EasyLoading.showError(passwordsDoNotMatch);
        return;
      }
      context.read<UserBloc>().add(SignUpUser(SignUpParams(
            firstName: _firstNameController.text,
            lastName: _lastNameController.text,
            email: _emailController.text,
            password: _passwordController.text,
          )));
    }
  }
}
