import 'package:capture/features/auth/cubit/auth_cubit.dart';
import 'package:capture/features/profile/cubit/profile_cubit.dart';
import 'package:capture/features/profile/cubit/profile_update_cubit.dart';
import 'package:capture/features/profile/models/profile.dart';
import 'package:capture/helpers/helpers.dart';
import 'package:capture/utils/data_state.dart';
import 'package:capture/utils/load_status.dart';
import 'package:capture/widgets/error_data.dart';
import 'package:capture/widgets/loading_progress.dart';
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
  final GlobalKey<FormState> _formKey = GlobalKey();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _telpController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _passwordConfirmController =
      TextEditingController();

  bool isEdit = false;

  late Profile _request;
  late Profile _requestTemp;
  late ProfileCubit _profileCubit;
  late ProfileUpdateCubit _profileUpdateCubit;

  @override
  void initState() {
    _request = Profile();
    _profileCubit = context.read<ProfileCubit>();
    _profileUpdateCubit = context.read<ProfileUpdateCubit>();
    initAsyncData();
    super.initState();
  }

  void initAsyncData() async {
    await _profileCubit.getProfile();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Profile'),
        actions: [
          if (isEdit)
            TextButton(
              onPressed: () {
                setState(() {
                  isEdit = !isEdit;
                  _request = _requestTemp;
                  _nameController.text = _requestTemp.nama ?? '';
                  _usernameController.text = _requestTemp.username ?? '';
                  _emailController.text = _requestTemp.email ?? '';
                  _telpController.text = _requestTemp.phone ?? '';
                  _passwordController.text = '';
                  _passwordConfirmController.text = '';
                });
              },
              child: const Text(
                'Cancel',
                style: TextStyle(color: Colors.white),
              ),
            ),
          if (isEdit)
            TextButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  _profileUpdateCubit.update(_request);
                  setState(() {
                    isEdit = !isEdit;
                  });
                }
              },
              child: const Text(
                'Save',
                style: TextStyle(color: Colors.white),
              ),
            ),
          if (!isEdit)
            TextButton(
              onPressed: () {
                setState(() {
                  isEdit = !isEdit;
                });
              },
              child: const Text(
                'Edit',
                style: TextStyle(color: Colors.white),
              ),
            ),
        ],
      ),
      body: BlocConsumer<ProfileCubit, DataState<Profile>>(
        listener: (context, state) {
          if (state.status == LoadStatus.success) {
            Profile? item = state.item;
            if (item != null) {
              setState(() {
                _request = item;
                _requestTemp = item;
                _nameController.text = item.nama ?? '';
                _usernameController.text = item.username ?? '';
                _emailController.text = item.email ?? '';
                _telpController.text = item.phone ?? '';
              });
            }
          }
        },
        builder: (context, state) {
          if (state.status == LoadStatus.initial ||
              state.status == LoadStatus.loading) {
            if (state.item == null) {
              return const LoadingProgress();
            } else {
              return Container();
            }
          } else if (state.status == LoadStatus.failure) {
            return Center(
                child: errorData(context, state.error,
                    onRetry: () => _profileCubit.getProfile()));
          }
          return BlocConsumer<ProfileUpdateCubit, DataState<Profile>>(
            listener: (context, stateUpdate) {
              if (stateUpdate.status == LoadStatus.success) {
                setState(() {
                  // _errorProfileUpdate = ErrorProfile();
                  _request = stateUpdate.item ?? Profile();
                  _requestTemp = stateUpdate.item ?? Profile();
                  _nameController.text = stateUpdate.item?.nama ?? '';
                  _usernameController.text = stateUpdate.item?.username ?? '';
                  _telpController.text = stateUpdate.item?.phone ?? '';
                  _emailController.text = stateUpdate.item?.email ?? '';
                });
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Successfully updated profile'),
                    duration: Duration(seconds: 2),
                  ),
                );
              } else if (stateUpdate.status == LoadStatus.failure) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Error update profile'),
                    duration: Duration(seconds: 2),
                  ),
                );
              }
            },
            builder: (context, stateUpdate) {
              return ListView(
                children: [
                  const SizedBox(height: 16),
                  ListTile(
                    title: Text(
                      _request.nama ?? '',
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
                      _request.username ?? '',
                      style: TextStyle(
                        color: Colors.black.withOpacity(0.800000011920929),
                        fontSize: 16,
                        fontFamily: 'Poppins',
                        fontWeight: FontWeight.w400,
                        height: 0.06,
                        letterSpacing: 0.16,
                      ),
                    ),
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
                            if (state.extendedImageLoadState ==
                                LoadState.completed) {
                              return state.completedWidget;
                            } else {
                              return Center(
                                  child: Text(
                                'PP',
                                style: TextStyle(
                                    fontSize: 18,
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onSecondary),
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
                  Form(
                    key: _formKey,
                    child: Container(
                      margin: const EdgeInsets.all(16),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          MyTextField(
                            controller: _nameController,
                            labelText: 'Name',
                            // errorText: extractErrorMessageFromError(emailError),
                            bgColor:
                                Theme.of(context).colorScheme.primaryContainer,
                            type: TextFieldType.normal,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your name';
                              }
                              return null;
                            },
                            readOnly: !isEdit,
                            filled: false,
                            textColor: Theme.of(context).colorScheme.onSurface,
                            onChange: (value) {
                              setState(() {
                                _request.nama = value;
                              });
                            },
                          ),
                          const SizedBox(height: 16),
                          MyTextField(
                            controller: _usernameController,
                            labelText: 'Username',
                            // errorText: extractErrorMessageFromError(emailError),
                            bgColor:
                                Theme.of(context).colorScheme.primaryContainer,
                            type: TextFieldType.normal,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your username';
                              }
                              return null;
                            },
                            readOnly: !isEdit,
                            filled: false,
                            textColor: Theme.of(context).colorScheme.onSurface,
                            onChange: (value) {
                              setState(() {
                                _request.username = value;
                              });
                            },
                          ),
                          const SizedBox(height: 16),
                          MyTextField(
                            controller: _telpController,
                            labelText: 'Telephone',
                            // errorText: extractErrorMessageFromError(emailError),
                            bgColor:
                                Theme.of(context).colorScheme.primaryContainer,
                            type: TextFieldType.number,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your telphone number';
                              }
                              return null;
                            },
                            readOnly: !isEdit,
                            filled: false,
                            textColor: Theme.of(context).colorScheme.onSurface,
                            onChange: (value) {
                              setState(() {
                                _request.phone = value;
                              });
                            },
                          ),
                          const SizedBox(height: 16),
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
                            readOnly: !isEdit,
                            filled: false,
                            textColor: Theme.of(context).colorScheme.onSurface,
                            onChange: (value) {
                              setState(() {
                                _request.email = value;
                              });
                            },
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
                              String pass = value ?? '';
                              if (pass != '' && pass.length < 6) {
                                return 'Password must be at least 6 characters long';
                              }
                              return null;
                            },
                            readOnly: !isEdit,
                            filled: false,
                            textColor: Theme.of(context).colorScheme.onSurface,
                            onChange: (value) {
                              setState(() {
                                _request.password = value;
                              });
                            },
                          ),
                          const SizedBox(height: 16),
                          MyTextField(
                            controller: _passwordConfirmController,
                            labelText: 'Confirmation Password',
                            // errorText: extractErrorMessageFromError(passwordError),
                            bgColor:
                                Theme.of(context).colorScheme.primaryContainer,
                            type: TextFieldType.password,
                            obscureText: true,
                            validator: (value) {
                              String pass = value ?? '';
                              String password = _passwordController.text;
                              if (pass != password) {
                                return 'Passwords do not match';
                              }
                              return null;
                            },
                            readOnly: !isEdit,
                            filled: false,
                            textColor: Theme.of(context).colorScheme.onSurface,
                          ),
                        ],
                      ),
                    ),
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
              );
            },
          );
        },
      ),
    );
  }
}
