import 'dart:convert';
import 'dart:io';

import 'package:capture/features/auth/cubit/auth_cubit.dart';
import 'package:capture/features/auth/cubit/sign_up_cubit.dart';
import 'package:capture/helpers/helpers.dart';
import 'package:capture/utils/data_state.dart';
import 'package:capture/utils/load_status.dart';
import 'package:capture/widgets/loading_progress.dart';
import 'package:capture/widgets/my_button.dart';
import 'package:capture/widgets/my_text_field.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _passwordConfirmController =
      TextEditingController();

  String? nameError;
  String? emailError;
  String? passwordError;
  String? passwordConfirmError;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.background,
        foregroundColor: Theme.of(context).colorScheme.onBackground,
        elevation: 0.0,

        // nameError = json["error"]["name"];
        // emailError = json["error"]["email"];
        // passwordError = json["error"]["password"];
        // passwordConfirmError = json['error']["confirm_password"];
      ),
      body: BlocConsumer<SignUpCubit, DataState<String>>(
        listener: (_, state) {
          setState(() {
            emailError = null;
            passwordError = null;
            passwordConfirmError = null;
            nameError = null;
          });
          if (state.status == LoadStatus.success) {
            final data = state.data;
            showDialogInfo(
              context,
              () {
                context.read<AuthCubit>().setAuthenticated(data['token']);
              },
              message: data['message'] ?? 'Registration success!',
            );
          } else if (state.status == LoadStatus.failure) {
            String errorMessage = '';
            var exception = state.error;
            if (exception?.response != null) {
              if (exception?.response?.statusCode ==
                  HttpStatus.unprocessableEntity) {
                final Map<String, dynamic> json =
                    jsonDecode(exception!.response.toString());
                setState(() {
                  nameError = json["error"]["nama"];
                  emailError = json["error"]["email"];
                  passwordError = json["error"]["password"];
                  passwordConfirmError = json['error']["confirm_password"];
                });
              } else {
                errorMessage = extractErrorMessage(exception);
                showDialogMsg(context, errorMessage);
              }
            } else {
              errorMessage =
                  (DioExceptionType.connectionError == exception?.type)
                      ? "Connection Error"
                      : "Something went wrong!";
              showDialogMsg(context, errorMessage);
            }
          }
        },
        builder: (context, state) {
          return Form(
            key: _formKey,
            child: Stack(
              children: [
                Container(
                  margin: const EdgeInsets.only(left: 24, right: 24),
                  child: Column(
                    children: [
                      Expanded(
                        child: ListView(
                          children: <Widget>[
                            const Center(
                              child: Text(
                                'Create Account',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w600,
                                  height: 0,
                                ),
                              ),
                            ),
                            const SizedBox(height: 50),
                            MyTextField(
                              controller: _nameController,
                              labelText: 'Name',
                              errorText: nameError,
                              bgColor: Theme.of(context)
                                  .colorScheme
                                  .primaryContainer,
                              type: TextFieldType.normal,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your name';
                                }
                                return null;
                              },
                              filled: true,
                              textColor:
                                  Theme.of(context).colorScheme.onSurface,
                            ),
                            const SizedBox(height: 16),
                            MyTextField(
                              controller: _emailController,
                              labelText: 'Email',
                              errorText: emailError,
                              bgColor: Theme.of(context)
                                  .colorScheme
                                  .primaryContainer,
                              type: TextFieldType.email,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your email address';
                                }
                                // Use a regular expression to validate the email format
                                final emailRegExp = RegExp(
                                    r'^[\w-]+(\.[\w-]+)*@[\w-]+(\.[\w-]+)+$');
                                if (!emailRegExp.hasMatch(value)) {
                                  return 'Please enter a valid email address';
                                }
                                return null;
                              },
                              filled: true,
                              textColor:
                                  Theme.of(context).colorScheme.onSurface,
                            ),
                            const SizedBox(height: 16),
                            MyTextField(
                              controller: _passwordController,
                              labelText: 'Password',
                              errorText: passwordError,
                              bgColor: Theme.of(context)
                                  .colorScheme
                                  .primaryContainer,
                              type: TextFieldType.password,
                              obscureText: true,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your password';
                                }
                                return null;
                              },
                              filled: true,
                              textColor:
                                  Theme.of(context).colorScheme.onSurface,
                            ),
                            const SizedBox(height: 16),
                            MyTextField(
                              controller: _passwordConfirmController,
                              labelText: 'Confirmation Password',
                              errorText: passwordConfirmError,
                              bgColor: Theme.of(context)
                                  .colorScheme
                                  .primaryContainer,
                              type: TextFieldType.password,
                              obscureText: true,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter your confirmation password';
                                } else if (value != _passwordController.text) {
                                  return 'Passwords do not match';
                                }
                                return null;
                              },
                              filled: true,
                              textColor:
                                  Theme.of(context).colorScheme.onSurface,
                            ),
                            const SizedBox(height: 16),
                            GestureDetector(
                              onTap: () {
                                if (kDebugMode) {
                                  print('Forgot Password!');
                                }
                              },
                              child: const Text(
                                'Forget your Password?',
                                textAlign: TextAlign.right,
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w400,
                                  decoration: TextDecoration.underline,
                                  height: 0,
                                  letterSpacing: 0.26,
                                ),
                              ),
                            ),
                            const SizedBox(height: 25),
                            MyButton(
                              text: "Submit",
                              verticalPadding: 25,
                              onPressed: () {
                                // if (_formKey.currentState!.validate()) {
                                context.read<SignUpCubit>().signUp(
                                    _nameController.text,
                                    _emailController.text,
                                    _passwordController.text,
                                    _passwordConfirmController.text);
                                // }
                              },
                            ),
                            const SizedBox(height: 16),
                          ],
                        ),
                      ),
                      Column(
                        children: [
                          const SizedBox(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(
                                width: 110,
                                height: 1,
                                decoration: ShapeDecoration(
                                  color: const Color(0x7FC4C4C4),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(1)),
                                ),
                              ),
                              Text(
                                'or Login with',
                                style: TextStyle(
                                  color: Colors.black
                                      .withOpacity(0.699999988079071),
                                  fontSize: 14,
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.w400,
                                  height: 0.07,
                                  letterSpacing: -0.14,
                                ),
                              ),
                              Container(
                                width: 110,
                                height: 1,
                                decoration: ShapeDecoration(
                                  color: const Color(0x7FC4C4C4),
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(1)),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 25),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  if (kDebugMode) {
                                    print('Login Google!');
                                  }
                                },
                                child: Container(
                                  width: 30.56,
                                  height: 30.56,
                                  margin: const EdgeInsets.all(5),
                                  decoration: const BoxDecoration(
                                    image: DecorationImage(
                                      fit: BoxFit.fitHeight,
                                      image: AssetImage(
                                          'assets/images/logo_google.png'),
                                    ),
                                  ),
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  if (kDebugMode) {
                                    print('Loginn Facebook!');
                                  }
                                },
                                child: Container(
                                  width: 30.56,
                                  height: 30.56,
                                  margin: const EdgeInsets.all(5),
                                  decoration: const BoxDecoration(
                                    image: DecorationImage(
                                      fit: BoxFit.fitHeight,
                                      image: AssetImage(
                                          'assets/images/logo_fb.png'),
                                    ),
                                  ),
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  if (kDebugMode) {
                                    print('Login Apple!');
                                  }
                                },
                                child: Container(
                                  width: 30.56,
                                  height: 30.56,
                                  margin: const EdgeInsets.all(5),
                                  decoration: const BoxDecoration(
                                    image: DecorationImage(
                                      fit: BoxFit.fitHeight,
                                      image: AssetImage(
                                          'assets/images/logo_apple.png'),
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 50),
                        ],
                      )
                    ],
                  ),
                ),
                if (state.status == LoadStatus.loading) const LoadingProgress(),
              ],
            ),
          );
        },
      ),
    );
  }
}
