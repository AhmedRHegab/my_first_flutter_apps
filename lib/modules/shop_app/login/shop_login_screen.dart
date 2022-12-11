import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:untitled/layout/shop_app/shop_layout.dart';
import 'package:untitled/modules/shop_app/login/cubit/cubit.dart';
import 'package:untitled/modules/shop_app/login/cubit/states.dart';
import 'package:untitled/shared/network/local/cache_helper.dart';

import '../../../shared/components/components.dart';
import '../../../shared/components/constants.dart';
import '../register/shop_register_screen.dart';

class ShopLoginScreen extends StatelessWidget
{
   ShopLoginScreen({Key? key}) : super(key: key);

  final formKey = GlobalKey<FormState>();
   var emailController = TextEditingController();
   var passwordController = TextEditingController();

  @override
  Widget build(BuildContext context)
  {

    return BlocProvider(
      create: (BuildContext context) => ShopLoginCubit(),
      child: BlocConsumer<ShopLoginCubit, ShopLoginStates>(
        listener: (context, state)
        {
          if(state is ShopLoginSuccessState)
            {
              if(state.loginModel.status!)
                {
                  print(state.loginModel.message);
                  print(state.loginModel.data!.token);

                  CacheHelper.saveData(key: 'token',
                    value: state.loginModel.data!.token,
                  ).then((value) {

                    token = state.loginModel.data!.token;

                    navigateAndFinish(context, const ShopLayout(),);
                  });

                }else
                  {
                    print(state.loginModel.message);

                    showToast(
                      text: state.loginModel.message!,
                      state: ToastStates.ERROR,
                    );

                  }
            }
        },
        builder: (context, state)
        {
          return Scaffold(
            appBar: AppBar(),
            body: Center(
              child: SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Form(
                    key: formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'LOGIN',
                          style: Theme.of(context).textTheme.headline4?.copyWith(
                            color: Colors.black,
                            fontWeight: FontWeight.w600,
                          ),

                        ),
                        const SizedBox(
                          height: 5.0,
                        ),

                        Text(
                          'Login now to browse our hot offers',
                          style: Theme.of(context).textTheme.bodyText1?.copyWith(
                            color: Colors.grey,
                          ),
                        ),
                        const SizedBox(
                          height: 30.0,
                        ),
                        defaultFormField(
                          controller: emailController,
                          type: TextInputType.emailAddress,
                          validate: (dynamic value)
                          {
                            if(value!.isEmpty)
                            {
                              return 'please enter your email address';
                            }
                            return null;
                          },
                          label: 'Email Address',
                          prefix: Icons.email_outlined,
                        ),

                        const SizedBox(
                          height: 15.0,
                        ),

                        defaultFormField(
                          controller: passwordController,
                          type: TextInputType.visiblePassword,
                          suffix: ShopLoginCubit.get(context).suffix,
                          onSubmit: (value)
                          {
                            if(formKey.currentState!.validate())
                            {
                              ShopLoginCubit.get(context).userLogin(
                                email: emailController.text,
                                password: passwordController.text,
                              );
                            }
                          },
                          isPassword: ShopLoginCubit.get(context).isPassword,
                          suffixPressed: ()
                          {
                            ShopLoginCubit.get(context).changePasswordVisibility();
                          },
                          validate: (dynamic value)
                          {
                            if(value!.isEmpty)
                            {
                              return 'password is too short';
                            }
                            return null;
                          },
                          label: 'password',
                          prefix: Icons.lock_outline,
                        ),

                        const SizedBox(
                          height: 15.0,
                        ),

                        ConditionalBuilder(
                          condition: state is! ShopLoginLoadingState,
                          builder: (context) => defaultButton(
                            function: ()
                            {
                              if(formKey.currentState!.validate())
                              {
                                ShopLoginCubit.get(context).userLogin(
                                  email: emailController.text,
                                  password: passwordController.text,
                                );
                              }

                            },
                            text: 'login',
                            isUpperCase: true,
                          ),
                          fallback: (context) => const Center(child: CircularProgressIndicator()),
                        ),

                        const SizedBox(
                          height: 15.0,
                        ),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children:  [
                            const Text(
                              'Don\'t have an account?',
                            ),

                            defaultTextButton(
                              function: ()
                              {
                                navigateTo(context, ShopRegisterScreen(),);
                              },
                              text: 'register now',
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

