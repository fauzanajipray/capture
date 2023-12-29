import 'package:capture/widgets/my_button.dart';
import 'package:capture/widgets/my_text_field.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Form(
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
                      // errorText: extractErrorMessageFromError(emailError),
                      bgColor: Theme.of(context).colorScheme.primaryContainer,
                      type: TextFieldType.normal,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your name';
                        }
                        return null;
                      },
                      filled: true,
                      textColor: Theme.of(context).colorScheme.onSurface,
                    ),
                    const SizedBox(height: 16),
                    MyTextField(
                      controller: _emailController,
                      labelText: 'Email',
                      // errorText: extractErrorMessageFromError(emailError),
                      bgColor: Theme.of(context).colorScheme.primaryContainer,
                      type: TextFieldType.email,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your email address';
                        }
                        // Use a regular expression to validate the email format
                        final emailRegExp =
                            RegExp(r'^[\w-]+(\.[\w-]+)*@[\w-]+(\.[\w-]+)+$');
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
                      bgColor: Theme.of(context).colorScheme.primaryContainer,
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
                    MyTextField(
                      controller: _passwordConfirmController,
                      labelText: 'Confirmation Password',
                      // errorText: extractErrorMessageFromError(passwordError),
                      bgColor: Theme.of(context).colorScheme.primaryContainer,
                      type: TextFieldType.password,
                      obscureText: true,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your confirmation password';
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
                          // context
                          //     .read<SignInCubit>()
                          //     .signIn(_emailController.text, _passwordController.text);
                        }
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
                          color: Colors.black.withOpacity(0.699999988079071),
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
                              image:
                                  AssetImage('assets/images/logo_google.png'),
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
                              image: AssetImage('assets/images/logo_fb.png'),
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
                              image: AssetImage('assets/images/logo_apple.png'),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  /*
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Do you have account?',
                        style: TextStyle(
                          fontSize: 13,
                          fontFamily: 'Poppins',
                          fontWeight: FontWeight.w400,
                          height: 0,
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const SignUpPage()),
                          );
                          if (kDebugMode) {
                            print('Sign In!');
                          }
                        },
                        child: const Text(
                          ' Sign in',
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
                  */
                  const SizedBox(height: 50),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
