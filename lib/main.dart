import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:projectgraduate/moduls/layout_screen/layout_cubit/cubit_layout.dart';
import 'package:projectgraduate/shared/constant/data_shared.dart';

import 'bloc_observer.dart';
import 'moduls/layout_screen/layout_screan.dart';
import 'moduls/login/login_screen.dart';
import 'shared/componant/componant.dart';
import 'shared/constant/theme_manager.dart';
import 'shared/language/applocale.dart';
import 'shared/network/local/cache_helper.dart';

void main()async {
  WidgetsFlutterBinding.ensureInitialized();
  await CacheHelper.init();

  if(CacheHelper.getData(key: 'uId')!=null){
    uId=CacheHelper.getData(key: 'uId');
  }
  await Firebase.initializeApp(
    // options:  FirebaseOptions(
    //   apiKey: 'AIzaSyAsNOLf5LmI1qFybvPaHFT7LEFFdPnbYMk',
    //   appId: "1:766788020496:android:4e946006d46fab771e9d95",
    //   messagingSenderId: '766788020496',
    //   projectId: 'projectgraduate-ba744',
    // ),
    );

  BlocOverrides.runZoned(
        () {
      runApp(
        MyApp(),);
    },
    blocObserver: MyBlocObserver(),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<CubitLayout>(create: (context)=>CubitLayout()..getProducts()..changeBottomNav(index: 1)..getCategory()..getUserData()..getToCart()..getAllOrder()),
      ],
      child: MaterialApp(

        debugShowCheckedModeBanner: false,
        theme:getApplicationTheme(context),
        supportedLocales:const [
          Locale('en',),
          Locale('ar'),
        ],
        locale: const Locale("en") ,

        localizationsDelegates: const[
          AppLocale.delegate,
            GlobalMaterialLocalizations.delegate,
           GlobalWidgetsLocalizations.delegate,
           GlobalCupertinoLocalizations.delegate,

        ],
        localeResolutionCallback: (currentLang,supportedLang){
          if(currentLang!=null){
            for(Locale local in supportedLang){
              if(local.languageCode==currentLang.languageCode){
                return currentLang;
              }
            }

          }
          return supportedLang.first;
        },
        home: launcherScreen(iscurrentuser: FirebaseAuth.instance.currentUser!=null,loginScreen: LoginScreen(), homeScreen: LayoutScreen()),
      ),
    );
  }
}


