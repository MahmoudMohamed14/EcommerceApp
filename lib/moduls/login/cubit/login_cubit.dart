

import 'package:bloc/bloc.dart';

import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  LoginCubit() : super(LoginInitState());

  bool isScure=true;
  IconData suffix=Icons.visibility;
  static LoginCubit get(context){
    return BlocProvider.of(context);
  }

  void passwordLogin(){

    isScure=!isScure;
    suffix=isScure?Icons.visibility:Icons.visibility_off;
    emit(LoginPasswordState());

  }

  void login({
    required String password,
    required String email,

  }){
    emit(LoginLoadingState());

    FirebaseAuth.instance.signInWithEmailAndPassword(email: email, password: password).then((value) {




      emit(LoginSuccessState(uId:value.user!.uid  ));
    }).catchError((error){
      print('error Login'+error.toString());
      emit(LoginErrorState(error: error.toString()));

    });


  }
// void getClassName(){
//   listClassName=[];
//   FirebaseFirestore.instance.collection('className').get()
//       .then((value) {
//     value.docs.forEach((element) {
//      listClassName.add(element.reference.path.split('/').last);
//
//     });
//     emit(GetClassNameSuccessState());
//     print('list+ $listClassName');
//
//
//
//   }).catchError((error){
//     print('erroe  '+error.toString());
//     emit(GetClassNameSuccessState());
//   });
//
// }

}