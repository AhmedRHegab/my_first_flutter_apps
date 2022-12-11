


//https://newsapi.org/v2/everything?q=tesla&apiKey=fc97a7fffa37443ebc63a7c9167a1523





import '../../modules/shop_app/login/shop_login_screen.dart';
import '../network/local/cache_helper.dart';
import 'components.dart';

void signOut(context)
{
  CacheHelper.removeData(key: 'token',).then((value)
  {
    if(value!)
    {
      navigateAndFinish(context, ShopLoginScreen());
    }
  });
}

void printFullText(String text)
{
  final pattern = RegExp('.{1,800}'); // 800 is the size of each chunk
  pattern.allMatches(text).forEach((match) => print(match.group((0))));
}


dynamic token = '';

dynamic uId = '';