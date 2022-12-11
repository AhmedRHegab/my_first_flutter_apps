import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:untitled/layout/news_app/cubit/states.dart';

import '../../../modules/news_app/news_app_business/business_screen.dart';
import '../../../modules/news_app/news_app_science/science_screen.dart';
import '../../../modules/news_app/news_app_sports/sports_screen.dart';
import '../../../shared/network/remote/dio_helper.dart';

class NewsCubit extends Cubit<NewsStates>
{
  NewsCubit() : super(NewsInitialState());

  static NewsCubit get(context) => BlocProvider.of(context);

  int currentIndex = 0;

  List<BottomNavigationBarItem> bottomItems = [
    const BottomNavigationBarItem(
      icon: Icon(
        Icons.business,
      ),
      label: 'Business',

    ),
    const BottomNavigationBarItem(
      icon: Icon(
        Icons.sports,
      ),
      label: 'Sports',
    ),
    const BottomNavigationBarItem(
      icon: Icon(
        Icons.science,
      ),
      label: 'Science',
    ),
  ];

  List<Widget> screens = [
    const BusinessScreen(),
    const SportsScreen(),
    const ScienceScreen(),
  ];

  void changeBottomNavBar(int index)
  {
    currentIndex = index;
    if(index == 1)
    {
      getSports();
    }
    if(index == 2)
    {
      getScience();
    }
    emit(NewsBottomNavState());
  }

  List<dynamic> business = [];

  void getBusiness()
  {
    emit(NewsGetBusinessLoadingState());

    DioHelper.getData(
      url: 'v2/top-headlines',
      query: {
        'country':'us',
        'category':'business',
        'apiKey':'fc97a7fffa37443ebc63a7c9167a1523',

      },
    ).then((value) {
      //print(value?.data['articles'][0]['title']);
      business = value?.data['articles'];
      print(business[1]['title']);

      emit(NewsGetBusinessSuccessState());
    }).catchError((error){
      print(error.toString());

      emit(NewsGetBusinessErrorState(error.toString()));
    });
  }

  List<dynamic> sports = [];

  void getSports()
  {
    emit(NewsGetSportsLoadingState());

    if(sports.isEmpty)
      {
        DioHelper.getData(
          url: 'v2/top-headlines',
          query: {
            'country':'us',
            'category':'sports',
            'apiKey':'fc97a7fffa37443ebc63a7c9167a1523',

          },
        ).then((value) {
          //print(value?.data['articles'][0]['title']);
          sports = value?.data['articles'];
          print(sports[1]['title']);

          emit(NewsGetSportsSuccessState());
        }).catchError((error){
          print(error.toString());

          emit(NewsGetSportsErrorState(error.toString()));
        });
      }else
        {
          emit(NewsGetSportsSuccessState());
        }


  }

  List<dynamic> science = [];

  void getScience()
  {
    emit(NewsGetScienceLoadingState());

    if(science.isEmpty)
      {

        DioHelper.getData(
          url: 'v2/top-headlines',
          query: {
            'country':'us',
            'category':'science',
            'apiKey':'fc97a7fffa37443ebc63a7c9167a1523',

          },
        ).then((value) {
          //print(value?.data['articles'][0]['title']);
          science = value?.data['articles'];
          print(science[1]['title']);

          emit(NewsGetScienceSuccessState());
        }).catchError((error){
          print(error.toString());

          emit(NewsGetScienceErrorState(error.toString()));
        });
      } else
        {
          emit(NewsGetScienceSuccessState());
        }

  }

  List<dynamic> search = [];

  void getSearch(String value)
  {

    emit(NewsGetSearchLoadingState());

    DioHelper.getData(
      url: 'v2/everything',
      query: {
        'q':value,
        'apiKey':'fc97a7fffa37443ebc63a7c9167a1523',

      },
    ).then((value) {
      search = value?.data['articles'];
      print(search[1]['title']);

      emit(NewsGetSearchSuccessState());
    }).catchError((error){
      print(error.toString());

      emit(NewsGetSearchErrorState(error.toString()));
    });

  }

}