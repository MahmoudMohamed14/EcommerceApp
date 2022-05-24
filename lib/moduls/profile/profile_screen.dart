import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:projectgraduate/moduls/layout_screen/layout_cubit/cubit_layout.dart';
import 'package:projectgraduate/moduls/layout_screen/layout_cubit/states_layout.dart';
import 'package:projectgraduate/shared/componant/componant.dart';
import 'package:projectgraduate/shared/language/applocale.dart';
import 'package:projectgraduate/shared/network/local/cache_helper.dart';

class ProfileScreen extends StatelessWidget {

  var name=TextEditingController();
  var phone=TextEditingController();
  var keyForm= GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    name.text=CubitLayout.get(context).myData?.name??'';
    phone.text=CubitLayout.get(context).myData?.phone??'';
    return BlocConsumer<CubitLayout,StateLayout>(
        listener: (context,state){},
    builder:(context,state){
    var cubit=CubitLayout.get(context);
    return Scaffold(
      appBar:CacheHelper.getData(key: 'admin')?null: AppBar(title: Text('Profile'),),
      body: Form(
        key: keyForm,


        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
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
                  control: phone,
                  textType: TextInputType.phone,
                  prefIcon: Icons.phone,
                  label: '${getLang(context, "phone_name")}',
                  validat: (s){
                    if(s!.isEmpty){
                      return'${getLang(context, "phone_empty")}';
                    }else if(s.length<11){
                      return'Must less than 11 number';
                    }
                    return null;

                  }
              ),
              SizedBox(height: 20,),
              defaultButton(onPress: (){
                if(keyForm.currentState!.validate()) cubit.updateUser(name: name.text,phone: phone.text);
              }, name: 'Update')

            ],
          ),
        ),
      ),
    )
    ;});
  }
}
