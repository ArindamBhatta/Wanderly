// ignore_for_file: avoid_print

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:wanderly/home/module/bloc/events.dart';
import 'package:wanderly/home/module/bloc/logic.dart';
import 'package:wanderly/home/module/bloc/state.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    context.read<WanderlyLogic>().add(InitialLoadRequested());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<WanderlyLogic, WanderlyState>(
        builder: (context, state) {
          if (state is DataLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (state is FetchDataSuccessful) {
            return Center(
              child: Text(
                '${state.data}',
              ),
            );
          } else if (state is FetchCachedData) {
            return Center(
              child: Column(
                children: [
                  Text('Showing Caching Data'),
                  Text(
                    '${state.cachedData}',
                  ),
                ],
              ),
            );
          } else if (state is FetchDataError) {
            return Center(
              child: Text(
                state.message,
              ),
            );
          }
          return const Center(
            child: Text('No Data Available'),
          );
        },
      ),
    );
  }
}
