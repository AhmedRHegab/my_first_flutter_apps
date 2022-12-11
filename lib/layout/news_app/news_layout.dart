import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:untitled/layout/news_app/cubit/cubit.dart';
import 'package:untitled/layout/news_app/cubit/states.dart';
import 'package:untitled/shared/components/components.dart';
import 'package:untitled/shared/cubit_todo/cubit.dart';

import '../../modules/news_app/search/search_screen.dart';
//NewsCubit()..getBusiness()..getSports()..getScience()
class NewsLayout extends StatelessWidget
{
  const NewsLayout({super.key});

  @override
  Widget build(BuildContext context)
  {
    return BlocConsumer<NewsCubit, NewsStates>(
      listener: (context, state){},
      builder: (context, state)
      {
        var cubit = NewsCubit.get(context);

        return Scaffold(
          appBar: AppBar(
            title: const Text(
              'News App',
            ),
            actions: [
              IconButton(
                icon: const Icon(
                  Icons.search,
                ),
                  onPressed: ()
                  {
                    navigateTo(context, SearchScreen(),);
                  },
              ),
              IconButton(
                icon:  const Icon(
                  Icons.brightness_4_outlined,
                ),
                  onPressed: ()
                  {
                    AppCubit.get(context).changeAppMode();
                    NewsCubit.get(context).getBusiness();
                    NewsCubit.get(context).getSports();
                    NewsCubit.get(context).getScience();

                  },
              ),
            ],

          ),

          body: cubit.screens[cubit.currentIndex],
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: cubit.currentIndex,
            onTap: (index)
            {
              cubit.changeBottomNavBar(index);

            },
            items: cubit.bottomItems,
          ),
        );
      },
    );
  }
}
