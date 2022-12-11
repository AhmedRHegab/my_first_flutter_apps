import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:untitled/layout/social_app/cubit/cubit.dart';
import 'package:untitled/layout/social_app/social_layout.dart';
import 'package:untitled/shared/bloc_observer.dart';
import 'package:untitled/shared/components/components.dart';
import 'package:untitled/shared/components/constants.dart';
import 'package:untitled/shared/cubit_todo/cubit.dart';
import 'package:untitled/shared/cubit_todo/states.dart';
import 'package:untitled/shared/network/local/cache_helper.dart';
import 'package:untitled/shared/network/remote/dio_helper.dart';
import 'package:untitled/shared/styles/themes.dart';
import 'layout/news_app/cubit/cubit.dart';
import 'layout/shop_app/cubit/cubit.dart';
import 'modules/native_code.dart';
import 'modules/social_app/social_login/social_login_screen.dart';

Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async
{
  print('on background message');
  print(message.data.toString());
  showToast(text: 'on background message', state: ToastStates.SUCCESS);
}

void main() async
{
  WidgetsFlutterBinding.ensureInitialized();

  // if(Platform.isWindows) {
  //   await DesktopWindow.setMinWindowSize(
  //     const Size(
  //       650.0,
  //       650.0,
  //     ),
  //   );
  // }
  await Firebase.initializeApp();

  var token = await FirebaseMessaging.instance.getToken();
  print(token);

  // foreground fcm
  FirebaseMessaging.onMessage.listen((event)
  {
    print('on message');
    print(event.data.toString());
    showToast(text: 'on message', state: ToastStates.SUCCESS);

  });

  // when click on notification to open app
  FirebaseMessaging.onMessageOpenedApp.listen((event)
  {
    print('on message opened app');
    print(event.data.toString());
    showToast(text: 'on message opened app', state: ToastStates.SUCCESS);

  });

  // background fcm
  FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);


  Bloc.observer = MyBlocObserver();
  DioHelper.init();
  await CacheHelper.init();

  bool isDark = CacheHelper.getData(key: 'isDark');

  Widget widget;

 //bool? onBoarding = CacheHelper.getData(key: 'onBoarding');
  token = CacheHelper.getData(key: 'token');
  uId = CacheHelper.getData(key: 'uId');

  print(token);

  // if(onBoarding != null)
  //   {
  //     if(token != null)
  //       {
  //         widget = const ShopLayout();
  //       }else
  //       {
  //         widget = ShopLoginScreen();
  //       }
  //   }else
  //   {
  //     widget = const OnBoardingScreen();
  //   }

  if(uId != null)
    {
      widget =  SocialLayout();
    }else
      {
        widget = SocialLoginScreen();
      }



  runApp( MyApp(
      isDark: isDark,
      startWidget: widget,
  ));
}

class MyApp extends StatelessWidget
{
   final bool isDark;
   final Widget startWidget;

   const MyApp({super.key,
     required this.isDark,
     required this.startWidget,
});

  @override
  Widget build(BuildContext context)
  {
  return  MultiBlocProvider(
    providers:
    [
      BlocProvider(create: (BuildContext context) => SocialCubit()..getUserData()..getPosts()..getComments()),
      BlocProvider(create:(BuildContext context) => ShopCubit()..getHomeData()..getCategories()..getFavourites()..getUserData(),),
      BlocProvider(create: (context) => NewsCubit()..getBusiness()..getSports()..getScience(),),
      BlocProvider(create:(BuildContext context) => AppCubit()..changeAppMode(fromShared: isDark,),
      ),
    ],
    child: BlocConsumer<AppCubit, AppStates>(
      listener: (context, state){},
      builder: (context, state) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: lightTheme,
          darkTheme: darkTheme,
          themeMode: AppCubit.get(context).isDark ? ThemeMode.dark : ThemeMode.light,
          home:  NativeCodeScreen(),
        );
      }
    ),
  );
  }
}
