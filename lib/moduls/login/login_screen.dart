import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:projectgraduate/moduls/layout_screen/layout_screan.dart';
import 'package:projectgraduate/moduls/login/cubit/login_cubit.dart';
import 'package:projectgraduate/moduls/login/cubit/login_state.dart';
import 'package:projectgraduate/moduls/register/register_screen.dart';
import 'package:projectgraduate/shared/componant/componant.dart';
import 'package:projectgraduate/shared/constant/icon_broken.dart';
import 'package:projectgraduate/shared/language/applocale.dart';


class LoginScreen extends StatelessWidget {



  @override
  Widget build(BuildContext context) {
    TextEditingController? email= new TextEditingController();
    TextEditingController? password=new TextEditingController();
    var keyForm=GlobalKey<FormState>();




    return
      BlocProvider(
        create: (BuildContext context)=>LoginCubit(),

        child: BlocConsumer<LoginCubit,LoginState>(
          listener: (context,state){
            if(state is LoginSuccessState){

               navigateAndFinish(context, LayoutScreen());
              // CubitApp.get(context).init();




            }
            if(state is LoginErrorState)
            {
              showToast( state: ToastState.ERROR, text: state.error!);
            }



          },
          builder: (context,state){

            var cubit=LoginCubit.get(context);
            return Scaffold(

              body: Center(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(20),
                    child: Form(
                      key: keyForm,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Image(width: 200,
                              height: 200,
                              image: AssetImage('assets/image/login_photo.png')
                          ),

                          //  Text('${getLang(context, "login_name")}', style:Theme.of(context).textTheme.headline3!.copyWith(color: Colors.black),),
                          //  SizedBox(height: 10,),
                          // Text('login now to ', style:Theme.of(context).textTheme.bodyText1!.copyWith(color: Colors.black54,fontSize: 18),),

                          defaultEditText(
                              control: email,
                              validat: ( s){
                                if(s!.isEmpty){
                                  return'${getLang(context, "email_empty")}';
                                }
                                return null;
                              },
                              label: '${getLang(context, "email_name")}',
                              prefIcon: Icons.email_outlined,
                              textType: TextInputType.emailAddress
                          ),
                          SizedBox(height: 20,),
                          defaultEditText(control: password,
                              validat: ( s){
                                if(s.isEmpty){
                                  return'${getLang(context, "password_empty")}';
                                }
                                return null;
                              },
                              textType:TextInputType.visiblePassword,
                              enable: cubit.isScure,
                              sufIcon: cubit.suffix,
                              label: '${getLang(context, "password_name")}',

                              prefIcon:IconBroken.Lock ,//Icons.lock,
                              onPressSuffix: (){
                                cubit.passwordLogin();

                              }
                          ),
                          SizedBox(height: 30,),
                          state is LoginLoadingState?Center(child: CircularProgressIndicator()) : defaultButton(
                              onPress: (){
                                if(keyForm.currentState!.validate()){

                                  cubit.login(password: password.text, email: email.text);



                                  //here you code


                                }else{
                                }
                              },
                              name: '${getLang(context, "login_name")}'),
                          SizedBox(height: 15,),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text('${getLang(context, "noHaveAccount_name")}'),
                              defaultTextButton(onPress: (){

                                //  cubit.getClassName();
                                 navigateTo(context, Register());




                              }, name: '${getLang(context, "register_name")}')
                            ],),



                        ],),
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