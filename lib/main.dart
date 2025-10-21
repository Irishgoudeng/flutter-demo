import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'features/goals/data/repositories/goal_repository.dart';
import 'features/goals/logic/goal_cubit.dart';
import 'features/goals/presentation/screens/goal_list_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Provide the repository and the cubit to the entire app
    return RepositoryProvider(
      create: (context) => GoalRepository(),
      child: BlocProvider(
        create: (context) => GoalCubit(
          RepositoryProvider.of<GoalRepository>(context),
        )..loadGoals(), // Initial data load
        child: MaterialApp(
          title: 'Goal Tracker',
          theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
            useMaterial3: true,
          ),
          home: const GoalListScreen(),
        ),
      ),
    );
  }
}