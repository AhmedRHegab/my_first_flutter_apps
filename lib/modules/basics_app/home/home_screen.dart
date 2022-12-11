import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal,
        leading: const Icon(
          Icons.menu,
        ),
        title: const Text(
          'First App',
        ),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.notification_important,
            ),
            onPressed: onNotification,
          ),
          IconButton(onPressed: () {
            print('Hello');
          },
            icon: const Icon(
              Icons.search,
            ),)

        ],
      ),
      body: Column(
        children: [

             Padding(
               padding: const EdgeInsets.all(50.0),
               child: Container(
                 decoration: const BoxDecoration(
                   borderRadius: BorderRadiusDirectional.only(
                     topStart: Radius.circular(
                       double.infinity
                     ),
                   ),
                 ),
                 clipBehavior: Clip.antiAliasWithSaveLayer,
                 child: Stack(
                   alignment: Alignment.bottomCenter,
                  children: [
                    const Image(
                        image: NetworkImage(
                          'https://images.unsplash.com/photo-1562690868-60bbe7293e94?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHx8&auto=format&fit=crop&w=418&q=80'
                        ),
                      height:200.0,
                      width: 200.0,
                      fit: BoxFit.cover,
                    ),
                    Container(
                      width: 200.0,
                      color: Colors.black.withOpacity(0.7),
                      padding: const EdgeInsets.symmetric(
                        vertical: 10.0,
                      ),
                      child: const Text(
                        'Flower',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 20.0,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ],
            ),
               ),
             ),
        ],
      ),
    );
  }

// when notification icon button clicked
  void onNotification() {
    print('notification clicked');
  }
}
