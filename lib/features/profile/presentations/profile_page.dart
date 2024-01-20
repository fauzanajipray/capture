import 'package:capture/features/auth/cubit/auth_cubit.dart';
import 'package:capture/helpers/helpers.dart';
import 'package:capture/widgets/my_button.dart';
import 'package:capture/widgets/my_text_field.dart';
import 'package:extended_image/extended_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _telpController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _passwordConfirmController =
      TextEditingController();

  bool isEdit = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Profile'),
        actions: [
          if (isEdit)
            IconButton(
                onPressed: () {
                  setState(() {
                    isEdit = !isEdit;
                  });
                },
                icon: const Icon(Icons.save)),
        ],
      ),
      body: ListView(
        children: [
          const SizedBox(height: 16),
          ListTile(
            title: Text(
              'Fiola Stephani',
              style: TextStyle(
                color: Colors.black.withOpacity(0.800000011920929),
                fontSize: 18,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w700,
                height: 0.05,
                letterSpacing: 0.18,
              ),
            ),
            subtitle: Text(
              'Fiolastephani10',
              style: TextStyle(
                color: Colors.black.withOpacity(0.800000011920929),
                fontSize: 16,
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w400,
                height: 0.06,
                letterSpacing: 0.16,
              ),
            ),
            trailing: (!isEdit)
                ? IconButton(
                    onPressed: () {
                      setState(() {
                        isEdit = !isEdit;
                      });
                    },
                    icon: const Icon(Icons.edit))
                : null,
            leading: ClipOval(
              child: Container(
                color: Theme.of(context).colorScheme.secondary,
                width: 60.0,
                height: 60.0,
                child: ExtendedImage.network(
                  "https://via.placeholder.com/60x60",
                  // headers: {"Authorization": token},
                  compressionRatio: kIsWeb ? null : 0.2,
                  clearMemoryCacheWhenDispose: true,
                  cache: true,
                  fit: BoxFit.cover,
                  loadStateChanged: (ExtendedImageState state) {
                    if (state.extendedImageLoadState == LoadState.completed) {
                      return state.completedWidget;
                    } else {
                      return Center(
                          child: Text(
                        'PP',
                        style: TextStyle(
                            fontSize: 18,
                            color: Theme.of(context).colorScheme.onSecondary),
                      ));

                      // return Center(
                      //   child: Text(
                      //     widget.item.name != null
                      //         ? widget.item.name!.length == 1
                      //             ? widget.item.name!.toUpperCase()
                      //             : widget.item.name!
                      //                 .substring(0, 2)
                      //                 .toUpperCase()
                      //         : '',
                      //     style: TextStyle(
                      //         color: Theme.of(context).colorScheme.onSecondary),
                      //   ),
                      // );
                    }
                  },
                ),
              ),
            ),
          ),
          Container(
            margin: const EdgeInsets.all(16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
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
                  filled: false,
                  textColor: Theme.of(context).colorScheme.onSurface,
                ),
                const SizedBox(height: 16),
                MyTextField(
                  controller: _telpController,
                  labelText: 'Telephone',
                  // errorText: extractErrorMessageFromError(emailError),
                  bgColor: Theme.of(context).colorScheme.primaryContainer,
                  type: TextFieldType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your telphone number';
                    }
                    return null;
                  },
                  filled: false,
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
                  filled: false,
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
                  filled: false,
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
                  filled: false,
                  textColor: Theme.of(context).colorScheme.onSurface,
                ),
                const SizedBox(height: 50),
                Center(
                    child: SizedBox(
                  width: 120,
                  height: 43,
                  child: MyButton(
                    onPressed: () {
                      showDialogConfirmationDelete(
                        context,
                        () => context.read<AuthCubit>().setUnauthenticated(),
                        message: 'Are you sure you want to log out?',
                        errorBtn: 'Confirm',
                      );
                    },
                    text: 'Logout',
                    verticalPadding: 10,
                  ),
                ))
              ],
            ),
          ),
        ],
      ),
    );
  }
}
