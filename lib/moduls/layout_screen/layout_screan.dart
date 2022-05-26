
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:projectgraduate/moduls/addProduct/addproduct_screen.dart';
import 'package:projectgraduate/moduls/add_category/add_category_screen.dart';
import 'package:projectgraduate/moduls/layout_screen/layout_cubit/cubit_layout.dart';
import 'package:projectgraduate/moduls/layout_screen/layout_cubit/states_layout.dart';
import 'package:projectgraduate/moduls/login/login_screen.dart';
import 'package:projectgraduate/moduls/profile/profile_screen.dart';
import 'package:projectgraduate/shared/componant/componant.dart';

import 'package:projectgraduate/shared/constant/color_manager.dart';
import 'package:projectgraduate/shared/constant/data_shared.dart';
import 'package:projectgraduate/shared/constant/icon_broken.dart';
import 'package:projectgraduate/shared/language/applocale.dart';
import 'package:projectgraduate/shared/network/local/cache_helper.dart';



class LayoutScreen extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CubitLayout,StateLayout>(
        listener: (context ,state){

    },
    builder: (context ,state){


          var cubit =CubitLayout.get(context);
    return DefaultTabController(
      length: 3,
      child: Scaffold(

        drawer: Container(
          width: 200,
          child: Drawer(
            child:  ListView(


                children: [
                  UserAccountsDrawerHeader(

                    accountName: Text(cubit.myData?.name??'',style: TextStyle(color: Colors.white),),
                    accountEmail:Text(cubit.myData?.email??'',style: TextStyle(color: Colors.white)),
                    // currentAccountPicture: CircleAvatar(
                    //   child: Icon(Icons.person),
                    //   backgroundColor: Colors.white,
                    // ),

                  ),
                  if  ( !CacheHelper.getData(key: 'admin') ) InkWell(
                    onTap: (){
                      navigateTo(context, ProfileScreen());
                    },
                    child: Padding(
                       padding: const EdgeInsets.all(10),
                       child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,

                        children: [
                          Icon(IconBroken.Setting,),
                          const SizedBox(width: 7,),
                          Text('Profile',style: TextStyle(color: ColorManager.primary),),
                        ],
                    ),
                     ),
                  ),
                if  ( CacheHelper.getData(key: 'admin') ) Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(10),
                        child: InkWell(
                          onTap: (){
                            navigateTo(context, AddCategoryScreen());
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,

                            children: [
                              Icon(IconBroken.Plus,),
                              const SizedBox(width: 7,),
                              Text( 'Add Category',style: TextStyle(color: ColorManager.primary),),
                            ],
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: (){
                          navigateTo(context, AddProductScreen());
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,

                            children: [
                              Icon(IconBroken.Plus,),
                              const SizedBox(width: 7,),
                              Text( 'Add Product',style: TextStyle(color: ColorManager.primary),),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),




                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: InkWell(
                      onTap: (){
                        signOut(context,LoginScreen());
                      },
                      child: Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(10),

                        decoration: BoxDecoration(

                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(color: Colors.red)
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,

                          children: [
                            Icon(Icons.logout,color: Colors.red,),
                            const SizedBox(width: 7,),
                            Text('${getLang(context, 'log_out')}',style: TextStyle(color: Colors.red),),
                          ],
                        ),






                      ),
                    ),
                  ),
                ]
            ),
          ),
        ),
        bottomNavigationBar:requestAdmin?null: CurvedNavigationBar(
          backgroundColor: ColorManager.white,
          color:  ColorManager.primary,
          index: cubit.index,
          items:CacheHelper.getData(key:'admin')?(superAdmin !=null?cubit.listIconSuper:cubit.listIconAdmin):cubit.listIconCustomer,
          //     <Widget>[
      //           CircleAvatar(backgroundImage: AssetImage('assets/image/order.png'),radius: 22,),
      //            Icon(IconBroken.Home, size: 35,color: ColorManager.white,),
      //           Stack(
      //
      //   alignment: AlignmentDirectional.topStart,
      //   children: [
      //     if(cubit.listCartModel.length>0) CircleAvatar(
      //       radius: 10,
      //       backgroundColor: ColorManager.white,
      //       child: Text('${cubit.listCartModel.length}'),
      //     ),
      //     Icon( IconBroken.Buy, size: 35,color: ColorManager.white,),
      //
      //   ],
      // ),
      //
      //     ],
  animationDuration: Duration(milliseconds: 300),
  onTap: (index) {
      cubit.changeBottomNav(index: index);
  },
  height: 50,
),
        appBar: AppBar(
          title: CacheHelper.getData(key:'admin')?(superAdmin !=null?Text('${cubit.listTitleSuper[cubit.index]}'):Text('${cubit.listTitleAdmin[cubit.index]}')):Text('${cubit.listTitleCustomer[cubit.index]}'),


          bottom: cubit.index==0?TabBar(

            indicatorColor: ColorManager.lightGrey,
              tabs:const [
                Tab(icon: Icon(Icons.watch_later_outlined),),
                Tab(icon: Icon(IconBroken.Shield_Done),),
                Tab(icon: Icon(IconBroken.Shield_Fail),),
                ]):null,
        ),
         body: CacheHelper.getData(key:'admin')?(superAdmin !=null?cubit.listWidgetSuper[cubit.index] :cubit.listWidgetAdmin[cubit.index]):cubit.listWidgetCustomer[cubit.index],
      ),
    );
    },

    );
  }

}