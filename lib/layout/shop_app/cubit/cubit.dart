import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:untitled/layout/shop_app/cubit/states.dart';
import 'package:untitled/models/shop_app/categories_model.dart';
import 'package:untitled/models/shop_app/favourites_model.dart';
import 'package:untitled/models/shop_app/home_model.dart';
import 'package:untitled/models/shop_app/login_model.dart';
import 'package:untitled/modules/shop_app/categories/categories_screen.dart';
import 'package:untitled/modules/shop_app/favorites/favourites_screen.dart';
import 'package:untitled/modules/shop_app/products/products_screen.dart';
import 'package:untitled/modules/shop_app/settings/settings_screen.dart';
import 'package:untitled/shared/network/end_points.dart';
import 'package:untitled/shared/network/remote/dio_helper.dart';

import '../../../models/shop_app/change_favourites_model.dart';
import '../../../shared/components/constants.dart';

class ShopCubit extends Cubit<ShopStates>
{
  ShopCubit() : super(ShopInitialState());

  static ShopCubit get(context) => BlocProvider.of(context);

  int currentIndex = 0;

  List<Widget> bottomScreens = [
    const ProductsScreen(),
    const CategoriesScreen(),
    const FavouritesScreen(),
    SettingsScreen(),
  ];

  void changeBottom(int index)
  {
    currentIndex = index;
    emit(ShopChangeBottomNavState());
  }


  late HomeModel homeModel;

  Map<int, bool> favourites = {};


  void getHomeData() {
    emit(ShopLoadingHomeDataState());

    DioHelper.getData(
        url: HOME,
      token: token,
    ).then((value)
    {
      homeModel = HomeModel.fromJson(value!.data);

      // print(homeModel?.data?.banners[0].image);
      // print(homeModel?.status);

      homeModel.data?.products.forEach((element)
      {
        favourites.addAll({
          element.id!: element.inFavorites!,
        });
      });

      //print(favourites.toString());

      emit(ShopSuccessHomeDataState());
    }).catchError((error){

      print(error.toString());
      emit(ShopErrorHomeDataState());
    });

  }

  late CategoriesModel categoriesModel;


  void getCategories() {

    DioHelper.getData(
      url: GET_CATEGORIES,
      token: token,
    ).then((value)
    {
      categoriesModel = CategoriesModel.fromJson(value!.data);


      emit(ShopSuccessCategoriesState());
    }).catchError((error){

      print(error.toString());
      emit(ShopErrorCategoriesState());
    });

  }


  ChangeFavouritesModel? changeFavouritesModel;

  void changeFavourites(int productId)
  {
    favourites[productId] = !favourites[productId]!;

    emit(ShopChangeFavouritesState());

    DioHelper.postData(
        url: FAVOURITES,
        token: token,
        data: {
          'product_id': productId,
        },
    ).then((value)
    {

      changeFavouritesModel = ChangeFavouritesModel.fromJson(value!.data);
      //print(value.data);

      if((changeFavouritesModel?.status != null) && (changeFavouritesModel?.status == false))
        {
          favourites[productId] = !favourites[productId]!;
        }else
        {
          getFavourites();
        }

      emit(ShopSuccessChangeFavouritesState(changeFavouritesModel!));

    }).catchError((error)
    {
      favourites[productId] = !favourites[productId]!;
      emit((ShopErrorChangeFavouritesState()));
    });
  }

  FavouritesModel? favouritesModel;


  void getFavourites()
  {
    emit(ShopLoadingGetFavouritesState());

    DioHelper.getData(
      url: FAVOURITES,
      token: token,
    ).then((value)
    {
      favouritesModel = FavouritesModel.fromJson(value!.data);


      emit(ShopSuccessGetFavouritesState());
    }).catchError((error){

      print(error.toString());
      emit(ShopErrorGetFavouritesState());
    });

  }

  ShopLoginModel? userModel;


  void getUserData()
  {
    emit(ShopLoadingUserDataState());

    DioHelper.getData(
      url: PROFILE,
      token: token,
    ).then((value)
    {
      userModel = ShopLoginModel.fromJson(value!.data);
      //print(userModel?.data?.name);


      emit(ShopSuccessUserDataState(userModel!));
    }).catchError((error){

      print(error.toString());
      emit(ShopErrorUserDataState());
    });

  }

  void updateUserData({
  required String name,
  required String email,
  required String phone,
})
  {
    emit(ShopLoadingUpdateUserState());

    DioHelper.putData(
      url: UPDATE_PROFILE,
      token: token,
      data: {
        'name':name,
        'email':email,
        'phone':phone,
      },
    ).then((value)
    {
      userModel = ShopLoginModel.fromJson(value!.data);
      //print(userModel?.data?.name);


      emit(ShopSuccessUpdateUserState(userModel!));
    }).catchError((error){

      print(error.toString());
      emit(ShopErrorUpdateUserState());
    });

  }

}