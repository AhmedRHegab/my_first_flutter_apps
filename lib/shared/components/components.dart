
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:untitled/shared/cubit_todo/cubit.dart';
import 'package:untitled/shared/styles/icon_broken.dart';

import '../../layout/shop_app/cubit/cubit.dart';
import '../../modules/news_app/web_view/web_view_screen.dart';
import '../styles/colors.dart';


Widget defaultButton({
  double width = double.infinity,
  Color background = Colors.blue,
  bool isUpperCase = true,
  required Function function,
  required String text,
}) =>
Container(
  width: width,
  height: 40.0,
  decoration: BoxDecoration(
    borderRadius: BorderRadius.circular(
      5.0,
    ),
    color: background,
  ),
  child: MaterialButton(
    onPressed: (){
      function();
    },
    child: Text(
      isUpperCase ? text.toUpperCase() : text,
      style: const TextStyle(
        color: Colors.white,
      ),
    ),
  ),

);


Widget defaultTextButton({
  required Function function,
  required String text,
  bool isBold = false,
}) => TextButton(
  onPressed: (){
    function();
  },
  child: Text(text.toUpperCase(),
    style: TextStyle(
      fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
    ),
  ),
);

Widget defaultFormField({
  required TextEditingController controller,
  required TextInputType type,
  dynamic onSubmit,
  dynamic onTap,
  dynamic onChange,
  bool isClickable = true,
  bool isPassword = false,
  required dynamic validate,
  required String label,
  required IconData prefix,
  IconData? suffix,
  dynamic suffixPressed,
}) => TextFormField(
controller: controller,
keyboardType: type,
  obscureText: isPassword,
onFieldSubmitted: onSubmit,
onChanged: onChange,
onTap: onTap,
enabled: isClickable,
validator: validate,
decoration: InputDecoration(
labelText: label,
prefixIcon:  Icon(
  prefix,
),
suffixIcon:   IconButton(
  onPressed: suffixPressed,
  icon:   Icon(
    suffix,
  ),
),
border: const OutlineInputBorder(),
),
);

Widget buildTaskItem(Map model, context) =>
    Dismissible(
      key: Key(model['id'].toString()),
      child: Padding(
padding: const EdgeInsets.all(20.0),
child: Row(
children: [
CircleAvatar(
radius: 40.0,
child: Text(
'${model['time']}',
),
),
SizedBox(
width: 20.0,
),
Expanded(
  child:   Column(

      crossAxisAlignment: CrossAxisAlignment.start,

  mainAxisSize: MainAxisSize.min,

  children: [

  Text(

  '${model['title']}',

  style: TextStyle(

  fontSize: 18.0,

  fontWeight: FontWeight.bold,

  ),

  ),

  Text(

  '${model['date']}',

  style: TextStyle(

  color: Colors.grey,

  ),

  ),

  ],

  ),
),
  SizedBox(
      width: 20.0,
  ),
  IconButton(
      onPressed: ()
      {
        AppCubit.get(context).updateData(
          status: 'done',
          id: model['id'],
        );
      },
      icon: const Icon(
        Icons.check_box,
        color: Colors.green,
      ),
  ),
  IconButton(
      onPressed: ()
      {
        AppCubit.get(context).updateData(
          status: 'archive',
          id: model['id'],
        );
      },
      icon: const Icon(
        Icons.archive,
        color: Colors.black45,
      ),
  ),
],
),
),
      onDismissed: (direction)
      {
        AppCubit.get(context).deleteData(id: model['id'],);
      },
    );

Widget myDivider() => Padding(
  padding: const EdgeInsetsDirectional.only(
    start: 20.0,
  ),
  child: Container(
    width: double.infinity,
    height: 1.0,
    color: Colors.grey[300],
  ),
);

