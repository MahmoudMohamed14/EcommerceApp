
import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:projectgraduate/models/user_model.dart';
import 'package:projectgraduate/moduls/layout_screen/layout_cubit/cubit_layout.dart';
import 'package:projectgraduate/moduls/layout_screen/layout_cubit/states_layout.dart';
import 'package:projectgraduate/shared/componant/componant.dart';
import 'package:projectgraduate/shared/constant/color_manager.dart';

class RequestAdminScreen extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CubitLayout,StateLayout>(
        listener: (context,state){},
      builder:(context,state){
          var cubit=CubitLayout.get(context);
          return ConditionalBuilder(
            condition: cubit.listAllUser.isNotEmpty,
            builder: (context)=>Padding(
              padding: const EdgeInsets.all(20),
              child:ListView.separated(
                  itemBuilder: (context,index)=>requestAdminBulidItem(context,cubit.listAllUser[index]),
                  separatorBuilder: (context,index)=>SizedBox(height: 20,),
                  itemCount: cubit.listAllUser.length) ,
            ),
            fallback:(context)=> Center(child: Text('No Request',style: Theme.of(context).textTheme.headline2,))  ,
          );
      } ,

    );
  }
  Widget requestAdminBulidItem(context,UsersModel usersModel){
    return Container(
      padding:const EdgeInsets.all(10) ,
      decoration: BoxDecoration(
          color: ColorManager.lightGrey.withOpacity(.3),
          borderRadius: BorderRadius.circular(20)

      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('${usersModel.name}',style: Theme.of(context).textTheme.headline1,),
          SizedBox(height: 5,),
          Text('${usersModel.phone}',style: Theme.of(context).textTheme.subtitle1,),
          SizedBox(height: 20,),
          Row(
            children: [
              Expanded(child: defaultButton(onPress:(){
                CubitLayout.get(context).acceptRequestAdmin(id: usersModel.id!);
              } , name: 'Accept',color: Colors.green)),
              SizedBox(width: 20,),
              Expanded(child: defaultButton(onPress:(){
                CubitLayout.get(context).cancelRequestAdmin(id: usersModel.id!);
              } , name: 'No',color: Colors.red)),
            ],
          )

        ],),
    );

  }
}