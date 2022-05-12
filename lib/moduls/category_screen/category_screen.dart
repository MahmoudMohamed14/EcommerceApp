import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:projectgraduate/models/category_model.dart';
import 'package:projectgraduate/moduls/layout_screen/layout_cubit/cubit_layout.dart';
import 'package:projectgraduate/moduls/layout_screen/layout_cubit/states_layout.dart';

class CategoriesScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CubitLayout,StateLayout>(
      listener: (context,state){},
      builder:(context,state){
        var cubit=CubitLayout.get(context);
        return ListView.separated(
            scrollDirection:Axis.vertical ,
            physics: BouncingScrollPhysics(),
            itemBuilder: (context,index)=>buildCategory(context,cubit.listAllCategory![index]),
            separatorBuilder:(context,index)=>SizedBox(width: 10,),
            itemCount: cubit.listAllCategory!.length);},


    );
  }
  Widget buildCategory(context,CategoryModel categoryModel){
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Row(


        children: [
          Image(
              width: 150,
              height: 150,
              image: NetworkImage('${categoryModel.image}')
          ),
          SizedBox(width: 10,),
          Text(
            '${categoryModel.category}',
            maxLines: 1,

            style: TextStyle(fontSize: 16,fontWeight: FontWeight.bold),
          ),
          Spacer(),
          Icon(Icons.arrow_forward_ios)
        ],
      ),
    );
  }
}