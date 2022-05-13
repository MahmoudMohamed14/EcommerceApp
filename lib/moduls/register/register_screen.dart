// ignore_for_file: use_key_in_widget_constructors, prefer_const_constructors


import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:projectgraduate/moduls/layout_screen/layout_screan.dart';
import 'package:projectgraduate/moduls/register/cubit/register_cubit.dart';
import 'package:projectgraduate/moduls/register/cubit/register_states.dart';

import '../../shared/componant/componant.dart';
import '../../shared/constant/color_manager.dart';
import '../../shared/constant/test_styles_manager.dart';
import '../../shared/language/applocale.dart';
import '../home/home_screen.dart';





class Register extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    var email=TextEditingController();
    var name=TextEditingController();
    var phone=TextEditingController();
    var password=TextEditingController();
    var keyForm= GlobalKey<FormState>();






    return BlocProvider(
      create: (context)=>RegisterCubit(),
      child: BlocConsumer<RegisterCubit,RegisterStates>(
          listener: (context,state){
            if(state is CreateUserSuccessState||state is PostClassNameSuccessState){
               navigateAndFinish(context, LayoutScreen());
              // CubitApp.get(context).init();
              showToast(text: 'Create Successful', state: ToastState.SUCCESS);

            }  if (state is CreateUserErrorState)
            {


              showToast(text:state.error! , state: ToastState.ERROR);
            }
            if (state is RegisterErrorState)
            {
              showToast(text:state.error! , state: ToastState.ERROR);
            }if (state is PostClassNameErrorState)
            {
              showToast(text:state.error! , state: ToastState.ERROR);
            }


          },
          builder:(context,state){
            var cubit=RegisterCubit.get(context);
           // isTeacher = cubit.isTeacher;
            return  Scaffold(
              appBar: AppBar(

              ),

              body: SingleChildScrollView(

                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Form(
                    key: keyForm,
                    child: Column(

                      children:  [

                        Text('${getLang(context, "register_name")}',style:Theme.of(context).textTheme.headline1!.copyWith(fontSize: 24),),
                        SizedBox(height: 20,),
                        defaultEditText(
                            control: name,
                            textType: TextInputType.name,
                            prefIcon: Icons.title,
                            label: '${getLang(context, "name")}',
                            validat: (s){
                              if(s!.isEmpty){
                                return'${getLang(context, "name_empty")}';
                              }
                              return null;

                            }
                        ),
                        SizedBox(height: 20,),
                        defaultEditText(
                            control: email,
                            textType: TextInputType.emailAddress,
                            prefIcon: Icons.email,
                            label: '${getLang(context, "email_name")}',
                            validat: (s){
                              if(s!.isEmpty){
                                return'${getLang(context, "email_empty")}';
                              }
                              return null;

                            }
                        ),
                        SizedBox(height: 20,),
                        defaultEditText(
                            control: phone,
                            textType: TextInputType.phone,
                            prefIcon: Icons.phone,
                            label: '${getLang(context, "phone_name")}',
                            validat: (s){
                              if(s!.isEmpty){
                                return'${getLang(context, "phone_empty")}';
                              }
                              return null;

                            }
                        ),

                        SizedBox(height: 20,),

                        defaultEditText(
                            control: password,
                            textType: TextInputType.visiblePassword,
                            prefIcon: Icons.lock,
                            label: '${getLang(context, "password_name")}',
                            validat: (s){
                              if(s!.isEmpty){
                                return'${getLang(context, "password_empty")}';
                              }else if(s.length<8){
                                return '${getLang(context, "validate_password")}';
                              }


                              return null;

                            }
                        ),
                        SizedBox(height: 20,),
                        Container(
                          padding:const EdgeInsets.symmetric(horizontal: 12,vertical: 4),
                          width: double.infinity,
                          height: 60,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(color: ColorManager.primary)

                          ),
                          child: DropdownButton(

                              isExpanded: true,
                              iconSize: 40,


                              value: cubit.isAdmin,// RegisterCubit.get(context).isTeacher,


                              onChanged: ( value){
                                RegisterCubit.get(context).radioButton(admin: value);

                              },

                              items:[
                                DropdownMenuItem<bool>(child: Text('Admin',style: getBoldStyle(color: ColorManager.primary,)),value: true,),
                                DropdownMenuItem<bool>(child: Text('Customer',style: getBoldStyle(color: ColorManager.primary,)),value: false,),
                              ]
                          ),
                        ),
                        SizedBox(height: 20,),

                        state is RegisterLoadingState? CircularProgressIndicator()
                            :defaultButton(onPress: (){


                          if(keyForm.currentState!.validate()){

                              cubit.registerUser(name: name.text, email: email.text, password: password.text,isAdmin: cubit.isAdmin!,phone: phone.text);

                          }else{

                          }

                        }, name: '${getLang(context, "register_name")}'),







                      ],

                    ),
                  ),
                ),
              ),
            );}

      ),
    );
  }
}
