
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:projectgraduate/models/product_model.dart';
import 'package:projectgraduate/moduls/home/home_screen.dart';


import 'package:projectgraduate/moduls/layout_screen/layout_cubit/cubit_layout.dart';
import 'package:projectgraduate/moduls/layout_screen/layout_cubit/states_layout.dart';
import 'package:projectgraduate/moduls/login/login_screen.dart';
import 'package:projectgraduate/shared/componant/componant.dart';

import 'package:projectgraduate/shared/constant/color_manager.dart';
import 'package:projectgraduate/shared/constant/icon_broken.dart';


class LayoutScreen extends StatelessWidget {





  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CubitLayout,StateLayout>(
        listener: (context ,state){

    },
    builder: (context ,state){


          var cubit =CubitLayout.get(context);
    return Scaffold(


bottomNavigationBar:  CurvedNavigationBar(
  backgroundColor: ColorManager.white,
  color:  ColorManager.primary,
  index: cubit.index,
  items: <Widget>[
    Icon(IconBroken.Category, size: 30,color: ColorManager.white,),
    Icon(IconBroken.Home, size: 30,color: ColorManager.white,),
    Icon( IconBroken.Buy, size: 30,color: ColorManager.white,),
  ],
  animationDuration: Duration(milliseconds: 300),
  onTap: (index) {
    cubit.changeBottomNav(index: index);
  },
  height: 50,
),
      appBar: AppBar(
        title: Text('${cubit.listTitle[cubit.index]}'),
        actions: [IconButton(icon: Icon(IconBroken.Logout),onPressed: (){
          signOut(context, LoginScreen());

        },)],
      ),
       body: cubit.listWidget[cubit.index],
    );
    },

    );
  }

}