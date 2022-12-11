import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:untitled/modules/counter/cubit/states.dart';

import 'cubit/cubit.dart';

class CounterScreen extends StatelessWidget
{
  const CounterScreen({super.key});


  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => CounterCubit(),
      child: BlocConsumer<CounterCubit, CounterStates>(
        listener: (BuildContext context, CounterStates state) {
          if(state is CounterMinusState)
            {
              //print('minus state ${state.counter}');
            }
          if(state is CounterPlusState)
            {
              //print('plus state ${state.counter}');
            }
        },
        builder: (BuildContext context, CounterStates state)
        {
          return Scaffold(
            appBar: AppBar(
              title: const Text(
                'Counter',
              ),
            ),
            body: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextButton(onPressed: ()
                  {
                    CounterCubit.get(context).minus();
                  },
                    child: const Text(
                      'MINUS',
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 20.0,
                    ),
                    child: Text(
                      '${CounterCubit.get(context).counter}',
                      style: const TextStyle(
                          fontSize: 50.0,
                          fontWeight: FontWeight.w900
                      ),
                    ),
                  ),
                  TextButton(onPressed: ()
                  {
                    CounterCubit.get(context).plus();
                  },
                    child: const Text(
                      'PLUS',
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),

    );

  }

}

