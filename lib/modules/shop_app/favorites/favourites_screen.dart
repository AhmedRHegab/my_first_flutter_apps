import 'package:conditional_builder_null_safety/conditional_builder_null_safety.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../layout/shop_app/cubit/cubit.dart';
import '../../../layout/shop_app/cubit/states.dart';
import '../../../shared/components/components.dart';

class FavouritesScreen extends StatelessWidget {
  const FavouritesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context)
  {
    return BlocConsumer<ShopCubit, ShopStates>(
      listener: (context, state){},
      builder: (context, state){
        return ConditionalBuilder(
          condition: state is! ShopLoadingGetFavouritesState,
          builder: (context) => ListView.separated(
            itemBuilder: (context, index) => buildListProduct((ShopCubit.get(context).favouritesModel?.data?.data![index].product)!, context),
            separatorBuilder: (context, index) => myDivider(),
            itemCount: (ShopCubit.get(context).favouritesModel?.data?.data?.length)!,
          ),
          fallback: (context) => const Center(child: CircularProgressIndicator()),
        );
      },
    );
  }



}

//(ShopCubit.get(context).favourites[model.product!.id]!)