Widget buildArticleItem(article, context) => InkWell(
  onTap: ()
  {
    navigateTo(context, WebViewScreen(article['url']),);
  },

  child:   Padding(

    padding: const EdgeInsets.all(20.0),

    child: Row(

      children: [

        Container(

          width: 120.0,

          height: 120.0,

          decoration: BoxDecoration(

            borderRadius: BorderRadius.circular(10.0,),

            image:  DecorationImage(

              image: NetworkImage('${article['urlToImage']}'),

              fit: BoxFit.cover,

            ),

          ),

        ),

        const SizedBox(

          width: 20.0,

        ),

        Expanded(

          child: Container(

            height: 120,

            child: Column(

              crossAxisAlignment: CrossAxisAlignment.start,

              mainAxisAlignment: MainAxisAlignment.start,

              children:

              [

                Expanded(

                  child: Text(

                    '${article['title']}',

                    style: Theme.of(context).textTheme.bodyText1,

                    maxLines: 3,

                    overflow: TextOverflow.ellipsis,

                  ),

                ),

                Text(

                  '${article['publishedAt']}',

                  style: const TextStyle(

                    color: Colors.grey,

                  ),

                ),

              ],

            ),

          ),

        ),

      ],

    ),

  ),
);

Widget articleBuilder(list, context) => ListView.separated(
  physics:   const BouncingScrollPhysics(),
  itemBuilder: (context, index) => buildArticleItem(list[index], context),
  separatorBuilder: (context, index) => myDivider(),
  itemCount: 10,
);

PreferredSizeWidget defaultAppBar({
  required BuildContext context,
  String? title,
  List<Widget>? actions,
}) => AppBar(
  leading: IconButton(
    onPressed: ()
    {
      Navigator.pop(context);
    },
    icon: const Icon(
      IconBroken.Arrow___Left_2,
    ),
  ),
  titleSpacing: 5.0,
  title: Text(
    title!,
  ),
  actions: actions,
);


void navigateTo(context, widget) => Navigator.push(context,
  MaterialPageRoute(
    builder: (context) => widget,
  ),
);

void navigateAndFinish(context, widget) => Navigator.pushAndRemoveUntil(context,
    MaterialPageRoute(
builder: (context) => widget,
),
    (Route<dynamic> route) => false,
);

void showToast({
  required String text,
  required ToastStates state,
}) =>  Fluttertoast.showToast(
    msg: text,
    toastLength: Toast.LENGTH_LONG,
    gravity: ToastGravity.BOTTOM,
    timeInSecForIosWeb: 5,
    backgroundColor: chooseToastColor(state),
    textColor: Colors.white,
    fontSize: 16.0
);

enum ToastStates {SUCCESS, ERROR, WARNING}

Color? chooseToastColor(ToastStates state)
{
  Color color;

  switch(state)
  {
    case ToastStates.SUCCESS:
      color = Colors.green;
      break;
    case ToastStates.ERROR:
      color = Colors.red;
      break;
    case ToastStates.WARNING:
      color = Colors.amber;
      break;
  }
  return color;
}

Widget buildListProduct(model, context, {bool isSearch = false,}) => Padding(
  padding: const EdgeInsets.all(20.0),
  child: Container(
    height: 120.0,
    child: Row(
      children: [
        Stack(
          alignment: AlignmentDirectional.bottomStart,
          children: [
            Image(
              image: NetworkImage((model.image)!),
              width: 120.0,
              height: 120.0,
            ),
            if((model.discount != null) && (model.discount != 0))
              Container(
                color: Colors.red,
                padding: const EdgeInsets.symmetric(horizontal: 5.0,),
                child: const Text(
                  'DISCOUNT',
                  style: TextStyle(
                    fontSize: 8.0,
                    color: Colors.white,
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(
          width: 20.0,
        ),
        Expanded(
          child: Column(

            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                (model.name)!,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 12.0,
                  fontWeight: FontWeight.bold,
                ),

              ),
              const Spacer(),
              Row(
                children: [
                  Text(
                    (model.price)!.toString(),
                    style: const TextStyle(
                      fontSize: 12.0,
                      fontWeight: FontWeight.bold,
                      color: defaultColor,
                    ),

                  ),
                  const SizedBox(
                    width: 5.0,
                  ),
                  if((model.discount != null) && (model.discount != 0))
                    Text(
                      (model.oldPrice)!.toString(),
                      style: const TextStyle(
                        fontSize: 10.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey,
                        decoration: TextDecoration.lineThrough,
                      ),

                    ),
                  const Spacer(),
                  IconButton(
                    onPressed: ()
                    {
                      ShopCubit.get(context).changeFavourites((model.id)!);

                    },
                    icon: const CircleAvatar(
                      radius: 15.0,
                      backgroundColor: defaultColor,
                      child: Icon(
                        Icons.favorite_border,
                        size: 14.0,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    ),
  ),
);