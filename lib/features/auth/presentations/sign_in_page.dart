import 'package:capture/features/auth/cubit/auth_cubit.dart';
import 'package:capture/features/auth/cubit/sign_in_cubit.dart';
import 'package:capture/features/auth/presentations/sign_up_page.dart';
import 'package:capture/features/auth/repository/auth_repositry.dart';
import 'package:capture/services/app_router.dart';
import 'package:capture/utils/data_state.dart';
import 'package:capture/utils/load_status.dart';
import 'package:capture/widgets/my_button.dart';
import 'package:capture/widgets/my_text_field.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class SignInPage extends StatefulWidget {
  const SignInPage({Key? key}) : super(key: key);

  @override
  State<SignInPage> createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final GlobalKey<FormState> _formKey = GlobalKey();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: BlocConsumer<SignInCubit, DataState<String>>(
        listener: (_, state) {
          if (state.status == LoadStatus.success) {
            // final data = state.data;
            context
                .read<AuthCubit>()
                .setAuthenticated('BHDSFIUECMSD,MXVJOIEJWJOIEJOIEWOF');
            // context.read<AuthCubit>().setAuthenticated(data['access_token']);
          }
        },
        builder: (contex, state) {
          return Form(
            key: _formKey,
            child: Container(
              padding: const EdgeInsets.only(left: 24, right: 24),
              child: Column(
                children: [
                  Expanded(
                    child: ListView(
                      children: <Widget>[
                        const Center(
                          child: Text(
                            'Sign in',
                            style: TextStyle(
                              fontSize: 20,
                              fontFamily: 'Poppins',
                              fontWeight: FontWeight.w600,
                              height: 0,
                            ),
                          ),
                        ),
                        const SizedBox(height: 50),
                        MyTextField(
                          controller: _emailController,
                          labelText: 'Email',
                          // errorText: extractErrorMessageFromError(emailError),
                          bgColor:
                              Theme.of(context).colorScheme.primaryContainer,
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
                          textColor: Theme.of(context).colorScheme.onSurface,
                        ),
                        const SizedBox(height: 16),
                        MyTextField(
                          controller: _passwordController,
                          labelText: 'Password',
                          // errorText: extractErrorMessageFromError(passwordError),
                          bgColor:
                              Theme.of(context).colorScheme.primaryContainer,
                          type: TextFieldType.password,
                          obscureText: true,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your password';
                            }
                            return null;
                          },
                          filled: true,
                          textColor: Theme.of(context).colorScheme.onSurface,
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
                          text: "Login",
                          verticalPadding: 25,
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              context.read<SignInCubit>().signIn(
                                  _emailController.text,
                                  _passwordController.text);
                            }
                          },
                        ),
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              'Don’t have account ?',
                              style: TextStyle(
                                fontSize: 13,
                                fontFamily: 'Poppins',
                                fontWeight: FontWeight.w400,
                                height: 0,
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                context.push(Destination.signUpPath);
                              },
                              child: const Text(
                                ' Sign up',
                                style: TextStyle(
                                  color: Color(0xFF304AAC),
                                  fontSize: 13,
                                  fontFamily: 'Poppins',
                                  fontWeight: FontWeight.w600,
                                  height: 0,
                                ),
                              ),
                            ),
                          ],
                        ),
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
                              color:
                                  Colors.black.withOpacity(0.699999988079071),
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
                                  fit: BoxFit.fill,
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
                                  fit: BoxFit.fill,
                                  image:
                                      AssetImage('assets/images/logo_fb.png'),
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
                                  fit: BoxFit.fill,
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
          );
        },
      ),
    );
  }
}
